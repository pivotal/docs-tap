# How to install the Supply Chain CLI Plugin

{{> 'partials/supply-chain/beta-banner' }} 

To start working with Workloads provided by platform engineering, install the `workload` CLI plugin.
The `workload` plugin CLI helps you discover Workload Kinds, deploy workloads, and monitor the workloads.

>**Note**
>The Tanzu Supply Chain's initial beta release does not include the installation of the workload CLI plugin as part of the TAP Plugin group. To install it, follow the instructions provided on this page separately.

## Prerequisites
Ensure that you installed or updated the core Tanzu CLI. For more information, see [Install Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-cli).

## Install Tanzu Supplychain and Workload CLI plugins

Run:
```
tanzu plugin install workload
```

## Verify that the plug-in is installed correctly:

```
tanzu workload version
```

## Uninstall Tanzu Supplychain and Workload CLI plugins

Run:
```
tanzu plugin delete workload
```

## References

[Understand Workloads](../explanation/workloads.hbs.md)
[Understand WorkloadRuns](../explanation/workloads.hbs.md)
