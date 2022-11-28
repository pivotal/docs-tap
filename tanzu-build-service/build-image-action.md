# GitHub Build Action for Tanzu Build Service (Alpha)

This GitHub Action creates a TBS Build on the given cluster.

> **Important** TODO: @apeek what is VMware's stance on Alpha features. We have a similar block regarding [workload
> functions beta feature](../workloads/using-functions.hbs.md).

> **Important** Alpha features are experimental and are not ready for production use. Configuration and behavior are
> likely to change and functionality may be removed in a future release.

## Overview

### Setup

This action uses a Kubernetes service account with specific permissions.

Here are the minimum required permissions needed:

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
  namespace: dev
rules:
  - apiGroups: [ '' ]
    resources: [ 'pods', 'pods/log' ]
    verbs: [ 'get', 'watch', 'list' ]
  - apiGroups: [ 'kpack.io' ]
    resources:
      - builds
    verbs: [ 'get', 'watch', 'list', 'create', 'delete' ]
```

The action needs access to the cluster with the
following [GitHub encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) set.

```bash
SECRET=$(kubectl get sa <sa-with-minimum-required-permissions> -oyaml -n <namespace-where-sa-exists> | yq '.secrets[0].name')
CA_CERT=$(kubectl get secret $SECRET -oyaml -n <namespace-where-sa-exists> | yq '.data."ca.crt"')
NAMESPACE=$(kubectl get secret $SECRET -oyaml -n <namespace-where-sa-exists> | ksd | yq .stringData.namespace)
TOKEN=$(kubectl get secret $SECRET -oyaml -n <namespace-where-sa-exists> | ksd | yq .stringData.token)
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
    # If not running locally, use `${{ secrets.SERVER }}`
    server: ''
    # CA Certificate of the API Server
    # If not running locally, use `${{ secrets.CA_CERT }}`
    ca_cert: ''
    # Service Account token to access kubernetes
    # If not running locally, use `${{ secrets.TOKEN }}`
    token: ''
    # _(required)_ The namespace to create the build resource in
    namespace:

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

- `name`: The full name, including sha of the built image.

#### Example

To use the output in a following step:

```yaml
- name: Do something with image
  run:
    echo "${{ steps.build.outputs.name }}"
```
