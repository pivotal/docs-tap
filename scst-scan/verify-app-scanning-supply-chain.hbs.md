# Verify scanning with Supply Chain integration

This topic tells you how to verify scanning with Supply Chains.

## <a id="create-workload"></a> Create a workload

1. Create a sample workload with a pre-built image by using the `tanzu apps workload create` command:

    ```console
    tanzu apps workload create WORKLOAD-NAME \
      --app APP-NAME \
      --git-repo GIT-REPO \
      --git-branch GIT-BRANCH \
      --type TYPE \
      --namespace DEV-NAMESPACE
    ```

    Where:

    - `WORKLOAD-NAME` is the name you choose for your workload.
    - `APP-NAME` is the name of your app.
    - `GIT-REPO` is the Git repository from which the workload is created.
    - `GIT-BRANCH` is the branch in a Git repository from where the workload is created.
    - `TYPE` is the type of your app.
    - `DEV-NAMESPACE` is the name of the developer namespace where scanning occurs.

**Note** For information about how to use the Tanzu CLI workload creation, see
[Create a Workload](../cli-plugins/apps/tutorials/create-update-workload.hbs.md).

## <a id="retrieve-scan-results"></a> Retrieve scan results

Scan results are uploaded to the container image registry as an [imgpkg](https://carvel.dev/imgpkg/) bundle.
To retrieve a vulnerability report:

1. Retrieve the result location from the ImageVulnerabilityScan CR Status:
   
   ```console
   SCAN_RESULT_URL=$(kubectl get imagevulnerabilityscan my-scan -n DEV-NAMESPACE -o jsonpath='{.status.scanResult}')
   ```

2. Download the bundle to a local directory and list the content:
   
   ```console
   imgpkg pull -b $SCAN_RESULT_URL -o scan-results/
   ls scan-results/
   ```
