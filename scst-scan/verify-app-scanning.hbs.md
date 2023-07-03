# Verify Scanning without Supply Chain integration

This topic tells you how to validate Scanning without Supply Chain integration.

## <a id="overview"></a> Overview

After you build an ImageVulnerabilityScan template to bring your own scanner, you van validate the capabilities to verify the integration is working correctly.

To ensure that the scan integration is working correctly so that downstream servers such as AMR Observer, Tanzu Developer Portal, and the insight CLI can use scan results:

1. Verify that a triggered scan is completed.
2. Retrieve the scan results from the registry
3. Verify that the scan results are in a supported format

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

2. Download the bundle to a local directory and list the content

   ```console
   imgpkg pull -b $SCAN_RESULT_URL -o scan-results/
   ls scan-results/
   ```

## <a id="validating-scan-format"></a> Validating Scan Format

After retrieving the scan results, the scan results must be validated to be in a format that downstream Tanzu Application Platform services such as AMR observer support.

<table>
  <caption>AMR Observer Supported SBOM Format/Versions</caption>
  <tr>
   <td><strong>SBOM Formats</strong></td>
   <td><strong>Versions</strong></td>
  </tr>
  <tr>
   <td>CycloneDX</td>
   <td>1.2, 1.3, 1.4</td>
  </tr>
  <tr>
   <td>SPDX</td>
   <td>2.2</td>
  </tr>
</table>

VMware reccomends validating the scan results by using this CycloneDX tool, [sbom-utility](https://github.com/CycloneDX/sbom-utility). This tool validates CycloneDX and SPDX BOMs against versioned schemas.

***Note*** The output of the scan must be valid in accordance with SPDX or CycloneDX specifications. If not, although it might be parsed correctly, VMware cannot ensure that the information will be parsed correctly, and results might not be displayed accurately in Tanzu Developer Portal and Tanzu Application s CLI.

1. Setup and install using the instructions [here](https://github.com/CycloneDX/sbom-utility#installation).
2. Run the `sbom-utility` CLI with the subcommand [validate](https://github.com/CycloneDX/sbom-utility#validate) to validate the scan report against its declared format (e.g., SPDX, CycloneDX) and version (e.g., "1.4", "2.2", etc.).

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
    [INFO] Successfully<!--฿ Redundant word? ฿--> unmarshalled data from: `/Users/lrobin/go/src/gitlab/app-scanning/scan-results-grype-cyclonedx-json/scan.json`
    [INFO] Determining file's SBOM format and version...
    [INFO] Determined<!--฿ |Determine| has two meanings. Consider if the univocal |discover| or |verify| would be better. ฿--> SBOM format, version (variant): `CycloneDX`, `1.4` (latest)
    [INFO] Matching SBOM schema (for validation): schema/cyclonedx/1.4/bom-1.4.schema.json
    [INFO] Loading schema `schema/cyclonedx/1.4/bom-1.4.schema.json`...
    [INFO] Schema `schema/cyclonedx/1.4/bom-1.4.schema.json` loaded.
    [INFO] Validating `/Users/lrobin/go/src/gitlab/app-scanning/scan-results-grype-cyclonedx-json/scan.json`...
    [INFO] SBOM valid against JSON schema: `true`
   ```