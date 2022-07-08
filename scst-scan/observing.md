# Observing and troubleshooting

This section shows how to observe the scan job and get logs.

## <a id="watch-inflight-jobs"></a>Watching in-flight jobs
The scan will run inside the job, which creates a Pod. Both the job and Pod will be cleaned up automatically after completion. You can set a watch on the job and Pod before applying a new scan to observe the job deployment.

```console
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

## <a id="troubleshooting"></a>Troubleshooting
If you run into any problems or face non-expected behavior, you can always address the logs to get more feedback.

```console
kubectl -n scan-link-system logs -f deployment/scan-link-controller-manager -c manager
```

### <a id="miss-img-ps"></a>Missing target image pull secret

Scanning an image from a private registry requires an image pull secret to exist in the Scan CR's namespace and be referenced as `grype.targetImagePullSecret` in `tap-values.yaml`. See [Installing the Tanzu Application Platform Package and Profiles](../install.md) for more information.

If a private image scan is triggered and the secret is not configured, the scan job will fail with the error as follows:

```console
Job.batch "scan-${app}-${id}" is invalid: [spec.template.spec.volumes[2].secret.secretName: Required value, spec.template.spec.containers[0].volumeMounts[2].name: Not found: "registry-cred"]
```


### <a id="disable-scst-store"></a> Disable Supply Chain Security Tools - Store

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

### <a id="incompatible-scan-policy"></a> Resolving Incompatible Scan Policy
  If your scan policy appears to not be enforced, it may be because the Rego file defined in the scan policy is incompatible with the scanner that is being used. For example, the Grype Scanner outputs in the CycloneDX XML format while the Snyk Scanner outputs SPDX JSON.

  See [Install Snyk Scanner](install-snyk-integration.md#a-idsnyk-policya-create-a-scan-policy-for-outputs-in-the-spdx-json-format) for an example of a ScanPolicy formatted for the SPDX JSON structure.