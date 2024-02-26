# How to install the Supply Chain CLI plug-ins

{{> 'partials/supply-chain/beta-banner' }} 

To start working with Tanzu Supply Chain, there are two Tanzu CLI plug-ins that you must install.

1. The `supplychain` CLI plug-in is used to author and manage SupplyChains and Components.
2. The `workload` CLI plug-in use by developers to discover and use the Workloads you authored with the `supplychain` CLI plug-in

>**Note**
>The Tanzu Supply Chain's initial beta release does not include the installation of the workload and supply chain CLI plug-ins as part of the plug-in group. To install them, follow the instructions provided on this page separately.

## Prerequisites

Ensure that you installed or updated the core Tanzu CLI. For more information, see [Install Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-cli).

## Install Tanzu Supplychain and Workload CLI plug-ins

Run:

```console
tanzu plugin install supplychain
tanzu plugin install workload
```

## Verify that the plug-in is installed correctly:

```console
tanzu supplychain version
tanzu workload version
```

## Uninstall Tanzu Supplychain and Workload CLI plug-ins

Run:

```console
tanzu plugin delete supplychain
tanzu plugin delete workload
```
