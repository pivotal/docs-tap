# Tanzu Supply Chain API

This topic gives you reference information about Tanzu Supply Chain APIs.

{{> 'partials/supply-chain/beta-banner' }}

Tanzu Supply Chain introduces two concrete resources and two Duck-typed resources to your Kubernetes
cluster.

The concrete resources are:

- `SupplyChain`, which describes a path to production and describes the `Workload` resource you can
  consume to run this supply chain.
- `Component`, which describes a reusable operation to apply to source, images, configuration, and
  other artifacts.

The Duck type resources are:

- `Workload`: This resource CRD is created on the cluster when a valid supply chain is applied. This
  is the API that your `SupplyChain` describes for users to consume.
- `WorkloadRun`: This is a single attempt to deliver the `Workload` through a `SupplyChain`. Every
  time there is new configuration or external inputs to a workload, a run is generated.

`Workload` and `WorkloadRun` are described as Duck type resources because their final names and CRD
are described by the `SupplyChain` and `Component` resources when applied to the cluster. Many
fields of each CRD are the same across the system.

<!--
[SupplyChain]: supplychain.hbs.md
[Workload]: workload.hbs.md
[Component]: component.hbs.md
[Components]: component.hbs.md
[WorkloadRun]: workloadrun.hbs.md
-->