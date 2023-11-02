# Tanzu Application Platform release notes

This topic describes the changes in Tanzu Application Platform (commonly known as TAP)
v{{ vars.url_version }}.

## <a id='1-7-0'></a> v1.7.0

**Release Date**: 07 November 2023

### <a id='1-7-0-whats-new'></a> What's new in Tanzu Application Platform v1.7

This release includes the following platform-wide enhancements.

#### <a id='1-7-0-new-platform-features'></a> New platform-wide features

- Added air-gapped support to the Tanzu Application Platform GitOps install method.
  For more information, see one of the following install topics:

  - [Install Tanzu Application Platform through GitOps with AWS Secrets Manager](install-gitops/eso/aws-secrets-manager.hbs.md#airgap-support)
  - [Install Tanzu Application Platform through GitOps with HashiCorp Vault](install-gitops/eso/hashicorp-vault.hbs.md#airgap-support)
  - [Install Tanzu Application Platform through Gitops with Secrets OPerationS (SOPS)](install-gitops/sops.hbs.md#airgap-support)

#### <a id='1-7-0-new-components'></a> New components

- [Aria Operations for Applications (AOA) dashboard (Beta)](aoa-dashboard/about.hbs.md):
  This dashboard, powered by Aria Operations for Applications (formerly Tanzu Observability), helps
  platform engineers monitor the health of clusters by showing whether the deployed
  Tanzu Application Platform components are behaving as expected.

- [AWS Services](aws-services/about.hbs.md): Provides a more streamlined approach for integrating
  services from AWS into Tanzu Application Platform. Currently supports RDS PostgresSQL and MySQL on AWS.
  Installing this package is optional because it is not included in any Tanzu Application Platform profile.

- [Service Registry for VMware Tanzu](service-registry/overview.hbs.md): Provides on-demand Eureka
  servers for Tanzu Application Platform clusters. With Service Registry, you can create Eureka
  servers in your namespaces and bind Spring Boot workloads to them.

### <a id='1-7-0-new-features'></a> v1.7.0 New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-7-0-api-autoreg'></a> v1.7.0 Features: API Auto Registration

- Introduces API curation feature in alpha that is intended for only testing.

- The new `CuratedAPIDescriptor` custom resource allows aggregating multiple APIs of type OpenAPI in
  a single curated API.

- Integrate with Spring Cloud Gateway for Kubernetes to automatically generate
  `SpringCloudGatewayMapping`s and `SpringCloudGatewayRouteConfig`s.

- The API Auto Registration controller exposes API endpoints to view all curated APIs or filter for
  specific APIs to add as API portal's source URLs.

#### <a id='1-7-0-app-acc'></a> v1.7.0 Features: Application Accelerator

- Includes built-in integration of application bootstrap provenance through an accelerator into
  Artifact Metadata Repository (AMR).
  This enables application architects to get advanced insight into how accelerators are used,
  such as, the most commonly and rarely used accelerators.

#### <a id='1-7-0-app-config-service'></a> v1.7.0 Features: Application Configuration Service

- The default interval for a new `ConfigurationSlice` resource is now 60 seconds.

- When debugging `ConfigurationSlice` resources, you now see status information from `GitRepository`
  resources if any of the errors are related to the `GitRepository` reconciliation.

#### <a id='1-7-0-app-live-view'></a> v1.7.0 Features: Application Live View

- Developers can override the settings for the Kubernetes default liveness, readiness, and startup
  probes for Spring Boot apps in Tanzu Application.
  For more information, see
  [Configure liveness, readiness, and startup probes for Spring Boot applications](./spring-boot-conventions/config-probes.hbs.md).

#### <a id='1-7-0-app-sso'></a> v1.7.0 Features: Application Single Sign-On

- Supports Kubernetes v1.28.
- `ClientRegistration`s instantaneously react to updates of `AuthServer`s.
- `ClusterWorkloadRegistrationClass`s instantaneously react to updates of `AuthServer`s.
- Insufficiently small token signature keys cause an explicit error condition in `AuthServer.status`.
- You can customize a `ClientRegistration`'s display name.
- You can customize the display names of identity providers for an `AuthServer`, with the restriction
  that this customization applies only to OpenID and Security Assertion Markup Language (SAML).
- Authorization servers log role mappings in the audit log.
- Authorization servers advertise the supported client authentication and grant types methods by using
  the OpenID discovery endpoint.
- End users can see their email address on the consent page.
- `AuthServer.spec.cors.{allowHeaders, exposeHeaders, allowCredentials, allowMethods}` provide
  service operators with finer control over an authorization server's Cross-Origin Resource Sharing
  (CORS) configuration. <!-- check abbreviation -->
  As a result, application operators can use the `client_credentials` grant for single-page apps.
- Authorization servers do not advertise the device authentication endpoint by using the
  OpenID discovery endpoint.
- The authorization server UI uses the Clarity design system.
- `ClientRegistration` uses finalizers.
- `ClusterUnsafeTestLogin` reports its issuer URI in its status and as a print column.
- Authorization servers support the user-information endpoint.
- `AuthServer.spec.session.expiry` controls the session expiry of authorization servers.
  The default value is `15m`. It must be at least `1m`.

#### <a id='1-7-0-bitnami-services'></a> v1.7.0 Features: Bitnami Services

- Adds support for environments enforcing the restricted Pod Security Standard.

#### <a id='1-7-0-cert-manager'></a> v1.7.0 Features: cert-manager

- Upgrades `cert-manager.tanzu.vmware.com` to `cert-manager@1.12`.
  For more information, see the [cert-manager documentation](https://cert-manager.io/docs/release-notes/release-notes-1.12/).

#### <a id='1-7-0-cnrs'></a> v1.7.0 Features: Cloud Native Runtimes

- Adds the new configuration option `resource_management`, which allows you to configure CPU and memory for both
  [Kubernetes request and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
  for all Knative Serving deployments in the `knative-serving` namespace.
  For information about how to use this configuration, see
  [Knative Serving Resource Management](cloud-native-runtimes/how-to-guides/app-operators/resource_management.hbs.md).

- Adds the new configuration option `cnrs.contour.default_tls_secret`, which has the same meaning as `cnrs.default_tls_secret`.
  `cnrs.default_tls_secret` is deprecated in this release and is marked for removal in
  Tanzu Application Platform v1.10, which includes Cloud Native Runtimes v2.7.
  In the meantime both options are supported and `cnrs.contour.default_tls_secret` takes precedence
  over `cnrs.default_tls_secret`.

- Adds new configuration options `cnrs.contour.[internal|external].namespace`.
  These two new options behave the same as `cnrs.ingress.[internal|external].namespace`.
  `cnrs.ingress.[internal/external].namespace` is deprecated in this release and is marked for removal
  in Tanzu Application Platform v1.10.
  In the meantime, both options are supported, but `cnrs.contour.[internal/external].namespace` takes
  precedence over `cnrs.ingress.[internal/external].namespace`.

- New Knative garbage collection defaults. Cloud Native Runtimes is reducing the number of revisions
  kept for each Knative service from 20 to 5.
  This improves the Knative controller's memory consumption when there are several Knative services.
  Knative manages this through the `config-gc` ConfigMap under the `knative-serving` namespace.
  See the [Knative documentation](https://knative.dev/docs/serving/revisions/revision-admin-config-options/).
  The following defaults are set for Knative garbage collection:

  - `retain-since-create-time: "48h"`: Any revision created with an age of 2 days is considered for garbage collection.
  - `retain-since-last-active-time: "15h"`: Revision that was last active at least 15 hours ago is considered for garbage collection.
  - `min-non-active-revisions: "2"`: The minimum number of inactive Revisions to retain.
  - `max-non-active-revisions: "5"`: The maximum number of inactive Revisions to retain.

  For more information about updating default values, see [Configure Garbage collection for the Knative revisions](cloud-native-runtimes/how-to-guides/garbage_collection.hbs.md).

- Knative Serving v1.11 is available in Cloud Native Runtimes. For more information, see the
  [Knative v1.11 release notes](https://knative.dev/blog/releases/announcing-knative-v1-11-release/).

- Adds the Knative Serving migrator job. Cloud Native Runtimes now runs a new job in the `knative-serving`
  namespace that is responsible for ensuring that Cloud Native Runtimes uses the latest Knative Serving
  resource versions.

#### <a id='1-7-0-contour'></a> v1.7.0 Features: Contour

- Contour v1.25.2 is available in Tanzu Application Platform. For more information, see the
  [Contour v1.25.2 release notes](https://github.com/projectcontour/contour/releases/tag/v1.25.2) in GitHub.

- Adds the new configuration option `loadBalancerTLSTermination`, which allows you to configure the
  Envoy service's port for TLS termination. For information about using this configuration option,
  see [Configure Contour to support TLS termination at an AWS Network LoadBalancer](./contour/how-to-guides/configuring-contour-with-loadbalancer-tls-termination.hbs.md)

#### <a id='1-7-0-crossplane'></a> v1.7.0 Features: Crossplane

- Updates Universal Crossplane to v1.13.2-up.1. For more information, see the [Upbound blog](https://blog.crossplane.io/crossplane-v1-13/).

- Custom certificate data is now correctly passed through to the Crossplane Providers.

#### <a id='1-7-0-eso'></a> v1.7.0 Features: External Secrets Operator

- External Secrets Operator has now reached General Availability.

- Adds SYNC, GET, LIST and CREATE commands to the CLI. The GET command lets you get more details
  about your external secrets and secret stores. The CREATE command lets you create cluster
  external secret and cluster secret stores. For more information, see the [Tanzu CLI Command Reference](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.1/tanzu-cli/command-ref.html) documentation.

#### <a id='1-7-0-service-bindings'></a> v1.7.0 Features: Service Bindings

- Introduces the new `servicebinding.tanzu.vmware.com` package, which supersedes the existing
  `service-bindings.labs.vmware.com`. The new package is based on the community maintained
  [`servicebinding/runtime`](https://github.com/servicebinding/runtime) implementation instead of the
  VMware-maintained [`vmware-tanzu/servicebinding`](https://github.com/vmware-tanzu/servicebinding).

#### <a id='1-7-0-services-toolkit'></a> v1.7.0 Features: Services Toolkit

- Adds support for Kubernetes v1.27.

#### <a id='1-7-0-supply-chain-plugin'></a> v1.7.0 Features: Supply Chain plug-in for Tanzu Developer Portal

- You can add triage analysis to vulnerabilities from a vulnerability scanner step.
  For more information, see [Triage Vulnerabilities](tap-gui/plugins/scc-tap-gui.hbs.md#triage-vulnerabilities)

#### <a id='1-7-0-scst-scan'></a> v1.7.0 Features: Supply Chain Security Tools (SCST) - Scan

- Adds support for Pod Security Admission with Pod Security Standards enforced.

- Adds support for the new Tanzu CLI Insight plug-in.

#### <a id='1-7-0-scst-store'></a> v1.7.0 Features: Supply Chain Security Tools (SCST) - Store

- Deploys Artifact Metadata Repository (AMR) by default. For more information, see
  [Artifact Metadata Repository](scst-store/amr/overview.hbs.md).

- Introduces the AMR authentication and authorization feature. For more information, see
  [Authentication and authorization](scst-store/amr/auth.hbs.md).

- AMR GraphQL now contains data for Images, Containers, and Location.
  For more information, see [Data Model and Concepts](scst-store/amr/data-model-and-concepts.hbs.md).

#### <a id='1-7-0-cli'></a> v1.7.0 Features: Tanzu CLI and plug-ins

- This release includes Tanzu CLI v1.0.0 and a set of installable plug-in groups that are versioned
  so that the CLI is compatible with every supported version of Tanzu Application Platform.
  For more information, see [Install Tanzu CLI](install-tanzu-cli.hbs.md).

##### <a id='1-7-0-tanzu-cli-insight-plugin'></a> v1.7.0 Features: Tanzu CLI Insight plug-in

- You can access reports from each scan to find out what packages and vulnerabilities were discovered
  by using the `tanzu insight report` command. For more information, see the
  [Tanzu CLI Command Reference](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.1/tanzu-cli/command-ref.html)
  documentation.

- You can rebase vulnerability triage analyses by using the `tanzu insight triage rebase` command.
  For more information, see [Rebase multiple analyses](cli-plugins/insight/triaging-vulnerabilities.hbs.md#rebase-multiple-analyses)
  and the [Tanzu CLI Command Reference](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.1/tanzu-cli/command-ref.html) documentation.

#### <a id='1-7-0-vscode-extension'></a> v1.7.0 Features: Tanzu Developer Tools for VS Code

- Introduces alpha support for [development containers](https://code.visualstudio.com/docs/devcontainers/containers).
  For more information, see [Use development containers to make a development environment (alpha)](vscode-extension/dev-containers.hbs.md).

---

### <a id='1-7-0-breaking-changes'></a> v1.7.0 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-7-0-tap-br'></a> v1.7.0 Breaking changes: Tanzu Application Platform

- Minikube support has been removed.

#### <a id='1-7-0-app-sso-br'></a> v1.7.0 Breaking changes: Application Single Sign-On

- `ClientRegistration.spec.clientAuthenticationMethod` no longer supports `basic` and `post`.

- The internal-unsafe identity provider for`AuthServer` no longer supports claim mappings.

- `ClusterUnsafeTestLogin` no longer has the short name `cutl`.

#### <a id='1-7-0-eventing-br'></a> v1.7.0 Breaking changes: Eventing

- Eventing is removed in this release. Install and manage Knative Eventing as an alternative solution.

#### <a id='1-7-0-lc-br'></a> v1.7.0 Breaking changes: Learning Center

- Learning Center is removed in this release. Use [Tanzu Academy](https://tanzu.academy/) instead for
  all Tanzu Application Platform learning and education needs.

#### <a id='1-7-0-services-toolkit-br'></a> v1.7.0 Breaking changes: Services Toolkit

- Services Toolkit forces explicit cluster-wide permissions to `claim` from a `ClusterInstanceClass`.
  You must now grant the permission to `claim` from a `ClusterInstanceClass` by using a `ClusterRole`
  and `ClusterRoleBinding`.
  For more information, see [The claim verb for ClusterInstanceClass](./services-toolkit/reference/api/rbac.hbs.md#claim-verb).

#### <a id='1-7-0-scst-scan'></a> v1.7.0 Breaking changes: Supply Chain Security Tools (SCST) - Scan

- The `docker` field and related sub-fields used in SCST - Scan are removed in this release.

- SCST - Scan 2.0: Users must upgrade the Tanzu Application Platform package to v1.7.0 before
  upgrading `app-scanning.apps.tanzu.vmware.com` to v0.2.0.
  See [Troubleshooting](./scst-scan/app-scanning-troubleshooting.hbs.md#upgrading-scan-0.2.0).

- The previously deprecated field `scanning.metadataStore.url` is now completely removed and
  its presence can cause the reconcillation failure. See [Troubleshooting](./scst-scan/troubleshoot-scan.hbs.md#reconcillation-failure-during-upgrade)

#### <a id='1-7-0-cli-re-br'></a> v1.7.0 Breaking changes: Tanzu CLI command reference documenation

- The Tanzu CLI plug-in command reference documentation has moved from the Tanzu Application Platform
  documentation to the [VMware Tanzu CLI](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.1/tanzu-cli/command-ref.html)
  documentation. The following Tanzu CLI plug-ins are impacted: Accelerator, Apps, Build Service,
  External Secrets, Insight, and Tanzu Service.

#### <a id='1-7-0-workloads-br'></a> v1.7.0 Breaking changes: Workloads

- Function Buildpacks for Knative and the corresponding Application Accelerator starter templates
  for Python and Java are removed in this release.

---

### <a id='1-7-0-security-fixes'></a> v1.7.0 Security fixes

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
<li><a href="https://github.com/advisories/GHSA-hrmr-f5m6-m9pq">GHSA-hrmr-f5m6-m9pq</a></li>
<li><a href="https://github.com/advisories/GHSA-6fxm-66hq-fc96">GHSA-6fxm-66hq-fc96</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22049">CVE-2023-22049</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22045">CVE-2023-22045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22044">CVE-2023-22044</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22041">CVE-2023-22041</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22036">CVE-2023-22036</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22006">CVE-2023-22006</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2012-2098">CVE-2012-2098</a></li>
</ul></details></td>
</tr>
<tr>
<td>amr-observer.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29383">CVE-2023-29383</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26604">CVE-2023-26604</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3219">CVE-2022-3219</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-13844">CVE-2020-13844</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-2781">CVE-2016-2781</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2013-4235">CVE-2013-4235</a></li>
</ul></details></td>
</tr>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22049">CVE-2023-22049</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22045">CVE-2023-22045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22044">CVE-2023-22044</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22041">CVE-2023-22041</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22036">CVE-2023-22036</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22006">CVE-2023-22006</a></li>
</ul></details></td>
</tr>
<tr>
<td>apis.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44487">CVE-2023-44487</a></li>
</ul></details></td>
</tr>
<tr>
<td>app-scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-6xv5-86q9-7xr8">GHSA-6xv5-86q9-7xr8</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
</ul></details></td>
</tr>
<tr>
<td>backend.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-w37g-rhq8-7m4j">GHSA-w37g-rhq8-7m4j</a></li>
<li><a href="https://github.com/advisories/GHSA-9w3m-gqgf-c4p9">GHSA-9w3m-gqgf-c4p9</a></li>
<li><a href="https://github.com/advisories/GHSA-6mjq-h674-j845">GHSA-6mjq-h674-j845</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li>
</ul></details></td>
</tr>
<tr>
<td>base-jammy-stack-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44466">CVE-2023-44466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4273">CVE-2023-4273</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4194">CVE-2023-4194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4155">CVE-2023-4155</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4132">CVE-2023-4132</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3866">CVE-2023-3866</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3865">CVE-2023-3865</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3863">CVE-2023-3863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38432">CVE-2023-38432</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3338">CVE-2023-3338</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2156">CVE-2023-2156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1206">CVE-2023-1206</a></li>
</ul></details></td>
</tr>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-v95c-p5hm-xq8f">GHSA-v95c-p5hm-xq8f</a></li>
<li><a href="https://github.com/advisories/GHSA-m8cg-xc2p-r3fc">GHSA-m8cg-xc2p-r3fc</a></li>
<li><a href="https://github.com/advisories/GHSA-hmfx-3pcx-653p">GHSA-hmfx-3pcx-653p</a></li>
<li><a href="https://github.com/advisories/GHSA-g2j6-57v7-gm8c">GHSA-g2j6-57v7-gm8c</a></li>
<li><a href="https://github.com/advisories/GHSA-f3fp-gc8g-vw66">GHSA-f3fp-gc8g-vw66</a></li>
<li><a href="https://github.com/advisories/GHSA-6xv5-86q9-7xr8">GHSA-6xv5-86q9-7xr8</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://github.com/advisories/GHSA-259w-8hf6-59c2">GHSA-259w-8hf6-59c2</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
</ul></details></td>
</tr>
<tr>
<td>cartographer.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
</ul></details></td>
</tr>
<tr>
<td>connector.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-jgvc-jfgh-rjvv">GHSA-jgvc-jfgh-rjvv</a></li>
<li><a href="https://github.com/advisories/GHSA-7g24-qg88-p43q">GHSA-7g24-qg88-p43q</a></li>
<li><a href="https://github.com/advisories/GHSA-6mjq-h674-j845">GHSA-6mjq-h674-j845</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li>
</ul></details></td>
</tr>
<tr>
<td>crossplane.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>developer-conventions.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
</ul></details></td>
</tr>
<tr>
<td>external-secrets.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-rm8v-mxj3-5rmq">GHSA-rm8v-mxj3-5rmq</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>java-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-gwrp-pvrq-jmwv">GHSA-gwrp-pvrq-jmwv</a></li>
<li><a href="https://github.com/advisories/GHSA-gp7f-rwcx-9369">GHSA-gp7f-rwcx-9369</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36033">CVE-2022-36033</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-29425">CVE-2021-29425</a></li>
</ul></details></td>
</tr>
<tr>
<td>java-native-image-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-gwrp-pvrq-jmwv">GHSA-gwrp-pvrq-jmwv</a></li>
<li><a href="https://github.com/advisories/GHSA-gp7f-rwcx-9369">GHSA-gp7f-rwcx-9369</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36033">CVE-2022-36033</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-29425">CVE-2021-29425</a></li>
</ul></details></td>
</tr>
<tr>
<td>metadata-store.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29939">CVE-2023-29939</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29934">CVE-2023-29934</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29932">CVE-2023-29932</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-supply-chain-testing-scanning.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-p782-xgp4-8hr8">GHSA-p782-xgp4-8hr8</a></li>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5197">CVE-2023-5197</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4921">CVE-2023-4921</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4881">CVE-2023-4881</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4623">CVE-2023-4623</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4622">CVE-2023-4622</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4569">CVE-2023-4569</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-44466">CVE-2023-44466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42756">CVE-2023-42756</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42755">CVE-2023-42755</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42753">CVE-2023-42753</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42752">CVE-2023-42752</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4273">CVE-2023-4273</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4244">CVE-2023-4244</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4208">CVE-2023-4208</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4207">CVE-2023-4207</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4206">CVE-2023-4206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4194">CVE-2023-4194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4155">CVE-2023-4155</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4147">CVE-2023-4147</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4132">CVE-2023-4132</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4128">CVE-2023-4128</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-40283">CVE-2023-40283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4015">CVE-2023-4015</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4004">CVE-2023-4004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3995">CVE-2023-3995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3866">CVE-2023-3866</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3865">CVE-2023-3865</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3863">CVE-2023-3863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38546">CVE-2023-38546</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38545">CVE-2023-38545</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38432">CVE-2023-38432</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38429">CVE-2023-38429</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38428">CVE-2023-38428</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38426">CVE-2023-38426</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3777">CVE-2023-3777</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3776">CVE-2023-3776</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3611">CVE-2023-3611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3610">CVE-2023-3610</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3609">CVE-2023-3609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35829">CVE-2023-35829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35828">CVE-2023-35828</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35824">CVE-2023-35824</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35823">CVE-2023-35823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35788">CVE-2023-35788</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3567">CVE-2023-3567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35001">CVE-2023-35001</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3439">CVE-2023-3439</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34319">CVE-2023-34319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34256">CVE-2023-34256</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3390">CVE-2023-3390</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3389">CVE-2023-3389</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3355">CVE-2023-3355</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3338">CVE-2023-3338</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33288">CVE-2023-33288</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33203">CVE-2023-33203</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3268">CVE-2023-3268</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32269">CVE-2023-32269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32248">CVE-2023-32248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32233">CVE-2023-32233</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3220">CVE-2023-3220</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3212">CVE-2023-3212</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3161">CVE-2023-3161</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31436">CVE-2023-31436</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3141">CVE-2023-3141</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31248">CVE-2023-31248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3117">CVE-2023-3117</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31084">CVE-2023-31084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3090">CVE-2023-3090</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30772">CVE-2023-30772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30456">CVE-2023-30456</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2985">CVE-2023-2985</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29007">CVE-2023-29007</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2898">CVE-2023-2898</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28466">CVE-2023-28466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28322">CVE-2023-28322</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28321">CVE-2023-28321</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25815">CVE-2023-25815</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25652">CVE-2023-25652</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25588">CVE-2023-25588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25585">CVE-2023-25585</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25584">CVE-2023-25584</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2194">CVE-2023-2194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2163">CVE-2023-2163</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2162">CVE-2023-2162</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2156">CVE-2023-2156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21400">CVE-2023-21400</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21255">CVE-2023-21255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20938">CVE-2023-20938</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20593">CVE-2023-20593</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20588">CVE-2023-20588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20569">CVE-2023-20569</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1998">CVE-2023-1998</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1990">CVE-2023-1990</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1972">CVE-2023-1972</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1859">CVE-2023-1859</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1855">CVE-2023-1855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1670">CVE-2023-1670</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1611">CVE-2023-1611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1513">CVE-2023-1513</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1380">CVE-2023-1380</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1206">CVE-2023-1206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1079">CVE-2023-1079</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1078">CVE-2023-1078</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1077">CVE-2023-1077</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1076">CVE-2023-1076</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1075">CVE-2023-1075</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0459">CVE-2023-0459</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48502">CVE-2022-48502</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48425">CVE-2022-48425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47696">CVE-2022-47696</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47673">CVE-2022-47673</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40982">CVE-2022-40982</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3707">CVE-2022-3707</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27672">CVE-2022-27672</a></li>
</ul></details></td>
</tr>
<tr>
<td>policy.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-vvpx-j8f3-3w6h">GHSA-vvpx-j8f3-3w6h</a></li>
<li><a href="https://github.com/advisories/GHSA-frqx-jfcm-6jjr">GHSA-frqx-jfcm-6jjr</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
</ul></details></td>
</tr>
<tr>
<td>service-bindings.labs.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-m425-mq94-257g">GHSA-m425-mq94-257g</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
</ul></details></td>
</tr>
<tr>
<td>services-toolkit.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
</ul></details></td>
</tr>
<tr>
<td>snyk.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xpw8-rcwv-8f8p">GHSA-xpw8-rcwv-8f8p</a></li>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-jgvc-jfgh-rjvv">GHSA-jgvc-jfgh-rjvv</a></li>
<li><a href="https://github.com/advisories/GHSA-7g24-qg88-p43q">GHSA-7g24-qg88-p43q</a></li>
<li><a href="https://github.com/advisories/GHSA-57m8-f3v5-hm5m">GHSA-57m8-f3v5-hm5m</a></li>
<li><a href="https://github.com/advisories/GHSA-4374-p667-p6c8">GHSA-4374-p667-p6c8</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35116">CVE-2023-35116</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22081">CVE-2023-22081</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22025">CVE-2023-22025</a></li>
</ul></details></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-rm8v-mxj3-5rmq">GHSA-rm8v-mxj3-5rmq</a></li>
<li><a href="https://github.com/advisories/GHSA-7g45-4rm6-3mm3">GHSA-7g45-4rm6-3mm3</a></li>
<li><a href="https://github.com/advisories/GHSA-68p4-95xf-7gx8">GHSA-68p4-95xf-7gx8</a></li>
<li><a href="https://github.com/advisories/GHSA-5mg8-w23w-74h3">GHSA-5mg8-w23w-74h3</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-41053">CVE-2023-41053</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34035">CVE-2023-34035</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-8908">CVE-2020-8908</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-wg6p-jmpc-xjmr">GHSA-wg6p-jmpc-xjmr</a></li>
<li><a href="https://github.com/advisories/GHSA-j8xg-fqg3-53r7">GHSA-j8xg-fqg3-53r7</a></li>
<li><a href="https://github.com/advisories/GHSA-gpv5-7x3g-ghjv">GHSA-gpv5-7x3g-ghjv</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5197">CVE-2023-5197</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4921">CVE-2023-4921</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4911">CVE-2023-4911</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46813">CVE-2023-46813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4641">CVE-2023-4641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4623">CVE-2023-4623</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4622">CVE-2023-4622</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45863">CVE-2023-45863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4569">CVE-2023-4569</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42756">CVE-2023-42756</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42755">CVE-2023-42755</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42753">CVE-2023-42753</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4273">CVE-2023-4273</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4244">CVE-2023-4244</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4208">CVE-2023-4208</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4207">CVE-2023-4207</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4206">CVE-2023-4206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4194">CVE-2023-4194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4147">CVE-2023-4147</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4132">CVE-2023-4132</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4128">CVE-2023-4128</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4039">CVE-2023-4039</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-40283">CVE-2023-40283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-40217">CVE-2023-40217</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4010">CVE-2023-4010</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4004">CVE-2023-4004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39332">CVE-2023-39332</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39331">CVE-2023-39331</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3863">CVE-2023-3863</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3777">CVE-2023-3777</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3776">CVE-2023-3776</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-37454">CVE-2023-37454</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3640">CVE-2023-3640</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3611">CVE-2023-3611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3609">CVE-2023-3609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35829">CVE-2023-35829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35828">CVE-2023-35828</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35827">CVE-2023-35827</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35824">CVE-2023-35824</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35823">CVE-2023-35823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35788">CVE-2023-35788</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34319">CVE-2023-34319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34256">CVE-2023-34256</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3397">CVE-2023-3397</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3389">CVE-2023-3389</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3338">CVE-2023-3338</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3268">CVE-2023-3268</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3212">CVE-2023-3212</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3141">CVE-2023-3141</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3111">CVE-2023-3111</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31084">CVE-2023-31084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31082">CVE-2023-31082</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3090">CVE-2023-3090</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2898">CVE-2023-2898</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21400">CVE-2023-21400</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21255">CVE-2023-21255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20588">CVE-2023-20588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20569">CVE-2023-20569</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1380">CVE-2023-1380</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1206">CVE-2023-1206</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1075">CVE-2023-1075</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0160">CVE-2023-0160</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45061">CVE-2022-45061</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43945">CVE-2022-43945</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40982">CVE-2022-40982</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-39189">CVE-2022-39189</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3567">CVE-2022-3567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3566">CVE-2022-3566</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3344">CVE-2022-3344</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3114">CVE-2022-3114</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3108">CVE-2022-3108</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1304">CVE-2022-1304</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1280">CVE-2022-1280</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0500">CVE-2022-0500</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0391">CVE-2022-0391</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-44879">CVE-2021-44879</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-4204">CVE-2021-4204</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-4189">CVE-2021-4189</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-4149">CVE-2021-4149</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-4023">CVE-2021-4023</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-39686">CVE-2021-39686</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3847">CVE-2021-3847</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3737">CVE-2021-3737</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3733">CVE-2021-3733</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3669">CVE-2021-3669</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36087">CVE-2021-36087</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36086">CVE-2021-36086</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36085">CVE-2021-36085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-36084">CVE-2021-36084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-33560">CVE-2021-33560</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-33061">CVE-2021-33061</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-31239">CVE-2021-31239</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-36694">CVE-2020-36694</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-24504">CVE-2020-24504</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-16156">CVE-2020-16156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-12364">CVE-2020-12364</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-12363">CVE-2020-12363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-12362">CVE-2020-12362</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-10735">CVE-2020-10735</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-8457">CVE-2019-8457</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-20794">CVE-2019-20794</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-19449">CVE-2019-19449</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-16089">CVE-2019-16089</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-15794">CVE-2019-15794</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12928">CVE-2018-12928</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2015-20107">CVE-2015-20107</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-telemetry.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
</ul></details></td>
</tr>
<tr>
<td>tekton.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hp87-p4gw-j4gq">GHSA-hp87-p4gw-j4gq</a></li>
<li><a href="https://github.com/advisories/GHSA-hmfx-3pcx-653p">GHSA-hmfx-3pcx-653p</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://github.com/advisories/GHSA-2qjp-425j-52j9">GHSA-2qjp-425j-52j9</a></li>
<li><a href="https://github.com/advisories/GHSA-259w-8hf6-59c2">GHSA-259w-8hf6-59c2</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4147">CVE-2023-4147</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-40217">CVE-2023-40217</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4015">CVE-2023-4015</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4004">CVE-2023-4004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3995">CVE-2023-3995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38429">CVE-2023-38429</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38428">CVE-2023-38428</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38426">CVE-2023-38426</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3777">CVE-2023-3777</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3776">CVE-2023-3776</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3611">CVE-2023-3611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3610">CVE-2023-3610</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3609">CVE-2023-3609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35829">CVE-2023-35829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35828">CVE-2023-35828</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35824">CVE-2023-35824</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35823">CVE-2023-35823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35788">CVE-2023-35788</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3567">CVE-2023-3567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35001">CVE-2023-35001</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3439">CVE-2023-3439</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34256">CVE-2023-34256</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3390">CVE-2023-3390</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3389">CVE-2023-3389</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3358">CVE-2023-3358</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3357">CVE-2023-3357</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3355">CVE-2023-3355</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33288">CVE-2023-33288</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33203">CVE-2023-33203</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3268">CVE-2023-3268</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32269">CVE-2023-32269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32248">CVE-2023-32248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32233">CVE-2023-32233</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3220">CVE-2023-3220</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3212">CVE-2023-3212</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3161">CVE-2023-3161</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31436">CVE-2023-31436</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3141">CVE-2023-3141</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31248">CVE-2023-31248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3117">CVE-2023-3117</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31084">CVE-2023-31084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3090">CVE-2023-3090</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30772">CVE-2023-30772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30456">CVE-2023-30456</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2985">CVE-2023-2985</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29007">CVE-2023-29007</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2898">CVE-2023-2898</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28466">CVE-2023-28466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28328">CVE-2023-28328</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28322">CVE-2023-28322</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28321">CVE-2023-28321</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27538">CVE-2023-27538</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27536">CVE-2023-27536</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27535">CVE-2023-27535</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27534">CVE-2023-27534</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27533">CVE-2023-27533</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27043">CVE-2023-27043</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26607">CVE-2023-26607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26606">CVE-2023-26606</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26605">CVE-2023-26605</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26545">CVE-2023-26545</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26544">CVE-2023-26544</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25815">CVE-2023-25815</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25652">CVE-2023-25652</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25588">CVE-2023-25588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25585">CVE-2023-25585</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25584">CVE-2023-25584</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23946">CVE-2023-23946</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23916">CVE-2023-23916</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23915">CVE-2023-23915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23914">CVE-2023-23914</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23559">CVE-2023-23559</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23455">CVE-2023-23455</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23454">CVE-2023-23454</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22490">CVE-2023-22490</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2194">CVE-2023-2194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2166">CVE-2023-2166</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2163">CVE-2023-2163</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2162">CVE-2023-2162</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21400">CVE-2023-21400</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21255">CVE-2023-21255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21102">CVE-2023-21102</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20938">CVE-2023-20938</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20593">CVE-2023-20593</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2006">CVE-2023-2006</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1998">CVE-2023-1998</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1990">CVE-2023-1990</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1972">CVE-2023-1972</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1872">CVE-2023-1872</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1859">CVE-2023-1859</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1855">CVE-2023-1855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1829">CVE-2023-1829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1670">CVE-2023-1670</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1652">CVE-2023-1652</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1611">CVE-2023-1611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1513">CVE-2023-1513</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1382">CVE-2023-1382</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1380">CVE-2023-1380</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1281">CVE-2023-1281</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1195">CVE-2023-1195</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1079">CVE-2023-1079</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1078">CVE-2023-1078</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1077">CVE-2023-1077</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1076">CVE-2023-1076</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1075">CVE-2023-1075</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1074">CVE-2023-1074</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1073">CVE-2023-1073</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0468">CVE-2023-0468</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0459">CVE-2023-0459</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0458">CVE-2023-0458</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0394">CVE-2023-0394</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0386">CVE-2023-0386</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0361">CVE-2023-0361</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0266">CVE-2023-0266</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0210">CVE-2023-0210</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0179">CVE-2023-0179</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0045">CVE-2023-0045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48502">CVE-2022-48502</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4842">CVE-2022-4842</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48425">CVE-2022-48425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48424">CVE-2022-48424</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48423">CVE-2022-48423</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48303">CVE-2022-48303</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47929">CVE-2022-47929</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47696">CVE-2022-47696</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47673">CVE-2022-47673</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47521">CVE-2022-47521</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47520">CVE-2022-47520</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47519">CVE-2022-47519</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47518">CVE-2022-47518</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45869">CVE-2022-45869</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4415">CVE-2022-4415</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4382">CVE-2022-4382</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4379">CVE-2022-4379</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42329">CVE-2022-42329</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42328">CVE-2022-42328</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4139">CVE-2022-4139</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4129">CVE-2022-4129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41218">CVE-2022-41218</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40982">CVE-2022-40982</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3707">CVE-2022-3707</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36280">CVE-2022-36280</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3545">CVE-2022-3545</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3521">CVE-2022-3521</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3435">CVE-2022-3435</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3424">CVE-2022-3424</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3344">CVE-2022-3344</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3169">CVE-2022-3169</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27672">CVE-2022-27672</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2196">CVE-2022-2196</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2007-4559">CVE-2007-4559</a></li>
</ul></details></td>
</tr>
<tr>
<td>tpb.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-29858">CVE-2022-29858</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-43138">CVE-2021-43138</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-10716">CVE-2019-10716</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-10715">CVE-2019-10715</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-25076">CVE-2018-25076</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-18589">CVE-2017-18589</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2014-2980">CVE-2014-2980</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2013-1779">CVE-2013-1779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2011-5125">CVE-2011-5125</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2010-0128">CVE-2010-0128</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2009-4592">CVE-2009-4592</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2009-4591">CVE-2009-4591</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2009-4590">CVE-2009-4590</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2009-0880">CVE-2009-0880</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2009-0879">CVE-2009-0879</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2007-5612">CVE-2007-5612</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2006-4683">CVE-2006-4683</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2006-4682">CVE-2006-4682</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2006-4681">CVE-2006-4681</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2005-4708">CVE-2005-4708</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-7-0-resolved-issues'></a> v1.7.0 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-7-0-app-config-srvc-ri'></a> v1.7.0 Resolved issues: Application Configuration Service

- The pod security context now adheres to the restricted Pod Security Standard, which prevents some
  installation failures.

#### <a id='1-7-0-app-sso-ri'></a> v1.7.0 Resolved issues: Application Single Sign-On

- Authorization servers advertise only supported scopes by using the discovery
  endpoint.

- `AuthServer.spec.identityProviders.*.name` has a description.

- `AuthServer.spec.identityProviders.*.name` is validated against DNS1123.

- `ClusterUnsafeTestLogin` reconciles only if the namespace designated by `cluster_resource_namespace`
  exists.

- Correctly implements the restricted Pod Security Standard for the controller and all
  `AuthServer`-related resources.

- Authorization servers display OpenID Connect (OIDC) providers on the login page even when there
  are no SAML providers.

#### <a id='1-7-0-cnrs-ri'></a> v1.7.0 Resolved issues: Cloud Native Runtimes

- Certain combinations of app name, namespace, and domain no longer produce Knative Services with
  status `CertificateNotReady`.

#### <a id='1-7-0-scc-ri'></a> v1.7.0 Resolved issues: Supply Chain Choreographer

- You can safely ignore the label `apps.tanzu.vmware.com/carvel-package-workflow` when the
  package supply chain is deactivated. Previously, workloads with this label failed when the
  package supply chain was deactivated.

- Workloads failed on image supply chains with `multiple supply chain matches` when testing or
  scanning supply chains are side loaded with the basic supply chain. Though side loading these supply
  chains is not a supported configuration, this fix allows you to continue to create workloads.

- The package Supply Chain can now generate a Carvel package when building an image from source and
  uploading it to a private registry using a certificate.

---

### <a id='1-7-0-known-issues'></a> v1.7.0 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-7-0-api-autoreg-ki'></a> v1.7.0 Known issues: API Auto Registration

- Registering conflicting `groupId` and `version` with API portal:

  If you create two `CuratedAPIDescriptor`s with the same `groupId` and `version` combination, both
  reconcile without throwing an error, and the `/openapi?groupId&version` endpoint returns both specifications.
  If you are adding both specifications to the API portal, only one of them might show up in the
  API portal UI with a warning indicating that there is a conflict.
  If you add the route provider annotation for both of the `CuratedAPIDescriptor`s to use SCG, <!-- what is SCG? -->
  the generated API specspecification includes API routes from both `CuratedAPIDescriptor`s.

  You can see the `groupId` and `version` information from all `CuratedAPIDescriptor`s by running:

    ```console
    $ kubectl get curatedapidescriptors -A

    NAMESPACE           NAME         GROUPID            VERSION   STATUS   CURATED API SPEC URL
    my-apps             petstore     test-api-group     1.2.3     Ready    http://AAR-CONTROLLER-FQDN/openapi/my-apps/petstore
    default             mystery      test-api-group     1.2.3     Ready    http://AAR-CONTROLLER-FQDN/openapi/default/mystery
    ```

#### <a id='1-7-0-amr-obs-ce-hndlr-ki'></a> v1.7.0 Known issues: Artifact Metadata Repository Observer and CloudEvent Handler

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of
  ImageVulnerabilityScan results. There is an error on duplicate submission of identical
  ImageVulnerabilityScans you can ignore if the previous submission was successful.

- ReplicaSet status in AMR only has two states: `created` and `deleted`.
  There is a known issue where the `available` and `unavailable` state is not showing.
  The workaround is that you can interpolate this information from the `instances` metadata in the
  AMR for the ReplicaSet.

#### <a id='1-7-0-bitnami-services-ki'></a> v1.7.0 Known issues: Bitnami Services

- If you try to configure private registry integration for the Bitnami services
  after having already created a claim for one or more of the Bitnami services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshoot Bitnami Services](bitnami-services/how-to-guides/troubleshooting.hbs.md#private-reg).

#### <a id='1-7-0-crossplane-ki'></a> v1.7.0 Known issues: Crossplane

- Crossplane Providers cannot communicate with systems using a custom CA.
  For more information and a workaround, see [Troubleshoot Crossplane](./crossplane/how-to-guides/troubleshooting.hbs.md#cp-custom-cert-inject).

- The Crossplane `validatingwebhookconfiguration` is not removed when you uninstall the
  Crossplane package.
  To workaround, delete the `validatingwebhookconfiguration` manually by running
  `kubectl delete validatingwebhookconfiguration crossplane`.

#### <a id='1-7-0-eventing-ki'></a> v1.7.0 Known issues: Eventing

- When using vSphere sources in Eventing, the vsphere-source is using a high number of
  informers to alleviate load on the API server. This causes high memory use.

#### <a id='1-7-0-service-bindings-ki'></a> v1.7.0 Known issues: Service Bindings

- When upgrading Tanzu Application Platform, pods are recreated for all workloads with service bindings.
  This is because workloads and pods that use service bindings are being updated to new service
  binding volumes. This happens automatically and will not affect subsequent upgrades.

  Affected pods are updated concurrently. To avoid failures, you must have sufficient Kubernetes
  resources in your clusters to support the pod rollout.

#### <a id='1-7-0-stk-ki'></a> v1.7.0 Known issues: Services Toolkit

- An error occurs if `additionalProperties` is `true` in a CompositeResourceDefinition.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#compositeresourcedef).

#### <a id='1-7-0-scc-ki'></a> v1.7.0 Known issues: Supply Chain Choreographer

- By default, Server Workload Carvel packages generated by the Carvel package supply chains no longer
  contain OpenAPIv3 descriptions of their parameters.
  These descriptions were omitted to keep the size of the Carvel Package definition under 4&nbsp;KB,
  which is the size limit for the string output of a Tekton Task. For information about these parameters,
  see [Carvel Package Supply Chains](scc/carvel-package-supply-chain.hbs.md).

- When using the Carvel Package Supply Chains, if the operator updates the parameter
  `carvel_package.name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps
  repository that uses the old value of `carvel_package.name_suffix`. You can ignore or delete this package.

- If the size of the resulting OpenAPIv3 specification exceeds a certain size, approximately 3&nbsp;KB,
  the Supply Chain does not function. If you use the default Carvel package parameters, you this
  issue does not occur. If you use custom Carvel package parameters, you might encounter this size limit.
  If you exceed the size limit, you can either deactivate this feature, or use a workaround.
  The workaround requires enabling a Tekton feature flag. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/additional-configs/#enabling-larger-results-using-sidecar-logs).

#### <a id='1-7-0-scst-store-ki'></a> v1.7.0 Supply Chain Security Tools - Store

- SCST - Store automatically detects PostgreSQL database index corruptions.
  SCST - Store does not reconcile if it finds a PostgresSQL database index corruption issue.
  For how to fix this issue, see [Fix Postgres Database Index Corruption](scst-store/database-index-corruption.hbs.md).

- `Supply Chain Security Tools - Store` automatically detects PostgreSQL Database Index corruptions.
  Supply Chain Security Tools - Store does not reconcile if it finds a Postgres database index
  corruption issue.
  For information about remediating this issue, see [Fix Postgres Database Index Corruption](scst-store/database-index-corruption.hbs.md).

#### <a id='1-7-0-scst-scan-ki'></a> v1.7.0 Known issues: Supply Chain Security Tools (SCST) - Scan 2.0

- When using Scan 2.0 with a clusterimagetemplate other the Grype, the scanner image is being incorrectly overwritten to the Grype image by the default value from the tap values in no value for ootb_supply_chain_testing_scanning.image_scanner_cli is provided.  You can prevent this from happening by setting the value in tap values for the correct image.  For example, for the Trivy image packaged with TAP:
  this issue by providing the correct image pointing to `registry.tanzu.vmware.com` like:
  ```
  ootb_supply_chain_testing_scanning:
    image_scanner_template_name: image-vulnerability-scan-trivy
    image: registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:675673a6d495d6f6a688497b754cee304960d9ad56e194cf4f4ea6ab53ca71d6
  ```

#### <a id='1-7-0-tdp-ki'></a> v1.7.0 Known issues: Tanzu Developer Portal

- If you do not configure any authentication providers, and do not allow guest access, the following
  message appears when loading Tanzu Developer Portal in a browser:

   ```console
   No configured authentication providers. Please configure at least one.
   ```

  To resolve this issue, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#authn-not-configured).

- When viewing a supply chain with the Supply Chain Choreographer plug-in, scrolling horizontally
  does not work. Click and drag left or right instead to move the supply chain diagram. A fix is
  planned for the future. The zoom function was removed because of user feedback.

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Developer Portal.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

#### <a id='1-7-0-sc-plugin-ki'></a> v1.7.0 Known issues: Tanzu Developer Portal - Supply Chain GUI plug-in

- Any workloads created by using a custom resource definition (CRD) might not work as expected.
  Only Out of the Box (OOTB) Supply Chains are supported in the UI.

- Downloading the SBOM from a vulnerability scan requires additional configuration in
  `tap-values.yaml`. For more information, see
  [Troubleshooting](tap-gui/troubleshooting.hbs.md#sbom-not-working).

#### <a id='1-7-0-intellij-plugin-ki'></a> v1.7.0 Known issues: Tanzu Developer Tools for IntelliJ

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

#### <a id='1-7-0-vs-plugin-ki'></a> v1.7.0 Known issues: Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

#### <a id='1-7-0-vscode-plugin-ki'></a> v1.7.0 Known issues: Tanzu Developer Tools for VS Code

- In the Tanzu activity panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

---

### <a id='1-7-0-components'></a> v1.7.0 Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                     | Version                            |
| -------------------------------------------------- | ---------------------------------- |
| API Auto Registration                              |                                    |
| API portal                                         |                                    |
| Application Accelerator                            |                                    |
| Application Configuration Service                  |                                    |
| Application Live View APIServer                    |                                    |
| Application Live View back end                     |                                    |
| Application Live View connector                    |                                    |
| Application Live View conventions                  |                                    |
| Application Single Sign-On                         | 5.0.0                              |
| Aria Operations for Applications dashboard (Beta)  |                                    |
| AWS Services                                       |                                    |
| Bitnami Services                                   |                                    |
| Cartographer Conventions                           |                                    |
| cert-manager                                       | 2.4.1(contains cert-manager v1.12) |
| Cloud Native Runtimes                              | 2.4.1                              |
| Contour                                            | 1.25.2                             |
| Crossplane                                         |                                    |
| Default Roles                                      |                                    |
| Developer Conventions                              |                                    |
| External Secrets Operator                          |                                    |
| Flux CD Source Controller                          |                                    |
| Local Source Proxy                                 |                                    |
| Namespace Provisioner                              |                                    |
| Out of the Box Delivery - Basic                    |                                    |
| Out of the Box Supply Chain - Basic                |                                    |
| Out of the Box Supply Chain - Testing              |                                    |
| Out of the Box Supply Chain - Testing and Scanning |                                    |
| Out of the Box Templates                           |                                    |
| Service Bindings                                   |                                    |
| Service Registry                                   |                                    |
| Services Toolkit                                   |                                    |
| Source Controller                                  |                                    |
| Spring Boot conventions                            |                                    |
| Spring Cloud Gateway                               |                                    |
| Supply Chain Choreographer                         |                                    |
| Supply Chain Security Tools - Policy Controller    |                                    |
| Supply Chain Security Tools - Scan                 | 1.7.1                              |
| Supply Chain Security Tools - Store                |                                    |
| Tanzu Developer Portal                             |                                    |
| Tanzu Application Platform Telemetry               |                                    |
| Tanzu Build Service                                |                                    |
| Tanzu CLI                                          |                                    |
| Tanzu CLI Application Accelerator plug-in          |                                    |
| Tanzu CLI Apps plug-in                             |                                    |
| Tanzu CLI Build Service plug-in                    |                                    |
| Tanzu CLI Insight plug-in                          |                                    |
| Tanzu Service CLI plug-in                          |                                    |
| Tekton Pipelines                                   |                                    |

---

## <a id='deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features remain on this list until they are retired from Tanzu Application Platform.

### <a id="1-6-alv-deprecations"></a> Application Live View deprecations

- `appliveview_connnector.backend.sslDisabled` is deprecated and marked for removal in
  Tanzu Application Platform v1.7.0.
  For more information about the migration, see [Deprecate the sslDisabled key](app-live-view/install.hbs.md#deprecate-the-ssldisabled-key).
<!-- is this now a breaking change for 1.7? -->

### <a id='1-7-cnrs-deprecations'></a> Cloud Native Runtimes deprecations

- **`default_tls_secret` config option**: After changes in this release, this config option is moved
  to `contour.default_tls_secret`. `default_tls_secret` is marked for removal in Cloud Native Runtimes v2.7.
  In the meantime, both options are supported, and `contour.default_tls_secret` takes precedence over
  `default_tls_secret`.

- **`ingress.[internal/external].namespace` config options**: After changes in this release, these
  config options are moved to `contour.[internal/external].namespace`.
  `ingress.[internal/external].namespace` is marked for removal in Cloud Native Runtimes v2.7.
  In the meantime, both options are supported, and `contour.[internal/external].namespace` takes
  precedence over `ingress.[internal/external].namespace`.

### <a id="1-7-flux-sc-deprecations"></a> Flux CD Source Controller deprecations

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

### <a id="1-7-stk-deprecations"></a> Services Toolkit deprecations

- The `tanzu services claims` CLI plug-in command is now deprecated. It is
  hidden from help text output, but continues to work until officially removed
  after the deprecation period. The new `tanzu services resource-claims` command
  provides the same function.

### <a id="1-7-sc-deprecations"></a> Source Controller deprecations

- The Source Controller `ImageRepository` API is deprecated and is marked for
  removal in Tanzu Application Platform v1.9. Use the `OCIRepository` API instead.
  The Flux Source Controller installation includes the `OCIRepository` API.
  For more information about the `OCIRepository` API, see the
  [Flux documentation](https://fluxcd.io/flux/components/source/ocirepositories/).

### <a id='1-7-scc-deprecations'></a> Supply Chain Choreographer deprecations

- Supply Chain Choreographer no longer uses the `git_implementation` field. The `go-git` implementation
  now assumes that `libgit2` is not supported.
    - Flux CD no longer supports the `spec.gitImplementation` field as of v0.33.0. For more information,
    see the [fluxcd/source-controller Changelog](https://github.com/fluxcd/source-controller/blob/main/CHANGELOG.md#0330).
    - Existing references to the `git_implementation` field are ignored and references to `libgit2`
      do not cause failures. This is assured up to Tanzu Application Platform v1.9.
    - Azure DevOps works without specifying `git_implementation` in Tanzu Application Platform v1.7.
<!-- which of these to keep? -->

### <a id="1-7-scst-scan-deprecations"></a> Supply Chain Security Tools (SCST) - Scan deprecations

- The profile based installation of Grype to a developer namespace and related fields in the values
  file, such as `grype.namespace` and `grype.targetImagePullSecret`, are deprecated and are marked
  for removal in Tanzu Application Platform v1.8. Before removal, you can opt-in to use the profile
  based installation of Grype to a single namespace by setting `grype.namespace` in the `tap-values.yaml`
  configuration file.

### <a id="1-7-tbs-deprecations"></a> Tanzu Build Service deprecations

- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated.
  VMware plans to remove support in Tanzu Application Platform v1.8.
  To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.hbs.md#deactivate-cnb-bom).

### <a id="1-7-tekton-deprecations"></a> Tekton Pipelines deprecations

- Tekton `ClusterTask` is deprecated and marked for removal in Tanzu Application Platform v1.9.
  Use the `Task` API instead. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/deprecations/).

---

## <a id="linux-kernel-cves"></a> Linux Kernel CVEs

Kernel level vulnerabilities are regularly identified and patched by Canonical.
Tanzu Application Platform releases with available images, which might contain known vulnerabilities.
When Canonical makes patched images available, Tanzu Application Platform incorporates these fixed
images into future releases.

The kernel runs on your container host VM, not the Tanzu Application Platform container image.
Even with a patched Tanzu Application Platform image, the vulnerability is not mitigated until you
deploy your containers on a host with a patched OS. An unpatched host OS might be exploitable if
the base image is deployed.
