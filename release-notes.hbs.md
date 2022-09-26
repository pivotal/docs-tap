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

- Feature 1
- Feature 2

#### <a id="alv-features"></a>Application Live View

- Feature 1
- Feature 2

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

- Updated Go to its latest version (1.19)
- New flags have been added to override default registry options. This means, if there's a private registry to push images to, options can be set either through apps plugin flags or environment variables. Refer to [workload apply registry opts flags](./cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#a-idapply-registry-ca-certa---registry-ca-cert) explanation for more info about these flags usage.
- Workload get improvements:
  - Added `Healthy` column to supply chain resources listed in `workload get` output. This column is also using colors to surface the resource healthy status.
  - Added an Overview section to show workload name and type.
  - Each section is now indented under its corresponding header.
  - Emojis are printed to distinguish each section.
  - A new column to show the resource stamped out by the supply chain was also added.
  - Deliverable information is being surfaced whenever it's available.
  - Pods status is now same as Kubectl so, for example, if there are init containers, when `workload get` is used, the `Init` status of these will be printed in the output.
- Local source changes will be updated/uploaded only if there is an actual change to the code.
- Maven artifact is also supported via flags. It can be set through complex params or the new flags. Check [workload apply maven source flags](./cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#a-idapply-maven-artifacta---maven-artifact) for more info about their usage.
- There are some environment variable that can be set as default values for apps plugin flags. These are:
  * `--type`: TANZU_APPS_TYPE
  * `--registry-ca-cert`: TANZU_APPS_REGISTRY_CA_CERT
  * `--registry-password`: TANZU_APPS_REGISTRY_PASSWORD
  * `--registry-username`: TANZU_APPS_REGISTRY_USERNAME
  * `--registry-token`: TANZU_APPS_REGISTRY_TOKEN

##### <a id="apps-plugin-deprecations"> Deprecations

- First warning that `workload update` command will be deprecated.

#### <a id="src-cont-features"></a>Source Controller

- Feature 1
- Feature 2

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
- Formally defined the Service Operator user role (see [Role descriptions](./authn-authz/role-descriptions.hbs.md)).
- **`tanzu services` CLI plug-in:** Improved information messages for deprecated commands.

### <a id='1-3-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="scst-scan-changes"></a> Supply Chain Security Tools - Scan

- [Supply Chain Security Tools - Sign](scst-sign/overview.md) is deprecated. For migration information, see [Migration From Supply Chain Security Tools - Sign](./scst-policy/migration.hbs.md).

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

#### <a id="app-acc-resolved"></a> Application Accelerator

- Resolved issue 1
- Resolved issue 2

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

- Flag `azure-container-registry-config` that was shown in help output but was not part of apps plugin flags, is not shown anymore.
- `workload list --output` was not showing all workloads in namespace. This was fixed and now all workloads are listed.
- When creating a workload from local source in Windows, the image would be created with unstructured directories and would flatten all file names. This was fixed with an `imgpkg` upgrade.
- When uploading a source image, if the namespace provided is not valid or doesn't exist, the image won't be uploaded and the workload won't be created.
- Due to a Tanzu Framework upgrade, the autocompletion for flag names in all commands is now working.

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

#### <a id="alv-known-issues"></a>Application Live View

- Known issue 1
- Known issue 2

#### <a id="alv-ca-known-issues"></a>Application Single Sign-On

[Application Single Sign On - Known Issues](app-sso/known-issues/index.md)

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

- **Scanning Java source code that uses Gradle package manager may not reveal vulnerabilities:**
  For most languages, Source Code Scanning only scans files present in the source code repository.
  Except for support added for Java projects using Maven, no network calls are made to fetch
  dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the
  lock files to check the dependencies for vulnerabilities.

  For Java using Gradle, dependency lock files are not guaranteed, so Grype uses the dependencies
  present in the built binaries (`.jar` or `.war` files) instead.

  Because VMware does not encourage committing binaries to source code repositories, Grype fails to
  find vulnerabilities during a Source Scan.
  The vulnerabilities are still found during the Image Scan after the binaries are built and packaged
  as images.

#### <a id="tap-gui-known-issues"></a>Tanzu Application Platform GUI

- Known issue 1
- Known issue 2

#### <a id="vscode-ext-known-issues"></a>VS Code Extension

- **Unable to view workloads on the panel when connected to GKE cluster:**
  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#cannot-view-workloads).

- **Warning notification when canceling an action:**
  A warning notification can appear when running `Tanzu: Debug Start`, `Tanzu: Live Update Start`,
  or `Tanzu: Apply`, which says that no workloads or Tiltfiles were found.
  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#cancel-action-warning).

#### <a id="intelj-ext-known-issues"></a>Intellij Extension

- **Unable to view workloads on the panel when connected to GKE cluster:**
  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#cannot-view-workloads).

#### <a id="store-known-issues"></a>Supply Chain Security Tools - Store

- Known issue 1
- Known issue 2
