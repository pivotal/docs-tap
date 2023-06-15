# Integration Guide

This topic describes how to integrate Supply Chain Security Tools - Scan 2.0 with the Out of the Box Supply Chain.

## <a id="prerequisites"></a> Prerequisites

Before you can integrate Supply Chain Security Tools - Scan 2.0 with the Out of the Box Supply Chain:
- Create an ImageVulnerabilityScan. You can either integrate your scanner or select from the provided samples:
  - [Customize your own ImageVulnerabilityScan](./ivs-create-your-own.hbs.md)
  - [ImageVulnerabilityScan samples](./ivs-custom-samples.hbs.md)
- [Create a ClusterImageTemplate](./clusterimagetemplates.hbs.md). The previously created ImageVulnerabilityScan needs to be incorporated into a ClusterImageTemplate.

## <a id="integration-with-supply-chain"></a> Integration with OOTB Supply Chain

1. After completing the prerequisites, update your `tap-values.yaml` file to specify the ClusterImageTemplate. For example:

    ```yaml
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: CLUSTERIMAGETEMPLATE
    ```

    Where `CLUSTERIMAGETEMPLATE` is the ClusterImageTemplate with the embdedded ImageVulnerabilityScan using the scanner of your choice.

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

### <a id="verifying-integration"></a> Verifying Scanning without Supply Chain Integration

This section describes how to verify scanning and retrieve scan results.
#### <a id="trigger-observe-scanning"></a> Trigger and Observe Scanning

To verify that you can scan an image using your ImageVulnerabilityScan:

1. Deploy your ImageVulnerabilityScan to the cluster by running:

    ```console
    kubectl apply -f image-vulnerability-scan.yaml -n DEV-NAMESPACE
    ```
   - Where `DEV-NAMESPACE` is the name of the developer namespace you want to use.

2. Child resources are created.

    - View the child PipelineRun, TaskRuns, and pods
      ```console
      kubectl get -l imagevulnerabilityscan,pipelinerun,taskrun,pod -n DEV-NAMESPACE
      ```

3. When the scanning completes, the status is shown. Specify `-o wide` to see the digest of the image scanned and the location of the published results.

    ```console
    kubectl get imagevulnerabilityscans -n DEV-NAMESPACE -o wide

    NAME                 SCANRESULT                           SCANNEDIMAGE          SUCCEEDED   REASON
    generic-image-scan   registry/project/scan-results@digest nginx:latest@digest   True        Succeeded

    ```

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
  - Specifying the `--image` flag configures the workload to skip the source scanning step by using the specified pre-built image. Currently SCST - Scan 2.0 only performs image scanning. There are specific requirements for pre-built images. For more details see [Configure your workload to use a prebuilt image](../scc/pre-built-image.hbs.md)


### <a id="retrieve-scan-results"></a> Retrieve scan results

Scan results are uploaded to the container image registry as an [imgpkg](https://carvel.dev/imgpkg/) bundle.
To retrieve a vulnerability report:

1. Retrieve the result location from the ImageVulnerabilityScan CR Status
   ```console
   SCAN_RESULT_URL=$(kubectl get imagevulnerabilityscan my-scan -n DEV-NAMESPACE -o jsonpath='{.status.scanResult}')
   ```

1. Download the bundle to a local directory and list the content
   ```console
   imgpkg pull -b $SCAN_RESULT_URL -o scan-results/
   ls scan-results/
   ```