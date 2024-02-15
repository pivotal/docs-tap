# Create a Supply Chain that uses SCST - Scan 2.0 with a Component

This topic covers how to create a Tanzu Supply Chain with App Scanning which replaces the previous
solution for Supply Chains Choreographer for Tanzu.

## <a id="prerequisites"></a> Prerequisites

This section describes what dependencies are needed to create and run a Tanzu Supply Chain Workload.

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

## <a id="supply-chain-scan-2.0"></a> Create a supply chain with SCST - Scan 2.0 

This section describes how to create a supply chain with SCST - Scan 2.0 and one of these components:

- [Trivy Supply Chain Component](./setup-supply-chain-component.hbs.md#install-trivy-sc)
- [Customized Scanning Component](./setup-supply-chain-component.hbs.md#customize-scan-component).

### <a id="scan-2.0-and-trivy"></a> Create a supply chain with SCST - Scan 2.0 and Trivy Supply Chain Component

Create a supply chain with SCST - Scan 2.0 and [Trivy Supply Chain Component](./setup-supply-chain-component.md#install-trivy-sc) using the Tanzu Cartographer Wizard:

  ```console
  tanzu cartographer supply-chain wizard --name trivy-supply-chain-1.0.0 \
  --description Trivy \
  --developer-interface-group example.com \
  --developer-interface-kind TrivySC \
  --developer-interface-version v1alpha1 \
  --stages source-git-provider-1.0.0 \
  --stages buildpack-build-1.0.0 \
  --stages trivy-image-scan-0.0.1 \
  --file trivy-supply-chain.yaml
  ```

#### <a id="scan-2.0-and-custom-scanning"></a> Create a supply chain with SCST - Scan 2.0 and Custom Scanning Component

Create a supply chain with SCST - Scan 2.0 and the Custom Scanning Component. See [Create a Custom Scanning Component](./setup-supply-chain-component.hbs.md#customize-scan-component):

  ```console
  tanzu cartographer supply-chain wizard --name SCANNER-supply-chain-1.0.0 \
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
  `SCANNING-COMPONENT-NAME` is the name of the [custom scanning component](./setup-supply-chain-component.md#customize-scan-component).
  `SCANNER` is the name of the scanner from the [custom scanning component](./setup-supply-chain-component.md#customize-scan-component).

**Note** For more details about how to construct a Supply Chain using the Tanzu CLI, see [Construct a Supply Chain using the CLI](../supply-chain/platform-engineering/how-to/supply-chain-authoring/construct-with-cli.hbs.md)

#### <a id="apply-supply-chain"></a> Apply supply chain

  ```console
  kubectl apply -f SUPPLYCHAIN-YAML -n DEV-NAMESPACE
  ```

  Where:

  `SUPPLYCHAIN-YAML` is the supply chain YAML created in the previous step.
  `DEV-NAMESPACE` is the same namespace where the intended workload will be.
