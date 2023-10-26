# Tanzu Developer Portal Configurator Concepts

This topic gives you conceptual overviews of how Tanzu Developer Portal Configurator works.

## <a id="customize"></a> Overview of how to customize your portal

![Tanzu Developer Portal customization flowchart. It starts with installing Tanzu Application Platform and finishes with portal deployment.](images/tdp-install-flowchart.png)

To use your customized portal with all the runtime configuration values used in your pre-built
version:

1. Install a working installation of Tanzu Application Platform with a working instance of the
   pre-built Tanzu Developer Portal.
1. Prepare your Configurator buildtime configuration file.
1. Prepare your Configurator workload definition YAML.
1. Submit your Configurator workload definition YAML to your supplychain.
1. After the image is built, retrieve your customized Tanzu Developer Portal image from your
   supplychain deliverables.
1. To run your customized portal, prepare a ytt overlay to replace the pre-built Tanzu Developer Portal
   in Tanzu Application Platform with your customized version. For more information about ytt, see the
   [Carvel documentation](https://carvel.dev/ytt/).
1. Apply the ytt overlay to your cluster.

## <a id="buildtime-and-runtime"></a> Overviews of buildtime configuration and runtime configuration

The following sections describe the differences between buildtime configuration and runtime
configuration.

### <a id="runtime"></a> Runtime configuration

Runtime configuration refers to the values that you use to configure your existing portal image.
You provide these values in `tap-values.yaml` when you install and run your portal.
Runtime configuration values can include:

- The name of your portal
- Integrations (GitHub or GitLab keys, identity provider configuration, and so on)
- The locations of any catalogs on GitHub or GitLab
- Security credentials
- Configuration made available by any Tanzu Developer Portal plug-in wrappers

### <a id="buildtime"></a> Buildtime configuration

Buildtime configuration refers to the values that you pass to Configurator to generate a new portal
image. This configuration consists of a list of Tanzu Developer Portal plug-in wrappers and any
default runtime configuration for the portal image.

## <a id="configurator"></a> Tanzu Developer Portal Configurator

Tanzu Developer Portal Configurator is the image that contains everything necessary to build a
customized version of Tanzu Developer Portal.

Configurator includes a templated version of Tanzu Developer Portal, an internal registry of Tanzu
Developer Portal plug-ins wrappers, and tools to enable the build process to incorporate external
plug-ins.

![Diagram of Tanzu Developer Portal Configurator, the included internal plug-in registry, and the customization process.](images/configurator-internal-external-plugins.png)

## <a id="wrappers"></a> Tanzu Developer Portal plug-in wrappers

While Backstage uses [Backstage plug-ins](https://backstage.io/plugins/) to enable the user to
customize functions, Tanzu Developer Portal uses Tanzu Developer Portal plug-in wrappers to do the
same thing.

A Tanzu Developer Portal plug-in wrapper is simply a Backstage plug-in wrapped in a small amount of
code to facilitate easy integration into Configurator and Tanzu Developer Portal.

### <a id="plug-ins"></a> Internal plug-in wrappers and external plug-in wrappers

Internal Tanzu Developer Portal plug-in wrappers are included inside the Tanzu Developer Portal
Configurator image. These include:

- Tanzu Developer Portal plug-in wrappers specifically built for Tanzu Application Platform
- Tanzu Developer Portal plug-in wrappers for core [Backstage](https://backstage.io) plug-ins

External Tanzu Developer Portal plug-in wrappers are not in the Tanzu Developer Portal Configurator
image. They are hosted in, and installed, from an external registry, such as [npmjs.com](https://www.npmjs.com/).
External Tanzu Developer Portal plug-in wrappers can include custom functions or wrap existing
[third-party Backstage plug-ins](https://backstage.io/plugins/).

### <a id="surfaces-and-wrappers"></a> Tanzu Developer Portal plug-in wrapper surfaces

Tanzu Developer Portal plug-in wrapper surfaces are the mechanism that allows Tanzu Developer Portal
plug-in wrappers to change the behavior of the portal.

When adding a Backstage plug-in to an instance of Backstage, code modifications are required. Rather
than editing code, Tanzu Developer Portal exposes extension points where Tanzu Developer Portal
plug-in wrappers can inject code. These extension points are known as surfaces.

The pre-built version of Tanzu Developer Portal has several surfaces to edit existing functions,
including:

- Allowing new items to be added to the sidebar
- Adding new routes, such as `https://YOUR_PORTAL_URL/plugin`
- The ability to appear as a Catalog Overview tab

This pattern of exposing surfaces where Tanzu Developer Portal plug-in wrappers can inject new
behavior is not limited to what is offered in the pre-built version of Tanzu Developer Portal.

This pattern can also be applied on top of Tanzu Developer Portal plug-in wrappers themselves. This
allows for one Tanzu Developer Portal plug-in wrapper to build on top of another Tanzu Developer
Portal plug-in wrapper.
