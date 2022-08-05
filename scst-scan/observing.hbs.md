# Observing and troubleshooting

This section shows how to observe the scan job and get logs.


## <a id="watch-inflight-jobs"></a> Watching in-flight jobs

The scan will run inside the job, which creates a Pod. Both the job and Pod will be cleaned up
automatically after completion.
You can set a watch on the job and Pod before applying a new scan to observe the job deployment.

```console
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```


## <a id="troubleshooting"></a> Troubleshooting

If you run into any problems or face non-expected behavior, you can always address the logs to get 
more feedback.

```console
kubectl -n scan-link-system logs -f deployment/scan-link-controller-manager -c manager
```

### <a id="miss-img-ps"></a> Missing target image pull secret

Scanning an image from a private registry requires an image pull secret to exist in the Scan CR's
namespace and be referenced as `grype.targetImagePullSecret` in `tap-values.yaml`.
See [Installing the Tanzu Application Platform Package and Profiles](../install.md) for more
information.

If a private image scan is triggered and the secret is not configured, the scan job will fail with
the error as follows:

```console
Job.batch "scan-${app}-${id}" is invalid: [spec.template.spec.volumes[2].secret.secretName: Required value, spec.template.spec.containers[0].volumeMounts[2].name: Not found: "registry-cred"]
```

### <a id="diasble-scst-store"></a> Disable Supply Chain Security Tools - Store

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

### <a id="incompatible-syft-schema-version"></a> Resolving Incompatible Syft Schema Version

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

### <a id="unable-to-decode-cyclonedx"></a> Resolving "Unable to decode cyclonedx"

Supply Chain Security Tools - Scan intermittently sets the phase of a scan to `Error` with the message `unable to decode cyclonedx`. To resolve this issue:

* If you’re applying the scan manually, you can delete the failed scan job and re-apply with `kubectl apply -f PATH-TO-IMAGESCAN-OR-SOURCESCAN -n DEV-NAMESPACE` to retrigger the scan.
* If this happens while running an out of the box Tanzu Application Platform Supply Chain, run `kubectl get imagescans -n WORKLOAD-NAMESPACE` or `kubectl get sourcescans -n WORKLOAD-NAMESPACE` to get the scan name. Delete the failed scan by running `kubectl delete IMAGESCAN-OR-SOURCESCAN SCAN-NAME -n WORKLOAD-NAMESPACE`. The Choreographer controller then recreates the scan.

### <a id="reporting-wrong-blob-url"></a> Blob Source Scan is reporting wrong source URL

  A Source Scan for a blob artifact can result in reporting the `status.artifact` and `status.compliantArtifact` for the wrong URL for the resource. This passes the remote SSH URL instead of the cluster local fluxcd URL. One symptom of this issue is the `image-builder` failing with a `ssh:// is an unsupported protocol` error message. 

  You can confirm you're having this problem running a `kubectl describe` in the affected resource and compare the `spec.blob.url` value against the `status.artifact.blob.url`. For example:

  ```console
  kubectl describe sourcescan <SOURCE-SCAN-NAME> -n <DEV-NAMESPACE>
  ```

  Compare the output:

  ```console
  ...
  spec:
    blob:
      ...
      url: http://source-controller.flux-system.svc.cluster.local./gitrepository/sample/repo/8d4cea98b0fa9e0112d58414099d0229f190f7f1.tar.gz
      ...
  status:
    artifact:
      blob:
        ...
        url: ssh://git@github.com:sample/repo.git
    compliantArtifact:
      blob:
        ...
        url: ssh://git@github.com:sample/repo.git
  ```

  **Workaround:** The following workarounds fix this issue:
  
    1. This problem is resolved in Supply Chain Security Tools - Scan `v1.2.0`. Upgrade your Supply Chain Security Tools - Scan and Grype Scanner deployment to version `v1.2.0` or later.
    2. Configure your SourceScan or Workload to connect to the repository by using HTTPS instead of using SSH.
    3. Edit the FluxCD GitRepository resource to not include the `.git` directory. 