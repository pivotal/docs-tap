# Use Gitops Delivery with FluxCD (alpha)

This topic outlines the delivery of packages created by the Out of the Box Supply Chain
with `carvel-package-workflow-enabled` and added to a GitOps repository to one or more run clusters.

## Prerequisites

To use Gitops Delivery with FluxCD, complete the following prerequisites:

 - The Build cluster is created and has network access to your run clusters. It must have FluxCD Kustomize Controller installed. See the [Flux documentation](https://fluxcd.io/flux/installation/#dev-install).
 - Run clusters serve as your deploy environments. They can either be Tanzu Application Platform clusters, or regular Kubernetes clusters, but they must have kapp-controller installed. See the [Carvel documentation](https://carvel.dev/kapp-controller/).
 - To target run clusters from the Build cluster, you must create a secret containing each run cluster Kubeconfig. The FluxCD Kustomization resource uses these secrets.

    For each run cluster, run:

    ```console
    kubectl create secret generic <run-cluster>-kubeconfig \
        -n <build_cluster_namespace> \
        --from-file=value.yaml=<path_to_kubeconfig>
    ```

## Create the PackageInstall

After the `source-to-url-packag` or `basic-image-to-url-package` [supply chains](./ootb-supply-chain-reference.hbs.md) create a Package YAML file in the GitOps repository,
you must add the packageInstall YAML file in the GitOps repository.

To use PackageInstall: 

1. Create a secret that has the values for the Package parameter. You can see the configurable properties of a package by inspecting the Package CR’s valuesSchema.

  ```yaml
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: hello-app-values
  stringData:
    values.yaml: |
      ---
      replicas: 2
      hostname: hello-app.mycompany.com
  ```

1. Add the secret to the GitOps repository that Flux deploys. See instructions in the [Flux documentation](https://fluxcd.io/flux/security/secrets-management/).

1. Reference the secret created earlier in the same namespace targeted by the PackageInstall.

  ```yaml
  ---
  apiVersion: packaging.carvel.dev/v1alpha1
  kind: PackageInstall
  metadata:
    name: hello-app
  spec:
    serviceAccountName: default-ns-sa
    packageRef:
      refName: hello-app.mycompany.com
      versionSelection:
        constraints: 1.0.0
    values:
    - secretRef:
        name: hello-app-values
  ```

  The Package references the package’s refName, version fields, and the
  versionSelection property which has a constraint's subproperty to give more
  control over which versions you install.

1. To manage App and PackageInstall custom resource (CR) privileges by using a service account, you need the following verbs to work with ConfigMaps:

  ```yaml
  kind: Role
  apiVersion: rbac.authorization.k8s.io/v1
  metadata:
    name: app-ip-cr-role
  rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list", "create", "update", "delete"]
  ```

  You need these permissions because of how kapp tracks information about apps
  it manages by storing information in a ConfigMap. If your App or
  PackageInstall CR does not create ConfigMaps, the service account needs
  permissions for working with ConfigMaps.

  You need the ConfigMap permissions, in addition to any other resource and verb
  combinations, to deploy all resources created by the App and PackageInstall
  CRs.

  For information about how service accounts are used, see [the Carvel documentation](https://carvel.dev/kapp-controller/docs/v0.43.2/security-model/).

1. Push the PackageInstall to the GitOps repository in the the same `$package-name`
folder, but use a new folder for each run cluster.

  ```console
  /$package-name
      /packages/$package-id.yaml          # Carvel Package definitions
      /$run-cluster/packageinstall.yaml  # A Carvel PackageInstall
      /$run-cluster/params.yaml          # Values secret for PackageInstall
      /...
  ```

## Create FluxCD GitRepository + FluxCD Kustomization

The [Build cluster](../multicluster/installing-multicluster.hbs.md#install-build-cluster) uses FluxCD to deploy `Packages` and `PackageInstalls` by creating a FluxCD `GitRepository`
to watch for changes to the GitOps repository.

For each run cluster, create:

- A FluxCD `Kustomization` on the Build cluster that applies `$package-name/packages/*` to the run cluster
- A FluxCD `Kustomization` on the Build cluster that applies `$package-name/$run-cluster/*` to the run cluster

### Create FluxCD GitRepository on Build Cluster

Create the following resources on the Cluster:

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: <package-name>-gitops-repo
  namespace: # Build cluster namespace
spec:
  url: # GitOps repo URL
  gitImplementation: go-git
  ignore: |
    !.git
  interval: 30s
  ref:
    branch: # GitOps repo branch
  timeout: 60s

  # only required if GitOps repo is private (recommended)
  secretRef:
    name: <package-name>-gitops-auth
    namespace: # Build cluster namespace

# only required if GitOps repo is private (recommended)
---
apiVersion: v1
kind: Secret
metadata:
  name: <package-name>-gitops-auth
  namespace: # Build cluster namespace
type: Opaque
data:
  username: # base64 encoded GitHub (or other git remote) username
  password: # base64 encoded GitHub (or other git remote) personal access token
```

### Create FluxCD Kustomizations on Build Cluster

For each run cluster, create the following resources:

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  # for the first run cluster, for example hello-app-prod1-packages
  name: <package-name>-<run-cluster>-packages
  namespace: # Build cluster namespace
spec:
  sourceRef:
    kind: GitRepository
    name: <package-name>-gitops-repo
    namespace: # Build cluster namespace
  path: "./<package-name>/packages"
  interval: 5m
  timeout: 5m
  prune: true
  wait: true

  # where to deploy
  kubeConfig:
    secretRef:
      name: <run-cluster>-kubeconfig
      namespace: # Build cluster namespace
  targetNamespace: # run cluster target namespace
  serviceAccountName: # run cluster target namespace service account

---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  # for the second run cluster, for example hello-app-prod2-packages
  name: <package-name>-<run-cluster>-packageinstalls
  namespace: # Build cluster namespace
spec:
  sourceRef:
    kind: GitRepository
    name: <package-name>-gitops-repo
    namespace: # Build cluster namespace
  path: "./<package-name>/<run-cluster>"
  interval: 5m
  timeout: 5m
  prune: true
  wait: true

  # where to deploy
  kubeConfig:
    secretRef:
      name: <run-cluster>-kubeconfig
      namespace: # Build cluster namespace
  targetNamespace: # run cluster target namespace
  serviceAccountName: # run cluster target namespace service account
```

## Verifying Installation

To verify your installation:

1. On your Build cluster, confirm that your FluxCD GitRepository and Kustomizations are reconciling:

  ```console
  kubectl get gitrepositories,kustomizations -A
  ```

1. Target a run cluster. Confirm that all Packages from the GitOps repository are deployed:

  ```console
  kubectl get packages -A
  ```

1. Confirm that all PackageInstalls are reconciled:

  ```console
  kubectl get packageinstalls -A
  ```

  Now you can access your application on each run cluster.
