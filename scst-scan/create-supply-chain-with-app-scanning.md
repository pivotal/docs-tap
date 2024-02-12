# Create a Supply Chain that uses SCST - Scan 2.0 with a Component

This topic covers how to create a Tanzu Supply Chain with App Scanning which replaces the previous solution for Supply Chains Choreographer for Tanzu.

## <a id="overview"></a> Overview

* [Prerequisities](./create-supply-chain-with-app-scanning.md#prerequisities)
* [Create Tanzu Supply Chain with SCST - Scan 2.0 and Component](./create-supply-chain-with-app-scanning.md#create-supply-chain-with-scst---scan-20-and-component)
  * [Create Supply Chain with SCST - Scan 2.0 and Trivy Supply Chain Component](./create-supply-chain-with-app-scanning.md#create-supply-chain-with-scst---scan-20-and-trivy-supply-chain-component)
  * [Create Supply Chain with SCST - Scan 2.0 and Custom Scanning Component](./create-supply-chain-with-app-scanning.md#create-supply-chain-with-scst---scan-20-and-custom-scanning-component)
  * [Apply Supply Chain](./create-supply-chain-with-app-scanning.md#apply-supply-chain)

### <a id="prerequisities"></a> Prerequisities

This sections covers what dependencies are needed in order to create and run a Tanzu Supply Chain Workload.

* Installed Packages:
  * Supplychain:
    * Supply Chain (supply-chain.apps.tanzu.vmware.com)
    * Supply Chain Catalog (supply-chain-catalog.apps.tanzu.vmware.com)
    * Managed Resource Controller (managed-resource-controller.apps.tanzu.vmware.com)
    * [Tekton](../tekton/install-tekton.hbs.md)
  * Components:
    * [Source](../supply-chain/reference/catalog/about.hbs.md#source-git-provider)
    * [Buildpack](../supply-chain/reference/catalog/about.hbs.md#buildpack-build)
    * [Trivy Scanning](../supply-chain/reference/catalog/about.hbs.md#trivy-image-scan)
  * Scanning:
    * [SCST - Scan 2.0](./install-app-scanning.hbs.md)
* [Tanzu Cartographer CLI Plugin](../install-tanzu-cli.hbs.md)

### <a id="create-supply-chain-with-scst-scan-2.0-and-component"></a> Create Supply Chain with SCST - Scan 2.0 and Component

This section covers how to create a supply chain with SCST - Scan 2.0 with either a [Trivy Supply Chain Component](./setup-supply-chain-component.md#install-trivy-supply-chain-component) or a [Customized Scanning Component](./setup-supply-chain-component.md#customize-scanning-component)

#### <a id="create-supply-chain-with-scst-scan-2.0-and-trivy-supply-chain-component"></a> Create Supply Chain with SCST - Scan 2.0 and Trivy Supply Chain Component

* Create a Supply Chain with SCST - Scan 2.0 and installed [Trivy Supply Chain Component](./setup-supply-chain-component.md#install-trivy-supply-chain-component) using Tanzu Cartographer Wizard:
  ```
  $ tanzu cartographer supply-chain wizard --name trivy-supply-chain-1.0.0 \
  --description Trivy \
  --developer-interface-group example.com \
  --developer-interface-kind TrivySC \
  --developer-interface-version v1alpha1 \
  --stages source-git-provider-1.0.0 \
  --stages buildpack-build-1.0.0 \
  --stages trivy-image-scan-0.0.1 \
  --file trivy-supply-chain.yaml
  ```

#### <a id="create-supply-chain-with-scst-scan-2.0-and-custom-scanning-component"></a> Create Supply Chain with SCST - Scan 2.0 and Custom Scanning Component

* Create a Supply Chain with SCST - Scan 2.0 and the Custom Scanning Component created in the component [page](./setup-supply-chain-component.md#customize-scanning-component):
  ```
  $ tanzu cartographer supply-chain wizard --name SCANNER-supply-chain-1.0.0 \
  --description <description of scanner> \
  --developer-interface-group example.com \
  --developer-interface-kind <custom Kind workload> \
  --developer-interface-version v1alpha1 \
  --stages source-git-provider-1.0.0 \
  --stages buildpack-build-1.0.0 \
  --stages SCANNING-COMPONENT-NAME \
  --file SCANNER-supply-chain.yaml
  ```
  Where:
  * SCANNING-COMPONENT-NAME is the name of the [custom scanning component](./setup-supply-chain-component.md#customize-scanning-component).
  * SCANNER is the name of the scanner from the [custom scanning component](./setup-supply-chain-component.md#customize-scanning-component).

**Note:** See Tanzu Supply Chain [docs](../supply-chain/platform-engineering/how-to/supply-chain-authoring/construct-with-cli.hbs.md) for more details on how to construct a Supply Chain using the CLI.

#### <a id="apply-supply-chain"></a> Apply Supply Chain

  ```
  $ kubectl apply -f <SUPPLYCHAIN-YAML> -n DEV-NAMESPACE
  ```
  Where:
  * SUPPLYCHAIN-YAML is the supply chain yaml created in the previous step.
  * DEV-NAMESPACE is the same namespace where the intended workload will be.
