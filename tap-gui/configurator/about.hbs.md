# Configurator Overview

This topic tells you about the Tanzu Developer Portal configurator tool, including an overview of
this functionality and the use cases it enables.

## <a id="diff"></a> Differences Between Customized Portals and the Pre-Built Tanzu Developer Portal

Tanzu Application Platform comes with a pre-built version of Tanzu Developer Portal.
The portal uses the Backstage open-source framework and includes the core capability of Backstage
(Software Catalog, TechDocs, API Docs, Templates/Accelerators, and Kubernetes).

Backstage framework offers an opportunity to enhance your portal's capabilities by adding
functionality as plugins. Backstage plugins could be created by any portal owner to capture some
company-specific functionality (i.e., custom plugins), or they could be solving common use cases and
made publicly available to Backstage adopters (i.e., community plugins). For more information,
please refer to [Backstage documentation](https://backstage.io/docs/overview/what-is-backstage).

The operator may choose to use the pre-built Tanzu Developer Portal that includes all the core
functionality of Backstage as well as all the integrations with the Tanzu Application Platform.
Alternatively, the operator may choose to make as many customizations to the Tanzu Developer Portal as needed by leveraging
the Configurator tool.

Customized Portal can include additional portal functionality that we shall refer to as "plugins".
VMware has built automation to simplify the process of plugin integration into your Backstage-based
portal. In the next sections, we shall describe how to add new functionality (i.e., community or
custom plugins) to your Tanzu Developer Portal. This automation is made possible via a tool we shall
refer to as configurator.

With that new functionality, we make sure that the maintenance of the Customized Portal remains
similar to that of a pre-built Tanzu Developer Portal, handled by the automation of the Tanzu
Application Platform.

## <a id="overview"></a> Tanzu Developer Portal configurator overview

Your VMware Tanzu Application Platform comes with a pre-built Tanzu Developer Portal that has all
the necessary functionality to give you the best user experience with the core Backstage
functionality and with the Tanzu Application Platform capabilities.

To add extra functions to your developer portal, see .
<!-- insert xref -->

### <a id="how-does-it-work"></a>How does the configurator work?

The configurator tools takes the list of the Backstage plugins that you prefer to integrate into
your Tanzu Developer Portal. With that plugin list, the tool generates a customized developer portal
to your specifications.

For more information on the steps to use the configurator tool, please refer to
[Building your Customized Tanzu Developer Portal with the Configurator](building.hbs.md).

## <a id="next-steps"></a>Next steps

Learn more about:

- [Tanzu Developer Portal Configurator Concepts](concepts.hbs.md)
- [Building your Customized Tanzu Developer Portal with the Configurator](building.hbs.md)
- [Running your Customized Tanzu Developer Portal](running.hbs.md)
- [External-plugins](external-plugins.hbs.md)
- [Surface API reference](surface-api-reference.hbs.md)
- [Troubleshooting](troubleshooting.hbs.md)