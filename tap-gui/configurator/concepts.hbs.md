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
