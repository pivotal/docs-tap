# Release notes

{{#unless vars.hide_content}}
This Handlebars condition is used to hide content.
In release notes, this condition hides content that describes an unreleased patch for a released minor.
{{/unless}}
This topic contains release notes for Tanzu Application Platform v1.1

{{#unless vars.hide_content}}
## <a id='1-1-3'></a> v1.1.3

**Release Date**: MONTH DAY, 2022

### <a id='1-1-3-security-fixes'></a> Security fixes

### <a id='1-1-3-new-features'></a> Resolved issues

### <a id='1-1-3-known-issues'></a> Known issues

{{/unless}}

## <a id='1-1-2'></a> v1.1.2

**Release Date**: June 14, 2022

### <a id='1-1-2-security-fixes'></a> Security fixes

#### <a id="1-1-2-gui-sec-fixes"></a>Tanzu Application Platform GUI

- [CVE-2022-1664: Improper Limitation of a Pathname to a Restricted Directory](https://nvd.nist.gov/vuln/detail/CVE-2022-1664)
- [CVE-2022-1292: Improper Neutralization of Special Elements used in an OS Command](https://nvd.nist.gov/vuln/detail/CVE-2022-1292)
- [CVE-2022-25878: Improperly Controlled Modification of Object Prototype Attributes](https://nvd.nist.gov/vuln/detail/CVE-2022-25878)

### <a id='1-1-2-new-features'></a> Resolved issues

This release includes the following changes, listed by component and area.

#### Application Live View

- Application Live View Connector package now supports values without quotes in sslDisabled boolean flag.
- Application Live View Convention Service sets `tanzu.app.live.view.application.name` to `carto.run/workload-name` if not set in workload yaml.
- Application Live View now supports environment editing for newer Spring Boot apps.

#### <a id="1-1-2-scst-scan-grype-resolved"></a>Grype scanner

- Added useful error message when the Syft schema version embeded in images is not compatible with the current Syft schema version supported by the Grype version.
- `zlib` has been updated to `1.2.11-2.ph3`
- `subversion` has been updated to `1.10.8-2.ph3`

#### <a id="1-1-2-scst-scan-resolved"></a>Supply Chain Security Tools - Scan

- Fixed `SourceScan`s failing for a blob scan without `sourcescan.spec.revision` set and without a `.git` folder in the source code.
- Fixed the values schema to include an `importFromNamespace` key for the authentication token needed to communicate to the Metadata Store.

#### <a id="1-1-2-gui-resolved"></a>Tanzu Application Platform GUI

- CVE fixes
- Various styling and bug fixes

### <a id='1-1-2-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="1-1-2-known-issues-grype"></a>Grype scanner

**Scanning Java source code may not reveal vulnerabilities:**
Source Code Scanning only scans files present in the source code repository.
No network calls are made to fetch dependencies.
For languages using dependency lock files, such as Golang and Node.js,
Grype uses the lock files to check the dependencies for vulnerabilities.

For Java, dependency lock files are not guaranteed, so Grype uses
the dependencies present in the built binaries (`.jar` or `.war` files) instead.

Because VMware discourages committing binaries to source code repositories,
Grype fails to find vulnerabilities during a Source Scan.
The vulnerabilities are still found during the Image Scan,
after the binaries are built and packaged as images.

#### <a id="1-1-2-known-issues-scst-scan"></a>Supply Chain Security Tools - Scan

**Blob Source Scan is reporting wrong source URL:**
- When running a Source Scan of a blob compressed file, SCST - Scan looks for a `.git` directory present in the files to extract useful information for the report sent to the SCST - Store deployment.

- Workaround - The following workarounds fix this issue:

  1. This problem is resolved in SCST - Scan `v1.2.0`. Upgrade your SCST - Scan and Grype Scanner deployment to version `v1.2.0` or later.
  2. Configure your SourceScan or Workload to connect using HTTPS to the repository instead of using SSH.
  3. Edit the FluxCD GitRepository resource to not include the `.git` directory.

**Error: Unable to decode cyclonedx:**
Supply Chain Security Tools - Scan has a known issue where it will set the phase to `Error` and show an `unable to decode cyclonedx` error in the `Succeeded` condition. The root cause of the problem is not known, but it is an intermittent issue that cuts the CycloneDX XML stream to the logs and then the scan controller can't process the results properly.

**Workaround:** As this is an intermittent issue, if you're applying the scan manually, you can delete the scan and re-apply it again to retry the scan. If this problem happened while running a Supply Chain from the OOTB Supply Chains, you can run `kubectl get imagescans -n <workload namespace>` or `kubectl get sourcescans -n <workload namespace>` to get the scan name, delete it running `kubectl delete <imagescan or sourcescan> <scan name> -n <workload namespace>` and the Choreographer controller will recreate it for you.

#### <a id="1-1-2-known-issues-scst-sign"></a>Supply Chain Security Tools - Sign

Supply Chain Security Tools - Sign rejects images from private registries when the image is deployed to a
non-default namespace.
For a workaround, see [Supply Chain Security Tools - Sign rejects images](troubleshooting-tap/troubleshoot-using-tap.md#scst-sign-reject-imgs).

## <a id='1-1-1'></a> v1.1.1

**Release Date**: May 10, 2022

### <a id='1-1-1-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id="scc-resolved"></a>Supply Chain Choreographer plug-in

- ImageScan stage shows incorrect status
- Workloads page does not show errors
- Build stage shows error while building

#### <a id="scst-resolved"></a>Supply Chain Security Tools - Scan

- Resolved edge case for scan phase to correctly indicate `Error` when error occurs during scanning
- Added missing `SecretImport` for the RBAC Auth token `store-auth-token` for multicluster
- Resolved race condition involving reading Store secrets and exporting to the Scan Controller namespace

#### <a id="scst-sign-resolved"></a>Supply Chain Security Tools - Sign

- Updated golang to v1.17.9 to address [CVE-2022-27191](https://nvd.nist.gov/vuln/detail/CVE-2022-27191)

#### <a id="scst-store-resolved"></a>Supply Chain Security Tools - Store

- Updated `containerd` version to `v1.5.10` to resolve [GHSA-crp2-qrr5-8pq7](https://github.com/advisories/GHSA-crp2-qrr5-8pq7) in Github
- Updated postgres image to resolve [CVE-2018-25032](https://nvd.nist.gov/vuln/detail/CVE-2018-25032)
- Updated `brancz/kube-rbac-proxy` image to `0.12.0` to resolve [GHSA-c3h9-896r-86jm](https://github.com/advisories/GHSA-c3h9-896r-86jm) in Github
- Fixed the issue where new vulnerabilities are not appended to the existing packages
- Fixed the issue where Insight CLI plug-in fails to start on Windows platforms

#### <a id="grype-resolved"></a>Grype Scanner

- Removed package `gnutls` to address [CVE-2021-20232](https://nvd.nist.gov/vuln/detail/CVE-2021-20232) and [CVE-2021-20231](https://nvd.nist.gov/vuln/detail/CVE-2021-20231)
- Removed package `lua` to address [CVE-2022-28805](https://nvd.nist.gov/vuln/detail/CVE-2022-28805)
- Updated module `golang.org/x/crypto` to v0.0.0-20210220033148-5ea612d1eb83 to address [CVE-2022-27191](https://nvd.nist.gov/vuln/detail/CVE-2022-27191)

#### <a id="gui-resolved"></a>Tanzu Application Platform GUI

- CVE fixes
- Various styling fixes
- TLS Certificate and Ingress bug fix
- Supply Chain plug-in upgrade

### <a id='1-1-1-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="1-1-1-known-issues-grype"></a>Grype scanner

**Scanning Java source code may not reveal vulnerabilities:**
Source Code Scanning only scans files present in the source code repository.
No network calls are made to fetch dependencies.
For languages using dependency lock files, such as Golang and Node.js,
Grype uses the lock files to check the dependencies for vulnerabilities.

For Java, dependency lock files are not guaranteed, so Grype uses
the dependencies present in the built binaries (`.jar` or `.war` files) instead.

Because VMware discourages committing binaries to source code repositories,
Grype fails to find vulnerabilities during a Source Scan.
The vulnerabilities are still found during the Image Scan,
after the binaries are built and packaged as images.

#### <a id="1-1-1-known-issues-scc"></a> Supply Chain Choreographer for Tanzu

- **`SourceScan` error when deploying Java functions workloads:**
  Using Out of the Box Supply Chain with Testing and Scanning to deploy Java functions workloads
  causes a `SourceScan` error.
  The workload deployed shows an error for `SourceScan` because it cannot find the scan template.
  You can receive enhanced scanning coverage for Java and Node.js workloads, including application
  runtime layer dependencies, by using both Tanzu Build Service and Grype in your
  Tanzu Application Platform supply chain. Python workloads are not supported.

#### <a id="1-1-1-known-issues-scst-scan"></a>Supply Chain Security Tools - Scan

The Supply Change Security Tools - Scan has the following CVEs at high severity
from the `kube-rbac-proxy v0.11.0-vmware.1` image:

#### <a id="1-1-1-known-issues-scst-store"></a>Supply Chain Security Tools - Store

The Supply Change Security Tools - Store has [CVE-2022-21698](https://nvd.nist.gov/vuln/detail/CVE-2022-21698)
at high severity from `brancz/kube-rbac-proxy:0.12.0` image.

#### <a id="1-1-1-known-issues-gui"></a>Tanzu Application Platform GUI

- **Accelerators not appearing on Accelerator page:**
  If the `app_config.backend.reading.allow` section is configured during the `tap-gui` package
  installation, no accelerators show on the accelerator page.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#no-accelerators).

## <a id='1-1'></a> v1.1

**Release Date**: April 12, 2022


### Prerequisites

Installation requires Kubernetes clusters v1.21, v1.22, or v1.23.
See [prerequisites](prerequisites.md) for supported Kubernetes platforms.

### <a id='1-1-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### Installing

There are four new profiles available, and additions to the Full profile.
The inclusion of new profiles supports a multicluster deployment architecture.

* **Tanzu Application Platform profile - Iterate** is intended for iterative development in contrast to the path to production.

* **Tanzu Application Platform profile - Build** is intended for the transformation of source revisions to workload revisions. Specifically, it's for hosting workloads and SupplyChains.

* **Tanzu Application Platform profile - Run** is intended for the transformation of workload revisions to running pods. Specifically, it's for hosting deliveries and deliverables.

* **Tanzu Application Platform profile - View** is intended for instances of applications related to centralized developer experiences, such as Tanzu Application Platform GUI and Metadata Store.

* **Tanzu Application Platform profile - Full** contains all of the Tanzu Application Platform packages. New packages in the Full profile:
    - Application Live View (Build)
    - Application Live View (Run)
    - Application Live View (GUI)
    - Default Roles
    - Telemetry

#### Default roles for Tanzu Application Platform

There are five new default roles and related permissions that apply to Kubernetes resources.
These roles help operators set up common sets of permissions to limit the access that users and
service accounts have on a cluster that runs Tanzu Application Platform.

Three roles are for users, including `app-editor`, `app-viewer` and `app-operator`.
Two roles are for “robot” or system permissions, including `workload` and `deliverable`.

For more information, see [Overview of Default Roles](authn-authz/overview.md).

#### <a id="app-acc-features"></a> Application Accelerator

- Option values can now be validated using regex
- TLS for ingress is enabled using `ingress.enable_tls` flag during package install

#### Application Live View

- Application Live View supports a multicluster setup now
- Application Live View components are split into three bundles with new package reference names (backend, connector, conventions)
- Application Live View Convention Service is compatible with cert-manager v1.7.1
- Application Live View Convention takes the management port setting from the Spring Boot Convention into account
- Structured JSON logging is integrated into Application Live View Backend and Application Live View Convention
- Updated Spring Native v0.10.5 to v0.10.6

#### Tanzu CLI - Apps plug-in

- `workload create/update/apply`:
  - Accept `workload.yaml` from stdin (through `--file -`).
  - Enable providing `spec.build.env` values (through new `–build.env` flag).
  - When `--git-repo` and `--git-tag` are provided, `git-branch` is not required.
  - Add new `--annotations` flag. Annotations provided are propagated to the running pod for the workload.
- `workload list`:
  - Shorthand `-A` can be passed in for `--all-namespaces`.
- `workload get`:
  - Service Claim details are returned in command output.
  - The existing STATUS value in the pods table in the output reflects when a pod is terminating.
- Deprecation
  - The `namespace` value you can pass for the `--service-ref` flag is deprecated.
  - A deprecation warning message is added to the `workload create/update/apply...` when user specifies a namespace in the `--service-ref` object.

#### Service Bindings

- Applied [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339) timestamps to service binding logs.
- Added Tanzu Application Platform aggregate roles to support Tanzu Application Platform Authentication and Authorization (new feature referenced above).
- Added support for servicebinding.io/v1beta1
- Corrected Postgres resource pluralization error.

#### Source Controller

- Enable Source Controller to connect to image registries that use self-signed or private certificate authorities to support air-gapped installations. This is an optional configuration. See [Source Controller Installation](source-controller/install-source-controller.md) for details.
- Applied [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339) timestamps to source controller logs.
- Added Tanzu Application Platform aggregate roles to support Tanzu Application Platform Authentication and Authorization (new feature referenced above).

#### Spring Boot Conventions

- **Set the management port to `8081`:** This is instead of the default port `8080`.
  - This change increases the security of Spring Boot apps running on the
  platform by preventing access to actuator endpoints. Actuator endpoints
  can leak sensitive information and allow access to trigger actions that can impact the app.
  - If the app explicitly sets the management port using the `JAVA_TOOL_OPTIONS`
  in the `workload.yaml`, the Spring Boot conventions respect that setting
  and do not set the management port to `8081`. For more information, see
  [Set the `JAVA_TOOL_OPTIONS` property for a workload](spring-boot-conventions/reference/CONVENTIONS.md#set-java-tool-options).
  - The convention overrides other common management port configuration methods
  such as `application.properties/yml` and `config server`.
- **RFC-3339 timestamps:** Applied [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339) timestamps to service binding logs.
- **Added Kubernetes liveness and readiness probes by using Spring Boot health endpoints:**
  - This convention is applied to Spring Boot v2.6 and later apps.
  - The probes are exposed on the main serving port for the app, which is port `8080` by default.

#### Supply Chain Choreographer

- All Supply Chains provided by Tanzu Application Platform support pre-built images for workloads
- Supply Chains can select workloads by fields and expressions in addition to labels
- Supply Chains can select which template to stamp out based on optional criteria
- Workloads include stamped resource references in their status

#### Supply Chain Security Tools - Scan

Support for configuring Supply Chain Security Tools - Scan to remotely connect to Supply Chain Security Tools - Store in a different cluster.

#### Supply Chain Security Tools - Sign

- Support configuring Webhook resources
- Support configuring Namespace where webhook is installed
- Support for registries with self-signed certificates

#### Supply Chain Security Tools - Store

- Added Contour Ingress support with custom domain name
- Created Tanzu CLI plug-in called `insight`. Currently, `insight` plug-in only supports macOS and Linux.

#### Tanzu Application Platform GUI

- Added improvements to the information presentation and filtering mechanisms of the Runtime Resources tab
- Added the new Supply Chain plug-in
- Added the Backstage API Documentation plug-in
- Updated overall theme to Clarity City
- Added compatibility with v1beta3 Backstage Templates
- Small security fixes
- Various accessibility and styling fixes

Plug-in improvements and additions include:

- **Runtime Resources Visibility plug-in:**
  - Textual and enumerated table column filters for ease of search
  - Meaningful error messages and paths forward to troubleshoot issues
  - Tags in Knative revision table on the details page
  - Kubernetes Service on the resources page to provide more insights into Kubernetes service details
  - Improved UI components for a more accessible user experience

- **Supply Chain Choreographer plug-in:**
  - Added a graphical representation of the execution of a workload by using an installed supply chain. This includes CRDs in the supply chain, the source results of each stage, and details to facilitate the troubleshooting of workloads on their path to production.

#### Functions (Beta)

Tanzu Application Platform enables developers to deploy functions, use starter templates to bootstrap
their functions and write only the code that matters to your business.
Developers can run a single CLI command to deploy their functions to an auto-scaled cluster.
This feature is in beta and subject to changes based on user feedback.
It is intended for evaluation and test purposes only.

For more information, see [Functions](workloads/functions.md).


### <a id='1-1-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.


#### <a id="app-acc-changes"></a> Application Accelerator

When enabling ingress, the TLS support must now be explicitly enabled using `ingress.tls_enable`.

#### Supply Chain Security Tools - Scan

API version `scanning.apps.tanzu.vmware.com/v1alpha1` is deprecated.

#### Supply Chain Security Tools - Store

- The independent `insight` CLI is deprecated. You can now use the Tanzu CLI plug-in Tanzu Insight, which currently supports macOS and Linux only.
- Renamed all instances of the `create` verb as `add` for all CLI commands.


### <a id='1-1-resolved-issues'></a> Resolved issues

This following issues, listed by area and component, are resolved in this release.

#### <a id="app-acc-resolved"></a> Application Accelerator

Accelerator engine no longer fails with `java.lang.OutOfMemoryError: Direct buffer memory` when processing very large Git repositories.

#### <a id="alv-resolved"></a> Application Live View

Updated Spring Boot to v2.5.12 to address [CVE-2022-22965](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-22965) and [CVE-2020-36518](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-36518)

#### Services Toolkit

- Resolved an issue with the `tanzu services` CLI plug-in that meant it was not compatible with Kubernetes clusters running on GKE.
- Fixed a potential race condition during reconciliation of ResourceClaims which might have caused the Services Toolkit manager to stop responding.
- Updated configuration of the Services Toolkit carvel Package to prevent an unwanted build up of ConfigMap resources.

#### Supply Chain Security Tools - Scan

- Resolved two scan jobs and two scan pods that are created when reconciling `ScanTemplates` and `ScanPolicies`
- Updated package `client_golang` to v1.11.1 to address [CVE-2022-21698](https://nvd.nist.gov/vuln/detail/CVE-2022-21698)

#### Grype Scanner

- Updated golang to v1.17.8 to address [CVE-2022-24921](https://nvd.nist.gov/vuln/detail/CVE-2022-24921)
- Updated photon to address [CVE-2022-23308](https://nvd.nist.gov/vuln/detail/CVE-2022-23308) and [CVE-2022-0778](https://nvd.nist.gov/vuln/detail/CVE-2022-0778)

#### Supply Chain Security Tools - Store

- Fixed an issue where querying a source report with local path name returned the following error: `{ "message": "Not found" }`.
- Return related packages when querying image and source vulnerabilities.
- Ratings are updated when updating vulnerabilities.
- Fixed [CVE-2022-24407](https://nvd.nist.gov/vuln/detail/CVE-2022-24407) and [CVE-2022-0778](https://nvd.nist.gov/vuln/detail/CVE-2022-0778) found in the PostgreSQL image.
- Updated package `client_golang` to v1.17.8 to address [CVE-2022-24921](https://nvd.nist.gov/vuln/detail/CVE-2022-24921).

#### Tanzu CLI - Apps plug-in

- Apps plug-in no longer fails when `KUBECONFIG` includes the colon (`:`) config file delimiter.
- `tanzu apps workload get`: Passing in `--output json` and `--export` flags together exports the workload in JSON rather than YAML.
- `tanzu apps workload tail`: Duplicate log entries created for init containers are removed.
- `tanzu apps workload create/update/apply`
  - When the `--wait` flag passed and the dialog box "Do you want to create this workload?"
  is declined, the command immediately exits 0, rather than hanging and continuing to wait.
  - Workload name is now validated when the workload values are passed in by using `--file workload.yaml`.
  - When creating or applying a workload from –local-path, if user answers “No” to the prompt “Are you sure you want to publish your local code to [registry name] where others may be able to access it?”, the command now exits 0 immediately rather than showing the workload diff and prompting to continue with workload creation.
  - `.spec.build.env` in workload YAML definition file is being removed when using Tanzu apps workload apply command.

#### Tanzu Application Platform GUI

Applied a fix for [CVE-2021-3918](https://nvd.nist.gov/vuln/detail/CVE-2021-3918) from the `json-schema` package


### <a id='1-1-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### Tanzu Application Platform

**Deprecated profile:** Tanzu Application Platform light profile is deprecated.

#### Tanzu Cluster Essentials

- **Feature Disabled error:**
When adding Tanzu Application Platform clusters with pre-installed Tanzu Cluster Essentials to a
Tanzu Mission Control instance, the `tanzunet-secret` export shows `Feature Disabled`.

- **--export-all-namespaces not properly observed:**
When deploying Tanzu Application Platform on Google Kubernetes Engine (GKE) v1.23.5-gke.200
and running `tanzu secret registry add tanzunet-creds`, the `--export-all-namespaces` is not
properly observed.

#### Application Live View

- **Application Live View Connector sometimes does not connect to the back end:**
Search the Application Live View Connector pod logs for issues with rsocket connection
to the back end. If you find any issues, delete the connector pod to recreate it:

    ```console
    kubectl -n app-live-view delete pods -l=name=application-live-view-connector
    ```

- **Application Live View Convention auto-exposes all actuators:**
Application Live View Convention exposes all Spring Boot actuator endpoints by default to
whatever is configured using the Spring Boot Convention for the management port.
You can change this configuration if it does not suit your needs.
For more information, see [Convention Server](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.1/docs/GUID-convention-server.html).

- **Frequent Application Live View Connector restarts:**
In some cases, the Application Live View Connector component restarts frequently.
This usually doesn't cause problems when using Application Live View.

- **No structured JSON logging on the connector:**
The format of the log output of the Application Live View Connector component is not currently
aligned with the standard Tanzu Application Platform logging format.
A fix is planned for Tanzu Application Platform v1.1.1.


#### Grype scanner

**Scanning Java source code may not reveal vulnerabilities:**
Source Code Scanning only scans files present in the source code repository. No network calls are made to fetch dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the lock files to check the dependencies for vulnerabilities.

For Java, dependency lock files are not guaranteed, so Grype instead uses the dependencies present in the built binaries (`.jar` or `.war` files).

Because VMware discourages committing binaries to source code repositories, Grype fails to find vulnerabilities during a Source Scan. The vulnerabilities are still found during the Image Scan, after the binaries are built and packaged as images.

#### Supply Chain Choreographer plug-in

- **Details for ConfigMap CRD not appearing:** The error `Unable to retrieve conditions for ConfigMap...`
appears in the details section after clicking on the ConfigMap stage in the
graph view of a supply chain.
This error does not necessarily mean that the workload failed its execution through the supply chain.
- **Scan results not shown:** Current CVEs found during Image or Build scanning do not appear. However, results are still present in the metadata store and are available by using the Tanzu CLI.

#### <a id='1-1-known-issues-scst'></a>Supply Chain Security Tools - Scan

- **Scan Phase indicates `Scanning` incorrectly:** Scans have an edge case that when an error
occurs during scanning, the `Scan Phase` field is not updated to `Error` and remains in the
`Scanning` phase. Read the scan pod logs to verify the existence of an error.

- **Multicluster Support: Error sending results to SCST - Store running in a different cluster:**
During installation, Supply Chain Security Tools - Scan (Scan) creates the
`SecretImport` for ingesting the TLS CA certificate secret,
but misses the `SecretImport` for the RBAC Auth token. See, [Troubleshooting Supply Chain Security Tools - Store](scst-store/troubleshooting.hbs.md#multicluster-store).

- **User sees error message indicating Supply Chain Security Tools - Store (Store)
is not configured even though configuration values were supplied:**
The Scan Controller experiences a race-condition when deploying Store in the same cluster,
that shows Store as not configured, even when it is present and properly configured.
This happens when the Scan Controller is deployed and reconciled before the Store
is reconciled and the corresponding secrets are exported to the Scan Controller namespace.
As a workaround, after your Store is successfully reconciled,
restart your Supply Chain Security Tools - Scan deployment by running:

    ```console
    kubectl rollout restart deployment.apps/scan-link-controller-manager -n scan-link-system
    ```

    >**Note:** If you deploy Supply Chain Security Tools - Scan to a different namespace than the default one,
    replace `-n scan-link-system` with `-n <my_custom_namespace>`.

#### Supply Chain Security Tools - Store

- **Tanzu Insight CLI plug-in does not support Windows:**

    Currently, the Tanzu Insight plug-in only supports macOS and Linux.

- **Existing packages with new vulnerabilities not updated:**

    It is a known issue that Supply Chain Security Tools - Store does not correctly save new vulnerabilities for a package that was already submitted in a previous report. This issue causes new vulnerabilities not saved to the database.

- **Persistent volume retains data:**

    If Supply Chain Security Tools - Store is deployed, deleted, redeployed, and the database password is changed during the redeployment, the `metadata-store-db` pod fails to start.
    The cause is the persistent volume that PostgreSQL uses retaining old data, even though the retention policy is set to `DELETE`.

    To resolve this issue, see [solution](scst-store/troubleshooting.md#persistent-volume-retains-data-solution).

- **Missing persistent volume:**

    After Supply Chain Security Tools - Store is deployed, `metadata-store-db` pod might fail for missing
    volume while `postgres-db-pv-claim` pvc is in the `PENDING` state.
    This issue might occur if the cluster where Supply Chain Security Tools - Store is deployed does not have
    `storageclass` defined.

    The provisioner of `storageclass` is responsible for creating the persistent volume after
    `metadata-store-db` attaches `postgres-db-pv-claim`. To resolve this issue, see
    [solution](scst-store/troubleshooting.md#missing-persistent-volume-solution).

- **No support for installing in custom namespaces:**

    Supply Chain Security Tools — Store is deployed to the `metadata-store` namespace.
    There is no support for configuring the namespace.

#### Tanzu Application Platform GUI

- **Tanzu Application Platform GUI doesn't work in Safari:**
  Tanzu Application Platform GUI does not work in the Safari web browser.

- **Runtime Resources errors:**
  The **Runtime Resources** tab shows cluster query errors when attempting to retrieve Kubernetes
  object details from clusters that are not on the Full profile.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#runtime-resource-visibility)

- **Supply Chain displays incorrect data if there are workloads with same name and namespace:**
  When there are two workloads that have the same name and namespace, but exist on different clusters,
  clicking either of them in the supply chain page always shows the details for the first one.
  There is no way to access details for the second.

- **Back-end Kubernetes plug-in reporting failure in multicluster environments:**

  In a multicluster environment when one request to a Kubernetes cluster fails,
  `backstage-kubernetes-backend` reports a failure to the front end.
  This is a known issue with upstream Backstage and it applies to all released versions of
  Tanzu Application Platform GUI. For more information, see
  [this Backstage code in GitHub](https://github.com/backstage/backstage/blob/c7f88d041b671185dc7a01e716f80dca0709e2a1/plugins/kubernetes-backend/src/service/KubernetesFanOutHandler.ts#L250-L271).
  This behavior arises from the API at the Backstage level. There are currently no known workarounds.
  There are plans for upstream commits to Backstage to resolve this issue.
