# Release notes

{{#unless vars.hide_content}}
This Handlebars condition is used to hide content.
In release notes, this condition hides content that describes an unreleased patch for a released minor.
{{/unless}}
This topic contains release notes for Tanzu Application Platform v1.2.1.

## <a id='1-2-1'></a> v1.2.1

**Release Date**: August 9, 2022

### <a id='1-2-1-new-features'></a> New features

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

#### <a id="scc-features"></a>Supply Chain Choreographer

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

- Improved error messaging.
- Removed noisy logging from AWS credential helper.

#### <a id="srvc-toolkit-features"></a> Services Toolkit

- Feature 1
- Feature 2

### <a id='1-2-1-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="tbs-breaking-changes"></a> Tanzu Build Service

- Breaking change 1
- Breaking change 2

### <a id='1-2-1-resolved-issues'></a> Resolved issues

- Resolved issue 1
- Resolved issue 2

#### <a id="app-acc-resolved"></a> Application Accelerator

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

- Supply Chain plug-in
  - ConfigMap has no conditions and as a result its status is `Unknown`.
  - ConfigWriter shows an error but no error details are displayed.
  - Kaniko based image builds could not show data in the UI.
  - Need to refresh browser to show successful or error messages.
  

### <a id='1-2-1-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="tap-known-issues"></a>Tanzu Application Platform

- **Issue:** Unable to add Tanzu Application Platform repo into clusters attached
to Tanzu Mission Control with pre-installed Cluster Essentials v1.2.

    **Workaround:** Do not add a cluster with Cluster Essentials v1.2 predeployed to Tanzu Mission Control.
Cluster Essentials must be provisioned by Tanzu Mission Control only.

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

**Blob Source Scan is reporting wrong source URL:**
- When running a Source Scan of a blob compressed file, it looks for a `.git` directory present in the files to extract information that is usefull for the report sent to the Supply Chain Security Tools - Store deployment. This problem happens when you use Grype Scanner ScanTemplates earlier than version `v1.2.0` because the Scan Controller has a deprecated path to support previous ScanTemplates. This will be removed by Supply Chain Security Tools - Scan `v1.3.0`.

- Workaround: Upgrade your Grype Scanner deployment to version `v1.2.0` or later. For more information, see [Upgrading Supply Chain Security Tools - Scan](scst-scan/upgrading.md#upgrade-to-1-2-0).

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
