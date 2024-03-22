# Tanzu Application Platform Release notes

This topic contains release notes for Tanzu Application Platform v{{ vars.url_version }}.

{{#unless vars.hide_content}}

This Handlebars condition is used to hide content.

In release notes, this condition hides content that describes an unreleased patch for a released minor.

{{/unless}}


## <a id='1-9-0'></a> v1.9.0

**Release Date**: 9 April 2024

### <a id='1-9-0-whats-new'></a> What's new in Tanzu Application Platform vX.X

This release includes the following platform-wide enhancements.

#### <a id='1-9-0-new-platform-features'></a> New platform-wide features

- Feature Description.

#### <a id='1-9-0-new-components'></a> New components

- [COMPONENT-NAME-AND-LINK-TO-DOCS](): Component description.

---

### <a id='1-9-0-new-features'></a> v1.9.0 New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-9-0-COMPONENT-NAME'></a> v1.9.0 Features: COMPONENT-NAME

- Feature description.

---

### <a id='1-9-0-breaking-changes'></a> v1.9.0 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-9-0-scst-scan-bc'></a> v1.9.0 Breaking changes: Supply Chain Security Tools - Scan

- When you configure SCST - Scan with the Metadata Store CA Certificate, the secret can no longer be manually created. Configure the secret in the `values.yaml` file. For more information, see [Multicluster setup for Supply Chain Security Tools](scst-store/multicluster-setup.hbs.md#apply-kubernetes).

#### <a id='svc-toolkit-bc'></a> v1.9.0 Breaking changes: Services Toolkit

The following APIs and tools have now been removed:

* The experimental kubectl-scp plug-in.

* The experimental multicluster APIs `*.multicluster.x-tanzu.vmware.com/v1alpha1`.
  * `apiexportrolebindings.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `apiresourceimports.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `clusterapigroupimports.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `downstreamclusterlinks.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `upstreamclusterlinks.projection.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `clusterresourceexportmonitors.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `clusterresourceimportmonitors.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `resourceexportmonitorbindings.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `resourceimportmonitorbindings.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `secretexports.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`
  * `secretimports.replication.apiresources.multicluster.x-tanzu.vmware.com/v1alpha1`

#### <a id='1-9-0-fluxcd-sc-bc'></a> v1.9.0 Breaking changes: FluxCD Source Controller

- In Tanzu Application Platform v1.9.0, FluxCD Source Controller no longer supports the `git_implementation` field in `GitRepository` version `v1`.

---

### <a id='1-9-0-security-fixes'></a> v1.9.0 Security fixes

This release has the following security fixes, listed by component and area.

#### <a id='1-9-0-COMPONENT-NAME-fixes'></a> v1.9.0 Security fixes: COMPONENT-NAME

- [CVE-2023-1234](https://nvd.nist.gov/vuln/detail/CVE-2023-1234): Security fix description.

OR add HTML table

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

### <a id='1-9-0-resolved-issues'></a> v1.9.0 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-9-0-COMPONENT-NAME-ri'></a> v1.9.0 Resolved issues: COMPONENT-NAME

- Resolved issue description.

---

### <a id='1-9-0-known-issues'></a> v1.9.0 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-9-0-scst-policy-ki'></a> v1.9.0 Known issues: Supply Chain Security Tools - Policy

- Supply Chain Security Tools - Policy is defaulting to TUF enabled due to incorrect logic.
This might cause the package to not reconcile correctly if the default TUF mirrors are not reachable.
To work around this, explicitly configure policy controller in the `tap-values.yaml` file to
enable TUF:

  ```yaml
  policy:
    tuf_enabled: true
  ```

#### <a id='1-9-0-scst-store-ki'></a> v1.9.0 Known issues: Supply Chain Security Tools - Store

- SCST - Store returns an expired certificate error message when a CA certificate expires before the app certificate. For more information, see [CA Cert expires](scst-store/troubleshooting.hbs.md#ca-cert-expires).

---

### <a id='1-9-0-components'></a> v1.9.0 Component versions

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
| Managed Resource Controller (beta)                 |         |
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
| Tanzu Application Platform Telemetry               |         |
| Tanzu Build Service                                |         |
| Tanzu CLI                                          |         |
| Tanzu Developer Portal                             |         |
| Tanzu Developer Portal Configurator                |         |
| Tanzu Supply Chain (beta)                          |         |
| Tekton Pipelines                                   |         |

---

## <a id='deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features remain on this list until they are retired from Tanzu Application Platform.

### <a id='svc-toolkit-deprecations'></a> Services Toolkit deprecations

- The following APIs are deprecated and are marked for removal in
  Tanzu Application Platform v1.11:
  - `clusterexampleusages.services.apps.tanzu.vmware.com/v1alpha1`
  - `clusterresources.services.apps.tanzu.vmware.com/v1alpha1`

### <a id='fluxcd-sc-deprecations'></a> FluxCD Source Controller deprecations

- In Tanzu Application Platform v1.9.0, FluxCD Source Controller updates the `GitRepository` API from `v1beta2` to `v1`.  The controller accepts resources with API versions `v1beta1` and `v1beta2`, saving them as `v1`.
