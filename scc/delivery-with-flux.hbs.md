# Gitops Delivery with FluxCD

This guide outlines the delivery of packages created by the Out of the Box Supply Chain
with `carvel-package-workflow-enabled` and added to a GitOps repo to Run cluster(s).

## Prerequisites

 - The Build cluster is created and has network access to your run clusters. It must have the following components installed:
   - FluxCD [Kustomize Controller](https://fluxcd.io/flux/installation/#dev-install).

 - Run clusters serve as your deploy environments. They can either be TAP clusters, or regular Kubernetes clusters, but they need to have the following components installed:
   - [kapp-controller](https://carvel.dev/kapp-controller/)

 - In order to target Run clusters from the Build cluster, you will need to create a secret containing each Run cluster Kubeconfig. These secrets will be used by the FluxCD Kustomization resource.

    For each run cluster, run the following command:

    ```sh
    kubectl create secret generic <run-cluster>-kubeconfig \
        -n <build_cluster_namespace> \
        --from-file=value.yaml=<path_to_kubeconfig>
    ```

## Prepare the PackageInstall

After the `source-to-url-packag` or `basic-image-to-url-package` [supply chains](./ootb-supply-chain-reference.hbs.md) create a Package yaml file in the gitops repo,
you need to the add the packageInstall yaml file in the gitops repo as well:

### PackageInstall Prerequisites

First, create a secret that has the values for the Package param. The configurable properties of a package can be seen by inspecting the Package CR’s valuesSchema.

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: hello-app-values
stringData:
  values.yml: |
    ---
    replicas: 2
    hostname: hello-app.mycompany.com
```
For adding the secret to the gitops repo to be deployed by flux, follow the instructions from flux [here](https://fluxcd.io/flux/security/secrets-management/)


### Create PackageInstall

The PackageInstall references the secret created in the previous step in the same namespace targeted by the PackageInstall.

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

The Package references the package’s refName and version fields as well as the versionSelection property which has a constraints subproperty to give more control over which versions are chosen for installation.

For managing App and PackageInstall CR privileges via a service account, the verbs in the role below are needed for working with ConfigMaps.
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

These permissions are needed because of how kapp tracks information about apps it manages, which is via storing information in a ConfigMap. So even if your App or PackageInstall CR does not create ConfigMaps, the service account will still need permissions for working with ConfigMaps.

The ConfigMap permissions above are needed in addition to any other resource/verb combinations needed to deploy all resources created by the App and PackageInstall CRs.

[Security model](https://carvel.dev/kapp-controller/docs/v0.43.2/security-model/) for explanation of how service accounts are used.

### Push PackageInstall
Push the PackageInstall to the GitOps repo under the the same `$package-name`
folder, but under a new folder for each run cluster

```
/$package-name
    /packages/$package-id.yaml	        # Carvel Package definitions
    /$run-cluster/packageinstall.yaml	# A Carvel PackageInstall
    /$run-cluster/params.yaml	        # Values secret for PackageInstall
    /...
```

## Create FluxCD GitRepository + FluxCD Kustomization

The [Build cluster](../multicluster/installing-multicluster.hbs.md#install-build-cluster) will use FluxCD to deploy `Packages` and `PackageInstalls` by creating a FluxCD `GitRepository`
on to watch for changes to the GitOps repo.

Per Run cluster, we will create:
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

On your Build cluster, confirm that your FluxCD GitRepository and Kustomizations are all reconciling successfully:

```sh
kubectl get gitrepositories,kustomizations -A
```

Now target a Run cluster. Confirm that all Packages from the GitOps repo have been deployed:

```sh
kubectl get packages -A
```

Confirm that all PackageInstalls have reconciled successfully:

```sh
kubectl get packageinstalls -A
```
Now your application can be accessed on each run cluster.
