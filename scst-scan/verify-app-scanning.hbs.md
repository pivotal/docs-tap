# Verifying Scanning without Supply Chain Integration

Once you have built an ImageVulnerabilityScan template to bring your own scanner, it is important to validate the functionality to verify the integration is working correctly.

In order to ensure the scan integration is working correctly so that downstream servers such as AMR observer, TAP GUI, and the insight CLI can use scan results, follow these steps:

1.  Verify that a triggered scan is completed successfully
2.  Retrieve the scan results from the registry
3.  Validate that the scan results are in a supported format

## <a id="trigger-observe-scanning"></a> Trigger and Observe Scanning

To verify that you can scan an image using your ImageVulnerabilityScan:

1. Deploy your ImageVulnerabilityScan to the cluster by running:

    ```console
    kubectl apply -f image-vulnerability-scan.yaml -n DEV-NAMESPACE
    ```
   - Where `DEV-NAMESPACE` is the name of the developer namespace you want to use.

2. Child resources are created.

    - View the child PipelineRun, TaskRuns, and pods
      ```console
      kubectl get -l imagevulnerabilityscan,pipelinerun,taskrun,pod -n DEV-NAMESPACE
      ```

3. When the scanning completes, the status is shown. Specify `-o wide` to see the digest of the image scanned and the location of the published results.

    ```console
    kubectl get imagevulnerabilityscans -n DEV-NAMESPACE -o wide

    NAME                 SCANRESULT                           SCANNEDIMAGE          SUCCEEDED   REASON
    generic-image-scan   registry/project/scan-results@digest nginx:latest@digest   True        Succeeded

    ```

## <a id="retrieve-scan-results"></a> Retrieve scan results

Scan results are uploaded to the container image registry as an [imgpkg](https://carvel.dev/imgpkg/) bundle.
To retrieve a vulnerability report:

1. Retrieve the result location from the ImageVulnerabilityScan CR Status
   ```console
   SCAN_RESULT_URL=$(kubectl get imagevulnerabilityscan my-scan -n DEV-NAMESPACE -o jsonpath='{.status.scanResult}')
   ```

1. Download the bundle to a local directory and list the content
   ```console
   imgpkg pull -b $SCAN_RESULT_URL -o scan-results/
   ls scan-results/
   ```

## <a id="validating-scan-format"></a> Validating Scan Format

After retrieving the scan results, the scan results must be validated to be in a format that downstream Tanzu Application Platform services such as AMR observer support.  The recommended way to validate the scan results is via this CycloneDX tool, [sbom-utility](https://github.com/CycloneDX/sbom-utility). This tool is designed to validate CycloneDX and SPDX BOMs against versioned schemas.

1. Setup and install using the instructions [here](https://github.com/CycloneDX/sbom-utility#installation).
2. To see what supported formats, schemas, and versions are available for validation use the `schema` command to list them out:
    ```console
    ./sbom-utility schema list
    ```

    For example:
    ```
    sbom-utility-v0.11.0-darwin-amd64 % ./sbom-utility schema list
    Welcome to the sbom-utility! Version `v0.11.0` (sbom-utility) (darwin/amd64)
    ============================================================================
    [INFO] Loading license policy config file: `license.json`...
    [INFO] Scanning document for vulnerabilities...
    name                          format     version   variant      file                                             url
    ----                          ------     -------   -------      ----                                             ---
    CycloneDX v1.5 (development)  CycloneDX  1.5       development  schema/cyclonedx/1.5/bom-1.5-dev.schema.json     https://raw.githubusercontent.com/CycloneDX/specification/v1.5-dev/schema/bom-1.5.schema.json
    CycloneDX v1.4                CycloneDX  1.4       (latest)     schema/cyclonedx/1.4/bom-1.4.schema.json         https://raw.githubusercontent.com/CycloneDX/specification/master/schema/bom-1.4.schema.json
    CycloneDX v1.4 (custom)       CycloneDX  1.4       custom       schema/test/bom-1.4-custom.schema.json
    CycloneDX v1.3                CycloneDX  1.3       (latest)     schema/cyclonedx/1.3/bom-1.3.schema.json         https://raw.githubusercontent.com/CycloneDX/specification/master/schema/bom-1.3.schema.json
    CycloneDX v1.3 (custom)       CycloneDX  1.3       custom       schema/test/bom-1.3-custom.schema.json
    CycloneDX v1.3 (strict)       CycloneDX  1.3       strict       schema/cyclonedx/1.3/bom-1.3-strict.schema.json  https://raw.githubusercontent.com/CycloneDX/specification/master/schema/bom-1.3-strict.schema.json
    CycloneDX v1.2                CycloneDX  1.2       (latest)     schema/cyclonedx/1.2/bom-1.2.schema.json         https://raw.githubusercontent.com/CycloneDX/specification/master/schema/bom-1.2.schema.json
    CycloneDX v1.2 (strict)       CycloneDX  1.2       strict       schema/cyclonedx/1.2/bom-1.2-strict.schema.json  https://raw.githubusercontent.com/CycloneDX/specification/master/schema/bom-1.2-strict.schema.json
    SPDX v2.3                     SPDX       SPDX-2.3  (latest)     schema/spdx/2.3/spdx-schema.json                 https://raw.githubusercontent.com/spdx/spdx-spec/development/v2.3/schemas/spdx-schema.json
    SPDX v2.3.1 (development)     SPDX       SPDX-2.3  development  schema/spdx/2.3.1/spdx-schema.json               https://raw.githubusercontent.com/spdx/spdx-spec/development/v2.3.1/schemas/spdx-schema.json
    SPDX v2.2.2                   SPDX       SPDX-2.2  (latest)     schema/spdx/2.2.2/spdx-schema.json               https://raw.githubusercontent.com/spdx/spdx-spec/v2.2.2/schemas/spdx-schema.json
    SPDX v2.2.1                   SPDX       SPDX-2.2  2.2.1        schema/spdx/2.2.1/spdx-schema.json               https://raw.githubusercontent.com/spdx/spdx-spec/v2.2.1/schemas/spdx-schema.json
    ```
    ***Note***: To add another format see [here](https://github.com/CycloneDX/sbom-utility#adding-sbom-formats-schema-versions-and-variants).
3. Run the `sbom-utility` CLI with the subcommand [validate](https://github.com/CycloneDX/sbom-utility#validate) to validate the scan report against its declared format (e.g., SPDX, CycloneDX) and version (e.g., "2.2", "1.4", etc.).
   ```console
   ./sbom-utility validate -i SCAN-REPORT-FILE-NAME
   ```
   Where `SCAN-REPORT-FILE-NAME` is the name of the scan report.

   For example:
   ```console
    sbom-utility-v0.11.0-darwin-amd64 % ./sbom-utility validate -i scan-results/scan.json
    Welcome to the sbom-utility! Version `v0.11.0` (sbom-utility) (darwin/amd64)
    ============================================================================
    [INFO] Loading license policy config file: `license.json`...
    [WARN] Invalid flag for command: `output-file` (`o`). Ignoring...
    [INFO] Attempting to load and unmarshal file `/Users/lrobin/go/src/gitlab/app-scanning/scan-results-grype-cyclonedx-json/scan.json`...
    [INFO] Successfully unmarshalled data from: `/Users/lrobin/go/src/gitlab/app-scanning/scan-results-grype-cyclonedx-json/scan.json`
    [INFO] Determining file's SBOM format and version...
    [INFO] Determined SBOM format, version (variant): `CycloneDX`, `1.4` (latest)
    [INFO] Matching SBOM schema (for validation): schema/cyclonedx/1.4/bom-1.4.schema.json
    [INFO] Loading schema `schema/cyclonedx/1.4/bom-1.4.schema.json`...
    [INFO] Schema `schema/cyclonedx/1.4/bom-1.4.schema.json` loaded.
    [INFO] Validating `/Users/lrobin/go/src/gitlab/app-scanning/scan-results-grype-cyclonedx-json/scan.json`...
    [INFO] SBOM valid against JSON schema: `true`
   ```