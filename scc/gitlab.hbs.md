# Using GitLab as a Git provider with your supply chains

This topic describes how to use GitLab as a Git provider with your Supply Chain Choreographer supply chains.

## <a id="overview"></a>Overview

There are two uses for Git in a supply chain:

- As a source of code to build and deploy applications
- As a repository of configuration created by the build cluster which is deployed on a run or production cluster

## <a id="repo-committed"></a> Using GitLab as a repository for committed code

This section tells you how developers can use GitLab to commit source code to a repository that the
supply chain pulls.

### <a id="devops-example"></a> GitLab example

The following example uses the GitLab source repository:

`https://gitlab.example.com/my-org/repository.git`

You can configure the supply chain by using `tap-values.yaml`:

```yaml
ootb_supply_chain_testing_scanning:
  git_implementation: go-git
```

or by using a workload parameter:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  ...
spec:
  params:
    - name: gitImplementation
      value: go-git
```

## <a id="using-gitops"></a> Using GitLab as a GitOps repository

The supply chain commits Kubernetes configuration to a Git repository.
This configuration is then applied to another cluster. This is the GitOps
promotion process.

You must construct a path and configure your Git implementation to read and write to an GitLab repository.

### <a id="gitops-write-ex"></a> GitOps write path example

The following example uses the GitLab Git repository:

`https://gitlab.example.com/my-org/repository.git`

1. Set the `gitops_server_kind` workload parameters to `gitlab`.

  ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      ...
    spec:
      params:
        - name: gitops_server_kind
          value: gitlab
        ...
  ```

1. Set other GitOps values in either `tap-values.yaml` or in the workload parameters.

  By using `tap-values.yaml`:

  ```yaml
      ootb_supply_chain_testing_scanning:
        gitops:
          server_address: https://gitlab.example.com
          repository_owner: my-org
          repository_name: repository
  ```

  By using the workload parameters:

  ```yaml
      apiVersion: carto.run/v1alpha1
      kind: Workload
      metadata:
        ...
      spec:
        params:
          - name: gitops_server_address
            value: https://gitlab.example.com
          - name: gitops_repository_owner
            value: my-org
          - name: gitops_repository_name
            value: repository
          ...
  ```

### <a id="gitops-read-ex"></a> GitLab read example

The following example uses the GitLab repository:

`https://gitlab.example.com/my-org/repository.git`

You can configure the delivery `tap-values.yaml`:

```yaml
ootb_delivery_basic:
  git_implementation: go-git
```

or the deliverable parameter:

```yaml
apiVersion: carto.run/v1alpha1
kind: Deliverable
metadata:
  ...
spec:
  params:
    - name: gitImplementation
      value: go-git
```

### <a id="gitops-read-temp"></a> GitLab over HTTPS with a custom CA certificate

When using HTTPS with a custom certificate authority, you must configure the Git
secret both in `tap-values.yaml` and the Git secret used by the GitRepository.

1. Set the [shared.ca_cert_data](../security-and-compliance/tls-and-certificates/custom-ca-certificates.hbs.md)
 in `tap-values.yaml`. You must set the Git secret in the `caFile` field.

  ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: SECRET-NAME
      annotations:
        tekton.dev/git-0: GIT-SERVER        # ! required
    type: kubernetes.io/basic-auth          # ! required
    stringData:
      username: GIT-USERNAME
      password: GIT-PASSWORD
      caFile: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
  ```

1. Associate the secret with the `ServiceAccount`.

  ```yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: default
  secrets:
    - name: registry-credentials
    - name: tap-registry
    - name: GIT-SECRET-NAME
  imagePullSecrets:
    - name: registry-credentials
    - name: tap-registry
  ```

For information about authentication, see [Git Authentication](git-auth.hbs.md).