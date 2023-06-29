## <a id="verifying-scanning-with-supply-chain-integration"></a> Verifying Scanning with Supply Chain Integration

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
