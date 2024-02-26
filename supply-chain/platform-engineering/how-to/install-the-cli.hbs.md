# Install the Tanzu Supply Chain CLI plug-ins

{{> 'partials/supply-chain/beta-banner' }} 

To start working with Tanzu Supply Chain, there are two Tanzu CLI plug-ins that you must install.

1. The Tazu Supplychain CLI plug-in is used to author and manage SupplyChains and Components.
2. The Tanzu Workload CLI plug-in is used by developers to discover and use the Workloads you authored with the Tazu Supplychain CLI plug-in.

**Important** The Tanzu Supply Chain beta release does not include the installation of the Workload and Supplychain` CLI plug-ins as part of the plug-in group.

## Prerequisites

Ensure that you installed or updated the core Tanzu CLI. For more information, see [Install Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-cli).

1. Install Tanzu `supplychain` and `workload` Tanzu CLI plug-ins:

    ```console
    tanzu plugin install supplychain
    tanzu plugin install workload
    ```

2. Verify that the plug-ins are installed correctly:

    ```console
    tanzu supplychain version
    tanzu workload version
    ```

## Uninstall Tanzu supplychain and workload CLI plug-ins

Run:

```console
tanzu plugin delete supplychain
tanzu plugin delete workload
```
