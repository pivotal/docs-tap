# Running a Sample Private Image Scan
This example will perform a scan against a private image of `spring-petclinic` located in the `dev.registry.pivotal.io` registry. The image is publicly available at [Docker Hub](https://hub.docker.com/r/arey/springboot-petclinic/) should you need to upload it to a private registry you have access to.

## Define the Resources
Create `private-image-example.yaml` and ensure you enter a valid docker config.json value in the secret:
```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: image-secret
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: # ~/.docker/config.json base64 data

---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageScan
metadata:
  name: private-image-example
spec:
  registry:
    image: "dev.registry.pivotal.io/vse-dev/spring-petclinic@sha256:128e38c1d3f10401a595c253743bee343967c81e8f22b94e30b2ab8292b3973f"
  scanTemplate: private-image-scan-template
```

## (Optional) Set Up a Watch
Before deploying, set up a watch in another terminal to see things process which will be quick.
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](../observing.md).

## Deploy the Resources
```bash
kubectl apply -f private-image-example.yaml
```

## View the Scan Results
Once the scan has completed, perform:
```bash
kubectl describe imagescan private-image-example
```
and notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](../results.md).

## Clean Up
```bash
kubectl delete -f private-image-example.yaml
```

## View Vulnerability Reports
See [Viewing Vulnerability Reports](../viewing-reports.md) section