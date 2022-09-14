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

- AppSSO uses a custom _Security Context Constraint_ to provide _OpenShift_ support.
- Kubernetes 1.24 is supported.
- Comply with the restricted _Pod Security Standard_ and give least privileges to the controller.
- `AuthServer` gets TLS-enabled `Ingress` autoconfigured. This can be controlled via `AuthServer.spec.tls`.
- Custom CAs are supported.
- More and better audit logs for authorization server events; `TOKEN_REQUEST_REJECTED`
- Enable the `/userinfo` endpoint.
- Increase the controller's default memory request and limits.
- Rename all Kubernetes resources in the _AppSSO_ package from _operator_ to _appsso-controller_.
- The controller restarts when its configuration is updated.
- The controller configuration is kept in a `Secret`.
- All existing `AuthServer` are updated and roll out when the controller's configuration changes significantly.

##### Deprecations

- `AuthServer.spec.issuerURI` is deprecated and marked for removal in the next release. Please, migrate
  to `AuthServer.spec.tls`.

##### Bug fixes

- Emit the audit `TOKEN_REQUEST_REJECTED` event when the `refresh_token` grant fails.
- The service binding `Secret` is updated when a `ClientRegistration` changes significantly.


#### <a id="default-roles-features"></a>Default roles for Tanzu Application Platform

- Added new default role `service-operator`. 

### Breaking changes

- `AuthServer.spec.identityProviders.internalUser.users.password` is now provided as plain text instead of _bcrypt_
  -hashed.
- When an authorization server fails to obtain a token from an OpenID identity provider, it will record
  an `INVALID_IDENTITY_PROVIDER_CONFIGURATION` audit event instead of `INVALID_UPSTREAM_PROVIDER_CONFIGURATION`.
- Package configuration `webhooks_disabled` has been removed and `extra` is renamed to `internal`.
- The `KEYS COUNT` print column has been replaced with the more insightful `STATUS` for `AuthServer`.
- The `sub` claim in `id_token`s and `access_token`s now follow the `<providerId>_<userId>` pattern,
  instead of `<providerId>/<userId>`. The previous pattern could cause bugs if used in URLs without
  proper URL-encoding in client applications. If your client application has stored `sub` claims,
  you may have to update them to match the new pattern.

##### Migration guide `v1.0.0` → `v2.0.0`

We strongly recommended that you recreate your `AuthServers` after upgrading your AppSSO package installation to `2.0.0`
with the following changes:

- Migrate from `.spec.issuerURI` to `.spec.tls`. AppSSO will template your issuer URI for you and provide TLS-enabled. A
  custom `Service` and ingress resource are no longer required.
  1. Configure one of `.spec.tls.{issuerRef, certificateRef, secretRef}`(
     see [Issuer URI & TLS](app-sso/service-operators/issuer-uri-and-tls.md)). Optionally, disable TLS
     with `.spec.tls.disabled`.
  2. Remove `.spec.issuerURI`.
  3. Delete your `AuthServer`-specific `Service` and ingress resources.
  4. Apply your `AuthServer`. You will find its issuer URI in `.status.issuerURI`.
  5. You can now update the redirect URIs in your upstream identity providers.

- If you are using the `internalUnsafe` identity provider migrate existing users by replacing the bcrypt hash by the
  plain-text equivalent. You can still use existing
  bcrypt passwords by prefixing them with `{bcrypt}`:

  ```yaml
  ---
  apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
  kind: AuthServer
  metadata:
    # ...
  spec:
    identityProviders:
      - name: internal
        internalUnsafe:
          users:
            # v1.0
            - username: test-user-1
              password: $2a$10$201z9o/tHlocFsHFTo0plukh03ApBYe4dRiXcqeyRQH6CNNtS8jWK # bcrypt-encoded "password"
              # ...
            # v2.0
            - username: "test-user-1"
              password: "{bcrypt}$2a$10$201z9o/tHlocFsHFTo0plukh03ApBYe4dRiXcqeyRQH6CNNtS8jWK" # same bcrypt hash, with {bcrypt} prefix
            - username: "test-user-2"
              password: "password" # plain text
    # ...
  ```

New versions of AppSSO are available from the Tanzu Application Platform package repository. See [AppSSO documentation](app-sso/platform-operators/upgrades.md) for detailed upgrade steps. 
You can also upgrade AppSSO as part of upgrading Tanzu Application Platform as a whole. See [Upgrading Tanzu Application Platform](upgrading.hbs.md) for more information.

#### <a id="apps-plugin"></a> Tanzu CLI - Apps plug-in

- Feature 1
- Feature 2

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
- **`tanzu services` CLI plug-in:** Improved information messages for deprecated commands.

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

- **Unable to view workloads on the panel when connected to GKE cluster:** 
When connecting to Google's GKE clusters, an error might appear with the text `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.` the cause is that GKE authentication was extracted into a separate plugin and is no longer inside kubernetes client or libraries. To fix this follow the instructions to [download and configure the GKE authentication plugin](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke) 

#### <a id="intelj-ext-known-issues"></a>Intellij Extension

- **Unable to view workloads on the panel when connected to GKE cluster:** 
When connecting to Google's GKE clusters, an error might appear with the text `WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.` the cause is that GKE authentication was extracted into a separate plugin and is no longer inside kubernetes client or libraries. To fix this follow the instructions to [download and configure the GKE authentication plugin](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke) 

#### <a id="store-known-issues"></a>Supply Chain Security Tools - Store

- Known issue 1
- Known issue 2
