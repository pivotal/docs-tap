# Release notes

This topic contains release notes for Tanzu Application Platform v1.2


## <a id='1-2-0'></a> v1.2.0

**Release Date**: MONTH DAY, 2022

### <a id='1-2-new-features'></a> New features


This release includes the following changes, listed by component and area.


#### <a id="app-acc-features"></a> Application Accelerator

- Feature 1
- Feature 2

#### Application Live View

- Feature 1
- Feature 2

#### Tanzu CLI - Apps plug-in

- Feature 1
- Feature 2

#### Service Bindings

- Feature 1
- Feature 2

#### Source Controller

- Feature 1
- Feature 2

#### Spring Boot Conventions

- Feature 1
- Feature 2

#### <a id="snyk-scanner"></a> Snyk Scanner (Beta)

- Snyk Scanner is now available in beta for the [Supply Chain Security Tools - Scan](#scst-scan) controller. 
  - To use Snyk Scanner, manually install it by following the [Install Snyk Scanner](scst-scan/install-snyk-integration.md) instructions.
  - Run Snyk Scanner on `ImageScan`s for the Scan-Link controller.

#### Supply Chain Choreographer

- View resource status on a workload
  - Added ability to indicate how Cartographer can read the state of the resource and reflect it on the owner status.
  - Surfaces information about the health of resources directly on the owner status.
  - Adds a field in the spec `healthRule` where authors can specify how to determine the health of the underlying resource for that template. The resource can be in one of the following states: A stamped resource can be in one of three states: 'Healthy' (status True), 'Unhealthy' (status False), or 'Unknown'  (status Unknown). If no healthRule is defined, Cartographer defaults to listing the resource as `Healthy` once it is successfully applied to the cluster and any outputs are read off the resource.

#### <a id="scst-scan"></a> Supply Chain Security Tools - Scan

- Scan-Link's controller abstraction from the scanners' output format allows more flexibility when you integrate new scanners.
- Supply Chain Security Tools - Scan is decoupled from the Supply Chain Security Tools - Store to ease future integration with different storage methods.
- Beta scanner support released in the [Snyk Scanner](#snyk-scanner) package.

**NOTICE:** The Grype Scanner `ScanTemplate`s shipped with versions prior to Supply Chain Security Tools - Scan `v1.2.0` are now deprecated and will no longer be supported in future releases.

#### Supply Chain Security Tools - Sign
**TODO** deprecation notice, namespace bug as known issue
- Feature 1
- Feature 2

#### Supply Chain Security Tools - Policy Controller
**TODO fill this out**
- Feature 1
- Feature 2

#### Supply Chain Security Tools - Store

- Added more accepted vulnerability method types (CVSSv31, OWASP)
- Updated logging format to follow the Logging RFC recommendations
- Bumped postgres and paketo images to fix CVE-2022-1292
- Added support for insight plug-in to consume vulnerabilities through VEX in CycloneDX 1.4 reports
- Added support for insight plug-in to consume SPDX 2.2/3.0 reports and introduced new --spdxtype option to tanzu insight image/source add command
- Changed insight plug-in text response to return only highest CVE 
- Added aliases for insight plug-in vulnerabilities command

#### Tanzu Application Platform GUI

- Supply Chain Plug-in
  - Added ability to visualize CVE scan results in the Details pane for both Build and Image Scan stages, as well as scan policy information, without using the CLI
  - Added ability to visualize the deployment of a workload as a deliverable in a multicluster environment in the supply chain graph
  - Added a deeplink to view approvals for PRs in a GitHub repository so that PRs can be reviewed and approved, resulting in the deployment of a workload to any cluster configured to accept a deployment
  - Added Reason column to the Workloads table to indicate causes for errors encountered during supply chain execution

- Feature 2

#### Functions (Beta)

- Feature 1
- Feature 2


### <a id='1-2-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="app-acc-changes"></a> Application Accelerator

- Breaking change 1
- Breaking change 2

#### <a id="scst-scan-changes"></a> Supply Chain Security Tools - Scan

- You must configure integration with Supply Chain Security Tools - Store for the Grype Scanner and Snyk Scanner packages to enable this feature. The configuration for Supply Chain Security Tools - Store in Supply Chain Security Tools - Scan is only for the deprecated Grype Scanner `ScanTemplate`s.
- The rego file structure required for the `ScanPolicies` to work with the Grype Scanner and Snyk Scanner templates has changed. **Note:** This doesn't apply if you're using the deprecated Grype Scanner `ScanTemplate`s prior to Grype Scanner `v1.2.0`.
  - The package name has changed from `package policies` to `package main`.
  - The deny rule has changed from the boolean `isCompliant` to the array of strings `deny[msg]`.
  - Please note that the sample `ScanPolicy` is different if you're using Grype Scanner with a cyclonedx structure or Snyk Scanner with a spdx json structure.

#### Supply Chain Security Tools - Store

- Breaking change 1
- Breaking change 2

#### <a id="grype-scanner-changes"></a> Grype Scanner

- Information to integrate with the Supply Chain Security Tools - Store should be provided in the `tap-values.yaml` file for the Grype Scanner `v1.2+` 

### <a id='1-2-resolved-issues'></a> Resolved issues

This following issues, listed by area and component, are resolved in this release.


#### <a id="app-acc-resolved"></a> Application Accelerator

- Resolved issue 1
- Resolved issue 2

#### <a id="alv-resolved"></a> Application Live View

- Resolved issue 1
- Resolved issue 2

#### Services Toolkit

- Resolved issue 1
- Resolved issue 2

#### Supply Chain Security Tools - Scan

- `Go` updated to version `v1.18.2`
- `Open Policy Agent` updated to version `v.0.40.0`

#### Grype Scanner

- `ncurses` updated to version `6.1-5.ph3`

#### Supply Chain Security Tools - Store

- Resolved issue 1
- Resolved issue 2

#### Tanzu CLI - Apps plug-in

- Resolved issue 1
- Resolved issue 2

#### Tanzu Application Platform GUI

- Supply Chain plug-in
  - **Details for ConfigMap CRD not appearing:** The error `Unable to retrieve conditions for ConfigMap...`appears in the details section after clicking on the ConfigMap stage in the graph view of a supply chain.
  - **Scan results not shown:** Current CVEs found during Image or Build scanning do not appear.



### <a id='1-2-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### Tanzu Application Platform

- Known issue 1
- Known issue 2

#### Tanzu Cluster Essentials

- Known issue 1
- Known issue 2

#### Application Live View

- Known issue 1
- Known issue 2

#### Grype scanner

- Known issue 1
- Known issue 2

#### Supply Chain Security Tools - Scan

- Known issue 1
- Known issue 2

#### Supply Chain Security Tools - Store

- Known issue 1
- Known issue 2

#### Tanzu Application Platform GUI

- Known issue 1
- Known issue 2
