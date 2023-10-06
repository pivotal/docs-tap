# Tanzu Supply Chain API

Tanzu Supply Chain introduces 2 concrete resources and 2 *meta-resources* to your Kubernetes cluster.

The concrete ones are:

* [**SupplyChain**](#SupplyChain) - used to describe a path to production and the Workload Resource that users can
  consume to run the supply chain.
* [**Component**](#Component) - used to describe a reusable (across different supply chains) operation to apply to
  source, images, configuration and other artifacts.

The meta-resources are:

* [**Workload**](#Workloads) - the resource created on cluster when a valid supply chain is applied. This is the API
  your [**SupplyChain**](#SupplyChain) describes for users to consume.
* [**WorkloadRun**](#WorkloadRuns) - a singlular attempt to deliver the [**Workload**](#Workloads) through a [*
  *SupplyChain**](#SupplyChain). Every time there's new configuration or external inputs to a workload, a run is
  generated.

The [**Workload**](#Workloads) and [**WorkloadRun**](#WorkloadRuns) are described as *meta-resources* because their
final names and CRD are described by the [**SupplyChain**](#SupplyChain) and [**Components**](#Component) when applied
to the cluster.



