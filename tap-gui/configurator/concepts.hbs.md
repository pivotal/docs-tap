# Tanzu Developer Portal Configurator Concepts

This topic gives you conceptual overviews of how Tanzu Developer Portal Configurator works.

## <a id="customize"></a> Overview of how to customize your portal

![Tanzu Developer Portal customization flowchart, starting from installing Tanzu Application Platform and finishing with deploying a customized Tanzu Developer Portal.](images/tdp-install-flowchart.jpg)

To use your customized portal with all the runtime configuration values used in your pre-built
version:

1. Install a working installation of Tanzu Application Platform with a working instance of the
   pre-built Tanzu Developer Portal.
2. Prepare your Configurator buildtime configuration file.
3. Prepare your Configurator workload definition YAML.
4. Submit your Configurator workload definition YAML to your supplychain.
5. After the image is built, retrieve your customized Tanzu Developer Portal image from your
   supplychain deliverables.
6. To run your customized portal, prepare a ytt overlay to replace the pre-built Tanzu Developer Portal
   in Tanzu Application Platform with your customized version. For more information about ytt, see the
   [Carvel documentation](https://carvel.dev/ytt/).
7. Apply the ytt overlay to your cluster.

## <a id="buildtime-and-runtime"></a> Overviews of buildtime configuration and runtime configuration

The following sections describe the differences between buildtime configuration and runtime
configuration.

### <a id="buildtime"></a> Buildtime configuration

Buildtime configuration refers to the customization of how plug-ins are included in the
Tanzu Developer Portal image that you run on your Tanzu Application Platform cluster.

Configurator reads this buildtime configuration to help build your customized instance of
Tanzu Developer Portal. Buildtime configuration values can include:

- Which plug-ins are included in your portal
- How plug-ins are linked on the sidebar for your portal
- Which cards are available and how they appear in the software catalog

### <a id="runtime"></a> Runtime configuration

Runtime configuration refers to the values that you use to configure the portal. You provide them in
your `tap-values.yaml` file when you install and run your portal. Runtime configuration values can
include:

- The name of your portal
- Integrations (GitHub or GitLab keys, identity provider configuration, and so on)
- The locations of any catalogs on GitHub or GitLab
- Security overrides
- Showing or hiding the included Tanzu Application Platform plug-ins

## <a id="foundation"></a> Tanzu Developer Portal Configurator Foundation and Plugins

The Tanzu Developer Portal Configurator Foundation is the image that contains everything necessary to build a customized version of Tanzu Developer Portal. This foundation includes the templated Tanzu Developer Portal, an internal registry of Tanzu Develoepr Portal plugins, as well as the necessary tooling to allow for the build process to incorporate external plugins.

![Tanzu Developer Portal Foundation and inlcuded internal plugin registry and the customization process.](images/foundation-internal-external-plugins.jpg)

### <a id="plugins"></a> Internal versus external plugins

The following sections describe the differences between the **internal** plugins that are included as part of the Tanzu Develoepr Portal Configurator and the **external** plugins that are added in from external registries.

- #### <a id="internal-plugins"></a> Internal plugins

   Internal plugins are ones that are included inside the Tanzu Developer Portal Configurator Foundation image. These include Tanzu Application Platform Plugins as well as [Backstage](https://backstage.io) core plugins.

- #### <a id="external-plugins"></a> External plugins

   External plugins are any plugin that is **not** in the Tanzu Deverloper Portal Configurator Foundation image. These can include custom plugins as well as [3rd-party Backstage plugins](https://backstage.io/plugins)

### <a id="plugin-surfaces-and-wrappers"></a> Plugin Surfaces and Wrappers

![Tanzu Developer Portal Foundation and inlcuded internal plugin registry and the customization process.](images/plugin-surfaces-and-wrappers.jpg)

#### <a id="plugin-surfaces"></a> Plugin Surfaces

Tanzu Developer Portal Configurator introduces the idea of **Plugin Surfaces**. A Surface is a discreet capability that a plugin provides. This could include
- The ability to show-up on the sidebar
- The ability to be accessed by URL (e.g. https://YOUR_PORTAL_URL/plugin)
- The ability to show-up as a Catalog Overview tab

#### <a id="plugin-wrappers"></a> Plugin Wrappers

Tanzu Developer Portal Configurator also introduces the idea of **Plugin Wrappers**. A Wrapper is a method of exposing a plugins's [surfaces](#plugin-surfaces) to the Tanzu Developer Portal Configurator so that that plugin can be integrated into a customized portal. These wrappers are in-fact plugins on their own but also `import` a reference to the actual underlying plugin itself.