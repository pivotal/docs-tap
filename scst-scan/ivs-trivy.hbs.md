# Configure an ImageVulnerabilityScan for Trivy

To configure an ImageVulnerabilityScan for Trivy, use the following ImageVulnerabilityScan configuration:

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: trivy-ivs
spec:
  image: nginx@sha256:... # The image to be scanned. Digest must be specified.
  scanResults:
    location: registry/project/scan-results
  serviceAccountNames:
    publisher: publisher
    scanner: scanner
  steps:
  - name: trivy
    image: TRIVY-SCANNER-IMAGE
    command: ["trivy"]
    args:
    - image
    - --format
    - cyclonedx
    - --output
    - $(params.scan-results-path)/scan.cdx
    - --scanners
    - vuln
    - $(params.image)
```

Where:

- `TRIVY-SCANNER-IMAGE` is the Trivy Scanner image used to run Trivy scans. For information about Trivy images, see [Trivy documentation](https://github.com/aquasecurity/trivy).