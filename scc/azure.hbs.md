# Using Azure DevOps as a Git provider

Azure DevOps differs from other Git providers in the following ways:

- Azure DevOps requires Git clients to support multi-ack.
- Azure DevOps repository paths differ from other Git providers.

These require special configuration by the operator to integrate Azure DevOps
repositories into a supply chain.

There are two uses for Git in a supply chain:

- As a source of code for applications to be built and deployed
- As a repository of configuration created by the build cluster which is
  deployed on a run or production cluster

> **Note** While you can configure supply chains to use Azure DevOps for only
> one of these purposes, VMware recommends using Azure DevOps for either both or
> neither.

## Using Azure DevOps as a repository for committed code

Developers can use Azure DevOps to commit source code to a repository that the
supply chain pulls, such as testing, building, scanning and deploying the
application.

### Azure DevOps example

The following example uses the Azure DevOps source repository:

`https://dev.azure.com/my-company/app/_git/app`

You can configure the supply chain through `tap-values`:

```yaml
ootb_supply_chain_testing_scanning:
  git_implementation: libgit2
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
      value: libgit2
```

### Azure DevOps discussion

Challenge: The default configuration of the source controller does not use a Git
implementation compatible with Azure DevOps.

Solution: You must configure the [source-template's](ootb-template-reference.hbs.md#source-template) parameter
`gitImplementation` to `libgit2`. To do this, use one of these options:

1. Use the tap-value `git_implementation` to set the parameter
   for the supply chain. See [source-provider](ootb-supply-chain-reference.hbs.md#source-provider).
2. Use the workload parameter `gitImplementation` to configure the parameter
   for the individual workload. See [Parameters](workload-reference.hbs.md#parameters).

If both methods are set and do not match, the workload's parameter is respected.

## Using Azure DevOps as a GitOps repository

Purpose: The supply chain commits Kubernetes configuration to a Git repository.
This configuration is then applied to another cluster. This is the GitOps
promotion pattern.

Challenges:

- Special repository path construction is required to write to an Azure DevOps repository.
- To pull from the Azure DevOps repository, special Git implementation must be used.

### Gitops write path

#### Gitops write path example

Given an Azure DevOps GitOps repository of

`https://dev.azure.com/vmware-tanzu/tap/_git/tap`

You can configure the supply chain through tap-values:

```yaml
otb_supply_chain_testing_scanning:
  gitops:
    server_address: https://dev.azure.com
    repository_owner: vmware-tanzu/tap
    repository_name: tap
    pull-request:
      server-kind: azure
```

or the workload parameters:

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
    - name: gitops_server_kind
      value: azure
    ...
```

#### Gitops write path discussion

The Git clone URL of an Azure DevOps repository is structured as:

`https://dev.azure.com/<org_name>/<project_name>/_git/<repository_name>`

This contrasts with the address structure of a Git provider, such as GitHub:

`https://github.com/<org_name>/<repository_name>`

In Azure DevOps, a project can have multiple repositories, though in practice the project name and repository name are
often the same.

The [config-writer](ootb-template-reference.hbs.md#config-writer-template) and
[config-writer-and-pull-requester](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template) templates
accept three parameters to build the path of the repository. For Azure DevOps, configure these as follows:

- gitops_server_address: Likely `https://dev.azure.com`
- gitops_repository_owner: `<org_name>/<project_name>`
- gitops_repository_name: `<repository_name>`

These template parameters are configured respectively by:

- `gitops.server_address` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_server_address` configured as a workload parameter.
- `gitops.repository_owner` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_repository_owner` configured as a workload parameter.
- `gitops.repository_name` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_repository_name` configured as a workload parameter.

For the write path to be properly constructed, the template parameter `gitops_server_kind` must be configured
as `azure`. This is done as

- `gitops.pull-request.server-kind` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_server_kind` configured as a workload parameter.

> **Note** Even if the commit strategy is not pull-request (i.e. git commits are made directly), to use an 
Azure DevOps repository either the tap value `gitops.pull-request.server-kind` or the workload parameter
`gitops_server_kind` must be configured to `azure`.

For more information about configuration of the GitOps write operations, see
[GitOps versus RegistryOps](gitops-vs-regops.hbs.md).

### Gitops read implementation

#### Gitops read example

Given an Azure DevOps GitOps repository of

`https://dev.azure.com/vmware-tanzu/tap/_git/tap`

You can configure the supply chain tap-values:

```yaml
ootb_supply_chain_testing_scanning:
  git_implementation: libgit2
```

or the delivery tap-values:

```yaml
ootb_delivery_basic:
  git_implementation: libgit2
```

or the workload parameter:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  ...
spec:
  params:
    - name: gitImplementation
      value: libgit2
```

#### Gitops read implementation discussion

Similar to [reading an Azure DevOps source repo](#using-azure-devops-as-a-repository-for-committed-code), when reading
an AzureDevOps GitOps repository, the Git implementation must be configured for the
[delivery-source-template](ootb-template-reference.hbs.md#delivery-source-template). The configuration of this parameter
can come from the [delivery](ootb-delivery-reference.hbs.md) or the
[deliverable](ootb-template-reference.hbs.md#deliverable-template).

You can configure the delivery through the tap-values for the delivery.

The supply chain creates the definition of a deliverable. The `gitImplementation` parameter passed to the deliverable
template is written into the Deliverable's parameters field (which can then be propagated to objects stamped when the
Deliverable is applied to a cluster with a Delivery). You can configure the deliverable-template's `gitImplementation` parameter by setting the tap-value `git_implementation` for the supply chain at installation, or by setting the
`gitImplementation` parameter on the workload.
