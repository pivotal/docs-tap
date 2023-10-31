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
  services from AWS into Tanzu Application Platform.

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
- `ClusterWorkloadRegistrationClass`s instantaneously react to updates of
  `AuthServer`s
- Insufficiently small token signature keys cause an explicit error condition in
  `AuthServer.status`.
- Customize a `ClientRegistration`'s display name.
- Customize the display names of identity providers for an `AuthServer`, with the
  restriction that this customization applies only to OpenID and Security Assertion Markup Language (SAML).
- Authorization servers log role mappings in the audit log.
- Authorization servers advertise<!--฿ |inform| or similar is likely better. ฿--> the supported client authentication and grant
  types methods by using the OpenID discovery endpoint.
- End-users<!--฿ |End users| is preferred. No hyphen. ฿--> see their email address on the consent page.
- `AuthServer.spec.cors.{allowHeaders, exposeHeaders, allowCredentials,
  allowMethods}` provide Service Operators with finer control over an
  authorization server's CORS configuration. As a result, Application Operators
  can use the `client_credentials` grant for single-page apps.
- Authorization servers do not advertise<!--฿ |inform| or similar is likely better. ฿--> the device auth<!--฿ |authentication| is preferred. ฿--> endpoint by using the
  OpenID discovery endpoint.
- Authorization server UI uses the Clarity design system.
- `ClientRegistration` uses finalizers.
- `ClusterUnsafeTestLogin` reports its issuer URI in its status and as a print
  coloumn.
- Authorization servers support the user-information endpoint.
- `AuthServer.spec.session.expiry` controls the session expiry of authorization
  servers. The default value is `15m`. It must be at least `1m`.

#### <a id='1-7-0-cert-manager'></a> v1.7.0 Features: cert-manager

- Upgrades `cert-manager.tanzu.vmware.com` to `cert-manager@1.12`.
  For more information, see the [cert-manager documentation](https://cert-manager.io/docs/release-notes/release-notes-1.12/).

#### <a id='1-7-0-cnrs'></a> v1.7.0 Features: Cloud Native Runtimes

- The new configuration option `resource_management` allows you to configure CPU and memory for both
  [Kubernetes request and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
  for all Knative Serving deployments in the `knative-serving` namespace.
  For information about how to use this configuration, see
  [Knative Serving Resource Management](cloud-native-runtimes/how-to-guides/app-operators/resource_management.hbs.md).

- **New config option `cnrs.contour.default_tls_secret`**: This option has the same meaning as `cnrs.default_tls_secret`.
  `cnrs.default_tls_secret` is deprecated in this release and will<!--฿ Avoid |will|: present tense is preferred. ฿--> be removed in Tanzu Application Platform v1.10.0, which includes Cloud Native Runtimes v2.7.0.
  In the meantime both options are supported and `cnrs.contour.default_tls_secret` takes precedence over `cnrs.default_tls_secret`.

- **New config options `cnrs.contour.[internal|external].namespace`**: These two new options behave the same as `cnrs.ingress.[internal|external].namespace`. Starting with TAP<!--฿ |Tanzu Application Platform| is preferred. ฿--> v1.7.0,
  `cnrs.ingress.[internal/external].namespace` is deprecated and will<!--฿ Avoid |will|: present tense is preferred. ฿--> be removed in Tanzu Application Platform v1.10.
  In the meantime, both options are supported, but `cnrs.contour.[internal/external].namespace` will<!--฿ Avoid |will|: present tense is preferred. ฿--> take precedence
  over `cnrs.ingress.[internal/external].namespace`.

- **New Knative Garbage Collection Defaults**: CNRs is reducing the number of revisions kept for each knative service from 20 to 5.
  This improves the knative controller's memory consumption when having several Knative services.
  Knative manages this through the config-gc ConfigMap under `knative-serving` namespace. See the [Knative documentation](https://knative.dev/docs/serving/revisions/revision-admin-config-options/). The following defaults<!--฿ |by default| is usually better. ฿--> are set for Knative garbage collection:
    - `retain-since-create-time: "48h"`: Any revision created with an age of 2 days is considered for garbage collection.
    - `retain-since-last-active-time: "15h"`: Revision that was last active at least 15 hours ago is considered for garbage collection.
    - `min-non-active-revisions: "2"`: The minimum number of inactive Revisions to retain.
    - `max-non-active-revisions: "5"`: The maximum number of inactive Revisions to retain.

  For more information about updating default values, see [Configure Garbage collection for the Knative revisions](cloud-native-runtimes/how-to-guides/garbage_collection.hbs.md).

- **Knative Serving v1.11**: Knative Serving v1.11 is available in Cloud Native Runtimes. For more information, see the [Knative v1.11 release notes](https://knative.dev/blog/releases/announcing-knative-v1-11-release/).

- **Knative Serving Migrator Job added**: CNR now runs a new job in the knative-serving<!--฿ In Knative docs, |Knative Serving| is preferred. ฿--> namespace that is responsible for ensuring that CNR uses the latest Knative Serving resource versions.

#### <a id='1-7-0-contour'></a> v1.7.0 Features: Contour

- **Contour v1.25.2**: Contour v1.25.2 is available in the TAP<!--฿ |Tanzu Application Platform| is preferred. ฿-->. For more information, see the [Contour v1.25.2 release notes](https://github.com/projectcontour/contour/releases/tag/v1.25.2) in GitHub.

- **New config option `loadBalancerTLSTermination`**: Allows configuring the Envoy service's port for TLS termination. For more information on<!--฿ |information about| is preferred. ฿--> how to use this config, see [Configure Contour to support TLS termination at an AWS Network LoadBalancer](./contour/how-to-guides/configuring-contour-with-loadbalancer-tls-termination.hbs.md)

#### <a id='1-7-0-eso'></a> v1.7.0 Features: External Secrets Operator

- External Secrets Operator has now reached General Availability.

- Adds SYNC, GET, LIST and CREATE commands to the CLI. The GET command lets you get more details
  about your external secrets and secret stores. The CREATE command lets you create cluster
  external secret and cluster secret stores. For more information, see the [Tanzu CLI Command Reference](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.0/tanzu-cli/command-ref.html) documentation.

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
  [Tanzu CLI Command Reference](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.0/tanzu-cli/command-ref.html)
  documentation.

- You can rebase vulnerability triage analyses by using the `tanzu insight triage rebase`command.
  For more information, see [Rebase multiple analyses](cli-plugins/insight/triaging-vulnerabilities.hbs.md#rebase-multiple-analyses)
  and the [Tanzu CLI Command Reference](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.0/tanzu-cli/command-ref.html) documentation.
<!-- should this now move to the main Tanzu CLI docs RNs? -->

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

#### <a id='1-7-0-cli-re-br'></a> v1.7.0 Breaking changes: Tanzu CLI command reference documenation

- The Tanzu CLI plug-in command reference documentation has moved from the Tanzu Application Platform
  documentation to the [VMware Tanzu CLI](https://docs.vmware.com/en/VMware-Tanzu-CLI/1.0/tanzu-cli/command-ref.html)
  documentation. The following Tanzu CLI plug-ins are impacted: Accelerator, Apps, Build Service,
  External Secrets, Insight, and Tanzu Service.

#### <a id='1-7-0-workloads-br'></a> v1.7.0 Breaking changes: Workloads

- Function Buildpacks for Knative and the corresponding Application Accelerator starter templates
  for Python and Java are removed in this release.

---

### <a id='1-7-0-security-fixes'></a> v1.7.0 Security fixes

This release has the following security fixes, listed by component and area.

| Package Name | Vulnerabilities Resolved |
| ------------ | ------------------------ |
| amr-observer.apps.tanzu.vmware.com | <ul><li> CVE-2016-2781</li><li>CVE-2022-3219</li><li>CVE-2023-29383</li><li>CVE-2013-4235</li><li>CVE-2020-13844</li><li>CVE-2022-3821</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-2650</li><li>CVE-2023-26604</li><li>CVE-2023-29491</li><li>CVE-2023-31484 </li></ul>|
| learningcenter.tanzu.vmware.com | <ul><li> CVE-2016-2781</li><li>CVE-2020-22916</li><li>CVE-2022-27943</li><li>CVE-2022-3219</li><li>CVE-2022-3715</li><li>CVE-2022-48522</li><li>CVE-2022-4899</li><li>CVE-2023-29383</li><li>CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-36054</li><li>CVE-2023-3817</li><li>CVE-2023-4016</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-4374-p667-p6c8</li><li>GHSA-qppj-fm5r-hxr3</li><li>CVE-2020-13844</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-2650</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>GHSA-jq35-85cj-fj4p</li><li>GHSA-m425-mq94-257g</li><li>CVE-2020-8908</li><li>CVE-2023-4911</li><li>GHSA-5mg8-w23w-74h3</li><li>GHSA-7g45-4rm6-3mm3</li><li>GHSA-6xv5-86q9-7xr8</li><li>CVE-2013-7445</li><li>CVE-2015-8553</li><li>CVE-2016-8660</li><li>CVE-2017-0537</li><li>CVE-2017-13716</li><li>CVE-2018-1000021</li><li>CVE-2018-1121</li><li>CVE-2018-12929</li><li>CVE-2018-12930</li><li>CVE-2018-12931</li><li>CVE-2018-17977</li><li>CVE-2019-1010204</li><li>CVE-2019-14899</li><li>CVE-2019-15213</li><li>CVE-2019-19378</li><li>CVE-2019-19814</li><li>CVE-2020-14304</li><li>CVE-2020-35501</li><li>CVE-2021-3826</li><li>CVE-2021-3864</li><li>CVE-2021-4095</li><li>CVE-2021-4148</li><li>CVE-2021-46195</li><li>CVE-2022-0400</li><li>CVE-2022-0480</li><li>CVE-2022-0995</li><li>CVE-2022-1247</li><li>CVE-2022-25836</li><li>CVE-2022-2961</li><li>CVE-2022-3238</li><li>CVE-2022-35205</li><li>CVE-2022-35206</li><li>CVE-2022-3523</li><li>CVE-2022-36402</li><li>CVE-2022-38096</li><li>CVE-2022-38457</li><li>CVE-2022-40133</li><li>CVE-2022-4285</li><li>CVE-2022-44840</li><li>CVE-2022-4543</li><li>CVE-2022-45703</li><li>CVE-2022-45884</li><li>CVE-2022-45885</li><li>CVE-2022-45888</li><li>CVE-2022-45919</li><li>CVE-2022-47007</li><li>CVE-2022-47008</li><li>CVE-2022-47010</li><li>CVE-2022-47011</li><li>CVE-2022-47695</li><li>CVE-2022-48063</li><li>CVE-2022-48065</li><li>CVE-2023-0030</li><li>CVE-2023-1193</li><li>CVE-2023-1194</li><li>CVE-2023-1206</li><li>CVE-2023-1989</li><li>CVE-2023-2007</li><li>CVE-2023-2156</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-25775</li><li>CVE-2023-26242</li><li>CVE-2023-28327</li><li>CVE-2023-2953</li><li>CVE-2023-31083</li><li>CVE-2023-31085</li><li>CVE-2023-32247</li><li>CVE-2023-32250</li><li>CVE-2023-32252</li><li>CVE-2023-32254</li><li>CVE-2023-32257</li><li>CVE-2023-32258</li><li>CVE-2023-3338</li><li>CVE-2023-34319</li><li>CVE-2023-34324</li><li>CVE-2023-37453</li><li>CVE-2023-3772</li><li>CVE-2023-3773</li><li>CVE-2023-38427</li><li>CVE-2023-38430</li><li>CVE-2023-38431</li><li>CVE-2023-38432</li><li>CVE-2023-38545</li><li>CVE-2023-38546</li><li>CVE-2023-3863</li><li>CVE-2023-3865</li><li>CVE-2023-3866</li><li>CVE-2023-3867</li><li>CVE-2023-39189</li><li>CVE-2023-39192</li><li>CVE-2023-39193</li><li>CVE-2023-39194</li><li>CVE-2023-4132</li><li>CVE-2023-4133</li><li>CVE-2023-4134</li><li>CVE-2023-4155</li><li>CVE-2023-4194</li><li>CVE-2023-4244</li><li>CVE-2023-4273</li><li>CVE-2023-42752</li><li>CVE-2023-42753</li><li>CVE-2023-42754</li><li>CVE-2023-42755</li><li>CVE-2023-42756</li><li>CVE-2023-44466</li><li>CVE-2023-45862</li><li>CVE-2023-45871</li><li>CVE-2023-4622</li><li>CVE-2023-4623</li><li>CVE-2023-4881</li><li>CVE-2023-4921</li><li>CVE-2023-5158</li><li>CVE-2023-5178</li><li>CVE-2023-5197</li><li>CVE-2023-5717</li><li>GHSA-259w-8hf6-59c2</li><li>GHSA-f3fp-gc8g-vw66</li><li>GHSA-g2j6-57v7-gm8c</li><li>GHSA-hmfx-3pcx-653p</li><li>GHSA-m8cg-xc2p-r3fc</li><li>GHSA-v95c-p5hm-xq8f</li><li>CVE-2023-1255</li><li>GHSA-rcjv-mgp8-qvmr</li><li>GHSA-2qjp-425j-52j9</li><li>GHSA-frqx-jfcm-6jjr</li><li>CVE-2022-36033</li><li>GHSA-gp7f-rwcx-9369</li><li>GHSA-p782-xgp4-8hr8</li><li>CVE-2007-2379</li><li>CVE-2009-3720</li><li>CVE-2012-0876</li><li>CVE-2012-1148</li><li>CVE-2015-1283</li><li>CVE-2016-0718</li><li>CVE-2016-1585</li><li>CVE-2016-4472</li><li>CVE-2018-10126</li><li>CVE-2018-20699</li><li>CVE-2019-1563</li><li>CVE-2020-13401</li><li>CVE-2020-1416</li><li>CVE-2021-23840</li><li>CVE-2021-32292</li><li>CVE-2021-40812</li><li>CVE-2022-1886</li><li>CVE-2022-32212</li><li>CVE-2022-32213</li><li>CVE-2022-32214</li><li>CVE-2022-32215</li><li>CVE-2022-3234</li><li>CVE-2022-3235</li><li>CVE-2022-3256</li><li>CVE-2022-3278</li><li>CVE-2022-3297</li><li>CVE-2022-3324</li><li>CVE-2022-3352</li><li>CVE-2022-3491</li><li>CVE-2022-3520</li><li>CVE-2022-3591</li><li>CVE-2022-3705</li><li>CVE-2022-3857</li><li>CVE-2022-40735</li><li>CVE-2022-40897</li><li>CVE-2022-40982</li><li>CVE-2022-4203</li><li>CVE-2022-4292</li><li>CVE-2022-4293</li><li>CVE-2022-4304</li><li>CVE-2022-4450</li><li>CVE-2022-45886</li><li>CVE-2022-46908</li><li>CVE-2022-48425</li><li>CVE-2022-48554</li><li>CVE-2023-0215</li><li>CVE-2023-0216</li><li>CVE-2023-0217</li><li>CVE-2023-0401</li><li>CVE-2023-0833</li><li>CVE-2023-1192</li><li>CVE-2023-1916</li><li>CVE-2023-20569</li><li>CVE-2023-20588</li><li>CVE-2023-20593</li><li>CVE-2023-21255</li><li>CVE-2023-21400</li><li>CVE-2023-23920</li><li>CVE-2023-27043</li><li>CVE-2023-28531</li><li>CVE-2023-2898</li><li>CVE-2023-31084</li><li>CVE-2023-3164</li><li>CVE-2023-32002</li><li>CVE-2023-32006</li><li>CVE-2023-3212</li><li>CVE-2023-32559</li><li>CVE-2023-32681</li><li>CVE-2023-34256</li><li>CVE-2023-34969</li><li>CVE-2023-38426</li><li>CVE-2023-38428</li><li>CVE-2023-38429</li><li>CVE-2023-39331</li><li>CVE-2023-39332</li><li>CVE-2023-40283</li><li>CVE-2023-4128</li><li>CVE-2023-4206</li><li>CVE-2023-4207</li><li>CVE-2023-4208</li><li>CVE-2023-43785</li><li>CVE-2023-43786</li><li>CVE-2023-43787</li><li>CVE-2023-43788</li><li>CVE-2023-43789</li><li>CVE-2023-4563</li><li>CVE-2023-4569</li><li>CVE-2023-4733</li><li>CVE-2023-4734</li><li>CVE-2023-4735</li><li>CVE-2023-4750</li><li>CVE-2023-4751</li><li>CVE-2023-4752</li><li>CVE-2023-4781</li><li>CVE-2023-4807</li><li>CVE-2023-4863</li><li>CVE-2023-5344</li><li>CVE-2023-5441</li><li>CVE-2023-5535</li><li>GHSA-45rm-2893-5f49</li><li>GHSA-5ffw-gxpp-mxpf</li><li>GHSA-5j5w-g665-5m35</li><li>GHSA-5rcv-m4m3-hfh7</li><li>GHSA-77vh-xpmg-72qh</li><li>GHSA-c2h3-6mxw-7mvq</li><li>GHSA-c2qf-rxjj-qqgw</li><li>GHSA-cgcv-5272-97pr</li><li>GHSA-f9jg-8p32-2f55</li><li>GHSA-gxpj-cx7g-858c</li><li>GHSA-h86h-8ppg-mxmh</li><li>GHSA-qc2g-gmh6-95p4</li><li>GHSA-qq97-vm5h-rrhg</li><li>GHSA-r88r-gmrh-7j83</li><li>GHSA-w33c-445m-f8w7</li><li>GHSA-wx77-rp39-c6vg</li><li>GHSA-wxc4-f4m6-wwqv</li><li>GHSA-xc8m-28vv-4pjc</li><li>CVE-2013-20001</li><li>CVE-2021-31879</li><li>GHSA-gc89-7gcr-jxqc</li><li>CVE-2023-43804</li><li>CVE-2023-45803</li><li>GHSA-45c4-8wx5-qw6w</li><li>GHSA-g4mx-q9vg-27p4</li><li>GHSA-v845-jxx5-vc9f</li><li>CVE-2023-5590</li><li>GHSA-43fp-rhv2-5gv8</li><li>GHSA-5cpq-8wj7-hf2v</li><li>GHSA-7fh5-64p2-3v2j</li><li>GHSA-j8r2-6x86-q33q</li><li>GHSA-jm77-qphf-c4w8</li><li>GHSA-rrm6-wvj7-cwh2</li><li>GHSA-v8gr-m533-ghj9</li><li>GHSA-w7pp-m8wf-vj6r</li><li>GHSA-xqr8-7jwr-rhp7 </li></ul>|
| workshops.learningcenter.tanzu.vmware.com | <ul><li> CVE-2016-2781</li><li>CVE-2022-3715</li><li>CVE-2022-4899</li><li>CVE-2023-29383</li><li>CVE-2023-3446</li><li>CVE-2023-36054</li><li>CVE-2023-3817</li><li>CVE-2023-4016</li><li>CVE-2023-29491</li><li>CVE-2023-31484</li><li>CVE-2023-4911</li><li>CVE-2023-44487</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2021-36084</li><li>CVE-2021-36085</li><li>CVE-2021-36086</li><li>CVE-2021-36087</li><li>CVE-2023-4039</li><li>CVE-2019-8457</li><li>CVE-2020-16156</li><li>CVE-2021-33560</li><li>CVE-2022-1304</li><li>CVE-2023-45853</li><li>CVE-2023-4641 </li></ul>|
| eventing.tanzu.vmware.com | <ul><li> CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-4374-p667-p6c8</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-m425-mq94-257g </li></ul>|
| tap-gui.tanzu.vmware.com | <ul><li> CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-29491</li><li>CVE-2023-31484</li><li>CVE-2023-4911</li><li>CVE-2023-1206</li><li>CVE-2023-3338</li><li>CVE-2023-34319</li><li>CVE-2023-3863</li><li>CVE-2023-4132</li><li>CVE-2023-4194</li><li>CVE-2023-4244</li><li>CVE-2023-4273</li><li>CVE-2023-42753</li><li>CVE-2023-42755</li><li>CVE-2023-42756</li><li>CVE-2023-4622</li><li>CVE-2023-4623</li><li>CVE-2023-4921</li><li>CVE-2023-5197</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2022-40982</li><li>CVE-2022-45886</li><li>CVE-2023-1192</li><li>CVE-2023-20569</li><li>CVE-2023-20588</li><li>CVE-2023-21255</li><li>CVE-2023-21400</li><li>CVE-2023-2898</li><li>CVE-2023-31084</li><li>CVE-2023-3212</li><li>CVE-2023-34256</li><li>CVE-2023-39331</li><li>CVE-2023-39332</li><li>CVE-2023-40283</li><li>CVE-2023-4128</li><li>CVE-2023-4206</li><li>CVE-2023-4207</li><li>CVE-2023-4208</li><li>CVE-2023-4569</li><li>CVE-2022-4269</li><li>CVE-2023-0597</li><li>CVE-2023-1075</li><li>CVE-2023-1380</li><li>CVE-2023-2002</li><li>CVE-2023-2124</li><li>CVE-2023-2269</li><li>CVE-2023-3090</li><li>CVE-2023-3141</li><li>CVE-2023-3268</li><li>CVE-2023-3389</li><li>CVE-2023-35788</li><li>CVE-2023-35823</li><li>CVE-2023-35824</li><li>CVE-2023-35828</li><li>CVE-2023-35829</li><li>CVE-2023-3609</li><li>CVE-2023-3611</li><li>CVE-2023-3776</li><li>CVE-2023-3777</li><li>CVE-2023-4004</li><li>CVE-2023-4147</li><li>CVE-2021-36084</li><li>CVE-2021-36085</li><li>CVE-2021-36086</li><li>CVE-2021-36087</li><li>CVE-2023-4039</li><li>CVE-2015-20107</li><li>CVE-2018-12928</li><li>CVE-2019-15794</li><li>CVE-2019-16089</li><li>CVE-2019-19449</li><li>CVE-2019-20794</li><li>CVE-2019-8457</li><li>CVE-2020-10735</li><li>CVE-2020-12362</li><li>CVE-2020-12363</li><li>CVE-2020-12364</li><li>CVE-2020-16156</li><li>CVE-2020-24504</li><li>CVE-2020-36694</li><li>CVE-2021-31239</li><li>CVE-2021-33061</li><li>CVE-2021-33560</li><li>CVE-2021-3669</li><li>CVE-2021-3733</li><li>CVE-2021-3737</li><li>CVE-2021-3847</li><li>CVE-2021-39686</li><li>CVE-2021-4023</li><li>CVE-2021-4149</li><li>CVE-2021-4189</li><li>CVE-2021-4204</li><li>CVE-2021-44879</li><li>CVE-2022-0391</li><li>CVE-2022-0500</li><li>CVE-2022-1280</li><li>CVE-2022-1304</li><li>CVE-2022-3108</li><li>CVE-2022-3114</li><li>CVE-2022-3344</li><li>CVE-2022-3566</li><li>CVE-2022-3567</li><li>CVE-2022-39189</li><li>CVE-2022-43945</li><li>CVE-2022-45061</li><li>CVE-2022-45887</li><li>CVE-2023-0160</li><li>CVE-2023-24329</li><li>CVE-2023-31082</li><li>CVE-2023-3111</li><li>CVE-2023-3397</li><li>CVE-2023-35827</li><li>CVE-2023-3640</li><li>CVE-2023-37454</li><li>CVE-2023-4010</li><li>CVE-2023-40217</li><li>CVE-2023-45863</li><li>CVE-2023-4641</li><li>CVE-2023-46813</li><li>CVE-2023-46862</li><li>GHSA-gpv5-7x3g-ghjv</li><li>GHSA-j8xg-fqg3-53r7</li><li>GHSA-wg6p-jmpc-xjmr </li></ul>|
| api-portal.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>CVE-2023-22006</li><li>CVE-2023-22036</li><li>CVE-2023-22041</li><li>CVE-2023-22044</li><li>CVE-2023-22045</li><li>CVE-2023-22049</li><li>CVE-2023-4911 </li></ul>|
| apis.apps.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>CVE-2023-44487 </li></ul>|
| cartographer.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>GHSA-4374-p667-p6c8</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p </li></ul>|
| developer-conventions.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>CVE-2023-2650</li><li>CVE-2023-1255 </li></ul>|
| external-secrets.apps.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-2650</li><li>CVE-2022-3996</li><li>CVE-2023-1255</li><li>GHSA-rm8v-mxj3-5rmq </li></ul>|
| policy.apps.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>GHSA-frqx-jfcm-6jjr</li><li>GHSA-vvpx-j8f3-3w6h </li></ul>|
| service-bindings.labs.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>GHSA-4374-p667-p6c8</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-m425-mq94-257g </li></ul>|
| services-toolkit.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9 </li></ul>|
| tap-telemetry.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9 </li></ul>|
| spring-cloud-gateway.tanzu.vmware.com | <ul><li> GHSA-4374-p667-p6c8</li><li>GHSA-qppj-fm5r-hxr3</li><li>CVE-2023-35116</li><li>CVE-2023-4911</li><li>GHSA-57m8-f3v5-hm5m</li><li>GHSA-xpw8-rcwv-8f8p</li><li>GHSA-7g24-qg88-p43q</li><li>GHSA-jgvc-jfgh-rjvv</li><li>CVE-2023-22025</li><li>CVE-2023-22081 </li></ul>|
| accelerator.apps.tanzu.vmware.com | <ul><li> CVE-2012-2098</li><li>CVE-2023-22006</li><li>CVE-2023-22036</li><li>CVE-2023-22041</li><li>CVE-2023-22044</li><li>CVE-2023-22045</li><li>CVE-2023-22049</li><li>GHSA-6fxm-66hq-fc96</li><li>GHSA-hrmr-f5m6-m9pq </li></ul>|
| tekton.tanzu.vmware.com | <ul><li> CVE-2022-3821</li><li>CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-2650</li><li>CVE-2023-29491</li><li>CVE-2023-31484</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>GHSA-259w-8hf6-59c2</li><li>GHSA-hmfx-3pcx-653p</li><li>CVE-2022-3996</li><li>CVE-2023-1255</li><li>GHSA-2qjp-425j-52j9</li><li>CVE-2022-40982</li><li>CVE-2022-45886</li><li>CVE-2022-48425</li><li>CVE-2023-1192</li><li>CVE-2023-20593</li><li>CVE-2023-21255</li><li>CVE-2023-21400</li><li>CVE-2023-27043</li><li>CVE-2023-2898</li><li>CVE-2023-31084</li><li>CVE-2023-3212</li><li>CVE-2023-34256</li><li>CVE-2023-38426</li><li>CVE-2023-38428</li><li>CVE-2023-38429</li><li>CVE-2022-27672</li><li>CVE-2022-3707</li><li>CVE-2022-4269</li><li>CVE-2022-47673</li><li>CVE-2022-47696</li><li>CVE-2022-48502</li><li>CVE-2023-0459</li><li>CVE-2023-0597</li><li>CVE-2023-1075</li><li>CVE-2023-1076</li><li>CVE-2023-1077</li><li>CVE-2023-1078</li><li>CVE-2023-1079</li><li>CVE-2023-1380</li><li>CVE-2023-1513</li><li>CVE-2023-1611</li><li>CVE-2023-1667</li><li>CVE-2023-1670</li><li>CVE-2023-1855</li><li>CVE-2023-1859</li><li>CVE-2023-1972</li><li>CVE-2023-1990</li><li>CVE-2023-1998</li><li>CVE-2023-2002</li><li>CVE-2023-20938</li><li>CVE-2023-2124</li><li>CVE-2023-2162</li><li>CVE-2023-2163</li><li>CVE-2023-2194</li><li>CVE-2023-2235</li><li>CVE-2023-2269</li><li>CVE-2023-2283</li><li>CVE-2023-23004</li><li>CVE-2023-25012</li><li>CVE-2023-25584</li><li>CVE-2023-25585</li><li>CVE-2023-25588</li><li>CVE-2023-25652</li><li>CVE-2023-25815</li><li>CVE-2023-2602</li><li>CVE-2023-2603</li><li>CVE-2023-2612</li><li>CVE-2023-28321</li><li>CVE-2023-28322</li><li>CVE-2023-28466</li><li>CVE-2023-29007</li><li>CVE-2023-2985</li><li>CVE-2023-30456</li><li>CVE-2023-30772</li><li>CVE-2023-3090</li><li>CVE-2023-3117</li><li>CVE-2023-31248</li><li>CVE-2023-3141</li><li>CVE-2023-31436</li><li>CVE-2023-3161</li><li>CVE-2023-3220</li><li>CVE-2023-32233</li><li>CVE-2023-32248</li><li>CVE-2023-32269</li><li>CVE-2023-3268</li><li>CVE-2023-33203</li><li>CVE-2023-33288</li><li>CVE-2023-3355</li><li>CVE-2023-3389</li><li>CVE-2023-3390</li><li>CVE-2023-3439</li><li>CVE-2023-35001</li><li>CVE-2023-3567</li><li>CVE-2023-35788</li><li>CVE-2023-35823</li><li>CVE-2023-35824</li><li>CVE-2023-35828</li><li>CVE-2023-35829</li><li>CVE-2023-3609</li><li>CVE-2023-3610</li><li>CVE-2023-3611</li><li>CVE-2023-3776</li><li>CVE-2023-3777</li><li>CVE-2023-3995</li><li>CVE-2023-4004</li><li>CVE-2023-4015</li><li>CVE-2023-4147</li><li>CVE-2022-3344</li><li>CVE-2023-24329</li><li>CVE-2023-40217</li><li>CVE-2007-4559</li><li>CVE-2022-2196</li><li>CVE-2022-3169</li><li>CVE-2022-3424</li><li>CVE-2022-3435</li><li>CVE-2022-3521</li><li>CVE-2022-3545</li><li>CVE-2022-36280</li><li>CVE-2022-41218</li><li>CVE-2022-4129</li><li>CVE-2022-4139</li><li>CVE-2022-42328</li><li>CVE-2022-42329</li><li>CVE-2022-4379</li><li>CVE-2022-4382</li><li>CVE-2022-4415</li><li>CVE-2022-45869</li><li>CVE-2022-47518</li><li>CVE-2022-47519</li><li>CVE-2022-47520</li><li>CVE-2022-47521</li><li>CVE-2022-47929</li><li>CVE-2022-48303</li><li>CVE-2022-4842</li><li>CVE-2022-48423</li><li>CVE-2022-48424</li><li>CVE-2023-0045</li><li>CVE-2023-0179</li><li>CVE-2023-0210</li><li>CVE-2023-0266</li><li>CVE-2023-0361</li><li>CVE-2023-0386</li><li>CVE-2023-0394</li><li>CVE-2023-0458</li><li>CVE-2023-0461</li><li>CVE-2023-0468</li><li>CVE-2023-1073</li><li>CVE-2023-1074</li><li>CVE-2023-1195</li><li>CVE-2023-1281</li><li>CVE-2023-1382</li><li>CVE-2023-1652</li><li>CVE-2023-1829</li><li>CVE-2023-1872</li><li>CVE-2023-2006</li><li>CVE-2023-21102</li><li>CVE-2023-2166</li><li>CVE-2023-22490</li><li>CVE-2023-23454</li><li>CVE-2023-23455</li><li>CVE-2023-23559</li><li>CVE-2023-23914</li><li>CVE-2023-23915</li><li>CVE-2023-23916</li><li>CVE-2023-23946</li><li>CVE-2023-26544</li><li>CVE-2023-26545</li><li>CVE-2023-26605</li><li>CVE-2023-26606</li><li>CVE-2023-26607</li><li>CVE-2023-27533</li><li>CVE-2023-27534</li><li>CVE-2023-27535</li><li>CVE-2023-27536</li><li>CVE-2023-27538</li><li>CVE-2023-28328</li><li>CVE-2023-3357</li><li>CVE-2023-3358</li><li>GHSA-hp87-p4gw-j4gq </li></ul>|
| buildservice.tanzu.vmware.com | <ul><li> CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-2650</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>CVE-2023-4911</li><li>GHSA-6xv5-86q9-7xr8</li><li>GHSA-259w-8hf6-59c2</li><li>GHSA-f3fp-gc8g-vw66</li><li>GHSA-g2j6-57v7-gm8c</li><li>GHSA-hmfx-3pcx-653p</li><li>GHSA-m8cg-xc2p-r3fc</li><li>GHSA-v95c-p5hm-xq8f</li><li>CVE-2022-3996</li><li>CVE-2023-1255 </li></ul>|
| crossplane.tanzu.vmware.com | <ul><li> CVE-2023-0464</li><li>CVE-2023-0465</li><li>CVE-2023-2650</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>CVE-2022-3996</li><li>CVE-2023-1255 </li></ul>|
| ootb-templates.tanzu.vmware.com | <ul><li> CVE-2023-2650</li><li>CVE-2023-29491</li><li>CVE-2023-31484</li><li>GHSA-2q89-485c-9j2x</li><li>CVE-2023-1206</li><li>CVE-2023-2156</li><li>CVE-2023-3338</li><li>CVE-2023-34319</li><li>CVE-2023-38432</li><li>CVE-2023-38545</li><li>CVE-2023-38546</li><li>CVE-2023-3863</li><li>CVE-2023-3865</li><li>CVE-2023-3866</li><li>CVE-2023-4132</li><li>CVE-2023-4155</li><li>CVE-2023-4194</li><li>CVE-2023-4244</li><li>CVE-2023-4273</li><li>CVE-2023-42752</li><li>CVE-2023-42753</li><li>CVE-2023-42755</li><li>CVE-2023-42756</li><li>CVE-2023-44466</li><li>CVE-2023-4622</li><li>CVE-2023-4623</li><li>CVE-2023-4881</li><li>CVE-2023-4921</li><li>CVE-2023-5197</li><li>CVE-2023-1255</li><li>GHSA-p782-xgp4-8hr8</li><li>CVE-2022-40982</li><li>CVE-2022-45886</li><li>CVE-2022-48425</li><li>CVE-2023-1192</li><li>CVE-2023-20569</li><li>CVE-2023-20588</li><li>CVE-2023-20593</li><li>CVE-2023-21255</li><li>CVE-2023-21400</li><li>CVE-2023-2898</li><li>CVE-2023-31084</li><li>CVE-2023-3212</li><li>CVE-2023-34256</li><li>CVE-2023-38426</li><li>CVE-2023-38428</li><li>CVE-2023-38429</li><li>CVE-2023-40283</li><li>CVE-2023-4128</li><li>CVE-2023-4206</li><li>CVE-2023-4207</li><li>CVE-2023-4208</li><li>CVE-2023-4569</li><li>CVE-2022-27672</li><li>CVE-2022-3707</li><li>CVE-2022-4269</li><li>CVE-2022-47673</li><li>CVE-2022-47696</li><li>CVE-2022-48502</li><li>CVE-2023-0459</li><li>CVE-2023-0597</li><li>CVE-2023-1075</li><li>CVE-2023-1076</li><li>CVE-2023-1077</li><li>CVE-2023-1078</li><li>CVE-2023-1079</li><li>CVE-2023-1380</li><li>CVE-2023-1513</li><li>CVE-2023-1611</li><li>CVE-2023-1667</li><li>CVE-2023-1670</li><li>CVE-2023-1855</li><li>CVE-2023-1859</li><li>CVE-2023-1972</li><li>CVE-2023-1990</li><li>CVE-2023-1998</li><li>CVE-2023-2002</li><li>CVE-2023-20938</li><li>CVE-2023-2124</li><li>CVE-2023-2162</li><li>CVE-2023-2163</li><li>CVE-2023-2194</li><li>CVE-2023-2235</li><li>CVE-2023-2269</li><li>CVE-2023-2283</li><li>CVE-2023-23004</li><li>CVE-2023-25012</li><li>CVE-2023-25584</li><li>CVE-2023-25585</li><li>CVE-2023-25588</li><li>CVE-2023-25652</li><li>CVE-2023-25815</li><li>CVE-2023-2602</li><li>CVE-2023-2603</li><li>CVE-2023-2612</li><li>CVE-2023-28321</li><li>CVE-2023-28322</li><li>CVE-2023-28466</li><li>CVE-2023-29007</li><li>CVE-2023-2985</li><li>CVE-2023-30456</li><li>CVE-2023-30772</li><li>CVE-2023-3090</li><li>CVE-2023-3117</li><li>CVE-2023-31248</li><li>CVE-2023-3141</li><li>CVE-2023-31436</li><li>CVE-2023-3161</li><li>CVE-2023-3220</li><li>CVE-2023-32233</li><li>CVE-2023-32248</li><li>CVE-2023-32269</li><li>CVE-2023-3268</li><li>CVE-2023-33203</li><li>CVE-2023-33288</li><li>CVE-2023-3355</li><li>CVE-2023-3389</li><li>CVE-2023-3390</li><li>CVE-2023-3439</li><li>CVE-2023-35001</li><li>CVE-2023-3567</li><li>CVE-2023-35788</li><li>CVE-2023-35823</li><li>CVE-2023-35824</li><li>CVE-2023-35828</li><li>CVE-2023-35829</li><li>CVE-2023-3609</li><li>CVE-2023-3610</li><li>CVE-2023-3611</li><li>CVE-2023-3776</li><li>CVE-2023-3777</li><li>CVE-2023-3995</li><li>CVE-2023-4004</li><li>CVE-2023-4015</li><li>CVE-2023-4147 </li></ul>|
| app-scanning.apps.tanzu.vmware.com | <ul><li> GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>GHSA-2q89-485c-9j2x</li><li>GHSA-6xv5-86q9-7xr8 </li></ul>|
| carbonblack.scanning.apps.tanzu.vmware.com | <ul><li> GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p </li></ul>|
| snyk.scanning.apps.tanzu.vmware.com | <ul><li> GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p </li></ul>|
| sso.apps.tanzu.vmware.com | <ul><li> CVE-2020-8908</li><li>GHSA-5mg8-w23w-74h3</li><li>GHSA-7g45-4rm6-3mm3</li><li>GHSA-rm8v-mxj3-5rmq</li><li>CVE-2023-34035</li><li>GHSA-68p4-95xf-7gx8</li><li>CVE-2023-41053 </li></ul>|
| base-jammy-stack-lite.buildpacks.tanzu.vmware.com | <ul><li> CVE-2023-4911</li><li>CVE-2023-1206</li><li>CVE-2023-2156</li><li>CVE-2023-3338</li><li>CVE-2023-38432</li><li>CVE-2023-3863</li><li>CVE-2023-3865</li><li>CVE-2023-3866</li><li>CVE-2023-4132</li><li>CVE-2023-4155</li><li>CVE-2023-4194</li><li>CVE-2023-4273</li><li>CVE-2023-44466 </li></ul>|
| ootb-supply-chain-testing-scanning.tanzu.vmware.com | <ul><li> GHSA-2q89-485c-9j2x </li></ul>|
| backend.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-20863</li><li>GHSA-6mjq-h674-j845</li><li>GHSA-9w3m-gqgf-c4p9</li><li>GHSA-w37g-rhq8-7m4j </li></ul>|
| connector.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-20863</li><li>GHSA-6mjq-h674-j845</li><li>GHSA-7g24-qg88-p43q</li><li>GHSA-jgvc-jfgh-rjvv </li></ul>|
| java-lite.buildpacks.tanzu.vmware.com | <ul><li> CVE-2023-20863</li><li>CVE-2021-29425</li><li>CVE-2022-36033</li><li>GHSA-gp7f-rwcx-9369</li><li>GHSA-gwrp-pvrq-jmwv </li></ul>|
| java-native-image-lite.buildpacks.tanzu.vmware.com | <ul><li> CVE-2023-20863</li><li>CVE-2021-29425</li><li>CVE-2022-36033</li><li>GHSA-gp7f-rwcx-9369</li><li>GHSA-gwrp-pvrq-jmwv </li></ul>|
| metadata-store.apps.tanzu.vmware.com | <ul><li> CVE-2023-29932</li><li>CVE-2023-29934</li><li>CVE-2023-29939 </li></ul>|
| tpb.tanzu.vmware.com | <ul><li> CVE-2005-4708</li><li>CVE-2006-4681</li><li>CVE-2006-4682</li><li>CVE-2006-4683</li><li>CVE-2007-5612</li><li>CVE-2009-0879</li><li>CVE-2009-0880</li><li>CVE-2009-4590</li><li>CVE-2009-4591</li><li>CVE-2009-4592</li><li>CVE-2010-0128</li><li>CVE-2011-5125</li><li>CVE-2013-1779</li><li>CVE-2014-2980</li><li>CVE-2017-18589</li><li>CVE-2018-25076</li><li>CVE-2019-10715</li><li>CVE-2019-10716</li><li>CVE-2021-43138</li><li>CVE-2022-29858 </li></ul>|

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

- Certain app name, namespace, and domain combinations no longer produce Knative Services with
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

  - If you create two `CuratedAPIDescriptor`s with the same `groupId` and `version`
  combination, both reconcile successfully<!--฿ Redundant word? ฿--> without throwing an error,
  and the `/openapi?groupId&version` endpoint returns both specs<!--฿ |specifications| is preferred. ฿-->.
  - If you are adding both specs<!--฿ |specifications| is preferred. ฿--> to API portal, only one of them might show up in
  the API portal UI with a warning indicating that there is a conflict.
  - If you add the route provider annotation for both of the `CuratedAPIDescriptor`s to use SCG,
  the generated API spec<!--฿ |specifications| is preferred. ฿--> includes API routes from both `CuratedAPIDescriptor`s.
  - You can see the `groupId` and `version` information from all `CuratedAPIDescriptor`s by running:

    ```console
    $ kubectl get curatedapidescriptors -A

    NAMESPACE           NAME         GROUPID            VERSION   STATUS   CURATED API SPEC URL
    my-apps             petstore     test-api-group     1.2.3     Ready    http://AAR-CONTROLLER-FQDN/openapi/my-apps/petstore
    default             mystery      test-api-group     1.2.3     Ready    http://AAR-CONTROLLER-FQDN/openapi/default/mystery
    ```

#### <a id='1-7-0-service-bindings-ki'></a> v1.7.0 Known issues: Service Bindings

- When upgrading Tanzu Application Platform, pods are recreated for all workloads with service bindings.
  This is because workloads and pods that use service bindings are being updated to new service
  binding volumes. This happens automatically and will not affect subsequent upgrades.

  Affected pods are updated concurrently. To avoid failures, you must have sufficient Kubernetes
  resources in your clusters to support the pod rollout.

#### <a id='1-7-0-scc-ki'></a> v1.7.0 Known issues: Supply Chain Choreographer

- By default, Server Workload Carvel packages generated by the Carvel package supply chains no longer
  contain OpenAPIv3 descriptions of their parameters.
  These descriptions were omitted to keep the size of the Carvel Package definition under 4&nbsp;KB,
  which is the size limit for the string output of a Tekton Task. For information about these parameters,
  see [Carvel Package Supply Chains](scc/carvel-package-supply-chain.hbs.md).

#### <a id='1-7-0-scst-store-ki'></a> v1.7.0 Known issues: Supply Chain Security Tools (SCST) - Store

- SCST - Store automatically detects PostgreSQL database index corruptions.
  SCST - Store does not reconcile if it finds a PostgresSQL database index corruption issue.
  For how to fix this issue, see [Fix Postgres Database Index Corruption](scst-store/database-index-corruption.hbs.md).

#### <a id='1-7-0-tdp-ki'></a> v1.7.0 Known issues: Tanzu Developer Portal

- If you do not configure any authentication providers, and do not allow guest access, the following
  message appears when loading Tanzu Developer Portal in a browser:

   ```console
   No configured authentication providers. Please configure at least one.
   ```

  To resolve this issue, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#authn-not-configured).

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
  to `contour.default_tls_secret`. `default_tls_secret` is marked for removal in Cloud Native Runtimes v2.7.0.
  In the meantime, both options are supported, and `contour.default_tls_secret` takes precedence over
  `default_tls_secret`.

- **`ingress.[internal/external].namespace` config options**: After changes in this release, these
  config options are moved to `contour.[internal/external].namespace`.
  `ingress.[internal/external].namespace` is marked for removal in Cloud Native Runtimes v2.7.0.
  In the meantime, both options are supported, and `contour.[internal/external].namespace` takes
  precedence over `ingress.[internal/external].namespace`.

### <a id="1-6-flux-sc-deprecations"></a> Flux CD Source Controller deprecations

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
<!-- which of these to keep? -->

### <a id="1-6-stk-deprecations"></a> Services Toolkit deprecations

- The `tanzu services claims` CLI plug-in command is now deprecated. It is
  hidden from help text output, but continues to work until officially removed
  after the deprecation period. The new `tanzu services resource-claims` command
  provides the same function.
<!-- has this been removed yet? when is the deprecation period over? -->

### <a id="1-7-sc-deprecations"></a> Source Controller deprecations

- The Source Controller `ImageRepository` API is deprecated and is marked for
  removal in Tanzu Application Platform v1.9. Use the `OCIRepository` API instead.
  The Flux Source Controller installation includes the `OCIRepository` API.
  For more information about the `OCIRepository` API, see the
  [Flux documentation](https://fluxcd.io/flux/components/source/ocirepositories/).

### <a id='1-6-scc-deprecations'></a> Supply Chain Choreographer deprecations

- Supply Chain Choreographer no longer uses the `git_implementation` field. The `go-git` implementation
  now assumes that `libgit2` is not supported.
    - Flux CD no longer supports the `spec.gitImplementation` field as of v0.33.0. For more information,
    see the [fluxcd/source-controller Changelog](https://github.com/fluxcd/source-controller/blob/main/CHANGELOG.md#0330).
    - Existing references to the `git_implementation` field are ignored and references to `libgit2`
      do not cause failures. This is assured up to Tanzu Application Platform v1.9.0.
    - Azure DevOps works without specifying `git_implementation` in Tanzu Application Platform v1.6.1.
<!-- which of these to keep? -->

### <a id="1-7-scst-scan-deprecations"></a> Supply Chain Security Tools (SCST) - Scan deprecations

- The profile based installation of Grype to a developer namespace and related fields in the values
  file, such as `grype.namespace` and `grype.targetImagePullSecret`, are deprecated and are marked
  for removal in Tanzu Application Platform v1.8. Before removal, you can opt-in to use the profile
  based installation of Grype to a single namespace by setting `grype.namespace` in the `tap-values.yaml`
  configuration file.

### <a id="1-6-tbs-deprecations"></a> Tanzu Build Service deprecations

- The Ubuntu Bionic stack is deprecated: Ubuntu Bionic stops receiving support in April 2023.
  VMware recommends you migrate builds to Jammy stacks in advance.
  For how to migrate builds, see [Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).
<!-- should I remove the above notice? -->

- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated.
  VMware plans to deactivate this format by default in Tanzu Application Platform v1.6.1 and remove
  support in Tanzu Application Platform v1.7.0.
  To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).
<!-- is this now a breaking change for 1.7? -->

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
