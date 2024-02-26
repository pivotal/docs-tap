# How to find the kinds of Workloads I can use

{{> 'partials/supply-chain/beta-banner' }}

Available `Workload` kinds can be discovered using the Tanzu `workload` CLI plug-in.

To discover available `Workload` kinds:

```console
$ tanzu workload kinds list

KIND                        VERSION   DESCRIPTION
buildserverapps.vmware.com  v1        Builds a Kubernetes deployment app exposed using a Service using Buildpacks.
buildwebapps.vmware.com     v1        Pulls the source code from a Git repository and builds a Knative Service app using Buildpacks.
buildworkerapps.vmware.com  v1        Creates a background worker app deployed as Kubernetes deployment using Buildpacks.
  
🔎 To generate a workload for one of these kinds, use 'tanzu workload generate'
```

To create a `Workload` of a kind, see [Creating a Workload](./create-workloads.hbs.md).

## References

- [Understand Workloads](../explanation/workloads.hbs.md)
- [Understand WorkloadRuns](../explanation/workloads.hbs.md)
