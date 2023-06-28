# Verifying Scanning without Supply Chain Integration

Once you have built an ImageVulnerabilityScan template to bring your own scanner, it is important to validate the functionality to verify the integration is working correctly.

In order to ensure the scan integration is working correctly so that downstream servers such as AMR Observer, TAP GUI, and the insight CLI can use scan results, follow these steps:

1.  Verify that a triggered scan is completed successfully
2.  Retrieve the scan results from the registry
3.  Validate that the scan results are in a supported format

## <a id="trigger-observe-scanning"></a> Trigger and Observe Scanning

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

## <a id="retrieve-scan-results"></a> Retrieve scan results

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
