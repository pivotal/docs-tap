# Using Gitlab as a Git provider with your supply chains

This topic describes how to use Gitlab as a Git provider with your Supply Chain Choreographer supply chains.

There are two uses for Git in a supply chain:

- As a source of code to build and deploy applications
- As a repository of configuration created by the build cluster which is deployed on a run or production cluster

## <a id="repo-committed"></a> Using Gitlab as a repository for committed code

Developers can use Gitlab to commit source code to a repository that the
supply chain pulls.

### <a id="devops-example"></a> Gitlab example

The following example uses the Gitlab source repository:

`https://gitlab.example.com/my-org/repository.git`

You can configure the supply chain by using `tap-values`:

```yaml
ootb_supply_chain_testing_scanning:
  git_implementation: go-git
```

or by using workload parameter:

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

## <a id="using-gitops"></a> Using Gitlab as a GitOps repository

The supply chain commits Kubernetes configuration to a Git repository.
This configuration is then applied to another cluster. This is the GitOps
promotion pattern.

You must construct a path and configure your Git implementation to read and write to an Gitlab repository.

### <a id="gitops-write-ex"></a> GitOps write path example

The following example uses the Gitlab Git repository:

`https://gitlab.example.com/my-org/repository.git`

Set the `gitops_server_kind` workload params to `gitlab`.

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

Set other gitops values in either tap-values or in the workload params.

  - By using tap-values:

    ```yaml
    ootb_supply_chain_testing_scanning:
      gitops:
        server_address: https://gitlab.example.com
        repository_owner: my-org
        repository_name: repository
    ```

  - By using the workload parameters:

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

### <a id="gitops-read-ex"></a> Gitlab read example

The following example uses the Gitlab repository:

`https://gitlab.example.com/my-org/repository.git`

You can configure the delivery tap-values:

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

### <a id="gitops-read-temp"></a> Gitlab over HTTPS with a custom CA certificate

When using HTTPS with a custom certificate authority the git secret must be configured both in the `tap-values` as 
well as the git secret used by the GitRepository.

The [`shared.ca_cert_data`](../security-and-compliance/tls-and-certificates/custom-ca-certificates.hbs.md) is set inside 
`tap-values.yaml`. Inside the git secret the `caFile` field must be set.

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

The secret is then associated with the `ServiceAccount`.

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

For more details please see [Git Authentication](git-auth.hbs.md).