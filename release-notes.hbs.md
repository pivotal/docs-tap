# Tanzu Application Platform release notes

This topic describes the changes in Tanzu Application Platform (commonly known as TAP)
v{{ vars.url_version }}.

## <a id='1-7-0'></a> v1.7.0

**Release Date**: 10 October 2023

### <a id='1-7-0-whats-new'></a> What's new in Tanzu Application Platform v1.7

This release includes the following platform-wide enhancements.

#### <a id='1-7-0-new-platform-features'></a> New platform-wide features

- Feature Description.

#### <a id='1-7-0-new-components'></a> New components

- [COMPONENT-NAME-AND-LINK-TO-DOCS](): Component description.

---

### <a id='1-7-0-new-features'></a> v1.7.0 New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-7-0-COMPONENT-NAME'></a> v1.7.0 features: COMPONENT-NAME

- Feature description.

#### <a id='1-7-0-cnrs'></a> v1.7.0 features: Cloud Native Runtimes

- **New config option `contour.default_tls_secret`**: VMware is deprecating the current `default_tls_secret` config option.
  This new option has the same meaning as `default_tls_secret`. Both config options will be supported for some releases.

- **New config options `contour.[internal/external].namespace`**: VMware is deprecating the current `ingress.[internal/external].namespace` config options.
  This new options have the same meaning as `ingress.[internal/external].namespace`. Both config options will be
  supported for some releases.

---

### <a id='1-7-0-breaking-changes'></a> v1.7.0 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-7-0-COMPONENT-NAME-bc'></a> v1.7.0 breaking changes: COMPONENT-NAME

- Breaking change description.

---

### <a id='1-7-0-security-fixes'></a> v1.7.0 Security fixes

This release has the following security fixes, listed by component and area.

#### <a id='1-7-0-COMPONENT-NAME-fixes'></a> v1.7.0 security fixes: COMPONENT-NAME

- Security fix description.

OR add HTML or Markdown table

<table>
<tr>
<th>Package name</th>
<th>Vulnerabilities resolved</th>
</tr>
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
</table>

---

### <a id='1-7-0-resolved-issues'></a> v1.7.0 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-7-0-COMPONENT-NAME-ri'></a> v1.7.0 resolved issues: COMPONENT-NAME

- Resolved issue description.

---

### <a id='1-7-0-known-issues'></a> v1.7.0 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-7-0-COMPONENT-NAME-ki'></a> v1.7.0 known issues: COMPONENT-NAME

- Known issue description with link to workaround.

---

### <a id='1-7-0-components'></a> v1.7.0 Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                                   | Version |
| ---------------------------------------------------------------- | ------- |
| API Auto Registration                                            |         |
| API portal                                                       |         |
| Application Accelerator                                          |         |
| Application Configuration Service                                |         |
| Application Live View APIServer                                  |         |
| Application Live View back end                                   |         |
| Application Live View connector                                  |         |
| Application Live View conventions                                |         |
| Application Single Sign-On                                       |         |
| Authentication and authorization                                 |         |
| Bitnami Services                                                 |         |
| Cartographer Conventions                                         |         |
| cert-manager                                                     |         |
| Cloud Native Runtimes                                            |         |
| Contour                                                          |         |
| Crossplane                                                       |         |
| Developer Conventions                                            |         |
| Eventing                                                         |         |
| Flux CD Source Controller                                        |         |
| Local Source Proxy                                               |         |
| Namespace Provisioner                                            |         |
| Out of the Box Delivery - Basic                                  |         |
| Out of the Box Supply Chain - Basic                              |         |
| Out of the Box Supply Chain - Testing                            |         |
| Out of the Box Supply Chain - Testing and Scanning               |         |
| Out of the Box Templates                                         |         |
| Service Bindings                                                 |         |
| Services Toolkit                                                 |         |
| Source Controller                                                |         |
| Spring Boot conventions                                          |         |
| Spring Cloud Gateway                                             |         |
| Supply Chain Choreographer                                       |         |
| Supply Chain Security Tools - Policy Controller                  |         |
| Supply Chain Security Tools - Scan                               |         |
| Supply Chain Security Tools - Store                              |         |
| Tanzu Developer Portal                                           |         |
| Tanzu Application Platform Telemetry                             |         |
| Tanzu Build Service                                              |         |
| Tanzu CLI                                                        |         |
| Tanzu CLI Application Accelerator plug-in                        |         |
| Tanzu CLI Apps plug-in                                           |         |
| Tanzu CLI Build Service plug-in                                  |         |
| Tanzu CLI Insight plug-in                                        |         |
| Tanzu Service CLI plug-in                                        |         |
| Tekton Pipelines                                                 |         |

---

## <a id='deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features remain on this list until they are retired from Tanzu Application Platform.

### <a id='COMPONENT-NAME-deprecations'></a> COMPONENT-NAME deprecations

- Deprecation description including the release when the feature will be removed.

---
