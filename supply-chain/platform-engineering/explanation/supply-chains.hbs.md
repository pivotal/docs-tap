# Understanding SupplyChains

{{> 'partials/supply-chain/beta-banner' }}

This topic introduces the SupplyChain resource which unifies the Tanzu Supply Chain operation.

![core-concepts-supplychains.jpg](./images/core-concepts-supplychains.jpg)

[Detailed Specification in the API Section](../../reference/api/supplychain.hbs.md)

## SupplyChain `defines` a configuration resource

A SupplyChain brings together the API for an end user to apply to the cluster by:

* [definining](../../reference/api/supplychain.hbs.md#specdefines) a group and kind for a resource, which we call [Workload].
* specifying [components] used in the SupplyChain;s [stages](../../reference/api/supplychain.hbs.md#specstages).

By selecting components, the supply chain aggregates each component's configuration as a single API specification for the [Workload].

> **A Note on this Beta:**
> 
> * It's quite likely that Workload will be named something else by TAP 1.9
> * Additional support for overriding configuration within a SupplyChain will be released in 1.9, allowing Platform Engineers to configure values developers don't need to know about.

## SupplyChain describes a process with `stages`

A supply chain, in the world of physical manufacturing is the process that delivers an end product to customers, starting with the raw materials.

In software, it's a very similar concept, delivering an operational end product to customers, starting with source code (raw materials).

The Tanzu Supply Chain product relies on this metaphor to describe your **Golden Path to Production**. 
It provides a primitive called SupplyChain, which is a Kubernetes custom resource, that you use to define all, or portions of, your software supply chain.

Typical uses of the Tanzu Supply Chain SupplyChain primitive are described in the topics below.

### Describe a build process 
A SupplyChain can describe the process of converting source into a runnable or deployable package.

Typical stages included in this process are:
 
* Build
  * Compile binary from source
  * Create OCI Image from binary
* Configure
  * Create deployment artifacts, such as Kubernetes Pod definitions
* Package
  * Create packaging artifacts, such as a Carvel Package or a Helm Chart
 
### Describe your build-promotion process

<!-- Ask <Nick Webb> for a section here -->

### Describe a release process

<!-- tbd -->

[Components]: ./components.hbs.md
[Workload]: ./workloads.hbs.md