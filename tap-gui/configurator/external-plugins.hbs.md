# Add external plug-ins to Tanzu Developer Portal

This topic tells you how to add external plug-ins to Tanzu Developer Portal.

## <a id="prereqs"></a> External plug-in prerequisite

As mentioned in [Build your Customized Tanzu Developer Portal with Configurator](building.hbs.md#prereqs),
to use any type of external plug-in, ensure that it is in the [npmjs.com](https://www.npmjs.com/)
registry.

> **Important** Tanzu Application Platform plug-ins cannot be removed from customized portals.
> However, if you decide you want to hide them, you can use the
> [runtime configuration](concepts.hbs.md#runtime) options in your `tap-values.yaml` file.