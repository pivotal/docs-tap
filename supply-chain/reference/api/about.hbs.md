# Tanzu Supply Chain API
{{> 'partials/supply-chain/<beta-banner>' }}

Tanzu Supply Chain introduces two concrete resources and two *Duck-typed resources* to your Kubernetes cluster.

The concrete resources are:

* [**SupplyChain**] - used to describe a path to production, and describe the [**Workload**] resource that users can
  consume to run this supply chain.
* [**Component**] - used to describe a reusable operation to apply to source, images, configuration and other artifacts.

The *Duck-typed resources* are:

* [**Workload**] - this resource CRD is created on cluster when a valid supply chain is applied. This is the API
  your [**SupplyChain**] describes for users to consume.
* [**WorkloadRun**] - a single attempt to deliver the [**Workload**] through a [**SupplyChain**]. Every time there's new configuration or external inputs to a workload, a run is
  generated.

The [**Workload**] and [**WorkloadRun**] are described as *Duck-Type resources* because their
final names and CRD are described by the [**SupplyChain**] and [**Components**] when applied
to the cluster. Many fields of each CRD are the same across the system.


[**SupplyChain**]: supplychain.hbs.md
[**Workload**]: workload.hbs.md
[**Component**]: component.hbs.md
[**Components**]: component.hbs.md
[**WorkloadRun**]: workloadrun.hbs.md
