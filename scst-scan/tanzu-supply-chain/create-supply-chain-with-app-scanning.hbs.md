# Create a Supply Chain that uses SCST - Scan 2.0 with a Component

This topic tels you how to create a Tanzu Supply Chain with SCST - Scan 2.0, which replaces the previous solution for Supply Chain Choreographer for Tanzu.

## <a id="prerequisites"></a> Prerequisites

- Tanzu Supply Chain packages

  - [Tanzu Supply Chain packages](../../supply-chain/platform-engineering/how-to/installing-supply-chain/install-authoring-profile.hbs.md#tsc-packages)
  - [Managed Resource Controller](../../supply-chain/platform-engineering/how-to/installing-supply-chain/about.hbs.md)

- Tanzu Supply Chain components

  - [Source](../../supply-chain/reference/catalog/about.hbs.md#source-git-provider)
  - [Buildpack](../../supply-chain/reference/catalog/about.hbs.md#buildpack-build)
  - [Trivy Scanning](../../supply-chain/reference/catalog/about.hbs.md#trivy-image-scan)

- Tanzu Application Platform packages

  - [SCST - Scan 2.0](../install-app-scanning.hbs.md)
  - [Tekton](../../tekton/install-tekton.hbs.md)

- Tanzu CLI plug-ins

  - Tanzu Workload CLI plug-in
  - Tanzu Supply Chain CLI plug-in

For more information see, [Install the Tanzu Supply Chain CLI plug-ins](../../supply-chain/platform-engineering/how-to/install-the-cli.hbs.md).

## <a id="supply-chain-scan-2-0"></a> Create a Supply Chain with SCST - Scan 2.0 and a Component

This section tells you how to create a supply chain with SCST - Scan 2.0 by using either a [Trivy Supply Chain Component](./setup-supply-chain-component.hbs.md#install-trivy-sc) or a [Custom Scanning Component](./setup-supply-chain-component.hbs.md#customize-scan-component).

Using Trivy Supply Chain Component
:  Complete the following steps:

    1. Initialize Tanzu Supply Chain by running:

      ```console
      tanzu supplychain init --group example.com
      ```

      Example output:

      ```console
      $ tanzu supplychain init --group example.com
      Initializing group example.com
      Creating directory structure
      ├─ supplychains/
      ├─ components/
      ├─ pipelines/
      ├─ tasks/
      └─ config.yaml

      Writing group configuration to config.yaml
      ```

    2. Generate a Supply Chain by running:

      ```console
      tanzu supplychain generate --kind TrivySC \
      --description Trivy \
      --component source-git-provider-1.0.0 \
      --component buildpack-build-1.0.0 \
      --component trivy-image-scan-1.0.0
      ```

      Example output:

      ```console
      $ tanzu supplychain generate --kind TrivySC \
        --description Trivy \
        --component source-git-provider-1.0.0 \
        --component buildpack-build-1.0.0 \
        --component trivy-image-scan-1.0.0

      ✓ Successfully fetched all component dependencies
      Created file supplychains/trivysc.yaml
      Created file components/buildpack-build-1.0.0.yaml
      Created file components/source-git-provider-1.0.0.yaml
      Created file components/trivy-image-scan-1.0.0.yaml
      Created file pipelines/buildpack-build.yaml
      Created file pipelines/source-git-provider.yaml
      Created file pipelines/trivy-image-scan-v2.yaml
      Created file tasks/calculate-digest.yaml
      Created file tasks/check-builders.yaml
      Created file tasks/prepare-build.yaml
      Created file tasks/source-git-check.yaml
      Created file tasks/source-git-clone.yaml
      Created file tasks/store-content-oci.yaml
      ```

Using Custom Scanning Component
: Complete the following steps:

    1. Initialize Tanzu Supply Chain by running:

        ```console
        tanzu supplychain init --group example.com
        ```

        Example output:

        ```console
        $ tanzu supplychain init --group example.com
        Initializing group example.com
        Creating directory structure
        ├─ supplychains/
        ├─ components/
        ├─ pipelines/
        ├─ tasks/
        └─ config.yaml

        Writing group configuration to config.yaml
        ```

    2. Generate supply chain by running:

        ```console
        tanzu supplychain generate --kind CUSTOM-KIND-WORKLOAD \
        --description DESCRIPTION-OF-SCANNER \
        --component source-git-provider-1.0.0 \
        --component buildpack-build-1.0.0 \
        --component SCANNING-COMPONENT-NAME
        ```

        Where `SCANNING-COMPONENT-NAME` is the name of the [Custom Scanning Component](./setup-supply-chain-component.hbs.md#customize-scan-component).

For more information about how to construct a Supply Chain by using the Tanzu CLI, see [Construct a Supply Chain using the CLI](../../supply-chain/platform-engineering/how-to/supply-chain-authoring/construct-with-cli.hbs.md).

For more details about how to create a Supply Chain, see [Build your first Supply Chain](../../supply-chain/platform-engineering/tutorials/my-first-supply-chain.hbs.md).

## <a id="apply-supply-chain"></a> Apply Supply Chain

Generating the supply chain created the following directory structure:

  ```console
  ├─ supplychains/
  ├─ components/
  ├─ pipelines/
  ├─ tasks/
  ```

Apply these directories to the namespace where the workload will run by running.

```console
kubectl apply -R -f components -f supplychains -f tasks -f pipelines -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the same namespace where the intended workload will be.
