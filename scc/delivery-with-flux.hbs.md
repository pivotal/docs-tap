# Gitops with Flux

## Prerequisites

 - The Brain cluster is created and has network access to your run clusters. It must have the following components [installed](https://fluxcd.io/flux/installation/#dev-install) along with other TAP components:
   - FluxCD Source Controller
   - FluxCD Kustomize Controller

## Deploy Packages and PackageInstalls

After the supply chain created a Package yaml file in the gitops repo, you need to the add the packageInstall yaml file in the gitops repo as well:

### Create a PackageInstall

Create a PackageInstall CR (and a secret to hold the values used by the Package params)

The PackageInstall should refereces an already existing secret in the same namespace as the PackageInstall. The secret that has the values for the Package param. The configurable properties of a package can be seen by inspecting the Package CR’s valuesSchema.

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: pkg-demo-values
stringData:
  values.yml: |
    ---
    hello_msg: "to all my internet friends"
```
For adding the secret to the gitops repo to be deployed by flux, follow the instructions from flux [here](https://fluxcd.io/flux/security/secrets-management/)

Now, the PackageInstall:

```yaml
---
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageInstall
metadata:
  name: pkg-demo
spec:
  serviceAccountName: default-ns-sa
  packageRef:
    refName: simple-app.corp.com
    versionSelection:
      constraints: 1.0.0
  values:
  - secretRef:
      name: pkg-demo-values
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

## FluxCD GitRepository + FluxCD Kustomization

The [Build cluster](../multicluster/installing-multicluster.hbs.md#install-build-cluster) will use FluxCD to deploy `Packages` and `PackageInstalls` by creating a FluxCD `GitRepository`
on to watch for changes to the GitOps repo.

Per environment, we will create:
- A FluxCD `Kustomization` on our Brain cluster that applies `$component/packages/*` to environment
- A FluxCD `Kustomization` on our Brain cluster that applies `$component/$environment/*` to environment

### Create FluxCD GitRepository on Brain Cluster

The following resources should be created on the Cluster:

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: <component>-gitops-repo
  namespace: # brain cluster namespace
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
    name: <component>-gitops-auth
    namespace: # brain cluster namespace

# only required if GitOps repo is private (recommended)
---
apiVersion: v1
kind: Secret
metadata:
  name: <component>-gitops-auth
  namespace: # brain cluster namespace
type: Opaque
data:
  username: # base64 encoded GitHub (or other git remote) username
  password: # base64 encoded GitHub (or other git remote) password/personal access token
```

### Create FluxCD Kustomizations on Brain Cluster

For each environment, create the following resources:

```yaml
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: <component>-<environment>-packages
  namespace: # brain cluster namespace
spec:
  sourceRef:
    kind: GitRepository
    name: <component>-gitops-repo
    namespace: # brain cluster namespace
  path: "./<component>/packages"
  interval: 5m
  timeout: 5m
  prune: true
  wait: true

  # where to deploy
  kubeConfig:
    secretRef:
      name: <environment>-kubeconfig
      namespace: # brain cluster namespace
  targetNamespace: # run cluster target namespace
  serviceAccountName: # run cluster target namespace service account

---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: <component>-<environment>-packageinstalls
  namespace: # brain cluster namespace
spec:
  sourceRef:
    kind: GitRepository
    name: <component>-gitops-repo
    namespace: # brain cluster namespace
  path: "./<component>/<environment>"
  interval: 5m
  timeout: 5m
  prune: true
  wait: true

  # where to deploy
  kubeConfig:
    secretRef:
      name: <environment>-kubeconfig
      namespace: # brain cluster namespace
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
