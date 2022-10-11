# Release notes

## <a id='1-3-0'></a> v1.3.0

**Release Date**: October 11, 2022

### <a id='1-3-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### <a id="api-auto-registration-features"></a> API Auto Registration

- API Auto Registration is a new package that supports dynamic registration of API from workloads into Tanzu Application Platform GUI.
- Supports Async API, GraphQL, gRPC and OpenAPI.
- Enhanced support for OpenAPI 3 to validate the specification and update the servers URL section.
- Custom Certificate Authority (CA) certificates are supported.

#### <a id="app-acc-features"></a> Application Accelerator

- Packaging
  - Out-of-the-box samples are now distributed as OCI images.
  - GitOps model support for publishing accelerator to facilitate governance around publishing accelerators.
- Controller
  - Added source-image support for fragments and Fragment CRD.
- Engine
  - OpenRewriteRecipe: More recipes are now supported in addition to Java: Xml, Properties, Maven, and Json.
  - New ConflictResolution Strategy : `NWayDiff` merges files modified in different places, as long as they don't conflict. Similar to the Git diff3 algorithm.
  - Enforces the validity of `inputType`: Accepts only valid values: `text`, `textarea`, `checkbox`, `select`, and `radio`.
- Server
  - Added configmap to store accelerator invocation counts.
  - Added separate downloaded endpoint for downloads telemetry.
- Jobs
  - No changes.
- Samples
  - Samples are moved to https://github.com/vmware-tanzu/application-accelerator-samples.
  - Release includes samples marked with the `tap-1.3` tag.

#### <a id="alv-features"></a>Application Live View

- Application Live View supports Steeltoe/.NET applications.
- Supports Custom Certificate Authority (CA) certificates.

#### <a id="app-sso-features"></a>Application Single Sign-On

- TLS Auto-configured: TLS-enabled Ingress is auto-configured for AuthServer.
- Custom Certificate Authority (CA) certificates support.
- Improved error handling and audit logs for:
  - `TOKEN_REQUEST_REJECTED` events.
  - Identity providers are incorrectly set up.
- Enabled `/userinfo` endpoint to retrieve user information.
- OpenShift support: AppSSO uses a custom Security Context Constraint.
- Security: Complies with the restricted Pod Security Standard and gives the least privilege to the controller.
- Service-Operator cluster role: Aggregate RBAC for managing AuthServer.
- Controller updates:
  - The controller restarts when its configuration is updated.
  - The controller configuration is kept in a Secret.
  - All existing AuthServers are updated and rolled out when the controller’s configuration changes significantly.

#### <a id="carbon-black-scanner-features"></a> Carbon Black Cloud Scanner integration (beta)

Carbon Black Cloud Scanner image scanning integration (beta) is available for [Supply Chain Security Tools - Scan](scst-scan/overview.hbs.md).
See [Install Carbon Black Scanner (beta)](scst-scan/install-carbonblack-integration.hbs.md) for instructions about using Carbon Black Cloud Scanner with Tanzu Application Platform Supply Chains.

#### <a id="default-roles-features"></a>Default roles for Tanzu Application Platform

- Added new default role `service-operator`.

#### <a id="apps-plugin"></a> Tanzu CLI - Apps plug-in

- `tanzu apps *` improvements:
  - auto-complete now works for all sub-command names and their positional argument values, flag names, and flag values.
- `tanzu apps workload create/apply` improvements:
  - Apps plug-in users can now pass in registry flags to override the default registry options configured on the platform.
    - These flags can be everaged when an application developer iterating on their code on their file system needs to push their code to a private registry. For example, this may be required when developing an application in an air-gapped environment.
    - To mitigate the risk of exposing sensitive information in the terminal, each registry flag/value can be specified by environment variables.
    - Refer to [workload apply > registry flags](./cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#---registry-ca-cert) for a more detailed explanation about these flags and how to use them.
  - Provided first-class support for creating workloads from Maven artifacts through Maven flags. Previously, this could only be achieved by passing the desired values through the `--complex-param` flag.
    - Refer to [workload apply > maven source flags](./cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#---maven-artifact) for a more detailed explanation about these flags and how to use them.
- `tanzu apps workload get` improvements:
  - Optimized the routines triggered when engaged in iterative development on the local file system.
    - Running `tanzu apps workload apply my-app --local-path . ... only uploads the contents of the project directory when source code changes are detected.
  - Added an OUTPUT column to the resource table in the Supply Chain section to provide visibility to the resource that's stamped out by each supply chain step.
    - The stamped out resource can be helpful when troubleshooting supply chain issues for a workload. For example, the OUTPUT value can be copied and pasted into a `kubectl describe [output-value]` to view the resource's state/status/messages/etc... in more detail).
  - Added a Delivery section that provides visiblity to the delivery steps and the health, status, and stamped out resource associated with each delivery step.
    - The Delivery section content might be conditionally displayed depending on whether the targetted environment includes the Deliverable object. Delivery is present on environments created using the Iterate and Build installation profiles.
  - Added a `Healthy` column to the Supply Chain resources table.
    - The column values are color coded to indicate the health of each resource at-a-glance.
  - Added an Overview section to show workload name and type.
  - Added Emojis to, and indentation under, each section header in the command output to better distinguish each section.
  - Updated the STATUS column in the table within the Pods section so that it displays the `Init` status when there are init containers (instead of displaying a less helpful/accurate `pending` value).
    - In fact, all column values in the Pods table have been updated so the output is equivalent to the output from `kubectl get pod/pod-name`.
- Updated Go to its latest version (v1.19).

##### <a id="apps-plugin-deprecations"></a> Deprecations

- The `tanzu apps workload update` command is deprecated in the `apps` CLI plug-in. Please use `tanzu apps workload apply` instead.
  - `update` is deprecated in two Tanzu Application Platform releases (in Tanzu Application Platform v1.5.0) or in one year (on Oct 11, 2023), whichever is later.

#### <a id="src-cont-features"></a>Source Controller

- Added support for pulling artifacts with `LATEST` and `SNAPSHOT` versions.
- Optimized 'MavenArtifact' artifact download during interval sync.
  - Only after the SHA on the Maven Repository has changed can the source controller download the artifact. Otherwise, the download is skipped.
- Added routine to reset `ImageRepository` condition status between reconciles.
- Added support for OpenShift.
- Added support for Kubernetes 1.24.

#### <a id="snyk-scanner"></a> Snyk Scanner (beta)

- Snyk CLI is updated to v1.994.0.

#### <a id="scst-policy-features"></a>Supply Chain Security Tools - Policy Controller

- Updated Policy Controller version from v0.2.0 to v0.3.0.
- Added ClusterImagePolicy [`warn` and `enforce` mode](./scst-policy/configuring.hbs.md#cip-mode).
- Added ClusterImagePolicy [authority static actions](./scst-policy/configuring.hbs.md#cip-static-action).

#### <a id="tap-gui-features"></a>Tanzu Application Platform GUI

- Users are no longer required to set the following values when using ingress: `app.baseUrl`,
  `backend.baseUrl`, `backend.cors.origin`.
  These values can be inferred by the value derived from `ingressDomain` or through the top-level
  key `ingress_domain`.
- Tanzu Application Platform GUI reads from a Kubernetes metrics server and displays these values in
  the Runtime Resources Visibility tab when available.
  By default, Tanzu Application Platform GUI does not try to fetch metrics.
  To enable metrics for a cluster, follow the
  [Runtime Resources Visibility documentation](tap-gui/plugins/runtime-resource-visibility.hbs.md#metrics-server).
- Tanzu Application Platform GUI reports logs in newline-delimited JSON format.
- Users can now edit the Kubernetes deployment parameters by using the `deployment` key.
- Upgraded the version of backstage on which Tanzu Application Platform GUI runs to backstage v1.1.1.
- Supports a new endpoint from which external components can push updates to catalog entities.
  The `api-auto-registration` package must be configured to push catalog entities to
  Tanzu Application Platform GUI.
- Application Accelerator plug-in:
  - Added metric to see how many executions an accelerator has in the accelerator list.
  - Added ability to create Git repositories based on the provided configuration.
- Runtime Resources plug-in:
  - Pods, ReplicaSets, and Deployments now display configured memory and CPU limits. On clusters
    configured with `skipMetricsLookup` set to `false`, realtime memory and CPU use are also displayed.
  - Supports new Kubernetes resources (Jobs, CronJobs, StatefulSets, and DaemonSets).
  - Warning and error banners can now be dismissed.
  - Log viewer improvements:
    - Log viewer now streams messages in real time.
    - Log entries can be soft-wrapped.
    - Log contents can be exported.
    - The log level can be changed for pods supporting Application Live View.
- Supply Chain Choreographer plug-in:
  - Improved error handling when a scan policy is misconfigured.
    There are now links to documentation to properly configure scan policies, which replace the
    `No policy has been configured` message.
  - Added cluster validation to avoid data collisions in the supply chain visualization when a
    workload with the same name and namespace exist on different clusters.
  - Beta: VMware Carbon Black scanning is now supported.
  - Keyboard navigation improvements.
  - Updated headers on the Supply Chain graph to better display the name of the supply chain used and
    the workload in the supply chain.
  - Added direct links to **Package Details** and **CVE Details** pages from within scan results to
    support a new Security Analysis plug-in.
- New [Security Analysis plug-in](tap-gui/plugins/sa-tap-gui.hbs.md):
  - View vulnerabilities across all workloads and clusters in a single location.
  - View CVE details and package details page. See the Supply Chain Choreographer plug-in's
    Vulnerabilities table.

#### <a id="dev-tls-vsc-features"></a>Tanzu Developer Tools for VS Code

- Added **Tanzu Problems** panel to show workload status errors inside the IDE.

#### <a id="functions-features"></a> Functions (beta)

- Functions Java and Python buildpack are included in Tanzu Application Platform 1.3.
- Node JS Functions accelerator now available in Tanzu Application Platform GUI.

#### <a id="tbs-features"></a> Tanzu Build Service

- **Tanzu Build Service now includes support for Jammy Stacks:**
You can opt-in to building workloads with the Jammy stacks by following the instructions in
[Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).
- **The Ubuntu Bionic stack is deprecated:**
Ubuntu Bionic stops receiving support in April 2023.
VMware recommends you migrate builds to Jammy stacks in advance.
For how to migrate builds, see [Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).
- **The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated:**
It is still activated by default in Tanzu Application Platform v1.3 and v1.4.
VMware plans to deactivate this format by default in Tanzu Application Platform v1.5
and remove support in Tanzu Application Platform v1.6.
To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).

#### <a id="srvc-toolkit-features"></a> Services Toolkit

- Added support for Openshift.
- Added support for Kubernetes 1.24.
- Created documentation and reference Service Instance Packages for new Cloud Service Provider integrations:
  - [Azure Flexible Server (Postgres) by using the Azure Service Operator](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_azure_flexibleserver_psql_with_azure_operator.html).
  - [Azure Flexible Server (Postgres) by using Crossplane](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_azure_database_with_crossplane.html).
  - [Google Cloud SQL (Postgres) by using Config Connector](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_config_connector.html).
  - [Google Cloud SQL (Postgres) by using Crossplane](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_crossplane.html).
- Formally defined the Service Operator user role (see [Role descriptions](./authn-authz/role-descriptions.hbs.md)).
- **`tanzu services` CLI plug-in:** Improved information messages for deprecated commands.

### <a id='1-3-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="scst-sign-changes"></a> Supply Chain Security Tools - Sign

- [Supply Chain Security Tools - Sign](scst-sign/overview.md) is deprecated. For migration information, see [Migration From Supply Chain Security Tools - Sign](./scst-policy/migration.hbs.md).

#### <a id="scst-scan-changes"></a> Supply Chain Security Tools - Scan

- Alpha version scan CRDs have been removed.
- Deprecated path, invoked when `ScanTemplates` shipped with versions prior to Supply Chain Security Tools - Scan `v1.2.0` are used, now logs a message directing users to update the scanner integration to the latest version. The migration path is to use `ScanTemplates` shipped with Supply Chain Security Tools - Scan `v1.3.0`.

#### <a id="app-sso-changes"></a> Application Single Sign-On

- **Deprecation notice:**
  - `AuthServer.spec.issuerURI` is deprecated and marked for removal in the next release. You can migrate
    to `AuthServer.spec.tls` by following instructions in [AppSSO migration guides](app-sso/upgrades/index.md#migration-guides).
  - `AuthServer.status.deployments.authserver.LastParentGenerationWithRestart` is deprecated and marked
   for removal in the next release.
- `AuthServer.spec.identityProviders.internalUser.users.password` is in plain text instead of _bcrypt_
  -hashed.
- When an authorization server fails to obtain a token from an OpenID identity provider, it records
  an `INVALID_IDENTITY_PROVIDER_CONFIGURATION` audit event instead of `INVALID_UPSTREAM_PROVIDER_CONFIGURATION`.
- Package configuration `webhooks_disabled` is removed and `extra` is renamed to `internal`.
- The `KEYS COUNT` print column is replaced with the more insightful `STATUS` for `AuthServer`.
- The `sub` claim in `id_token`s and `access_token`s follow the `<providerId>_<userId>` pattern,
  instead of `<providerId>/<userId>`. See [Misconfigured `sub` claim](app-sso/service-operators/troubleshooting.md#sub-claim) for more information.

#### <a id="app-live-view-changes"></a> Application Live View

- In a multi-cluster setup, if `shared.ingress_domain` is configured, `ingressEnabled` flag in the backend is no longer set to `true` automatically. The user has to explicitly set `ingressEnabled` to `true` in order to create HTTPProxy and establish the communication between backend and connector.

### <a id='1-3-resolved-issues'></a> Resolved issues

#### <a id="1-3-upgrade-issues"></a>Upgrading Tanzu Application Platform

- Adding new Tanzu Application Platform repository bundle in addition to another repository bundle no longer causes a failure.

#### <a id="app-acc-resolved"></a> Application Accelerator

- Controller
  - Importing a non-ready fragment propagates non-readyness.
  - DependsOn from fragments are no longer "lost" when imported.
- Engine
  - OpenRewriteRecipe updates: Unrecognized Recipe properties now trigger an explicit error.

#### <a id="app-sso-resolved"></a> Application Single Sign-On

- Emit the audit `TOKEN_REQUEST_REJECTED` event when the `refresh_token` grant fails.
- The service binding `Secret` is updated when a `ClientRegistration` changes significantly.

#### <a id="scst-scan-resolved"></a>Supply Chain Security Tools - Policy Controller

- Pods deployed through `kubectl run` in non-default namespace can now build the neccessary keychain for registry access during validation.

#### <a id="apps-plugin-resolved"></a> Tanzu CLI - Apps plug-in

- Flag `azure-container-registry-config` that was shown in help output but was not part of apps plug-in flags, is not shown anymore.
- `workload list --output` was not showing all workloads in namespace. This was fixed, and now all workloads are listed.
- When creating a workload from local source in Windows, the image was created with unstructured directories and flattened all file names. This is now fixed with an `imgpkg` upgrade.
- When uploading a source image, if the namespace provided is not valid or doesn't exist, the image isn't uploaded and the workload isn't created.
- Due to a Tanzu Framework upgrade, the autocompletion for flag names in all commands is now working.

#### <a id="source-controller-resolved"></a> Source Controller

- Added checks to ensure that SNAPSHOT has versioning enabled.
- Fixed resource status conditions when metadata or metadata element is not found.

#### <a id="tap-gui-resolved"></a>Tanzu Application Platform GUI

- Supply Chain Plug-in

  - Deliverable link in Runtime Resources no longer takes a user to a blank page instead of to the
    supply chain delivery.
  - Results for the wrong workload are no longer shown if the same `part-of label` is used across
    workloads with the same name.

### <a id='1-3-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="tap-known-issues"></a>Tanzu Application Platform

- New default Contour configuration causes ingress on Kind cluster on Mac to break. The config value `contour.envoy.service.type` now defaults to `LoadBalancer`. For more information, see [Troubleshooting Install Guide](troubleshooting-tap/troubleshoot-install-tap.hbs.md#a-idcontour-error-kinda-ingress-is-broken-on-kind-cluster).
- The key shared.image_registry.project_path, which takes input as "SERVER-NAME/REPO-NAME", cannot take "/" at the end. For more information, see [Troubleshoot using Tanzu Application Platform](troubleshooting-tap/troubleshoot-using-tap.hbs.md#invalid-repo-paths).

#### <a id="tanzu-cli-known-issues"></a>Tanzu CLI/Plug-ins

**Failure to connect to AWS EKS clusters:**

When connecting to AWS EKS clusters, an error might appear with the text:

  - `Error: Unable to connect: connection refused. Confirm kubeconfig details and try again` or
  - `invalid apiVersion "client.authentication.k8s.io/v1alpha1"`.

This occurs if the version of the `aws-cli` is less than the supported version, v`2.7.35`.

 For information about resolving this issue, see [Troubleshoot using Tanzu Application Platform](troubleshooting-tap/troubleshoot-using-tap.hbs.md#connect-aws-eks-clusters).

#### <a id="api-auto-registration-known-issues"></a>API Auto Registration

**Valid OpenAPI v2 specifications that use `schema.$ref` currently fail validation:**

If using an OpenAPI v2 specification with this field, consider converting to OpenAPI v3.
For more information, see [Troubleshooting](api-auto-registration/troubleshooting.hbs.md).
All other specification types and OpenAPI v3 specifications are unaffected.

#### <a id="app-acc-known-issues"></a>Application Accelerator

**Generation of new project from an accelerator times out:**

Generation of a new project from an accelerator might time out for more complex accelerators.
For more information, see [Configure ingress timeouts](application-accelerator/configuration.hbs.md#configure-timeouts).

#### <a id="alv-known-issues"></a>Application Live View

**Unable to find CertificateRequests in App Live View Convention:**

When creating a Tanzu Application Platform workload, an error might appear with the text:

```console
failed to authenticate: unable to find valid certificaterequests for certificate "app-live-view-conventions/appliveview-webhook-cert"
```

This occurs because the certificate request is missing for the corresponding certificate `appliveview-webhook-cert`.
For more information, see [Troubleshooting](app-live-view/troubleshooting.hbs.md#missing-cert-requests).

#### <a id="alv-ca-known-issues"></a>Application Single Sign-On

**Redirect URIs change to http instead of https:**

AppSSO makes requests to external identity providers with `http` rather than `https`.
For more information, see [Redirect URIs change to http instead of https](app-sso/known-issues/cidr-ranges.md).

#### <a id="cnrs-issues"></a> Cloud Native Runtimes

**Failure to deploy workloads on `run` cluster in multicluster setup on Openshift:**

When creating a workload from a Deliverable resource, it may not create and instead result in the following error:

```
pods "<pod name>" is forbidden: unable to validate against any security context constraint:
[provider "anyuid": Forbidden: not usable by user or serviceaccount, spec.containers[0].securityContext.runAsUser:
Invalid value: 1000: must be in the ranges: [1000740000, 1000749999]
```

This can be due to ServiceAccounts or users bound to overly restrictive SecurityContextConstraints.

For information about resolving this issue, see the Cloud Native Runtimes [troubleshooting documentation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.0/tanzu-cloud-native-runtimes/GUID-troubleshooting.html).

#### <a id="grype-scan-known-issues"></a>Grype scanner

**Scanning Java source code that uses Gradle package manager might not reveal vulnerabilities:**

For most languages, Source Code Scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch
dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check the dependencies for vulnerabilities.

For Java using Gradle, dependency lock files are not guaranteed, so Grype uses the dependencies
present in the built binaries (`.jar` or `.war` files) instead.

Because VMware does not encourage committing binaries to source code repositories, Grype fails to
find vulnerabilities during a source scan.
The vulnerabilities are still found during the image scan after the binaries are built and packaged
as images.

#### <a id="tap-gui-known-issues"></a>Tanzu Application Platform GUI

**Tanzu Application Platform GUI doesn't work in Safari:**

Tanzu Application Platform GUI does not work in the Safari web browser.

#### <a id="tap-gui-plug-in-known-issues"></a>Tanzu Application Platform GUI Plug-ins

- **Supply Chain Plug-in:**

  - The Target Cluster column in the Workloads table shows the incorrect cluster when two workloads
    of the same name, `part-of label`, namespace, and same supply-chain name are used on different
    clusters.
  - Updating a supply chain results in an error (`Can not create edge...`) when an existing workload
    is clicked in the Workloads table and that supply chain is no longer present.
    For information about resolving this issue, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#update-sc-err).
  - API Descriptors/Service Bindings stages show an `Unknown` status (grey question mark in the graph)
    even if successful.

#### <a id="vscode-ext-known-issues"></a>VS Code Extension

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
  [Troubleshooting](vscode-extension/troubleshooting.hbs.md#lu-not-working-wl-types).

- **Tiltfile snippet doesn't work on files named `Tiltfile` when Tilt extension is installed:**

  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#tiltfile-snippet).

#### <a id="intelj-ext-known-issues"></a>IntelliJ Extension

- **Unable to view workloads on the panel when connected to GKE cluster:**

  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#cannot-view-workloads).

- **Starting debug and live update sessions is synchronous:**

  When a user runs or debugs a launch configuration, IntelliJ deactivates the launch controls to prevent
  other launch configurations from being launched at the same time.
  These controls are reactivated when the launch configuration is started.
  As such, starting multiple Tanzu debug and live update sessions is a synchronous activity.

- **Live update not working when using server or worker Workload types:**

  When using `server` or `worker` as
  [workload type](workloads/workload-types.hbs.md#-available-workload-types),
  live update might not work.
  For more information, see
  [Troubleshooting](intellij-extension/troubleshooting.hbs.md#lu-not-working-wl-types).

- **Stopping one debug session stops them all:**

  When starting multiple simultaneous workload debug sessions, stopping one of those sessions also
  stops the others. This disconnects the debugger without stopping the workload process itself,
  so it is possible to restart debug sessions. A fix is planned for Tanzu Application Platform v1.3.1.

#### <a id="contour-known-issues"></a>Contour

- Incorrect output for command `tanzu package available get contour.tanzu.vmware.com/1.22.0+tap.3 --values-schema -n tap-install`:
  The default values displayed for the following keys are incorrect in values-schema of Contour package in Tanzu Application Platform v1.3.0:
    - Key `envoy.hostPorts.enable` has a default value as `false`, but it is displayed as `true`.
    - Key `envoy.hostPorts.enable` has a default value as `LoadBalancer`, but it is displayed as `NodePort`.

#### <a id="scc-known-issues"></a>Supply Chain Choreographer

- **Misleading DeliveryNotFound error message on Build profile clusters**

  Deliverables incorrectly show a DeliveryNotFound error on *build* profile clusters even though the
  workload is working correctly. The message is typically:
  `No delivery found where full selector is satisfied by labels:`.
