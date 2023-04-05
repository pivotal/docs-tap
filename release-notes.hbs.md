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
- Accelerator Tanzu CLI plugin now supports using the TAP-GUI URL with the --server-url command option. For more information, see [Using TAP-GUI URL](https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/1.5/tap/cli-plugins-accelerator-overview.html#server-api-connections-for-operators-and-developers-0)

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

#### <a id="1-5-namespace-provisiones-new-feats"></a> Namespace Provisioner

- New Out-of-the-box GitOps workflow for managing the list of desired namespaces fully declaratively
  via a Git repo. Specify the location of GitOps repo that has the list of desired namespaces as
  `ytt data values` to be imported in the namespace provisioner using the `gitops_install` TAP values configuration.
  - For more information, refer to the GitOps section in
    [Provision Developer Namespace](./namespace-provisioner/provision-developer-ns.md) documentation.
- Namespace provisioner controller supports adding namespace parameters from labels/annotations on
  namespace objects based on accepted prefixes defined in `parameter_prefixes` TAP values configuration.
  You can use this feature to add custom parameters to a namespace for creating resources conditionally.
  - For an example use case, refer to the documentation on how to
    [Create Tekton pipelines and Scan policies using namespace parameters](./namespace-provisioner/use-case2.md).
- Add support for importing Kubernetes Secrets that contains a `ytt overlay` definition that can be
  applied to the resources created by the Namespace provisioner.
  - Using the `overlays_secret` configuration in namespace provisioner TAP values, users can provide
    a list of secrets that contains the overlay definition they want to apply to resources created by provisioner.
  - For an example use case, refer to the documentation on how to
    [Customize OOTB default resources](./namespace-provisioner/use-case4.md) using overlays.
- Add support for reading sensitive data from a Kubernetes secret in YAML format and populating that
  information in the resources created by namespace provisioner in runtime and keep it in sync with
  the source, thereby removing the need to store any sensitive data in GitOps repository.
  - Using the `import_data_values_secrets` configuration in namespace provisioner TAP values, you can
   import sensitive data from a YAML formatted secret and make it available under `data.values.imported` for additional resource templating.
  - For an example use case, refer to the documentation on how to
    [Install multiple scanners in the developer namespace](./namespace-provisioner/use-case5.md).
- Namespace Provisioner now creates a Kubernetes `LimitRange` object with sensible defaults which sets
  max limits on how much resource pods in the managed namespace can request.
  - Run profile: Stamped by default.
  - Full & Iterate profile: Opt-in using parameters.
    - Refer to the [Customize OOTB Limit Range default](./namespace-provisioner/use-case4.md#customize-limit-range-defaults) documentation for sample configuration.
- Namespaces provisioner enabled users to use private git repositories for storing their GitOps based
  installation files as well as additional platform operator templated resources that they want to create
  in their developer namespace. Authentication is provided using a secret in `tap-namespace-provisioning`
  namespace, or an existing secret in another namespace referred to in the `secretRef` in the additional sources.
  - For an example use case, refer to the documentation on [Working with private Git Repositories](./namespace-provisioner/use-case3.md)

#### <a id='1-5-0-tap-gui-new-feats'></a> Tanzu Application Platform GUI

- **Disclosure:** This upgrade includes a Java script operated by the service provider Pendo.io.
  The Java script is installed on selected pages of VMware software and collects information about
  your use of the software, such as clickstream data and page loads, hashed user ID, and limited
  browser and device information.
  This information is used to better understand the way you use the software in order to improve
  VMware products and services and your experience.
  For more information, see the
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html).

- Supports automatic configuration with Supply Chain Security Tools - Store. For more information,
  see [Automatically connect Tanzu Application Platform GUI to the Metadata Store](tap-gui/plugins/scc-tap-gui.hbs.md#scan-auto).
- Enables specification of security banners. To use this customization,
  see [Customize security banners](tap-gui/customize/customize-portal.hbs.md#cust-security-banners).
- Upgrades Backstage to v1.10.1
- Includes an optional plug-in that collects telemetry by using the Pendo tool.
  To configure Pendo telemetry and opt in or opt out, see
  [Opt out of telemetry collection](../docs-tap/opting-out-telemetry.hbs.md).

#### <a id="tap-gui-plug-in-new-feats"></a> Tanzu Application Platform GUI plug-ins

- **App Accelerator Plug-in:**
  - Extracted Application Accelerator Entity Provider and template actions to a back-end plug-in.
  - Added ID generation for accelerator provenance.
  - Hid pop-up menu from the Application Accelerator scaffolder page and, consequently, hid the
    **Edit template** feature.
  - Added fallback to `displayName` for a telemetry call when an email address isn't present for the
    logged-in user.
  - Changed label for the Git repository confirmation check box.
  - Changed the app accelerator telemetry call to use the user name instead of an email address in
    the user details.

- **Supply Chain Plug-in:**
  - When `alvToken` has expired, the logic to fetch a new token and the API call are both retried.
  - Actions are deactivated and a message is displayed when sensitive operations are deactivated for
    the app.
  - The **Heap Dump** button deactivates when sensitive operations are deactivated for the application.
  - Enabled Secure Access Communication between App Live View components.
  - Added an API to connect to `appliveview-apiserver` by reusing `tap-gui` authentication.
  - The ALV plug-in now requests a token from `appliveview-apiserver` and passes it to every call to
    the ALV back end.
  - Secured sensitive operations (edit env, change log levels, download heap dump) and display a
    message in the UI.
  - Renamed the `k8s-logging-backend` plug-in as `k8s-custom-apis-backend`.
  - The fetch token for the `logLevelsPanelToggle` component is now loaded from the workload plug-in
    PodLogs page.

- **Security Analysis GUI Plug-in:**
  - **CVE Details:** Added Impacted Workloads widget to the CVE Details page.
  - **CVE Details:** Display and navigate to latest source SHA or image digest in the Workload Builds
    table.
  - **Package Details:** Added Impacted Workloads column to the Vulnerabilities table.
  - **Package Details:** Display and navigate to latest source SHA or image digest in the Workload
    Builds table.
  - **Security Analysis Dashboard:** Added Highest Reach Vulnerabilities widget.

#### <a id="1-5-apps-plugin-new-feats"></a> Tanzu CLI Apps plug-in

- Added support for `-ojson` and `-oyaml` output flags in `tanzu apps workload create/apply` command.
  - The CLI does not wait to print workload when using `--output` in workload create/apply unless
  `--wait` or `--tail` flags are specified as well.
- Using the `--no-color` flag in `tanzu apps workload create/apply` commands now hides progress bars
  in addition to color output and emojis.
- Added support for unsetting `--git-repo`, `--git-commit`, `--git-tag` and `--git-branch` flags
  by setting the value to empty string.

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
- Carbon Black Scanner - **Update carbon black scanner CLI to version 1.9.2**
  - Add BuildPack cyclonedx support:

    when scanning image that was created by BuildPack add package from the create and build image to scan manifest.
  - Update scan logic to reduce scan time.

    **for the full patch-note and other feature check [CBC Console Release Notes](https://docs.vmware.com/en/VMware-Carbon-Black-Cloud/services/rn/vmware-carbon-black-cloud-console-release-notes/index.html#What's%20New%20-%2012%20January%202023-Container%20Essentials).**

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

| Package Name | Vulnerabilities Resolved |
| ------------ | ------------------------ |
| buildservice.tanzu.vmware.com | <ul><li> GHSA-fxg5-wq6x-vr4w</li><li>CVE-2023-0179 </li></ul>|
| eventing.tanzu.vmware.com | <ul><li> GHSA-fxg5-wq6x-vr4w</li><li>GHSA-69cg-p879-7622</li><li>GHSA-69ch-w2m2-3vjp </li></ul>|
| learningcenter.tanzu.vmware.com | <ul><li> GHSA-fxg5-wq6x-vr4w</li><li>CVE-2023-0461</li><li>GHSA-3vm4-22fp-5rfm</li><li>GHSA-69ch-w2m2-3vjp</li><li>CVE-2023-24329</li><li>GHSA-83g2-8m93-v3w7</li><li>GHSA-ppp9-7jff-5vj2</li><li>CVE-2023-0286</li><li>CVE-2023-23919</li><li>GHSA-2hrw-hx67-34x6</li><li>GHSA-x4qr-2fvf-3mr5 </li></ul>|
| policy.apps.tanzu.vmware.com | <ul><li> GHSA-fxg5-wq6x-vr4w </li></ul>|
| workshops.learningcenter.tanzu.vmware.com | <ul><li> GHSA-fxg5-wq6x-vr4w</li><li>CVE-2023-0461</li><li>GHSA-3vm4-22fp-5rfm</li><li>GHSA-69ch-w2m2-3vjp</li><li>CVE-2023-24329</li><li>GHSA-83g2-8m93-v3w7</li><li>GHSA-ppp9-7jff-5vj2</li><li>CVE-2023-0286</li><li>CVE-2023-23919 </li></ul>|
| carbonblack.scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-24827 </li></ul>|
| grype.scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-24329 </li></ul>|
| snyk.scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-24329 </li></ul>|
| tap-gui.tanzu.vmware.com | <ul><li> CVE-2023-0286</li><li>CVE-2023-23918</li><li>CVE-2023-23919</li><li>CVE-2023-0361</li><li>CVE-2022-4450</li><li>CVE-2023-0215 </li></ul>|

#### <a id='1-5-0-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id='1-5-0-app-accelerator-resolved-issues'></a> Application Accelerator

- Resolved issue with `custom types` not re-ordering fields correctly in the VS Code extension.

#### <a id='1-5-0-appsso-resolved-issues'></a> Application Single Sign-On (AppSSO)

- Resolved redirect URI issue with insecure HTTP redirection on Tanzu Kubernetes Grid multicloud
(TKGm) clusters.

#### <a id="1-5-namespace-provisioner-resolved-issues"></a> Namespace Provisioner

- Updates default resources to avoid ownership conflicts with the `grype` package.

#### <a id="tap-gui-plug-in-new-feats"></a>Tanzu Application Platform GUI plug-ins

- **App Accelerator Plug-in:**

  - Fixed JSON schema for Git repository creation.
  - Added missing query string parameters to accelerator provenance.

- **Supply Chain Plug-in:**

  - Fixed CPU stats in App Live View Steeltoe Threads and Memory pages.
  - The App Live View Details page now shows the correct boot version instead of **UNKNOWN**.
  - Fixed request parameters for the post-API call.
  - Fixed the UI error in the ALV request-mapping page that was caused by an unused style.
  - Fixed the ALV Request Mappings and Threads page to support Boot 3 apps.

#### <a id="1-5-apps-plugin-resolved-issues"></a> Tanzu CLI Apps plug-in

- Allow users to pass only `--git-commit` for git ref while creating a workload from Git Repository.
  This update removes the limitation where users had to provide a `--git-tag` or `--git-branch` along with the commit to create a workload.
- Fixed the behavior where `subpath` was getting removed from the Workload when there are updates
  to the git section of the Workload source specification.

### <a id='1-5-0-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id='1-5-0-bitnami-services-ki'></a> Bitnami Services

- If you try to configure private registry integration for the Bitnami services
after having already created a claim for one or more of the Bitnami services using the default
configuration, the updated private registry configuration does not appear to take effect.
This is due to caching behavior in the system which is not currently accounted for during configuration
updates. For a workaround, see [Troubleshooting and limitations](services-toolkit/how-to-guides/troubleshooting.hbs.md).

#### <a id='1-5-0-cnrs-ki'></a> Cloud Native Runtimes

- When using auto-tls, on by default, DomainMapping resources must have names that are less than 63 characters. Otherwise, the DomainMapping fails to become ready due to `CertificateNotReady`.

#### <a id="1-5-apps-plugin-known-issues"></a> Tanzu CLI Apps plug-in

- `tanzu apps workload apply` does not wait for the changes to be taken when the workload is updated
   using `--tail` or `--wait` and instead, fails if the status before the changes is showing error.

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

#### <a id='1-5-0-eventing'></a> Eventing

When using vsphere sources in Eventing, the vsphere-source is currently using a high number of informers to alleviate load on the api server resulting in high memory utilization.

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
  in Tanzu Application Platform 1.6.0. Use `tanzu apps workload apply` instead.
    <!-- Should this be a breaking change? -->
