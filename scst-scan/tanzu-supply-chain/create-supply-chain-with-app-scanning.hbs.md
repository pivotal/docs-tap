# Create a Supply Chain that uses SCST - Scan 2.0 with a Component

This topic covers how to create a Tanzu Supply Chain with App Scanning which replaces the previous
solution for Supply Chains Choreographer for Tanzu.

## <a id="prerequisites"></a> Prerequisites

This section describes what dependencies are needed to create and run a Tanzu Supply Chain Workload.

[Tanzu Cartographer CLI Plug-in](../../install-tanzu-cli.hbs.md)

The following installed packages are required:

- [Supply Chain](../../supply-chain/platform-engineering/how-to/installing-supply-chain/about.hbs.md)
- [Supply Chain Catalog](../../supply-chain/platform-engineering/how-to/installing-supply-chain/about.hbs.md)
- [Managed Resource Controller](../../supply-chain/platform-engineering/how-to/installing-supply-chain/about.hbs.md)
- [Source](../../supply-chain/reference/catalog/about.hbs.md#source-git-provider)
- [Buildpack](../../supply-chain/reference/catalog/about.hbs.md#buildpack-build)
- [Trivy Scanning](../../supply-chain/reference/catalog/about.hbs.md#trivy-image-scan)
- [SCST - Scan 2.0](../install-app-scanning.hbs.md)
- [Tekton](../../tekton/install-tekton.hbs.md)

## <a id="supply-chain-scan-2.0"></a> Create Supply Chain with SCST - Scan 2.0 and Component

This section covers how to create a supply chain with SCST - Scan 2.0 with either a [Trivy Supply Chain Component](./setup-supply-chain-component.hbs.md#install-trivy-sc) or a [Customized Scanning Component](./setup-supply-chain-component.hbs.md#customize-scan-component)


### <a id="scan-2.0-and-trivy"></a> Create Supply Chain with SCST - Scan 2.0 and Trivy Supply Chain Component

Create a Supply Chain with SCST - Scan 2.0 and installed [Trivy Supply Chain Component](./setup-supply-chain-component.hbs.md#install-trivy-sc) using Tanzu Cartographer Wizard:

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

### <a id="scan-2.0-and-custom-scanning"></a> Create Supply Chain with SCST - Scan 2.0 and Custom Scanning Component

Create a Supply Chain with SCST - Scan 2.0 and the Custom Scanning Component created in the
component [page](./setup-supply-chain-component.hbs.md#customize-scan-component):

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

  * `SCANNING-COMPONENT-NAME` is the name of the [Customized Scanning Component](./setup-supply-chain-component.hbs.md#customize-scan-component).
  * `SCANNER` is the name of the scanner from the [Customized Scanning Component](./setup-supply-chain-component.hbs.md#customize-scan-component).

**Note**: For more details about how to construct a Supply Chain using the Tanzu CLI, see [Construct a Supply Chain using the CLI](../../supply-chain/platform-engineering/how-to/supply-chain-authoring/construct-with-cli.hbs.md)

## <a id="apply-supply-chain"></a> Apply Supply Chain

  ```console
  kubectl apply -f SUPPLYCHAIN-YAML -n DEV-NAMESPACE
  ```

  Where:

  * `SUPPLYCHAIN-YAML` is the supply chain yaml created in the previous step.
  * `DEV-NAMESPACE` is the same namespace where the intended workload will be.
