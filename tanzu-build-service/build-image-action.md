# GitHub Build Action for Tanzu Build Service (Alpha)

This GitHub Action creates a Tanzu Build Service (TBS) Build on the given cluster.

> **Important** Alpha features are experimental and are not ready for production use. Configuration and behavior are
> likely to change and functionality may be removed in a future release.

## Overview

### Prerequisites
- [Tanzu Application Platform](../install-intro.hbs.md)


### Setup
#### Create developer namespace
Create a namespace where the Build resource will be created.
```bash
kubectl create namespace <developer-namespace>
```

Create a secret that uses `secretgen` to get the registry credentials and update the default Service Account:
```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  namespace: <developer-namespace>
secrets:
  - name: image-secret
imagePullSecrets:
  - name: image-secret
---
apiVersion: v1
kind: Secret
metadata:
  name: image-secret
  namespace: <developer-namespace>
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30K
```

#### Service Account
This action uses a Kubernetes Service Account with specific permissions.
Create a service account in the developer namespace and bind it to the following roles:

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: github-actions
rules:
  - apiGroups: [ 'kpack.io' ]
    resources:
      - clusterbuilders
    verbs: [ 'get' ]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: github-actions
  namespace: <developer-namespace>
rules:
  - apiGroups: [ '' ]
    resources: [ 'pods', 'pods/log' ]
    verbs: [ 'get', 'watch', 'list' ]
  - apiGroups: [ 'kpack.io' ]
    resources:
      - builds
    verbs: [ 'get', 'watch', 'list', 'create', 'delete' ]
```

The action needs access to the cluster, using the service account created, with the
following [GitHub encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) set:
- CA_CERT
- NAMESPACE
- TOKEN
- SERVER

To get this information, run the following commands:

```bash
DEV_NAMESPACE=dev
SECRET=$(kubectl get sa <sa-with-minimum-required-permissions> -oyaml -n $DEV_NAMESPACE | yq '.secrets[0].name')

CA_CERT=$(kubectl get secret $SECRET -oyaml -n $DEV_NAMESPACE | yq '.data."ca.crt"')
NAMESPACE=$(kubectl get secret $SECRET -oyaml -n $DEV_NAMESPACE | yq .data.namespace | base64 -d)
TOKEN=$(kubectl get secret $SECRET -oyaml -n $DEV_NAMESPACE | yq .data.token | base64 -d)
SERVER=$(kubectl config view --minify | yq '.clusters[0].cluster.server')
```

Create the required secrets on the repository
through [GitHub.com](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository)
or through the `gh` CLI:

```bash
gh secret set CA_CERT --app actions --body "$CA_CERT"
gh secret set NAMESPACE --app actions --body "$NAMESPACE"
gh secret set TOKEN --app actions --body "$TOKEN"
gh secret set SERVER --app actions --body "$SERVER"
```

### Usage

```yaml
- uses: vmware-tanzu/build-image-action@v1-alpha
  with:
    ## Authorization
    # Host of the API server
    server: `${{ secrets.SERVER }}`
    # CA Certificate of the API Server
    ca_cert: `${{ secrets.CA_CERT }}`
    # Service Account token to access kubernetes
    token: `${{ secrets.TOKEN }}`
    # _(required)_ The namespace to create the build resource in
    namespace: `${{ secrets.NAMESPACE }}`

    ## Image configuration
    # _(required)_ Destination for the built image
    # Example: gcr.io/<my-project>/<my-image>
    destination: ''
    # Optional list of build time environment variables
    env: ''
    # Name of the service account in the namespace, defaults to `default`
    serviceAccountName: ''
    # Name of the cluster builder to use, defaults to `default`
    clusterBuilder: ''
    # Max active time that the pod can run for in seconds, defaults to 3600
    timeout:
```

#### Example

To use the action in a workflow:

```yaml
- name: Build Image
  id: build
  uses: vmware-tanzu/build-image-action@v1-alpha
  with:
    # Authorization
    server: ${{ secrets.SERVER }}
    token: ${{ secrets.TOKEN }}
    ca_cert: ${{ secrets.CA_CERT }}
    namespace: ${{ secrets.NAMESPACE }}
    # Image configuration
    destination: gcr.io/project-id/name-for-image
    env: |
      BP_JAVA_VERSION=17
```

### Outputs

- `name`: The full name, including sha, of the built image.

#### Example

To use the output in a subsequent step:

```yaml
- name: Do something with image
  run:
    echo "${{ steps.build.outputs.name }}"
```
