# Understanding SupplyChains

{{> 'partials/supply-chain/beta-banner' }}

This topic introduces the SupplyChain resource which unifies the Tanzu Supply Chain operation.

![core-concepts-supplychains.jpg](./images/core-concepts-supplychains.jpg)

[Detailed Specification in the API Section](../../reference/api/supplychain.hbs.md)

## SupplyChain describes a process with `stages`

A supply chain, in the world of physical manufacturing is the process that delivers an end product to customers, starting with the raw materials.

In software, it's a very similar concept, delivering an operational end product to customers, starting with source code (raw materials).

The Tanzu Supply Chain product relies on this metaphor to describe your **Golden Path to Production**.
It provides a primitive called SupplyChain, which is a Kubernetes custom resource, that you use to define all, or portions of, your software supply chain.

Typical uses of the Tanzu Supply Chain SupplyChain primitive are described in the topics below.

### SupplyChain describes a build process
A SupplyChain can describe the process of converting source into a runnable or deployable package.

Typical stages included in this process are:

* Build
  * Compile binary from source
  * Create OCI Image from binary
* Configure
  * Create deployment artifacts, such as Kubernetes Pod definitions
* Package
  * Create packaging artifacts, such as a Carvel Package or a Helm Chart

[//]: # (### Describe your build-promotion process)

[//]: # ()
[//]: # (<!-- Ask <Nick Webb> for a section here -->)

[//]: # ()
[//]: # (### Describe a release process)

[//]: # ()
[//]: # (<!-- tbd -->)

## SupplyChain `defines` a configuration resource

A SupplyChain brings together the API for an end user to apply to the cluster by:

* [definining](../../reference/api/supplychain.hbs.md#specdefines) a group and kind for a resource, which we call [Workload].
* specifying [components] used in the SupplyChain;s [stages](../../reference/api/supplychain.hbs.md#specstages).

By selecting components, the supply chain aggregates each component's configuration as a single API specification for the [Workload].

> **A Note on this Beta:**
>
> * It's quite likely that Workload will be named something else by TAP 1.9
> * Additional support for overriding configuration within a SupplyChain will be released in 1.9, allowing Platform Engineers to configure values developers don't need to know about.

### Supply Chains enforce immutability

The version of your SupplyChain, as embedded in the name, must follow the following rules.

A patch bump is required to update the supply chain without an API change.
The controller will ensure this rule cannot be broken when comparing supply chains on cluster.

For example, imagine you apply to a cluster:

* a SupplyChain with the name `serverappv1s.example.com-1.0.0` with kind `ServerAppV1s`
* a SupplyChain with the name `serverappv1s.example.com-1.0.1` with kind `ServerAppV1s`

If the generated API for the kind is unchanged, then the higher version is accepted.
If there is a change, the first applied supply chain wins, and the others reflect the error in their status.
This ensures that **you can't accidentally break the running kind API**.

These rules ensure that potentially thousands of Workloads and Runs on the cluster do not suddenly break.

**Recommended** version guidelines:

* If the API and general behavior is unchanged by a change to the [`spec.stages`](tbd link):
  * Use a patch bump such as `1.2.5` to `1.2.6`
  * Keep the same kind, such as `ServerAppV1`
* If the API is unchanged, but something significantly different occurs because of changes to the [`spec.stages`](tbd link), consider:
  * a bump to the minor or major version, such as `1.2.5` to `1.3.0`
  * a bump to the kind, such as `ServerAppV2`
  * or a change of kind, such as `ServerAppWithApprovalV1`
* If the API changes:
  * a bump to the minor or major version, such as `1.2.5` to `1.3.0`
  * a bump to the kind, such as `ServerAppV2`

This ensures clear communication to your users. New kind versions typically indicate that the user
needs to migrate their resources to the new API.

## Integrity validation

A SupplyChain is **not valid** if:

* A required field is missing
* The [Components] referenced are not in the same namespace
* The [Components] referenced contain inputs that are not satisfied by their position in the [`spec.stages`](#specstages)
* The name does not match the [`spec.defines`](#specdefines) section
* The SupplyChain breaks the [versioning rules](#supply-chains-cannot-change-an-api-once-it-is-on-cluster).

The [SupplyChain Status](../../reference/api/supplychain.hbs.md#statusconditions) describes when these rules are broken. 

[Components]: ./components.hbs.md
[Workload]: ./workloads.hbs.md