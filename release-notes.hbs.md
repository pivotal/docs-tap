# Release notes

This topic contains release notes for Tanzu Application Platform v1.5.

## <a id='1-5-0'></a> v1.5.0

**Release Date**: April 11, 2023

### <a id="1-5-0-tap-new-features"></a> Tanzu Application Platform new features

- [Crossplane](crossplane/about.hbs.md) is a new component that powers a number of capabilities,
  such as dynamic provisioning of service instances with Services Toolkit as well as the
  provided Bitnami Services. It is part of the iterate, run, and full profiles.

- [Bitnami Services](bitnami-services/about.hbs.md) is a new component that includes a set of
  backing services for Tanzu Application Platform.
  The provided services are MySQL, PostgreSQL, RabbitMQ and Redis, all of which are backed by
  the corresponding Bitnami Helm Chart. It is part of the iterate, run and full profiles.

### <a id='1-5-0-new-component-features'></a> New features by component and area

#### <a id='1-5-0-app-accelerator-new-features'></a> Application Accelerator

- The Application Accelerator plug-in for IntelliJ is now available as a beta release on the [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
- The [Tanzu Java Restful Web App](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/java-rest-service) and [Tanzu Java Web App](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/tanzu-java-web-app) accelerators have the option to support Spring Boot v3.0.
- Use the `accelerator-info.yaml` file to review historical information and to determine if
  a project was generated with an accelerator.
- (Optional) Use a system-wide property in the `tap-values.yaml` configuration file to activate or
  deactivate Git repository creation. For more information, see [Deactivate Git repository creation](./tap-gui/plugins/application-accelerator-git-repo.hbs.md#deactiv-git-repo-creation).

#### <a id='1-5-0-appsso-new-features'></a> Application Single Sign-On (AppSSO)

- Introduces `AuthServer` CORS API that enables configuration of allowed HTTP origins.
  This is useful for public clients, such as single-page apps.
- Introduces an API for filtering external roles, groups, and memberships across OpenID, LDAP, and SAML identity providers
  in `AuthServer` resource into the `roles` claim of the resulting identity
  token. For more information, see [Roles claim filtering](app-sso/service-operators/identity-providers.hbs.md#roles-filters).
- Introduces mapping of users' roles, filtered and propagated in the identity
  token's `roles` claim, into scopes of the access token. For access tokens that are in the JWT format, the resulting
  scopes are part of the access token's `scope` claim, if the `ClientRegistration` contains the
  scopes. For more information, see [Configure authorization](app-sso/service-operators/configure-authorization.hbs.md).
- Introduces default access token scopes for user's authentication by using an identity
  provider. For more information, see [Default authorization scopes](app-sso/service-operators/configure-authorization.hbs.md#default-scopes).
- Introduces standardized client authentication methods to `ClientRegistration` custom resource.
  For more information, see [ClientRegistration](app-sso/crds/clientregistration.hbs.md).


#### <a id='1-5-0-bitnami-services-new-features'></a> Bitnami Services

- The new component [Bitnami Services](bitnami-services/about.hbs.md) is available with
  Tanzu Application Platform.

- This component provides integration for dynamic provisioning of Bitnami Helm Charts included with
  Tanzu Application Platform for the following backing services:
  - PostgreSQL
  - MySQL
  - Redis
  - RabbitMQ

- For more information, see [Working with Bitnami Services](services-toolkit/tutorials/working-with-bitnami-services.hbs.md).

#### <a id='1-5-0-crossplane-new-features'></a> Crossplane

- The new component [Crossplane](crossplane/about.hbs.md) is available with Tanzu Application Platform.
  - It installs [Upbound Universal Crossplane](https://github.com/upbound/universal-crossplane) version `1.11.0`.
  - This provides integration for dynamic provisioning in Services Toolkit and can be used for
  integration with cloud services such as AWS, Azure, and GCP.
  For more information, see
  [Integrating cloud services into Tanzu Application Platform](services-toolkit/tutorials/integrate-cloud-services.hbs.md).
  - For more information about dynamic provisioning, see
  [Set up dynamic provisioning of service instances](services-toolkit/tutorials/setup-dynamic-provisioning.hbs.md) to learn more.

- This release includes two Crossplane [Providers](https://docs.crossplane.io/v1.9/concepts/providers/), `provider-kubernetes` and `provider-helm`.
You can add other providers manually as required.

#### <a id='1-5-0-tap-gui-new-feats'></a> Tanzu Application Platform GUI

- Tanzu Application Platform GUI now supports automatic configuration with
  Supply Chain Security Tools - Store. For more information, see
  [Automatically connect Tanzu Application Platform GUI to the Metadata Store](tap-gui/plugins/scc-tap-gui.hbs.md#scan-auto).
- Tanzu Application Platform GUI enables specification of security banners. To use this customization,
  see [Customize security banners](tap-gui/customize/customize-portal.hbs.md#cust-security-banners).
- Tanzu Application Platform GUI includes an optional plug-in that collects telemetry by using the
  Pendo tool. To configure Pendo telemetry and opt in or opt out, see
  [Opt out of telemetry collection](../docs-tap/opting-out-telemetry.hbs.md).
- Upgrades Backstage to 1.10.1

  **Disclosure:** This upgrade includes a Java script operated by our service provider Pendo.io.
   The Java script is installed on selected pages of VMware software and collects information about
   your use of the software, such as clickstream data and page loads, hashed user ID, and limited
   browser and device information.
   This information is used to better understand the way you use the software in order to improve
   VMware products and services and your experience.
   For more information, see the
   [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html).

#### <a id="tap-gui-plug-in-known-issues"></a>Tanzu Application Platform GUI Plug-ins

- **App Accelerator Plug-in:**
  - Extracted application accelerator Entity Provider and template actions to a backend plugin
  - Added id generation for accelerator provenance
  - Hide context menu from the app accelerator scaffolder page, the edit template feature shouldn't be visible
  - Fixed JSON schema for git repository creation
  - Added missing query string parameters to accelerator provenance
  - Added fallback to displayName for telemetry call when email isn't present in the logged in user
  - Changed label for git repository confirmation checkbox
  - Changed app accelerator telemetry call to use username instead of email in the user details

- **Supply Chain Plug-in:**
  - Fix CPU stats in App Live View Steeltoe Threads and Memory pages
  - Retry logic to fetch a new token and retry the API call again when the alvToken has expired
  - Disable actions and display a message to the user when sensitive operations are deactivated for the app
  - Fix a bug on the App Live View Details page to show the correct Boot Version instead of UNKNOWN
  - Disable download heap dump button when sensitive operations are disabled for the application
  - Fix request params for post Api call
  - Fixes the UI error in ALV request-mapping page due to unused style.
  - Enable Secure Access Communication between App Live View components
  - Added API to connect to appliveview-apiserver by reusing tap-gui authentication
  - ALV plugin requests a token from appliveview-apiserver and passes it to every call to ALV backend
  - Secure sensitive operations (edit env, change log levels, download heap dump) and display a message in the UI
  - The k8s-logging-backend plugin is renamed to k8s-custom-apis-backend
  - Fetch token for logLevelsPanelToggle component loaded from the workload plugin PodLogs Page
  - Fix ALV Request Mappings and Threads Page to support Boot 3 apps

- **Security Analysis GUI Plug-in:**
  -  [Package Details] Add Impacted Workloads Column to Vulnerabilities table
  -  [CVE Details] Add Impacted Workloads widget to CVE Details Page
  -  Add Highest Reach Vulnerabilities widget to Security Analysis Dashboard
  -  [CVE Details] Display and navigate to latest source sha and/or image digest in the Workload Builds table
  -  [Package Details] Display and navigate to latest source sha and/or image digest in the Workload Builds table


#### <a id='1-5-0-services-toolkit-new-features'></a> Services Toolkit

- Services Toolkit now supports the dynamic provisioning of services instances.
  - `ClusterInstanceClass` now supports the new provisioner mode.
  When a `ClassClaim` is created which refers to a provisioner `ClusterInstanceClass`, a new
  service instance is created on-demand and claimed.
 This is powered by [Crossplane](crossplane/about.hbs.md).

- The `tanzu service` CLI plug-in has the following updates:
  - The command `tanzu service class-claim create`  now allows you to pass parameters to the
  provisioner-based `ClusterInstanceClass` to support dynamic provisioning.
  For example,
  `tanzu service class-claim create rmq-claim-1 --class rmq --parameter replicas=3  --parameter ha=true`
  - The `tanzu service class-claim get` now outputs parameters passed as part of claim creation.
  - For more information about these commands, see [Tanzu Service CLI Plug-In](services-toolkit/reference/tanzu-service-cli.hbs.md#stk-cli-class-claim).

- Services Toolkit integrates with the new component [Bitnami Services](bitnami-services/about.hbs.md),
  which provides pre-installed dynamic provisioning support for the following Helm charts:
  - PostgreSQL
  - MySQL
  - Redis
  - RabbitMQ

- Improved the security model to control which users can claim specific service instances.
  - Introduced the `claim` custom RBAC verb that targets a specific `ClusterInstanceClass`.
  You can bind this to users for access control of who can create `ClassClaim` resources for
  a specific `ClusterInstanceClass`.
  - A `ResourceClaimPolicy` is now created automatically for successful `ClassClaims`.
  - For more information, see [Authorize users and groups to claim from provisioner-based classes](services-toolkit/how-to-guides/authorize-claim-provisioner-classes.hbs.md) to learn more.

- `ResourceClaimPolicy` now supports targeting individual resources by name.
  To do so, configure `.spec.subject.resourceNames`.

- The `Where-For-Dinner` sample application accelerator now supports dynamic provisioning.

- There are large changes to the Services Toolkit component documentation.
  - The [standalone Services Toolkit documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/index.html)
  is no longer receiving updates.
  From now on you can find all Services Toolkit documentation in the Tanzu Application Platform
  component documentation section for [Services Toolkit](services-toolkit/about.hbs.md).
  - See the new [tutorials](services-toolkit/tutorials/index.hbs.md),
  [how-to guides](services-toolkit/how-to-guides/index.hbs.md),
  [concepts](services-toolkit/concepts/index.hbs.md), and
  [reference material](services-toolkit/reference/index.hbs.md) to learn more about working with services
  on Tanzu Application Platform.

#### <a id='1-5-0-scc-new-features'></a> Supply Chain Choreographer

- Introduces a variation of the OOTB Basic supply chains that output Carvel packages. Carvel packages enable configuring for each runtime environment. See [Carvel Package Workflow](scc/carvel-package-supply-chain.hbs.md). This feature is experimental.

#### <a id='1-5-0-scst-policy-new-features'></a> Supply Chain Security Tools - Policy Controller

- ClusterImagePolicy resync is triggered every 10 hours to get updated values from KMS.

#### <a id='1-5-0-external-secrets-new-features'></a>External Secrets CLI (Beta)
The external-secrets plug-in available in the Tanzu CLI interacts with the External Secrets Operator API. Users can use this CLI plug-in to create and view External Secrets Operator resources on a Kubernetes cluster.

Refer to the official [External Secrets Operator](https://external-secrets.io) documentation to learn
more about managing secrets with External Secrets in general. For installing the External Secrets
Operator and the CLI plug-in refer to the following documentation. Additionally, refer to the example
integration of External-Secrets with Hashicorp Vault

- [Installing External Secrets Operator in TAP](external-secrets/install-external-secrets-operator.hbs.md)
- [Installing External Secrets CLI plug-in](prerequisites.hbs.md)
- [External-Secrets with Hashicorp Vault](external-secrets/vault-example.md)


#### <a id='1-5-0-cert-manager-ncf'></a> cert-manager

- `cert-manager.tanzu.vmware.com` has upgraded to cert-manager `v1.11.0`.
For more information, see [cert-manager GitHub repository](https://github.com/cert-manager/cert-manager/releases/tag/v1.11.0).

#### <a id="1-5-0-scst-scan-features"></a> Supply Chain Security Tools - Scan
- SCST - Scan now runs on Tanzu Service Mesh-enabled clusters, enabling end to end, secure communication.
  - Kubernetes Jobs that previously created the scan pods were replaced with [Tekton TaskRuns](https://tekton.dev/docs/pipelines/taskruns/#overview).
  - [Observability](./scst-scan/observing.hbs.md) and [Troubleshooting](./scst-scan/troubleshoot-scan.hbs.md) documentation is updated to account for the impact of these changes. One restart in scanner pods is expected with successful scans. See [Scanner Pod restarts once in SCST - Scan `v1.5.0` or later](./scst-scan/troubleshoot-scan.hbs.md#scanner-pod-restarts).
- In conformance with NIST 800-53, support for rotating certificates and TLS is added.
  - Users can specify a TLS certificate, minimum TLS version, and restrict TLS ciphers when using kube-rbac-proxy. See [Configure properties](./scst-scan/install-scst-scan.hbs.md#configure-scst-scan).
- SCST - Scan now offers even more flexibility for users to use their existing investments in scanning solutions. In Tanzu Application Platform `v1.5.0`, users have early access to:
  - A new alpha integration with the [Trivy Open Source Vulnerability Scanner](https://www.aquasec.com/products/trivy/) by Aqua Security scans source code and images from secure supply chains. See [Install Trivy (alpha)](./scst-scan/install-trivy-integration.hbs.md).
  - A simplified alpha user experience for creating custom integrations with additional vulnerability scanners that aren't included by default. Got a scanner that you'd like to use with Tanzu Application Platform? See [SCST - Scan 2.0 (alpha)](./scst-scan/app-scanning-alpha.hbs.md).
  - The Tanzu team is looking for early adopters to test drive both of these alpha offerings and provide feedback. Email your Tanzu representative or [contact us here](https://tanzu.vmware.com/application-platform).

#### <a id='1-5-0-intellij-plugin-ncf'></a> Tanzu Developer Tools for IntelliJ

- The Tanzu Workloads panel is updated to show workloads deployed across multiple namespaces.
- Tanzu actions for workload apply, workload delete, debug, and Live Update start are now available
  from the Tanzu Workloads panel.
- Tanzu Developer Tools for IntelliJ can be used to iterate on Spring Boot 3 based applications.

#### <a id='1-5-0-vscode-plugin-ncf'></a> Tanzu Developer Tools for VS Code

- The Tanzu Activity tab in the Panels view enables developers to visualize the supply chain, delivery,
  and running application pods.
- The tab enables a developer to view and describe logs on each resource associated with a workload
  from within their IDE. The tab displays detailed error messages for each resource in an error state.
- The Tanzu Workloads panel is updated to show workloads deployed across multiple namespaces.
- Tanzu commands for workload apply, workload delete, debug, and Live Update start are now available
  from the Tanzu Workloads panel.
- Tanzu Developer Tools for VS Code can be used to iterate on Spring Boot 3 based applications.

#### <a id='1-5-0-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id='1-5-0-tbs-bc'></a> Tanzu Build Service

- The default `ClusterBuilder` now uses the Ubuntu Jammy v22.04 stack instead of the Ubuntu Bionic
v18.04 stack. Previously, the default `ClusterBuilder` pointed to the Base builder based on the
Bionic stack. Now, the default `ClusterBuilder` points to the Base builder based on the Jammy stack.
Ensure that your workloads can be built and run on Jammy.

  For information about how to change the `ClusterBuilder` from the default builder, see the
  [Configure the Cluster Builder](../docs-tap/tanzu-build-service/tbs-workload-config.hbs.md#cluster-builder) in the Tanzu Build Service documentation.

  For more information about available builders, see
  [Lite Dependencies](../docs-tap/tanzu-build-service/dependencies.hbs.md#lite-dependencies) and
  [Full Dependencies](../docs-tap/tanzu-build-service/dependencies.hbs.md#full-dependencies) in the
  Tanzu Build Service documentation.

#### <a id='1-5-0-security-fixes'></a> Security fixes

This release has the following security fixes, listed by area and component.

#### <a id='1-5-0-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id='1-5-0-app-accelerator-resolved-issues'></a> Application Accelerator

- Resolved issue with `custom types` not re-ordering fields correctly in the VS Code extension.

#### <a id='1-5-0-appsso-resolved-issues'></a> Application Single Sign-On (AppSSO)

- Resolved redirect URI issue with insecure HTTP redirection on Tanzu Kubernetes Grid multicloud
(TKGm) clusters.

### <a id='1-5-0-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id='1-5-0-cnrs-ki'></a> Cloud Native Runtimes

- When using auto-tls, on by default, DomainMapping resources must have names that are less than 63 characters. Otherwise, the DomainMapping fails to become ready due to `CertificateNotReady`.

#### <a id='1-5-0-vscode-plugin-ki'></a> Tanzu Developer Tools for VS Code

- If a user restarts their computer while running Live Update, without having terminated the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again. Delete the Tilt lock file to resolve this.
  The default file location is `~/.tilt-dev/config.lock`.

- On Windows, workload commands don't work when in a project with spaces in the name, such as
  `my-app project`.
  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#projects-with-spaces).

- If your kubeconfig file (`~/.kube/config`) is malformed, you cannot apply a workload.
  You see an error message when you attempt to do so. To resolve this, fix the kubeconfig file.

- In the Tanzu Activity Panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. It should be in the **Supply Chain** category.

#### <a id='1-5-0-intellij-plugin-ki'></a> Tanzu Developer Tools for IntelliJ

- A `com.vdurmont.semver4j.SemverException: Invalid version (no major version)` error is shown in the
  error logs when attempting to take a workload action before having installed the Tanzu CLI apps
  plug-in.

- The apply action prompts and stores the workload file path when using the action for the first time,
  but modifying it afterwards is not possible.
  If the workload file location changes, the user needs to delete the module's key-value entries
  prefixed with `com.tanzu` in the `PropertiesComponent` found in the project's `.idea/workspace.xml`
  file to delete the configuration. The next apply action run prompts for new values again.

- If a user restarts their computer while running Live Update without having terminated the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again.
  Deleting the Tilt lock file resolves this. The default location is `~/.tilt-dev/config.lock`.

- On Windows, workload actions do not work when in a project with spaces in the name such as
  `my-app project`.
  For more information, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#projects-with-spaces).

- In the Tanzu Activity Panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. It should be in the **Supply Chain** category.

#### <a id="1-5-0-grype-scan-known-issues"></a>Grype scanner

- **Scanning Java source code that uses Gradle package manager might not reveal
  vulnerabilities:**

  For most languages, source code scanning only scans files present in the
  source code repository. Except for support added for Java projects using
  Maven, no network calls fetch dependencies. For languages using dependency
  lock files, such as golang and Node.js, Grype uses the lock files to verify
  dependencies for vulnerabilities.

  For Java using Gradle, dependency lock files are not guaranteed, so Grype uses
  dependencies present in the built binaries, such as `.jar` or `.war` files.

  Grype fails to find vulnerabilities during a source scan because VMware
  discourages committing binaries to source code repositories. The
  vulnerabilities are still found during the image scan after the binaries are
  built and packaged as images.

#### <a id='1-5-0-tap-gui-ki'></a> Tanzu Application Platform GUI

- The portal might partially overlay text on the Security Banners customization (bottom banner).

- The Impacted Workloads table is empty on the **CVE and Package Details** pages if the relevant CVE
  belongs to a workload that has only completed one type of vulnerability scan (either image or source).
  A fix is planned for Tanzu Application Platform GUI v1.5.1.

#### <a id='1-5-0-cb-scanner'></a> Supply Chain Security Tools - Scan
- **Update binary use for scanning to v1.9.2**
- Add support for BuildPack scan enhancer using cyclonedx.
- Updated Syft version to 0.74.0
- Update scan logic to reduce scan time.
- Malware Detection added, log into the web interface to check for images file reputation.

  for the full patch-note check [VMware Carbon Black Cloud Console Release Notes](https://docs.vmware.com/en/VMware-Carbon-Black-Cloud/services/rn/vmware-carbon-black-cloud-console-release-notes/index.html).

#### <a id="1-5-0-external-secrets-known-issue"></a>External Secrets CLI (Beta)

- The external-secrets plug-in creating `ExternalSecret` and `SecretStore` resource via STDIN incorrectly confirms resource creation. Use `-f ` to create resources via file instead of stdin.

## <a id='1-5-deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

### <a id='1-5-appsso-deprecations'></a> Application Single Sign-On (AppSSO)

- `ClientRegistration` resource `clientAuthenticationMethod` field values `post` and `basic` are deprecated.
Use `client_secret_post` and `client_secret_basic` instead.
<!-- has this been removed already? If yes, should it be a breaking change. If not, when? -->

### <a id='1-5-convention-controller-dp'></a> Convention Controller

- This deprecated component has now been removed in this release and is replaced by [Cartographer Conventions](https://github.com/vmware-tanzu/cartographer-conventions). Cartographer Conventions implements the `conventions.carto.run` API that includes all the features that were available in the Convention Controller component.

<!-- has this been removed already? If yes, should it be a breaking change. If not, when? -->

#### <a id="1-5-app-live-view-deprecations"></a> Application Live View

- `appliveview_connnector.backend.sslDisabled` is deprecated and marked for
  removal in Tanzu Application Platform 1.7.0. For more information on the
  migration, see [Deprecate the sslDisabled
  key](app-live-view/install.hbs.md#deprecate-the-ssldisabled-key).

#### <a id="1-4-0-app-sso-deprecations"></a> Application Single Sign-On (AppSSO)

- `AuthServer.spec.tls.disabled` is deprecated and marked for removal in the
  next release. For more information about how to migrate to
  `AuthServer.spec.tls.deactivated`, see [Migration
  guides](app-sso/upgrades/index.md#migration-guides).
  <!-- has this been removed in 1.5? If yes, should it be a breaking change. If not, when? -->

#### <a id="1-4-0-stk-deprecations"></a> Services Toolkit

- The `tanzu services claims` CLI plug-in command is now deprecated. It is
  hidden from help text output, but continues to work until officially removed
  after the deprecation period. The new `tanzu services resource-claims` command
  provides the same functionality.
  <!-- has this been removed already? If yes, should it be a breaking change. If not, when? -->

#### <a id="1-5-scst-scan-deprecations"></a> Supply Chain Security Tools - Scan

- Removed deprecated ScanTemplates:
  - Deprecated Grype ScanTemplates shipped with versions prior to Tanzu
    Application Platform 1.2.0 are removed and no longer supported. Use Grype
    ScanTemplates v1.2 and later.
  - `docker` field and related sub-fields used in Supply Chain Security Tools -
    Scan are deprecated and marked for removal in Tanzu Application Platform
    1.7.0.
    - The deprecation impacts the following components: Scan Controller, Grype
      Scanner, and Snyk Scanner. Carbon Black Scanner is not impacted.
    - For information about the migration path, see
  [Troubleshooting](scst-scan/observing.hbs.md#unable-to-pull-scanner-controller-images).

#### <a id="1-4-scst-sign-deprecations"></a> Supply Chain Security Tools - Sign

- [Supply Chain Security Tools - Sign](scst-sign/overview.md) is deprecated. For
  migration information, see [Migration From Supply Chain Security Tools -
  Sign](./scst-policy/migration.hbs.md).
  <!-- has this been removed already? If yes, should it be a breaking change. If not, when? -->

#### <a id="1-5-tbs-deprecations"></a> Tanzu Build Service

- The Ubuntu Bionic stack is deprecated: Ubuntu Bionic stops receiving support
in April 2023. VMware recommends you migrate builds to Jammy stacks in advance.
For how to migrate builds, see [Use Jammy stacks for a
workload](tanzu-build-service/dependencies.md#using-jammy).
- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated.
VMware plans to deactivate this format by default in Tanzu Application Platform
v1.5 and remove support in Tanzu Application Platform v1.6. To manually
deactivate legacy CNB BOM support, see [Deactivate the CNB BOM
format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).
  <!-- is the plan to remove support still true? -->

#### <a id="1-5-apps-plugin-deprecations"></a> Tanzu CLI Apps plug-in

- The default value for the
  [`--update-strategy`](./cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md#update-strategy)
  flag will change from `merge` to `replace` in Tanzu Application Platform
  v1.7.0.
- The `tanzu apps workload update` command is deprecated and marked for removal
  in Tanzu Application Platform 1.5.0. Use `tanzu apps workload apply` instead.
    <!-- Should this be a breaking change? -->
