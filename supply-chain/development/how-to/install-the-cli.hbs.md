# How to install the Supply Chain CLI Plug-in

{{> 'partials/supply-chain/beta-banner' }} 

To start working with Workloads provided by platform engineering, install the `workload` CLI plug-in.
The `workload` plug-in CLI helps you discover Workload Kinds, deploy workloads, and monitor the workloads.

>**Note** The Tanzu Supply Chain's initial beta release does not include the installation of the workload CLI plug-in as part of the plug-in group. To install it, follow the instructions provided on this page separately.

## Prerequisites

Ensure that you installed or updated the core Tanzu CLI. For more information, see [Install Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-cli).

## Install Tanzu Workload CLI plug-in

Run:

```console
tanzu plugin install workload
```

## Verify that the plug-in is installed correctly:

```console
tanzu workload version
```

## Uninstall Tanzu Workload CLI plug-ins

Run:

```console
tanzu plugin delete workload
```

## References

* [Understand Workloads](../explanation/workloads.hbs.md)
* [Understand WorkloadRuns](../explanation/workloads.hbs.md)
