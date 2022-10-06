# Release notes

{{#unless vars.hide_content}}
This Handlebars condition is used to hide content.
In release notes, this condition hides content that describes an unreleased patch for a released minor.
{{/unless}}
This topic contains release notes for Tanzu Application Platform v1.3

{{#unless vars.hide_content}}
## <a id='1-3-1'></a> v1.3.1

**Release Date**: MONTH DAY, 2022

### <a id='1-3-1-security-fixes'></a> Security fixes

### <a id='1-3-1-new-features'></a> Resolved issues

### <a id='1-3-1-known-issues'></a> Known issues

{{/unless}}

## <a id='1-3-0'></a> v1.3.0

**Release Date**: MONTH DAY, 2022

### <a id='1-3-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### <a id="app-acc-features"></a> Application Accelerator

- Packaging
  - Out-of-the-box samples are now distributed as OCI images
  - GitOps model support for publishing accelerator to facilitate governance around publishing accelerators
- Controller
  - Add source-image support for fragments and Fragment CRD
- Engine
  - OpenRewriteRecipe: More recipes are now supported in addition to Java: Xml, Properties, Maven, Json
  - New ConflictResolution Strategy : `NWayDiff` will merge files that were modified in different places, as long as they don't conflict. Similar to git diff3 algorithm
  - Enforce the validity of `inputType`: Only valid values `text`, `textarea`, `checkbox`, `select` and `radio` will be accepted
- Server
  - Add configmap to store accelerator invocation counts
  - Add separate downloaded endpoint for downloads telemetry
- Jobs
  - No changes
- Samples
  - Samples are moved to https://github.com/vmware-tanzu/application-accelerator-samples
  - Release includes samples marked with `tap-1.3` tag

#### <a id="alv-features"></a>Application Live View

- Application Live View uses a custom security context constraint to provide Openshift support.
- Custom Certificate Authority (CA) certificates are supported.


#### <a id="app-sso-features"></a>Application Single Sign-On

- AppSSO uses a custom Security Context Constraint to provide OpenShift support.
- Comply with the restricted _Pod Security Standard_ and give the least privilege to the controller.
- `AuthServer` gets TLS-enabled `Ingress` autoconfigured. This can be controlled by using `AuthServer.spec.tls`.
- Custom CAs are supported.
- More and better audit logs for authorization server events; `TOKEN_REQUEST_REJECTED`.
- Enable the `/userinfo` endpoint.
- Rename all Kubernetes resources in the _AppSSO_ package from _operator_ to _appsso-controller_.
- The controller restarts when its configuration is updated.
- The controller configuration is kept in a `Secret`.
- All existing `AuthServer` are updated and roll out when the controller's configuration changes significantly.
- Aggregate RBAC for managing `AuthServer` into the _Service-Operator_ cluster role.

#### <a id="default-roles-features"></a>Default roles for Tanzu Application Platform

- Added new default role `service-operator`.

#### <a id="apps-plugin"></a> Tanzu CLI - Apps plug-in

- `tanzu apps *` improvements:
  - auto-complete now works for all sub-command names and their positional argument values, flag names, and flag values.
- `tanzu apps workload create/apply` improvements:
  - Apps plug-in users can now pass in registry flags to override the default registry options configured on the platform.
    - These flags can leveraged when an application developer iterating on their code on their filesystem needs to push their code to a private registry. For example, this may be required when developing an application in an air-gapped environment.
    - To mitigate the risk of exposing sensitive information in the terminal, each registry flag/value can specified by environment variables.
    - Refer to [workload apply > registry flags](./cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#---registry-ca-cert) for a more detailed explanation about these flags and how to use them.
  - Provided first-class support for creating workloads from Maven artifacts through Maven flags. Previously this could only be achieved by passing the desired values through the `--complex-param` flag.
    - Refer to [workload apply > maven source flags](./cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#---maven-artifact) for a more detailed explanation about these flags and how to use them.
- `tanzu apps workload get` improvements:
  - Optimized the routines triggered when engaged in iterative development on the local filesystem.
    - running `tanzu apps workload apply my-app --local-path . ... will only upload the contents of the project directory when source code changes are detected.
  - Added a OUTPUT column to the resource table in the Supply Chain section to provide visibility to the resource that's stamped out by each supply chain step.
    - The stamped out resource may be helpful when troubleshooting supply chain issues for a workload. For example, the OUTPUT value can be copied and pasted into a `kubectl describe [output-value]` to view the resource's state/status/messages/etc... in more detail).
  - Added a Delivery section which provides visiblity to the delivery steps,  and the health, status, and stamped out resource associated with each delivery step.
    - The Delivery section content might be conditionally displayed depending on whether the targetted environment includes the Deliverable object. Delivery will be present on environments created using the Iterate and Build installation profiles.
  - Added a `Healthy` column to the Supply Chain resources table.
    - The column values are color coded to indicate the health of each resource at-a-glance.
  - Added an Overview section to show workload name and type.
  - Added Emojis to, and indentation under, each section header in the command output to better distinguish each section.
  - Updated the STATUS column in the table within the Pods section so that it displays the `Init` status when there are init containers (instead of displaying a less helpful/accurate `pending` value).
    - In fact, all column values in the Pods table have been updated so the output is equivalent to the output from `kubectl get pod/pod-name`.
- Updated Go to its latest version (1.19).

##### <a id="apps-plugin-deprecations"> Deprecations

- The `tanzu apps workload update` command will be deprecated in the `apps` CLI plugin. Please use `tanzu apps workload apply` instead.
  - `update` will be deprecated in two TAP releases (in TAP v1.5.0) or in one year (on Oct 11, 2023), whichever is longer.

#### <a id="src-cont-features"></a>Source Controller

- Added support for pulling artifacts with `LATEST` and `SNAPSHOT` versions.
- Optimized 'MavenArtifact' artifact download during interval sync.
  - Only after the SHA on the Maven Repository has changed can the source controller download the artifact. Otherwise, the download is skipped.
- Added routine to reset `ImageRepository` condition status between reconciles.
- Added support for OpenShift.
- Added support for Kubernetes 1.24.

#### <a id="snyk-scanner"></a> Snyk Scanner (beta)

- Snyk CLI is updated to v1.994.0.

#### <a id="scc-features"></a>Supply Chain Choreographer

- Feature 1
- Feature 2

#### <a id="scst-scan"></a> Supply Chain Security Tools - Scan

- Feature 1
- Feature 2

#### <a id="scst-policy-features"></a>Supply Chain Security Tools - Policy Controller

- Update Policy Controller version from v0.2.0 to v0.3.0
- Added ClusterImagePolicy [`warn` and `enforce` mode](./scst-policy/configuring.hbs.md#cip-mode)
- Added ClusterImagePolicy [authority static actions](./scst-policy/configuring.hbs.md#cip-static-action)

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

- Added **Tanzu Problems** panel to show workload status errors inside the IDE

#### <a id="dev-tls-intelj-features"></a>Tanzu Developer Tools for IntelliJ

- Feature 1
- Feature 2

#### <a id="functions-features"></a> Functions (beta)

- Functions Java and Python buildpack are included in TAP 1.3.
- Node JS Functions accelerator now available in TAP GUI.

#### <a id="tbs-features"></a> Tanzu Build Service

- TAP/TBS now ships with support for Jammy Stacks
  - Users can [opt-in](tanzu-build-service/dependencies.md#bionic-vs-jammy) to building workloads with the jammy stacks

#### <a id="srvc-toolkit-features"></a> Services Toolkit

- Added support for Openshift.
- Added support for Kubernetes 1.24.
- Created documentation and reference Service Instance Packages for new Cloud Service Provider integrations:
  - [Azure Flexible Server (Postgres) by using the Azure Service Operator](https://docs-staging.vmware.com/en/draft/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_azure_flexibleserver_psql_with_azure_operator.html).
  - [Azure Flexible Server (Postgres) by using Crossplane](https://docs-staging.vmware.com/en/draft/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_azure_database_with_crossplane.html).
  - [Google Cloud SQL (Postgres) by using Config Connector](https://docs-staging.vmware.com/en/draft/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_config_connector.html).
  - [Google Cloud SQL (Postgres) by using Crossplane](https://docs-staging.vmware.com/en/draft/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_crossplane.html).
- Formally defined the Service Operator user role (see [Role descriptions](./authn-authz/role-descriptions.hbs.md)).
- **`tanzu services` CLI plug-in:** Improved information messages for deprecated commands.

### <a id='1-3-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="scst-scan-changes"></a> Supply Chain Security Tools - Scan

- [Supply Chain Security Tools - Sign](scst-sign/overview.md) is deprecated. For migration information, see [Migration From Supply Chain Security Tools - Sign](./scst-policy/migration.hbs.md).
- Alpha version scan CRDs have been removed.
- Deprecated path, invoked when `ScanTemplates` shipped with versions prior to Supply Chain Security Tools - Scan `v1.2.0` are used, now logs a message directing users to update the scanner integration to the latest version. The migration path is to use `ScanTemplates` shipped with Supply Chain Security Tools - Scan `v1.3.0`.

#### <a id="tbs-breaking-changes"></a> Tanzu Build Service

- Breaking change 1
- Breaking change 2

#### <a id="grype-scanner-changes"></a> Grype Scanner

- Breaking change 1
- Breaking change 2

#### <a id="app-sso-changes"></a> Application Single Sign-On

- **Deprecation notice:** `AuthServer.spec.issuerURI` is deprecated and marked for removal in the next release. You can migrate
  to `AuthServer.spec.tls` by following instructions in [AppSSO migration guides](app-sso/upgrades/index.md#migration-guides).
- `AuthServer.spec.identityProviders.internalUser.users.password` is in plain text instead of _bcrypt_
  -hashed.
- When an authorization server fails to obtain a token from an OpenID identity provider, it records
  an `INVALID_IDENTITY_PROVIDER_CONFIGURATION` audit event instead of `INVALID_UPSTREAM_PROVIDER_CONFIGURATION`.
- Package configuration `webhooks_disabled` is removed and `extra` is renamed to `internal`.
- The `KEYS COUNT` print column is replaced with the more insightful `STATUS` for `AuthServer`.
- The `sub` claim in `id_token`s and `access_token`s follow the `<providerId>_<userId>` pattern,
  instead of `<providerId>/<userId>`. See [Misconfigured `sub` claim](app-sso/service-operators/troubleshooting.md#sub-claim) for more information.

### <a id='1-3-resolved-issues'></a> Resolved issues

- Resolved issue 1
- Resolved issue 2

#### <a id="1-3-upgrade-issues"></a>Upgrading Tanzu Application Platform

- Adding new Tanzu Application Platform repository bundle in addition to another repository bundle does not cause a failure anymore.

#### <a id="app-acc-resolved"></a> Application Accelerator

- Controller
  - Importing a non-ready fragment should propagate non-readyness
  - DependsOn from fragments are no longer "lost" when imported 
- Engine
  - OpenRewriteRecipe updates: Unrecognized Recipe properties now trigger an explicit error

#### <a id="app-sso-resolved"></a> Application Single Sign-On

- Emit the audit `TOKEN_REQUEST_REJECTED` event when the `refresh_token` grant fails.
- The service binding `Secret` is updated when a `ClientRegistration` changes significantly.

#### <a id="scst-scan-resolved"></a>Supply Chain Security Tools - Policy Controller

- Pods deployed through `kubectl run` in non-default namespace now are able to build the neccessary keychain for registry access during validation.

#### <a id="scst-scan-resolved"></a>Supply Chain Security Tools - Scan

- Resolved issue 1
- Resolved issue 2

#### <a id="grype-scan-resolved"></a>Grype Scanner

- Resolved issue 1
- Resolved issue 2

#### <a id="apps-plugin-resolved"></a> Tanzu CLI - Apps plug-in

- Flag `azure-container-registry-config` that was shown in help output but was not part of apps plug-in flags, is not shown anymore.
- `workload list --output` was not showing all workloads in namespace. This was fixed, and now all workloads are listed.
- When creating a workload from local source in Windows, the image was created with unstructured directories and flattened all file names. This is now fixed with an `imgpkg` upgrade.
- When uploading a source image, if the namespace provided is not valid or doesn't exist, the image isn't uploaded and the workload isn't created.
- Due to a Tanzu Framework upgrade, the autocompletion for flag names in all commands is now working.

#### <a id="source-controller-resolved"></a> Source Controller

- Added checks to ensure SNAPSHOT has versioning enabled.
- Fixed resource status conditions when metadata or metadata element is not found.

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

  - New default Contour configuration causes ingress on Kind cluster on Mac to break. The config value `contour.envoy.service.type` now defaults to `LoadBalancer`. For more information, see [Troubleshooting Install Guide](troubleshooting-tap/troubleshoot-install-tap.hbs.md#a-idcontour-error-kinda-ingress-is-broken-on-kind-cluster).
  - The key shared.image_registry.project_path, which takes input as "SERVER-NAME/REPO-NAME", cannot take "/" at the end. For more information, see [Troubleshoot using Tanzu Application Platform](troubleshooting-tap/troubleshoot-using-tap.hbs.md#invalid-repo-paths).

#### <a id="tanzu-cli-known-issues"></a>Tanzu CLI/Plug-ins

- **Failure to connect to AWS EKS clusters:**

  When connecting to AWS EKS clusters, an error might appear with the text
  - `Error: Unable to connect: connection refused. Confirm kubeconfig details and try again` or
  - `invalid apiVersion "client.authentication.k8s.io/v1alpha1"`.

  This occurs if the version of the `aws-cli` is less than the supported version `2.7.35`.

  See the ["failure to connect to AWS EKS clusters"](troubleshooting-tap/troubleshoot-using-tap.md#connect-aws-eks-clusters) section of TAP troubleshooting for instructions in how to resolve the issue.

#### <a id="app-acc-known-issues"></a>Application Accelerator

- Generation of new project from an accelerator might time out for more complex accelerators. See the [Configure ingress timeouts when some accelerators take longer to generate](application-accelerator/configuration.html#configure-timeouts) section.

#### <a id="alv-known-issues"></a>Application Live View

- Known issue 1
- Known issue 2

#### <a id="alv-ca-known-issues"></a>Application Single Sign-On

[Application Single Sign On - Known Issues](app-sso/known-issues/index.md)

#### <a id="conv-svc-known-issues"></a>Convention Service

- Known issue 1
- Known issue 2

#### <a id="cnrs-issues"></a> Cloud Native Runtimes

- **Failure to successfully deploy workloads on Openshift**
  When creating a workload from a Deliverable resource, it may not create successfully, and an error might be seen with the text
  ```
  pods "<pod name>" is forbidden: unable to validate against any security context constraint: 
  [provider "anyuid": Forbidden: not usable by user or serviceaccount, spec.containers[0].securityContext.runAsUser:
  Invalid value: 1000: must be in the ranges: [1000740000, 1000749999]
  ```
  This may be due to ServiceAccounts or Users bound to overly restrictive SecurityContextConstraints.

  See the Cloud Native Runtimes [troubleshooting documentation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.0/tanzu-cloud-native-runtimes/GUID-troubleshooting.html) for how to resolve this issue.

#### <a id="functions-issues"></a> Functions (beta)

- Known issue 1
- Known issue 2

#### <a id="scst-scan-issues"></a>Supply Chain Security Tools - Scan

- Known issue 1
- Known issue 2

#### <a id="grype-scan-known-issues"></a>Grype scanner

- **Scanning Java source code that uses Gradle package manager might not reveal vulnerabilities:**
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

- **Tanzu Application Platform GUI doesn't work in Safari:**
  Tanzu Application Platform GUI does not work in the Safari web browser.

#### <a id="vscode-ext-known-issues"></a>VS Code Extension

- **Unable to view workloads on the panel when connected to GKE cluster:**
  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#cannot-view-workloads).

- **Warning notification when canceling an action:**
  A warning notification can appear when running `Tanzu: Debug Start`, `Tanzu: Live Update Start`,
  or `Tanzu: Apply`, which says that no workloads or Tiltfiles were found.
  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#cancel-action-warning).

- **Live update not working when using server or worker Workload types:**
  When using `server` or `worker` as [workload type](workloads/workload-types.hbs.md#-available-workload-types), live update might not work. This is because the default pod selector used to check when a pod is ready to do live update is incorrectly using the label `'serving.knative.dev/service': '<workload_name>'`, this label is not present on  `server` or `worker` workloads. To fix this go to the project's `Tiltfile`, look for the `k8s_resource` line and modify the `extra_pod_selectors` parameter to use any pod selector that will match your workload, e.g. `extra_pod_selectors=[{'carto.run/workload-name': '<workload_name>', 'app.kubernetes.io/component': 'run', 'app.kubernetes.io/part-of': '<workload_name>'}]`

- **Tiltfile snippet does not work on files named `Tiltfile` when Tilt extension is installed:** For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#tiltfile-snippet).

#### <a id="intelj-ext-known-issues"></a>Intellij Extension

- **Unable to view workloads on the panel when connected to GKE cluster:**
  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#cannot-view-workloads).

- **Starting debug and live update sessions is synchronous:**
  When a User `Run`s (or `Debug`s) a launch configuration intellij disables the launch controls preventing other
  launch configs from being launched at the same time.  Re-activating these controls only when the launch config is started.
  As such, starting mulitple Tanzu debug and live update sessions is a synchronous activity.  We are looking into
  how we might improve this expereince for our Users.

- **Live update not working when using server or worker Workload types:**
  When using `server` or `worker` as [workload type](workloads/workload-types.hbs.md#-available-workload-types), live update might not work. This is because the default pod selector used to check when a pod is ready to do live update is incorrectly using the label `'serving.knative.dev/service': '<workload_name>'`, this label is not present on  `server` or `worker` workloads. To fix this go to the project's `Tiltfile`, look for the `k8s_resource` line and modify the `extra_pod_selectors` parameter to use any pod selector that will match your workload, e.g. `extra_pod_selectors=[{'carto.run/workload-name': '<workload_name>', 'app.kubernetes.io/component': 'run', 'app.kubernetes.io/part-of': '<workload_name>'}]`

- **Stoping one debug session stops them all:**
  When starting multiple simultaneous workload debud sessions, terminating one of those sessions will inadvertently also terminate
  the others. (Note that is only disconnects the debugger, it doesn't terminate the workload process itself, so it is possible
  reatach/restart debug sessions). A fix for this bug will be included in TAP 1.3.1.
 
#### <a id="store-known-issues"></a>Supply Chain Security Tools - Store

- Known issue 1
- Known issue 2
