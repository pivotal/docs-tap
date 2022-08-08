# Release notes

This topic contains release notes for Tanzu Application Platform v1.2.1.

## <a id='1-2-1'></a> v1.2.1

**Release Date**: August 9, 2022

### <a id='1-2-1-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### <a id="tbs-features"></a> Tanzu Build Service

- Improved error messaging.
- Removed noisy logging from AWS credential helper.

### <a id='1-2-1-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="tap-gui-resolved"></a>Tanzu Application Platform GUI

- Supply Chain plug-in
  - ConfigMap has no conditions and as a result its status is `Unknown`.
  - ConfigWriter shows an error but no error details are displayed.
  - Kaniko-based image builds cannot show data in the UI.
  - Need to refresh browser to show successful or error messages.
  
### <a id='1-2-1-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="tap-known-issues"></a>Tanzu Application Platform

- **Unable to add Tanzu Application Platform repo into clusters attached to Tanzu Mission Control with pre-installed Cluster Essentials v1.2:** For the solution, see [Troubleshoot installing Tanzu Application Platform](troubleshooting-tap/troubleshoot-install-tap.hbs.md#cant-add-tap-repo).

#### <a id="scst-scan-issues"></a>Supply Chain Security Tools - Scan

- **Blob source scan is reporting wrong source URL:** When running a source scan of a blob compressed file, it looks for a `.git` directory present in the files to extract information that is useful for the report sent to the Supply Chain Security Tools - Store deployment. This problem happens when you use Grype Scanner ScanTemplates earlier than version `v1.2.0` because the Scan Controller has a deprecated path to support previous ScanTemplates. VMware plans to resolve this issue by Supply Chain Security Tools - Scan `v1.3.0`. For the solution, see [Observability and troubleshooting](scst-scan/observing.hbs.md#reporting-wrong-blob-url).

#### <a id="grype-scan-known-issues"></a>Grype scanner

**Scanning Java source code that uses Gradle package manager may not reveal vulnerabilities:**

- For most languages, source code scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch dependencies.
For languages using dependency lock files, such as Golang and Node.js,
Grype uses the lock files to check the dependencies for vulnerabilities.

- For Java using Gradle, dependency lock files are not guaranteed, so Grype uses
the dependencies present in the built binaries (`.jar` or `.war` files) instead.

- Because VMware does not encourage committing binaries to source code repositories,
Grype fails to find vulnerabilities during a source scan.
The vulnerabilities are still found during the image scan
after the binaries are built and packaged as images.
