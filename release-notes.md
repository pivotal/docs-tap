# Release notes

This topic contains release notes for Tanzu Application Platform v1.1

## <a id='1-1'></a> v1.1

**Release Date**: MMMM DD, 2022

### <a id='1-1-new-features'></a> New features

#### Installing

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

#### Tanzu Application Platform GUI

Plug-in improvements and additions include:

- **Runtime Resources Visibility plug-in:**
  - Textual and enumerated table column filters for ease of search
  - Meaningful error messages and paths forward to troubleshoot issues
  - Tags in Knative revision table on the details page
  - Kubernetes Service on the resources page to provide more insights into Kubernetes service details
  - Improved UI components for a better, and more accessible, user experience

- **Supply Chain Choreographer plug-in:**
Added a graphical representation of the execution of a workload by using an installed supply chain.
This includes CRDs in the supply chain, the source results of each stage, and details to facilitate
the troubleshooting of workloads on their path to production.

#### <a id="app-acc-features"></a> Application Accelerator

- Option values can now be validated using regex
- TLS for ingress are enabled using `ingress.enable_tls` flag during package install

#### Application Live View

- Application Live View supports a multi-cluster setup now
- Application Live View components are split into three bundles with new package reference names (backend, connector, conventions)
- Application Live View Convention Service now compatible with the cert-manager version `1.7.1`
- Application Live View Convention now taking the management port setting from the Spring Boot Convention into account
- structured JSON logging integrated into Application Live View Backend and Application Live View Convention
- Updated Spring Native `0.10.5` to `0.10.6`
- Updated `Spring Boot` to `2.5.12` to address `CVE-2022-22965` and `CVE-2020-36518`

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
  and will not set the management port to `8081`. For more information about `JAVA_TOOL_OPTIONS`, see
  [Conventions](spring-boot-conventions/reference/CONVENTIONS.md#set-java-tool-options-property).
  - The convention overrides other common management port configuration methods
  such as `application.properties/yml` and `config server`.
- **RFC-3339 timestamps:** Applied [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339) timestamps to service binding logs.
- **Added Kubernetes liveness and readiness probes by using Spring Boot health endpoints:**
  - This convention is applied to Spring Boot v2.6 and later apps.
  - The probes will be exposed on the main serving port for the app, which is port `8080` by default.


#### Supply Chain Security Tools - Scan

- Support for configuring Supply Chain Security Tools - Scan to remotely connect to Supply Chain Security Tools - Store in a different cluster.

#### Supply Chain Security Tools – Sign

- Support configuring Webhook resources
- Support configuring Namespace where webhook is installed
- Support for registries with self-signed certificates

#### Supply Chain Security Tools - Store

- Added Contour Ingress support with custom domain name
- Created Tanzu CLI plug-in called `insight`
  - Currently, `insight` plug-in only supports MacOS and Linux.
- Upgraded golang version from `1.17.5` to `1.17.8`

#### <a id="gui-features"></a> Tanzu Application Platform GUI

- **Runtime Resources Visibility plug-in:**
- **Supply Chain Choreographer plug-in:** Added a new graphical representation of
the execution of a workload by using an installed supply chain.
This includes CRDs in the supply chain, the source results of each stage, and
details to facilitate the troubleshooting of workloads on their path to production.  

#### Functions (Beta)

The function experience on Tanzu Application Platform enables developers to deploy functions, use starter templates to bootstrap their function and write only the code that matters to your business. Developers can run a single CLI command to deploy their functions to an auto-scaled cluster.

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

#### Supply Chain Security Tools – Scan

- Resolved two scan jobs and two scan pods being created when reconciling `ScanTemplates` and `ScanPolicies`.

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

#### Application Live View

- **App Live View connector sometimes does not connect to the backend **
  Workaround: Check the app live view connector pod logs to see if there are any rsocket connection issues to the backend.
  Try deleting the connector pod so it gets recreated:
  ```
  kubectl -n app-live-view delete pods -l=name=application-live-view-connector
  ```

- **Application Live View Convention auto-exposes all actuators:** The Application Live View Convention exposes all Spring Boot actuator endpoints by default (to whatever is configured via the Spring Boot Convention for the management port). The detailed documentation of the Application Live View Convention contains more details and instructions how to avoid this if this does not fit your needs.

- **Frequent Application Live View Connector restarts:** We are aware of the Application Live View Connector component being restarted quite frequently (under specific circumstances). This usually doesn't cause any problems when using Application Live View, but we are investigating this for future releases.

- **No structured JSON logging on the connector yet:** The format of the log output of the Application Live View Connector component is not yet aligned with the standard TAP logging format. This is scheduled to be fixed in an upcoming 1.1.1 release.


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

#### Supply Chain Security Tools – Scan

- **Scan Phase indicates `Scanning` incorrectly:** Scans have an edge case that when an error
  occurs during scanning, the `Scan Phase` field is not updated to `Error` and remains in the
  `Scanning` phase. Read the scan pod logs to verify the existence of an error.
- **User sees error message saying Supply Chain Security Tools - Store (Store) is not configured even though configuration values were supplied:** The Scan Controller experiences a race-condition when deploying Store in the same cluster, that shows Store as not configured, even when it is present and properly configured. This happens when the Scan Controller is deployed and reconciled before the Store is reconciled and the corresponding secrets are exported to the Scan Controller namespace. As a workaround to this, once your Store is successfully reconciled, you would need to restart your Supply Chain Security Tools - Scan deployment by running: `kubectl rollout restart deployment.apps/scan-link-controller-manager -n scan-link-system`. If you deployed Supply Chain Security Tools - Scan to a different namespace than the default one, you can replace `-n scan-link-system` with `-n <my_custom_namespace>`.

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

#### Application Live View

- **App Live View connector sometimes does not connect to the back end:**

    Workaround:

    - Check the app live view connector pod logs to verify if there are any rsocket connection issues to the back end.

    - Try deleting the connector pod so it gets re-created:

        ```
        kubectl -n app-live-view delete pods -l=name=application-live-view-connector
        ```
