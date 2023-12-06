# Overview of Configurator

Use the Tanzu Developer Portal Configurator tool to add custom functions to Tanzu Developer Portal.

## <a id="diff"></a> Differences between the pre-built Tanzu Developer Portal and a customized portal

Tanzu Application Platform (commonly known as TAP) has a pre-built version of Tanzu Developer
Portal. The pre-built Tanzu Developer Portal includes all the core functions of Backstage
(software catalog, TechDocs, API Docs, templates, accelerators, and Kubernetes).

You can choose to use just the pre-built Tanzu Developer Portal and the integrations with Tanzu
Application Platform. Alternatively, you can customize Tanzu Developer Portal for your needs by
using the Configurator tool to add additional Tanzu Developer Portal plug-ins.

## <a id="plug-ins"></a> Tanzu Developer Portal plug-ins

Tanzu Developer Portal is built using the [Cloud Native Computing Foundation's](https://www.cncf.io/)
project [Backstage](https://backstage.io/).

Backstage offers [Backstage plug-ins](https://backstage.io/plugins/) for adding custom
functions, and Tanzu Developer Portal does the same.
A Tanzu Developer Portal plug-in is simply a Backstage plug-in that is wrapped in a small
amount of code to make integrating with Configurator and Tanzu Developer Portal easier.

## <a id="how-it-works"></a> How Configurator works

Configurator takes a list of Tanzu Developer Portal plug-ins that you want to integrate with your
Tanzu Developer Portal. With that plug-in list, Configurator generates a portal customized to your
specifications.

With these new plug-ins, maintaining a customized portal remains similar to maintaining a pre-built
Tanzu Developer Portal. Tanzu Application Platform automation handles the maintenance.

## <a id="next-steps"></a> Next steps

- Learn the [Tanzu Developer Portal Configurator concepts](concepts.hbs.md).

- See the [list of Tanzu Developer Portal plug-ins](dependency-version-refs.hbs.md#external-tdp-plugins)
  currently available for use.

- When you are ready, [build your customized Tanzu Developer Portal with Configurator](building.hbs.md).

- Learn how to
  [create your own Tanzu Developer Portal plug-in](create-plug-in-wrapper.hbs.md) of
  an existing Backstage plug-in.

- For more information about how to create Backstage plug-ins, see the
  [Backstage plug-in documentation](https://backstage.io/docs/plugins/).
