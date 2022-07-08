# Observability and Troubleshooting

This section outlines observability and troubleshooting methods and issues for using the Supply Chain Security Tools - Scan components.

## <a id="observability"></a>Observability

The scans will run inside a k8s Job where the Job creates a Pod. Both the Job and Pod will be cleaned up automatically after completion.

Before applying a new scan, you can set a watch on the Jobs, Pods, SourceScans, Imagescans to observe their progression:
```console
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

## <a id="troubleshooting"></a>Troubleshooting

### <a id="debugging-commands"></a>Debugging commands

Run the following commands to get more logs and details on the errors around scanning. The Jobs and Pods will only persist for a predefined amount of seconds before getting deleted. (`deleteScanJobsSecondsAfterFinished` is the tap pkg variable that defines this)

####  <a id="debugging-scan-pods"></a> Debugging Scan Pods
Run the following to get error logs from a pod when scan pods are in a failing state:
```console
kubectl logs <scan-pod-name> -n <DEV-NAMESPACE>
```
See [here](https://jamesdefabia.github.io/docs/user-guide/kubectl/kubectl_logs/) for more details on debugging k8s pods.

The following is an example of a successful scan run output:
```yaml
scan:
  cveCount:
    critical: 20
    high: 120
    medium: 114
    low: 9
    unknown: 0
  scanner:
    name: Grype
    vendor: Anchore
    version: v0.37.0
  reports:
  - /workspace/scan.xml
eval:
  violations:
  - CVE node-fetch GHSA-w7rc-rwvf-8q5r Low
store:
  locations:
  - https://metadata-store-app.metadata-store.svc.cluster.local:8443/api/sources?repo=hound&sha=5805c6502976c10f5529e7f7aeb0af0c370c0354&org=houndci
```
A scan run that had an error would mean one of the init containers: scan-plugin, metadata-store-plugin, compliance-plugin, summary, or any other additional containers had a failure.

To inspect for a specific init container in a pod:
```console
kubectl logs <scan-pod-name> -n <DEV-NAMESPACE> -c <init-container-name>
```
See [here](https://kubernetes.io/docs/tasks/debug/debug-application/debug-init-containers/) for debug init container tips.

####  <a id="debug-source-image-scan"></a> Debugging SourceScan and ImageScan

To retrieve status conditions of an SourceScan and ImageScan run the following:
```console
kubectl describe sourcescan <sourcescan> -n <DEV-NAMESPACE>
```
```console
kubectl describe imagescan <imagescan> -n <DEV-NAMESPACE>
```

Under `Status.Conditions`, for a condition look at the "Reason", "Type", "Message" values that use the keyword "Error" to investigate issues.

#### <a id="debug-scanning-in-supplychain"></a> Debugging Scanning within a SupplyChain

See [here](../cli-plugins/apps/debug-workload.md) for tanzu workload commands for tailing build and runtime logs and getting workload status and details.


#### <a id="view-scan-controller-manager-logs"></a> Viewing the Scan-Controller manager logs
To retrieve scan-controller manager logs:
```console
kubectl -n scan-link-system logs -f deployment/scan-link-controller-manager -c manager
```

### <a id="restarting-deployment"></a> Restarting Deployment

If you encounter an issue with the scan-link controller not being able to start, run the following to restart the deployment to see if it's reproducible or flaking upon starting:
```console
kubectl rollout restart deployment scan-link-controller-manager -n scan-link-system
```

### <a id="troubleshooting-issues"></a> Troubleshooting issues

#### <a id="miss-img-ps"></a> Missing target image pull secret

Scanning an image from a private registry requires an image pull secret to exist in the Scan CR's namespace and be referenced as `grype.targetImagePullSecret` in `tap-values.yaml`. See [Installing the Tanzu Application Platform Package and Profiles](../install.md) for more information.

If a private image scan is triggered and the secret is not configured, the scan job will fail with the error as follows:

```console
Job.batch "scan-${app}-${id}" is invalid: [spec.template.spec.volumes[2].secret.secretName: Required value, spec.template.spec.containers[0].volumeMounts[2].name: Not found: "registry-cred"]
```

#### <a id="disable-scst-store"></a> Disable Supply Chain Security Tools - Store

Supply Chain Security Tools - Store is a prerequisite for installing Supply Chain Security Tools - Scan.
If you choose to install without the Supply Chain Security Tools - Store,  you need to edit the
configurations to disable the Store:

  ```yaml
  ---
  metadataStore:
    url: ""
  ```

  Install the package with the edited configurations by running:

  ```console
  tanzu package install scan-controller \
    --package-name scanning.apps.tanzu.vmware.com \
    --version VERSION \
    --namespace tap-install \
    --values-file tap-values.yaml
  ```

#### <a id="incompatible-syft-schema-version"></a> Resolving Incompatible Syft Schema Version

  You might encounter the following error:

  ```console
  The provided SBOM has a Syft Schema Version which doesn't match the version that is supported by Grype...
  ```

  This means that the Syft Schema Version from the provided SBOM doesn't match the version supported by the installed grype-scanner. There are two different methods to resolve this incompatibility issue:

  - (Preferred method) Install a version of [Tanzu Build Service](../tanzu-build-service/tbs-about.md) that provides an SBOM with a compatible Syft Schema Version.
  - Deactivate the `failOnSchemaErrors` in `grype-values.yaml` (see [installation steps](install-scst-scan.md)). Although this change bypasses the check on Syft Schema Version, it does not resolve the incompatibility issue and produces a partial scanning result.

    ```yaml
    syft:
      failOnSchemaErrors: false
    ```
