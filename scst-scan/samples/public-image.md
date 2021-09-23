# Running a Sample Public Image Scan
This example will perform a scan against a public image of `nginx:1.16`.

## Define the Resource
Create `public-image-example.yaml`:
```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageScan
metadata:
  name: public-image-example
spec:
  registry:
    image: "nginx:1.16"
  scanTemplate: public-image-scan-template
```

## (Optional) Setup a Watch
Before deploying, set up a watch in another terminal to see things process... it will be quick!
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](../observing.md).

## Deploy the Resources
```bash
kubectl apply -f public-image-example.yaml
```

## See the Results
Once the scan has completed, perform:
```bash
kubectl describe imagescan public-image-example
```
and notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](../results.md).

## Clean Up
```bash
kubectl delete -f public-image-example.yaml
```
