<h1>Tanzu Developer Portal Confgurator Concepts</h1>

<h2>Tanzu Developer Portal Configurator's Customization Process</h2>

![Tanzu Developer Portal Customization Process Flowchart](./images/tdp-install-flowchart.jpg)

1. Install and validate that you have working installation of Tanzu Application Platform with a working instance of the pre-built Tanzu Developer Portal.
2. Prepare your Tanzu Developer Portal Configurator's [buildtime](#buildtime) configuration file.
3. Prepare your Tanzu Developer Portal Configurator Workload definition YAML
4. Submit your Tanzu Developer Portal Configurator Workload definition YAML to your supplychain
5. Once the image has been built, you'll retrieve you customized Tanzu Developer Portal image from your supplychain deliverables.
6. In order to run your customized portal, you'll need to prepare a [`ytt`](https://carvel.dev/ytt/) overlay to replace the pre-built Tanzu Developer Portal in Tanzu Application Platform with your customized version.
7. You'll apply this [`ytt`](https://carvel.dev/ytt/) overlay to your cluster.
8. You can now use your customized portal with all the [runtime configuration](#runtime) values used in your pre-built version.


<h2><a id=buildtime></a>Buildtime Configuration Vs. Runtime Configuration</h2>

<h3>Buildime Configuration</h3>
Buildtime configuration refers to the customization of how plugins are included in the Tanzu Developer Portal image that you run on your Tanzu Application Platform cluster. Thus buildtime configuration is read by the Tanzu Developer Portal Configurator and results in your built customized instance of Tanzu Developer Portal. These values can include:

- Which Plugins are included in your portal
- How plugins are linked on the sidebar for your portal
- Which cards are available and how they appear in the Software Catalog

<h3><a id=runtime></a>Runtime Configuration</h3>
Runtime configuration refers to the values that you're used to configuring and providing in your `tap-values.yaml` file when your install and run your Tanzu Developer Portal. This can include:

- The name of your portal
- Integrations (Github/Gitlab keys, Identity provider configuration, etc.)
- The locations of any catalogs on Git
- Security overrides
- Showing/Hiding the included Tanzu Application Platform plugins
