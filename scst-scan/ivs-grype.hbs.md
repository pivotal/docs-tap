# Configure a ImageVulnerabilityScan for Grype

This topic gives you an example of how to configure an ImageVulnerabilityScan (IVS) for Grype.

## <a id="example"></a> Example ImageVulnerabilityScan

This section contains a sample IVS that uses Grype to scan a targeted image and push the results to the specified registry location.
For information about the IVS specification, see [Configuration Options](ivs-create-your-own.hbs.md#img-vuln-config-options).

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: grype-ivs
  annotations:
    app-scanning.apps.tanzu.vmware.com/scanner-name: Grype
spec:
  image: TARGET-IMAGE
  scanResults:
    location: registry/project/scan-results
  serviceAccountNames:
    publisher: publisher
    scanner: scanner
  steps:
  - name: grype
    image: GRYPE-SCANNER-IMAGE
    args:
    - -o
    - cyclonedx-json
    - registry:$(params.image)
    - --file
    - /workspace/scan-results/scan.cdx.json
    env:
    - name: GRYPE_ADD_CPES_IF_NONE
      value: "false"
    - name: GRYPE_EXCLUDE
    - name: GRYPE_SCOPE
```

Where:

- `TARGET-IMAGE` is the image to scan. You must specify digest.
- `GRYPE-SCANNER-IMAGE` is the image containing the Grype CLI. For example, `anchore/grype:latest`. For information about publicly available Grype images, see [DockerHub](https://hub.docker.com/r/anchore/grype/tags). For more information about using the Grype CLI, see the [Grype documentation](https://github.com/anchore/grype#getting-started).

## <a id="grype-db-requirement"></a> Grype database size requirement

The recommended `storageSize` for Grype scans is 4Gi due to the size of the Grype database. If the `storageSize` is not sufficient, you might encounter an error indicating insufficient space when initializing the database in the scan pod.

Update the `app-scanning-values-file.yaml` for the `app-scanning.apps.tanzu.vmware.com` package to change the default `storageSize`. See [installation documentation](./install-app-scanning.hbs.md#install-scst-app-scanning).

```console
scans:
  workspace:
    storageSize: 4Gi
```

If you do not want to set a default `storageSize` by updating the  `app-scanning-values-file.yaml`, you must specify the `spec.workspace.size` when creating each standalone ImageVulnerabilityScan or embedded the ImageVulnerabilityScan in a [ClusterImageTemplate](./clusterimagetemplates.hbs.md#create-clusterimagetemplate).

>**Warning** As a publicly maintained image that is built outside of VMware build systems, the image might not meet the security standards VMware established. Ensure that you review the image before use to ensure that it meets your organizations security and compliance policies.
For the publicly available Grype scanner CLI image, CLI commands and parameters used are accurate at the time of documentation.