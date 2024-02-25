# Tutorial: Deploy your first Workload

{{> 'partials/supply-chain/beta-banner' }} 

In this section, we will be using the `workload` CLI plugin for developers to create our first `Workload`. Our Platform Engineer has created some Supply Chains for us to use, which can pull the source code from our source repository, build it and the built artifact will be shipped to a GitOps repository of Platform Engineer's choice.

## Prequisites
You will need the following CLI tools installed on your local machine:

* [Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-tanzu-cli)
* [**workload** Tanzu CLI plugin](../how-to/install-the-cli.hbs.md)

## Getting Started

As a developer, the first thing we want to know is what `SupplyChain` are available to us. You can