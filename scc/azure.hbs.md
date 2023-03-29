# Using Azure DevOps as a Git Provider

Azure DevOps differs from other git providers in a number of ways:

- Azure DevOps requires git clients to support multi-ack.
- Azure DevOps repository paths differ from other git providers.

These require special configuration by the operator in order to integrate Azure DevOps repositories into a supply chain.

There are two uses for git in a supply chain:
- As a source of code for applications to be built and deployed
- As a repository of configuration created by the build cluster which will be deployed on a run/production cluster (the
  gitops pattern)

> **Note** While it is possible to configure supply chains to use Azure DevOps for just one of these purposes, it is
advisable to use Azure DevOps for either both or neither.

## Using Azure DevOps as a repository for committed code

Purpose: Developers commit source code to a repository which is the supply chain pulls (testing, building, scanning and
deploying the application).

### Quick Example

Given an Azure DevOps source repo of

`https://dev.azure.com/my-company/app/_git/app`

You can configure the supply chain through tap-values:

```yaml
ootb_supply_chain_testing_scanning:
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

### Discussion

Challenge: The default configuration of the source controller does not use a git implementation compatible with Azure
DevOps.

Solution: The [source-template's](ootb-template-reference.hbs.md#source-template) parameter
`gitImplementation` must be configured to `libgit2`. This can be done in two ways:

1. Using the tap-value `git_implementation` to set [the parameter](ootb-supply-chain-reference.hbs.md#source-provider)
   for the supply chain.
2. Using the [workload parameter](workload-reference.hbs.md#parameters) `gitImplementation` to configure the parameter
   for the individual workload.

If both methods are set and do not match, the workload's parameter will be respected.

## Using Azure DevOps as a gitops repository

Purpose: The supply chain commits kubernetes configuration to a git repository. This configuration is then applied to
another cluster. This is the gitops promotion pattern.

Challenges:

- Special repository path construction is necessary to write to an Azure DevOps repository.
- To pull from the Azure DevOps repository, special git implementation must be used.

### Gitops Write Path

#### Quick Example

Given an Azure DevOps gitops repo of

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

#### Discussion

The git clone url of an Azure Devops repository is structured as:

`https://dev.azure.com/<org_name>/<project_name>/_git/<repository_name>`

This contrasts with the address structure of a git provider such as github:

`https://github.com/<org_name>/<repository_name>`

In Azure DevOps, a project may have multiple repositories, though in practice the project name and repository name are
often the same.

The [config-writer](ootb-template-reference.hbs.md#config-writer-template) and
[config-writer-and-pull-requester](ootb-template-reference.hbs.md#config-writer-and-pull-requester-template) templates
accept three parameters to build the path of the repository. For Azure DevOps these should be configured as:

- gitops_server_address: Likely `https://dev.azure.com`
- gitops_repository_owner: `<org_name>/<project_name>`
- gitops_repository_name: `<repository_name>`

These template parameters can be configured respectively by:

- `gitops.server_address` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_server_address` configured as a workload parameter.
- `gitops.repository_owner` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_repository_owner` configured as a workload parameter.
- `gitops.repository_name` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_repository_name` configured as a workload parameter.

In order for the write path to be properly constructed, the template parameter `gitops_server_kind` must be configured
as `azure`. This can be done as

- `gitops.pull-request.server-kind` tap-value during the Out of the Box Supply Chains package installation
  or `gitops_server_kind` configured as a workload parameter.

> **Note** Even if the commit strategy is not pull-request (i.e. git commits are made directly), in order to use an 
Azure DevOps repository either the tap value `gitops.pull-request.server-kind` or the workload param
`gitops_server_kind` must be configured to `azure`.

For more information about configuration of the gitops write operations, see
[GitOps versus RegistryOps](gitops-vs-regops.hbs.md).

### Gitops Read Implementation

#### Quick Example

Given an Azure DevOps gitops repo of

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

#### Discussion

Similar to [reading an Azure DevOps source repo](#using-azure-devops-as-a-repository-for-committed-code), when reading
an AzureDevOps gitops repo, the git implementation must be configured for the
[delivery-source-template](ootb-template-reference.hbs.md#delivery-source-template). The configuration of this parameter
can come from the [delivery](ootb-delivery-reference.hbs.md) or the
[deliverable](ootb-template-reference.hbs.md#deliverable-template).

The delivery can be configured through the tap-values for the delivery.

The definition of a deliverable is created by the supply chain. The `gitImplementation` param passed to the deliverable
template is written into the Deliverable's params field (which can then be propagated to objects stamped when the
Deliverable is applied to a cluster with a Delivery). The deliverable-template's `gitImplementation` param can be
configured either by setting the tap-value `git_implementation` for the supply chain at installation, or by setting the
`gitImplementation` param on the workload.
