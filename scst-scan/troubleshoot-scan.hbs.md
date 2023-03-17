# Troubleshooting Supply Chain Security Tools - Scan

## <a id="debugging-commands"></a> Debugging commands

Run these commands to get more logs and details about the errors around scanning. The taskruns and pods
persist for a predefined amount of seconds before getting deleted.
(`deleteScanJobsSecondsAfterFinished` is the tap pkg variable that defines this)

### <a id="debugging-scan-pods"></a> Debugging Scan pods

Run the following to get error logs from a pod when scan pods are in a failing state:

```console
kubectl logs scan-pod-name -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the name of the developer namespace you want to use.

See [here](https://jamesdefabia.github.io/docs/user-guide/kubectl/kubectl_logs/) for more details
about debugging Kubernetes pods.

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

A scan run that has an error means that one of the init containers: `scan-plugin`,
`metadata-store-plugin`, `compliance-plugin`, `summary`, or any other additional containers had a
failure.

To inspect for a specific init container in a pod:

```console
kubectl logs scan-pod-name -n DEV-NAMESPACE -c init-container-name
```

Where `DEV-NAMESPACE` is the name of the developer namespace you want to use.

See [Debug Init
Containers](https://kubernetes.io/docs/tasks/debug/debug-application/debug-init-containers/) in the
Kubernetes documentation for debug init container tips.

### <a id="debug-source-image-scan"></a> Debugging SourceScan and ImageScan

To retrieve status conditions of an SourceScan and ImageScan, run:

```console
kubectl describe sourcescan <sourcescan> -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the name of the developer namespace you want to use.

```console
kubectl describe imagescan <imagescan> -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the name of the developer namespace you want to use.

Under `Status.Conditions`, for a condition look at the "Reason", "Type", "Message" values that use
the keyword "Error" to investigate issues.

### <a id="debug-scanning-in-supplychain"></a> Debugging Scanning within a SupplyChain

See [here](../cli-plugins/apps/debug-workload.md) for Tanzu workload commands for tailing build and
runtime logs and getting workload status and details.

### <a id="view-scan-controller-manager-logs"></a> Viewing the Scan-Controller manager logs

To retrieve scan-controller manager logs:

```console
kubectl -n scan-link-system logs -f deployment/scan-link-controller-manager -c manager
```

## <a id="restarting-deployment"></a> Restarting Deployment

If you encounter an issue with the scan-link controller not starting, run the following to restart
the deployment to see if it's reproducible or flaking upon starting:

```console
kubectl rollout restart deployment scan-link-controller-manager -n scan-link-system
```

## <a id="troubleshooting-issues"></a> Troubleshooting issues

### <a id="troubleshooting-grype-in-airgap"></a> Troubleshooting Grype in Airgap Environments
For any issues with grype in airgap environments see [here](offline-airgap.hbs.md).

### <a id="miss-src-ps"></a> Missing target SSH secret

Scanning source code from a private source repository requires an SSH secret present in the
namespace and referenced as `grype.targetSourceSshSecret` in `tap-values.yaml`. See [Installing the
Tanzu Application Platform Package and Profiles](../install.md).

If a private source scan is triggered and the secret cannot be found, the scan pod includes a
`FailedMount` warning in Events with the message `MountVolume.SetUp failed for volume "ssh-secret" :
secret "secret-ssh-auth" not found`, where `secret-ssh-auth` is the value specified in
`grype.targetSourceSshSecret`.

### <a id="miss-img-ps"></a> Missing target image pull secret

Scanning an image from a private registry requires an image pull secret to exist in the Scan CRs
namespace and be referenced as `grype.targetImagePullSecret` in `tap-values.yaml`. See [Installing
the Tanzu Application Platform Package and Profiles](../install.md).

If a private image scan is triggered and the secret is not configured, the scan taskrun's pod's `step-scan-plugin` container fails with the error as follows:

```console
Error: GET https://dev.registry.tanzu.vmware.com/v2/vse-dev/spring-petclinic/manifests/sha256:128e38c1d3f10401a595c253743bee343967c81e8f22b94e30b2ab8292b3973f: UNAUTHORIZED: unauthorized to access repository: vse-dev/spring-petclinic, action: pull: unauthorized to access repository: vse-dev/spring-petclinic, action: pull
```

### <a id="deactivate-scst-store"></a> Deactivate Supply Chain Security Tools (SCST) - Store

SCST - Store is required to install SCST - Scan. If you install without the SCST - Store,
you must edit the configurations to deactivate the Store:

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

  This means that the Syft Schema Version from the provided SBOM doesn't match the version supported
  by the installed `grype-scanner`. There are two different methods to resolve this incompatibility
  issue:

  - (Preferred method) Install a version of [Tanzu Build
    Service](../tanzu-build-service/tbs-about.md) that provides an SBOM with a compatible Syft
    Schema Version.
  - Deactivate the `failOnSchemaErrors` in `grype-values.yaml`. See [Install Supply Chain Security
    Tools - Scan](install-scst-scan.md). Although this change bypasses the check on Syft Schema
    Version, it does not resolve the incompatibility issue and produces a partial scanning result.

    ```yaml
    syft:
      failOnSchemaErrors: false
    ```

### <a id="incompatible-scan-policy"></a> Resolving incompatible scan policy

If your scan policy appears to not be enforced, it might be because the Rego file defined in the
scan policy is incompatible with the scanner that is being used.
For example, the Grype Scanner outputs in the CycloneDX XML format while the Snyk Scanner outputs SPDX JSON.

See [Sample ScanPolicy for Snyk in SPDX JSON format](install-snyk-integration.md#snyk-scan-policy)
for an example of a ScanPolicy formatted for SPDX JSON.

### <a id="ca-not-found-in-secret"></a> Could not find CA in secret

If you encounter the following issue, it might be due to not exporting
`app-tls-cert` to the correct namespace:

```console
{"level":"error","ts":"2022-06-08T15:20:48.43237873Z","logger":"setup","msg":"Could not find CA in Secret","err":"unable to set up connection to Supply Chain Security Tools - Store"}
```

Configure `ns_for_export_app_cert` in your `tap-values.yaml`.

```yaml
metadata_store:
  ns_for_export_app_cert: "DEV-NAMESPACE"
```

Where `DEV-NAMESPACE` is the name of the developer namespace you want to use.

If there are multiple developer namespaces, use `ns_for_export_app_cert: "*"`.

### <a id="reporting-wrong-blob-url"></a> Blob Source Scan is reporting wrong source URL

A Source Scan for a blob artifact can cause reporting in the `status.artifact` and
`status.compliantArtifact` the wrong URL for the resource, passing the remote SSH URL instead of the
cluster local fluxcd one. One symptom of this issue is the `image-builder` failing with a `ssh:// is
an unsupported protocol` error message.

You can confirm you're having this problem by running `kubectl describe` in the
affected resource and comparing the `spec.blob.url` value against the `status.artifact.blob.url`.
The problem occurs if they are different URLs. For example:

```console
kubectl describe sourcescan SOURCE-SCAN-NAME -n DEV-NAMESPACE
```

Where:

- `SOURCE-SCAN-NAME` is the name of the source scan you want to configure.
- `DEV-NAMESPACE` is the name of the developer namespace you want to use.
And compare the output:

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

**Workaround:** This problem happens in SCST - Scan `v1.2.0` when you use a Grype Scanner
ScanTemplates earlier than `v1.2.0`, because this is a deprecated path. To fix this problem, upgrade
your Grype Scanner deployment to `v1.2.0` or later. See [Upgrading Supply Chain Security Tools -
Scan](upgrading.md#upgrade-to-1-2-0) for step-by-step instructions.

### <a id="supply-chain-stops"></a> Resolving failing scans that block a Supply Chain

If the Supply Chain is not progressing due to CVEs found in either the SourceScan or ImageScan, see
the CVE triage workflow in [Triaging and Remediating CVEs](triaging-and-remediating-cves.hbs.md.

### <a id="gui-miss-policy"></a> Policy not defined in the Tanzu Application Platform GUI

If you encounter `No policy has been defined`, it might be because the Tanzu Application Platform
GUI is unable to view the Scan Policy resource.

Confirm that the Scan Policy associated with a SourceScan or ImageScan exists. For example, the
`scanPolicy` in the scan matches the name of the Scan Policy.

```console
kubectl describe sourcescan NAME -n DEV-NAMESPACE
kubectl describe imagescan NAME -n DEV-NAMESPACE
kubectl get scanpolicy NAME -n DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the name of the developer namespace you want to use.

Add the `app.kubernetes.io/part-of` label to the Scan Policy. See [Enable Tanzu Application Platform
GUI to view ScanPolicy
Resource](policies.hbs.md#gui-view-scan-policy).

### Lookup error when connecting to SCST - Store

If your scan pod is failing, you might see the following connection error in the logs:

```console
dial tcp: lookup metadata-store-app.metadata-store.svc.cluster.local on 10.100.0.10:53: no such host
```

A connection error while attempting to connect to the
local cluster URL causes this error. If this is a multicluster deployment, set the
`grype.metadataStore.url` property in your Build profile `values.yaml`. You must
set the ingress domain of SCST - Store which is deployed in the View cluster.
For information about this configuration, see [Install Build
profile](../scst-store/multicluster-setup.hbs.md#install-build-profile).

### Sourcescan error with SCST - Store endpoint without a prefix

If your Source Scan resource is failing, the status might show this error:

```console
Error: endpoint require 'http://' or 'https://' prefix
```

This is because the `grype.metadataStore.url` value in the Tanzu Application
Platform profile `values.yaml` was not configured with the correct prefix.
Verify that the URL starts with either `http://` or `https://`.

### <a id="deprecated-pre-v1.2-templates"></a> Deprecated pre-v1.2 templates

If the scan phase is in `Error` and the status condition message is:

```console
Summary logs could not be retrieved: . error opening stream pod logs reader: container summary is not valid for pod scan-grypeimagescan-sample-public-zmj2g-hqv5g
```

This error might be a consequence of using Grype Scanner ScanTemplates shipped with
SCST - Scan v1.1 or earlier. These ScanTemplates are deprecated and are not
supported in Tanzu Application Platform v1.4.0 and later.

There are two options to resolve this issue:

- Option 1: Upgrade to the latest Grype Scanner version. This automatically replaces the old ScanTemplates with the upgraded ScanTemplates.

- Option 2: Create a ScanTemplate. Follow the steps in [Create a scan template](create-scan-template.hbs.md).

### <a id="inc-cnfg-self-signed-cert"></a> Incorrectly configured self-signed certificate

The following error in the pod logs indicate that the self-signed certificate might be incorrectly
configured:

```console
x509: certificate signed by unknown authority
```

To resolve this issue, ensure that `shared.ca_cert_data` contains the required certificate. For an example of setting up the shared self-signed certificate, see [Build profile](../multicluster/reference/tap-values-build-sample.hbs.md).

For information about `shared.ca_cert_data`, see [View possible configuration settings for your package](../view-package-config.hbs.md).

### <a id="unable-to-pull-scanner-controller-images"></a> Unable to pull scan controller and scanner images from a specified registry

The `docker` field and related sub-fields by SCST - Scan Controller, Grype
Scanner, or Snyk Scanner are deprecated in Tanzu Application Platform v1.4.0.
Previously these text boxes might be used to populate the `registry-credentials`
secret. You might encounter the following error during installation:

```console
UNAUTHORIZED: unauthorized to access repository
```

The recommended migration path for users setting up their namespaces
manually is to add registry credentials to both the developer namespace and the
`scan-link-system` namespace, using these
[instructions](../set-up-namespaces.hbs.md).

>**Important** This step does not apply to users who used
`--export-to-all-namespaces` when setting up the Tanzu Application Platform
package repository.
### <a id="grype-db-not-available"></a> Grype database not available

Prior to running a scan, the Grype scanner downloads a copy of its database. If the database fails to download, the following log message might appear.

```console
Vulnerability DB [no update available] New version of grype is available: 0.50.2 [0000] WARN unable to check for vulnerability database update 1 error occurred: * failed to load vulnerability db: vulnerability database is corrupt (run db update to correct): database metadata not found: ~/Library/Caches/grype/db/3
```

To resolve this issue, ensure that Grype has access to its vulnerability database:

- If you have set up a [mirror](offline-airgap.hbs.md) of the vulnerability
  database, verify that it is populated and reachable.
- If you did not set up a mirror, Grype manages its database behind the scenes.
  Verify that the cluster has access to https://anchore.com/.

This issue is unrelated to Supply Chain Security Tools for Tanzu – Store.
