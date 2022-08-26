# Release notes

{{#unless vars.hide_content}}
This Handlebars condition is used to hide content.
In release notes, this condition hides content that describes an unreleased patch for a released minor.
{{/unless}}
This topic contains release notes for Tanzu Application Platform v1.3


## <a id='1-3-0'></a> v1.3.0

**Release Date**: MONTH DAY, 2022

### <a id='1-3-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### <a id="app-acc-features"></a> Application Accelerator

- Feature 1
- Feature 2

#### <a id="alv-features"></a>Application Live View

- Feature 1
- Feature 2

#### <a id="app-sso-features"></a>Application Single Sign-On

- Feature 1
- Feature 2

#### <a id="apps-plugin"></a> Tanzu CLI - Apps plug-in

- Feature 1
- Feature 2

#### <a id="src-cont-features"></a>Source Controller

- Feature 1
- Feature 2

#### <a id="snyk-scanner"></a> Snyk Scanner (beta)

- Feature 1
- Feature 2

#### <a id="scc-features"></a>Supply Chain Choreographer

- Feature 1
- Feature 2

#### <a id="scst-scan"></a> Supply Chain Security Tools - Scan

- Feature 1
- Feature 2

#### <a id="scst-sign-features"></a>Supply Chain Security Tools - Sign

- Feature 1
- Feature 2

#### <a id="scst-policy-features"></a>Supply Chain Security Tools - Policy Controller

- Feature 1
- Feature 2

#### <a id="scst-store-features"></a>Supply Chain Security Tools - Store

- Feature 1
- Feature 2

#### <a id="tap-gui-features"></a>Tanzu Application Platform GUI

- Supply Chain plug-in:
  - Added ability to visualize CVE scan results in the Details pane for both Source and Image Scan stages, as well as scan policy information without using the CLI.
  - Added ability to visualize the deployment of a workload as a deliverable in a multicluster environment in the supply chain graph.
  - Added a deeplink to view approvals for PRs in a GitOps repository so that PRs can be reviewed and approved, resulting in the deployment of a workload to any cluster configured to accept a deployment.
  - Added Reason column to the Workloads table to indicate causes for errors encountered during supply chain execution.
  - Added links to a downloadable log output for each execution of the Test and Build stages of the out of the box supply chains to enable more enhanced troubleshooting methods for workloads

#### <a id="dev-tls-vsc-features"></a>Tanzu Developer Tools for VS Code

- Feature 1
- Feature 2

#### <a id="dev-tls-intelj-features"></a>Tanzu Developer Tools for IntelliJ

- Feature 1
- Feature 2

#### <a id="functions-features"></a> Functions (beta)

- Feature 1
- Feature 2

#### <a id="tbs-features"></a> Tanzu Build Service

- Feature 1
- Feature 2

#### <a id="srvc-toolkit-features"></a> Services Toolkit

- Added support for Openshift.
- Added support for Kubernetes 1.24.
- Created documentation and reference Service Instance Packages for new Cloud Service Provider integrations:
  - [Azure Flexible Server (Postgres) by using the Azure Service Operator](https://docs-staging.vmware.com/en/draft/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_azure_flexibleserver_psql_with_azure_operator.html).
  - [Azure Flexible Server (Postgres) by using Crossplane](https://docs-staging.vmware.com/en/draft/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_azure_database_with_crossplane.html).
  - [Google Cloud SQL (Postgres) by using Config Connector](https://docs-staging.vmware.com/en/draft/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_config_connector.html).
  - [Google Cloud SQL (Postgres) by using Crossplane](https://docs-staging.vmware.com/en/draft/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_crossplane.html).
- **`tanzu services` CLI plug-in:** improved info messages for deprecated commands.

### <a id='1-3-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="scst-scan-changes"></a> Supply Chain Security Tools - Scan

- Breaking change 1
- Breaking change 2

#### <a id="tbs-breaking-changes"></a> Tanzu Build Service

- Breaking change 1
- Breaking change 2

#### <a id="grype-scanner-changes"></a> Grype Scanner

- Breaking change 1
- Breaking change 2

### <a id='1-3-resolved-issues'></a> Resolved issues

- Resolved issue 1
- Resolved issue 2

#### <a id="app-acc-resolved"></a> Application Accelerator

- Resolved issue 1
- Resolved issue 2

#### <a id="scst-scan-resolved"></a>Supply Chain Security Tools - Scan

- Resolved issue 1
- Resolved issue 2

#### <a id="grype-scan-resolved"></a>Grype Scanner

- Resolved issue 1
- Resolved issue 2

#### <a id="apps-plugin-resolved"></a> Tanzu CLI - Apps plug-in

- Resolved issue 1
- Resolved issue 2

#### <a id="srvc-toolkit-resolved"></a> Services Toolkit

- Resolved issue 1
- Resolved issue 2

#### <a id="srvc-bindings-resolved"></a> Service Bindings

- Resolved issue 1
- Resolved issue 2

#### <a id="sprng-convs-resolved"></a> Spring Boot Conventions

- Resolved issue 1
- Resolved issue 2

#### <a id="tap-gui-resolved"></a>Tanzu Application Platform GUI

- Resolved issue 1
- Resolved issue 2

### <a id='1-3-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="tap-known-issues"></a>Tanzu Application Platform

- Known issue 1
- Known issue 2

#### <a id="alv-known-issues"></a>Application Live View

- Known issue 1
- Known issue 2

#### <a id="alv-ca-known-issues"></a>Application Single Sign-On

- Known issue 1
- Known issue 2

#### <a id="conv-svc-known-issues"></a>Convention Service

- Known issue 1
- Known issue 2

#### <a id="functions-issues"></a> Functions (beta)

- Known issue 1
- Known issue 2

#### <a id="scst-scan-issues"></a>Supply Chain Security Tools - Scan

- Known issue 1
- Known issue 2

#### <a id="grype-scan-known-issues"></a>Grype scanner

**Scanning Java source code that uses Gradle package manager may not reveal vulnerabilities:**
- For most languages, Source Code Scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch dependencies.
For languages using dependency lock files, such as Golang and Node.js,
Grype uses the lock files to check the dependencies for vulnerabilities.

- For Java using Gradle, dependency lock files are not guaranteed, so Grype uses
the dependencies present in the built binaries (`.jar` or `.war` files) instead.

- Because VMware does not encourage committing binaries to source code repositories,
Grype fails to find vulnerabilities during a Source Scan.
The vulnerabilities are still found during the Image Scan
after the binaries are built and packaged as images.

#### <a id="tap-gui-known-issues"></a>Tanzu Application Platform GUI

- Known issue 1
- Known issue 2

#### <a id="vscode-ext-known-issues"></a>VS Code Extension

- Known issue 1
- Known issue 2

#### <a id="intelj-ext-known-issues"></a>Intellij Extension

- Known issue 1
- Known issue 2

#### <a id="store-known-issues"></a>Supply Chain Security Tools - Store

- Known issue 1
- Known issue 2
