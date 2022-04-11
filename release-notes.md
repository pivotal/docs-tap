# Release notes

This topic contains release notes for Tanzu Application Platform v1.1

## <a id='1-1'></a> v1.1

**Release Date**: MMMM DD, 2022

### <a id='1-1-new-features'></a> New features

###Prerequisites
Installation requires Kubernetes clusters v1.21, v1.22, or v1.23. See [prerequisites](./prerequisites.md) for supported Kubernetes platforms.


#### Installing
There are 4 new profiles available, and additions to the Full profile. The inclusion of new profiles supports a multi-cluster deployment architecture.

* **Tanzu Application Platform profile - Iterate** is intended for iterative development versus the path to production.

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
- TLS for ingress are enabled using `ingress.enable_tls` flag during package install

#### Application Live View

- Application Live View supports a multi-cluster setup now
- Application Live View components are split into three bundles with new package reference names (backend, connector, conventions)
- Application Live View Convention Service is compatible with cert-manager v1.7.1
- Application Live View Convention takes the management port setting from the Spring Boot Convention into account
- Structured JSON logging is integrated into Application Live View Backend and Application Live View Convention
- Updated Spring Native v0.10.5v to v0.10.6
- Updated Spring Boot to v2.5.12 to address [CVE-2022-22965](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-22965) and [CVE-2020-36518](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-36518)

#### Tanzu CLI - Apps plug-in

- `workload create/update/apply`:
  - Accept `workload.yaml` from stdin (through `--file -`).
  - Enable providing `spec.build.env` values (through new `–build.env` flag).
  - When `--git-repo` and `--git-tag` are provided, `git-branch` is not required.
  - Add new `--annotations` flag. Annotation(s) provided are propagated to the running pod for the workload.
- `workload list`:
  - Shorthand `-A` can be passed in for `--all-namespaces`.
- `workload get`:
  - Service Claim details are returned in command output.
  - The existing STATUS value in the Pods table in the output reflects when a pod is “Terminating.”

**Deprecation**
* The `namespace` value you can pass for the `--service-ref` flag is deprecated.
  * A deprecation warning message is added to the `workload create/update/apply...` when user specifies a namespace in the `--service-ref` object.

#### Service Bindings

- Applied [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339) timestamps to service binding logs.
- Added Tanzu Application Platform aggregate roles to support Tanzu Application Platform Authentication and Authorization (new feature referenced above).
- Added support for servicebinding.io/v1beta1
- Corrected Postgres resource pluralization error.

#### Source Controller

- Enable Source Controller to connect to image registries that use self-signed or private certificate authorities to support airgapped installations
  - This is an optional configuration
  - See [Source Controller Installation](source-controller/install-source-controller.md) for details
- Applied [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339) timestamps to source controller logs.
- Added Tanzu Application Platform aggregate roles to support Tanzu Application Platform Authentication and Authorization (new feature referenced above).

#### Spring Boot Conventions

- **Set the management port to `8081`:** This is instead of the default port `8080`.
  - This change increases the security of Spring Boot apps running on the
  platform by preventing access to actuator endpoints. Actuator endpoints
  can leak sensitive information and allow access to trigger actions that can impact the app.
  - If the app explicitly sets the management port using the `JAVA_TOOL_OPTIONS`
  in the `workload.yaml`, the Spring Boot conventions will respect that setting
  and will not set the management port to `8081`. For more information, see
  [Set the `JAVA_TOOL_OPTIONS` property for a workload](spring-boot-conventions/reference/CONVENTIONS.md#set-java-tool-options).
  - The convention overrides other common management port configuration methods
  such as `application.properties/yml` and `config server`.
- **RFC-3339 timestamps:** Applied [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339) timestamps to service binding logs.
- **Added Kubernetes liveness and readiness probes by using Spring Boot health endpoints:**
  - This convention is applied to Spring Boot v2.6 and later apps.
  - The probes will be exposed on the main serving port for the app, which is port `8080` by default.

#### Supply Chain Choreographer

- All Supply Chains provided by Tanzu Application Platform support pre-built images for workloads
- Supply Chains can select workloads by fields and expressions in addition to labels
- Supply Chains can select which template to stamp out based on optional criteria
- Workloads include stamped resource references in their status

#### Supply Chain Security Tools - Scan

- Support for configuring Supply Chain Security Tools - Scan to remotely connect to Supply Chain Security Tools - Store in a different cluster.

#### Supply Chain Security Tools - Sign

- Support configuring Webhook resources
- Support configuring Namespace where webhook is installed
- Support for registries with self-signed certificates

#### Supply Chain Security Tools - Store

- Added Contour Ingress support with custom domain name
- Created Tanzu CLI plug-in called `insight`
  - Currently, `insight` plug-in only supports MacOS and Linux.
- Upgraded golang version from `1.17.5` to `1.17.8`

#### <a id="gui-features"></a> Tanzu Application Platform GUI

- Added improvements to the information presentation and filtering mechanisms of the Runtime Resources tab
- Added the new Supply Chain plug-in
- Added the Backstage API Documentation Plug-in
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

The function experience on Tanzu Application Platform enables developers to deploy functions, use starter templates to bootstrap their function and write only the code that matters to your business. Developers can run a single CLI command to deploy their functions to an auto-scaled cluster.

>**Note:** This functionality is in beta and subject to changes based on users feedback. It is intended for evaluation and test purposes only.

For more information, see [Functions](workloads/functions.md).

### <a id='1-1-breaking-changes'></a> Breaking changes

#### <a id="app-acc-changes"></a> Application Accelerator

- When enabling ingress the TLS support must now be explicitly enabled using `ingress.tls_enable`.

#### Supply Chain Security Tools - Scan

- **Deprecated API version:** API version `scanning.apps.tanzu.vmware.com/v1alpha1` is deprecated.

#### Supply Chain Security Tools - Store

- The independent `insight` CLI is deprecated, customers can now use Tanzu CLI plugin called `insight`.
  - Renamed all instances of `create` verb to `add` for all CLI commands.
  - Currently, `insight` plug-in only supports MacOS and Linux.

### <a id='1-1-security-issues'></a> Security issues

This release has the following security issues:

None.

### <a id='1-1-resolved-issues'></a> Resolved issues

#### <a id="app-acc-resolved"></a> Application Accelerator

- Accelerator engine no longer fails with "java.lang.OutOfMemoryError: Direct buffer memory" when processing very large Git repositories.

#### Services Toolkit

- Resolved an issue with the `tanzu services` CLI plug-in which meant it was not compatible with Kubernetes clusters running on GKE.
- Fixed a potential race condition during reconciliation of ResourceClaims which might cause the Services Toolkit manager to stop responding.
- Updated configuration of the Services Toolkit carvel Package to prevent an unwanted build up of ConfigMap resources.

#### Supply Chain Security Tools - Scan

- Resolved two scan jobs and two scan pods that are created when reconciling `ScanTemplates` and `ScanPolicies`
- Updated package `client_golang` to v1.11.1 to address [CVE-2022-21698](https://nvd.nist.gov/vuln/detail/CVE-2022-21698)

#### Grype Scanner

- Updated golang to v1.17.8 to address [CVE-2022-24921](https://nvd.nist.gov/vuln/detail/CVE-2022-24921)
- Updated photon to address [CVE-2022-23308](https://nvd.nist.gov/vuln/detail/CVE-2022-23308) and [CVE-2022-0778](https://nvd.nist.gov/vuln/detail/CVE-2022-0778)

#### Supply Chain Security Tools - Store

- Fixed an issue where querying a source report with local path name would return the following error: `{ "message": "Not found" }`.
- Return related packages when querying image and source vulnerabilities.
- Ratings are updated when updating vulnerabilities.

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


### <a id='1-1-known-issues'></a> Known issues

#### Tanzu Application Platform

- **Deprecated profile:** Tanzu Application Platform light profile is deprecated.

### Tanzu Cluster Essentials
- **When adding Tanzu Application Platform clusters with pre-installed Tanzu Cluster Essentials to a Tanzu Mission Control instance, the tanzunet-secret Export will show Feature Disabled.
- ##When deploying Tanzu Application Platform on Google Kubernetes Engine (GKE) `v1.23.5-gke.200`, during the step `tanzu secret registry add tanzunet-creds` the `--export-all-namespaces` will not be properly observed.

#### Application Live View

- **Application Live View Connector sometimes does not connect to the back end:**
Search the Application Live View Connector pod logs for issues with rsocket connection
to the back end. If you find any issues, delete the connector pod to recreate it:

    ```
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

- **Scanning Java source code may not reveal vulnerabilities:** Source Code Scanning only scans
files present in the source code repository. No network calls are made to fetch dependencies.
For languages using dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check the dependencies for vulnerabilities.
- For Java, dependency lock files are not guaranteed, so Grype instead uses the
dependencies present in the built binaries (`.jar` or `.war` files).
- Because VMware does not recommend committing binaries to source code repositories, Grype
fails to find vulnerabilities during a Source Scan. The vulnerabilities are still found during the
Image Scan, after the binaries are built and packaged as images.

#### Supply Chain Choreographer plug-in

- **Details for ConfigMap CRD not appearing:** The error `Unable to retrieve conditions for ConfigMap...`
appears in the details section after clicking on the ConfigMap stage in the
graph view of a supply chain.
This error does not necessarily mean that the workload failed its execution through the supply chain.
- **Scan results not shown:** Current CVEs found during Image or Build scanning do not appear. However, results are still present in the metadata store and are available by using the Tanzu CLI.

#### Supply Chain Security Tools - Scan

- **Scan Phase indicates `Scanning` incorrectly:** Scans have an edge case that when an error
  occurs during scanning, the `Scan Phase` field is not updated to `Error` and remains in the
  `Scanning` phase. Read the scan pod logs to verify the existence of an error.
- **Multi-Cluster Support: Error sending results to Supply Chain Security Tools - Store (Store) running in a different cluster** The [Store Ingress and multicluster support](scst-store/ingress-multicluster.md) document instructs you on how to create `SecretExports` to share secrets for communicating with the Store. During installation, Supply Chain Security Tools - Scan (Scan) automatically creates the `SecretImport` necessary for ingesting the TLS CA certificate secret, but is missing the `SecretImport` for the RBAC Auth token. As a workaround, apply the following YAML, updating the namespaces if necessary, to the cluster running Scan and then perform a rolling restart:
  ```yaml
  ---
  apiVersion: secretgen.carvel.dev/v1alpha1
  kind: SecretImport
  metadata:
    name: store-auth-token
    namespace: scan-link-system
  spec:
    fromNamespace: metadata-store-secrets
  ```
  The necessary `Secret` for the RBAC Auth token is created and the scan can be re-run.

  A rolling restart includes running the following:

  ```
  kubectl rollout restart deployment.apps/scan-link-controller-manager -n scan-link-system
  ```
#### Supply Chain Security Tools - Store

- **`insight` CLI plug-in does not support Windows:**

    Currently, `insight` plug-in only supports MacOS and Linux.

- **Existing packages with new vulnerabilities not updated:**

    It is a known issue that **Supply Chain Security Tools - Store** does not correctly save new vulnerabilities for a package that was already submitted in a previous report. This issue causes new vulnerabilities not saved to the database.

- **Persistent volume retains data:**

    If **Supply Chain Security Tools - Store** is deployed, deleted, redeployed, and the database password is changed during the redeployment, the
    `metadata-store-db` pod fails to start.
    This is caused by the persistent volume used by postgres retaining old data, even though the retention
    policy is set to `DELETE`.

    To resolve this issue, see [solution](scst-store/troubleshooting.md#persistent-volume-retains-data-solution).

- **Missing persistent volume:**

    After **Supply Chain Security Tools - Store** is deployed, `metadata-store-db` pod might fail for missing
    volume while `postgres-db-pv-claim` pvc is in the `PENDING` state.
    This issue might occur if the cluster where **Supply Chain Security Tools - Store** is deployed does not have
    `storageclass` defined.

    The provisioner of `storageclass` is responsible for creating the persistent volume after
    `metadata-store-db` attaches `postgres-db-pv-claim`. To resolve this issue, see
    [solution](scst-store/troubleshooting.md#missing-persistent-volume-solution).

- **No support for installing in custom namespaces:**

    **Supply Chain Security Tools — Store** is deployed to the `metadata-store` namespace.
    There is no support for configuring the namespace.

#### Tanzu Application Platform GUI

- **Runtime Resources errors:** The Runtime Resources tab shows cluster query errors when attempting to retrieve Kubernetes object details from non-full-profile clusters.
