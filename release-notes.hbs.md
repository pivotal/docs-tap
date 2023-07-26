# Tanzu Application Platform release notes

This topic describes the changes in Tanzu Application Platform (commonly known as TAP)
v{{ vars.url_version }}.

{{#unless vars.hide_content}}

This Handlebars condition is used to hide content.

In release notes, this condition hides content that describes an unreleased patch for a released minor.

{{/unless}}

## <a id='1-6-1'></a> v1.6.1

**Release Date**: 27 July 2023

### <a id='1-6-1-whats-new'></a> What's new in Tanzu Application Platform

This release includes the following platform-wide enhancements.

#### <a id='1-6-1-new-platform-feats'></a> New platform-wide features

- New services available with the Bitnami Service package: MongoDB and Kafka.
- Best practices required to build and deploy workloads at scale are now available
in the documentation. For more information, see [Scale workloads](scalability.hbs.md).

#### <a id='1-6-1-new-components'></a> New components

- [Local Source Proxy](local-source-proxy/about.hbs.md) offers developers a secure and user-friendly
  approach to seamlessly upload their local source code to a Tanzu Application Platform cluster.
  This enables developers to navigate their code smoothly through a predefined production pathway
  using supply chains.

  This component reduces the obstacles faced by developers who would otherwise need to manually
  specify a registry and provide their credentials on their local systems for iterative inner loop
  workflows.

---

### <a id='1-6-1-new-features'></a> New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-6-1-app-acc'></a> Application Accelerator

- The Application Accelerator plug-in for IntelliJ has now reached general availability on [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
  The plug-in for IntelliJ now supports Git repository creation and custom type declarations for options,
  and embeds telemetry and bootstrapping provenance.
  For more information, see [Application Accelerator IntelliJ Plug-in](./application-accelerator/intellij.hbs.md).

#### <a id='1-6-1-alv'></a> Application Live View

- You can secure access, at the user level, to sensitive operations that can be executed on a running
  application using the actuator endpoints. For more information, see
  [Authorize a user to execute sensitive operations](app-live-view/improved-security-and-access-control.hbs.md#access-control).

- Developers can view the live information of natively compiled Spring applications by using
  Application Live View for lightweight troubleshooting.
  The pages and metrics that are currently unavailable for natively compiled Spring applications include
  threads, heap dump, memory graphs, cache manager, conditions, schedules tasks, and actuator information.
  For more information, see [Enable Spring Native apps for Application Live View](app-live-view/configuring-apps/spring-native-enablement.hbs.md).

#### <a id='1-6-1-appsso'></a> Application Single Sign-On (AppSSO)

- Incorporates the token expiry settings into the `AuthServer` resource. Service
  operators can customize the expiry settings of access, refresh, or identity
  tokens. For more information, see
  [Token settings](./app-sso/how-to-guides/service-operators/token-settings.hbs.md#token-expiry-settings).

- You can map custom user attributes or claims from upstream identity providers, such as
  OpenID, LDAP, and SAML. You can also configure the internal unsafe provider with custom claims.
  For more information, see [Identity providers](./app-sso/how-to-guides/service-operators/identity-providers.hbs.md#id-token-claims-mapping).

- Adds `ClusterUnsafeTestLogin`, which is an unsafe, ready-to-claim Application Single Sign-On service
  offering that you can use to get started. It is not safe for production environments.
  For more information, see [ClusterUnsafeTestLogin API](app-sso/reference/api/clusterunsafetestlogin.hbs.md).

- Adds `ClusterWorkloadRegistrationClass`, which exposes an `AuthServer` as a ready-to-claim
  Application Single Sign-On service offering. For more information, see
  [ClusterWorkloadRegistrationClass API](app-sso/reference/api/clusterworkloadregistrationclass.hbs.md).

- Adds `WorkloadRegistration`, which is a portable client registration that templates redirect URIs.
  For more information, see [WorkloadRegistration API](app-sso/reference/api/workloadregistration.hbs.md).

- Adds `XWorkloadRegistration`, which is a composite resource definition (XRD) and an integration
  API between Services Toolkit, Crossplane, and Application Single Sign-On.
  For more information, see [XWorkloadRegistration API](app-sso/reference/api/xworkloadregistration.hbs.md).

#### <a id='1-6-1-bitnami-services'></a> Bitnami Services

The `bitnami.services.tanzu.vmware.com` package v0.2.0 includes the following:

- New services available: MongoDB and Kafka

#### <a id='1-6-1-cnrs'></a> Cloud Native Runtimes

- Adds a new configuration option that configures `default-external-scheme` on Knative's `config-network`
  ConfigMap with a default scheme you can use for Knative Service URLs.
  Supported values are either `http` or `https`. You cannot set this option at the same time as the
  `default_tls_secret` option.

#### <a id='1-6-1-contour'></a> Contour

- Adds new parameters to specify `contour` and `envoy` resources requests and limits for CPU and memory.
  For more information, see [Install Contour](contour/install.hbs.md).

- For more information about the new features in Contour v1.24.4, see the
  [Contour release notes](https://github.com/projectcontour/contour/releases/tag/v1.24.4) in GitHub.

#### <a id='1-6-1-crossplane'></a> Crossplane

The `crossplane.tanzu.vmware.com` package v0.2.1 includes the following:

- Includes updates to the following software components:

  - Updates Universal Crossplane (UXP) to v1.12.1-up.1, which includes new Crossplane features such
    as ObserveOnly resources, Composition Validation, and Pluggable Secret Stores.
    For the full release notes, see
    [universal-crossplane releases](https://github.com/upbound/universal-crossplane/releases/tag/v1.12.1-up.1)
    in GitHub.
  - Updates provider-helm to v0.15.0. For the full release notes, see
    [provider-helm releases](https://github.com/crossplane-contrib/provider-helm/releases/tag/v0.15.0)
    in GitHub.
  - Updates provider-kubernetes to v0.8.0. For the full release notes, see
    [provider-kubernetes releases](https://github.com/crossplane-contrib/provider-kubernetes/releases/tag/v0.8.0)
    in GitHub.

  For more information about versions of software comprising the Crossplane package, See
  [Version matrix for Crossplane](./crossplane/reference/version-matrix.hbs.md).

- The Crossplane package now more gracefully handles situations in which Crossplane is already
  installed to a cluster by using another method, for example, through Helm install.
  For more information, see [Use your existing Crossplane installation](crossplane/how-to-guides/use-existing-crossplane.hbs.md).

- Includes kapp wait rules that match on `Healthy=True` for the Providers.
  This means that package installation now waits for the Providers to become healthy before reporting
  success.

- Adds support for installing Providers in environments that use custom CA certificates.

- Adds the `orphan_resources` package value to allow you to configure whether to orphan all Crossplane
  Custom Resource Definitions (CRDs), providers, and managed resources when the package is uninstalled.
  This setting is optional. The default is `true`.

  **Caution**: setting this value to `false` causes all Crossplane CRDs, providers, and managed
  resources to be deleted when the `crossplane.tanzu.vmware.com` package is uninstalled.
  This might also cause any existing service instances also being deleted.
  For more information, see [Delete Crossplane resources when you uninstall Tanzu Application Platform](./crossplane/how-to-guides/delete-resources.hbs.md)

#### <a id='1-6-1-flux-sc'></a> FluxCD Source Controller

Flux Source Controller v0.36.1-build.2 release includes the following API changes:

- `GitRepository` API:

  - `spec.ref.name` is the reference value for Git checkout. It takes precedence over Branch,
  Tag, and SemVer. It must be a valid
  [Git reference](https://git-scm.com/docs/git-check-ref-format#_description).

      Examples:

      - `"refs/heads/main"`
      - `"refs/tags/v0.1.0"`
      - `"refs/pull/420/head"`
      - `"refs/merge-requests/1/head"`

  - `status.artifact.digest` represents the value of the file in the form of `ALGORITHM:CHECKSUM`.
  - `status.observedIgnore` represents the latest `spec.ignore` value. It indicates the ignore
    rules for building the current artifact in storage.
  - `status.observedRecurseSubmodules` represents the latest `spec.recurseSubmodules` value
    during the latest reconciliation.
  - `status.observedInclude` represents the list of `GitRepository` resources that produces
    the current artifact.

- `OCIRepository` API:

  - `spec.layerSelector` specifies which layer is extracted from an OCI Artifact.
    This field is optional and set to extracting the first layer in the artifact by default.
  - `spec.verify` includes the secret name that holds the trusted public keys for signature verification.
    It also indicates the provider responsible for validating the authenticity of the OCI image.
  - `spec.insecure` enables connections to a non-TLS HTTP container image registry.

- `HelmChart` API:

  - Adds the new field `spec.verify`, which includes the secret name that holds
    the trusted public keys for signature verification.
    It also indicates the provider responsible for validating the authenticity of the OCI image.
    This field is only supported when using the HelmRepository source with the `spec.type` OCI.
    Chart dependencies, which are not bundled in the umbrella chart artifact, are not verified.

- `HelmRepository` API:

  - Adds the new field `spec.provider` for authentication purposes. Supported values are
    `aws`, `azure`, `gcp`, or `generic`.
    `generic` is its default value. This field is only required when the `.spec.type` field is set to `oci`

- `Bucket` API:

  - Adds the new field `status.observedIgnore`, which represents the latest `spec.ignore` value.
    It indicates the ignore rules for building the current artifact in storage.

#### <a id='1-6-1-namespace-provisioner'></a> Namespace Provisioner

- Implements the capability to skip creating certain default resources for the Namespace Provisioner,
  providing greater flexibility for customization.

- Enables you to deactivate the default installation of the Grype scanner by using `default_parameters`
  in the `tap-values.yaml` file or by using namespace parameters. For more information, see
  [Deactivate Grype install](namespace-provisioner/use-case4.hbs.md#deactivate-grype-install).

- Enhances support for adding `secrets` and `imagePullSecrets` to the service account used by the
  Supply Chain and Delivery components. You can do this by using either `default_parameters` or
  namespace-level parameters. For more information, see
  [Customize service accounts](namespace-provisioner/use-case4.hbs.md#customize-service-accounts).

- Introduces the option to deactivate the creation of the LimitRange object in `full`, `iterate`,
  and `run` profile clusters. For more information, see
  [Deactivate LimitRange Setup](namespace-provisioner/use-case4.hbs.md#deactivate-limitrange-setup).

- Adds support for passing lists or objects with annotations for complex namespace parameters.
  This simplifies the configuration process. For more information about how to use this feature, see
  [Namespace parameters](namespace-provisioner/parameters.hbs.md).

- The `path` value in `additional_sources` is now automatically generated, eliminating the need for
  you to provide it manually. This simplifies the configuration of external sources.

#### <a id='1-6-1-stk'></a> Services Toolkit

The `services-toolkit.tanzu.vmware.com` package v0.11.0 includes the following:

- Adds Kubernetes events to make debugging easier:
  - Normal events: CreatedCompositeResource, DeletedCompositeResource, ClaimableInstanceFound,
    NoClaimableInstancesFound
  - Warning events: ParametersValidationFailed, CompositeResourceDeletionFailed

- Updates reconciler-runtime to v0.11.1.

The Tanzu Service CLI plug-in v0.7.0 includes the following:

- The Tanzu Service plug-in is now compiled using the new Tanzu CLI runtime (v0.90.0).
- There are no new features or changes to existing commands.

#### <a id='1-6-1-scc'></a> Supply Chain Choreographer

- [Carvel Package Supply Chains](scc/carvel-package-supply-chain.hbs.md) are promoted from `alpha` to `beta`.

#### <a id='1-6-1-scst-scan'></a> Supply Chain Security Tools (SCST) - Scan

- The source scanning step is removed from the out-of-the-box test and scan supply chain. <!-- should this be Out of the Box Supply Chain - Testing and Scanning? -->
  For information about how to add the source scanning step to the test and scan supply chain, see
  [Scan Types for Supply Chain Security Tools - Scan](scst-scan/scan-types.hbs.md#source-scan).

- [Supply Chain Security Tools - Scan 2.0](scst-scan/app-scanning-beta.hbs.md) is promoted from `alpha`
  to `beta`.  This promotion primarily includes capabilities to integrate the SCST-Scan 2.0 component
  with other components of the Tanzu Application Platform, including:

  - The ability to enable Supply Chain Security Tools (SCST) - Scan 2.0 in the out-of-the-box test
    and scan supply chain.<!-- should this be Out of the Box Supply Chain - Testing and Scanning? --> For more information, see
    [Add app scanning to default test and scan supply chains](scst-scan/integrate-app-scanning.hbs.md#adding-app-scanning-to-default-test-and-scan-supply-chain).
  - [Artifact Metadata Repository (AMR) Observer (alpha)](scst-store/amr/overview.hbs.md#amr-observer)
    observes scan results from SCST - Scan 2.0 and archives them to the
    [AMR (beta)](scst-store/amr/architecture.hbs.md) for long-term storage and reporting, and use by
    other Tanzu Application Platform components.
  - Results from image scans with SCST - Scan 2.0 are now available in
    [Supply Chain Choreographer](tap-gui/plugins/scc-tap-gui.hbs.md) and
    [Security Analysis](tap-gui/plugins/sa-tap-gui.hbs.md) plug-ins for the Tanzu Developer Portal.
  - [Sample scan templates](scst-scan/ivs-custom-samples.hbs.md) are created to help users get started
    with examples of how to bring your own scanner:
      - [Carbon Black](scst-scan/ivs-carbon-black.hbs.md)
      - [Snyk](scst-scan/ivs-snyk.hbs.md)
      - [Prisma](scst-scan/ivs-prisma.hbs.md)
      - [Trivy](scst-scan/ivs-trivy.hbs.md)
      - [Grype](scst-scan/ivs-grype.hbs.md)
  - VMware encourages feedback about SCST - Scan 2.0. Email your VMware representative or [contact us here](https://tanzu.vmware.com/application-platform).

#### <a id='1-6-1-scst-store'></a> Supply Chain Security Tools (SCST) - Store

- Adds a new report feature that links all packages, vulnerabilities, and ratings
  associated from a specific vulnerability scan SBOM to a Store report. When
  querying a report, it returns information linked to the original SBOM report
  instead of returning the aggregated data of all reports for the linked image
  or source.
  - Updates to the `POST /api/v1/images` and `POST /api/v1/sources` APIs:
      - New optional header request fields:
          - `Report-UID`: A unique identifier to assign to the report. If omitted, a
            unique identifier is randomly generated for the report. Supported
            characters: ALPHA DIGIT hyphen (`-`), period (`.`), underscore (`_`), and tilde (`~`).
            <!-- is ALPHA DIGIT upper/lowercase letters (a-z) and (A-Z), numbers (0-9), special chars ("-" / "." / "_" / "~") -->
          - `Original-Location`: The stored location of the original SBOM
            vulnerability scan result used to create this report.
      - New response field returned `ReportUID`, the report's unique identifier
      associated with the data submitted by this image.
  - Updates to the `POST /api/v1/artifact-groups` API:
      - New `ReportUID` optional body payload field that links an existing
      report, tagged by its UID, to this artifact group.
  - New `GET /api/v1/report/{ReportUID}` API gets a specific report by its unique identifier.
  - New `GET /api/v1/reports` API queries for a list of reports with specified
    image digest, source SHA, or original location.
      > **Note** When you request SPDX or CycloneDX format, the report date is
      set to the date of the original vulnerability scan SBOM. In addition, the
      tooling section includes the tool used to generate the original
      vulnerability scan report, if provided, and SCST - Store.

- Artifact Metadata Repository Observer (alpha). For more information, see [Artifact Metadata Repository overview](./scst-store/amr/overview.hbs.md)
  - Registers the cluster's location using user defined labels and the kube-system UID as the reference
  - Observes ImageVulnerabilityScan CustomResources from [SCST - Scan 2.0 package](scst-scan/app-scanning-beta.hbs.md)
  - Observes workload ReplicaSets. These are ReplicaSets that have a container named workload as it
    is produced by the Out of the Box Supply Chains. <!-- what does "it" refer to here? -->
  - Sends CloudEvents for observed resources to the Artifact Metadata Repository CloudEvent Handler

- Artifact Metadata Repository CloudEvent Handler (alpha). See [Artifact Metadata Repository overview](./scst-store/amr/overview.hbs.md).
  - The name Artifact Metadata Repository Persister is deprecated in favor of Artifact Metadata Repository
    CloudEvent Handler.
  - Handles ImageVulnerabilityScan configured CloudEvents from the Artifact Metadata Repository Observer.
  - Handles Location configured CloudEvents from the Artifact Metadata Repository Observer.
  - Handles ReplicaSet configured CloudEvents from the Artifact Metadata Repository Observer.

- Adds a new vulnerability triage feature allows you to store analysis
  data for vulnerabilities detected in their workloads. The vulnerability analysis
  data allows you to record the impact of a particular vulnerability,
  to discover an effective remediation plan.
  - New triage API supports the creating, updating, and searching vulnerability analysis.
    For more information, see [v1triage](scst-store/api.hbs.md#v1triage).
  - New triage subcommands for the Tanzu CLI Insight plug-in enable interaction with the triage API.
    For more information, see [Triage vulnerabilities](cli-plugins/insight/triaging-vulnerabilities.hbs.md).

#### <a id='1-6-1-tanzu-cli'></a> Tanzu CLI

- This Tanzu Application Platform release introduces the new Tanzu CLI v0.90.1.

  > **Note:** Tanzu CLI v1.0 will be published as a fast-follow to the v0.90.x line in August 2023.<br/>
  Version 1.0 of Tanzu CLI will provide backward compatibility guarantees for all CLI plugins required for TAP 1.6.1<br/>
  Customers are strongly encouraged to upgrade to Tanzu CLI v1.0 when it becomes available.

- Backward compatibility with earlier versions of Tanzu CLI plug-ins is provided.

- Install Tanzu CLI using a package manager. For more information, see
  [Install the Tanzu CLI](install-tanzu-cli.hbs.md#install-cli).

- Install plug-ins from the new centralized plug-in repository using plug-in groups. For more
  information, see [Install Tanzu CLI Plug-ins](install-tanzu-cli.hbs.md#install-plugins).

- For Internet-restricted environments, plug-ins and plug-in groups can be migrated to, and
  installed from internal registries.

- There is now central Tanzu CLI documentation where more detailed information about the CLI
  architecture, the centralized plug-in repository, plug-in groups, and Internet-restricted
  environments is available. For more information, see
  [VMware Tanzu CLI documentation](https://docs.vmware.com/en/VMware-Tanzu-CLI/index.html).

- For the comprehensive list of what's new in this release of Tanzu CLI, see the
  [VMware Tanzu CLI v0.90.x release notes](https://docs.vmware.com/en/VMware-Tanzu-CLI/0.90.0/tanzu-cli/release-notes.html).

- If you have any issues, questions, or suggestions, you can submit feedback, feature requests, or
  issue reports in the open-source [Tanzu CLI project on GitHub](https://github.com/vmware-tanzu/tanzu-cli).

#### <a id='1-6-1-tanzu-cli-plugins'></a> Tanzu CLI plug-in distribution change

- Tanzu CLI plug-ins are no longer distributed as part of the Tanzu Application Platform bundle on
  VMware Tanzu Network. The Tanzu CLI is still included in the bundle.

- The plug-ins are now installed using Tanzu CLI commands. Manual download of the plug-in binaries
  to the local file system is no longer required.

- For Internet-restricted environments, see
  [Installing the Tanzu CLI in Internet-Restricted Environments](https://docs.vmware.com/en/VMware-Tanzu-CLI/0.90.0/tanzu-cli/index.html#internet-restricted-install).

#### <a id='1-6-1-apps-cli-plugin'></a> Tanzu CLI Apps plug-in

- The apps plug-in is integrated with Local Source Proxy for seamless iterative inner-loop development
  using the Tanzu CLI or IDE plug-ins.

- The `tanzu apps workload apply` and `tanzu apps workload create` commands can now seamlessly create
  a workload from local source using only the `--local-path` flag.

- The `--source-image` flag is now optional. If `--source-image` flag is used with `--local-path`,
  the local source proxy is not used and bypassed for backward compatibility.

- A new command, `tanzu apps lsp health` is available. It allows you to verify the status of the
  Local Source Proxy. This command performs several checks, including:
  - Verifies whether the developer has Role-Based Access Control (RBAC) permissions to access the
    Local Source Proxy using their kubeconfig.
  - Checks if the Local Source Proxy is installed on the cluster.
  - Ensures that the Local Source Proxy deployment is healthy and accessible.
  - Verifies that the Local Source Proxy is correctly configured and can access the registry using the
    credentials set up by the operator during Tanzu Application Platform installation.

- Auto-completion is available for workload types. Additionally, the default workload type is set to
  `web`, making the `--type` flag optional.
  The flag is only required if the type is something other than `web`.

- The shorthand option `-e` is available as a convenient alternative for the `--export` flag.

- The `tanzu apps workload get` command is enhanced to include Git revision information in the
  overview section. This provides a quick reference to the Git revision associated with the workload.

#### <a id='1-6-1-tbs-plugin'></a> Tanzu CLI Build Service plug-in

- Adds a new Build Service plug-in that allows you to view all Tanzu Build Service resources on any
  Kubernetes cluster that has Tanzu Application Platform or Tanzu Build Service installed.
  For more information, see [Build Service CLI plug-in overview](cli-plugins/build-service/overview.hbs.md).

#### <a id='1-6-1-insight-cli-plugin'></a> Tanzu CLI Insight plug-in

- Triage vulnerabilities with the `tanzu insight triage` command. For more information, see
  [Triage vulnerabilities](cli-plugins/insight/triaging-vulnerabilities.hbs.md).

#### <a id='1-6-1-tap-dev-portal'></a> Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- Download the Software Bill of Materials (SBOM) from the Supply Chain Cartographer (SCC) plug-in.
  Obtain the SCST - Store-generated SBOM in SPDX or CycloneDX formats.

#### <a id='1-6-1-intellij-ext'></a> Tanzu Developer Tools for IntelliJ

- Added support for Local Source Proxy that eliminates the need to provide source image configuration
  for rapid iteration in the inner loop.

- You can now use Tanzu Developer Tools for IntelliJ to rapidly iterate on Spring-native applications.
  Developers can Live Update and debug spring-native applications non-natively and then deploy
  to a cluster as a native image.

- Developers can now use Tanzu Developer Tools for IntelliJ to rapidly iterate and build Gradle
  projects in their preferred IDE.

#### <a id='1-6-1-vscode-ext'></a> Tanzu Developer Tools for VS Code

- Added support for Local Source Proxy that eliminates the need to provide source image configuration
  for rapid iteration in the inner loop.

- You can now use Tanzu Developer Tools for VS Code to rapidly iterate on Spring-native applications.
  Developers can Live Update and debug spring-native applications non-natively and then deploy
  to a cluster as a native image.

- Developers can now use Tanzu Developer Tools for VS Code to rapidly iterate and build Gradle
  projects in their preferred IDE.

---

### <a id='1-6-1-breaking-changes'></a> Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-6-1-appsso-bc'></a> Application Single Sign-On (AppSSO)

- Consumes Application Single Sign-On service offerings using `ClassClaim` instead of the lower-level
  `WorkloadRegistration` or `ClientRegistration`.

- Crossplane is an installation and runtime dependency of Application Single Sign-On.

- The field `AuthServer.spec.tls.disabled` is removed. Use `AuthServer.spec.tls.deactivated` instead.

- The default for field `ClientRegistration.spec.redirectURIs` is no longer `["http://127.0.0.0:8080"]`.

#### <a id='1-6-1-cnrs-bc'></a> Cloud Native Runtimes

- The `provider` configuration option is removed in this release. For more information, see the
 [Deprecation notice](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.0/tanzu-cloud-native-runtimes/GUID-release-notes.html#deprecation-notice-13)
 in the Cloud Native Runtimes v2.0 release notes.

#### <a id='1-6-1-flux-sc-bc'></a> FluxCD Source Controller

- The format of the `status.artifact.revision` value in the `GitRepository` resource's
  status field is updated from `BRANCH/CHECKSUM` to `BRANCH@sha1:CHECKSUM`.
  For example, `main/6db88c7a7e7dec1843809b058195b68480c4c12a` is now `main@sha1:6db88c7a7e7dec1843809b058195b68480c4c12a`.

#### <a id='1-6-1-buildservice-bc'></a> Tanzu Build Service

- The full dependencies package is renamed and the installation process is modified.
  - You must remove existing full dependencies installations before installing the new version.
  - You must provide the `tap-values.yaml` file during the full dependencies package installation.

- The full dependencies package repository is tagged with the Tanzu Application Platform package
  version instead of the Tanzu Build Service package version.

- The Ubuntu Bionic stack is no longer included with the Tanzu Application Platform and the full
  dependencies package repository.

- Introduced a cluster buildpack resource to enable individually packaged dependencies and provide
  insights into installed buildpack versions.

#### <a id='1-6-1-apps-cli-plugin-bc'></a> Tanzu CLI Apps plug-in

- The deprecated command `tanzu apps workload update` is removed from the CLI.
  Use the command `tanzu apps workload apply` instead.

#### <a id='1-6-1-tap-gui-bc'></a> Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- The `allowGuestAccess` configuration option: Previously this was not needed in the configuration because
  users were permitted to log in without credentials by default. In v1.6 and later, guest users must
  be permitted explicitly.
  The recommended values files in the installation sections are updated to include this setting.
  Add the following lines to `tap-values.yaml` to enable guest access explicitly:

  ```yaml
  # Existing tap-values.yaml settings
  tap_gui:
    app_config:
      auth:
        allowGuestAccess: true  # Allows unauthenticated users to log in to your portal. If you deactivate it, configure an alternative auth provider.
  ```

---

### <a id='1-6-1-security-fixes'></a> Security fixes

This release has the following security fixes, listed by component and area.

| Package Name | Vulnerabilities Resolved |
| ------------ | ------------------------ |
| accelerator.apps.tanzu.vmware.com | <ul><li>CVE-2022-29458</li><li>CVE-2023-29491</li><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li><li>CVE-2023-31484</li><li>CVE-2023-20861</li><li>CVE-2023-20863</li><li>GHSA-3f7h-mf4q-vrm4</li></ul>|
| api-portal.tanzu.vmware.com | <ul><li>CVE-2022-29458</li><li>CVE-2023-29491</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li></ul>|
| apis.apps.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-1255</li></ul>|
| apiserver.appliveview.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li></ul>|
| app-scanning.apps.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li></ul>|
| application-configuration-service.tanzu.vmware.com | <ul><li>CVE-2023-20861</li><li>CVE-2023-20863</li></ul>|
| backend.appliveview.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li></ul>|
| buildservice.tanzu.vmware.com | <ul><li>CVE-2023-20861</li><li>CVE-2023-20863</li><li>GHSA-hw7c-3rfg-p46j</li><li>CVE-2023-1380</li><li>CVE-2023-30456</li><li>CVE-2023-31436</li><li>CVE-2023-32233</li><li>CVE-2017-13716</li><li>CVE-2018-20657</li><li>CVE-2019-1010204</li><li>CVE-2022-27943</li><li>CVE-2022-4285</li><li>CVE-2020-13844</li><li>CVE-2023-28321</li><li>CVE-2023-28322</li><li>CVE-2018-1000021</li><li>CVE-2023-2953</li><li>CVE-2023-1667</li><li>CVE-2023-2283</li><li>CVE-2013-7445</li><li>CVE-2015-8553</li><li>CVE-2016-8660</li><li>CVE-2017-0537</li><li>CVE-2017-13165</li><li>CVE-2017-13693</li><li>CVE-2018-1121</li><li>CVE-2018-12928</li><li>CVE-2018-12929</li><li>CVE-2018-12930</li><li>CVE-2018-12931</li><li>CVE-2018-17977</li><li>CVE-2019-14899</li><li>CVE-2019-15213</li><li>CVE-2019-19378</li><li>CVE-2019-19814</li><li>CVE-2020-14304</li><li>CVE-2020-35501</li><li>CVE-2021-26934</li><li>CVE-2021-3864</li><li>CVE-2021-4095</li><li>CVE-2021-4148</li><li>CVE-2022-0400</li><li>CVE-2022-0480</li><li>CVE-2022-0995</li><li>CVE-2022-1247</li><li>CVE-2022-25836</li><li>CVE-2022-2961</li><li>CVE-2022-3114</li><li>CVE-2022-3238</li><li>CVE-2022-3523</li><li>CVE-2022-36402</li><li>CVE-2022-38096</li><li>CVE-2022-38457</li><li>CVE-2022-40133</li><li>CVE-2022-41848</li><li>CVE-2022-4269</li><li>CVE-2022-44032</li><li>CVE-2022-44033</li><li>CVE-2022-44034</li><li>CVE-2022-4543</li><li>CVE-2022-45884</li><li>CVE-2022-45885</li><li>CVE-2022-45886</li><li>CVE-2022-45887</li><li>CVE-2022-45888</li><li>CVE-2022-45919</li><li>CVE-2022-48425</li><li>CVE-2023-0030</li><li>CVE-2023-0597</li><li>CVE-2023-1076</li><li>CVE-2023-1077</li><li>CVE-2023-1079</li><li>CVE-2023-1192</li><li>CVE-2023-1193</li><li>CVE-2023-1194</li><li>CVE-2023-1611</li><li>CVE-2023-1670</li><li>CVE-2023-1855</li><li>CVE-2023-1859</li><li>CVE-2023-1989</li><li>CVE-2023-1990</li><li>CVE-2023-1998</li><li>CVE-2023-2002</li><li>CVE-2023-2007</li><li>CVE-2023-2124</li><li>CVE-2023-2156</li><li>CVE-2023-2194</li><li>CVE-2023-2235</li><li>CVE-2023-2269</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-23004</li><li>CVE-2023-25012</li><li>CVE-2023-2612</li><li>CVE-2023-26242</li><li>CVE-2023-28327</li><li>CVE-2023-28466</li><li>CVE-2023-30772</li><li>CVE-2023-32250</li><li>CVE-2023-32254</li><li>CVE-2023-33203</li><li>CVE-2023-33288</li><li>CVE-2018-6952</li><li>CVE-2021-45261</li><li>GHSA-2qjp-425j-52j9</li><li>GHSA-m5m3-46gj-wch8</li><li>CVE-2021-29425</li><li>GHSA-gwrp-pvrq-jmwv</li><li>CVE-2022-36033</li><li>GHSA-gp7f-rwcx-9369</li></ul>|
| cnrs.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li></ul>|
| connector.appliveview.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li></ul>|
| controller.source.apps.tanzu.vmware.com | <ul><li>CVE-2023-1255</li><li>CVE-2023-2650</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>GHSA-hw7c-3rfg-p46j</li></ul>|
| conventions.appliveview.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li></ul>|
| developer-conventions.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li></ul>|
| fluxcd.source.controller.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>GHSA-259w-8hf6-59c2</li><li>GHSA-hmfx-3pcx-653p</li><li>GHSA-2qjp-425j-52j9</li><li>GHSA-53c4-hhmh-vw5q</li><li>GHSA-67fx-wx78-jx33</li><li>GHSA-6rx9-889q-vv2r</li><li>GHSA-pwcw-6f5g-gxf8</li><li>GHSA-7hfp-qfw3-5jxh</li></ul>|
| learningcenter.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2022-3821</li><li>CVE-2022-4415</li><li>CVE-2022-36033</li><li>GHSA-gp7f-rwcx-9369</li><li>CVE-2023-25690</li><li>CVE-2023-27522</li><li>CVE-2023-23914</li><li>CVE-2023-23915</li><li>CVE-2023-23916</li><li>CVE-2023-27533</li><li>CVE-2023-27534</li><li>CVE-2023-27535</li><li>CVE-2023-27536</li><li>CVE-2023-27538</li><li>CVE-2023-25652</li><li>CVE-2023-25815</li><li>CVE-2023-29007</li><li>CVE-2022-23649</li><li>CVE-2022-36056</li><li>GHSA-8gw7-4j42-w388</li><li>GHSA-ccxc-vr6p-4858</li><li>GHSA-3633-5h82-39pq</li><li>CVE-2023-21830</li><li>CVE-2023-21835</li><li>CVE-2023-21843</li><li>CVE-2022-24963</li><li>CVE-2023-2004</li><li>CVE-2023-0361</li><li>CVE-2023-0795</li><li>CVE-2023-0796</li><li>CVE-2023-0797</li><li>CVE-2023-0798</li><li>CVE-2023-0799</li><li>CVE-2023-0800</li><li>CVE-2023-0801</li><li>CVE-2023-0802</li><li>CVE-2023-0803</li><li>CVE-2023-0804</li><li>CVE-2023-28484</li><li>CVE-2023-29469</li><li>CVE-2022-2196</li><li>CVE-2022-3169</li><li>CVE-2022-3344</li><li>CVE-2022-3424</li><li>CVE-2022-3435</li><li>CVE-2022-3521</li><li>CVE-2022-3545</li><li>CVE-2022-36280</li><li>CVE-2022-41218</li><li>CVE-2022-4129</li><li>CVE-2022-4139</li><li>CVE-2022-42328</li><li>CVE-2022-42329</li><li>CVE-2022-4379</li><li>CVE-2022-4382</li><li>CVE-2022-45869</li><li>CVE-2022-47518</li><li>CVE-2022-47519</li><li>CVE-2022-47520</li><li>CVE-2022-47521</li><li>CVE-2022-47929</li><li>CVE-2022-4842</li><li>CVE-2022-48423</li><li>CVE-2022-48424</li><li>CVE-2023-0045</li><li>CVE-2023-0210</li><li>CVE-2023-0266</li><li>CVE-2023-0394</li><li>CVE-2023-0458</li><li>CVE-2023-1073</li><li>CVE-2023-1074</li><li>CVE-2023-1195</li><li>CVE-2023-1382</li><li>CVE-2023-1652</li><li>CVE-2023-1872</li><li>CVE-2023-2006</li><li>CVE-2023-21102</li><li>CVE-2023-2166</li><li>CVE-2023-23454</li><li>CVE-2023-23455</li><li>CVE-2023-23559</li><li>CVE-2023-26544</li><li>CVE-2023-26545</li><li>CVE-2023-26605</li><li>CVE-2023-26606</li><li>CVE-2023-26607</li><li>CVE-2023-28328</li><li>CVE-2023-23918</li><li>CVE-2022-40898</li><li>GHSA-hhqj-cfjx-vj25</li><li>CVE-2023-27320</li><li>CVE-2023-28486</li><li>CVE-2023-28487</li><li>CVE-2022-48303</li><li>CVE-2022-0213</li><li>CVE-2022-0261</li><li>CVE-2022-0318</li><li>CVE-2022-0319</li><li>CVE-2022-0351</li><li>CVE-2022-0359</li><li>CVE-2022-0361</li><li>CVE-2022-0368</li><li>CVE-2022-0408</li><li>CVE-2022-0413</li><li>CVE-2022-0443</li><li>CVE-2022-0554</li><li>CVE-2022-0572</li><li>CVE-2022-0629</li><li>CVE-2022-0685</li><li>CVE-2022-0714</li><li>CVE-2022-0729</li><li>CVE-2022-1629</li><li>CVE-2022-1674</li><li>CVE-2022-1720</li><li>CVE-2022-1733</li><li>CVE-2022-1735</li><li>CVE-2022-1785</li><li>CVE-2022-1796</li><li>CVE-2022-1851</li><li>CVE-2022-1898</li><li>CVE-2022-1927</li><li>CVE-2022-1942</li><li>CVE-2022-1968</li><li>CVE-2022-2124</li><li>CVE-2022-2125</li><li>CVE-2022-2126</li><li>CVE-2022-2129</li><li>CVE-2022-2175</li><li>CVE-2022-2183</li><li>CVE-2022-2206</li><li>CVE-2022-2207</li><li>CVE-2022-2304</li><li>CVE-2022-2344</li><li>CVE-2022-2345</li><li>CVE-2022-2571</li><li>CVE-2022-2581</li><li>CVE-2022-2845</li><li>CVE-2022-2849</li><li>CVE-2022-2923</li><li>CVE-2022-2946</li><li>CVE-2022-2980</li><li>CVE-2022-47024</li><li>CVE-2023-0049</li><li>CVE-2023-0051</li><li>CVE-2023-0054</li><li>CVE-2023-0288</li><li>CVE-2023-0433</li><li>CVE-2023-1170</li><li>CVE-2023-1175</li><li>CVE-2023-1264</li></ul>|
| metadata-store.apps.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2022-3821</li><li>CVE-2022-4415</li><li>CVE-2023-28484</li><li>CVE-2023-29469</li><li>CVE-2023-2454</li><li>CVE-2023-2455</li><li>CVE-2019-17594</li><li>CVE-2019-17595</li><li>CVE-2021-39537</li></ul>|
| ootb-templates.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>GHSA-g2j6-57v7-gm8c</li><li>GHSA-m8cg-xc2p-r3fc</li><li>GHSA-hw7c-3rfg-p46j</li><li>CVE-2023-27533</li><li>CVE-2023-27534</li><li>CVE-2023-27535</li><li>CVE-2023-27536</li><li>CVE-2023-27538</li><li>CVE-2022-2196</li><li>CVE-2022-3424</li><li>CVE-2022-36280</li><li>CVE-2022-41218</li><li>CVE-2022-4129</li><li>CVE-2022-4382</li><li>CVE-2022-47929</li><li>CVE-2022-4842</li><li>CVE-2022-48423</li><li>CVE-2022-48424</li><li>CVE-2023-0045</li><li>CVE-2023-0210</li><li>CVE-2023-0266</li><li>CVE-2023-0394</li><li>CVE-2023-0458</li><li>CVE-2023-1073</li><li>CVE-2023-1074</li><li>CVE-2023-1652</li><li>CVE-2023-1872</li><li>CVE-2023-21102</li><li>CVE-2023-23454</li><li>CVE-2023-23455</li><li>CVE-2023-23559</li><li>CVE-2023-26544</li><li>CVE-2023-26545</li><li>CVE-2023-26606</li><li>CVE-2023-28328</li><li>CVE-2023-0386</li><li>CVE-2023-1281</li><li>CVE-2023-1829</li></ul>|
| scanning.apps.tanzu.vmware.com | <ul><li>CVE-2023-1255</li><li>CVE-2023-2650</li></ul>|
| services-toolkit.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li><li>CVE-2023-27484</li><li>GHSA-v829-x6hh-cqfq</li><li>GHSA-vfvj-3m3g-m532</li></ul>|
| sso.apps.tanzu.vmware.com | <ul><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li><li>CVE-2023-20861</li><li>CVE-2023-20863</li><li>GHSA-f3fp-gc8g-vw66</li><li>GHSA-g2j6-57v7-gm8c</li><li>GHSA-m8cg-xc2p-r3fc</li><li>CVE-2022-3821</li></ul>|
| tap-gui.tanzu.vmware.com | <ul><li>GHSA-p5gc-c584-jj6v</li><li>GHSA-7hv8-3fr9-j2hv</li><li>GHSA-6w63-h3fj-q4vw</li><li>GHSA-jv3g-j58f-9mq9</li><li>GHSA-8cf7-32gw-wr33</li><li>GHSA-hjrf-2m68-5959</li><li>GHSA-qwph-4952-7xr6</li><li>GHSA-x77j-w7wf-fjmw</li></ul>|
| workshops.learningcenter.tanzu.vmware.com | <ul><li>CVE-2022-3715</li><li>CVE-2016-20013</li><li>CVE-2023-2602</li><li>CVE-2023-2603</li><li>CVE-2022-29458</li><li>CVE-2023-29491</li><li>CVE-2022-3996</li><li>CVE-2023-0464</li><li>CVE-2023-1255</li><li>CVE-2023-2650</li><li>CVE-2022-4899</li><li>CVE-2023-31484</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>GHSA-259w-8hf6-59c2</li><li>GHSA-hmfx-3pcx-653p</li><li>GHSA-f3fp-gc8g-vw66</li><li>GHSA-g2j6-57v7-gm8c</li><li>GHSA-m8cg-xc2p-r3fc</li><li>GHSA-v95c-p5hm-xq8f</li><li>CVE-2022-3821</li><li>CVE-2022-4415</li><li>CVE-2017-13716</li><li>CVE-2018-20657</li><li>CVE-2019-1010204</li><li>CVE-2022-27943</li><li>CVE-2022-4285</li><li>CVE-2020-13844</li><li>CVE-2023-28321</li><li>CVE-2023-28322</li><li>CVE-2018-1000021</li><li>CVE-2023-2953</li><li>CVE-2023-1667</li><li>CVE-2023-2283</li><li>CVE-2013-7445</li><li>CVE-2015-8553</li><li>CVE-2016-8660</li><li>CVE-2017-0537</li><li>CVE-2017-13165</li><li>CVE-2017-13693</li><li>CVE-2018-1121</li><li>CVE-2018-12928</li><li>CVE-2018-12929</li><li>CVE-2018-12930</li><li>CVE-2018-12931</li><li>CVE-2018-17977</li><li>CVE-2019-14899</li><li>CVE-2019-15213</li><li>CVE-2019-19378</li><li>CVE-2019-19814</li><li>CVE-2020-14304</li><li>CVE-2020-35501</li><li>CVE-2021-26934</li><li>CVE-2021-3864</li><li>CVE-2021-4095</li><li>CVE-2021-4148</li><li>CVE-2022-0400</li><li>CVE-2022-0480</li><li>CVE-2022-0995</li><li>CVE-2022-1247</li><li>CVE-2022-25836</li><li>CVE-2022-2961</li><li>CVE-2022-3114</li><li>CVE-2022-3238</li><li>CVE-2022-3523</li><li>CVE-2022-36402</li><li>CVE-2022-38096</li><li>CVE-2022-38457</li><li>CVE-2022-40133</li><li>CVE-2022-41848</li><li>CVE-2022-4269</li><li>CVE-2022-44032</li><li>CVE-2022-44033</li><li>CVE-2022-44034</li><li>CVE-2022-4543</li><li>CVE-2022-45884</li><li>CVE-2022-45885</li><li>CVE-2022-45886</li><li>CVE-2022-45887</li><li>CVE-2022-45888</li><li>CVE-2022-45919</li><li>CVE-2022-48425</li><li>CVE-2023-0030</li><li>CVE-2023-0597</li><li>CVE-2023-1076</li><li>CVE-2023-1077</li><li>CVE-2023-1079</li><li>CVE-2023-1192</li><li>CVE-2023-1193</li><li>CVE-2023-1194</li><li>CVE-2023-1611</li><li>CVE-2023-1670</li><li>CVE-2023-1855</li><li>CVE-2023-1859</li><li>CVE-2023-1989</li><li>CVE-2023-1990</li><li>CVE-2023-1998</li><li>CVE-2023-2002</li><li>CVE-2023-2007</li><li>CVE-2023-2124</li><li>CVE-2023-2156</li><li>CVE-2023-2194</li><li>CVE-2023-2235</li><li>CVE-2023-2269</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-23004</li><li>CVE-2023-25012</li><li>CVE-2023-2612</li><li>CVE-2023-26242</li><li>CVE-2023-28327</li><li>CVE-2023-28466</li><li>CVE-2023-30772</li><li>CVE-2023-32250</li><li>CVE-2023-32254</li><li>CVE-2023-33203</li><li>CVE-2023-33288</li><li>CVE-2018-6952</li><li>CVE-2021-45261</li><li>GHSA-2qjp-425j-52j9</li><li>GHSA-p782-xgp4-8hr8</li><li>CVE-2022-36033</li><li>GHSA-gp7f-rwcx-9369</li><li>CVE-2023-25690</li><li>CVE-2023-27522</li><li>CVE-2016-1585</li><li>CVE-2023-1972</li><li>CVE-2023-25584</li><li>CVE-2023-25585</li><li>CVE-2023-25588</li><li>CVE-2009-3720</li><li>CVE-2012-0876</li><li>CVE-2012-1148</li><li>CVE-2015-1283</li><li>CVE-2016-0718</li><li>CVE-2016-4472</li><li>CVE-2023-23914</li><li>CVE-2023-23915</li><li>CVE-2023-23916</li><li>CVE-2023-27533</li><li>CVE-2023-27534</li><li>CVE-2023-27535</li><li>CVE-2023-27536</li><li>CVE-2023-27538</li><li>CVE-2023-34969</li><li>CVE-2013-1779</li><li>CVE-2023-25652</li><li>CVE-2023-25815</li><li>CVE-2023-29007</li><li>GHSA-5ffw-gxpp-mxpf</li><li>GHSA-5j5w-g665-5m35</li><li>GHSA-c2h3-6mxw-7mvq</li><li>GHSA-qq97-vm5h-rrhg</li><li>CVE-2018-20699</li><li>CVE-2020-13401</li><li>GHSA-gc89-7gcr-jxqc</li><li>GHSA-77vh-xpmg-72qh</li><li>CVE-2022-23649</li><li>CVE-2022-36056</li><li>GHSA-8gw7-4j42-w388</li><li>GHSA-3633-5h82-39pq</li><li>GHSA-h86h-8ppg-mxmh</li><li>GHSA-wxc4-f4m6-wwqv</li><li>CVE-2023-21830</li><li>CVE-2023-21835</li><li>CVE-2023-21843</li><li>CVE-2007-2379</li><li>CVE-2022-24963</li><li>CVE-2023-2004</li><li>CVE-2021-40812</li><li>CVE-2023-24593</li><li>CVE-2023-25180</li><li>CVE-2023-29499</li><li>CVE-2023-32611</li><li>CVE-2023-32636</li><li>CVE-2023-32643</li><li>CVE-2023-32665</li><li>CVE-2023-0361</li><li>CVE-2022-3857</li><li>CVE-2023-27043</li><li>CVE-2022-46908</li><li>CVE-2018-10126</li><li>CVE-2022-48281</li><li>CVE-2023-0795</li><li>CVE-2023-0796</li><li>CVE-2023-0797</li><li>CVE-2023-0798</li><li>CVE-2023-0799</li><li>CVE-2023-0800</li><li>CVE-2023-0801</li><li>CVE-2023-0802</li><li>CVE-2023-0803</li><li>CVE-2023-0804</li><li>CVE-2023-1999</li><li>CVE-2023-28484</li><li>CVE-2023-29469</li><li>CVE-2022-2196</li><li>CVE-2022-27672</li><li>CVE-2022-3169</li><li>CVE-2022-3344</li><li>CVE-2022-3424</li><li>CVE-2022-3435</li><li>CVE-2022-3521</li><li>CVE-2022-3545</li><li>CVE-2022-36280</li><li>CVE-2022-3707</li><li>CVE-2022-41218</li><li>CVE-2022-4129</li><li>CVE-2022-4139</li><li>CVE-2022-42328</li><li>CVE-2022-42329</li><li>CVE-2022-4379</li><li>CVE-2022-4382</li><li>CVE-2022-45869</li><li>CVE-2022-47518</li><li>CVE-2022-47519</li><li>CVE-2022-47520</li><li>CVE-2022-47521</li><li>CVE-2022-47929</li><li>CVE-2022-4842</li><li>CVE-2022-48423</li><li>CVE-2022-48424</li><li>CVE-2023-0045</li><li>CVE-2023-0210</li><li>CVE-2023-0266</li><li>CVE-2023-0394</li><li>CVE-2023-0458</li><li>CVE-2023-0459</li><li>CVE-2023-1073</li><li>CVE-2023-1074</li><li>CVE-2023-1075</li><li>CVE-2023-1078</li><li>CVE-2023-1118</li><li>CVE-2023-1195</li><li>CVE-2023-1382</li><li>CVE-2023-1513</li><li>CVE-2023-1652</li><li>CVE-2023-1872</li><li>CVE-2023-2006</li><li>CVE-2023-20938</li><li>CVE-2023-21102</li><li>CVE-2023-2162</li><li>CVE-2023-2166</li><li>CVE-2023-23454</li><li>CVE-2023-23455</li><li>CVE-2023-23559</li><li>CVE-2023-26544</li><li>CVE-2023-26545</li><li>CVE-2023-26605</li><li>CVE-2023-26606</li><li>CVE-2023-26607</li><li>CVE-2023-28328</li><li>CVE-2023-32269</li><li>GHSA-45rm-2893-5f49</li><li>CVE-2004-2761</li><li>CVE-2023-23918</li><li>CVE-2023-23920</li><li>CVE-2023-23936</li><li>CVE-2019-1563</li><li>CVE-2021-23840</li><li>CVE-2021-3712</li><li>CVE-2022-1292</li><li>CVE-2022-2068</li><li>CVE-2022-2097</li><li>CVE-2022-32212</li><li>CVE-2022-32213</li><li>CVE-2022-32214</li><li>CVE-2022-32215</li><li>CVE-2022-40735</li><li>CVE-2022-4203</li><li>CVE-2022-4304</li><li>CVE-2022-4450</li><li>CVE-2023-0215</li><li>CVE-2023-0216</li><li>CVE-2023-0217</li><li>CVE-2023-0401</li><li>CVE-2020-14145</li><li>CVE-2023-28531</li><li>CVE-2022-40898</li><li>CVE-2020-17753</li><li>GHSA-hhqj-cfjx-vj25</li><li>CVE-2023-27320</li><li>CVE-2023-28486</li><li>CVE-2023-28487</li><li>CVE-2020-36634</li><li>CVE-2022-0128</li><li>CVE-2022-0156</li><li>CVE-2022-0158</li><li>CVE-2022-0213</li><li>CVE-2022-0261</li><li>CVE-2022-0318</li><li>CVE-2022-0319</li><li>CVE-2022-0351</li><li>CVE-2022-0359</li><li>CVE-2022-0361</li><li>CVE-2022-0368</li><li>CVE-2022-0393</li><li>CVE-2022-0407</li><li>CVE-2022-0408</li><li>CVE-2022-0413</li><li>CVE-2022-0443</li><li>CVE-2022-0554</li><li>CVE-2022-0572</li><li>CVE-2022-0629</li><li>CVE-2022-0685</li><li>CVE-2022-0696</li><li>CVE-2022-0714</li><li>CVE-2022-0729</li><li>CVE-2022-1629</li><li>CVE-2022-1674</li><li>CVE-2022-1720</li><li>CVE-2022-1733</li><li>CVE-2022-1735</li><li>CVE-2022-1785</li><li>CVE-2022-1796</li><li>CVE-2022-1851</li><li>CVE-2022-1886</li><li>CVE-2022-1898</li><li>CVE-2022-1927</li><li>CVE-2022-1942</li><li>CVE-2022-1968</li><li>CVE-2022-2124</li><li>CVE-2022-2125</li><li>CVE-2022-2126</li><li>CVE-2022-2129</li><li>CVE-2022-2175</li><li>CVE-2022-2182</li><li>CVE-2022-2183</li><li>CVE-2022-2206</li><li>CVE-2022-2207</li><li>CVE-2022-2304</li><li>CVE-2022-2343</li><li>CVE-2022-2344</li><li>CVE-2022-2345</li><li>CVE-2022-2571</li><li>CVE-2022-2581</li><li>CVE-2022-2845</li><li>CVE-2022-2849</li><li>CVE-2022-2862</li><li>CVE-2022-2889</li><li>CVE-2022-2923</li><li>CVE-2022-2946</li><li>CVE-2022-2980</li><li>CVE-2022-2982</li><li>CVE-2022-47024</li><li>CVE-2023-0049</li><li>CVE-2023-0051</li><li>CVE-2023-0054</li><li>CVE-2023-0288</li><li>CVE-2023-0433</li><li>CVE-2023-1170</li><li>CVE-2023-1175</li><li>CVE-2023-1264</li><li>CVE-2023-2426</li><li>CVE-2023-2609</li><li>CVE-2023-2610</li><li>GHSA-p5gc-c584-jj6v</li></ul>|

### <a id='1-6-1-resolved-issues'></a> Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-6-1-cnrs-ri'></a> Cloud Native Runtimes

- New toggle feature for how to make ConfigMap updates. For some ConfigMaps in Cloud Native Runtimes,
  such as config-features, the option to update using an overlay was not taking effect.
  This issue is fixed.

  With this version, the legacy behavior remains the same, but VMware introduced
  a configuration to opt-in into updating ConfigMaps using overlays in Cloud Native Runtimes.
  To configure this option, edit your `cnr-values.yaml` file to change the following configuration:

    ```yaml
    allow_manual_configmap_update: false
    ```

#### <a id='1-6-1-crossplane-ri'></a> Crossplane

- The Crossplane package now more gracefully handles situations in which Crossplane is already
  installed to a cluster by using another method, for example, Helm install.

  Previously the Crossplane Package assumed that Crossplane was not already installed on the cluster,
  which is not always true.
  Rather than fail, the package completed installing, which caused non-deterministic behavior.

  Now, if you attempt to install or upgrade the Crossplane package on a cluster that has
  Crossplane installed by other means, it fails with the error `Resource already exists`.
  In such cases, you can either exclude the Crossplane package from the Tanzu Application Platform
  installation, or set `adopt_resources` to true in the Crossplane package to adopt resources from
  your existing installation.
  For more information, see [Use your existing Crossplane installation](crossplane/how-to-guides/use-existing-crossplane.hbs.md).

- Resolved an issue where Crossplane Providers did not transition to `HEALTHY=True` if using a custom
  certificate for your registry.
  This prevented the class claims used for dynamic provisioning from reconciling.
  The Crossplane Package now inherits the data configured in `shared.ca_cert_data` of `tap-values.yaml`.

#### <a id='1-6-1-namespace-provisioner-ri'></a> Namespace Provisioner

- Resolved an issue that prevented updates to the AWS Identity and Access Management (IAM) role
  from reflecting in the service accounts used by Supply Chains and Delivery components.

- Resolved a behavior where the Namespace Provisioner failed if the same Git secret was used multiple
  times within the `additional_sources` section of the `tap-values.yaml` file.
  This fix requires Cluster Essentials v1.6 or later installed on the cluster.

- Resolved an issue where a namespace managed by the Namespace Provisioner became stuck in the
  `Terminating` phase during deletion if it contained a workload.
  This fix requires Cluster Essentials v1.6 or later installed on the cluster.

#### <a id='1-6-1-stk-ri'></a> Services Toolkit

- Resolved an issue that prevented the default cluster-admin IAM role on Google Kubernetes Engine (GKE)
  clusters from claiming any of the Bitnami services.

  Previously, if a user with the cluster-admin role on a GKE cluster attempted to claim any of the
  Bitnami services, they received a validation error.

- Resolved an issue affecting the dynamic provisioning flow if you used a CompositeResourceDefinition
  that specified a schema that defined `.status` without also defining `.spec`.
  You can now use a CompositeResourceDefinition which only specifies `.status` in the schema.

  Previously, if you attempted to create a ClassClaim for a ClusterInstanceClass that referred to
  such a CompositeResourceDefinition, the ClassClaim did not transition into `Ready=True` and
  instead reported `unexpected end of JSON input`.

#### <a id='1-6-1-scst-store-ri'></a> Supply Chain Security Tools (SCST) - Store

- Implemented basic logging in the AMR database.

- AMR database no longer creates a load balancer when enabling the shared ingress domain and ingress
  values in `tap-values.yaml`.

- Modified the behavior of the `/v1/artifact-groups/vulnerabilities/_search` endpoint.
  It now returns a list of artifact groups affected by the vulnerability even if the images or sources
  in the query are not linked to them.

  Previously the endpoint returned the list of artifact groups the images or sources were linked to,
  even if the artifact group was not affected by the vulnerability.

#### <a id='1-6-1-apps-cli-plugin-ri'></a> Tanzu CLI Apps plug-in

- Implemented validations to prevent the inclusion of multiple sources through flags in the
  `workload create` and `workload apply` commands.

- Modified the behavior of the commands when waiting to apply workload changes. If the workload was
  previously in a failed state, it no longer immediately fails. When the `--wait` flag is used, the
  command continues to wait until the workload either succeeds or fails again. When the `--tail`
  flag is used, the command continues tailing logs from the Supply chain steps that were impacted by
  the workload update.

#### <a id='1-6-1-intellij-plugin-ri'></a> Tanzu Developer Tools for IntelliJ

- The `apply` action no longer stores the workload file path, which prevented modifying the workload
  file path later. Now this information is either computed or obtained by prompting the user as needed.

- In the Tanzu Activity Panel, the `config-writer-pull-requester` of the type `Runnable` is no longer
  incorrectly categorized as **Unknown**.


#### <a id='1-6-1-vscode-plugin-ri'></a> Tanzu Developer Tools for VS Code

- Errors in the kubeconfig file `~/.kube/config` that are not related to the current context are now
  ignored, allowing you to work with Tanzu panel without any issues.

---

### <a id='1-6-1-known-issues'></a> Known issues

This release has the following known issues, listed by component and area.

> **Note** Starting in this release, the release notes list known issues in each release until
> they are resolved.

#### <a id='1-6-1-amr-obs-ce-hndlr-ki'></a> Artifact Metadata Repository Observer and CloudEvent Handler

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of
  ImageVulnerabilityScan results. There is an error on duplicate submission of identical ImageVulnerabilityScans you can ignore if the previous submission was successful.

- ReplicaSet status in AMR only has two states: `created` and `deleted`.
  There is a known issue where the `available` and `unavailable` state is not showing.
  The workaround is that you can interpolate this information from the `instances` metadata in the
  AMR for the ReplicaSet.

#### <a id='1-6-1-bitnami-services-ki'></a> Bitnami Services

- If you try to configure private registry integration for the Bitnami services
  after having already created a claim for one or more of the Bitnami services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshoot Bitnami Services](bitnami-services/how-to-guides/troubleshooting.hbs.md#private-reg).

#### <a id='1-6-1-cnrs-ki'></a> Cloud Native Runtimes

- For Knative Serving, certain app name, namespace, and domain combinations produce Knative Services
  with status `CertificateNotReady`. For more information, see
  [Troubleshooting](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.3/tanzu-cloud-native-runtimes/troubleshooting.html#certificate-not-ready-kcert).

#### <a id='1-6-1-crossplane-ki'></a> Crossplane

- Crossplane Providers cannot communicate with systems using a custom CA.
  For more information and a workaround, see [Troubleshoot Crossplane](./crossplane/how-to-guides/troubleshooting.hbs.md#cp-custom-cert-inject).

- The Crossplane `validatingwebhookconfiguration` is not removed when you uninstall the
  Crossplane Package.
  To workaround, delete the `validatingwebhookconfiguration` manually by running
  `kubectl delete validatingwebhookconfiguration crossplane`.

#### <a id='1-6-1-eventing-ki'></a> Eventing

- When using vSphere sources in Eventing, the vsphere-source is using a high number of
  informers to alleviate load on the API server. This causes high memory use.

#### <a id="1-6-1-grype-scan-ki"></a> Grype scanner

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

#### <a id='1-6-1-stk-ki'></a> Services Toolkit

- An error occurs if `additionalProperties` is `true` in a CompositeResourceDefinition.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#compositeresourcedef).

#### <a id='1-6-1-scc-ki'></a> Supply Chain Choreographer

- When using the Carvel Package Supply Chains, if the operator updates the parameter
  `carvel_package.name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps
  repository that uses the old value of `carvel_package.name_suffix`. You can ignore or delete this package.

- If the size of the resulting OpenAPIv3 specification exceeds a certain size, approximately 3&nbsp;KB,
  the Supply Chain does not function. If you use the default Carvel package parameters, you this
  issue does not occur. If you use custom Carvel package parameters, you might encounter this size limit.
  If you exceed the size limit, you can either deactivate this feature, or use a workaround.
  The workaround requires enabling a Tekton feature flag. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/additional-configs/#enabling-larger-results-using-sidecar-logs).

- The ClusterSupplyChain `scanning-image-scan-to-url` does not update if you attempt to update the
  `ootb_supply_chain_testing_scanning` field in the `tap-values.yaml` file to use a specified
  ClusterImageTemplate as follows:

    ```
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: CLUSTERIMAGETEMPLATE
    ```

    This is because the ClusterSupplyChain is preset to `image-scanner-template`.
    To workaround, edit the Out of the Box Supply template following the steps
    [Modifying an Out of the Box Supply template](./scc/authoring-supply-chains.hbs.md#modify-ootb-sc).

#### <a id='1-6-1-tap-gui-ki'></a> Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Developer Portal.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

#### <a id='1-6-1-sc-plugin-ki'></a> Tanzu Developer Portal - Supply Chain GUI plug-in

- Any workloads created by using a CRD might not work as expected.
  Only Out of the Box (OOTB) Supply Chains are supported in the GUI.

- [Supply Chain Security Tools - Scan v2.0](scst-scan/app-scanning-beta.hbs.md), which introduces the
  `ImageVulnerabilityScanner` CRD, is not currently supported in the Supply Chain GUI.

- Downloading the SBOM from a vulnerability scan requires additional configuration in
  `tap-values.yaml`. For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#sbom-not-working).

#### <a id='1-6-1-intellij-plugin-ki'></a> Tanzu Developer Tools for IntelliJ

- The error `com.vdurmont.semver4j.SemverException: Invalid version (no major version)` is shown in
  the error logs when attempting to perform a workload action before installing the Tanzu CLI apps
  plug-in.

- If you restart your computer while running Live Update without terminating the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again.
  For the fix, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#lock-prevents-live-update).

- Workload actions and Live Update do not work when in a project with spaces in its name, such as
  `my app`, or in its path, such as `C:\Users\My User\my-app`.
  For more information, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#projects-with-spaces).

- An **EDT Thread Exception** error is logged or reported as a notification with a message similar to
  `"com.intellij.diagnostic.PluginException: 2007 ms to call on EDT TanzuApplyAction#update@ProjectViewPopup"`.
  For more information, see
  [Troubleshooting](intellij-extension/troubleshooting.hbs.md#ui-liveness-check-error).

#### <a id='1-5-0-vs-plugin-ki'></a> Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

#### <a id='1-6-1-vscode-plugin-ki'></a> Tanzu Developer Tools for VS Code

- In the Tanzu Activity Panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

- Tanzu Debug does not work on Windows for new workloads. When attempting to Tanzu Debug on Windows,
  the user sees an error message similar to the following:

    ```console
    Error: unable to check if filepath "'FILE-PATH'" is a valid url.
    ```

    For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#windows-quotes-error).

---

### <a id="1-6-components"></a> Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                                   | Version |
| ---------------------------------------------------------------- | ------- |
| API Auto Registration                                            |         |
| API portal                                                       |         |
| API Scoring and Validation                                       |         |
| Application Accelerator                                          |         |
| Application Configuration Service                                |         |
| Application Live View                                            |         |
| Application Single Sign-On                                       |         |
| Authentication and authorization                                 |         |
| Bitnami Services                                                 | 0.2.0   |
| Cartographer Conventions                                         |         |
| cert-manager                                                     |         |
| Cloud Native Runtimes                                            |         |
| Contour                                                          |         |
| Crossplane                                                       | 0.2.1   |
| Developer Conventions                                            |         |
| Eventing                                                         | 2.2.3   |
| FluxCD Source Controller                                         |         |
| Learning Center                                                  |         |
| Local Source Proxy                                               | 0.1.0   |
| Namespace Provisioner                                            | 0.4.0   |
| Out of the Box Delivery - Basic                                  | 0.13.6  |
| Out of the Box Supply Chain - Basic                              | 0.13.6  |
| Out of the Box Supply Chain - Testing                            | 0.13.6  |
| Out of the Box Supply Chain - Testing and Scanning               | 0.13.6  |
| Out of the Box Templates                                         | 0.13.6  |
| Service Bindings                                                 | 0.9.1   |
| Services Toolkit                                                 | 0.11.0  |
| Source Controller                                                |         |
| Spring Boot conventions                                          |         |
| Spring Cloud Gateway                                             |         |
| Supply Chain Choreographer                                       | 0.7.3   |
| Supply Chain Security Tools - Policy Controller                  |         |
| Supply Chain Security Tools - Scan                               |         |
| Supply Chain Security Tools - Sign (deprecated)                  |         |
| Supply Chain Security Tools - Store                              |         |
| Tanzu Developer Portal (formerly Tanzu Application Platform GUI) |         |
| Tanzu Application Platform Telemetry                             |         |
| Tanzu Build Service                                              |         |
| Tanzu CLI plug-in                                                |         |
| Tanzu Developer Tools for IntelliJ                               |         |
| Tanzu Developer Tools for Visual Studio                          |         |
| Tanzu Developer Tools for VS Code                                |         |
| Tanzu Service CLI plug-in                                        | 0.7.0   |
| Tekton Pipelines                                                 |         |

---

## <a id="1-6-deprecations"></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

### <a id="1-6-alv-deprecations"></a> Application Live View

- `appliveview_connnector.backend.sslDisabled` is deprecated and marked for removal in
  Tanzu Application Platform v1.7.0.
  For more information about the migration, see [Deprecate the sslDisabled key](app-live-view/install.hbs.md#deprecate-the-ssldisabled-key).

### <a id='1-6-app-sso-deprecations'></a> Application Single Sign-On (AppSSO)

- `ClientRegistration` resource `clientAuthenticationMethod` field values
  `post` and `basic` are deprecated and marked for removal in Tanzu Application
  Platform v1.7.0. Use `client_secret_post` and `client_secret_basic` instead.

### <a id="1-6-flux-sc-deprecations"></a> FluxCD Source Controller

- Deprecations for the `GitRepository` API:

    - `spec.gitImplementation` is deprecated.
    `GitImplementation` defines the Git client library implementation.
    `go-git` is the default and only supported implementation. `libgit2`
    is no longer supported.
    - `spec.accessFrom` is deprecated. `AccessFrom`, which defines an Access
    Control List for enabling cross-namespace references to this object, was never
    implemented.
    - `status.contentConfigChecksum` is deprecated in favor of the explicit fields
    defined in the observed artifact content config within the status.
    - `status.artifact.checksum` is deprecated in favor of `status.artifact.digest`.
    - `status.url` is deprecated in favor of `status.artifact.url`.

- Deprecations for the `OCIRepository` API:

    - `status.contentConfigChecksum` is deprecated in favor of the explicit fields
    defined in the observed artifact content config within the status.

### <a id="1-6-stk-deprecations"></a> Services Toolkit

- The `tanzu services claims` CLI plug-in command is now deprecated. It is
  hidden from help text output, but continues to work until officially removed
  after the deprecation period. The new `tanzu services resource-claims` command
  provides the same function.

### <a id="1-6-sc-deprecations"></a> Source Controller

- The Source Controller `ImageRepository` API is deprecated and is marked for
  removal in Tanzu Application Platform v1.9. Use the `OCIRepository` API instead.
  The Flux Source Controller installation includes the `OCIRepository` API.
  For more information about the `OCIRepository` API, see the
  [Flux documentation](https://fluxcd.io/flux/components/source/ocirepositories/).

### <a id='1-6-scc-deprecations'></a> Supply Chain Choreographer

- Supply Chain Choreographer no longer uses the `git_implementation` field. The `go-git` implementation
  now assumes that `libgit2` is not supported.
    - FluxCD no longer supports the `spec.gitImplementation` field as of v0.33.0. For more information,
    see the [fluxcd/source-controller Changelog](https://github.com/fluxcd/source-controller/blob/main/CHANGELOG.md#0330).
    - Existing references to the `git_implementation` field are ignored and references to `libgit2`
      do not cause failures. This is assured up to Tanzu Application Platform v1.9.0.
    - Azure DevOps works without specifying `git_implementation` in Tanzu Application Platform v1.6.1.

### <a id="1-6-scst-scan-deprecations"></a> Supply Chain Security Tools (SCST) - Scan

- The `docker` field and related sub-fields used in SCST -
  Scan are deprecated and marked for removal in Tanzu Application Platform
  v1.7.0.

   The deprecation impacts the following components: Scan Controller, Grype Scanner, and Snyk Scanner.
   Carbon Black Scanner is not impacted.
   For information about the migration path, see
   [Troubleshooting](scst-scan/observing.hbs.md#unable-to-pull-scanner-controller-images).

- The profile based installation of Grype to a developer namespace and related
  fields in the values file, such as `grype.namespace` and
  `grype.targetImagePullSecret`, are deprecated and marked for removal in Tanzu
  Application Platform v1.8.0.

   VMware recommends using the namespace provisioner to populate namespaces with
   all the required resources, including the Grype installation.  For
   information about how to use namespace provisioner to populate a namespace
   with SCST - SCST scan, see [Setup for OOTB Supply Chains](namespace-provisioner/ootb-supply-chain.hbs.md#test-scan).

### <a id="1-6-tbs-deprecations"></a> Tanzu Build Service

- The Ubuntu Bionic stack is deprecated: Ubuntu Bionic stops receiving support in April 2023.
  VMware recommends you migrate builds to Jammy stacks in advance.
  For how to migrate builds, see [Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).

- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated.
  VMware plans to deactivate this format by default in Tanzu Application Platform v1.6.1 and remove
  support in Tanzu Application Platform v1.7.0.
  To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).

### <a id="1-6-apps-plugin-deprecations"></a> Tanzu CLI Apps plug-in

- The default value for the
  [--update-strategy](./cli-plugins/apps/reference/workload-create-apply.hbs.md#update-strategy)
  flag is planned to change from `merge` to `replace` in Tanzu Application Platform v1.7.0.

### <a id="1-6-tekton-deprecations"></a> Tekton Pipelines

- Tekton `ClusterTask` is deprecated and marked for removal in Tanzu Application
  Platform v1.9. Use the `Task` API instead. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/deprecations/).
