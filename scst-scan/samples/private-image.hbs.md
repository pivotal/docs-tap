# Sample private image scan

This example performs a scan against an image located in a private registry.

## <a id="define-resources"></a>Define the resources

Create `sample-private-image-scan.yaml`:

```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ImageScan
metadata:
  name: sample-private-image-scan
spec:
  registry:
    image: IMAGE_URL
  scanTemplate: private-image-scan-template
```

Where `IMAGE_URL` is the URL of an image in a private registry.

> **Note** The private image scan assumes that the target image secret was configured during Tanzu Application Platform installation.

## <a id="set-up-watch"></a>(Optional) Set up a watch

Before deploying the resources to a user specified namespace, set up a watch in another terminal to view the progression:

```console
watch kubectl get sourcescans,imagescans,pods,taskruns,scantemplates,scanpolicies -n DEV-NAMESPACE
```
Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.

For more information, see [Observing and Troubleshooting](../observing.md).

## <a id="deploy-resources"></a>Deploy the resources

```console
kubectl apply -f sample-private-image-scan.yaml -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.

## <a id="view-scan-results"></a>View the scan results

When the scan completes, run:

```console
kubectl describe imagescan sample-private-image-scan -n DEV-NAMESPACE
```

Notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, see [Viewing and Understanding Scan Status Conditions](../results.md).

## <a id="clean-up"></a>Clean up

```console
kubectl delete -f sample-private-image-scan.yaml -n DEV-NAMESPACE
```

## <a id="view-vuln-reports"></a>View vulnerability reports

After completing the scans, [query the Supply Chain Security Tools - Store](../../cli-plugins/insight/query-data.md) to view your vulnerability results.
