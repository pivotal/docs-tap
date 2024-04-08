# Tanzu Application Platform Release notes

This topic contains release notes for Tanzu Application Platform v{{ vars.url_version }}.

{{#unless vars.hide_content}}

This Handlebars condition is used to hide content.

In release notes, this condition hides content that describes an unreleased patch for a released minor.

{{/unless}}


## <a id='1-9-0'></a> v1.9.0

**Release Date**: 9 April 2024

### <a id='1-9-0-whats-new'></a> What's new in Tanzu Application Platform v1.9

This release includes the following platform-wide enhancements.

#### <a id='1-9-0-new-platform-features'></a> New platform-wide features

- Tanzu Application Platform v1.9 supports N-2 upgrades, which allows you to upgrade from
  Tanzu Application Platform v1.7.x to v1.9.x or from Tanzu Application Platform v1.8.x to v1.9.x.

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

#### <a id='1-9-0-buildpacks'></a> v1.9.0 Features: Buildpacks and Stacks

- Adds support for the Tanzu Standard Stack for UBI 8 to the .NET Core and Web Servers buildpacks.
  For more information about the Tanzu Standard Stack for UBI 8, see the
  [Tanzu Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html#ubi-8-stacks).

#### <a id='1-9-0-services-toolkit'></a> v1.9.0 Features: Services Toolkit

- You can configure resource limits and requests for the Services Toolkit Controller Manager
  and Services Toolkit Resource Claims API Server deployments through the package values.
  For more information, see [Scalability](scalability.hbs.md).

#### <a id='1-9-0-tanzu-dev-portal'></a> v1.9.0 Features: Tanzu Developer Portal

- Added configuration to route traffic through a specified HTTP/HTTPS proxy. This includes all
  outgoing requests made by Backstage and Tanzu Developer Portal. For more information, see
  [Configure HTTP Proxy](tap-gui/http-proxy.hbs.md).
- The DORA plug-in now has the following changes:
  - Added the date range drop-down menu filters **Last 7 Days** and **Last 30 Days**
  - The default date range filter is now **Last 7 Days** instead of **Last 90 Days**
  - Earlier filters have more accurate names: **This Week** is now **Week to Date**, **This Month**
    is now **Month to Date**, and **This Quarter** is now **Quarter to Date**
  - Added percentage values to show improvements or declines in metrics when compared with the
    previous time period
  - Added graphs to display changes in Lead Time and Deployment Frequency metrics over time
  - Performance improvements

---

### <a id='1-9-0-breaking-changes'></a> v1.9.0 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-9-0-fluxcd-sc-bc'></a> v1.9.0 Breaking changes: FluxCD Source Controller

- FluxCD Source Controller no longer supports the `git_implementation` field in `GitRepository` version `v1`.

#### <a id='svc-toolkit-bc'></a> v1.9.0 Breaking changes: Services Toolkit

- The `tanzu services claims` CLI plug-in command has been removed. You must now use the
  `tanzu services resource-claims` command instead.

-  The experimental kubectl-scp plug-in has been removed.

-  The experimental multicluster APIs `*.multicluster.x-tanzu.vmware.com/v1alpha1` have been removed.
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

#### <a id='1-9-0-scst-scan-bc'></a> v1.9.0 Breaking changes: Supply Chain Security Tools - Scan

- When you configure SCST - Scan with the Metadata Store CA Certificate, you can no longer manually
  create the secret. Configure the secret in the `values.yaml` file. For more information, see
  [Multicluster setup for Supply Chain Security Tools](scst-store/multicluster-setup.hbs.md#apply-kubernetes).

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

#### <a id='1-9-0-tap-ki'></a> v1.9.0 Known issues: Tanzu Application Platform

- On Azure Kubernetes Service (AKS), the Datadog Cluster Agent cannot reconcile the webhook, which
  leads to an error.
  For troubleshooting information, see [Datadog agent cannot reconcile webhook on AKS](./troubleshooting-tap/troubleshoot-using-tap.hbs.md#datadog-agent-aks).

- The Tanzu Application Platform integration with Tanzu Service Mesh does not work
  on vSphere with TKR v1.26. For more information about this integration, see
  [Set up Tanzu Service Mesh](integrations/tsm-tap-integration.hbs.md).
  As a workaround, you can apply the label to update pod security on a TKr v1.26 Kubernetes namespace
  as advised by the release notes for
  [TKr 1.26.5 for vSphere 8.x](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-releases/services/rn/vmware-tanzu-kubernetes-releases-release-notes/index.html#TKr%201.26.5%20for%20vSphere%208.x-What's%20New).
  However, applying this label provides more than the minimum necessary privilege to the resources in
  developer namespaces.

#### <a id='1-9-0-api-auto-reg-ki'></a> v1.9.0 Known issues: API Auto Registration

- Registering conflicting `groupId` and `version` with API portal:

  If you create two `CuratedAPIDescriptor`s with the same `groupId` and `version` combination, both
  reconcile without throwing an error, and the `/openapi?groupId&version` endpoint returns both specifications.
  If you are adding both specifications to the API portal, only one of them might show up in the
  API portal UI with a warning indicating that there is a conflict.
  If you add the route provider annotation for both of the `CuratedAPIDescriptor`s to use Spring Cloud Gateway,
  the generated API specspecification includes API routes from both `CuratedAPIDescriptor`s.

  You can see the `groupId` and `version` information from all `CuratedAPIDescriptor`s by running:

    ```console
    $ kubectl get curatedapidescriptors -A

    NAMESPACE           NAME         GROUPID            VERSION   STATUS   CURATED API SPEC URL
    my-apps             petstore     test-api-group     1.2.3     Ready    http://AAR-CONTROLLER-FQDN/openapi/my-apps/petstore
    default             mystery      test-api-group     1.2.3     Ready    http://AAR-CONTROLLER-FQDN/openapi/default/mystery
    ```

- When creating an `APIDescriptor` with different `apiSpec.url` and `server.url`, the controller
  incorrectly uses the API spec URL as the server URL. To avoid this issue, use `server.url` only.

#### <a id='1-9-0-alm-ki'></a> v1.9.0 Known issues: App Last Mile Catalog

- The app-config-web, app-config-server, and app-config-worker components do not allow developers to
  override the default application ports.
  This means that applications that use non-standard ports do not work. To work around this, you can
  configure ports by providing values to the resulting Carvel package.
  This issue is planned to be fixed in a future release.

#### <a id='1-9-0-alv-ki'></a> v1.9.0 Known issues: Application Live View

- On the Run profile, Application Live View fails to reconcile if you use a non-default cluster issuer
while installing through Tanzu Mission Control.

#### <a id='1-9-0-amr-obs-ce-hndlr-ki'></a> v1.9.0 Known issues: Artifact Metadata Repository Observer and CloudEvent Handler

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of
  ImageVulnerabilityScan results. There is an error on duplicate submission of identical
  ImageVulnerabilityScans you can ignore if the previous submission was successful.

#### <a id='1-9-0-bitnami-services-ki'></a> v1.9.0 Known issues: Bitnami Services

- If you try to configure private registry integration for the Bitnami Services
  after having already created a claim for one or more of the services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshoot Bitnami Services](bitnami-services/how-to-guides/troubleshooting.hbs.md#private-reg).

#### <a id='1-9-0-carto-conventions'></a>v1.9.0 Known issues: Cartographer Conventions

- Before Tanzu Application Platform v1.9, the `cartographer.tanzu.vmware.com` package contained two products:
  Cartographer and Cartographer Conventions.
  In Tanzu Application Platform v1.9.0 the Cartographer Conventions product is removed from the
  `cartographer.tanzu.vmware.com` package and is distributed in its own package named
  `cartographer.conventions.apps.tanzu.vmware.com`.

  When you upgrade to Tanzu Application Platform v1.9, an issue might occur when installing the new
  package for Cartographer Conventions. The upgrade might fail to reconcile and show error messages
  similar to the following:

    ```console
    Resource 'clusterrole/cartographer-conventions-manager-role (rbac.authorization.k8s.io/v1) cluster' is already associated with a different app 'cartographer.app'
    ```

  This message might appear more than once, and it can refer to several resources.

  These errors appear when kapp-controller on the cluster tries to install the new Cartographer
  Conventions package before the Cartographer package has reconciled.
  The new package for Cartographer Conventions tries to install resources that the existing
  Cartographer package still owns.

  Although it looks like the upgrade fails, if you wait a few minutes, kapp-controller finishes
  the installation and the packages will reconcile successfully. The system works normally after
  the reconciliation is complete.

  This error does not occur on a new installation of Tanzu Application Platform v1.9.

- While processing workloads with large SBOMs, the Cartographer Convention controller manager pod can
  fail with the status `CrashLoopBackOff` or `OOMKilled`.
  For information about how to increase the memory limit for both the convention server and webhook
  servers, including app-live-view-conventions, spring-boot-webhook, and developer-conventions/webhook,
  see [Troubleshoot Cartographer Conventions](cartographer-conventions/troubleshooting.hbs.md).

#### <a id='1-9-0-crossplane-ki'></a> v1.9.0 Known issues: Crossplane

- The Crossplane `validatingwebhookconfiguration` is not removed when you uninstall the
  Crossplane package.
  To workaround, delete the `validatingwebhookconfiguration` manually by running
  `kubectl delete validatingwebhookconfiguration crossplane`.

#### <a id='1-9-0-tap-buildpacks'></a>v1.9.0 Known issues: Go Lite Buildpack

- In v1.8.1 there was a mismatch in version between the Go Lite buildpack provided in the
  Tanzu Application Platform packages and the Go buildpack provided in the full dependencies.
  This version mismatch made it impossible to use the dependency updater.
  For Tanzu Application Platform v1.8.2, the version of Go Lite has been upgraded from v2.2.x to v3.1.x.
  This version of the buildpack contains a breaking change which is the removal of the Dep package manager,
  which has been deprecated.
  If you still need to use the Dep package manager, see Tanzu Build Service documentation about using
  out of band packages. <!-- get link -->

#### <a id='1-9-0-svc-bindings-ki'></a> v1.9.0 Known issues: Service Bindings

- When upgrading Tanzu Application Platform, pods are recreated for all workloads with service bindings.
  This is because workloads and pods that use service bindings are being updated to new service
  binding volumes. This happens automatically and will not affect subsequent upgrades.

  Affected pods are updated concurrently. To avoid failures, you must have sufficient Kubernetes
  resources in your clusters to support the pod rollout.

#### <a id='1-9-0-stk-ki'></a> v1.9.0 Known issues: Services Toolkit

- An error occurs if `additionalProperties` is `true` in a CompositeResourceDefinition.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#compositeresourcedef).

#### <a id='1-9-0-scc-ki'></a> v1.9.0 Known issues: Supply Chain Choreographer

- The template for the `external-deliverable-template` does not respect the
  `gitops_credentials_secret` parameter. The value is not present on the deliverable if it is
  provided in the workload parameter `gitops_credentials_secret` or the supply chain tap-value
  `ootb_supply_chain*.gitops.credentials_secret`. As a workaround, operators must provide the value
  as a tap-value for the delivery: `ootb_delivery_basic.source.credentials_secret`.
  The supply chain's GitOps credentials must authenticate to the same repository as the delivery's
  source credentials. If a deliverable must use a secret different from that specified by the
  delivery tap-value, the deliverable must be manually altered when being copied to the Run
  cluster. Add the secret name as a `source_credentials_secret` parameter on the deliverable.

- By default, Server Workload Carvel packages generated by the Carvel package supply chains no longer
  contain OpenAPIv3 descriptions of their parameters.
  These descriptions were omitted to keep the size of the Carvel Package definition under 4&nbsp;KB,
  which is the size limit for the string output of a Tekton Task. For information about these parameters,
  see [Carvel Package Supply Chains](scc/carvel-package-supply-chain.hbs.md).

- When using the Carvel Package Supply Chains, if the operator updates the parameter
  `carvel_package.name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps
  repository that uses the old value of `carvel_package.name_suffix`. You can ignore or delete this package.

- If the size of the resulting OpenAPIv3 specification exceeds a certain size, approximately 3&nbsp;KB,
  the Supply Chain does not function. If you use the default Carvel package parameters, this
  issue does not occur. If you use custom Carvel package parameters, you might encounter this size limit.
  If you exceed the size limit, you can either deactivate this feature, or use a workaround.
  The workaround requires enabling a Tekton feature flag. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/additional-configs/#enabling-larger-results-using-sidecar-logs).

- Supply Chains that use [SSH auth](scc/git-auth.hbs.md#sshassh) with the git-writer resource will fail in the
  [gitops](scc/gitops-vs-regops.hbs.md#gitopsagitops) step. As a workaround, use
  [HTTPS auth](scc/git-auth.hbs.md#httpahttp).

#### <a id='1-9-0-scst-policy-ki'></a> v1.9.0 Known issues: Supply Chain Security Tools - Policy

- Supply Chain Security Tools - Policy defaults to The Update Framework (TUF) enabled due to incorrect logic.
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

- When using SCST - Scan 2.0, Trivy must be pinned to v0.42.1. This is because CycloneDX v1.5 is
  the default for later versions of Trivy and is not supported by AMR.

- The Snyk scanner outputs an incorrectly created date, resulting in an invalid date. If the workload
  is in a failed state due to an invalid date, wait approximately 10 hours and the workload
  automatically goes into the ready state.
  For more about this issue information, see the
  [Snyk](https://github.com/snyk-tech-services/snyk2spdx/issues/54) GitHub repository.

- Recurring scan fails to import keychains for cloud container registries such as ECR, ACR, and GCR.
  To work around, create a Docker config secret for the registry.

- Recurring scan has a maximum of approximately 5000 container images that can be scanned at a
  single time due to size limits configMaps.

- Recurring scan resources are shown in the Security Analysis Plug-in in Tanzu Developer Portal.
  This is cosmetic and does not have any impact on the vulnerabilities shown.

- If the supply chain container image scanning is configured to use a different scanner or scanner
  version than the recurring scanning, the vulnerabilities displayed in Tanzu Developer Portal might
  be inaccurate.

- SCST - Scan 1.0 fails with the error `secrets 'store-ca-cert' not found` during deployment by using
  Tanzu Mission Control with a non-default issuer. For how to work around this issue, see
  [Deployment failure with non-default issuer](scst-scan/troubleshoot-scan.hbs.md#non-default-issuer).

#### <a id='1-9-0-scst-store-ki'></a> v1.9.0 Known issues: Supply Chain Security Tools - Store

- SCST - Store returns an expired certificate error message when a CA certificate expires before the app certificate.
  For more information, see [CA Cert expires](scst-store/troubleshooting.hbs.md#ca-cert-expires).

- When outputting CycloneDX v1.5 SBOMs, the report is found to be an invalid SBOM by CycloneDX validators.
  This issue is planned to be fixed in a future release.

- AMR-specific steps have been added to the [Multicluster setup for Supply Chain Security Tools - Store](scst-store/multicluster-setup.hbs.md).

- SCST - Store automatically detects PostgreSQL database index corruptions.
  If SCST - Store finds a PostgresSQL database index corruption issue, SCST - Store does not reconcile.
  For how to fix this issue, see [Fix Postgres Database Index Corruption](scst-store/database-index-corruption.hbs.md).

- If CA Certificate data is included in the shared Tanzu Application Platform values section, do not
  configure AMR Observer with CA Certificate data.

#### <a id='1-9-0-ssc-ui-ki'></a> v1.9.0 Known issues: Supply Chain UI

- When you select the **Supply Chains** tab in Tanzu Developer Portal, you might encounter an error
  related to `data.packaging.carvel.dev`. The error message is related to permission issues and JSON
  parsing errors. The error message indicates that the user `system:serviceaccount:tap-gui:tap-gui-viewer`
  cannot list resource `packages` in the API group `data.packaging.carvel.dev` at the cluster scope.
  Additionally, an unexpected non-whitespace character is reported after JSON at position 4.

  As a temporary workaround, apply an RBAC configuration that includes the get, watch, and list
  permissions for the resources in the `data.packaging.carvel.dev` API group. This workaround must
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

#### <a id='1-9-0-tbs-ki'></a> v1.9.0 Known issues: Tanzu Build Service

- During upgrades a large number of builds might be created due to buildpack and stack updates.
  Some of these builds might fail due to transient network issues,
  causing the workload to be in an unhealthy state. This resolves itself on subsequent builds
  after a code change and does not affect the running application.

  If you do not want to wait for subsequent builds to run, you can manually trigger a build.
  For instructions, see [Troubleshooting](./tanzu-build-service/troubleshooting.hbs.md#failed-builds-upgrade).

#### <a id='1-9-0-tdp-ki'></a>v1.9.0 Known issues: Tanzu Developer Portal

- Tanzu Developer Portal Configurator jumps from v1.0.x in Tanzu Application Platform v1.7 to v1.8.x
  in Tanzu Application Platform v1.8. This version jump enables future versions of
  Tanzu Developer Portal and Tanzu Developer Portal Configurator to sync going forward.

- If you do not configure any authentication providers, and do not allow guest access, the following
  message appears when loading Tanzu Developer Portal in a browser:

    ```console
    No configured authentication providers. Please configure at least one.
    ```

    To resolve this issue, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#authn-not-configured).

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Developer Portal.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

- [ScmAuth](https://backstage.io/docs/reference/integration-react.scmauth/) is a Backstage concept
  that abstracts Source Code Management (SCM) authentication into a package. An oversight in a
  recent code-base migration led to the accidental exclusion of custom ScmAuth functions. This
  exclusion affected some client operations, such as using Application Accelerators to create Git
  repositories on behalf of users.

#### <a id='1-9-0-intellij-plugin-ki'></a> v1.9.0 Known issues: Tanzu Developer Tools for IntelliJ

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

#### <a id='1-9-0-vs-plugin-ki'></a> v1.9.0 Known issues: Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

---

### <a id='1-9-0-components'></a> v1.9.0 Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                     | Version        |
| -------------------------------------------------- | -------------- |
| API Auto Registration                              | 0.5.0          |
| API portal                                         | 1.5.0          |
| Application Accelerator                            | 1.9.1          |
| Application Configuration Service                  | 2.3.1          |
| Application Live View APIServer                    | 1.9.1          |
| Application Live View back end                     | 1.9.1          |
| Application Live View connector                    | 1.9.1          |
| Application Live View conventions                  | 1.9.1          |
| Application Single Sign-On                         | 5.1.4          |
| Artifact Metadata Repository Observer              | 0.5.0          |
| AWS Services                                       | 0.3.0-rc.2     |
| Bitnami Services                                   | 0.5.0-rc.3     |
| Carbon Black Scanner for SCST - Scan (beta)        | 1.4.0          |
| Cartographer Conventions                           | 0.9.0          |
| cert-manager                                       | 2.7.2          |
| Cloud Native Runtimes                              | 2.5.3          |
| Contour                                            | 2.2.0          |
| Crossplane                                         | 0.5.0-rc.3     |
| Default Roles                                      | 1.1.0          |
| Developer Conventions                              | 0.16.1         |
| External Secrets Operator                          | 0.9.4+tanzu.3  |
| Flux CD Source Controller                          | 1.1.2+tanzu.1  |
| Grype Scanner for SCST - Scan                      | 1.9.0          |
| Local Source Proxy                                 | 0.2.1          |
| Managed Resource Controller (beta)                 | 0.2.1          |
| Namespace Provisioner                              | 0.6.2          |
| Out of the Box Delivery - Basic                    | 0.16.1         |
| Out of the Box Supply Chain - Basic                | 0.16.1         |
| Out of the Box Supply Chain - Testing              | 0.16.1         |
| Out of the Box Supply Chain - Testing and Scanning | 0.16.1         |
| Out of the Box Templates                           | 0.16.1         |
| Service Bindings                                   | 0.12.0-rc.2    |
| Service Registry                                   | 1.3.2          |
| Services Toolkit                                   | 0.14.0-rc.5    |
| Snyk Scanner for SCST - Scan (beta)                | 1.3.0          |
| Source Controller                                  | 0.9.0          |
| Spring Boot conventions                            | 1.9.1          |
| Spring Cloud Gateway                               | 2.1.9          |
| Supply Chain Choreographer                         | 0.9.0          |
| Supply Chain Security Tools - Policy Controller    | 1.6.4          |
| Supply Chain Security Tools - Scan                 | 1.9.1          |
| Supply Chain Security Tools - Scan 2.0             | 0.4.0          |
| Supply Chain Security Tools - Store                | 1.9.0          |
| Tanzu Application Platform Telemetry               | 0.7.0          |
| Tanzu Build Service                                | 1.13.0         |
| Tanzu CLI                                          | 1.2.0          |
| Tanzu Developer Portal                             | 1.9.1          |
| Tanzu Developer Portal Configurator                | 1.9.1          |
| Tanzu Supply Chain (beta)                          | 0.2.9          |
| Tekton Pipelines                                   | 0.50.3+tanzu.4 |

---

## <a id='deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features remain on this list until they are retired from Tanzu Application Platform.

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

### <a id='fluxcd-sc-deprecations'></a> FluxCD Source Controller deprecations

- FluxCD Source Controller updates the `GitRepository` API from `v1beta2` to `v1`.
  The controller accepts resources with API versions `v1beta1` and `v1beta2`, saving them as `v1`.

### <a id='svc-toolkit-deprecations'></a> Services Toolkit deprecations

- The following APIs are deprecated and are marked for removal in
  Tanzu Application Platform v1.11:
  - `clusterexampleusages.services.apps.tanzu.vmware.com/v1alpha1`
  - `clusterresources.services.apps.tanzu.vmware.com/v1alpha1`

### <a id="sc-deprecations"></a> Source Controller deprecations

- The Source Controller `ImageRepository` API is deprecated and is marked for
  removal. Use the `OCIRepository` API instead.
  The Flux Source Controller installation includes the `OCIRepository` API.
  For more information about the `OCIRepository` API, see the
  [Flux documentation](https://fluxcd.io/flux/components/source/ocirepositories/).
