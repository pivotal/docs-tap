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

#### <a id='1-8-0-COMPONENT-NAME'></a> v1.8.0 Features: COMPONENT-NAME

- Feature description.

#### <a id='1-8-0-crossplane'></a> v1.8.0 Features: Crossplane

- Updates Universal Crossplane to v1.14.1-up.1. For more information, see the
  [Upbound blog](https://blog.crossplane.io/crossplane-v1-14/).

---

### <a id='1-8-0-breaking-changes'></a> v1.8.0 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-8-0-apix-bc'></a> v1.8.0 Breaking changes: API Validation and Scoring

- API Validation and Scoring is removed in this release.

---

### <a id='1-8-0-security-fixes'></a> v1.8.0 Security fixes

This release has the following security fixes, listed by component and area.

| Package Name | Vulnerabilities Resolved |
| ------------ | ------------------------ |
| aws.services.tanzu.vmware.com | <ul><li> CVE-2016-2781</li><li>CVE-2020-22916</li><li>CVE-2022-27943</li><li>CVE-2022-3219</li><li>CVE-2022-3715</li><li>CVE-2022-48522</li><li>CVE-2022-4899</li><li>CVE-2023-29383</li><li>CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-36054</li><li>CVE-2023-3817</li><li>CVE-2023-39804</li><li>CVE-2023-4016</li><li>CVE-2023-4641</li><li>CVE-2023-47038</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-50495</li><li>CVE-2023-5156</li><li>CVE-2023-52426</li><li>CVE-2023-5363</li><li>CVE-2023-5981</li><li>CVE-2023-7008</li><li>CVE-2024-0553</li><li>CVE-2024-0567</li><li>CVE-2024-22365</li><li>GHSA-2c7c-3mj9-8fqh </li></ul>|
| accelerator.apps.tanzu.vmware.com | <ul><li> CVE-2022-48522</li><li>CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-36054</li><li>CVE-2023-3817</li><li>CVE-2023-39318</li><li>CVE-2023-39319</li><li>CVE-2023-39804</li><li>CVE-2023-4016</li><li>CVE-2023-47038</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>CVE-2023-5981</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-45x7-px36-x8w8</li><li>GHSA-qppj-fm5r-hxr3 </li></ul>|
| amr-observer.apps.tanzu.vmware.com | <ul><li> CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>GHSA-2wrh-6pvc-2jm9 </li></ul>|
| crossplane.tanzu.vmware.com | <ul><li> CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>GHSA-2c7c-3mj9-8fqh</li><li>GHSA-4374-p667-p6c8</li><li>GHSA-m425-mq94-257g </li></ul>|
| metadata-store.apps.tanzu.vmware.com | <ul><li> CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-36054</li><li>CVE-2023-3817</li><li>CVE-2023-39804</li><li>CVE-2023-4016</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>CVE-2023-5981</li><li>CVE-2024-0553</li><li>CVE-2024-0567</li><li>CVE-2024-22365</li><li>CVE-2021-31879 </li></ul>|
| namespace-provisioner.apps.tanzu.vmware.com | <ul><li> CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-qppj-fm5r-hxr3 </li></ul>|
| ootb-supply-chain-testing-scanning.tanzu.vmware.com | <ul><li> CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-39318</li><li>CVE-2023-39319</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-45x7-px36-x8w8</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-jq35-85cj-fj4p</li><li>GHSA-7ww5-4wqc-m92c</li><li>GHSA-6xv5-86q9-7xr8</li><li>CVE-2023-4911 </li></ul>|
| services-toolkit.tanzu.vmware.com | <ul><li> CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-5363</li><li>GHSA-4374-p667-p6c8 </li></ul>|
| buildservice.tanzu.vmware.com | <ul><li> CVE-2023-39318</li><li>CVE-2023-39319</li><li>GHSA-449p-3h89-pw88</li><li>GHSA-9763-4f94-gfch</li><li>GHSA-4v98-7qmw-rqr8</li><li>GHSA-m3r6-h7wv-7xxv</li><li>GHSA-wr6v-9f75-vh2g</li><li>GHSA-7ww5-4wqc-m92c </li></ul>|
| developer-conventions.tanzu.vmware.com | <ul><li> CVE-2023-39318</li><li>CVE-2023-39319</li><li>CVE-2023-39326</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727 </li></ul>|
| nodejs-lite.buildpacks.tanzu.vmware.com | <ul><li> CVE-2023-39318</li><li>CVE-2023-39319</li><li>CVE-2023-39326</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-qppj-fm5r-hxr3</li><li>CVE-2023-45284</li><li>CVE-2023-24532</li><li>CVE-2023-29406</li><li>CVE-2023-29409</li><li>CVE-2022-41717 </li></ul>|
| backend.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2024-20926 </li></ul>|
| connector.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156 </li></ul>|
| dotnet-core-lite.buildpacks.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>GHSA-45x7-px36-x8w8</li><li>CVE-2023-45284</li><li>GHSA-7ww5-4wqc-m92c </li></ul>|
| python-lite.buildpacks.tanzu.vmware.com | <ul><li> CVE-2023-39326 </li></ul>|
| apiserver.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156 </li></ul>|
| app-scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-qppj-fm5r-hxr3 </li></ul>|
| carbonblack.scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>GHSA-2wrh-6pvc-2jm9</li><li>CVE-2023-24532</li><li>CVE-2023-29406</li><li>CVE-2023-29409 </li></ul>|
| conventions.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156 </li></ul>|
| grype.scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>GHSA-2q89-485c-9j2x</li><li>CVE-2023-24532</li><li>CVE-2023-29406</li><li>CVE-2023-29409 </li></ul>|
| scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-qppj-fm5r-hxr3 </li></ul>|
| servicebinding.tanzu.vmware.com | <ul><li> CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156 </li></ul>|
| snyk.scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>GHSA-2wrh-6pvc-2jm9</li><li>CVE-2023-24532</li><li>CVE-2023-29406</li><li>CVE-2023-29409 </li></ul>|
| cnrs.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>GHSA-45x7-px36-x8w8 </li></ul>|
| tap-gui.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>CVE-2023-2953</li><li>CVE-2023-32250</li><li>CVE-2023-32252</li><li>CVE-2023-32257</li><li>CVE-2023-34324</li><li>CVE-2023-35827</li><li>CVE-2023-46813</li><li>CVE-2023-6039</li><li>CVE-2023-6040</li><li>CVE-2023-6606</li><li>CVE-2023-6622</li><li>CVE-2024-0641</li><li>CVE-2021-35452</li><li>CVE-2021-36408</li><li>CVE-2021-36409</li><li>CVE-2021-36410</li><li>CVE-2021-36411</li><li>CVE-2022-1253</li><li>CVE-2022-43235</li><li>CVE-2022-43236</li><li>CVE-2022-43237</li><li>CVE-2022-43238</li><li>CVE-2022-43239</li><li>CVE-2022-43240</li><li>CVE-2022-43241</li><li>CVE-2022-43242</li><li>CVE-2022-43243</li><li>CVE-2022-43248</li><li>CVE-2022-43252</li><li>CVE-2022-43253</li><li>CVE-2022-47015</li><li>CVE-2023-22084 </li></ul>|
| java-lite.buildpacks.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-jq35-85cj-fj4p</li><li>GHSA-7ww5-4wqc-m92c </li></ul>|
| java-native-image-lite.buildpacks.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>GHSA-qppj-fm5r-hxr3 </li></ul>|
| ootb-templates.tanzu.vmware.com | <ul><li> GHSA-2wrh-6pvc-2jm9</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>GHSA-9763-4f94-gfch</li><li>GHSA-7ww5-4wqc-m92c</li><li>GHSA-6xv5-86q9-7xr8 </li></ul>|
| sso.apps.tanzu.vmware.com | <ul><li> GHSA-45x7-px36-x8w8</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-7f9x-gw85-8grf</li><li>GHSA-pvcr-v8j8-j5q3</li><li>CVE-2023-42503</li><li>GHSA-cgwf-w82q-5jrr</li><li>GHSA-wjxj-5m7g-mg7q </li></ul>|
| api-portal.tanzu.vmware.com | <ul><li> CVE-2020-8908</li><li>GHSA-5mg8-w23w-74h3</li><li>GHSA-7g45-4rm6-3mm3</li><li>GHSA-jjfh-589g-3hjx</li><li>GHSA-r47r-87p9-8jh3 </li></ul>|

---

### <a id='1-8-0-resolved-issues'></a> v1.8.0 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-8-0-COMPONENT-NAME-ri'></a> v1.8.0 Resolved issues: COMPONENT-NAME

- Resolved issue description.

---

### <a id='1-8-0-known-issues'></a> v1.8.0 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-8-0-COMPONENT-NAME-ki'></a> v1.8.0 Known issues: COMPONENT-NAME

#### v1.8.0 Known issues: Service Bindings

`ServiceBinding` is not immediately reconciled when `status.binding.name` changes on a previously
bound service resource. This impacts the timely rollout of new connection secrets to workloads. The reconciler eventually picks up the change but this might take up to 10 hours.
As a temporary workaround, you can do one of the following:

- Delete the existing `ServiceBinding` and create a new one that is identical.
- Trigger reconciliation of the existing `ServiceBinding` by adding an arbitrary annotation or label.
- Delete and recreate the application workload referred to by the `ServiceBinding`.

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

---
