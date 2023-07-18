# Using Azure DevOps as a Git provider with your supply chains

This topic describes how you can Azure DevOps as a Git provider with your Supply Chain Choreographer supply chains.

## Overview 

There are two uses for Git in a supply chain:

- As a source of code to build and deploy applications
- As a repository of configuration created by the build cluster which is deployed on a run or production cluster

Azure DevOps differs from other Git providers in the following ways:

- Azure DevOps requires Git clients to support multi-ack.
- Azure DevOps repository paths differ from other Git providers.

For information about how Azure DevOps is different from other Git providers, see [Gitops write path templates](#gitops-write-temp).

The operator requires special configuration to integrate Azure DevOps repositories into a supply chain.

## <a id="azure-auth"></a> Azure authentication

You can use Azure authentication with Supply Chain Choreographer. 

For information about configuring secrets to authenticate with your Azure DevOps Git repository, see 
[Use Git authentication with Supply Chain Choreographer](./git-auth.hbs.md). 

Azure http and https authentication requires:

```yaml
username: "_token"
password: AZURE-USER-TOKEN
```

Where `AZURE-USER-TOKEN` is your Azure personal access token. 
See [Azure Devops Personal Access Tokens](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate) in the Microsoft documentation.

## <a id="repo-committed"></a> Using Azure DevOps as a repository for committed code

Developers can use Azure DevOps to commit source code to a repository that the
supply chain pulls.

### <a id="devops-example"></a> Azure DevOps example

The following example uses the Azure DevOps source repository:

`https://dev.azure.com/my-company/app/_git/app`

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

## <a id="using-gitops"></a> Using Azure DevOps as a GitOps repository

The supply chain commits Kubernetes configuration to a Git repository.
This configuration is then applied to another cluster. This is the GitOps
promotion pattern.

You must construct a path and configure your Git implementation to read and write to an Azure DevOps repository.

### <a id="gitops-write-ex"></a> GitOps write path example

The following example uses the Azure DevOps Git repository:

`https://dev.azure.com/vmware-tanzu/tap/_git/tap`

Set the `gitops_server_kind` workload parameters to `azure`.

  ```yaml
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    ...
  spec:
    params:
      - name: gitops_server_kind
        value: azure
      ...
  ```

Set other GitOps values in either tap-values or in the workload parameters.

  - By using tap-values:

    ```yaml
    ootb_supply_chain_testing_scanning:
      gitops:
        server_address: https://dev.azure.com
        repository_owner: vmware-tanzu/tap
        repository_name: tap
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
          value: https://dev.azure.com
        - name: gitops_repository_owner
          value: vmware-tanzu/tap
        - name: gitops_repository_name
          value: tap
        ...
    ```

### <a id="gitops-write-temp"></a> Gitops write path templates

Azure DevOps and Git use different URL structures.

For example, the Git clone URL of an Azure DevOps repository is structured as:

`https://dev.azure.com/<org_name>/<project_name>/_git/<repository_name>`

GitHub uses the following address structure:

`https://github.com/<org_name>/<repository_name>`

In Azure DevOps, a project can have multiple repositories, but the project name
and repository name are often the same.

The [config-writer](ootb-template-reference.hbs.md#config-writer-template) and
[config-writer-and-pull-requester](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template) templates
accept three parameters to build the path of the repository. For Azure DevOps, configure them as follows:

- gitops_server_address: `https://dev.azure.com`
- gitops_repository_owner: `<org_name>/<project_name>`
- gitops_repository_name: `<repository_name>`

Configure the template parameters as follows:

- `gitops.server_address` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_server_address` configured as a workload parameter.
- `gitops.repository_owner` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_repository_owner` configured as a workload parameter.
- `gitops.repository_name` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_repository_name` configured as a workload parameter.

To properly contruct the write path, the template parameter `gitops_server_kind` must be configured
as `azure`.

Configure`gitops_server_kind` as a workload parameter.

>**Note** When you use pull requests with GitOps, you can set the type of server with the tap-value `gitops.pull_request.server_kind`. See [GitOps versus RegistryOps](gitops-vs-regops.hbs.md#a-idprsa-pull-requests).

For information about configuring the GitOps write operations, see
[GitOps versus RegistryOps](gitops-vs-regops.hbs.md).