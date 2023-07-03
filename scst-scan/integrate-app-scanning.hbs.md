# Add App Scanning to default test and scan supply chains

This topic tells you how to enable SCST - Scan 2.0 with the out of the box test and scan supply chain, and bring your own scanner by creating an ImageVulnerabilityScan template. The default configuration for Out of the Box Supply Chain - Testing and Scanning uses Supply Chain Security Tools (SCST) - Scan 1.0. 

## <a id="prerequisites"></a> Prerequisites

Before you integrate SCST - Scan 2.0 with the out of the box supply chain:

- Select an `ImageVulnerabilityScan`. You can bring your own scanner by creating a custom ImageVulnerabilityScan template or use a sample:
  - [Create your own ImageVulnerabilityScan to bring your own scanner](./ivs-create-your-own.hbs.md)
  - [ImageVulnerabilityScan samples](./ivs-custom-samples.hbs.md)
- [Create a ClusterImageTemplate](./clusterimagetemplates.hbs.md). Incorporate the ImageVulnerabilityScan template into a ClusterImageTemplate.

## <a id="integration-supply-chain"></a> Integrate with OOTB Supply Chain

To integrate App Scanning with an OOTB supply chain:

1. Update your `tap-values.yaml` file to specify the ClusterImageTemplate. For example:

    ```yaml
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: CLUSTERIMAGETEMPLATE
    ```

    Where `CLUSTERIMAGETEMPLATE` is the name of the ClusterImageTemplate with the embedded ImageVulnerabilityScan that uses your scanner.

2. Update your Tanzu Application Platform installation by running:

  ```console
  tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
  ```

  Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

## <a id="verifying-scanning-different-contexts"></a> Verify scanning in different contexts

To verify scanning integration:

1. Create an ImageVulnerabilityScan either as a standalone or in the context of a Supply Chain:

    - [Create ImageVulnerabilityScan](./integrate-app-scanning.hbs.md#verifying-scanning-without-supply-chain-integration)
    - [Create ImageVulnerabilityScan in context of Supply Chain Workload](./integrate-app-scanning.hbs.md#verifying-scanning-with-supply-chain-integration)

2. [Retrieve scan results](./integrate-app-scanning.hbs.md#retrieve-scan-results)

### <a id="verifying-scanning-sc"></a> Verifying Scanning with Supply Chain Integration

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

Specifying the `--image` flag sets the `spec.image` of the workload so that it is taken up by the `scanning-image-scan-to-url` supply chain. For information about how to use the Tanzu CLI workload creation, see [Create a Workload](../cli-plugins/apps/create-workload.hbs.md) documentation.

>**Note** SCST - Scan 2.0 only performs image scanning. There are specific requirements for pre-built images. See [Configure your workload to use a prebuilt image](../scc/pre-built-image.hbs.md)
