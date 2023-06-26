# Adding App-Scanning to Default Test and Scan Supply Chain

The default configuration for Out of the Box Supply Chain - Testing and Scanning uses Supply Chain Security Tools - Scan 1.0. This topic describes how to enable Supply Chain Security Tools - Scan 2.0 with the out of the box test + scan supply chain, as well as bring your own scanner by creating an ImageVulnerabilityScan template.

## <a id="prerequisites"></a> Prerequisites

Before you can integrate Supply Chain Security Tools - Scan 2.0 with the out of the box supply chain:
- Select an ImageVulnerabilityScan. You can either bring your own scanner by creating a custom ImageVulnerabilityScan template or select from the provided samples:
  - [Create your own ImageVulnerabilityScan to bring your own scanner](./ivs-create-your-own.hbs.md)
  - [ImageVulnerabilityScan samples](./ivs-custom-samples.hbs.md)
- [Create a ClusterImageTemplate](./clusterimagetemplates.hbs.md). Incorporate the ImageVulnerabilityScan template into a ClusterImageTemplate.

## <a id="integration-with-supply-chain"></a> Integration with OOTB Supply Chain

1. After completing the prerequisites, update your `tap-values.yaml` file to specify the ClusterImageTemplate. For example:

    ```yaml
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: CLUSTERIMAGETEMPLATE
    ```

    Where `CLUSTERIMAGETEMPLATE` is the name of the ClusterImageTemplate with the embedded ImageVulnerabilityScan using the scanner of your choice.

1. Update your Tanzu Application Platform installation by running:

  ```console
  tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
  ```

  Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

## <a id="verifying-scanning-different-contexts"></a> Verify Scanning in different contexts

To verify scanning integration:

1. Create an ImageVulnerabilityScan either as a standalone or in the context of a Supply Chain:

    - [Create ImageVulnerabilityScan](./integrate-app-scanning.hbs.md#verifying-scanning-without-supply-chain-integration)
    - [Create ImageVulnerabilityScan in context of Supply Chain Workload](./integrate-app-scanning.hbs.md#verifying-scanning-with-supply-chain-integration)

2. [Retrieve scan results](./integrate-app-scanning.hbs.md#retrieve-scan-results)

### <a id="verifying-scanning-with-supply-chain-integration"></a> Verifying Scanning with Supply Chain Integration

1. Create a sample workload with a pre-built image by using the `tanzu apps workload create` command:

  ```console
  tanzu apps workload create WORKLOAD-NAME \
    --app APP-NAME \
    --type TYPE \
    --image IMAGE \
    --namespace DEV-NAMESPACE
  ```

  Where:

  - `WORKLOAD-NAME` is the name you choose for your workload.
  - `APP-NAME` is the name of your app.
  - `TYPE` is the type of your app.
  - `IMAGE` is the container image that contains the app you want to deploy.
  - `DEV-NAMESPACE` is the name of the developer namespace where scanning occurs.

  **Note**:
  - For more info on how to use the Tanzu CLI workload creation see [Create a Workload](../cli-plugins/apps/create-workload.hbs.md) documentation.
  - Specifying the `--image` flag sets the `spec.image` of the workload so that it is taken up by the `scanning-image-scan-to-url` supply chain. Currently SCST - Scan 2.0 only performs image scanning. There are specific requirements for pre-built images. For more details see [Configure your workload to use a prebuilt image](../scc/pre-built-image.hbs.md)
