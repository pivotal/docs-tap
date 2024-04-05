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

#### <a id='1-9-0-app-acc'></a> v1.9.0 Features: Application Accelerator

- Accelerator authors can use IntelliJ or VS Code to create accelerators using the local authoring
  experience without connecting to a Tanzu Application Platform cluster.
  For more information, see [Use a local Application Accelerator engine server](application-accelerator/creating-accelerators/using-local-engine-server.hbs.md).

- Adds the Spring AI Chat sample accelerator, which provides a sample application you can use to
  quickly start development of a web application for AI chat based on Spring AI.
  This web application offers an interactive chat experience that uses Retrieval Augmented Generation (RAG)
  to enable a user to ask questions about their uploaded documents. For more information, see
  [Spring AI Chat Sample Accelerator](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/spring-ai-chat).

#### <a id='1-9-0-app-live-view'></a> v1.9.0 Features: Application Live View

- By default, Application Live View connector is deployed as a Deployment to discover applications
  across all namespaces running in a worker node of a Kubernetes cluster.
  This overrides the previous behavior where the connector was deployed as a DaemonSet, which made the
  Kubernetes scheduling pattern unpredictable when a node restarts. For more information, see
  [Connector deployment modes in Application Live View](app-live-view/connector-deployment-modes.hbs.md).

#### <a id='1-9-0-bitnami-service'></a> v1.9.0 Features: Bitnami Services

- Introduces the package value `claim_namespace`, which enables you to create services in the same
  namespace as the originating claim.
  You can set this value globally or on a specific service. For more information, see
  [Package values of Bitnami Services](bitnami-services/reference/package-values.hbs.md).

#### <a id='1-9-0-services-toolkit'></a> v1.9.0 Features: Services Toolkit

- You can configure resource limits and requests for the Services Toolkit Controller Manager
  and Services Toolkit Resource Claims API Server deployments through the package values.
  For more information, see [Scalability](scalability.hbs.md).

#### <a id='1-9-0-tanzu-dev-portal'></a> v1.9.0 Features: Tanzu Developer Portal

- The DORA plug-in now has the following changes:
  - Added the date range drop-down menu filters **Last 7 Days** and **Last 30 Days**
  - The default date range filter is now **Last 7 Days** instead of **Last 90 Days**
  - Earlier filters have more accurate names: **This Week** is now **Week to Date**, **This Month**
    is now **Month to Date**, and **This Quarter** is now **Quarter to Date**
  - Added percentage values to show improvements or declines in metrics when compared with the
    previous time period
  - Added graphs to display changes in Lead Time and Deployment Frequency metrics over time
  - Performance improvements
- Added configuration to route traffic through a specified HTTP/HTTPS proxy. This includes all outgoing requests made by Backstage and Tanzu Developer Portal. For more information, see [Configure HTTP Proxy documentation](tap-gui/http-proxy.hbs.md).

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
<li><a href="https://github.com/advisories/GHSA-8r3f-844c-mc37">GHSA-8r3f-844c-mc37</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-26308">CVE-2024-26308</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-25710">CVE-2024-25710</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-22365">CVE-2024-22365</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0567">CVE-2024-0567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0553">CVE-2024-0553</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4641">CVE-2023-4641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>alm-catalog.component.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28085">CVE-2024-28085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24855">CVE-2024-24855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-2398">CVE-2024-2398</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0607">CVE-2024-0607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0565">CVE-2024-0565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0340">CVE-2024-0340</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6915">CVE-2023-6915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6121">CVE-2023-6121</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51782">CVE-2023-51782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51780">CVE-2023-51780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51779">CVE-2023-51779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-50868">CVE-2023-50868</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-50387">CVE-2023-50387</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46343">CVE-2023-46343</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4134">CVE-2023-4134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32247">CVE-2023-32247</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48065">CVE-2022-48065</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48063">CVE-2022-48063</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47695">CVE-2022-47695</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>apis.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
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
<td>apiserver.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>app-scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>application-configuration-service.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-6qvw-249j-h44c">GHSA-6qvw-249j-h44c</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-20926">CVE-2024-20926</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
</ul></details></td>
</tr>
<tr>
<td>aws.services.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-h626-pv66-hhm7">GHSA-h626-pv66-hhm7</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4782">CVE-2023-4782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45287">CVE-2023-45287</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39319">CVE-2023-39319</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39318">CVE-2023-39318</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29409">CVE-2023-29409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29406">CVE-2023-29406</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29403">CVE-2023-29403</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1732">CVE-2023-1732</a></li>
</ul></details></td>
</tr>
<tr>
<td>backend.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24785">CVE-2024-24785</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24784">CVE-2024-24784</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24783">CVE-2024-24783</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45290">CVE-2023-45290</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45289">CVE-2023-45289</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-24823">CVE-2022-24823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-43797">CVE-2021-43797</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-21409">CVE-2021-21409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-21295">CVE-2021-21295</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-21290">CVE-2021-21290</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2014-3488">CVE-2014-3488</a></li>
</ul></details></td>
</tr>
<tr>
<td>base-jammy-stack-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24855">CVE-2024-24855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1086">CVE-2024-1086</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1085">CVE-2024-1085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0646">CVE-2024-0646</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0607">CVE-2024-0607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0565">CVE-2024-0565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0340">CVE-2024-0340</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6915">CVE-2023-6915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6121">CVE-2023-6121</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51782">CVE-2023-51782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51781">CVE-2023-51781</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51780">CVE-2023-51780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51779">CVE-2023-51779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46343">CVE-2023-46343</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4134">CVE-2023-4134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32247">CVE-2023-32247</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48065">CVE-2022-48065</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48063">CVE-2022-48063</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47695">CVE-2022-47695</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>cartographer.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xw73-rw38-6vjc">GHSA-xw73-rw38-6vjc</a></li>
</ul></details></td>
</tr>
<tr>
<td>connector.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-wjxj-5m7g-mg7q">GHSA-wjxj-5m7g-mg7q</a></li>
<li><a href="https://github.com/advisories/GHSA-w33c-445m-f8w7">GHSA-w33c-445m-f8w7</a></li>
<li><a href="https://github.com/advisories/GHSA-jjfh-589g-3hjx">GHSA-jjfh-589g-3hjx</a></li>
<li><a href="https://github.com/advisories/GHSA-hr8g-6v94-x4m9">GHSA-hr8g-6v94-x4m9</a></li>
<li><a href="https://github.com/advisories/GHSA-cgwf-w82q-5jrr">GHSA-cgwf-w82q-5jrr</a></li>
<li><a href="https://github.com/advisories/GHSA-6qvw-249j-h44c">GHSA-6qvw-249j-h44c</a></li>
<li><a href="https://github.com/advisories/GHSA-5jpm-x58v-624v">GHSA-5jpm-x58v-624v</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-29025">CVE-2024-29025</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-26308">CVE-2024-26308</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-25710">CVE-2024-25710</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42503">CVE-2023-42503</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35116">CVE-2023-35116</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34462">CVE-2023-34462</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-24823">CVE-2022-24823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-43797">CVE-2021-43797</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-21409">CVE-2021-21409</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-21295">CVE-2021-21295</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-21290">CVE-2021-21290</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2014-3488">CVE-2014-3488</a></li>
</ul></details></td>
</tr>
<tr>
<td>contour.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6780">CVE-2023-6780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45284">CVE-2023-45284</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>controller.source.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xw73-rw38-6vjc">GHSA-xw73-rw38-6vjc</a></li>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-jq35-85cj-fj4p">GHSA-jq35-85cj-fj4p</a></li>
<li><a href="https://github.com/advisories/GHSA-8r3f-844c-mc37">GHSA-8r3f-844c-mc37</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
</ul></details></td>
</tr>
<tr>
<td>conventions.appliveview.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24785">CVE-2024-24785</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24784">CVE-2024-24784</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24783">CVE-2024-24783</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45290">CVE-2023-45290</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45289">CVE-2023-45289</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>conventions.component.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24855">CVE-2024-24855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1086">CVE-2024-1086</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1085">CVE-2024-1085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0646">CVE-2024-0646</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0607">CVE-2024-0607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0565">CVE-2024-0565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0340">CVE-2024-0340</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6915">CVE-2023-6915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6121">CVE-2023-6121</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51782">CVE-2023-51782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51781">CVE-2023-51781</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51780">CVE-2023-51780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51779">CVE-2023-51779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46343">CVE-2023-46343</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4134">CVE-2023-4134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32247">CVE-2023-32247</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48065">CVE-2022-48065</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48063">CVE-2022-48063</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47695">CVE-2022-47695</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>crossplane.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>fluxcd.source.controller.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-r53h-jv2g-vpx6">GHSA-r53h-jv2g-vpx6</a></li>
<li><a href="https://github.com/advisories/GHSA-frqx-jfcm-6jjr">GHSA-frqx-jfcm-6jjr</a></li>
<li><a href="https://github.com/advisories/GHSA-6xv5-86q9-7xr8">GHSA-6xv5-86q9-7xr8</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://github.com/advisories/GHSA-2wrh-6pvc-2jm9">GHSA-2wrh-6pvc-2jm9</a></li>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5363">CVE-2023-5363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5156">CVE-2023-5156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4813">CVE-2023-4813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4806">CVE-2023-4806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46737">CVE-2023-46737</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3817">CVE-2023-3817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3446">CVE-2023-3446</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2975">CVE-2023-2975</a></li>
</ul></details></td>
</tr>
<tr>
<td>git-writer.component.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24855">CVE-2024-24855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1086">CVE-2024-1086</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1085">CVE-2024-1085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0646">CVE-2024-0646</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0607">CVE-2024-0607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0565">CVE-2024-0565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0340">CVE-2024-0340</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6915">CVE-2023-6915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6121">CVE-2023-6121</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51782">CVE-2023-51782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51781">CVE-2023-51781</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51780">CVE-2023-51780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51779">CVE-2023-51779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4641">CVE-2023-4641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46343">CVE-2023-46343</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4134">CVE-2023-4134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32247">CVE-2023-32247</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48065">CVE-2022-48065</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48063">CVE-2022-48063</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47695">CVE-2022-47695</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>go-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-mq39-4gv4-mvpx">GHSA-mq39-4gv4-mvpx</a></li>
<li><a href="https://github.com/advisories/GHSA-m5m3-46gj-wch8">GHSA-m5m3-46gj-wch8</a></li>
<li><a href="https://github.com/advisories/GHSA-jq35-85cj-fj4p">GHSA-jq35-85cj-fj4p</a></li>
<li><a href="https://github.com/advisories/GHSA-hmfx-3pcx-653p">GHSA-hmfx-3pcx-653p</a></li>
<li><a href="https://github.com/advisories/GHSA-7ww5-4wqc-m92c">GHSA-7ww5-4wqc-m92c</a></li>
<li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li>
<li><a href="https://github.com/advisories/GHSA-2qjp-425j-52j9">GHSA-2qjp-425j-52j9</a></li>
<li><a href="https://github.com/advisories/GHSA-259w-8hf6-59c2">GHSA-259w-8hf6-59c2</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-29018">CVE-2024-29018</a></li>
</ul></details></td>
</tr>
<tr>
<td>java-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xw73-rw38-6vjc">GHSA-xw73-rw38-6vjc</a></li>
<li><a href="https://github.com/advisories/GHSA-8r3f-844c-mc37">GHSA-8r3f-844c-mc37</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
</ul></details></td>
</tr>
<tr>
<td>java-native-image-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
</ul></details></td>
</tr>
<tr>
<td>metadata-store.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-qppj-fm5r-hxr3">GHSA-qppj-fm5r-hxr3</a></li>
<li><a href="https://github.com/advisories/GHSA-m425-mq94-257g">GHSA-m425-mq94-257g</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-25062">CVE-2024-25062</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-supply-chain-testing-scanning.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xw73-rw38-6vjc">GHSA-xw73-rw38-6vjc</a></li>
<li><a href="https://github.com/advisories/GHSA-v53g-5gjp-272r">GHSA-v53g-5gjp-272r</a></li>
<li><a href="https://github.com/advisories/GHSA-jw44-4f3j-q396">GHSA-jw44-4f3j-q396</a></li>
<li><a href="https://github.com/advisories/GHSA-9p26-698r-w4hx">GHSA-9p26-698r-w4hx</a></li>
<li><a href="https://github.com/advisories/GHSA-8r3f-844c-mc37">GHSA-8r3f-844c-mc37</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-50868">CVE-2023-50868</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-50387">CVE-2023-50387</a></li>
</ul></details></td>
</tr>
<tr>
<td>policy.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
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
<td>service-registry.spring.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
</ul></details></td>
</tr>
<tr>
<td>servicebinding.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
</ul></details></td>
</tr>
<tr>
<td>services-toolkit.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
</ul></details></td>
</tr>
<tr>
<td>source.component.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-8r3f-844c-mc37">GHSA-8r3f-844c-mc37</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24855">CVE-2024-24855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1086">CVE-2024-1086</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1085">CVE-2024-1085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0646">CVE-2024-0646</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0607">CVE-2024-0607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0565">CVE-2024-0565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0340">CVE-2024-0340</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6915">CVE-2023-6915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6121">CVE-2023-6121</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51782">CVE-2023-51782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51781">CVE-2023-51781</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51780">CVE-2023-51780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51779">CVE-2023-51779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4641">CVE-2023-4641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46343">CVE-2023-46343</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4134">CVE-2023-4134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32247">CVE-2023-32247</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48065">CVE-2022-48065</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48063">CVE-2022-48063</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47695">CVE-2022-47695</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-boot-conventions.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
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
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-ccgv-vj62-xf9h">GHSA-ccgv-vj62-xf9h</a></li>
<li><a href="https://github.com/advisories/GHSA-4g9r-vxhx-9pgx">GHSA-4g9r-vxhx-9pgx</a></li>
<li><a href="https://github.com/advisories/GHSA-4265-ccf5-phj5">GHSA-4265-ccf5-phj5</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-26308">CVE-2024-26308</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-25710">CVE-2024-25710</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24785">CVE-2024-24785</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24784">CVE-2024-24784</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24783">CVE-2024-24783</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24549">CVE-2024-24549</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-23672">CVE-2024-23672</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4641">CVE-2023-4641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45290">CVE-2023-45290</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-45289">CVE-2023-45289</a></li>
</ul></details></td>
</tr>
<tr>
<td>supply-chain-catalog.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24855">CVE-2024-24855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1086">CVE-2024-1086</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1085">CVE-2024-1085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0646">CVE-2024-0646</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0607">CVE-2024-0607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0565">CVE-2024-0565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0340">CVE-2024-0340</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6915">CVE-2023-6915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6121">CVE-2023-6121</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51782">CVE-2023-51782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51781">CVE-2023-51781</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51780">CVE-2023-51780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51779">CVE-2023-51779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46343">CVE-2023-46343</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4134">CVE-2023-4134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32247">CVE-2023-32247</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48065">CVE-2022-48065</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48063">CVE-2022-48063</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47695">CVE-2022-47695</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xvch-5gv4-984h">GHSA-xvch-5gv4-984h</a></li>
<li><a href="https://github.com/advisories/GHSA-ww39-953v-wcq6">GHSA-ww39-953v-wcq6</a></li>
<li><a href="https://github.com/advisories/GHSA-vh95-rmgr-6w4m">GHSA-vh95-rmgr-6w4m</a></li>
<li><a href="https://github.com/advisories/GHSA-p6mc-m468-83gw">GHSA-p6mc-m468-83gw</a></li>
<li><a href="https://github.com/advisories/GHSA-6xwr-q98w-rvg7">GHSA-6xwr-q98w-rvg7</a></li>
<li><a href="https://github.com/advisories/GHSA-2fc9-xpp8-2g9h">GHSA-2fc9-xpp8-2g9h</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-25062">CVE-2024-25062</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24855">CVE-2024-24855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24806">CVE-2024-24806</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-22667">CVE-2024-22667</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0985">CVE-2024-0985</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0607">CVE-2024-0607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0565">CVE-2024-0565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0340">CVE-2024-0340</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6915">CVE-2023-6915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6277">CVE-2023-6277</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6228">CVE-2023-6228</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6121">CVE-2023-6121</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52356">CVE-2023-52356</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51782">CVE-2023-51782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51780">CVE-2023-51780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51779">CVE-2023-51779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-50868">CVE-2023-50868</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-50387">CVE-2023-50387</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-49468">CVE-2023-49468</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-49467">CVE-2023-49467</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-49465">CVE-2023-49465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-47471">CVE-2023-47471</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46343">CVE-2023-46343</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-43887">CVE-2023-43887</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4134">CVE-2023-4134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32247">CVE-2023-32247</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27103">CVE-2023-27103</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27102">CVE-2023-27102</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25221">CVE-2023-25221</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24758">CVE-2023-24758</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24757">CVE-2023-24757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24756">CVE-2023-24756</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24755">CVE-2023-24755</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24754">CVE-2023-24754</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24752">CVE-2023-24752</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24751">CVE-2023-24751</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48624">CVE-2022-48624</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47665">CVE-2022-47665</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43250">CVE-2022-43250</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43249">CVE-2022-43249</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43245">CVE-2022-43245</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-43244">CVE-2022-43244</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>tekton.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-9763-4f94-gfch">GHSA-9763-4f94-gfch</a></li>
<li><a href="https://github.com/advisories/GHSA-7ww5-4wqc-m92c">GHSA-7ww5-4wqc-m92c</a></li>
<li><a href="https://github.com/advisories/GHSA-45x7-px36-x8w8">GHSA-45x7-px36-x8w8</a></li>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
<li><a href="https://github.com/advisories/GHSA-2c7c-3mj9-8fqh">GHSA-2c7c-3mj9-8fqh</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-24855">CVE-2024-24855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1086">CVE-2024-1086</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-1085">CVE-2024-1085</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0727">CVE-2024-0727</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0646">CVE-2024-0646</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0641">CVE-2024-0641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0607">CVE-2024-0607</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0565">CVE-2024-0565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0340">CVE-2024-0340</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-0193">CVE-2024-0193</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6932">CVE-2023-6932</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6931">CVE-2023-6931</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6915">CVE-2023-6915</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6817">CVE-2023-6817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6622">CVE-2023-6622</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6606">CVE-2023-6606</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6237">CVE-2023-6237</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6176">CVE-2023-6176</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6129">CVE-2023-6129</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6121">CVE-2023-6121</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6040">CVE-2023-6040</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-6039">CVE-2023-6039</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-5678">CVE-2023-5678</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51782">CVE-2023-51782</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51781">CVE-2023-51781</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51780">CVE-2023-51780</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-51779">CVE-2023-51779</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46862">CVE-2023-46862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46813">CVE-2023-46813</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4641">CVE-2023-4641</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-46343">CVE-2023-46343</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4134">CVE-2023-4134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-39326">CVE-2023-39326</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35827">CVE-2023-35827</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34324">CVE-2023-34324</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32257">CVE-2023-32257</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32252">CVE-2023-32252</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32250">CVE-2023-32250</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32247">CVE-2023-32247</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2953">CVE-2023-2953</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1732">CVE-2023-1732</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48065">CVE-2022-48065</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48063">CVE-2022-48063</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47695">CVE-2022-47695</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
<tr>
<td>tpb.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-xvch-5gv4-984h">GHSA-xvch-5gv4-984h</a></li>
<li><a href="https://github.com/advisories/GHSA-ww39-953v-wcq6">GHSA-ww39-953v-wcq6</a></li>
<li><a href="https://github.com/advisories/GHSA-vh95-rmgr-6w4m">GHSA-vh95-rmgr-6w4m</a></li>
<li><a href="https://github.com/advisories/GHSA-6xwr-q98w-rvg7">GHSA-6xwr-q98w-rvg7</a></li>
</ul></details></td>
</tr>
<tr>
<td>trivy.app-scanning.component.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2024-28757">CVE-2024-28757</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-52425">CVE-2023-52425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li>
</ul></details></td>
</tr>
</tbody>
</table>

---

### <a id='1-9-0-resolved-issues'></a> v1.9.0 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-9-0-alm-ri'></a> v1.9.0 Resolved issues: App Last Mile Catalog

- Resolved an issue where the Deployer component output an error message that was larger than 4&nbsp;KB.
  This caused a Tekton error. The Deployer component now outputs a smaller error message that is
  human readable.

#### <a id='1-9-0-aws-services'></a> v1.9.0 Resolved issues: AWS Services

- Updated the `endpoint` key name in the binding secret for Amazon MQ (RabbitMQ) claims to `addresses`
  so that it matches the name that the [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings) library uses.
  This key name change is not applied to any existing Amazon MQ (RabbitMQ) claims.
  If new Amazon MQ (RabbitMQ) claims still do not have the updated `addresses` key name, see
  [Troubleshoot AWS Services](aws-services/how-to-guides/troubleshooting.hbs.md).

#### <a id='1-9-0-crossplane'></a> v1.9.0 Resolved issues: Crossplane

- Fixed an issue that you might encounter if you uninstall and reinstall the Crossplane
  package on the same cluster. You no longer receive a TLS certificate verification error with
  service claims never transitioning to `READY=True`.

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

#### <a id='1-9-0-scst-scan-ki'></a> v1.9.0 Known issues: Supply Chain Security Tools - Scan

- When using Supply Chain Security Tools (SCST) - Scan 2.0 with a ClusterImageTemplate, the value for
  the scanning image is overwritten with an incorrect default value from
  `ootb_supply_chain_testing_scanning.image_scanner_cli` in the `tap-values.yaml` file.
  You can prevent this by setting the value in your `tap-values.yaml` file to the correct image.
  For example, for the Grype image packaged with Tanzu Application Platform:

    ```yaml
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: image-vulnerability-scan-grype
      image_scanning_cli:
        image: registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:feb1cdbd5c918aae7a89bdb2aa39d486bf6ffc81000764b522842e5934578497
    ```

#### <a id='1-9-0-scst-store-ki'></a> v1.9.0 Known issues: Supply Chain Security Tools - Store

- SCST - Store returns an expired certificate error message when a CA certificate expires before the app certificate. For more information, see [CA Cert expires](scst-store/troubleshooting.hbs.md#ca-cert-expires).


#### <a id='1-9-0-ssc-ui-ki'></a> v1.9.0 Known issues: Supply Chain UI

- When you select the **Supply Chains** tab in Tanzu Developer Portal, you might encounter an error
related to `data.packaging.carvel.dev`. The error message is related to permission issues
and JSON parsing errors. The error message indicates that the user `system:serviceaccount:tap-gui:tap-gui-viewer` cannot list resource `packages` in the API group `data.packaging.carvel.dev` at the cluster scope. Additionally, an unexpected non-whitespace character
is reported after JSON at position 4.

  As a temporary workaround, apply an RBAC configuration that includes the get, watch, and list
  permissions for the resources in the `data.packaging.carvel.dev` API group. This workaround should
  not be mandated for supply chains that do not generate Carvel packages.

  To eliminate the error message, configure RBAC to allow access to the Carvel package resource as
  follows:

  ```console
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRole
  - apiGroups: [data.packaging.carvel.dev]
    resources: [packages]
    verbs: ['get', 'watch', 'list']
  ```

#### <a id='1-9-0-tdp-ki'></a>v1.9.0 Known issues: Tanzu Developer Portal

- [ScmAuth](https://backstage.io/docs/reference/integration-react.scmauth/) is a Backstage concept
  that abstracts Source Code Management (SCM) authentication into a package. An oversight in a
  recent code-base migration led to the accidental exclusion of custom ScmAuth functions. This
  exclusion affected some client operations, such as using Application Accelerators to create Git
  repositories on behalf of users. A fix for this issue is planned for the next patch.

#### <a id='1-9-0-cartographer-conventions'></a>v1.9.0 Known issues: Cartographer Conventions

- Prior to TAP 1.9.0 the "cartographer.tanzu.vmware.com" package contained two products:
  "Cartographer" itself and "Cartographer Conventions".  In TAP 1.9.0 the "Cartographer Conventions"
  product has been removed from the "cartographer.tanzu.vmware.com" package and will be distributed
  in its own package: "cartographer.conventions.apps.tanzu.vmware.com".

  During an upgrade from TAP < 1.9.0 to TAP >= 1.9.0 an issue may occur when installing the new
  package for "Cartographer Conventions".  The upgrade may fail to reconcile and show error messages
  similar to the following:

    Resource 'clusterrole/cartographer-conventions-manager-role (rbac.authorization.k8s.io/v1) cluster' is already associated with a different app 'cartographer.app'

  This message may appear more than once and it can refer to several different resources.

  These errors appear when "kapp-controller" on the cluster tries to install the new "Cartographer
  Conventions" package before the "Cartographer" packge itself is finished being reconciled; the
  new package for "Cartographer Conventions" tries to install resources that the existing
  "Cartographer" package still owns.

  Although it looks like the upgrade fails, if you wait a few minutes, "kapp-controller" finishes
  the install and the packages will reconcile successfully.  The system should work normally after
  the reconcilation is complete.

  This error does not occur on a new installation of TAP 1.9.0.

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