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

#### <a id='1-9-0-application-accelerator'></a> v1.9.0 Features: Application Accelerator
- Accelerator authors can create accelerators faster using a local authoring experience without connecting to a Tanzu Application Platform cluster using the IntelliJ IDE. For more information, see [Using a local Application Accelerator engine server](application-accelerator/creating-accelerators/using-local-engine-server.hbs.md).
- The spring-ai-chat sample accelerator provides an out-of-the-box application setup to fast start development of a Web Application for AI Chat based on Spring AI. This web application offers an interactive chat experience utilizing RAG (Retrieval Augmented Generation) to enable a user to ask questions about their own uploaded documents. For more information, see [Spring AI Chat Sample Accelerator](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/spring-ai-chat).

#### <a id='1-9-0-app-live-view'></a> v1.9.0 Features: Application Live View

- By default, Application Live View connector is deployed as a Deployment to discover applications across all namespaces running in a worker node of a Kubernetes cluster. This is to override the earlier behavior where the connector is deployed as a DaemonSet, making the Kubernetes scheduling pattern unpredictable when a node restarts. For more information, see [Connector deployment modes in Application Live View](app-live-view/connector-deployment-modes.hbs.md).

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
| Package Name | Vulnerabilities Resolved |
| ------------ | ------------------------ |
| accelerator.apps.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-4641</li><li>CVE-2023-52425</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0553</li><li>CVE-2024-0567</li><li>CVE-2024-0727</li><li>CVE-2024-22365</li><li>CVE-2024-28757</li><li>GHSA-8r3f-844c-mc37</li><li>CVE-2024-25710</li><li>CVE-2024-26308 </li></ul>|
| alm-catalog.component.apps.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-52425</li><li>CVE-2024-28085</li><li>CVE-2024-28757</li><li>CVE-2022-47695</li><li>CVE-2022-48063</li><li>CVE-2022-48065</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-32247</li><li>CVE-2023-4134</li><li>CVE-2023-46343</li><li>CVE-2023-46862</li><li>CVE-2023-51779</li><li>CVE-2023-51780</li><li>CVE-2023-51782</li><li>CVE-2023-6121</li><li>CVE-2023-6915</li><li>CVE-2024-0340</li><li>CVE-2024-0565</li><li>CVE-2024-0607</li><li>CVE-2024-2398</li><li>CVE-2024-24855</li><li>CVE-2023-50387</li><li>CVE-2023-50868</li><li>GHSA-45x7-px36-x8w8 </li></ul>|
| app-scanning.apps.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-52425</li><li>CVE-2024-28757 </li></ul>|
| base-jammy-stack-lite.buildpacks.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-52425</li><li>CVE-2024-28757</li><li>CVE-2022-47695</li><li>CVE-2022-48063</li><li>CVE-2022-48065</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-32247</li><li>CVE-2023-4134</li><li>CVE-2023-46343</li><li>CVE-2023-46862</li><li>CVE-2023-51779</li><li>CVE-2023-51780</li><li>CVE-2023-51782</li><li>CVE-2023-6121</li><li>CVE-2023-6915</li><li>CVE-2024-0340</li><li>CVE-2024-0565</li><li>CVE-2024-0607</li><li>CVE-2024-24855</li><li>CVE-2023-51781</li><li>CVE-2024-0646</li><li>CVE-2024-1085</li><li>CVE-2024-1086 </li></ul>|
| conventions.component.apps.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-52425</li><li>CVE-2024-28757</li><li>CVE-2022-47695</li><li>CVE-2022-48063</li><li>CVE-2022-48065</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-32247</li><li>CVE-2023-4134</li><li>CVE-2023-46343</li><li>CVE-2023-46862</li><li>CVE-2023-51779</li><li>CVE-2023-51780</li><li>CVE-2023-51782</li><li>CVE-2023-6121</li><li>CVE-2023-6915</li><li>CVE-2024-0340</li><li>CVE-2024-0565</li><li>CVE-2024-0607</li><li>CVE-2024-24855</li><li>CVE-2023-51781</li><li>CVE-2024-0646</li><li>CVE-2024-1085</li><li>CVE-2024-1086 </li></ul>|
| git-writer.component.apps.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-4641</li><li>CVE-2023-52425</li><li>CVE-2024-28757</li><li>CVE-2022-47695</li><li>CVE-2022-48063</li><li>CVE-2022-48065</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-32247</li><li>CVE-2023-4134</li><li>CVE-2023-46343</li><li>CVE-2023-46862</li><li>CVE-2023-51779</li><li>CVE-2023-51780</li><li>CVE-2023-51782</li><li>CVE-2023-6121</li><li>CVE-2023-6915</li><li>CVE-2024-0340</li><li>CVE-2024-0565</li><li>CVE-2024-0607</li><li>CVE-2024-24855</li><li>CVE-2023-51781</li><li>CVE-2024-0646</li><li>CVE-2024-1085</li><li>CVE-2024-1086 </li></ul>|
| source.component.apps.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-4641</li><li>CVE-2023-52425</li><li>CVE-2024-28757</li><li>GHSA-8r3f-844c-mc37</li><li>CVE-2022-47695</li><li>CVE-2022-48063</li><li>CVE-2022-48065</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-32247</li><li>CVE-2023-4134</li><li>CVE-2023-46343</li><li>CVE-2023-46862</li><li>CVE-2023-51779</li><li>CVE-2023-51780</li><li>CVE-2023-51782</li><li>CVE-2023-6121</li><li>CVE-2023-6915</li><li>CVE-2024-0340</li><li>CVE-2024-0565</li><li>CVE-2024-0607</li><li>CVE-2024-24855</li><li>CVE-2023-51781</li><li>CVE-2024-0646</li><li>CVE-2024-1085</li><li>CVE-2024-1086 </li></ul>|
| supply-chain-catalog.apps.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-52425</li><li>CVE-2024-28757</li><li>CVE-2022-47695</li><li>CVE-2022-48063</li><li>CVE-2022-48065</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-32247</li><li>CVE-2023-4134</li><li>CVE-2023-46343</li><li>CVE-2023-46862</li><li>CVE-2023-51779</li><li>CVE-2023-51780</li><li>CVE-2023-51782</li><li>CVE-2023-6121</li><li>CVE-2023-6915</li><li>CVE-2024-0340</li><li>CVE-2024-0565</li><li>CVE-2024-0607</li><li>CVE-2024-24855</li><li>CVE-2023-51781</li><li>CVE-2024-0646</li><li>CVE-2024-1085</li><li>CVE-2024-1086 </li></ul>|
| tap-gui.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-52425</li><li>CVE-2024-28757</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-32247</li><li>CVE-2023-4134</li><li>CVE-2023-46343</li><li>CVE-2023-46862</li><li>CVE-2023-51779</li><li>CVE-2023-51780</li><li>CVE-2023-51782</li><li>CVE-2023-6121</li><li>CVE-2023-6915</li><li>CVE-2024-0340</li><li>CVE-2024-0565</li><li>CVE-2024-0607</li><li>CVE-2024-24855</li><li>CVE-2023-50387</li><li>CVE-2023-50868</li><li>CVE-2024-25062</li><li>CVE-2022-43244</li><li>CVE-2022-43245</li><li>CVE-2022-43249</li><li>CVE-2022-43250</li><li>CVE-2022-47665</li><li>CVE-2022-48624</li><li>CVE-2023-24751</li><li>CVE-2023-24752</li><li>CVE-2023-24754</li><li>CVE-2023-24755</li><li>CVE-2023-24756</li><li>CVE-2023-24757</li><li>CVE-2023-24758</li><li>CVE-2023-25221</li><li>CVE-2023-27102</li><li>CVE-2023-27103</li><li>CVE-2023-43887</li><li>CVE-2023-47471</li><li>CVE-2023-49465</li><li>CVE-2023-49467</li><li>CVE-2023-49468</li><li>CVE-2023-52356</li><li>CVE-2023-6228</li><li>CVE-2023-6277</li><li>CVE-2024-0985</li><li>CVE-2024-22667</li><li>CVE-2024-24806</li><li>GHSA-2fc9-xpp8-2g9h</li><li>GHSA-6xwr-q98w-rvg7</li><li>GHSA-p6mc-m468-83gw</li><li>GHSA-vh95-rmgr-6w4m</li><li>GHSA-ww39-953v-wcq6</li><li>GHSA-xvch-5gv4-984h </li></ul>|
| tekton.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-39326</li><li>CVE-2023-4641</li><li>CVE-2023-52425</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>CVE-2024-28757</li><li>CVE-2022-47695</li><li>CVE-2022-48063</li><li>CVE-2022-48065</li><li>CVE-2023-22995</li><li>CVE-2023-23000</li><li>CVE-2023-32247</li><li>CVE-2023-4134</li><li>CVE-2023-46343</li><li>CVE-2023-46862</li><li>CVE-2023-51779</li><li>CVE-2023-51780</li><li>CVE-2023-51782</li><li>CVE-2023-6121</li><li>CVE-2023-6915</li><li>CVE-2024-0340</li><li>CVE-2024-0565</li><li>CVE-2024-0607</li><li>CVE-2024-24855</li><li>GHSA-45x7-px36-x8w8</li><li>GHSA-2q89-485c-9j2x</li><li>CVE-2023-1732</li><li>CVE-2023-51781</li><li>CVE-2024-0646</li><li>CVE-2024-1085</li><li>CVE-2024-1086</li><li>CVE-2023-32250</li><li>CVE-2023-32252</li><li>CVE-2023-32257</li><li>CVE-2023-34324</li><li>CVE-2023-35827</li><li>CVE-2023-46813</li><li>CVE-2023-6039</li><li>CVE-2023-6176</li><li>CVE-2023-6622</li><li>CVE-2024-0641</li><li>GHSA-7ww5-4wqc-m92c</li><li>GHSA-2c7c-3mj9-8fqh</li><li>CVE-2023-2953</li><li>CVE-2023-6040</li><li>CVE-2023-6606</li><li>CVE-2023-6817</li><li>CVE-2023-6931</li><li>CVE-2023-6932</li><li>CVE-2024-0193</li><li>GHSA-9763-4f94-gfch </li></ul>|
| trivy.app-scanning.component.apps.tanzu.vmware.com | <ul><li> CVE-2022-3715</li><li>CVE-2023-52425</li><li>CVE-2024-28757 </li></ul>|
| apiserver.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727 </li></ul>|
| aws.services.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>GHSA-45x7-px36-x8w8</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-2wrh-6pvc-2jm9</li><li>CVE-2023-29403</li><li>CVE-2023-29406</li><li>CVE-2023-29409</li><li>CVE-2023-39318</li><li>CVE-2023-39319</li><li>CVE-2023-45287</li><li>GHSA-2q89-485c-9j2x</li><li>GHSA-h626-pv66-hhm7</li><li>CVE-2023-1732</li><li>CVE-2023-4782 </li></ul>|
| contour.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>CVE-2023-45284</li><li>CVE-2023-6780 </li></ul>|
| conventions.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>CVE-2023-45290</li><li>CVE-2023-45289</li><li>CVE-2024-24783</li><li>CVE-2024-24784</li><li>CVE-2024-24785 </li></ul>|
| crossplane.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727 </li></ul>|
| ootb-supply-chain-testing-scanning.tanzu.vmware.com | <ul><li> CVE-2023-39326</li><li>CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>GHSA-8r3f-844c-mc37</li><li>GHSA-xw73-rw38-6vjc</li><li>GHSA-9p26-698r-w4hx</li><li>GHSA-jw44-4f3j-q396</li><li>GHSA-v53g-5gjp-272r </li></ul>|
| spring-cloud-gateway.tanzu.vmware.com | <ul><li> CVE-2023-4641</li><li>CVE-2024-25710</li><li>CVE-2024-26308</li><li>CVE-2023-45290</li><li>CVE-2023-45289</li><li>CVE-2024-24783</li><li>CVE-2024-24784</li><li>CVE-2024-24785</li><li>GHSA-4g9r-vxhx-9pgx</li><li>CVE-2024-23672</li><li>CVE-2024-24549</li><li>GHSA-ccgv-vj62-xf9h</li><li>GHSA-4265-ccf5-phj5 </li></ul>|
| apis.apps.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>GHSA-45x7-px36-x8w8</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156 </li></ul>|
| application-configuration-service.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>CVE-2024-20926</li><li>GHSA-6qvw-249j-h44c </li></ul>|
| backend.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>CVE-2023-45290</li><li>CVE-2023-45289</li><li>CVE-2024-24783</li><li>CVE-2024-24784</li><li>CVE-2024-24785</li><li>CVE-2014-3488</li><li>CVE-2021-21290</li><li>CVE-2021-21295</li><li>CVE-2021-21409</li><li>CVE-2021-43797</li><li>CVE-2022-24823 </li></ul>|
| connector.appliveview.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>CVE-2023-35116</li><li>CVE-2024-25710</li><li>CVE-2024-26308</li><li>CVE-2023-34462</li><li>CVE-2024-29025</li><li>GHSA-5jpm-x58v-624v</li><li>GHSA-hr8g-6v94-x4m9</li><li>GHSA-wjxj-5m7g-mg7q</li><li>GHSA-6qvw-249j-h44c</li><li>CVE-2014-3488</li><li>CVE-2021-21290</li><li>CVE-2021-21295</li><li>CVE-2021-21409</li><li>CVE-2021-43797</li><li>CVE-2022-24823</li><li>GHSA-jjfh-589g-3hjx</li><li>CVE-2023-42503</li><li>GHSA-cgwf-w82q-5jrr</li><li>GHSA-w33c-445m-f8w7 </li></ul>|
| fluxcd.source.controller.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>GHSA-2wrh-6pvc-2jm9</li><li>GHSA-2q89-485c-9j2x</li><li>GHSA-6xv5-86q9-7xr8</li><li>CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-46737</li><li>CVE-2023-5363</li><li>GHSA-frqx-jfcm-6jjr</li><li>GHSA-r53h-jv2g-vpx6 </li></ul>|
| policy.apps.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-5363 </li></ul>|
| service-registry.spring.apps.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727 </li></ul>|
| servicebinding.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727 </li></ul>|
| services-toolkit.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727 </li></ul>|
| spring-boot-conventions.tanzu.vmware.com | <ul><li> CVE-2023-5678</li><li>CVE-2023-6129</li><li>CVE-2023-6237</li><li>CVE-2024-0727</li><li>CVE-2023-4806</li><li>CVE-2023-4813</li><li>CVE-2023-5156</li><li>CVE-2023-2975</li><li>CVE-2023-3446</li><li>CVE-2023-3817</li><li>CVE-2023-5363 </li></ul>|
| controller.source.apps.tanzu.vmware.com | <ul><li> GHSA-8r3f-844c-mc37</li><li>GHSA-45x7-px36-x8w8</li><li>GHSA-jq35-85cj-fj4p</li><li>GHSA-xw73-rw38-6vjc</li><li>GHSA-qppj-fm5r-hxr3 </li></ul>|
| java-lite.buildpacks.tanzu.vmware.com | <ul><li> GHSA-8r3f-844c-mc37</li><li>GHSA-45x7-px36-x8w8</li><li>GHSA-xw73-rw38-6vjc </li></ul>|
| ootb-templates.tanzu.vmware.com | <ul><li> CVE-2023-50387</li><li>CVE-2023-50868 </li></ul>|
| go-lite.buildpacks.tanzu.vmware.com | <ul><li> GHSA-45x7-px36-x8w8</li><li>GHSA-jq35-85cj-fj4p</li><li>CVE-2024-29018</li><li>GHSA-33pg-m6jh-5237</li><li>GHSA-6wrf-mxfj-pf5p</li><li>GHSA-mq39-4gv4-mvpx</li><li>GHSA-qppj-fm5r-hxr3</li><li>GHSA-7ww5-4wqc-m92c</li><li>GHSA-259w-8hf6-59c2</li><li>GHSA-2qjp-425j-52j9</li><li>GHSA-hmfx-3pcx-653p</li><li>GHSA-m5m3-46gj-wch8 </li></ul>|
| java-native-image-lite.buildpacks.tanzu.vmware.com | <ul><li> GHSA-45x7-px36-x8w8 </li></ul>|
| cartographer.tanzu.vmware.com | <ul><li> GHSA-xw73-rw38-6vjc </li></ul>|
| metadata-store.apps.tanzu.vmware.com | <ul><li> GHSA-qppj-fm5r-hxr3</li><li>GHSA-m425-mq94-257g</li><li>CVE-2024-25062 </li></ul>|
| tpb.tanzu.vmware.com | <ul><li> GHSA-6xwr-q98w-rvg7</li><li>GHSA-vh95-rmgr-6w4m</li><li>GHSA-ww39-953v-wcq6</li><li>GHSA-xvch-5gv4-984h </li></ul>|

---

### <a id='1-9-0-resolved-issues'></a> v1.9.0 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-9-0-alm-ri'></a> v1.9.0 Resolved issues: App Last Mile Catalog

- Resolved an issue where the Deployer component would output an error message larger than 4KB, resulting in a Tekton error. The Deployer component now outputs a smaller, human readable error message.

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


#### <a id='1-9-0-ssc-ui-ki'></a> v1.9.0 Known issues: Supply Chain UI

- When accessing the supply chain tab in the Tanzu Developer Portal, users might encounter an error related to data.packaging.carvel.dev. The error message displayed is related to permission issues and JSON parsing errors, specifically mentioning that the user "system:serviceaccount:tap-gui:tap-gui-viewer" cannot list resource "packages" in the API group "data.packaging.carvel.dev" at the cluster scope. Additionally, an unexpected non-whitespace character is reported after JSON at position 4.

Workaround: A temporary solution involves applying an RBAC configuration that includes permissions (get, watch, list) for the resources within the data.packaging.carvel.dev API group. This configuration mitigates the issue but it is highlighted that such a requirement should not be mandated for supply chains not generating Carvel packages.

Configuring RBAC to allow access to the Carvel package resource eliminates the error message:

```
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

### <a id='1-9-0-scst-scan-bc'></a> Supply Chain Security Tools - Scan 1.0 deprecation

- In Tanzu Application Platform v1.9.0, Scan 1.0 has been marked for deprecation in favor of Scan 2.0.  Scan 1.0 will remain the documented default for online installations and replaced as the documented default in Tanzu Application Platform v1.10.0, then removed in a future release.  For an overview of Scan 1.0 versus scan 2.0, please see the [scan overview page](./scst-scan/overview.hbs.md).
