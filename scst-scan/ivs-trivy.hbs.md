# Configure an ImageVulnerabilityScan for Trivy

Below is a sample ImageVulnerabilityScan (IVS) that utilizes Trivy to scan a targeted image and push the results to the specified registry location.
For addtional details about the IVS specification, refer to [Configuration Options](../scst-scan-ivs-create-your-own.html#configuration-options-1).

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: trivy-ivs
  annotations:
    app-scanning.apps.tanzu.vmware.com/scanner-name: Trivy
spec:
  image: TARGET-IMAGE
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
    - $(params.scan-results-path)/scan.cdx.json
    - --scanners
    - vuln
    - $(params.image)
```

Where
- `TARGET-IMAGE` is the image to be scanned.  Digest must be specified.
- `TRIVY-SCANNER-IMAGE` is the image containing the Trivy CLI. For example, `aquasec/trivy:0.44.1` For additional publicly available Trivy images, refer to [DockerHub](https://hub.docker.com/r/aquasec/trivy/tags). For more information on the usage of the Trivy CLI, refer to the [Trivy documentation](https://github.com/aquasecurity/trivy).
