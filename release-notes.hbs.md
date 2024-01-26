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

---

### <a id='1-8-0-breaking-changes'></a> v1.8.0 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-8-0-apix-bc'></a> v1.8.0 Breaking changes: API Validation and Scoring

- API Validation and Scoring is removed in this release.

---

### <a id='1-8-0-security-fixes'></a> v1.8.0 Security fixes

This release has the following security fixes, listed by component and area.

#### <a id='1-8-0-COMPONENT-NAME-fixes'></a> v1.8.0 Security fixes: COMPONENT-NAME

- Security fix description.

OR add HTML or Markdown table

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
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xxxx-xxxx-xxxx">GHSA-xxxx-xxxx-xxxx</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-12345">CVE-2023-12345</a></li>
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
| Supply Chain Security Tools - Scan 2.0 (beta)      |         |
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

### <a id='services-toolkit-deprecations'></a> Services Toolkit deprecations

- The following experimental APIs are marked as deprecated and will be removed in
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

---
