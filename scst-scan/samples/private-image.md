# Sample private image scan
This example will perform a scan against an image located in a private registry.

## Define the resources
Create `sample-image-source-scan.yaml` and ensure you enter a valid docker config.json value in the secret:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: image-secret
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <~/.docker/config.json base64 data>

---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageScan
metadata:
  name: sample-image-source-scan
spec:
  registry:
    image: <url of an image in a private registry>
  scanTemplate: private-image-scan-template
```

## (Optional) Set up a watch
Before deploying, set up a watch in another terminal to see things process which will be quick.
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](../observing.md).

## Deploy the [][]esources
```bash
kubectl apply -f sample-image-source-scan.yaml
```

## View the scan results
Once the scan has completed, perform:
```bash
kubectl describe imagescan sample-image-source-scan
```
and notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](../results.md).

## Clean up
```bash
kubectl delete -f sample-image-source-scan.yaml
```

## View vulnerability reports
See [Viewing Vulnerability Reports](../viewing-reports.md) section
