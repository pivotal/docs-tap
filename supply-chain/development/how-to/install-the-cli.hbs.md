# How to install the Tanzu Workload CLI Plug-in

{{> 'partials/supply-chain/beta-banner' }}

This topic tells you how to install the Tanzu Workload CLI plug-in. This CLI enables you to work
with the workloads provided by platform engineering.

This plug-in helps you discover workload kinds, deploy workloads, and monitor the workloads. The
Tanzu Supply Chain beta release does not include the installation of the Tanzu Workload CLI plug-in
as part of the plug-in group. The Tanzu `workload` CLI plug-in provides commands that allow a Developer to generate a `Workload` manifest, apply it to a cluster, and delete it from a cluster.

## Prerequisites

Ensure that you installed or updated the core Tanzu CLI. For more information, see
[Install Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-cli).

## Install Tanzu Workload CLI plug-in

1. Run:

    ```console
    tanzu plugin install workload
    ```

1. Verify that the plug-in is installed correctly:

    ```console
    tanzu workload version
    ```

## Uninstall Tanzu Workload CLI plug-ins

Run:

```console
tanzu plugin delete workload
```