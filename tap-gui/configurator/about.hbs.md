# Overview of Configurator

The Tanzu Developer Portal (formerly named Tanzu Application Platform GUI) Configurator tool enables
you to add functions (plug-ins) to Tanzu Developer Portal, turning it into a customized portal.

## <a id="diff"></a> Differences between the pre-built Tanzu Developer Portal and a customized portal

Tanzu Application Platform comes with a pre-built version of Tanzu Developer Portal.
The portal uses the Backstage open-source framework and includes the core capability of Backstage
(Software Catalog, TechDocs, API Docs, Templates/Accelerators, and Kubernetes).

The Backstage framework enables you to enhance your portal's capabilities by adding
functions as plug-ins. For more information about Backstage, see the
[Backstage documentation](https://backstage.io/docs/overview/what-is-backstage/).

Any portal owner can create two types of Backstage plug-ins:

- Custom plug-ins, which are for organization-specific needs
- Community plug-ins, which are for common needs and are made publicly available to Backstage adopters

The operator might choose to just use the pre-built Tanzu Developer Portal that includes all the core
functions of Backstage as well as all the integrations with Tanzu Application Platform.
Alternatively, the operator might choose to customize Tanzu Developer Portal as needed by using the
Configurator tool.

## <a id="how-it-works"></a> How Configurator works

Configurator takes the list of the Backstage plug-ins that you want to integrate into your
Tanzu Developer Portal. With that plug-in list, Configurator generates a developer portal customized
to your specifications. VMware has built automation to simplify integrating the plug-ins.

With these new plug-ins the maintenance of a customized portal remains similar to that of a pre-built
Tanzu Developer Portal, handled by the automation of Tanzu Application Platform.

## <a id="next-steps"></a> Next steps

See [Tanzu Developer Portal Configurator Concepts](concepts.hbs.md) or skip straight to
[Building your Customized Tanzu Developer Portal with Configurator](building.hbs.md)