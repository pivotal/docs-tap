# Crossplane

[Crossplane](https://www.crossplane.io/) is an open source, CNCF project built on the foundation of Kubernetes to orchestrate anything. Tanzu Application Platform makes use of Crossplane to power a number of capabilities, such as dynamic provisioning of services instances with [Services Toolkit](../services-toolkit/about.hbs.md) as well as the out of the box [Bitnami Services](../bitnami-services/about.hbs.md).

## Crossplane with Tanzu Application Platform

Tanzu Application Platform ships with a Carvel Package named `crossplane.tanzu.vmware.com`, which is included by default in the `iterate`, `build` and `run` profiles. The Package installs Upbound Universal Crossplane (UXP). A brief description of UXP from Upbound's documentation follows:

> Upbound Universal Crossplane (UXP) is Upbound's official enterprise-grade distribution of Crossplane.
> It's fully compatible with upstream Crossplane, open source, capable of connecting to Upbound Cloud for real-time
> dashboard visibility, and maintained by Upbound. It's the easiest way for both individual community members and
> enterprises to build their production control planes.

In addition, the Package ships with two pre-configured Crossplane Providers - [provider-helm](https://github.com/crossplane-contrib/provider-helm) and [provider-kubernetes](https://github.com/crossplane-contrib/provider-kubernetes), both of which provide useful [Managed Resources](https://docs.crossplane.io/latest/concepts/managed-resources/) which can be used as part of [Composition](https://docs.crossplane.io/latest/concepts/composition/#compositions). These are both used by Tanzu Application Platform's [Bitnami Services](../bitnami-services/about.hbs.md).

The Package installs UXP and the Providers to the `crossplane-system` namespace.

## Where to start

Refer to official Crossplane documentation to learn more about working with Crossplane in general. Alternatively if you'd like to lean more about how Tanzu Application Platform integrates with Crossplane, refer to one of the following tutorials to get started.

**For apps teams**

* [Tutorial - Working with Bitnami Services](../bitnami-services/tutorials/working-with-bitnami-services.hbs.md)

**For ops teams**

* [Tutorial - Setup Dynamic Provisioning of Service Instances](../services-toolkit/tutorials/setup-dynamic-provisioning.hbs.md)

Alternatively, refer to the [reference material](reference/index.hbs.md).
