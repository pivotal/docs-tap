# Adding External Plugins to your Tanzu Developer Portal via the Customizer

## External Plugin Requirements Review
As discussed in [Build your Customized Tanzu Developer Portal with Configurator](./building.hbs.md#prereqs), you'll need the following in order to include any type of external plugin:

- Ensure that your additional plug-ins are in an NPM registry. This registry can be your own
  private registry or a plug-in registry if you intend to use a third-party or community plug-in.

> **Important** Tanzu Application Platform plug-ins cannot be removed from customized portals.
> However, if you decide you want to hide them, you can use the
> [runtime configuration](concepts.hbs.md#runtime) options in your `tap-values.yaml` file.