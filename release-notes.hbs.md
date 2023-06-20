# Tanzu Application Platform release notes

This topic describes the changes in Tanzu Application Platform (commonly known as TAP)
v{{ vars.url_version }}.

{{#unless vars.hide_content}}
## <a id='1-2-3'></a> v1.2.3

**Release Date**: MONTH DAY, 2022

### <a id='1-2-3-security-fixes'></a> Security fixes

### <a id='1-2-3-new-features'></a> Resolved issues

### <a id='1-2-3-known-issues'></a> Known issues

{{/unless}}

## <a id='1-2-2'></a> v1.2.2

**Release Date**: September 13, 2022

### <a id='1-2-2-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### <a id="1-2-2-scst-store-new-features"></a>Supply Chain Security Tools - Store

- Modified the vulnerability response in the `tanzu insight` CLI plug-in to only return the highest severity rating for a CVE.

### <a id='1-2-2-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id="1-2-2-scst-scan-issues"></a>Supply Chain Security Tools - Scan

* Resolved blob source scan reporting wrong source URL to the metadata store when the .git file does not exist.

#### <a id="1-2-2-scst-store-issues"></a>Supply Chain Security Tools - Store

- Resolved an issue where Store could not handle new method types.
- Resolved an issue where Store could not handle blob URLs in component names.

#### <a id="1-2-2-tap-gui-resolved"></a>Tanzu Application Platform GUI

* Updated supply-chain package version to v0.1.26 to fix an issue in the Image Scanner Stage.

### <a id='1-2-2-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="1-2-2-upgrade-issues"></a> Upgrading Tanzu Application Platform

- **Adding the v1.2.2 repository bundle in addition to another repository might cause a failure:**

   - While upgrading to Tanzu Application Platform v1.2.2 from any previous version, adding the v1.2.2 repo bundle in addition to the existing repo bundle can fail. For the workaround, see [Troubleshoot installing Tanzu Application Platform](troubleshooting-tap/troubleshoot-install-tap.hbs.md#tap-upgrade-fails).

  - You might observe an error with package installs `ReconcileFailed True Expected to find at least one version` until Tanzu Application Platform is upgraded to v1.2.2, but this does not affect the functionality of any components.

#### <a id="1-2-2-grype-scan-issues"></a>Grype scanner

- **Scanning Java source code that uses Gradle package manager may not reveal vulnerabilities:**

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

#### <a id="1-2-2-scst-sign-issues"></a>Supply Chain Security Tools - Policy Controller

This issue is also present in previous releases of Supply Chain Security Tools - Policy Controller.

- **`kubectl run` pods fail to validate in non-default namespaces:**

  - When policy verification occurs on an image deployed through `kubectl run` on a non-default namespace, the verification will fail to create the keychain required if the image requires credentials.

#### <a id="1-2-2-learning-center-issues"></a>Learning Center

- **session.objects, environment.objects, and session.patches are not deployed:**

  - Due to a security improvement in Learning Center, session.objects, environment.objects, and session.patches are not working properly. VMware resolved this issue by Learning Center `v0.2.4` in TAP 1.3.2.

## <a id='1-2-1'></a> v1.2.1

**Release Date**: August 9, 2022

### <a id='1-2-1-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### <a id="1-2-1-tbs-features"></a> Tanzu Build Service

- Improved error messaging.
- Removed noisy logging from AWS credential helper.

### <a id='1-2-1-resolved'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id="1-2-1-tap-gui-resolved"></a>Tanzu Application Platform GUI

- Supply Chain plug-in:
  - ConfigMap has no conditions and as a result its status is `Unknown`.
  - ConfigWriter shows an error but no error details are displayed.
  - Kaniko-based image builds cannot show data in the UI.
  - Need to refresh browser to show successful or error messages.

- Runtime Resource Visibility plug-in:
The [Maven artifacts access error](tap-gui/troubleshooting.hbs.md#maven-artifacts-error) is fixed.

### <a id='1-2-1-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="1-2-1-tap-known-issues"></a>Tanzu Application Platform

- **Unable to add Tanzu Application Platform repo into clusters attached to Tanzu Mission Control with pre-installed Cluster Essentials v1.2:** For the solution, see [Troubleshoot installing Tanzu Application Platform](troubleshooting-tap/troubleshoot-install-tap.hbs.md#cant-add-tap-repo).

#### <a id="1-2-1-scst-scan-issues"></a>Supply Chain Security Tools - Scan

- **Blob source scan is reporting wrong source URL:** When running a source scan of a blob compressed file, it looks for a `.git` directory present in the files to extract information that is useful for the report sent to the Supply Chain Security Tools - Store deployment. This problem happens when you use Grype Scanner ScanTemplates earlier than version `v1.2.0` because the Scan Controller has a deprecated path to support previous ScanTemplates. VMware plans to resolve this issue by Supply Chain Security Tools - Scan `v1.3.0`. For the solution, see [Observability and troubleshooting](scst-scan/observing.hbs.md#reporting-wrong-blob-url).

#### <a id="1-2-1-grype-scan-issues"></a>Grype scanner

- **Scanning Java source code that uses Gradle package manager may not reveal vulnerabilities:**
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

## <a id='1-2-0'></a> v1.2.0

**Release Date**: July 12, 2022

### <a id='1-2-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### <a id="app-acc-features"></a> Application Accelerator

- [Accelerator fragments](./application-accelerator/creating-accelerators/composition.md) are now available.
  - Allows for re-usable accelerator fragments to be imported into other accelerators.
- [Tanzu Application Accelerator for VS Code Extension](./application-accelerator/vscode.md#vs-code-app-accel-install) is now available.
  - Allows for developers to quickly generate projects from their organization's Accelerator Catalog right from within VS Code.
- Added the `subPath` field for [Accelerators](./application-accelerator/creating-accelerators/accelerator-crd.md#accelerator-crd-spec) and [Fragments](./application-accelerator/creating-accelerators/accelerator-crd.md#fragment-crd-spec).
  - Provides the option for altering the location of the root of an accelerator or fragment.

#### <a id="alv-features"></a>Application Live View

- Live Hover Integration with Spring Tools Suite:
  - Users can hover over Spring Actuator endpoints to see live data. You can enable this feature from Preferences.

#### <a id="app-sso-features"></a>Application Single Sign-On

- Application Single Sign-On package comes installed with iterate, run, and full profiles.
- Secure a workload with AppSSO. For more information, see [AppSSO documentation](https://docs.vmware.com/en/Application-Single-Sign-On-for-VMware-Tanzu/1.0/appsso/GUID-app-operators-register-an-app-with-app-sso.html).
- AppSSO Starter Java Accelerator shows how to enable SSO on a Spring Boot application.
- OpenID Connect Identity Providers are supported.
- Grant types supported: authorization code, client credentials, refresh token.
- Audit logs for troubleshooting.
- Secure tokens - Token signature keys are created and applied to AuthServer so that tokens can be signed and verified.
- TLS secured.

#### <a id="apps-plugin-features"></a> Tanzu CLI - Apps plug-in

- Added support for [`--sub-path`](cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.md#apply-subpath) flag where users can specify a relative path inside the repository or image to treat as application root for source.
- Added [`--service-account`](cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.md#apply-service-account) flag to specify ServiceAccount name used by the workload to create resources submitted by the supply chain.
- Added shorthand `-s` for [`--source-image`](cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.md#apply-source-image) flag.
- Added support for [`--output`](cli-plugins/apps/command-reference/commands-details/workload_list.md#list-output) flag to `workloads list` command.
- Added support for JSON or YAML params using new flag [`--param-yaml`](cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.md#apply-param-yaml).
- Added support for creating workloads from JAR, WAR, and ZIP files through the [`--local-path`](cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.md#apply-local-path) flag.
- Added source information from workload  in the `workload get` command output.
- Added new command [`tanzu apps cluster-supply-chain get`](cli-plugins/apps/command-reference/tanzu-apps-cluster-supply-chain-get.md).
- Added support for excluding files on local path using `.tanzuignore` file.
- Added supply chain step information in `workload get` command output.
- Added support for short names for Cartographer workload (wld) and cluster-supply-chain commands (csc).
- Added support for providing ServiceAccount name in workload commands through file input.

#### <a id="src-cont-features"></a>Source Controller

- Added support for pulling Artifacts from a Maven repository using the `MavenArtifact` CR.

  >**Note:** Fetching `RELEASE` version from GitHub packages is not currently supported. The `metadata.xml` in GitHub packages does not have the `release` tag that contains the released version number. For more information, see [Maven-metadata.xml is corrupted on upload to registry](https://github.community/t/maven-metadata-xml-is-corrupted-on-upload-to-registry/177725) on GitHub.

#### <a id="snyk-scanner-features"></a> Snyk Scanner (beta)

- Snyk scanner image scanning integration (Beta) is available for [Supply Chain Security Tools - Scan](#scst-scan).
  - See [Snyk Installation and Configuration Guide](scst-scan/install-snyk-integration.md) for instructions on how to use Snyk with Tanzu Application Platform Supply Chains.

#### <a id="scc-features"></a>Supply Chain Choreographer

- View resource status on a workload:
  - Added ability to indicate how Cartographer can read the state of the resource and reflect it on the owner status.
  - Surfaces information about the health of resources directly on the owner status.
  - Adds a field in the spec `healthRule` where authors can specify how to determine the health of the underlying resource for that template. The resource can be in one of the following states: A stamped resource can be in one of three states: `Healthy` (status True), `Unhealthy` (status False), or `Unknown` (status Unknown). If no healthRule is defined, Cartographer defaults to listing the resource as `Healthy` once it is successfully applied to the cluster and any outputs are read off the resource.
- [Cartographer Conventions](./cartographer-conventions/about.md) v0.1.0 is now bundled with Supply Chain Choreographer.
  - As of v0.07.0 release of [Convention Controller](./convention-service/about.md), its APIs are deprecated in favor of continuing development on [Cartographer Conventions](./cartographer-conventions/about.md). Cartographer Conventions is now bundled with Supply Chain Choreographer.

#### <a id="scst-scan-features"></a> Supply Chain Security Tools - Scan

- Scan-Link's controller abstraction from the scanners' output format allows more flexibility when you integrate new scanners.
- Supply Chain Security Tools - Scan is decoupled from the Supply Chain Security Tools - Store to ease future integration with different storage methods.
- Beta scanner support released in the [Snyk Scanner](#snyk-scanner) package.
- Documentation is available on how to use [Grype in offline and air-gapped environments](scst-scan/offline-airgap.md).

>**Note:** The Grype Scanner `ScanTemplate`s shipped with versions before Supply Chain Security Tools - Scan `v1.2.0` are now deprecated and are no longer supported in future releases. See [Upgrading Supply Chain Security Tools - Scan](scst-scan/upgrading.md#upgrade-to-1-2-0) for step-by-step instructions.

#### <a id="scst-sign-features"></a>Supply Chain Security Tools - Sign

- Updated cosign to v1.9.0.
- Fixed resources without namespace defined causing errors.

>**Important:** Supply Chain Security Tools - Sign is being deprecated and is being replaced
by Supply Chain Security Tools - Policy Controller.
Supply Chain Security Tools - Sign is no longer supported after
Tanzu Application Platform v1.4.0. See [Migration From Supply Chain Security Tools - Sign](scst-policy/migration.md)
for migration instructions.

#### <a id="scst-policy-features"></a>Supply Chain Security Tools - Policy Controller

- Initial release of Policy Controller, which uses Sigstore Policy Controller.

#### <a id="scst-store-features"></a>Supply Chain Security Tools - Store

- Added more accepted vulnerability method types (CVSSv31, OWASP).
- Updated logging format to follow the Logging RFC recommendations.
- Bumped PostgreSQL and paketo images to fix CVE-2022-1292.
- Added support for insight plug-in to consume vulnerabilities through VEX in CycloneDX 1.4 reports.
- Added support for insight plug-in to consume SPDX 2.2/3.0 reports and introduced the new `--spdxtype` option to the `tanzu insight image add` and `tanzu insight source add` commands.
- Changed insight plug-in text response to return only highest CVE.
- Added aliases for insight plug-in vulnerabilities command.

#### <a id="tap-gui-features"></a>Tanzu Application Platform GUI

&nbsp; Plug-in improvements and additions include:

- Runtime Resources Visibility plug-in:
  - Added support for pod logs and the ability to change log levels (where application live view is supported).
  - Added memory and CPU limit configuration.
  - Added quick links to access app memory and threads usage.
  - Added additional current status information when viewing runtime resources.
  - Added Tanzu Workload integration with a workload detail page for all runtime resouces.
  - Added support for Supply Chain resources.
  - UX updates to the Runtime Resource landing page.

- Supply Chain plug-in:
  - Added ability to visualize CVE scan results in the Details pane for both Source and Image Scan stages, as well as scan policy information without using the CLI.
  - Added ability to visualize the deployment of a workload as a deliverable in a multicluster environment in the supply chain graph.
  - Added a deeplink to view approvals for PRs in a GitOps repository so that PRs can be reviewed and approved, resulting in the deployment of a workload to any cluster configured to accept a deployment.
  - Added Reason column to the Workloads table to indicate causes for errors encountered during supply chain execution.
  - Added links to a downloadable log output for each execution of the Test and Build stages of the out of the box supply chains to enable more enhanced troubleshooting methods for workloads.

#### <a id="dev-tls-vsc-features"></a>Tanzu Developer Tools for VS Code

- **View workload statuses:** You can see the status of your workloads from the Workloads panel.
For more information, see
[Using the Tanzu Dev Tools Extension](vscode-extension/using-the-extension.md).
- **Apply and Delete workload commands:** You can run **Tanzu: Apply Workload** and
**Tanzu: Delete Workload** from the Command Palette. For more information, see
[Using the Tanzu Dev Tools Extension](vscode-extension/using-the-extension.md).
- **Live Hover Integration with Spring Tools Suite:** You can point to Spring annotations and see
the live data from a running Spring Boot application by way of Spring Boot Actuator endpoints.
For more information, see
[Live Hover integration with Spring Boot Tools (Experimental)](vscode-extension/live-hover.md).

#### <a id="dev-tls-intelj-features"></a>Tanzu Developer Tools for IntelliJ

- **Live Update and Debug your workloads:** The new IntelliJ extension enables you to Live Update and
Debug your workloads.
For more information, see [VMware Tanzu Developer Tools for IntelliJ](intellij-extension/about.md).

#### <a id="functions-features"></a> Functions (beta)

- Live Update and Debug your Java functions. For more information, see [Iterate on your function](workloads/iterate-functions.md).

#### <a id="tbs-features"></a> Tanzu Build Service

- Updates to dependencies are now provided as part of Tanzu Application Platform patches.
- The automatic dependency update feature is deprecated.
VMware discourages configuring Tanzu Application Platform with automatic dependency updates due to compatibility risks.
This feature is still supported until stated otherwise.

#### <a id="srvc-toolkit-features"></a> Services Toolkit

- Services Toolkit now integrates with Amazon RDS using the ACK Operator or Crossplane.
For more information, see the [Services Toolkit documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.7/svc-tlk/GUID-use.html).
- New `ClusterInstanceClass` supports service instance abstraction.
It is available using `tanzu service classes list` in v0.3.0 of the Services plug-in for Tanzu CLI.
- Claimable resources are now discoverable through the `InstanceQuery` API.
It is available using `tanzu service claimable list --class CLASS-NAME` in `v0.3.0` of the Services plug-in for Tanzu CLI.
- ResourceClaims now aggregate on ClusterRoles for service resources with the standard
`servicebinding.io/controller: "true"` label from the [Service Binding specification for Kubernetes](https://github.com/servicebinding/spec).
- Deprecation warning: `tanzu service types list` and `tanzu service instances list` commands are now
deprecated. These commands are hidden from help text but remain functional if invoked.
VMware intends to continue to support these commands for either two additional minor releases
(v0.6.0 of the CLI plug-in) or after one year (2023-07-12), whichever comes later.
VMware recommends using `tanzu service class` and `tanzu service claimable` commands in place of
`tanzu service type` and `tanzu service instance` from now on.

### <a id='1-2-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="app-accel-changes"></a> Application Accelerator

- App Accelerator now ships with Open Rewrite 7.24.0 (up from 7.21.x in TAP 1.1). As a consequence, some configuration properties of the OpenRewriteRecipe transform may need to be revised. For example, when using the `ChangePackage` recipe.

#### <a id="scst-scan-changes"></a> Supply Chain Security Tools - Scan

- You must configure integration with Supply Chain Security Tools - Store for the Grype Scanner and Snyk Scanner packages to enable this feature. The configuration for Supply Chain Security Tools - Store in Supply Chain Security Tools - Scan is only for the deprecated Grype Scanner `ScanTemplate`s.
- For the profile configuration of Supply Chain Security Tools - Scan, the scanning component no longer takes the metadata store configurations as of v1.2.0.
  - For information about configuring metadata store by using the Grype component instead of the scanning component as of v1.2.0, see [Install multicluster Tanzu Application Platform profiles
](multicluster/installing-multicluster.md).
  - See [Build profile](multicluster/reference/tap-values-build-sample.md) for the deprecated way of writing the metadata store configuration through the scanning component.

  >**Note:** This doesn't apply if you are using the deprecated Grype Scanner `ScanTemplate`s prior to Grype Scanner `v1.2.0`.

  - The package name changed from `package policies` to `package main`.
  - The deny rule changed from the boolean `isCompliant` to the array of strings `deny[msg]`.
  - The sample `ScanPolicy` is different if you're using Grype Scanner with a CycloneDX structure or Snyk Scanner with a SPDX JSON structure. See [Install Snyk Scanner](scst-scan/install-snyk-integration.md) for an example of a Scan Policy.
  - See [Enforce compliance policy using Open Policy Agent](scst-scan/policies.md) for an example of the current ScanPolicy format for v1.2.0 and later.

#### <a id="tbs-breaking-changes"></a> Tanzu Build Service

>**Note:** If your Tanzu Application Platform v1.1 installation is configured with
`enable_automatic_updates: false`, you can ignore this breaking change.

- When upgrading Tanzu Application Platform to v1.2, Tanzu Build Service image
resources automatically run a build that fails due to a missing dependency.
This error does not persist and subsequent builds automatically resolve this error.
Users can safely wait for the next build of their workloads, which is triggered
by source code changes.
To manually re-run builds, follow the instructions in the troubleshooting item
[Builds fail after upgrading to Tanzu Application Platform v1.2](tanzu-build-service/troubleshooting.md#tbs-1-2-breaking-change).

#### <a id="grype-scanner-changes"></a> Grype Scanner

- Provide information to integrate with the Supply Chain Security Tools - Store in the `tap-values.yaml` file for the Grype Scanner v1.2 and later.

### <a id='1-2-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id="app-acc-resolved"></a> Application Accelerator

- Limit server logging to startup and generate zip requests.
- Update engine to use Spring Boot v2.7.0.

#### <a id="scst-scan-resolved"></a>Supply Chain Security Tools - Scan

- `Go` updated to v1.18.2.
- `Open Policy Agent` updated to v0.40.0.

#### <a id="grype-scan-resolved"></a>Grype Scanner

- `ncurses` updated to v6.1-5.ph3.

#### <a id="apps-plugin-resolved"></a> Tanzu CLI - Apps plug-in

- Updated output for list when there are no workloads. It now shows a more user-friendly message `No workloads found.`
- Fixed error messaging for empty kubeconfig and invalid kube context.
- Fixed incorrect error message for `workload create` when the user did not have enough permissions to create a workload.
- Removing namespace from `--service-ref` is not ignored.
- Issue for Windows error x509: certificate signed by unknown authority by upgrading imgpkg v0.29.0. The new version supports loading Windows root CA certificates.

#### <a id="srvc-toolkit-resolved"></a> Services Toolkit

- ResourceClaims no longer mutate service resources with an annotation to mark a claimed resource.
- ResourceClaims no longer require the `update` permission when adding new service resources to Tanzu Application Platform.

#### <a id="srvc-bindings-resolved"></a> Service Bindings

- Added a new ClusterRole `service-binding-provisioned-services`  with label selector `servicebinding.io/controller: "true"` for get, list, and watch, which fixes the issue where Service Binding controller was aggregating non-provisioned service RBAC to the controller manager.

#### <a id="sprng-convs-resolved"></a> Spring Boot Conventions

- No environment variables are added if conventions are not applied. Fixes the issue where `JAVA_TOOL_OPTS` was added to non-JAVA apps.
- Controller does not error out if no image metadata is present. Fixes the edge case when the image metadata is missing.

#### <a id="tap-gui-resolved"></a>Tanzu Application Platform GUI

- Supply Chain plug-in:

  - **Details for ConfigMap CRD now appear as expected:** The error
  `Unable to retrieve conditions for ConfigMap...` no longer appears in the details section after
  clicking on the ConfigMap stage in the graph view of a supply chain.
  - **Scan results now appear as expected:** Current CVEs found during Image or Source scanning now
  appear as expected.

### <a id='1-2-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="tap-known-issues"></a>Tanzu Application Platform

- **Failure to connect to AWS EKS clusters:**
When connecting to AWS EKS clusters, an error might appear with the text
`Error: Unable to connect: connection refused. Confirm kubeconfig details and try again` or
`invalid apiVersion "client.authentication.k8s.io/v1alpha1"`.
To prevent this, see
[Failure to connect to AWS EKS clusters](troubleshooting-tap/troubleshoot-using-tap.md#connect-aws-eks-clusters).

- **Failure to add Tanzu Application Platform repo:**
Unable to add Tanzu Application Platform repo into clusters attached
to Tanzu Mission Control with pre-installed Cluster Essentials v1.2. For the solution, see [Troubleshoot installing Tanzu Application Platform](troubleshooting-tap/troubleshoot-install-tap.hbs.md#cant-add-tap-repo).

#### <a id="alv-known-issues"></a>Application Live View

- Application Live View with custom CA does not support air-gapped installation.

#### <a id="alv-ca-known-issues"></a>Application Single Sign-On

- Application Single Sign-On with custom CA does not support air-gapped installation.

#### <a id="conv-svc-known-issues"></a>Convention Service

- **Issue:**
  If the self-signed certificate authority (CA) for a registry is provided through `convention-controller.ca_cert_data`, it is not successfully propagated to the convention service. For the solution, see [Troubleshoot Convention Service](cartographer-conventions/troubleshooting.hbs.md#ca-not-propagated).

#### <a id="functions-issues"></a> Functions (beta)

- When using Live Update, hot reload of your function on your cluster might not
display changes made to your function.
To manually push changes to the cluster, run the `tilt up` command.

#### <a id="scst-scan-issues"></a>Supply Chain Security Tools - Scan

- **Blob Source Scan is reporting wrong source URL:**
When running a Source Scan of a blob compressed file, it looks for a `.git` directory present in the files to extract information that is usefull for the report sent to the Supply Chain Security Tools - Store deployment. This problem happens when you use Grype Scanner ScanTemplates earlier than version `v1.2.0` because the Scan Controller has a deprecated path to support previous ScanTemplates. This will be removed by Supply Chain Security Tools - Scan `v1.3.0`. For the solution, see [Observability and troubleshooting](scst-scan/observing.hbs.md#reporting-wrong-blob-url).

#### <a id="grype-scan-known-issues"></a>Grype scanner

- **Scanning Java source code that uses Gradle package manager may not reveal vulnerabilities:**
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

- **Tanzu Application Platform GUI doesn't work in Safari:**
  Tanzu Application Platform GUI does not work in the Safari web browser.

- **Supply Chain plug-in:**

    - The delivery section of the supply chain graph might show deliverables that do not pertain to
      the selected workload. This occurs if there is more than one `Build` cluster per namespace.
    - For `Deliverables` to show up for a `Workload`, they must have the following labels in both
      resources: `carto.run/workload-name`, `app.kubernetes.io/part-of`, and `carto.run/supply-chain-name`.
    - ConfigMap has no conditions and as a result its status is `Unknown`.
    - ConfigWriter shows an error but no error details are displayed.
    - You might receive the error `TypeError: Cannot read properties of undefined (reading 'data')`
      when viewing a workload in a supply chain.
      Use the CLI tools instead to view the status of the workload in the supply chain.

- **Back-end Kubernetes plug-in reporting failure in multicluster environments:**

  In a multicluster environment when one request to a Kubernetes cluster fails,
  `backstage-kubernetes-backend` reports a failure to the front end.
  This is a known issue with upstream Backstage and it applies to all released versions of
  Tanzu Application Platform GUI. For more information, see
  [this Backstage code in GitHub](https://github.com/backstage/backstage/blob/c7f88d041b671185dc7a01e716f80dca0709e2a1/plugins/kubernetes-backend/src/service/KubernetesFanOutHandler.ts#L250-L271).
  This behavior arises from the API at the Backstage level. There are currently no known workarounds.
  There are plans for upstream commits to Backstage to resolve this issue.

- **Runtime Resource Visibility plug-in:**
  When accessing the **Runtime Resources** tab from the **Component** view, the following warning appears:
  `Access error when querying cluster 'host' for resource '/apis/source.apps.tanzu.vmware.com/v1alpha1/mavenartifacts' (status: 403). Contact your administrator.`
  This issue is resolved in v1.2.1. In v1.2.0, the user can fix this issue by troubleshooting the
  [Maven artifacts access error](tap-gui/troubleshooting.hbs.md#maven-artifacts-error).

#### <a id="vscode-ext-known-issues"></a>VS Code Extension

- **Debugging ending prematurely:**
  When debugging an application with service bindings, debugging sessions might prematurely end on
  the first run only. This is because of services being late-bound.

- **Workloads panel only supports `kubeconfig`:**
  The Workloads panel only supports the default `kubeconfig` file, which is usually in `~/.kube/config`.

- **Unable to view workloads on the panel when connected to GKE cluster:**
  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#cannot-view-workloads).

- **Warning notification when canceling an action:**
  A warning notification can appear when running `Tanzu: Debug Start`, `Tanzu: Live Update Start`,
  or `Tanzu: Apply`, which says that no workloads or Tiltfiles were found.
  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#cancel-action-warning).

- **Live update might not work when using server or worker Workload types:**
  When using `server` or `worker` as
  [workload type](workloads/workload-types.hbs.md#-available-workload-types),
  live update might not work.
  For more information, see
  [Troubleshooting](vscode-extension/troubleshooting.hbs.md#lu-not-working-wl-types)

#### <a id="intelj-ext-known-issues"></a>Intellij Extension

- **Debugging ending prematurely:**
  When debugging an application with service bindings, debugging sessions might prematurely end on
  the first run only. This is because of services being late-bound.

- **Unable to view workloads on the panel when connected to GKE cluster:**
  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#cannot-view-workloads).

- **Live update might not work when using server or worker Workload types:**
  When using `server` or `worker` as
  [workload type](workloads/workload-types.hbs.md#-available-workload-types),
  live update might not work.
  For more information, see
  [Troubleshooting](intellij-extension/troubleshooting.hbs.md#lu-not-working-wl-types)

#### <a id="store-known-issues"></a>Supply Chain Security Tools - Store

- Querying by insight source returns zero CVEs even though there are CVEs in the source scan:
When attempting to look up CVE and affected packages, querying `insight source get` (or other
`insight source` commands) may return zero results due to supply chain configuration and repo URL.
See [Troubleshoot Supply Chain Security Tools - Store](scst-store/troubleshooting.hbs.md)
