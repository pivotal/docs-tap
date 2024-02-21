# How to find the kinds of Workloads I can use

{{> 'partials/supply-chain/beta-banner' }}

Available [Workload] kinds can be discovered using the Tanzu `workload` CLI plugin.

To discover available [Workload] kinds:

```console
$ tanzu workload kinds list

KIND                        VERSION
buildserverapps.vmware.com  v1
buildwebapps.vmware.com     v1
buildworkerapps.vmware.com  v1
```

To create a [Workload] of a kind, see [Creating a Workload].

[Workload]: ../explanation/workloads.hbs.md
[Creating a Workload]: ./create-workloads.hbs.md