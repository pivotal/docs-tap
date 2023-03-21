# Sample private image scan

This example performs a scan against an image located in a private registry.

## <a id="define-resources"></a>Define the resources

Create `sample-private-image-scan.yaml` and ensure you enter a valid docker config.json value in the secret:

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
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ImageScan
metadata:
  name: sample-image-source-scan
spec:
  registry:
    image: <url of an image in a private registry>
  scanTemplate: private-image-scan-template
```

Where `IMAGE_URL` is the URL of an image in a private registry.

> **Note** The private image scan assumes that the target image secret was configured during Tanzu Application Platform installation. If not, follow the [(Optional) Set up target image pull secret step](./private-image.hbs.md#set-up-target-image-pull-secret).

## <a id="set-up-target-image-pull-secret"></a>(Optional) Set up target image pull secret
1. Create a secret containing the credentials used to pull the target image you want to scan. For more information on secret creation see [Kubernetes docs](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-secret-by-providing-credentials-on-the-command-line).
  ```
  kubectl create secret docker-registry TARGET-REGISTRY-CREDENTIALS-SECRET \
    --docker-server=<your-registry-server> \
    --docker-username=<your-name> \
    --docker-password=<your-password> \
    --docker-email=<your-email>
  ```
  Where `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that is being created.

1. Update the `tap-values.yaml` file to include the name of secret created above.
  ```
  grype:
    namespace: "MY-DEV-NAMESPACE"
    targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
  ```
1. Perform an upgrade of Tanzu Application Platform with the modified `tap-values.yaml` file following [Upgrade instructions for Profile-based installation](../../upgrading.hbs.md#profile-based-instruct)

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
