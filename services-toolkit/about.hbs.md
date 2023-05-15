# Services Toolkit

Services Toolkit is responsible for backing many of the most powerful service capabilities in
Tanzu Application Platform.

From the integration of an extensive list of cloud-based and on-prem services, through to the offering
and discovery of those services, and finally to the claiming and binding of service instances to
application workloads, Services Toolkit has the tools you need to make working with services on
Tanzu Application Platform simple, easy, and effective.

>**Note** These docs apply to Services Toolkit v0.10 and later.
>To view the Services Toolkit documentation for v0.9 and earlier, see the previous
>[Services Toolkit site](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/index.html).

## <a id="capabilities"></a> Capabilities

The main capabilities on offer in Tanzu Application Platform through Services Toolkit are:

1. The classes and claims abstraction: provides a simple, but powerful, user experience to apps teams,
while promoting a strong separation of concerns between apps teams and ops teams.

1. Dynamic provisioning of service instances: enables apps teams to create service
instances that adhere to company policy. Apps teams can create instances on-demand as needed.

1. Seamless integration of almost any service, cloud-based or on-prem, into Tanzu Application Platform
with minimal configuration overhead: provides a near-limitless range of services to help boost
developer productivity.

## <a id="getting-started"></a> Getting started

If this is your first time working with services on Tanzu Application Platform,
you might want to start with
[Claim services on Tanzu Application Platform](../getting-started/claim-services.hbs.md) and
[Consume services on Tanzu Application Platform](../getting-started/consume-services.hbs.md)
in the getting started guide.
These guides run through the basics, after which you can return here to the Services Toolkit
component documentation to continue your services journey on Tanzu Application Platform.

## <a id="organization"></a>How this documentation is organized

The Services Toolkit component documentation consists of the following sections that relate to what
you are want to achieve:

- [Concepts](concepts/index.hbs.md): To gain a deeper understanding of Services Toolkit.
- [Tutorials](tutorials/index.hbs.md): To learn through following examples.
- [How-to guides](how-to-guides/index.hbs.md): To find a set of steps to solve a specific problem.
- [Reference material](reference/index.hbs.md): To find specific information such as Services Toolkit's
APIs, the Tanzu Service CLI plug-in, and troubleshooting information.

Tutorials and concepts are of most relevance when studying, while how-to guides and reference material
are of most use while working.

The following is a selection of useful topics on offer:

**For apps teams:**

- Tutorial: [Working with Bitnami Services](tutorials/working-with-bitnami-services.hbs.md)

**For ops teams:**

- Tutorial: [Setup Dynamic Provisioning of Service Instances](tutorials/setup-dynamic-provisioning.hbs.md)
- Tutorial: [Integrating Cloud Services (AWS, Azure, GCP, etc.) into Tanzu Application Platform](tutorials/integrate-cloud-services.hbs.md)
- How-to guide: [Configure Dynamic Provisioning of AWS RDS Service Instances](how-to-guides/dynamic-provisioning-rds.hbs.md)

**For everyone:**

- Concept: [Four Levels of Service Consumption in Tanzu Application Platform](concepts/service-consumption.hbs.md)
