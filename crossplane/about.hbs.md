# Overview of Crossplane

Crossplane is an open source, Cloud Native Computing Foundation (CNCF) project built on the
foundation of Kubernetes.
Tanzu Application Platform (commonly known as TAP) uses Crossplane to power a number of capabilities,
such as dynamic provisioning of services instances with [Services Toolkit](../services-toolkit/about.hbs.md)
and the [Bitnami Services](../bitnami-services/about.hbs.md).

> **Note** If installing Tanzu Application Platform to a cluster that already has Crossplane
> installed, see [Use your existing Crossplane installation](how-to-guides/use-existing-crossplane.hbs.md).

## <a id="crossplane"></a> Crossplane with Tanzu Application Platform

Tanzu Application Platform includes a Carvel package named `crossplane.tanzu.vmware.com`, which is
included by default in the full, iterate, and run profiles.
The package installs [Upbound Universal Crossplane (UXP)](https://github.com/upbound/universal-crossplane).

In addition, the package includes two pre-configured Crossplane providers:
[provider-helm](https://github.com/crossplane-contrib/provider-helm) and [provider-kubernetes](https://github.com/crossplane-contrib/provider-kubernetes).
Both of providers provide useful [Managed Resources](https://docs.crossplane.io/latest/concepts/managed-resources/)
that you can use as part of [Composition](https://docs.crossplane.io/latest/concepts/composition/#compositions).
These are both used by Tanzu Application Platform's [Bitnami Services](../bitnami-services/about.hbs.md).

The package installs UXP and the providers to the `crossplane-system` namespace.

## <a id="getting-started"></a> Getting started

To learn about working with Crossplane in general, see the [Crossplane documentation](https://docs.crossplane.io/).
To learn about how Tanzu Application Platform integrates with Crossplane,
see one of the following tutorials to get started.

**For apps teams:**

- Tutorial: [Working with Bitnami Services](../bitnami-services/tutorials/working-with-bitnami-services.hbs.md)

**For ops teams:**

- Tutorial: [Setup Dynamic Provisioning of Service Instances](../services-toolkit/tutorials/setup-dynamic-provisioning.hbs.md)
- How-to guide: [Use your existing Crossplane installation](how-to-guides/use-existing-crossplane.hbs.md)
- How-to guide: [Delete Crossplane resources when you uninstall Tanzu Application Platform](how-to-guides/delete-resources.hbs.md)

Alternatively, see the [reference material](reference/index.hbs.md).
