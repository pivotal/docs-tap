# Sample private image scan for Supply Chain Security Tools - Scan

This example describes how you can perform a scan against an image located in a private registry for SCST - Scan.

## <a id="define-resources"></a>Define the resources

### <a id="set-up-target-secret"></a> Set up target image pull secret

1. Confirm that target image secret is configured. This is completed during Tanzu Application Platform installation. If the target image secret exists, see [Create the private image scan](./private-image.hbs.md#create-the-private-image-scan).
2. If the target image secret was not configured, create a secret containing the credentials used to pull the target image you want to scan. For information about secret creation, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-secret-by-providing-credentials-on-the-command-line).

  ```
  kubectl create secret docker-registry TARGET-REGISTRY-CREDENTIALS-SECRET \
    --docker-server=YOUR-REGISTRY-SERVER \
    --docker-username=YOUR-NAME \
    --docker-password=YOUR-PASSWORD \
    --docker-email=YOUR-EMAIL \
    -n DEV-NAMESPACE
  ```

  Where:

  - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that is created.
  - `DEV-NAMESPACE` is the developer namespace where the scanner is installed.
  - `YOUR-REGISTRY-SERVER` is the registry server you want to use.
  - `YOUR-NAME` is the name associated with the secret. 
  - `YOUR-PASSWORD` is the password associated with the secret. 
  - `YOUR-EMAIL` is the email associated with the secret. 

1. Update the `tap-values.yaml` file to include the name of secret created earlier.

  ```yaml
  grype:
    namespace: "MY-DEV-NAMESPACE"
    targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
  ```

1. Upgrade Tanzu Application Platform with the modified `tap-values.yaml` file.

  ```console
  tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP-VERSION}  --values-file tap-values.yaml -n tap-install
  ```

  Where `TAP-VERSION` is the Tanzu Application Platform version.

### <a id="create-private-image-scan"></a>Create the private image scan

Create `sample-private-image-scan.yaml`:

```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ImageScan
metadata:
  name: sample-private-image-scan
spec:
  registry:
    image: IMAGE-URL
  scanTemplate: private-image-scan-template
```

Where `IMAGE-URL` is the URL of an image in a private registry.

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

Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.

>**Note** The `Status.Conditions` includes a `Reason: JobFinished` and
`Message: The scan job finished`. See [Viewing and Understanding Scan Status
Conditions](../results.md).

## <a id="clean-up"></a>Clean up

```console
kubectl delete -f sample-private-image-scan.yaml -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.

## <a id="view-vuln-reports"></a>View vulnerability reports

After completing the scans, [query the Supply Chain Security Tools - Store](../../cli-plugins/insight/query-data.md) to view your vulnerability results.
