# GitHub Action for Tanzu Build Service Build

This GitHub Action creates a TBS Build on the given cluster.

## Overview

## Try it out

### Setup

In order to use this action a service account will need to exist inside TAP that has permissions to access the required
resources.

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

The action will need access to the cluster and needs the
following [GitHub encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) set

```bash
SECRET=$(kubectl get sa <sa-with-minimum-required-permissions> -oyaml -n <namespace-where-sa-exists> | yq '.secrets[0].name')
CA_CERT=$(kubectl get secret $SECRET -oyaml -n <namespace-where-sa-exists> | yq '.data."ca.crt"')
NAMESPACE=$(kubectl get secret $SECRET -oyaml -n <namespace-where-sa-exists> | ksd | yq .stringData.namespace)
TOKEN=$(kubectl get secret $SECRET -oyaml -n <namespace-where-sa-exists> | ksd | yq .stringData.token)
SERVER=$(kubectl config view --minify | yq '.clusters[0].cluster.server')
```

You can create the required secrets on the repository
through [GitHub.com](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository)
or through the `gh` CLI:

```bash
gh secret set CA_CERT --app actions --body "$CA_CERT"
gh secret set NAMESPACE --app actions --body "$NAMESPACE"
gh secret set TOKEN --app actions --body "$TOKEN"
gh secret set SERVER --app actions --body "$SERVER"
```

### Usage

#### Auth

- `server`: Host of the API Server.
- `ca-cert`: CA Certificate of the API Server.
- `token`: Service Account token to access kubernetes.
- `namespace`: _(required)_ The namespace to create the build resource in.

#### Image Configuration

- `destination`: _(required)_
- `env`: Optional list of build time environment variables
- `serviceAccountName`: Name of the service account in the namespace, defaults to `default`
- `clusterBuilder`: Name of the cluster builder to use, defaults to `default`

#### Basic Configuration

In your GitHub workflow, add a step to build the image:

```yaml
- name: Build Image
  id: build
  uses: vmware-tanzu/build-image-action@v1
  with:
    # auth
    server: ${{ secrets.SERVER }}
    token: ${{ secrets.TOKEN }}
    ca_cert: ${{ secrets.CA_CERT }}
    namespace: ${{ secrets.NAMESPACE }}
    # image config
    destination: gcr.io/project-id/name-for-image
    env: |
      BP_JAVA_VERSION=17
```

##### Outputs

- `name`: The full name, including sha of the built image.

##### Example

To use the output in a following step:

```yaml
- name: Do something with image
  run:
    echo "${{ steps.build.outputs.name }}"
```

