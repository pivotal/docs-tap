# Overview of Configurator

The Tanzu Developer Portal Configurator tool allows you to add custom functions to Tanzu Developer
Portal.

## <a id="diff"></a> Differences between the pre-built Tanzu Developer Portal and a customized portal

Tanzu Application Platform (commonly known as TAP) has a pre-built version of Tanzu Developer
Portal. The pre-built Tanzu Developer Portal includes all the core functions of Backstage
(software catalog, TechDocs, API Docs, templates, accelerators, and Kubernetes).

You can choose to use just the pre-built Tanzu Developer Portal and the integrations with
Tanzu Application Platform.

Alternatively, you can customize Tanzu Developer Portal as needed by using the Configurator tool to
add additional Tanzu Developer Portal plug-in wrappers.

## <a id="plug-in-wrappers"></a> Tanzu Developer Portal plug-in wrappers

Tanzu Developer Portal is built using the [Cloud Native Computing Foundation's](https://www.cncf.io/)
project [Backstage](https://backstage.io/).

While Backstage offers [Backstage plug-ins](https://backstage.io/plugins/) for adding custom
functions, Tanzu Developer Portal uses plug-in wrappers to accomplish the same thing.
A Tanzu Developer Portal plug-in wrapper is simply a Backstage plug-in that is wrapped in a small
amount of code to make integrating with Configurator and Tanzu Developer Portal easier.

## <a id="how-it-works"></a> How Configurator works

Configurator takes a list of Tanzu Developer Portal plug-ins wrappers that you want to integrate
with your Tanzu Developer Portal. With that plug-in list, Configurator generates a portal customized
to your specifications.

With these new plug-ins, maintaining a customized portal remains similar to maintaining a pre-built
Tanzu Developer Portal. Tanzu Application Platform automation handles the maintenance.

## <a id="next-steps"></a> Next steps

- Learn the [Tanzu Developer Portal Configurator concepts](concepts.hbs.md).

- See the [list of Tanzu Developer Portal plug-in wrappers](tdp-plug-in-wrapper-list.hbs.md)
  currently available for use.

- When you are ready to build your customized portal, see
  [Building your Customized Tanzu Developer Portal with Configurator](building.hbs.md).

- Learn how to
  [create your own Tanzu Developer Portal plug-in wrapper](create-plug-in-wrapper.hbs.md) of
  an existing Backstage plug-in.

- For more information about how to create Backstage plug-ins, see the
  [Backstage plug-in documentation](https://backstage.io/docs/plugins/).
