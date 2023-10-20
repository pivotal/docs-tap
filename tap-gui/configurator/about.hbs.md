# Overview of Configurator

The Tanzu Developer Portal Configurator tool allows you to add custom functionality to Tanzu Developer Portal.

## <a id="diff"></a> Differences between the pre-built Tanzu Developer Portal and a customized portal

Tanzu Application Platform has a pre-built version of Tanzu Developer Portal.
You might choose to use this pre-built Tanzu Developer Portal that includes all the core functions of Backstage
(Software Catalog, TechDocs, API Docs, Templates/Accelerators, and Kubernetes) as well as all the integrations with
Tanzu Application Platform.
Alternatively, you might choose to customize Tanzu Developer Portal as needed by using the Configurator tool to add
additional TPD plug-in wrappers.

## TPD plug-in wrappers

Tanzu Developer Portal is built using the
[Cloud Native Computing Foundation's](https://www.cncf.io/) project [Backstage](https://backstage.io/).
While Backstage uses [Backstage plug-ins](https://backstage.io/plugins/) to allow the user to customize functionality,
Tanzu Developer Portal uses TPD plug-in wrappers to accomplish the same thing.
A TPD plug-in wrapper is simply a Backstage plug-in, wrapped small amount of code to facilitate easy integration into
the Configurator and Tanzu Developer Portal.

## <a id="how-it-works"></a> How Configurator works

Configurator takes a list of TDP plug-ins wrappers that you want to integrate into your Tanzu Developer Portal.
With that plug-in list, Configurator generates a portal customized to your specifications.

With these new plug-ins the maintenance of a customized portal remains similar to that of a pre-built
Tanzu Developer Portal, handled by the automation of Tanzu Application Platform.

## <a id="next-steps"></a> Next steps

* It is recommended you familiarize yourself with the [Tanzu Developer Portal Configurator Concepts](concepts.hbs.md) if
you plan on using the Configurator
* To see what TPD plug-in wrappers are currently available for use, checkout the
[list of TDP plug-in wrappers](tdp-plug-in-wrapper-list.hbs.md)
* When you are ready to start building your customized portal, follow the steps outlined in
[Building your Customized Tanzu Developer Portal with Configurator](building.hbs.md)
* To learn how to create your own TDP plug-in wrapper of an existing Backstage plug-in, see the
[Creating a TPD plugin wrapper tutorial](creating-a-tdp-plugin-wrapper.hbs.md)
* For more information about how to create Backstage plug-ins, checkout the
[Backstage plug-in documentation](https://backstage.io/docs/plugins/)