# Configure a ImageVulnerabilityScan for Grype

To configure an ImageVulnerabilityScan for Grype, use the following ImageVulnerabilityScan configuration:

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: grype-ivs
spec:
  image: nginx@sha256:... # The image to be scanned. Digest must be specified.
  scanResults:
    location: registry/project/scan-results
  steps:
  - name: grype
    image: GRYPE-SCANNER-IMAGE
    args:
    - -o
    - cyclonedx
    - registry:$(params.image)
    - --file
    - /workspace/scan-results/scan.cdx
    env:
    - name: GRYPE_ADD_CPES_IF_NONE
      value: "false"
    - name: GRYPE_EXCLUDE
    - name: GRYPE_SCOPE
```

Where:

- `GRYPE-SCANNER-IMAGE` is the Grype scanner image. See [Grype documentation](https://github.com/anchore/grype#getting-started). For example, `image: anchore/grype` references the publicly available grype image from [DockerHub](https://hub.docker.com/r/anchore/grype/tags).
