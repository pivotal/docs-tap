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

<table>
<thead>
<tr>
<th>Package name</th>
<th>Vulnerabilities resolved</th>
</tr>
</thead>
<tbody>
<tr>
<td>PACKAGE.tanzu.vmware.com</td>
<td>
<details><summary>Expand to see the list</summary>
<ul>
<li><a href="https://github.com/advisories/GHSA-xxxx-xxxx-xxxx">GHSA-xxxx-xxxx-xxxx</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-12345">CVE-2023-12345</a></li>
</ul>
</details>
</td>
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

- When viewing a supply chain with the Supply Chain Choreographer plug-in, scrolling horizontally
  does not work. Click and drag left or right instead to move the supply chain diagram. A fix is
  planned for the future. The zoom function was removed because of user feedback.

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
