# Tanzu Application Platform release notes

This topic contains release notes for Tanzu Application Platform v{{ vars.url_version }}.

{{#unless vars.hide_content}}

This Handlebars condition is used to hide content.

In release notes, this condition hides content that describes an unreleased patch for a released minor.

{{/unless}}

## <a id='1-8-0'></a> v1.8.0

**Release Date**: 29 February 2024

### <a id='1-8-0-whats-new'></a> What's new in Tanzu Application Platform v1.8

This release includes the following platform-wide enhancements.

#### <a id='1-8-0-new-platform-features'></a> New platform-wide features

- Feature Description.

#### <a id='1-8-0-new-components'></a> New components

- [COMPONENT-NAME-AND-LINK-TO-DOCS](): Component description.

---

### <a id='1-8-0-new-features'></a> v1.8.0 New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-8-0-app-accelerator'></a> v1.8.0 Features: Application Accelerator

- Accelerator authors can create accelerators faster using a local authoring experience without
  connecting to a Tanzu Application Platform cluster.
  This allows you to create accelerators locally by using the VSCode IDE.
  For more information, see [Using a local Application Accelerator engine server](application-accelerator/creating-accelerators/using-local-engine-server.hbs.md)

#### <a id='1-8-0-app-live-view'></a> v1.8.0 Features: Application Live View

- By default, Application Live View connector is deployed as a Kubernetes DaemonSet to discover
  applications across all namespaces running in a worker node of a Kubernetes cluster.
  When the connector is deployed as a DaemonSet, the Kubernetes scheduling pattern might be unpredictable
  when a node restarts.
  To avoid this, you can override the default settings to deploy the connector as a deployment or in
  namespace-scope mode.
  For more information, see [Connector deployment modes in Application Live View](app-live-view/connector-deployment-modes.hbs.md).

#### <a id='1-8-0-app-sso'></a> v1.8.0 Features: Application Single Sign-On

- The authorization server can auto-discover upstream identity provider
  configuration from
  `AuthServer.spec.identityProviders[].openID.configurationURI`.
  For more information, see [Identity providers for Application Single Sign-On](app-sso/how-to-guides/service-operators/identity-providers.hbs.md).

- The `userinfo` endpoint of an upstream identity provider is called when
  it's known and configured with the scope `openid`. That means user information
  is retrieved for non-standard providers.

- Scopes in the token response are filtered according to the roles filtering
  defined on the `AuthServer`.

- Advertises the Application Single Sign-On version on components:

  - The controller workloads are annotated with
    `sso.apps.tanzu.vmware.com/version`.
  - `AuthServer`-owned workloads are annotated with
    `sso.apps.tanzu.vmware.com/version`.
  - Authorization servers report the version by using the endpoint
    `FDQN/actuator/info`.

- Shows an error message when attempting unsupported, Relying Party (RP)-Initiated Logout.

- Shows an improved error message when using `localhost` in
  `ClientRegistration.spec.redirectURIs`.

- Bundles the latest `bitnami/redis:7.2.4`.

- Supports Kubernetes v1.29.

#### <a id='1-8-0-aws-services'></a> v1.8.0 Features: AWS Services

- Adds the service Amazon MQ for RabbitMQ. To enable the new service, set `rabbitmq.enabled: true`
  in your `aws-services-values.yaml`. For more configuration options, see
  [Package values for AWS Services](aws-services/reference/package-values.hbs.md).

- Adds the package value `crossplane.role_arn`. Users can specify a `role_arn`, which causes
  the Provider pods to run as a service account that is mapped to the corresponding IAM role in AWS.

- Updates upbound/provider-aws from v0.39.0 to v0.46.0.

#### <a id='1-8-0-bitnami-services'></a> v1.8.0 Features: Bitnami Services

- Updates all Compositions to use function pipelines rather than Crossplane’s default patch and transform.
  New instances created using a class claim are now composed using the new Compositions.
  There is no change to how the resulting composed service instances operate.
  There is no impact to existing instances.

#### <a id='1-8-0-buildpacks'></a> v1.8.0 Features: Buildpacks and Stacks

- Adds the following new stacks, along with builders, as part of the [full](tanzu-build-service/dependencies.hbs.md#lite-vs-full)
dependencies:

  - [Tanzu Standard Stack for UBI 8](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html#ubi-8-stacks)
  - [Tanzu Static Stack for Ubuntu 22.04](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html#ubuntu-stacks)

- Adds support for [.NET 8](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-8) in the
  Tanzu .NET Core Buildpack.

#### <a id='1-8-0-cert-manager'></a> v1.8.0 Features: cert-manager

- Updates cert-manager to v1.13.3. For more information, see the [cert-manager release notes](https://github.com/cert-manager/cert-manager/releases/tag/v1.13.3) in GitHub.

#### <a id='1-8-0-crossplane'></a> v1.8.0 Features: Crossplane

- Updates [Universal Crossplane](https://github.com/upbound/universal-crossplane) to v1.14.5-up.1
  For more information, see the [Upbound blog](https://blog.crossplane.io/crossplane-v1-14/).

- Updates provider-helm to v0.16.0.

- Updates provider-kubernetes to v0.11.0.

- Adds support for composition functions. Composition functions are beta in for Crossplane v1.14.
  For more information, see the [Upbound Documentation](https://docs.crossplane.io/latest/concepts/composition-functions).

- Adds the patch and transform function. Users who want to use function pipelines in their Compositions
  can use this function without having to explicitly install it.

#### <a id='1-8-0-service-bindings'></a> v1.8.0 Features: Service Bindings

- Updates [servicebinding/runtime](https://github.com/servicebinding/runtime) to v0.7.0.
  This update fixes the issue of `ServiceBinding` not immediately reconciling when `status.binding.name`
  changes on a previously bound service resource.

#### <a id='1-8-0-services-toolkit'></a> v1.8.0 Features: Services Toolkit

- Updates reconciler-runtime to v0.15.1.

#### <a id='1-8-0-spring-boot-conv'></a> v1.8.0 Features: Spring Boot Convention

- You no longer must provide the verbose configuration to enable actuators and the Application Live View
  features while running Spring Native workloads on Tanzu Application Platform.
  The Spring Boot convention server enhances Tanzu PodIntents with metadata.
  This metadata can include labels, annotations, or properties required to run native workloads in
  Tanzu Application Platform.
  This metadata enables Application Live View to discover and register the app instances so that
  Application Live View can access the actuator data from those workloads.
  For more information, see [Enable Spring Native apps for Application Live View](app-live-view/configuring-apps/spring-native-enablement.hbs.md)

#### <a id='1-8-0-scc'></a> v1.8.0 Features: Supply Chain Choreographer

- Introduces [Carvel Package Supply Chains](scc/carvel-package-supply-chain.hbs.md) for the [Out of the Box Supply Chain with Testing](scc/ootb-supply-chain-testing.hbs.md) and [Out of the Box Supply Chain with Testing and Scanning](scc/ootb-supply-chain-testing-scanning.hbs.md) packages. This feature is in beta.

#### <a id='1-8-0-scst-scan'></a> v1.8.0 Features: Supply Chain Security Tools (SCST) - Scan

- SCST - Scan 2.0 is now GA. For more information, including guidance on when to use
SCST - Scan 1.0 versus SCST - Scan 2.0, see [SCST - Scan Overview](./scst-scan/overview.hbs.md).
- SCST - Scan 1.0 remains the default scan component, with SCST - Scan 2.0 available on an
opt-in basis, except in the following situations:
  - Air-gapped installs use SCST - Scan 2.0 and Trivy to simplify the installation and configuration
  process.
  - [Tanzu Supply Chain (Beta)](./supply-chain/about.hbs.md) uses the Trivy component based on
  SCST - Scan 2.0.
- You can scan container images on a periodic interval after the initial build. See [Set up recurring scanning](./scst-scan/recurring-scanning.hbs.md).
- The SCST - Scan 2.0 scanners are updated to the latest versions to support CycloneDX 1.5 outputs:
  - Aqua Trivy is updated to [v0.48.3](https://github.com/aquasecurity/trivy/releases/tag/v0.48.3).
  - Anchore Grype is updated to [v0.74.1](https://github.com/anchore/grype/releases/tag/v0.74.1).

#### <a id='1-8-0-scst-store'></a> v1.8.0 Features: Supply Chain Security Tools - Store

- Adds support for ingesting SBOMs in CycloneDX v1.5 format.
- Better error messaging for ingestion errors.
- To enable DORA metrics functionality, if you configured the `environment` label, rename it
  to `env`. For more information, see [Configure Artifact Metadata Repository](scst-store/amr/configuration.hbs.md).

#### <a id='1-8-0-tanzu-dev-portal'></a> v1.8.0 Features: Tanzu Developer Portal

- The DORA plug-in now has:
  - A Date Range drop-down menu, which includes the filters **This Week**, **This Month**,
    **This Quarter**, and **Last 90 Days (default)**
  - An Environments drop-down menu, which includes the filters **All Environments (default)** and
    any available individual environment

#### <a id='1-8-0-vscode'></a> v1.8.0 Features: Tanzu Developer Tools for Visual Studio Code

- You can create `portforwards` with the [Tanzu: Portforward](vscode-extension/using-the-extension.hbs.md#workload-port-forward)
  action from the pop-up menu in the Tanzu panel. This enables you to easily access the application
  when iterating locally from a local URL (via **Tanzu: Portforward**) or a Knative URL (for the web
  type of workloads) from the Tanzu panel.

#### <a id='1-8-0-intellij'></a> v1.8.0 Features: Tanzu Developer Tools for IntelliJ

- You can create `portforwards` with the [Port Forward](vscode-extension/using-the-extension.hbs.md#workload-port-forward)
  action from the pop-up menu in the Tanzu panel. This enables you to easily access the application
  when iterating locally from a local URL (via **Port Forward**) or a Knative URL (for the web
  type of workloads) from the Tanzu panel.
---

### <a id='1-8-0-breaking-changes'></a> v1.8.0 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-8-0-apix-bc'></a> v1.8.0 Breaking changes: API Validation and Scoring

- API Validation and Scoring is removed in this release.

#### <a id='1-8-0-buildpacks-bc'></a> v1.8.0 Breaking changes: Buildpacks

- Tanzu Java Buildpack removes Java (BellSoft Liberica) v20. This is replaced by Java v21.

- Tanzu Go Buildpack removes support for the [dep dependency management tool for Go](https://github.com/golang/dep).
  This tool has been officially deprecated since 2020.

#### <a id='1-8-0-scst-scan-bc'></a> v1.8.0 Breaking changes: Supply Chain Security Tools (SCST) - Scan

- Grype scanner has been removed from the `build` and `full` installation profiles. Use Namespace Provisioner
  to install the Grype package to developer namespaces. For instructions, see
  [Apply ScanTemplate overlays in air-gapped environments in Namespace Provisioner](./namespace-provisioner/use-case6.hbs.md).

### <a id="1-8-0-tbs-bc"></a> v1.8.0 Breaking changes: Tanzu Build Service

- The Cloud Native Buildpack Bill of Materials (CNB BOM) format has been removed.

---

### <a id='1-8-0-security-fixes'></a> v1.8.0 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<thead>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>accelerator.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-47038">CVE-2023-47038</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4016">CVE-2023-4016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39804">CVE-2023-39804</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48522">CVE-2022-48522</a></li>
</ul></details></td>
</tr>
<tr>
<td>amr-observer.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
</ul></details></td>
</tr>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-r47r-87p9-8jh3">GHSA-r47r-87p9-8jh3</a></li>
<li><a href="https://github.com/advisories/GHSA-jjfh-589g-3hjx">GHSA-jjfh-589g-3hjx</a></li>
<li><a href="https://github.com/advisories/GHSA-7g45-4rm6-3mm3">GHSA-7g45-4rm6-3mm3</a></li>
<li><a href="https://github.com/advisories/GHSA-5mg8-w23w-74h3">GHSA-5mg8-w23w-74h3</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-8908">CVE-2020-8908</a></li>
</ul></details></td>
</tr>
<tr>
<td>apiserver.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
</ul></details></td>
</tr>
<tr>
<td>app-scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
</ul></details></td>
</tr>
<tr>
<td>aws.services.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2c7c-3mj9-8fqh">GHSA-2c7c-3mj9-8fqh</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-22365">CVE-2024-22365</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0567">CVE-2024-0567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0553">CVE-2024-0553</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-7008">CVE-2023-7008</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52426">CVE-2023-52426</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-50495">CVE-2023-50495</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-47038">CVE-2023-47038</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4641">CVE-2023-4641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4016">CVE-2023-4016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39804">CVE-2023-39804</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29383">CVE-2023-29383</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4899">CVE-2022-4899</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48522">CVE-2022-48522</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3219">CVE-2022-3219</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27943">CVE-2022-27943</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-22916">CVE-2020-22916</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-2781">CVE-2016-2781</a></li>
</ul></details></td>
</tr>
<tr>
<td>backend.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-20926">CVE-2024-20926</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-wr6v-9f75-vh2g">GHSA-wr6v-9f75-vh2g</a></li>
<li><a href="https://github.com/advisories/GHSA-m3r6-h7wv-7xxv">GHSA-m3r6-h7wv-7xxv</a></li>
<li><a href="https://github.com/advisories/GHSA-9763-4f94-gfch">GHSA-9763-4f94-gfch</a></li>
<li><a href="https://github.com/advisories/GHSA-7ww5-4wqc-m92c">GHSA-7ww5-4wqc-m92c</a></li>
<li><a href="https://github.com/advisories/GHSA-4v98-7qmw-rqr8">GHSA-4v98-7qmw-rqr8</a></li>
<li><a href="https://github.com/advisories/GHSA-449p-3h89-pw88">GHSA-449p-3h89-pw88</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
</ul></details></td>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29409">CVE-2023-29409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29406">CVE-2023-29406</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24532">CVE-2023-24532</a></li>
</ul></details></td>
</tr>
<tr>
<td>cnrs.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
</ul></details></td>
</tr>
<tr>
<td>connector.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>conventions.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
</ul></details></td>
</tr>
<tr>
<td>crossplane.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-m425-mq94-257g">GHSA-m425-mq94-257g</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://github.com/advisories/GHSA-2c7c-3mj9-8fqh">GHSA-2c7c-3mj9-8fqh</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
</ul></details></td>
</tr>
<tr>
<td>developer-conventions.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
</ul></details></td>
</tr>
<tr>
<td>dotnet-core-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-7ww5-4wqc-m92c">GHSA-7ww5-4wqc-m92c</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45284">CVE-2023-45284</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>grype.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29409">CVE-2023-29409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29406">CVE-2023-29406</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24532">CVE-2023-24532</a></li>
</ul></details></td>
</tr>
<tr>
<td>java-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-jq35-85cj-fj4p">GHSA-jq35-85cj-fj4p</a></li>
<li><a href="https://github.com/advisories/GHSA-7ww5-4wqc-m92c">GHSA-7ww5-4wqc-m92c</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
</ul></details></td>
</tr>
<tr>
<td>java-native-image-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
</ul></details></td>
</tr>
<tr>
<td>metadata-store.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-22365">CVE-2024-22365</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0567">CVE-2024-0567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0553">CVE-2024-0553</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5981">CVE-2023-5981</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4016">CVE-2023-4016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39804">CVE-2023-39804</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-36054">CVE-2023-36054</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-31879">CVE-2021-31879</a></li>
</ul></details></td>
</tr>
<tr>
<td>namespace-provisioner.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
</ul></details></td>
</tr>
<tr>
<td>nodejs-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45284">CVE-2023-45284</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29409">CVE-2023-29409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29406">CVE-2023-29406</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24532">CVE-2023-24532</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41717">CVE-2022-41717</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-supply-chain-testing-scanning.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-jq35-85cj-fj4p">GHSA-jq35-85cj-fj4p</a></li>
<li><a href="https://github.com/advisories/GHSA-7ww5-4wqc-m92c">GHSA-7ww5-4wqc-m92c</a></li>
<li><a href="https://github.com/advisories/GHSA-6xv5-86q9-7xr8">GHSA-6xv5-86q9-7xr8</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-9763-4f94-gfch">GHSA-9763-4f94-gfch</a></li>
<li><a href="https://github.com/advisories/GHSA-7ww5-4wqc-m92c">GHSA-7ww5-4wqc-m92c</a></li>
<li><a href="https://github.com/advisories/GHSA-6xv5-86q9-7xr8">GHSA-6xv5-86q9-7xr8</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
</ul></details></td>
</tr>
<tr>
<td>python-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
</ul></details></td>
</tr>
<tr>
<td>servicebinding.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
</ul></details></td>
</tr>
<tr>
<td>services-toolkit.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
</ul></details></td>
</tr>
<tr>
<td>snyk.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29409">CVE-2023-29409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29406">CVE-2023-29406</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24532">CVE-2023-24532</a></li>
</ul></details></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-wjxj-5m7g-mg7q">GHSA-wjxj-5m7g-mg7q</a></li>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-pvcr-v8j8-j5q3">GHSA-pvcr-v8j8-j5q3</a></li>
<li><a href="https://github.com/advisories/GHSA-cgwf-w82q-5jrr">GHSA-cgwf-w82q-5jrr</a></li>
<li><a href="https://github.com/advisories/GHSA-7f9x-gw85-8grf">GHSA-7f9x-gw85-8grf</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42503">CVE-2023-42503</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0641">CVE-2024-0641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6622">CVE-2023-6622</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6606">CVE-2023-6606</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6040">CVE-2023-6040</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6039">CVE-2023-6039</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46813">CVE-2023-46813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35827">CVE-2023-35827</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34324">CVE-2023-34324</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32257">CVE-2023-32257</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32252">CVE-2023-32252</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32250">CVE-2023-32250</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2953">CVE-2023-2953</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22084">CVE-2023-22084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47015">CVE-2022-47015</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43253">CVE-2022-43253</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43252">CVE-2022-43252</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43248">CVE-2022-43248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43243">CVE-2022-43243</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43242">CVE-2022-43242</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43241">CVE-2022-43241</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43240">CVE-2022-43240</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43239">CVE-2022-43239</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43238">CVE-2022-43238</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43237">CVE-2022-43237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43236">CVE-2022-43236</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43235">CVE-2022-43235</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1253">CVE-2022-1253</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36411">CVE-2021-36411</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36410">CVE-2021-36410</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36409">CVE-2021-36409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36408">CVE-2021-36408</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-35452">CVE-2021-35452</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-8-0-resolved-issues'></a> v1.8.0 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-8-0-COMPONENT-NAME-ri'></a> v1.8.0 Resolved issues: Service Bindings

- Resolved an issue in which `ServiceBinding` is not immediately reconciled when `status.binding.name`
  changes on a previously bound service resource.

#### <a id='1-8-0-scst-store-ri'></a> v1.8.0 Resolved issues: Supply Chain Security Tools - Store

- This release fixes the issue with expired certificates where you must restart the metadata-store pods when the internal database certificate is rotated by cert-manager.
You will no longer see this issue with the default internal database, but the solution does not cover the case of an external database.

- Artifact Metadata Repository now properly sets the `hasNextPage` to `false` when there are
no more items to be retrieved during a paginated query. This fixes the issue
where the last page always returns an empty list.

---

### <a id='1-8-0-known-issues'></a> v1.8.0 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-8-0-app-live-view-ki'></a> v1.8.0 Known issues: Tanzu Application Platform

- On Azure Kubernetes Service (AKS), the Datadog Cluster Agent cannot reconcile the webhook, which
  leads to an error.
  For troubleshooting information, see [Datadog agent cannot reconcile webhook on AKS](./troubleshooting-tap/troubleshoot-using-tap.hbs.md#datadog-agent-aks).

#### <a id='1-8-0-cnr-ki'></a> v1.8.0 Known issues: Cloud Native Runtimes

- Web workloads created with Tanzu Application Platform v1.6.3 and earlier fail to update with the error
  `API server says: admission webhook "validation.webhook.serving.knative.dev" denied the request: validation failed: annotation value is immutable`.
  For a workaround, see [Troubleshoot Cloud Native Runtimes for Tanzu](cloud-native-runtimes/how-to-guides/troubleshooting.hbs.md).

#### <a id='1-8-0-scst-scan-ki'></a> v1.8.0 Known issues: Supply Chain Security Tools - Scan

- The Snyk scanner outputs an incorrectly created date, resulting in an invalid date. If the workload
is in a failed state due to an invalid date, wait approximately 10 hours and the workload
automatically goes into the ready state. For more information, see this [issue](https://github.com/snyk-tech-services/snyk2spdx/issues/54) in the Snyk GitHub repository.
- Recurring scan fails to import keychains for cloud container registries such as ECR, ACR, and GCR.
To work around, create a Docker config secret for the registry.
- Recurring Scan has a maximum of approximately 5000 container images that can be scanned at a
single time due to size limits configMaps.
- Recurring Scan resources are shown in the Security Analysis Plug-in in Tanzu Developer Portal.
This is cosmetic and does not have any impact on the vulnerabilities shown.
- If the supply chain container image scanning is configured to use a different scanner or scanner
version than the recurring scanning, the vulnerabilities displayed in Tanzu
Developer Portal might be inaccurate.

#### <a id='1-8-0-scst-store-ki'></a> v1.8.0 Known issues: Supply Chain Security Tools - Store

- When outputting CycloneDX 1.5 SBOMs, the report is found to be an invalid SBOM by CycloneDX validators. This issue is planned to be fixed in the next patch.

#### <a id='1-8-0-tdp-ki'></a> v1.8.0 Known issues: Tanzu Developer Portal

- Tanzu Developer Portal Configurator jumps from v1.0.x in Tanzu Application Platform v1.7 to v1.8.x
  in Tanzu Application Platform v1.8. This version jump enables future versions of
  Tanzu Developer Portal and Tanzu Developer Portal Configurator to sync going forward.

---

### <a id='1-8-0-components'></a> v1.8.0 Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                     | Version |
| -------------------------------------------------- | ------- |
| API Auto Registration                              |         |
| API portal                                         |         |
| Application Accelerator                            |         |
| Application Configuration Service                  |         |
| Application Live View APIServer                    |         |
| Application Live View back end                     |         |
| Application Live View connector                    |         |
| Application Live View conventions                  |         |
| Application Single Sign-On                         |         |
| Artifact Metadata Repository Observer              |         |
| AWS Services                                       |         |
| Bitnami Services                                   |         |
| Carbon Black Scanner for SCST - Scan (beta)        |         |
| Cartographer Conventions                           |         |
| cert-manager                                       |         |
| Cloud Native Runtimes                              |         |
| Contour                                            |         |
| Crossplane                                         |         |
| Default Roles                                      |         |
| Developer Conventions                              |         |
| External Secrets Operator                          |         |
| Flux CD Source Controller                          |         |
| Grype Scanner for SCST - Scan                      |         |
| Local Source Proxy                                 |         |
| Namespace Provisioner                              |         |
| Out of the Box Delivery - Basic                    |         |
| Out of the Box Supply Chain - Basic                |         |
| Out of the Box Supply Chain - Testing              |         |
| Out of the Box Supply Chain - Testing and Scanning |         |
| Out of the Box Templates                           |         |
| Service Bindings                                   |         |
| Service Registry                                   |         |
| Services Toolkit                                   |         |
| Snyk Scanner for SCST - Scan (beta)                |         |
| Source Controller                                  |         |
| Spring Boot conventions                            |         |
| Spring Cloud Gateway                               |         |
| Supply Chain Choreographer                         |         |
| Supply Chain Security Tools - Policy Controller    |         |
| Supply Chain Security Tools - Scan                 |         |
| Supply Chain Security Tools - Scan 2.0             |         |
| Supply Chain Security Tools - Store                |         |
| Tanzu Developer Portal                             |         |
| Tanzu Developer Portal Configurator                |         |
| Tanzu Application Platform Telemetry               |         |
| Tanzu Build Service                                |         |
| Tanzu CLI                                          |         |
| Tekton Pipelines                                   |         |

---

## <a id='deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features remain on this list until they are retired from Tanzu Application Platform.

### <a id='COMPONENT-NAME-deprecations'></a> COMPONENT-NAME deprecations

- Deprecation description including the release when the feature will be removed.

### <a id='cnrs-deprecations'></a> Cloud Native Runtimes deprecations

- **`default_tls_secret` config option**: After changes in this release, this config option is moved
  to `contour.default_tls_secret`. `default_tls_secret` is marked for removal in Cloud Native Runtimes v2.7.
  In the meantime, both options are supported, and `contour.default_tls_secret` takes precedence over
  `default_tls_secret`.

- **`ingress.[internal/external].namespace` config options**: After changes in this release, these
  config options are moved to `contour.[internal/external].namespace`.
  `ingress.[internal/external].namespace` is marked for removal in Cloud Native Runtimes v2.7.
  In the meantime, both options are supported, and `contour.[internal/external].namespace` takes
  precedence over `ingress.[internal/external].namespace`.

### <a id="flux-cd-deprecations"></a> Flux CD Source Controller deprecations

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

### <a id='services-toolkit-deprecations'></a> Services Toolkit deprecations

- The `tanzu services claims` CLI plug-in command is deprecated and is marked for removal in
  Tanzu Application Platform v1.9.
  It is hidden from help text output, but it will continue to work until it is removed.
  The new `tanzu services resource-claims` command provides the same function.

- The experimental multicluster APIs `*.multicluster.x-tanzu.vmware.com/v1alpha1` are deprecated
  and marked for removal in Tanzu Application Platform v1.9.

- The experimental `kubectl-scp` plug-in is deprecated and marked for removal in Tanzu
  Application Platform v1.9.

- The following experimental APIs are deprecated and are marked for removal in
  Tanzu Application Platform v1.9:

  - `apiexportrolebindings.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `apiresourceimports.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `clusterapigroupimports.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `downstreamclusterlinks.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `upstreamclusterlinks.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `clusterresourceexportmonitors.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `clusterresourceimportmonitors.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `resourceexportmonitorbindings.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `resourceimportmonitorbindings.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `secretexports.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  - `secretimports.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`

### <a id="sc-deprecations"></a> Source Controller deprecations

- The Source Controller `ImageRepository` API is deprecated and is marked for
  removal. Use the `OCIRepository` API instead.
  The Flux Source Controller installation includes the `OCIRepository` API.
  For more information about the `OCIRepository` API, see the
  [Flux documentation](https://fluxcd.io/flux/components/source/ocirepositories/).

### <a id='scc-deprecations'></a> Supply Chain Choreographer deprecations

- Supply Chain Choreographer no longer uses the `git_implementation` field. The `go-git` implementation
  now assumes that `libgit2` is not supported.
  - Flux CD no longer supports the `spec.gitImplementation` field as of v0.33.0. For more information,
  see the [fluxcd/source-controller Changelog](https://github.com/fluxcd/source-controller/blob/main/CHANGELOG.md#0330).
  - Existing references to the `git_implementation` field are ignored and references to `libgit2`
    do not cause failures. This is assured up to Tanzu Application Platform v1.9.
  - Azure DevOps works without specifying `git_implementation` in Tanzu Application Platform v1.8.

### <a id="tekton-deprecations"></a> Tekton Pipelines deprecations

- Tekton `ClusterTask` is deprecated and marked for removal in Tanzu Application Platform v1.9.
  Use the `Task` API instead. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/deprecations/).

---
