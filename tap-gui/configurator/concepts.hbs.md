# Tanzu Developer Portal Configurator Concepts

This topic tells you about the concepts that illustrate the design and purpose of
Tanzu Developer Portal Configurator.

## Tanzu Developer Portal Configurator Customization Process

![Tanzu Developer Portal Customization Process Flowchart](./images/tdp-install-flowchart.jpg)

1. Install and validate that you have a working installation of Tanzu Application Platform with a
   working instance of the pre-built Tanzu Developer Portal.
2. Prepare your Tanzu Developer Portal Configurator's buildtime configuration file.
3. Prepare your Tanzu Developer Portal Configurator Workload definition YAML.
4. Submit your Tanzu Developer Portal Configurator Workload definition YAML to your supplychain
5. After the image has been built, you'll retrieve you customized Tanzu Developer Portal image from
   your supplychain deliverables.
6. To run your customized portal, you'll need to prepare a [`ytt`](https://carvel.dev/ytt/)
   overlay to replace the pre-built Tanzu Developer Portal in Tanzu Application Platform with your
   customized version.
7. You'll apply this [`ytt`](https://carvel.dev/ytt/) overlay to your cluster.
8. You can now use your customized portal with all the runtime configuration values used in your
   pre-built version.

## Buildtime Configuration versus Runtime Configuration

### Buildime Configuration

Buildtime configuration refers to the customization of how plugins are included in the
Tanzu Developer Portal image that you run on your Tanzu Application Platform cluster.

This buildtime configuration is read by the Tanzu Developer Portal Configurator and results in your
built customized instance of Tanzu Developer Portal. These values can include:

- Which plug-ins are included in your portal
- How plug-ins are linked on the sidebar for your portal
- Which cards are available and how they appear in the Software Catalog

### <a id=runtime></a> Runtime Configuration

Runtime configuration refers to the values that you're used to configuring and providing in your
`tap-values.yaml` file when your install and run your Tanzu Developer Portal. This can include:

- The name of your portal
- Integrations (GitHub/Gitlab keys, Identity provider configuration, etc.)
- The locations of any catalogs on Git
- Security overrides
- Showing/Hiding the included Tanzu Application Platform plugins
