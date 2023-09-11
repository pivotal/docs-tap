# Configure a ImageVulnerabilityScan for Grype

Below is a sample ImageVulnerabilityScan (IVS) that utilizes Grype to scan a targeted image and push the results to the specified registry location.
For addtional details about the IVS specification, refer to [Configuration Options](../scst-scan-ivs-create-your-own.html#configuration-options-1).

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: grype-ivs
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

- `TARGET-IMAGE` is the image to be scanned.  Digest must be specified.
- `GRYPE-SCANNER-IMAGE` is the image containing the Grype CLI. For example, `anchore/grype:latest` For additional publicly available Grype images refer to [DockerHub](https://hub.docker.com/r/anchore/grype/tags). For more information on the usage of the Grype CLI, refer to the [Grype documentation](https://github.com/anchore/grype#getting-started).
