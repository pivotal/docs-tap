# Tanzu Application Platform release notes

This topic describes the changes in Tanzu Application Platform (commonly known as TAP)
v{{ vars.url_version }}.

## <a id='1-6-4'></a> v1.6.4

**Release Date**: 10 October 2023

### <a id='1-6-4-breaking-changes'></a> v1.6.4 Breaking changes

This release has the following breaking changes, listed by component and area.

#### <a id='1-6-4-services-toolkit-br'></a> v1.6.4 Breaking changes: Services Toolkit

- Services Toolkit forces explicit cluster-wide permissions to `claim` from a `ClusterInstanceClass`.
  You must now grant the permission to `claim` from a `ClusterInstanceClass` by using a `ClusterRole`
  and `ClusterRoleBinding`.
  For more information, see [The claim verb for ClusterInstanceClass](./services-toolkit/reference/api/rbac.hbs.md#claim-verb).

---

### <a id='1-6-4-security-fixes'></a> v1.6.4 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
<tr>
<td>accelerator.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-43642">CVE-2023-43642</a></li>
</ul></details></td>
</tr>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-r47r-87p9-8jh3">GHSA-r47r-87p9-8jh3</a></li>
<li><a href="https://github.com/advisories/GHSA-6mjq-h674-j845">GHSA-6mjq-h674-j845</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34035">CVE-2023-34035</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
</ul></details></td>
</tr>
<tr>
<td>apis.apps.tanzu.vmware.com</td>
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
<td>application-configuration-service.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-mjmq-gwgm-5qhm">GHSA-mjmq-gwgm-5qhm</a></li>
<li><a href="https://github.com/advisories/GHSA-3p86-9955-h393">GHSA-3p86-9955-h393</a></li>
</ul></details></td>
</tr>
<tr>
<td>base-jammy-stack-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hp87-p4gw-j4gq">GHSA-hp87-p4gw-j4gq</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38429">CVE-2023-38429</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38428">CVE-2023-38428</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38426">CVE-2023-38426</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35829">CVE-2023-35829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35828">CVE-2023-35828</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35824">CVE-2023-35824</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35823">CVE-2023-35823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3439">CVE-2023-3439</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34256">CVE-2023-34256</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33288">CVE-2023-33288</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33203">CVE-2023-33203</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3268">CVE-2023-3268</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32248">CVE-2023-32248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3212">CVE-2023-3212</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3141">CVE-2023-3141</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3117">CVE-2023-3117</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31084">CVE-2023-31084</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30772">CVE-2023-30772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2898">CVE-2023-2898</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28466">CVE-2023-28466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2194">CVE-2023-2194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2163">CVE-2023-2163</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21255">CVE-2023-21255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1990">CVE-2023-1990</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1855">CVE-2023-1855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1611">CVE-2023-1611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48502">CVE-2022-48502</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48425">CVE-2022-48425</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40982">CVE-2022-40982</a></li>
</ul></details></td>
</tr>
<tr>
<td>learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3712">CVE-2021-3712</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
</ul></details></td>
</tr>
<tr>
<td>policy.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-cgwf-w82q-5jrr">GHSA-cgwf-w82q-5jrr</a></li>
<li><a href="https://github.com/advisories/GHSA-7g45-4rm6-3mm3">GHSA-7g45-4rm6-3mm3</a></li>
<li><a href="https://github.com/advisories/GHSA-5mg8-w23w-74h3">GHSA-5mg8-w23w-74h3</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-42503">CVE-2023-42503</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3635">CVE-2023-3635</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2976">CVE-2023-2976</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22049">CVE-2023-22049</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22045">CVE-2023-22045</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22044">CVE-2023-22044</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22041">CVE-2023-22041</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22036">CVE-2023-22036</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22006">CVE-2023-22006</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-8908">CVE-2020-8908</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32559">CVE-2023-32559</a></li>
</ul></details></td>
</tr>
<tr>
<td>tekton.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48566">CVE-2022-48566</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48565">CVE-2022-48565</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48564">CVE-2022-48564</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48560">CVE-2022-48560</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48064">CVE-2022-48064</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li>
</ul></details></td>
</tr>
</table>

---

### <a id='1-6-4-resolved-issues'></a> v1.6.4 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-6-4-app-config-srvc-ri'></a> v1.6.4 Resolved issues: Application Configuration Service

- Resolves an issue which caused client applications that include the `spring-cloud-config-client`
  dependency to fail to start or properly load the configuration that Application Configuration Service
  produced. The fix is adding the property `spring.cloud.config.enabled=false` in secret resources
  that Application Configuration Service produced.

- Resolves some installation failure scenarios by setting the pod security context to adhere to the
  restricted pod security standard.

---

### <a id='1-6-4-known-issues'></a> v1.6.4 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-6-4-tap-ki'></a> v1.6.4 Known issues: Tanzu Application Platform

- Tanzu Application Platform v1.6.4 is not supported with Tanzu Kubernetes releases (TKR) v1.26.5
  on vSphere with Tanzu v8.

#### <a id='1-6-4-amr-obs-ce-hndlr-ki'></a> v1.6.4 Known issues: Artifact Metadata Repository Observer and CloudEvent Handler

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of
  ImageVulnerabilityScan results. There is an error on duplicate submission of identical
  ImageVulnerabilityScans you can ignore if the previous submission was successful.

- ReplicaSet status in AMR only has two states: `created` and `deleted`.
  There is a known issue where the `available` and `unavailable` state is not showing.
  The workaround is that you can interpolate this information from the `instances` metadata in the
  AMR for the ReplicaSet.

#### <a id='1-6-4-bitnami-services-ki'></a> v1.6.4 Known issues: Bitnami Services

- If you try to configure private registry integration for the Bitnami services
  after having already created a claim for one or more of the Bitnami services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshoot Bitnami Services](bitnami-services/how-to-guides/troubleshooting.hbs.md#private-reg).

#### <a id='1-6-4-cnrs-ki'></a> v1.6.4 Known issues: Cloud Native Runtimes

- For Knative Serving, certain app name, namespace, and domain combinations produce Knative Services
  with status `CertificateNotReady`. For more information, see
  [Troubleshooting](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.3/tanzu-cloud-native-runtimes/troubleshooting.html#certificate-not-ready-kcert).

#### <a id='1-6-4-crossplane-ki'></a> v1.6.4 Known issues: Crossplane

- Crossplane Providers cannot communicate with systems using a custom CA.
  For more information and a workaround, see [Troubleshoot Crossplane](./crossplane/how-to-guides/troubleshooting.hbs.md#cp-custom-cert-inject).

- The Crossplane `validatingwebhookconfiguration` is not removed when you uninstall the
  Crossplane Package.
  To workaround, delete the `validatingwebhookconfiguration` manually by running
  `kubectl delete validatingwebhookconfiguration crossplane`.

#### <a id='1-6-4-eventing-ki'></a> v1.6.4 Known issues: Eventing

- When using vSphere sources in Eventing, the vsphere-source is using a high number of
  informers to alleviate load on the API server. This causes high memory use.

#### <a id='1-6-4-learningcenter-ki'></a> v1.6.4 Known issues: Learning Center

- [CVE-2023-26114](https://nvd.nist.gov/vuln/detail/CVE-2023-26114):
  Versions of VS Code server before v4.10.1 are vulnerable to Missing Origin Validation in WebSocket handshakes.
  For mitigation steps, see [Known issues for Learning Center](./learning-center/known-issues.hbs.md).

#### <a id='1-6-4-local-source-proxy-ki'></a> v1.6.4 Known issues: Local Source Proxy

- Individual component installation of `Local Source Proxy` fails on Openshift distribution due to missing `SecurityContextConstraits` policy.

#### <a id='1-6-4-stk-ki'></a> v1.6.4 Known issues: Services Toolkit

- An error occurs if `additionalProperties` is `true` in a CompositeResourceDefinition.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#compositeresourcedef).

#### <a id='1-6-4-scc-ki'></a> v1.6.4 Known issues: Supply Chain Choreographer

- When using the Carvel Package Supply Chains, if the operator updates the parameter
  `carvel_package.name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps
  repository that uses the old value of `carvel_package.name_suffix`. You can ignore or delete this package.

- If the size of the resulting OpenAPIv3 specification exceeds a certain size, approximately 3&nbsp;KB,
  the Supply Chain does not function. If you use the default Carvel package parameters, you this
  issue does not occur. If you use custom Carvel package parameters, you might encounter this size limit.
  If you exceed the size limit, you can either deactivate this feature, or use a workaround.
  The workaround requires enabling a Tekton feature flag. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/additional-configs/#enabling-larger-results-using-sidecar-logs).

#### <a id='1-6-4-supply-chain-security-tools-store-ki'></a> v1.6.4 Supply Chain Security Tools - Store

- `Supply Chain Security Tools - Store` automatically detects PostgreSQL Database Index corruptions.
  Supply Chain Security Tools - Store does not reconcile if it finds a Postgres database index
  corruption issue.
  For information about remediating this issue, see [Fix Postgres Database Index Corruption](scst-store/database-index-corruption.hbs.md).

#### <a id='1-6-4-tap-gui-ki'></a> v1.6.4 Known issues: Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Developer Portal.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

- If you do not configure any authentication providers, and do not allow guest access, the following
  message appears when loading Tanzu Developer Portal in a browser:

   ```console
   No configured authentication providers. Please configure at least one.
   ```

  To resolve this issue, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#authn-not-configured).

#### <a id='1-6-4-sc-plugin-ki'></a> v1.6.4 Known issues: Tanzu Developer Portal - Supply Chain GUI plug-in

- Any workloads created by using a custom resource definition (CRD) might not work as expected.
  Only Out of the Box (OOTB) Supply Chains are supported in the UI.

- Downloading the SBOM from a vulnerability scan requires additional configuration in
  `tap-values.yaml`. For more information, see
  [Troubleshooting](tap-gui/troubleshooting.hbs.md#sbom-not-working).

#### <a id='1-6-4-intellij-plugin-ki'></a> v1.6.4 Known issues: Tanzu Developer Tools for IntelliJ

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

#### <a id='1-6-4-vs-plugin-ki'></a> v1.6.4 Known issues: Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

#### <a id='1-6-4-vscode-plugin-ki'></a> v1.6.4 Known issues: Tanzu Developer Tools for VS Code

- In the Tanzu activity panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

---

### <a id='1-6-4-components'></a> v1.6.4 Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                                   | Version |
| ---------------------------------------------------------------- | ------- |
| API Auto Registration                                            | 0.3.4   |
| API portal                                                       | 1.4.2   |
| Application Accelerator                                          | 1.6.2   |
| Application Configuration Service                                | 2.1.2   |
| Application Live View API Server                                 | 1.6.2   |
| Application Live View Backend                                    | 1.6.2   |
| Application Live View Connector                                  | 1.6.2   |
| Application Live View Conventions                                | 1.6.2   |
| Application Single Sign-On                                       | 4.0.1   |
| Authentication and authorization                                 | 1.1.0   |
| Bitnami Services                                                 | 0.2.0   |
| Cartographer Conventions                                         | 0.7.4   |
| cert-manager                                                     | 2.3.1   |
| Cloud Native Runtimes                                            | 2.3.2   |
| Contour                                                          | 1.24.4  |
| Crossplane                                                       | 0.2.1   |
| Developer Conventions                                            | 0.11.0  |
| Eventing (deprecated)                                            | 2.2.4   |
| External Secrets Operator                                        | 0.6.1   |
| Flux CD Source Controller                                        | 0.36.1  |
| Learning Center (deprecated)                                     | 0.3.2   |
| Learning Center workshops (deprecated)                           | 0.3.1   |
| Local Source Proxy                                               | 0.1.0   |
| Namespace Provisioner                                            | 0.4.1   |
| Out of the Box Delivery - Basic                                  | 0.13.11 |
| Out of the Box Supply Chain - Basic                              | 0.13.11 |
| Out of the Box Supply Chain - Testing                            | 0.13.11 |
| Out of the Box Supply Chain - Testing and Scanning               | 0.13.11 |
| Out of the Box Templates                                         | 0.13.11 |
| Service Bindings                                                 | 0.9.1   |
| Services Toolkit                                                 | 0.11.1  |
| Source Controller                                                | 0.8.3   |
| Spring Boot conventions                                          | 1.6.2   |
| Spring Cloud Gateway                                             | 2.0.8   |
| Supply Chain Choreographer                                       | 0.7.4   |
| Supply Chain Security Tools - Policy Controller                  | 1.4.2   |
| Supply Chain Security Tools - Scan                               | 1.6.141 |
| Supply Chain Security Tools - Store                              | 1.6.3   |
| Tanzu Developer Portal (formerly Tanzu Application Platform GUI) | 1.6.5   |
| Tanzu Application Platform Telemetry                             | 0.6.2   |
| Tanzu Build Service                                              | 1.11.13 |
| Tanzu CLI                                                        | 1.0.0   |
| Tekton Pipelines                                                 | 0.41.0  |

---

## <a id='1-6-3'></a> v1.6.3

**Release Date**: 12 September 2023

### <a id='1-6-3-security-fixes'></a> v1.6.3 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
<tr>
<td>accelerator.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hp87-p4gw-j4gq">GHSA-hp87-p4gw-j4gq</a></li>
</ul></details></td>
</tr>
<tr>
<td>application-configuration-service.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>base-jammy-stack-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47696">CVE-2022-47696</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47673">CVE-2022-47673</a></li>
</ul></details></td>
</tr>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4415">CVE-2022-4415</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
</ul></details></td>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-2q89-485c-9j2x">GHSA-2q89-485c-9j2x</a></li>
</ul></details></td>
</tr>
<tr>
<td>eventing.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li>
</ul></details></td>
</tr>
<tr>
<td>learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-p5gc-c584-jj6v">GHSA-p5gc-c584-jj6v</a></li>
<li><a href="https://github.com/advisories/GHSA-j8xg-fqg3-53r7">GHSA-j8xg-fqg3-53r7</a></li>
<li><a href="https://github.com/advisories/GHSA-frjg-g767-7363">GHSA-frjg-g767-7363</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38408">CVE-2023-38408</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38289">CVE-2023-38289</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-38288">CVE-2023-38288</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3618">CVE-2023-3618</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35829">CVE-2023-35829</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35828">CVE-2023-35828</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35824">CVE-2023-35824</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35823">CVE-2023-35823</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3567">CVE-2023-3567</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3439">CVE-2023-3439</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33288">CVE-2023-33288</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33203">CVE-2023-33203</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3316">CVE-2023-3316</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3268">CVE-2023-3268</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32665">CVE-2023-32665</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32643">CVE-2023-32643</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32636">CVE-2023-32636</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32611">CVE-2023-32611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32269">CVE-2023-32269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32248">CVE-2023-32248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3220">CVE-2023-3220</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3161">CVE-2023-3161</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3141">CVE-2023-3141</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3138">CVE-2023-3138</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3117">CVE-2023-3117</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30772">CVE-2023-30772</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2985">CVE-2023-2985</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29499">CVE-2023-29499</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2908">CVE-2023-2908</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28466">CVE-2023-28466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28322">CVE-2023-28322</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28321">CVE-2023-28321</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26966">CVE-2023-26966</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26965">CVE-2023-26965</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2610">CVE-2023-2610</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2609">CVE-2023-2609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25588">CVE-2023-25588</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25585">CVE-2023-25585</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25584">CVE-2023-25584</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25433">CVE-2023-25433</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25180">CVE-2023-25180</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24593">CVE-2023-24593</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2426">CVE-2023-2426</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23936">CVE-2023-23936</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2194">CVE-2023-2194</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2163">CVE-2023-2163</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2162">CVE-2023-2162</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20938">CVE-2023-20938</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1999">CVE-2023-1999</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1998">CVE-2023-1998</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1990">CVE-2023-1990</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1972">CVE-2023-1972</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1859">CVE-2023-1859</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1855">CVE-2023-1855</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1670">CVE-2023-1670</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1611">CVE-2023-1611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1513">CVE-2023-1513</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1079">CVE-2023-1079</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1078">CVE-2023-1078</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1077">CVE-2023-1077</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1076">CVE-2023-1076</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1075">CVE-2023-1075</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0459">CVE-2023-0459</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48502">CVE-2022-48502</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48281">CVE-2022-48281</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47696">CVE-2022-47696</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47673">CVE-2022-47673</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3707">CVE-2022-3707</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3153">CVE-2022-3153</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3134">CVE-2022-3134</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3099">CVE-2022-3099</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3037">CVE-2022-3037</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3016">CVE-2022-3016</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2982">CVE-2022-2982</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2889">CVE-2022-2889</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2874">CVE-2022-2874</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2862">CVE-2022-2862</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2819">CVE-2022-2819</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2817">CVE-2022-2817</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2816">CVE-2022-2816</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27672">CVE-2022-27672</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2598">CVE-2022-2598</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2580">CVE-2022-2580</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2522">CVE-2022-2522</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2289">CVE-2022-2289</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2287">CVE-2022-2287</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2286">CVE-2022-2286</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2285">CVE-2022-2285</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2284">CVE-2022-2284</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2264">CVE-2022-2264</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2257">CVE-2022-2257</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2231">CVE-2022-2231</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2210">CVE-2022-2210</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2208">CVE-2022-2208</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2182">CVE-2022-2182</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0696">CVE-2022-0696</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0407">CVE-2022-0407</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0393">CVE-2022-0393</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0158">CVE-2022-0158</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0156">CVE-2022-0156</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0128">CVE-2022-0128</a></li>
</ul></details></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-hp87-p4gw-j4gq">GHSA-hp87-p4gw-j4gq</a></li>
</ul></details></td>
</tr>
<tr>
<td>workshops.learningcenter.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
</ul></details></td>
</tr>
</table>

---

### <a id='1-6-3-resolved-issues'></a> v1.6.3 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-6-3-app-config-serv-ri'></a> v1.6.3 Resolved issues: Application Configuration Service

- `GitRepository` is now consistently observed beyond 15 minutes. The `interval` property for a
  `ConfigurationSlice` now continues to work as expected.

- Error-logging is improved where a `ConfigurationSlice` references a non-existent `ConfigurationSource`.
  A `ConfigurationSlice` properly reconciles after the referenced `ConfigurationSource` is created.

#### <a id='1-6-3-cli-ri'></a> v1.6.3 Resolved issues: Tanzu CLI and plugins

- This release includes Tanzu CLI v1.0.0 and a set of installable plug-in groups that are versioned
  so that the CLI is compatible with every supported version of Tanzu Applicatin Platform. For more
  information, see [Install Tanzu CLI](install-tanzu-cli.hbs.md).

---

### <a id='1-6-3-known-issues'></a> v1.6.3 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-6-3-tap-ki'></a> v1.6.3 Known issues: Tanzu Application Platform

- Tanzu Application Platform v1.6.3 is not supported with Tanzu Kubernetes releases (TKR) v1.26.5
  on vSphere with Tanzu v8.

#### <a id='1-6-3-app-config-srvc-ki'></a> v1.6.3 Known issues: Application Configuration Service

- Client applications that include the `spring-cloud-config-client` dependency might fail to start or
  properly load the configuration that Application Configuration Service produced.

- Installation might fail because the pod security context does not perfectly adhere to the
  restricted pod security standard.

#### <a id='1-6-3-amr-obs-ce-hndlr-ki'></a> v1.6.3 Known issues: Artifact Metadata Repository Observer and CloudEvent Handler

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of
  ImageVulnerabilityScan results. There is an error on duplicate submission of identical
  ImageVulnerabilityScans you can ignore if the previous submission was successful.

- ReplicaSet status in AMR only has two states: `created` and `deleted`.
  There is a known issue where the `available` and `unavailable` state is not showing.
  The workaround is that you can interpolate this information from the `instances` metadata in the
  AMR for the ReplicaSet.

#### <a id='1-6-3-bitnami-services-ki'></a> v1.6.3 Known issues: Bitnami Services

- If you try to configure private registry integration for the Bitnami services
  after having already created a claim for one or more of the Bitnami services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshoot Bitnami Services](bitnami-services/how-to-guides/troubleshooting.hbs.md#private-reg).

#### <a id='1-6-3-cnrs-ki'></a> v1.6.3 Known issues: Cloud Native Runtimes

- For Knative Serving, certain app name, namespace, and domain combinations produce Knative Services
  with status `CertificateNotReady`. For more information, see
  [Troubleshooting](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.3/tanzu-cloud-native-runtimes/troubleshooting.html#certificate-not-ready-kcert).

#### <a id='1-6-3-crossplane-ki'></a> v1.6.3 Known issues: Crossplane

- Crossplane Providers cannot communicate with systems using a custom CA.
  For more information and a workaround, see [Troubleshoot Crossplane](./crossplane/how-to-guides/troubleshooting.hbs.md#cp-custom-cert-inject).

- The Crossplane `validatingwebhookconfiguration` is not removed when you uninstall the
  Crossplane Package.
  To workaround, delete the `validatingwebhookconfiguration` manually by running
  `kubectl delete validatingwebhookconfiguration crossplane`.

#### <a id='1-6-3-eventing-ki'></a> v1.6.3 Known issues: Eventing

- When using vSphere sources in Eventing, the vsphere-source is using a high number of
  informers to alleviate load on the API server. This causes high memory use.

#### <a id='1-6-3-learningcenter-ki'></a> v1.6.3 Known issues: Learning Center

- [CVE-2023-26114](https://nvd.nist.gov/vuln/detail/CVE-2023-26114):
  Versions of VS Code server before v4.10.1 are vulnerable to Missing Origin Validation in WebSocket handshakes.
  For mitigation steps, see [Known issues for Learning Center](./learning-center/known-issues.hbs.md).

#### <a id='1-6-3-stk-ki'></a> v1.6.3 Known issues: Services Toolkit

- An error occurs if `additionalProperties` is `true` in a CompositeResourceDefinition.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#compositeresourcedef).

#### <a id='1-6-3-scc-ki'></a> v1.6.3 Known issues: Supply Chain Choreographer

- When using the Carvel Package Supply Chains, if the operator updates the parameter
  `carvel_package.name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps
  repository that uses the old value of `carvel_package.name_suffix`. You can ignore or delete this package.

- If the size of the resulting OpenAPIv3 specification exceeds a certain size, approximately 3&nbsp;KB,
  the Supply Chain does not function. If you use the default Carvel package parameters, you this
  issue does not occur. If you use custom Carvel package parameters, you might encounter this size limit.
  If you exceed the size limit, you can either deactivate this feature, or use a workaround.
  The workaround requires enabling a Tekton feature flag. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/additional-configs/#enabling-larger-results-using-sidecar-logs).

#### <a id='1-6-3-supply-chain-security-tools-store-ki'></a> v1.6.3 Supply Chain Security Tools - Store

- `Supply Chain Security Tools - Store` automatically detects PostgreSQL Database Index corruptions. Supply Chain Security Tools - Store does not reconcile if it finds a Postgres database index corruption issue. For information about remediating this issue, see [Fix Postgres Database Index Corruption](scst-store/database-index-corruption.hbs.md).

#### <a id='1-6-3-tap-gui-ki'></a> v1.6.3 Known issues: Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Developer Portal.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

#### <a id='1-6-3-sc-plugin-ki'></a> v1.6.3 Known issues: Tanzu Developer Portal - Supply Chain GUI plug-in

- Any workloads created by using a custom resource definition (CRD) might not work as expected.
  Only Out of the Box (OOTB) Supply Chains are supported in the UI.

- Downloading the SBOM from a vulnerability scan requires additional configuration in
  `tap-values.yaml`. For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#sbom-not-working).

#### <a id='1-6-3-intellij-plugin-ki'></a> v1.6.3 Known issues: Tanzu Developer Tools for IntelliJ

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

#### <a id='1-6-3-vs-plugin-ki'></a> v1.6.3 Known issues: Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

#### <a id='1-6-3-vscode-plugin-ki'></a> v1.6.3 Known issues: Tanzu Developer Tools for VS Code

- In the Tanzu activity panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

### <a id='1-6-3-components'></a> v1.6.3 Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                                   | Version |
| ---------------------------------------------------------------- | ------- |
| API Auto Registration                                            | 0.3.3   |
| API portal                                                       | 1.4.1   |
| Application Accelerator                                          | 1.6.2   |
| Application Configuration Service                                | 2.1.1   |
| Application Live View API Server                                 | 1.6.1   |
| Application Live View Backend                                    | 1.6.1   |
| Application Live View Connector                                  | 1.6.1   |
| Application Live View Conventions                                | 1.6.1   |
| Application Single Sign-On                                       | 4.0.0   |
| Authentication and authorization                                 | 1.1.0   |
| Bitnami Services                                                 | 0.2.0   |
| Cartographer Conventions                                         | 0.7.3   |
| cert-manager                                                     | 2.3.1   |
| Cloud Native Runtimes                                            | 2.3.1   |
| Contour                                                          | 1.24.4  |
| Crossplane                                                       | 0.2.1   |
| Developer Conventions                                            | 0.11.0  |
| Eventing (deprecated)                                            | 2.2.4   |
| External Secrets Operator                                        | 0.6.1   |
| Flux CD Source Controller                                        | 0.36.1  |
| Learning Center (deprecated)                                     | 0.3.2   |
| Learning Center workshops (deprecated)                           | 0.3.1   |
| Local Source Proxy                                               | 0.1.0   |
| Namespace Provisioner                                            | 0.4.0   |
| Out of the Box Delivery - Basic                                  | 0.13.9  |
| Out of the Box Supply Chain - Basic                              | 0.13.9  |
| Out of the Box Supply Chain - Testing                            | 0.13.9  |
| Out of the Box Supply Chain - Testing and Scanning               | 0.13.9  |
| Out of the Box Templates                                         | 0.13.9  |
| Service Bindings                                                 | 0.9.1   |
| Services Toolkit                                                 | 0.11.0  |
| Source Controller                                                | 0.8.1   |
| Spring Boot conventions                                          | 1.6.1   |
| Spring Cloud Gateway                                             | 2.0.6   |
| Supply Chain Choreographer                                       | 0.7.3   |
| Supply Chain Security Tools - Policy Controller                  | 1.4.0   |
| Supply Chain Security Tools - Scan                               | 1.6.141 |
| Supply Chain Security Tools - Store                              | 1.6.3   |
| Tanzu Developer Portal (formerly Tanzu Application Platform GUI) | 1.6.5   |
| Tanzu Application Platform Telemetry                             | 0.6.1   |
| Tanzu Build Service                                              | 1.11.13 |
| Tanzu CLI                                                        | 1.0.0   |
| Tekton Pipelines                                                 | 0.41.0  |

---

## <a id='1-6-2'></a> v1.6.2

**Release Date**: 15 August 2023

### <a id='1-6-2-security-fixes'></a> v1.6.2 Security fixes

This release has the following security fixes, listed by component and area.

<table>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
<tr>
<td>accelerator.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
</ul></details></td>
</tr>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
</ul></details></td>
</tr>
<tr>
<td>app-scanning.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-g2j6-57v7-gm8c">GHSA-g2j6-57v7-gm8c</a></li>
<li><a href="https://github.com/advisories/GHSA-m8cg-xc2p-r3fc">GHSA-m8cg-xc2p-r3fc</a></li>
</ul></details></td>
</tr>
<tr>
<td>base-jammy-stack-lite.buildpacks.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4015">CVE-2023-4015</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-4004">CVE-2023-4004</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3995">CVE-2023-3995</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3777">CVE-2023-3777</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3776">CVE-2023-3776</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3611">CVE-2023-3611</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3610">CVE-2023-3610</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3609">CVE-2023-3609</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35788">CVE-2023-35788</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-35001">CVE-2023-35001</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3390">CVE-2023-3390</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3389">CVE-2023-3389</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32233">CVE-2023-32233</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3220">CVE-2023-3220</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31436">CVE-2023-31436</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31248">CVE-2023-31248</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-3090">CVE-2023-3090</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30456">CVE-2023-30456</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2985">CVE-2023-2985</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28322">CVE-2023-28322</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28321">CVE-2023-28321</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20593">CVE-2023-20593</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1998">CVE-2023-1998</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1859">CVE-2023-1859</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1670">CVE-2023-1670</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1380">CVE-2023-1380</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1079">CVE-2023-1079</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1077">CVE-2023-1077</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1076">CVE-2023-1076</a></li>
</ul></details></td>
</tr>
<tr>
<td>fluxcd.source.controller.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
</ul></details></td>
</tr>
<tr>
<td>metadata-store.apps.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
</ul></details></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-crqg-jrpj-fc84">GHSA-crqg-jrpj-fc84</a></li>
<li><a href="https://github.com/advisories/GHSA-6mjq-h674-j845">GHSA-6mjq-h674-j845</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34035">CVE-2023-34035</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34034">CVE-2023-34034</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33008">CVE-2023-33008</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li>
</ul></details></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><details><summary>Expand to see the list</summary><ul>
<li><a href="https://github.com/advisories/GHSA-h755-8qp9-cq85">GHSA-h755-8qp9-cq85</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23936">CVE-2023-23936</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23920">CVE-2023-23920</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4304">CVE-2022-4304</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li>
<li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2097">CVE-2022-2097</a></li>
</ul></details></td>
</tr>
</table>

---

### <a id='1-6-2-resolved-issues'></a> v1.6.2 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-6-2-scc-ri'></a> v1.6.2 Resolved issues: Supply Chain Choreographer

- Fixed an issue where if a user attempted to update the `ootb_supply_chain_testing_scanning` field
  in their `tap-values.yaml` file to use a specified ClusterImageTemplate, it did not update
  because the ClusterSupplyChain was already preset to `image-scanner-template`.
  You can now update the `ootb_supply_chain_testing_scanning` field in their `tap-values.yaml` to
  use a specified ClusterImageTemplate.

#### <a id='1-6-2-sc-plugin-ri'></a> v1.6.2 Resolved issues: Tanzu Developer Portal - Supply Chain GUI plug-in

- [Supply Chain Security Tools - Scan v2.0](scst-scan/app-scanning-beta.hbs.md), which introduces the
  `ImageVulnerabilityScanner` custom resource definition (CRD), is now supported in the Supply Chain
  UI.

#### <a id='1-6-2-vscode-ext-ri'></a> v1.6.2 Resolved issues: Tanzu Developer Tools for VS Code

- Fixed an issue that prevented Tanzu Debug from working on new untracked workloads on Windows.

---

### <a id='1-6-2-known-issues'></a> v1.6.2 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-6-2-app-config-srvc-ki'></a> v1.6.2 Known issues: Application Configuration Service

- Client applications that include the `spring-cloud-config-client` dependency might fail to start or
  properly load the configuration that Application Configuration Service produced.

- Installation might fail because the pod security context does not perfectly adhere to the
  restricted pod security standard.

#### <a id='1-6-2-amr-obs-ce-hndlr-ki'></a> v1.6.2 Known issues: Artifact Metadata Repository Observer and CloudEvent Handler

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of
  ImageVulnerabilityScan results. There is an error on duplicate submission of identical
  ImageVulnerabilityScans you can ignore if the previous submission was successful.

- ReplicaSet status in AMR only has two states: `created` and `deleted`.
  There is a known issue where the `available` and `unavailable` state is not showing.
  The workaround is that you can interpolate this information from the `instances` metadata in the
  AMR for the ReplicaSet.

#### <a id='1-6-2-bitnami-services-ki'></a> v1.6.2 Known issues: Bitnami Services

- If you try to configure private registry integration for the Bitnami services
  after having already created a claim for one or more of the Bitnami services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshoot Bitnami Services](bitnami-services/how-to-guides/troubleshooting.hbs.md#private-reg).

#### <a id='1-6-2-cnrs-ki'></a> v1.6.2 Known issues: Cloud Native Runtimes

- For Knative Serving, certain app name, namespace, and domain combinations produce Knative Services
  with status `CertificateNotReady`. For more information, see
  [Troubleshooting](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.3/tanzu-cloud-native-runtimes/troubleshooting.html#certificate-not-ready-kcert).

#### <a id='1-6-2-crossplane-ki'></a> v1.6.2 Known issues: Crossplane

- Crossplane Providers cannot communicate with systems using a custom CA.
  For more information and a workaround, see [Troubleshoot Crossplane](./crossplane/how-to-guides/troubleshooting.hbs.md#cp-custom-cert-inject).

- The Crossplane `validatingwebhookconfiguration` is not removed when you uninstall the
  Crossplane Package.
  To workaround, delete the `validatingwebhookconfiguration` manually by running
  `kubectl delete validatingwebhookconfiguration crossplane`.

#### <a id='1-6-2-eventing-ki'></a> v1.6.2 Known issues: Eventing

- When using vSphere sources in Eventing, the vsphere-source is using a high number of
  informers to alleviate load on the API server. This causes high memory use.

#### <a id='1-6-2-learningcenter-ki'></a> v1.6.2 Known issues: Learning Center

- [CVE-2023-26114](https://nvd.nist.gov/vuln/detail/CVE-2023-26114):
  Versions of VS Code server before v4.10.1 are vulnerable to Missing Origin Validation in WebSocket handshakes.
  For mitigation steps, see [Known issues for Learning Center](./learning-center/known-issues.hbs.md).

#### <a id='1-6-2-stk-ki'></a> v1.6.2 Known issues: Services Toolkit

- An error occurs if `additionalProperties` is `true` in a CompositeResourceDefinition.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#compositeresourcedef).

#### <a id='1-6-2-scc-ki'></a> v1.6.2 Known issues: Supply Chain Choreographer

- When using the Carvel Package Supply Chains, if the operator updates the parameter
  `carvel_package.name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps
  repository that uses the old value of `carvel_package.name_suffix`. You can ignore or delete this package.

- If the size of the resulting OpenAPIv3 specification exceeds a certain size, approximately 3&nbsp;KB,
  the Supply Chain does not function. If you use the default Carvel package parameters, you this
  issue does not occur. If you use custom Carvel package parameters, you might encounter this size limit.
  If you exceed the size limit, you can either deactivate this feature, or use a workaround.
  The workaround requires enabling a Tekton feature flag. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/additional-configs/#enabling-larger-results-using-sidecar-logs).

#### <a id='1-6-2-supply-chain-security-tools-store-ki'></a> v1.6.2 Supply Chain Security Tools - Store

- `Supply Chain Security Tools - Store` automatically detects PostgreSQL Database Index corruptions. Supply Chain Security Tools - Store does not reconcile if it finds a Postgres database index corruption issue. For information about remediating this issue, see [Fix Postgres Database Index Corruption](scst-store/database-index-corruption.hbs.md).

#### <a id='1-6-2-tap-gui-ki'></a> v1.6.2 Known issues: Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Developer Portal.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

#### <a id='1-6-2-sc-plugin-ki'></a> v1.6.2 Known issues: Tanzu Developer Portal - Supply Chain GUI plug-in

- Any workloads created by using a custom resource definition (CRD) might not work as expected.
  Only Out of the Box (OOTB) Supply Chains are supported in the UI.

- Downloading the SBOM from a vulnerability scan requires additional configuration in
  `tap-values.yaml`. For more information, see
  [Troubleshooting](tap-gui/troubleshooting.hbs.md#sbom-not-working).

#### <a id='1-6-2-intellij-plugin-ki'></a> v1.6.2 Known issues: Tanzu Developer Tools for IntelliJ

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

#### <a id='1-6-2-vs-plugin-ki'></a> v1.6.2 Known issues: Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

#### <a id='1-6-2-vscode-plugin-ki'></a> v1.6.2 Known issues: Tanzu Developer Tools for VS Code

- In the Tanzu activity panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

---

### <a id='1-6-2-components'></a> v1.6.2 Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                                   | Version |
| ---------------------------------------------------------------- | ------- |
| API Auto Registration                                            | 0.3.3   |
| API portal                                                       | 1.4.1   |
| Application Accelerator                                          | 1.6.2   |
| Application Configuration Service                                | 2.1.0   |
| Application Live View APIServer                                  | 1.6.1   |
| Application Live View back end                                   | 1.6.1   |
| Application Live View connector                                  | 1.6.1   |
| Application Live View conventions                                | 1.6.1   |
| Application Single Sign-On                                       | 4.0.0   |
| Authentication and authorization                                 | 1.1.0   |
| Bitnami Services                                                 | 0.2.0   |
| Cartographer Conventions                                         | 0.7.3   |
| cert-manager                                                     | 2.3.1   |
| Cloud Native Runtimes                                            | 2.3.1   |
| Contour                                                          | 1.24.4  |
| Crossplane                                                       | 0.2.1   |
| Developer Conventions                                            | 0.11.0  |
| Eventing (deprecated)                                            | 2.2.3   |
| External Secrets Operator                                        | 0.6.1   |
| Flux CD Source Controller                                        | 0.36.1  |
| Learning Center (deprecated)                                     | 0.3.1   |
| Learning Center workshops (deprecated)                           | 0.3.0   |
| Local Source Proxy                                               | 0.1.0   |
| Namespace Provisioner                                            | 0.4.0   |
| Out of the Box Delivery - Basic                                  | 0.13.8  |
| Out of the Box Supply Chain - Basic                              | 0.13.8  |
| Out of the Box Supply Chain - Testing                            | 0.13.8  |
| Out of the Box Supply Chain - Testing and Scanning               | 0.13.8  |
| Out of the Box Templates                                         | 0.13.8  |
| Service Bindings                                                 | 0.9.1   |
| Services Toolkit                                                 | 0.11.0  |
| Source Controller                                                | 0.8.0   |
| Spring Boot conventions                                          | 1.6.1   |
| Spring Cloud Gateway                                             | 2.0.6   |
| Supply Chain Choreographer                                       | 0.7.3   |
| Supply Chain Security Tools - Policy Controller                  | 1.4.0   |
| Supply Chain Security Tools - Scan                               | 1.6.141 |
| Supply Chain Security Tools - Store                              | 1.6.3   |
| Tanzu Developer Portal (formerly Tanzu Application Platform GUI) | 1.6.5   |
| Tanzu Application Platform Telemetry                             | 0.6.1   |
| Tanzu Build Service                                              | 1.11.10 |
| Tanzu CLI                                                        | 0.90.1  |
| Tanzu CLI Application Accelerator plug-in                        | 1.6.0   |
| Tanzu CLI Apps plug-in                                           | 0.12.1  |
| Tanzu CLI Build Service plug-in                                  | 1.0.0   |
| Tanzu CLI Insight plug-in                                        | 1.6.3   |
| Tanzu Service CLI plug-in                                        | 0.7.0   |
| Tekton Pipelines                                                 | 0.41.0  |

---

## <a id='1-6-1'></a> v1.6.1

**Release Date**: 27 July 2023

### <a id='1-6-1-whats-new'></a> What's new in Tanzu Application Platform v1.6

This release includes the following platform-wide enhancements.

#### <a id='1-6-1-new-platform-feats'></a> New platform-wide features

- New services available with the Bitnami Service package: MongoDB and Kafka.
- Best practices required to build and deploy workloads at scale are now available
in the documentation. For more information, see [Scale workloads](scalability.hbs.md).

#### <a id='1-6-1-new-components'></a> New components

- [Local Source Proxy](local-source-proxy/about.hbs.md) offers developers a secure and user-friendly
  approach to seamlessly upload their local source code to a Tanzu Application Platform cluster.
  This enables developers to navigate their code smoothly through a predefined production pathway
  using supply chains.

  This component reduces the obstacles faced by developers who would otherwise need to manually
  specify a registry and provide their credentials on their local systems for iterative inner loop
  workflows.

---

### <a id='1-6-1-new-features'></a> v1.6.1 New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-6-1-app-acc'></a> v1.6.1 Features: Application Accelerator

- The Application Accelerator plug-in for IntelliJ has now reached general availability on [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
  The plug-in for IntelliJ now supports Git repository creation and custom type declarations for options,
  and embeds telemetry and bootstrapping provenance.
  For more information, see [Application Accelerator IntelliJ Plug-in](./application-accelerator/intellij.hbs.md).

#### <a id='1-6-1-alv'></a> v1.6.1 Features: Application Live View

- You can secure access, at the user level, to sensitive operations that can be executed on a running
  application using the actuator endpoints. For more information, see
  [Authorize a user to execute sensitive operations](app-live-view/improved-security-and-access-control.hbs.md#access-control).

- Developers can view the live information of natively compiled Spring applications by using
  Application Live View for lightweight troubleshooting.
  The pages and metrics that are currently unavailable for natively compiled Spring applications include
  threads, heap dump, memory graphs, cache manager, conditions, schedules tasks, and actuator information.
  For more information, see [Enable Spring Native apps for Application Live View](app-live-view/configuring-apps/spring-native-enablement.hbs.md).

#### <a id='1-6-1-appsso'></a> v1.6.1 Features: Application Single Sign-On (AppSSO)

- Incorporates the token expiry settings into the `AuthServer` resource. Service
  operators can customize the expiry settings of access, refresh, or identity
  tokens. For more information, see
  [Token settings](./app-sso/how-to-guides/service-operators/token-settings.hbs.md#token-expiry-settings).

- You can map custom user attributes or claims from upstream identity providers, such as
  OpenID, LDAP, and SAML. You can also configure the internal unsafe provider with custom claims.
  For more information, see [Identity providers](./app-sso/how-to-guides/service-operators/identity-providers.hbs.md#id-token-claims-mapping).

- Adds `ClusterUnsafeTestLogin`, which is an unsafe, ready-to-claim Application Single Sign-On service
  offering that you can use to get started. It is not safe for production environments.
  For more information, see [ClusterUnsafeTestLogin API](app-sso/reference/api/clusterunsafetestlogin.hbs.md).

- Adds `ClusterWorkloadRegistrationClass`, which exposes an `AuthServer` as a ready-to-claim
  Application Single Sign-On service offering. For more information, see
  [ClusterWorkloadRegistrationClass API](app-sso/reference/api/clusterworkloadregistrationclass.hbs.md).

- Adds `WorkloadRegistration`, which is a portable client registration that templates redirect URIs.
  For more information, see [WorkloadRegistration API](app-sso/reference/api/workloadregistration.hbs.md).

- Adds `XWorkloadRegistration`, which is a composite resource definition (XRD) and an integration
  API between Services Toolkit, Crossplane, and Application Single Sign-On.
  For more information, see [XWorkloadRegistration API](app-sso/reference/api/xworkloadregistration.hbs.md).

#### <a id='1-6-1-bitnami-services'></a> v1.6.1 Features: Bitnami Services

The `bitnami.services.tanzu.vmware.com` package v0.2.0 includes the following:

- New services available: MongoDB and Kafka

#### <a id='1-6-1-cnrs'></a> v1.6.1 Features: Cloud Native Runtimes

- Adds a new configuration option that configures `default-external-scheme` on Knative's `config-network`
  ConfigMap with a default scheme you can use for Knative Service URLs.
  Supported values are either `http` or `https`. You cannot set this option at the same time as the
  `default_tls_secret` option.

#### <a id='1-6-1-contour'></a> v1.6.1 Features: Contour

- Adds new parameters to specify `contour` and `envoy` resources requests and limits for CPU and memory.
  For more information, see [Install Contour](contour/install.hbs.md).

- For more information about the new features in Contour v1.24.4, see the
  [Contour release notes](https://github.com/projectcontour/contour/releases/tag/v1.24.4) in GitHub.

#### <a id='1-6-1-crossplane'></a> v1.6.1 Features: Crossplane

The `crossplane.tanzu.vmware.com` package v0.2.1 includes the following:

- Includes updates to the following software components:

  - Updates Universal Crossplane (UXP) to v1.12.1-up.1, which includes new Crossplane features such
    as ObserveOnly resources, Composition Validation, and Pluggable Secret Stores.
    For the full release notes, see
    [universal-crossplane releases](https://github.com/upbound/universal-crossplane/releases/tag/v1.12.1-up.1)
    in GitHub.
  - Updates provider-helm to v0.15.0. For the full release notes, see
    [provider-helm releases](https://github.com/crossplane-contrib/provider-helm/releases/tag/v0.15.0)
    in GitHub.
  - Updates provider-kubernetes to v0.8.0. For the full release notes, see
    [provider-kubernetes releases](https://github.com/crossplane-contrib/provider-kubernetes/releases/tag/v0.8.0)
    in GitHub.

  For more information about versions of software comprising the Crossplane package, See
  [Version matrix for Crossplane](./crossplane/reference/version-matrix.hbs.md).

- The Crossplane package now more gracefully handles situations in which Crossplane is already
  installed to a cluster by using another method, for example, through Helm install.
  For more information, see [Use your existing Crossplane installation](crossplane/how-to-guides/use-existing-crossplane.hbs.md).

- Includes kapp wait rules that match on `Healthy=True` for the Providers.
  This means that package installation now waits for the Providers to become healthy before reporting
  success.

- Adds support for installing Providers in environments that use custom CA certificates.

- Adds the `orphan_resources` package value to allow you to configure whether to orphan all Crossplane
  Custom Resource Definitions (CRDs), providers, and managed resources when the package is uninstalled.
  This setting is optional. The default is `true`.

  > **Caution** setting this value to `false` causes all Crossplane CRDs, providers, and managed
  > resources to be deleted when the `crossplane.tanzu.vmware.com` package is uninstalled.
  > This might also cause any existing service instances also being deleted.
  > For more information, see [Delete Crossplane resources when you uninstall Tanzu Application Platform](./crossplane/how-to-guides/delete-resources.hbs.md).

#### <a id='1-6-1-flux-sc'></a> v1.6.1 Features: Flux CD Source Controller

Flux Source Controller v0.36.1-build.2 release includes the following API changes:

- `GitRepository` API:

  - `spec.ref.name` is the reference value for Git checkout. It takes precedence over Branch,
  Tag, and SemVer. It must be a valid
  [Git reference](https://git-scm.com/docs/git-check-ref-format#_description).

      Examples:

      - `"refs/heads/main"`
      - `"refs/tags/v0.1.0"`
      - `"refs/pull/420/head"`
      - `"refs/merge-requests/1/head"`

  - `status.artifact.digest` represents the value of the file in the form of `ALGORITHM:CHECKSUM`.
  - `status.observedIgnore` represents the latest `spec.ignore` value. It indicates the ignore
    rules for building the current artifact in storage.
  - `status.observedRecurseSubmodules` represents the latest `spec.recurseSubmodules` value
    during the latest reconciliation.
  - `status.observedInclude` represents the list of `GitRepository` resources that produces
    the current artifact.

- `OCIRepository` API:

  - `spec.layerSelector` specifies which layer is extracted from an OCI Artifact.
    This field is optional and set to extracting the first layer in the artifact by default.
  - `spec.verify` includes the secret name that holds the trusted public keys for signature verification.
    It also indicates the provider responsible for validating the authenticity of the OCI image.
  - `spec.insecure` enables connections to a non-TLS HTTP container image registry.

- `HelmChart` API:

  - Adds the new field `spec.verify`, which includes the secret name that holds
    the trusted public keys for signature verification.
    It also indicates the provider responsible for validating the authenticity of the OCI image.
    This field is only supported when using the HelmRepository source with the `spec.type` OCI.
    Chart dependencies, which are not bundled in the umbrella chart artifact, are not verified.

- `HelmRepository` API:

  - Adds the new field `spec.provider` for authentication purposes. Supported values are
    `aws`, `azure`, `gcp`, or `generic`.
    `generic` is its default value. This field is only required when the `.spec.type` field is set to `oci`

- `Bucket` API:

  - Adds the new field `status.observedIgnore`, which represents the latest `spec.ignore` value.
    It indicates the ignore rules for building the current artifact in storage.

#### <a id='1-6-1-namespace-provisioner'></a> v1.6.1 Features: Namespace Provisioner

- Implements the capability to skip creating certain default resources for the Namespace Provisioner,
  providing greater flexibility for customization.

- Enables you to deactivate the default installation of the Grype scanner by using `default_parameters`
  in the `tap-values.yaml` file or by using namespace parameters. For more information, see
  [Deactivate Grype install](namespace-provisioner/use-case4.hbs.md#deactivate-grype-install).

- Enhances support for adding `secrets` and `imagePullSecrets` to the service account used by the
  Supply Chain and Delivery components. You can do this by using either `default_parameters` or
  namespace-level parameters. For more information, see
  [Customize service accounts](namespace-provisioner/use-case4.hbs.md#customize-service-accounts).

- Introduces the option to deactivate the creation of the LimitRange object in `full`, `iterate`,
  and `run` profile clusters. For more information, see
  [Deactivate LimitRange Setup](namespace-provisioner/use-case4.hbs.md#deactivate-limitrange-setup).

- Adds support for passing lists or objects with annotations for complex namespace parameters.
  This simplifies the configuration process. For more information about how to use this feature, see
  [Namespace parameters](namespace-provisioner/parameters.hbs.md).

- The `path` value in `additional_sources` is now automatically generated, eliminating the need for
  you to provide it manually. This simplifies the configuration of external sources.

#### <a id='1-6-1-stk'></a> v1.6.1 Features: Services Toolkit

The `services-toolkit.tanzu.vmware.com` package v0.11.0 includes the following:

- Adds Kubernetes events to make debugging easier:
  - Normal events: CreatedCompositeResource, DeletedCompositeResource, ClaimableInstanceFound,
    NoClaimableInstancesFound
  - Warning events: ParametersValidationFailed, CompositeResourceDeletionFailed

- Updates reconciler-runtime to v0.11.1.

The Tanzu Service CLI plug-in v0.7.0 includes the following:

- The Tanzu Service CLI plug-in is now compiled using the new Tanzu CLI runtime (v0.90.0).
- There are no new features or changes to existing commands.

#### <a id='1-6-1-scc'></a> v1.6.1 Features: Supply Chain Choreographer

- [Carvel Package Supply Chains](scc/carvel-package-supply-chain.hbs.md) are promoted from `alpha` to `beta`.

#### <a id='1-6-1-scst-scan'></a> v1.6.1 Features: Supply Chain Security Tools (SCST) - Scan

- The source scanning step is removed from the Out of the Box Supply Chain - Testing and Scanning.
  For information about how to add the source scanning step to the test and scan supply chain, see
  [Scan Types for Supply Chain Security Tools - Scan](scst-scan/scan-types.hbs.md#source-scan).

- [Supply Chain Security Tools - Scan 2.0](scst-scan/app-scanning-beta.hbs.md) is promoted from `alpha`
  to `beta`.  This promotion primarily includes capabilities to integrate the SCST-Scan 2.0 component
  with other components of the Tanzu Application Platform, including:

  - The ability to enable Supply Chain Security Tools (SCST) - Scan 2.0 in the
    Out of the Box Supply Chain - Testing and Scanning. For more information, see
    [Add app scanning to default test and scan supply chains](scst-scan/integrate-app-scanning.hbs.md#adding-app-scanning-to-default-test-and-scan-supply-chain).
  - [Artifact Metadata Repository (AMR) Observer (alpha)](scst-store/amr/overview.hbs.md#amr-observer)
    observes scan results from SCST - Scan 2.0 and archives them to the
    [AMR (beta)](scst-store/amr/architecture.hbs.md) for long-term storage and reporting, and use by
    other Tanzu Application Platform components.
  - Results from image scans with SCST - Scan 2.0 are now available in
    [Supply Chain Choreographer](tap-gui/plugins/scc-tap-gui.hbs.md) and
    [Security Analysis](tap-gui/plugins/sa-tap-gui.hbs.md) plug-ins for the Tanzu Developer Portal.
  - [Sample scan templates](scst-scan/ivs-custom-samples.hbs.md) are created to help users get started
    with examples of how to bring your own scanner:
      - [Carbon Black](scst-scan/ivs-carbon-black.hbs.md)
      - [Snyk](scst-scan/ivs-snyk.hbs.md)
      - [Prisma](scst-scan/ivs-prisma.hbs.md)
      - [Trivy](scst-scan/ivs-trivy.hbs.md)
      - [Grype](scst-scan/ivs-grype.hbs.md)
  - VMware encourages feedback about SCST - Scan 2.0. Email your VMware representative or [contact us here](https://tanzu.vmware.com/application-platform).

#### <a id='1-6-1-scst-store'></a> v1.6.1 Features: Supply Chain Security Tools (SCST) - Store

- Adds a new report feature that links all packages, vulnerabilities, and ratings
  associated from a specific vulnerability scan SBOM to a Store report. When
  querying a report, it returns information linked to the original SBOM report
  instead of returning the aggregated data of all reports for the linked image
  or source.
  - Updates to the `POST /api/v1/images` and `POST /api/v1/sources` APIs:
      - New optional header request fields:
          - `Report-UID`: A unique identifier to assign to the report. If omitted, a
            unique identifier is randomly generated for the report. Supported
            characters: uppercase letters (A-Z), lowercase letters (a-z), numbers (0-9),
            hyphen (`-`), period (`.`), underscore (`_`), and tilde (`~`).
          - `Original-Location`: The stored location of the original SBOM
            vulnerability scan result used to create this report.
      - New response field returned `ReportUID`, the report's unique identifier
      associated with the data submitted by this image.
  - Updates to the `POST /api/v1/artifact-groups` API:
      - New `ReportUID` optional body payload field that links an existing
      report, tagged by its UID, to this artifact group.
  - New `GET /api/v1/report/{ReportUID}` API gets a specific report by its unique identifier.
  - New `GET /api/v1/reports` API queries for a list of reports with specified
    image digest, source SHA, or original location.
      > **Note** When you request SPDX or CycloneDX format, the report date is
      set to the date of the original vulnerability scan SBOM. In addition, the
      tooling section includes the tool used to generate the original
      vulnerability scan report, if provided, and SCST - Store.

- Artifact Metadata Repository Observer (alpha). For more information, see [Artifact Metadata Repository overview](./scst-store/amr/overview.hbs.md)
  - Registers the cluster's location using user defined labels and the kube-system UID as the reference
  - Observes ImageVulnerabilityScan CustomResources from [SCST - Scan 2.0 package](scst-scan/app-scanning-beta.hbs.md)
  - Observes workload ReplicaSets. These are ReplicaSets that have a container with the name `workload`,
    which are produced by the Out of the Box Supply Chains.
  - Sends CloudEvents for observed resources to the Artifact Metadata Repository CloudEvent Handler

- Artifact Metadata Repository CloudEvent Handler (alpha). See [Artifact Metadata Repository overview](./scst-store/amr/overview.hbs.md).
  - The name Artifact Metadata Repository Persister is deprecated in favor of Artifact Metadata Repository
    CloudEvent Handler.
  - Handles ImageVulnerabilityScan configured CloudEvents from the Artifact Metadata Repository Observer.
  - Handles Location configured CloudEvents from the Artifact Metadata Repository Observer.
  - Handles ReplicaSet configured CloudEvents from the Artifact Metadata Repository Observer.

- Adds a new vulnerability triage feature allows you to store analysis
  data for vulnerabilities detected in their workloads. The vulnerability analysis
  data allows you to record the impact of a particular vulnerability,
  to discover an effective remediation plan.
  - New triage API supports the creating, updating, and searching vulnerability analysis.
    For more information, see [v1triage](scst-store/api.hbs.md#v1triage).
  - New triage subcommands for the Tanzu CLI Insight plug-in enable interaction with the triage API.
    For more information, see [Triage vulnerabilities](cli-plugins/insight/triaging-vulnerabilities.hbs.md).

#### <a id='1-6-1-tanzu-cli'></a> v1.6.1 Features: Tanzu CLI

- This Tanzu Application Platform release introduces the new Tanzu CLI v0.90.1.

  > **Note** Tanzu CLI v1.0 will be published soon.
  > Tanzu CLI v1.0 will provide backward compatibility for all CLI plugins required for
  > Tanzu Application Platform v1.6.1.
  > VMware strongly encourages you to upgrade to Tanzu CLI v1.0 when it becomes available.

- Backward compatibility with earlier versions of Tanzu CLI plug-ins is provided.

- Install Tanzu CLI using a package manager. For more information, see
  [Install the Tanzu CLI](install-tanzu-cli.hbs.md#install-cli).

- Install plug-ins from the new centralized plug-in repository using plug-in groups. For more
  information, see [Install Tanzu CLI Plug-ins](install-tanzu-cli.hbs.md#install-plugins).

- For Internet-restricted environments, plug-ins and plug-in groups can be migrated to, and
  installed from internal registries.

- There is now central Tanzu CLI documentation where more detailed information about the CLI
  architecture, the centralized plug-in repository, plug-in groups, and Internet-restricted
  environments is available. For more information, see
  [VMware Tanzu CLI documentation](https://docs.vmware.com/en/VMware-Tanzu-CLI/index.html).

- For the comprehensive list of what's new in this release of Tanzu CLI, see the
  [VMware Tanzu CLI v0.90.x release notes](https://docs.vmware.com/en/VMware-Tanzu-CLI/0.90.0/tanzu-cli/release-notes.html).

- If you have any issues, questions, or suggestions, you can submit feedback, feature requests, or
  issue reports in the open-source [Tanzu CLI project on GitHub](https://github.com/vmware-tanzu/tanzu-cli).

#### <a id='1-6-1-tanzu-cli-plugins'></a> v1.6.1 Features: Tanzu CLI plug-in distribution change

- Tanzu CLI plug-ins are no longer distributed as part of the Tanzu Application Platform bundle on
  VMware Tanzu Network. The Tanzu CLI is still included in the bundle.

- The plug-ins are now installed using Tanzu CLI commands. Manual download of the plug-in binaries
  to the local file system is no longer required.

- For Internet-restricted environments, see
  [Installing the Tanzu CLI in Internet-Restricted Environments](https://docs.vmware.com/en/VMware-Tanzu-CLI/0.90.0/tanzu-cli/index.html#internet-restricted-install).

#### <a id='1-6-1-apps-cli-plugin'></a> v1.6.1 Features: Tanzu CLI Apps plug-in

- The apps plug-in is integrated with Local Source Proxy for seamless iterative inner-loop development
  using the Tanzu CLI or IDE plug-ins.

- The `tanzu apps workload apply` and `tanzu apps workload create` commands can now seamlessly create
  a workload from local source using only the `--local-path` flag.

- The `--source-image` flag is now optional. If `--source-image` flag is used with `--local-path`,
  the local source proxy is not used and bypassed for backward compatibility.

- A new command, `tanzu apps lsp health` is available. It allows you to verify the status of the
  Local Source Proxy. This command performs several checks, including:
  - Verifies whether the developer has Role-Based Access Control (RBAC) permissions to access the
    Local Source Proxy using their kubeconfig.
  - Checks if the Local Source Proxy is installed on the cluster.
  - Ensures that the Local Source Proxy deployment is healthy and accessible.
  - Verifies that the Local Source Proxy is correctly configured and can access the registry using the
    credentials set up by the operator during Tanzu Application Platform installation.

- Auto-completion is available for workload types. Additionally, the default workload type is set to
  `web`, making the `--type` flag optional.
  The flag is only required if the type is something other than `web`.

- The shorthand option `-e` is available as a convenient alternative for the `--export` flag.

- The `tanzu apps workload get` command is enhanced to include Git revision information in the
  overview section. This provides a quick reference to the Git revision associated with the workload.

#### <a id='1-6-1-tbs-plugin'></a> v1.6.1 Features: Tanzu CLI Build Service plug-in

- Adds a new Build Service plug-in that allows you to view all Tanzu Build Service resources on any
  Kubernetes cluster that has Tanzu Application Platform or Tanzu Build Service installed.
  For more information, see [Build Service CLI plug-in overview](cli-plugins/build-service/overview.hbs.md).

#### <a id='1-6-1-insight-cli-plugin'></a> v1.6.1 Features: Tanzu CLI Insight plug-in

- Triage vulnerabilities with the `tanzu insight triage` command. For more information, see
  [Triage vulnerabilities](cli-plugins/insight/triaging-vulnerabilities.hbs.md).

#### <a id='1-6-1-tap-dev-portal'></a> v1.6.1 Features: Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- Download the Software Bill of Materials (SBOM) from the Supply Chain Cartographer (SCC) plug-in.
  Obtain the SCST - Store-generated SBOM in SPDX or CycloneDX formats.

- The component is renamed as Tanzu Developer Portal to reflect that it's more than just a graphical
  user interface (GUI) for Tanzu Application Platform.

- As of this release, the tool Configurator is available in beta. Configurator enables
  the integration of Backstage-compatible plug-ins in Tanzu Developer Portal. For more information,
  see [Tanzu Developer Portal Configurator](tap-gui/configurator/about.hbs.md).

- Permission framework is released in alpha. Permission framework enables the Platform Operator to
  evaluate visibility restriction of the software catalog entities based on ownership property.
  For more information, see [Set up permission framework for your Tanzu Developer Portal](tap-gui/tap-gui-rbac/set-up-tap-gui-prmssn-frmwrk.hbs.md)

#### <a id='1-6-1-intellij-ext'></a> v1.6.1 Features: Tanzu Developer Tools for IntelliJ

- Added support for Local Source Proxy that eliminates the need to provide source image configuration
  for rapid iteration in the inner loop.

- You can now use Tanzu Developer Tools for IntelliJ to rapidly iterate on Spring-native applications.
  Developers can Live Update and debug spring-native applications non-natively and then deploy
  to a cluster as a native image.

- Developers can now use Tanzu Developer Tools for IntelliJ to rapidly iterate and build Gradle
  projects in their preferred IDE.

#### <a id='1-6-1-vscode-ext'></a> v1.6.1 Features: Tanzu Developer Tools for VS Code

- Added support for Local Source Proxy that eliminates the need to provide source image configuration
  for rapid iteration in the inner loop.

- You can now use Tanzu Developer Tools for VS Code to rapidly iterate on Spring-native applications.
  Developers can Live Update and debug spring-native applications non-natively and then deploy
  to a cluster as a native image.

- Developers can now use Tanzu Developer Tools for VS Code to rapidly iterate and build Gradle
  projects in their preferred IDE.

#### <a id='1-6-1-visualstudio-ext'></a> v1.6.1 Features: Tanzu Developer Tools for Visual Studio

- Added a Tanzu Workloads panel to easily view deployed workloads in a Tanzu Application Platform
  cluster.
- You can now use Tanzu Developer Tools for Visual Studio to directly manage workloads, which includes
  the functions Apply Workload, Start Live Update, and Debug Workload.

---

### <a id='1-6-1-breaking-changes'></a> v1.6.1 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-6-1-appsso-bc'></a> v1.6.1 Breaking changes: Application Single Sign-On (AppSSO)

- Consumes Application Single Sign-On service offerings using `ClassClaim` instead of the lower-level
  `WorkloadRegistration` or `ClientRegistration`.

- Crossplane is an installation and runtime dependency of Application Single Sign-On.

- The field `AuthServer.spec.tls.disabled` is removed. Use `AuthServer.spec.tls.deactivated` instead.

- The default for field `ClientRegistration.spec.redirectURIs` is no longer `["http://127.0.0.0:8080"]`.

#### <a id='1-6-1-cnrs-bc'></a> v1.6.1 Breaking changes: Cloud Native Runtimes

- The `provider` configuration option is removed in this release. For more information, see the
 [Deprecation notice](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.0/tanzu-cloud-native-runtimes/GUID-release-notes.html#deprecation-notice-13)
 in the Cloud Native Runtimes v2.0 release notes.

#### <a id='1-6-1-flux-sc-bc'></a> v1.6.1 Breaking changes: Flux CD Source Controller

- The format of the `status.artifact.revision` value in the `GitRepository` resource's
  status field is updated from `BRANCH/CHECKSUM` to `BRANCH@sha1:CHECKSUM`.
  For example, `main/6db88c7a7e7dec1843809b058195b68480c4c12a` is now `main@sha1:6db88c7a7e7dec1843809b058195b68480c4c12a`.

#### <a id='1-6-1-buildservice-bc'></a> v1.6.1 Breaking changes: Tanzu Build Service

- The full dependencies package is renamed and the installation process is modified.
  - You must remove existing full dependencies installations before installing the new version.
  - You must provide the `tap-values.yaml` file during the full dependencies package installation.

- The full dependencies package repository is tagged with the Tanzu Application Platform package
  version instead of the Tanzu Build Service package version.

- The Ubuntu Bionic stack is no longer included with the Tanzu Application Platform and the full
  dependencies package repository.

- Introduced a cluster buildpack resource to enable individually packaged dependencies and provide
  insights into installed buildpack versions.

#### <a id='1-6-1-apps-cli-plugin-bc'></a> v1.6.1 Breaking changes: Tanzu CLI Apps plug-in

- The deprecated command `tanzu apps workload update` is removed from the CLI.
  Use the command `tanzu apps workload apply` instead.

#### <a id='1-6-1-tap-gui-bc'></a> v1.6.1 Breaking changes: Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- The `allowGuestAccess` configuration option: Previously this was not needed in the configuration because
  users were permitted to log in without credentials by default. In v1.6 and later, guest users must
  be permitted explicitly.
  The recommended values files in the installation sections are updated to include this setting.
  Add the following lines to `tap-values.yaml` to enable guest access explicitly:

    ```yaml
    # Existing tap-values.yaml settings
    tap_gui:
      app_config:
        auth:
          allowGuestAccess: true  # Allows unauthenticated users to log in to your portal. If you deactivate it, configure an alternative auth provider.
    ```

---

### <a id='1-6-1-security-fixes'></a> v1.6.1 Security fixes

This release has the following security fixes, listed by component and area.

| Package name | Vulnerabilities resolved |
| ------------ | ------------------------ |
| accelerator.apps.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-3f7h-mf4q-vrm4">GHSA-3f7h-mf4q-vrm4</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20861">CVE-2023-20861</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-29458">CVE-2022-29458</a></li></ul></details>|
| api-portal.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-29458">CVE-2022-29458</a></li></ul></details>|
| apis.apps.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| apiserver.appliveview.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| app-scanning.apps.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| application-configuration-service.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20861">CVE-2023-20861</a></li></ul></details>|
| backend.appliveview.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| buildservice.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-m5m3-46gj-wch8">GHSA-m5m3-46gj-wch8</a></li><li><a href="https://github.com/advisories/GHSA-hw7c-3rfg-p46j">GHSA-hw7c-3rfg-p46j</a></li><li><a href="https://github.com/advisories/GHSA-gwrp-pvrq-jmwv">GHSA-gwrp-pvrq-jmwv</a></li><li><a href="https://github.com/advisories/GHSA-gp7f-rwcx-9369">GHSA-gp7f-rwcx-9369</a></li><li><a href="https://github.com/advisories/GHSA-2qjp-425j-52j9">GHSA-2qjp-425j-52j9</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33288">CVE-2023-33288</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33203">CVE-2023-33203</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32254">CVE-2023-32254</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32250">CVE-2023-32250</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32233">CVE-2023-32233</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31436">CVE-2023-31436</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30772">CVE-2023-30772</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30456">CVE-2023-30456</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2953">CVE-2023-2953</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28466">CVE-2023-28466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28327">CVE-2023-28327</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28322">CVE-2023-28322</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28321">CVE-2023-28321</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26242">CVE-2023-26242</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2194">CVE-2023-2194</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2156">CVE-2023-2156</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20861">CVE-2023-20861</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2007">CVE-2023-2007</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1998">CVE-2023-1998</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1990">CVE-2023-1990</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1989">CVE-2023-1989</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1859">CVE-2023-1859</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1855">CVE-2023-1855</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1670">CVE-2023-1670</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1611">CVE-2023-1611</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1380">CVE-2023-1380</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1194">CVE-2023-1194</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1193">CVE-2023-1193</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1079">CVE-2023-1079</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1077">CVE-2023-1077</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1076">CVE-2023-1076</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0030">CVE-2023-0030</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48425">CVE-2022-48425</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45888">CVE-2022-45888</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45885">CVE-2022-45885</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45884">CVE-2022-45884</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4543">CVE-2022-4543</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-44034">CVE-2022-44034</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-44033">CVE-2022-44033</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-44032">CVE-2022-44032</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4285">CVE-2022-4285</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41848">CVE-2022-41848</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40133">CVE-2022-40133</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-38457">CVE-2022-38457</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-38096">CVE-2022-38096</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36402">CVE-2022-36402</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36033">CVE-2022-36033</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3523">CVE-2022-3523</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3238">CVE-2022-3238</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3114">CVE-2022-3114</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2961">CVE-2022-2961</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27943">CVE-2022-27943</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-25836">CVE-2022-25836</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1247">CVE-2022-1247</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0995">CVE-2022-0995</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0480">CVE-2022-0480</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0400">CVE-2022-0400</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-45261">CVE-2021-45261</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-4148">CVE-2021-4148</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-4095">CVE-2021-4095</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3864">CVE-2021-3864</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-29425">CVE-2021-29425</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-26934">CVE-2021-26934</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-35501">CVE-2020-35501</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-14304">CVE-2020-14304</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-13844">CVE-2020-13844</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-19814">CVE-2019-19814</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-19378">CVE-2019-19378</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-15213">CVE-2019-15213</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-14899">CVE-2019-14899</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-1010204">CVE-2019-1010204</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-6952">CVE-2018-6952</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-20657">CVE-2018-20657</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-17977">CVE-2018-17977</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12931">CVE-2018-12931</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12930">CVE-2018-12930</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12929">CVE-2018-12929</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12928">CVE-2018-12928</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-1121">CVE-2018-1121</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-1000021">CVE-2018-1000021</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-13716">CVE-2017-13716</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-13693">CVE-2017-13693</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-13165">CVE-2017-13165</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-0537">CVE-2017-0537</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-8660">CVE-2016-8660</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2015-8553">CVE-2015-8553</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2013-7445">CVE-2013-7445</a></li></ul></details>|
| cnrs.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| connector.appliveview.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| controller.source.apps.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-hw7c-3rfg-p46j">GHSA-hw7c-3rfg-p46j</a></li><li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li><li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li></ul></details>|
| conventions.appliveview.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| developer-conventions.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| fluxcd.source.controller.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-pwcw-6f5g-gxf8">GHSA-pwcw-6f5g-gxf8</a></li><li><a href="https://github.com/advisories/GHSA-hmfx-3pcx-653p">GHSA-hmfx-3pcx-653p</a></li><li><a href="https://github.com/advisories/GHSA-7hfp-qfw3-5jxh">GHSA-7hfp-qfw3-5jxh</a></li><li><a href="https://github.com/advisories/GHSA-6rx9-889q-vv2r">GHSA-6rx9-889q-vv2r</a></li><li><a href="https://github.com/advisories/GHSA-67fx-wx78-jx33">GHSA-67fx-wx78-jx33</a></li><li><a href="https://github.com/advisories/GHSA-53c4-hhmh-vw5q">GHSA-53c4-hhmh-vw5q</a></li><li><a href="https://github.com/advisories/GHSA-2qjp-425j-52j9">GHSA-2qjp-425j-52j9</a></li><li><a href="https://github.com/advisories/GHSA-259w-8hf6-59c2">GHSA-259w-8hf6-59c2</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| learningcenter.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-hhqj-cfjx-vj25">GHSA-hhqj-cfjx-vj25</a></li><li><a href="https://github.com/advisories/GHSA-gp7f-rwcx-9369">GHSA-gp7f-rwcx-9369</a></li><li><a href="https://github.com/advisories/GHSA-ccxc-vr6p-4858">GHSA-ccxc-vr6p-4858</a></li><li><a href="https://github.com/advisories/GHSA-8gw7-4j42-w388">GHSA-8gw7-4j42-w388</a></li><li><a href="https://github.com/advisories/GHSA-3633-5h82-39pq">GHSA-3633-5h82-39pq</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29469">CVE-2023-29469</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29007">CVE-2023-29007</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28487">CVE-2023-28487</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28486">CVE-2023-28486</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28484">CVE-2023-28484</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28328">CVE-2023-28328</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27538">CVE-2023-27538</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27536">CVE-2023-27536</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27535">CVE-2023-27535</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27534">CVE-2023-27534</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27533">CVE-2023-27533</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27522">CVE-2023-27522</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27320">CVE-2023-27320</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26607">CVE-2023-26607</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26606">CVE-2023-26606</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26605">CVE-2023-26605</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26545">CVE-2023-26545</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26544">CVE-2023-26544</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25815">CVE-2023-25815</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25690">CVE-2023-25690</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25652">CVE-2023-25652</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23918">CVE-2023-23918</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23916">CVE-2023-23916</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23915">CVE-2023-23915</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23914">CVE-2023-23914</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23559">CVE-2023-23559</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23455">CVE-2023-23455</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23454">CVE-2023-23454</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21843">CVE-2023-21843</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21835">CVE-2023-21835</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21830">CVE-2023-21830</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2166">CVE-2023-2166</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21102">CVE-2023-21102</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2006">CVE-2023-2006</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2004">CVE-2023-2004</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1872">CVE-2023-1872</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1652">CVE-2023-1652</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1382">CVE-2023-1382</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1264">CVE-2023-1264</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1195">CVE-2023-1195</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1175">CVE-2023-1175</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1170">CVE-2023-1170</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1074">CVE-2023-1074</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1073">CVE-2023-1073</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0804">CVE-2023-0804</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0803">CVE-2023-0803</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0802">CVE-2023-0802</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0801">CVE-2023-0801</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0800">CVE-2023-0800</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0799">CVE-2023-0799</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0798">CVE-2023-0798</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0797">CVE-2023-0797</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0796">CVE-2023-0796</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0795">CVE-2023-0795</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0458">CVE-2023-0458</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0433">CVE-2023-0433</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0394">CVE-2023-0394</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0361">CVE-2023-0361</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0288">CVE-2023-0288</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0266">CVE-2023-0266</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0210">CVE-2023-0210</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0054">CVE-2023-0054</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0051">CVE-2023-0051</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0049">CVE-2023-0049</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0045">CVE-2023-0045</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48424">CVE-2022-48424</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48423">CVE-2022-48423</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4842">CVE-2022-4842</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48303">CVE-2022-48303</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47929">CVE-2022-47929</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47521">CVE-2022-47521</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47520">CVE-2022-47520</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47519">CVE-2022-47519</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47518">CVE-2022-47518</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47024">CVE-2022-47024</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45869">CVE-2022-45869</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4415">CVE-2022-4415</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4382">CVE-2022-4382</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4379">CVE-2022-4379</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42329">CVE-2022-42329</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42328">CVE-2022-42328</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4139">CVE-2022-4139</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4129">CVE-2022-4129</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41218">CVE-2022-41218</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40898">CVE-2022-40898</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36280">CVE-2022-36280</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36056">CVE-2022-36056</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36033">CVE-2022-36033</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3545">CVE-2022-3545</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3521">CVE-2022-3521</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3435">CVE-2022-3435</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3424">CVE-2022-3424</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3344">CVE-2022-3344</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3169">CVE-2022-3169</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2980">CVE-2022-2980</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2946">CVE-2022-2946</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2923">CVE-2022-2923</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2849">CVE-2022-2849</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2845">CVE-2022-2845</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2581">CVE-2022-2581</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2571">CVE-2022-2571</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-24963">CVE-2022-24963</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-23649">CVE-2022-23649</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2345">CVE-2022-2345</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2344">CVE-2022-2344</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2304">CVE-2022-2304</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2207">CVE-2022-2207</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2206">CVE-2022-2206</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2196">CVE-2022-2196</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2183">CVE-2022-2183</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2175">CVE-2022-2175</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2129">CVE-2022-2129</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2126">CVE-2022-2126</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2125">CVE-2022-2125</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2124">CVE-2022-2124</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1968">CVE-2022-1968</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1942">CVE-2022-1942</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1927">CVE-2022-1927</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1898">CVE-2022-1898</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1851">CVE-2022-1851</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1796">CVE-2022-1796</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1785">CVE-2022-1785</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1735">CVE-2022-1735</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1733">CVE-2022-1733</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1720">CVE-2022-1720</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1674">CVE-2022-1674</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1629">CVE-2022-1629</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0729">CVE-2022-0729</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0714">CVE-2022-0714</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0685">CVE-2022-0685</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0629">CVE-2022-0629</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0572">CVE-2022-0572</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0554">CVE-2022-0554</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0443">CVE-2022-0443</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0413">CVE-2022-0413</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0408">CVE-2022-0408</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0368">CVE-2022-0368</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0361">CVE-2022-0361</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0359">CVE-2022-0359</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0351">CVE-2022-0351</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0319">CVE-2022-0319</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0318">CVE-2022-0318</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0261">CVE-2022-0261</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0213">CVE-2022-0213</a></li></ul></details>|
| metadata-store.apps.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29469">CVE-2023-29469</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28484">CVE-2023-28484</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2455">CVE-2023-2455</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2454">CVE-2023-2454</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4415">CVE-2022-4415</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-39537">CVE-2021-39537</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-17595">CVE-2019-17595</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-17594">CVE-2019-17594</a></li></ul></details>|
| ootb-templates.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-m8cg-xc2p-r3fc">GHSA-m8cg-xc2p-r3fc</a></li><li><a href="https://github.com/advisories/GHSA-hw7c-3rfg-p46j">GHSA-hw7c-3rfg-p46j</a></li><li><a href="https://github.com/advisories/GHSA-g2j6-57v7-gm8c">GHSA-g2j6-57v7-gm8c</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28328">CVE-2023-28328</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27538">CVE-2023-27538</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27536">CVE-2023-27536</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27535">CVE-2023-27535</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27534">CVE-2023-27534</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27533">CVE-2023-27533</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26606">CVE-2023-26606</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26545">CVE-2023-26545</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26544">CVE-2023-26544</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23559">CVE-2023-23559</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23455">CVE-2023-23455</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23454">CVE-2023-23454</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21102">CVE-2023-21102</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1872">CVE-2023-1872</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1829">CVE-2023-1829</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1652">CVE-2023-1652</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1281">CVE-2023-1281</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1074">CVE-2023-1074</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1073">CVE-2023-1073</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0458">CVE-2023-0458</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0394">CVE-2023-0394</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0386">CVE-2023-0386</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0266">CVE-2023-0266</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0210">CVE-2023-0210</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0045">CVE-2023-0045</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48424">CVE-2022-48424</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48423">CVE-2022-48423</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4842">CVE-2022-4842</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47929">CVE-2022-47929</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4382">CVE-2022-4382</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4129">CVE-2022-4129</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41218">CVE-2022-41218</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36280">CVE-2022-36280</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3424">CVE-2022-3424</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2196">CVE-2022-2196</a></li></ul></details>|
| scanning.apps.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li></ul></details>|
| services-toolkit.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-vfvj-3m3g-m532">GHSA-vfvj-3m3g-m532</a></li><li><a href="https://github.com/advisories/GHSA-v829-x6hh-cqfq">GHSA-v829-x6hh-cqfq</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27484">CVE-2023-27484</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li></ul></details>|
| sso.apps.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-m8cg-xc2p-r3fc">GHSA-m8cg-xc2p-r3fc</a></li><li><a href="https://github.com/advisories/GHSA-g2j6-57v7-gm8c">GHSA-g2j6-57v7-gm8c</a></li><li><a href="https://github.com/advisories/GHSA-f3fp-gc8g-vw66">GHSA-f3fp-gc8g-vw66</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20863">CVE-2023-20863</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20861">CVE-2023-20861</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li></ul></details>|
| tap-gui.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-x77j-w7wf-fjmw">GHSA-x77j-w7wf-fjmw</a></li><li><a href="https://github.com/advisories/GHSA-qwph-4952-7xr6">GHSA-qwph-4952-7xr6</a></li><li><a href="https://github.com/advisories/GHSA-p5gc-c584-jj6v">GHSA-p5gc-c584-jj6v</a></li><li><a href="https://github.com/advisories/GHSA-jv3g-j58f-9mq9">GHSA-jv3g-j58f-9mq9</a></li><li><a href="https://github.com/advisories/GHSA-hjrf-2m68-5959">GHSA-hjrf-2m68-5959</a></li><li><a href="https://github.com/advisories/GHSA-8cf7-32gw-wr33">GHSA-8cf7-32gw-wr33</a></li><li><a href="https://github.com/advisories/GHSA-7hv8-3fr9-j2hv">GHSA-7hv8-3fr9-j2hv</a></li><li><a href="https://github.com/advisories/GHSA-6w63-h3fj-q4vw">GHSA-6w63-h3fj-q4vw</a></li></ul></details>|
| workshops.learningcenter.tanzu.vmware.com | <details><summary>Expand to see the list</summary><ul><li><a href="https://github.com/advisories/GHSA-wxc4-f4m6-wwqv">GHSA-wxc4-f4m6-wwqv</a></li><li><a href="https://github.com/advisories/GHSA-v95c-p5hm-xq8f">GHSA-v95c-p5hm-xq8f</a></li><li><a href="https://github.com/advisories/GHSA-qq97-vm5h-rrhg">GHSA-qq97-vm5h-rrhg</a></li><li><a href="https://github.com/advisories/GHSA-p782-xgp4-8hr8">GHSA-p782-xgp4-8hr8</a></li><li><a href="https://github.com/advisories/GHSA-p5gc-c584-jj6v">GHSA-p5gc-c584-jj6v</a></li><li><a href="https://github.com/advisories/GHSA-m8cg-xc2p-r3fc">GHSA-m8cg-xc2p-r3fc</a></li><li><a href="https://github.com/advisories/GHSA-hmfx-3pcx-653p">GHSA-hmfx-3pcx-653p</a></li><li><a href="https://github.com/advisories/GHSA-hhqj-cfjx-vj25">GHSA-hhqj-cfjx-vj25</a></li><li><a href="https://github.com/advisories/GHSA-h86h-8ppg-mxmh">GHSA-h86h-8ppg-mxmh</a></li><li><a href="https://github.com/advisories/GHSA-gp7f-rwcx-9369">GHSA-gp7f-rwcx-9369</a></li><li><a href="https://github.com/advisories/GHSA-gc89-7gcr-jxqc">GHSA-gc89-7gcr-jxqc</a></li><li><a href="https://github.com/advisories/GHSA-g2j6-57v7-gm8c">GHSA-g2j6-57v7-gm8c</a></li><li><a href="https://github.com/advisories/GHSA-f3fp-gc8g-vw66">GHSA-f3fp-gc8g-vw66</a></li><li><a href="https://github.com/advisories/GHSA-c2h3-6mxw-7mvq">GHSA-c2h3-6mxw-7mvq</a></li><li><a href="https://github.com/advisories/GHSA-8gw7-4j42-w388">GHSA-8gw7-4j42-w388</a></li><li><a href="https://github.com/advisories/GHSA-77vh-xpmg-72qh">GHSA-77vh-xpmg-72qh</a></li><li><a href="https://github.com/advisories/GHSA-6wrf-mxfj-pf5p">GHSA-6wrf-mxfj-pf5p</a></li><li><a href="https://github.com/advisories/GHSA-5j5w-g665-5m35">GHSA-5j5w-g665-5m35</a></li><li><a href="https://github.com/advisories/GHSA-5ffw-gxpp-mxpf">GHSA-5ffw-gxpp-mxpf</a></li><li><a href="https://github.com/advisories/GHSA-45rm-2893-5f49">GHSA-45rm-2893-5f49</a></li><li><a href="https://github.com/advisories/GHSA-3633-5h82-39pq">GHSA-3633-5h82-39pq</a></li><li><a href="https://github.com/advisories/GHSA-33pg-m6jh-5237">GHSA-33pg-m6jh-5237</a></li><li><a href="https://github.com/advisories/GHSA-2qjp-425j-52j9">GHSA-2qjp-425j-52j9</a></li><li><a href="https://github.com/advisories/GHSA-259w-8hf6-59c2">GHSA-259w-8hf6-59c2</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-34969">CVE-2023-34969</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33288">CVE-2023-33288</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-33203">CVE-2023-33203</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32665">CVE-2023-32665</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32643">CVE-2023-32643</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32636">CVE-2023-32636</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32611">CVE-2023-32611</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32269">CVE-2023-32269</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32254">CVE-2023-32254</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-32250">CVE-2023-32250</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-31484">CVE-2023-31484</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-30772">CVE-2023-30772</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2953">CVE-2023-2953</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29499">CVE-2023-29499</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29491">CVE-2023-29491</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29469">CVE-2023-29469</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-29007">CVE-2023-29007</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28531">CVE-2023-28531</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28487">CVE-2023-28487</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28486">CVE-2023-28486</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28484">CVE-2023-28484</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28466">CVE-2023-28466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28328">CVE-2023-28328</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28327">CVE-2023-28327</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28322">CVE-2023-28322</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-28321">CVE-2023-28321</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27538">CVE-2023-27538</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27536">CVE-2023-27536</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27535">CVE-2023-27535</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27534">CVE-2023-27534</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27533">CVE-2023-27533</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27522">CVE-2023-27522</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27320">CVE-2023-27320</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-27043">CVE-2023-27043</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26607">CVE-2023-26607</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26606">CVE-2023-26606</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26605">CVE-2023-26605</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26545">CVE-2023-26545</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26544">CVE-2023-26544</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2650">CVE-2023-2650</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26242">CVE-2023-26242</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2612">CVE-2023-2612</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2610">CVE-2023-2610</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2609">CVE-2023-2609</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2603">CVE-2023-2603</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2602">CVE-2023-2602</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25815">CVE-2023-25815</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25690">CVE-2023-25690</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25652">CVE-2023-25652</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25588">CVE-2023-25588</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25585">CVE-2023-25585</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25584">CVE-2023-25584</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25180">CVE-2023-25180</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-25012">CVE-2023-25012</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24593">CVE-2023-24593</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2426">CVE-2023-2426</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23936">CVE-2023-23936</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23920">CVE-2023-23920</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23918">CVE-2023-23918</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23916">CVE-2023-23916</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23915">CVE-2023-23915</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23914">CVE-2023-23914</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23559">CVE-2023-23559</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23455">CVE-2023-23455</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23454">CVE-2023-23454</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23004">CVE-2023-23004</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23000">CVE-2023-23000</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-22995">CVE-2023-22995</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2283">CVE-2023-2283</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2269">CVE-2023-2269</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2235">CVE-2023-2235</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2194">CVE-2023-2194</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21843">CVE-2023-21843</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21835">CVE-2023-21835</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21830">CVE-2023-21830</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2166">CVE-2023-2166</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2162">CVE-2023-2162</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2156">CVE-2023-2156</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2124">CVE-2023-2124</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-21102">CVE-2023-21102</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20938">CVE-2023-20938</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2007">CVE-2023-2007</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2006">CVE-2023-2006</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2004">CVE-2023-2004</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-2002">CVE-2023-2002</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1999">CVE-2023-1999</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1998">CVE-2023-1998</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1990">CVE-2023-1990</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1989">CVE-2023-1989</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1972">CVE-2023-1972</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1872">CVE-2023-1872</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1859">CVE-2023-1859</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1855">CVE-2023-1855</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1670">CVE-2023-1670</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1667">CVE-2023-1667</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1652">CVE-2023-1652</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1611">CVE-2023-1611</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1513">CVE-2023-1513</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1382">CVE-2023-1382</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1264">CVE-2023-1264</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1255">CVE-2023-1255</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1195">CVE-2023-1195</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1194">CVE-2023-1194</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1193">CVE-2023-1193</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1192">CVE-2023-1192</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1175">CVE-2023-1175</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1170">CVE-2023-1170</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1118">CVE-2023-1118</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1079">CVE-2023-1079</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1078">CVE-2023-1078</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1077">CVE-2023-1077</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1076">CVE-2023-1076</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1075">CVE-2023-1075</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1074">CVE-2023-1074</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-1073">CVE-2023-1073</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0804">CVE-2023-0804</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0803">CVE-2023-0803</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0802">CVE-2023-0802</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0801">CVE-2023-0801</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0800">CVE-2023-0800</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0799">CVE-2023-0799</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0798">CVE-2023-0798</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0797">CVE-2023-0797</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0796">CVE-2023-0796</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0795">CVE-2023-0795</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0597">CVE-2023-0597</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0464">CVE-2023-0464</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0459">CVE-2023-0459</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0458">CVE-2023-0458</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0433">CVE-2023-0433</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0401">CVE-2023-0401</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0394">CVE-2023-0394</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0361">CVE-2023-0361</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0288">CVE-2023-0288</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0266">CVE-2023-0266</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0217">CVE-2023-0217</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0216">CVE-2023-0216</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0215">CVE-2023-0215</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0210">CVE-2023-0210</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0054">CVE-2023-0054</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0051">CVE-2023-0051</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0049">CVE-2023-0049</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0045">CVE-2023-0045</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0030">CVE-2023-0030</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4899">CVE-2022-4899</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48425">CVE-2022-48425</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48424">CVE-2022-48424</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48423">CVE-2022-48423</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4842">CVE-2022-4842</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-48281">CVE-2022-48281</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47929">CVE-2022-47929</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47521">CVE-2022-47521</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47520">CVE-2022-47520</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47519">CVE-2022-47519</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47518">CVE-2022-47518</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-47024">CVE-2022-47024</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-46908">CVE-2022-46908</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45919">CVE-2022-45919</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45888">CVE-2022-45888</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45887">CVE-2022-45887</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45886">CVE-2022-45886</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45885">CVE-2022-45885</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45884">CVE-2022-45884</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-45869">CVE-2022-45869</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4543">CVE-2022-4543</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4450">CVE-2022-4450</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4415">CVE-2022-4415</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-44034">CVE-2022-44034</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-44033">CVE-2022-44033</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-44032">CVE-2022-44032</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4382">CVE-2022-4382</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4379">CVE-2022-4379</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4304">CVE-2022-4304</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4285">CVE-2022-4285</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4269">CVE-2022-4269</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42329">CVE-2022-42329</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42328">CVE-2022-42328</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4203">CVE-2022-4203</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41848">CVE-2022-41848</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4139">CVE-2022-4139</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4129">CVE-2022-4129</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41218">CVE-2022-41218</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40898">CVE-2022-40898</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40735">CVE-2022-40735</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-40133">CVE-2022-40133</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3996">CVE-2022-3996</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3857">CVE-2022-3857</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-38457">CVE-2022-38457</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3821">CVE-2022-3821</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-38096">CVE-2022-38096</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3715">CVE-2022-3715</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3707">CVE-2022-3707</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36402">CVE-2022-36402</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36280">CVE-2022-36280</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36056">CVE-2022-36056</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-36033">CVE-2022-36033</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3545">CVE-2022-3545</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3523">CVE-2022-3523</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3521">CVE-2022-3521</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3435">CVE-2022-3435</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3424">CVE-2022-3424</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3344">CVE-2022-3344</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3238">CVE-2022-3238</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-32215">CVE-2022-32215</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-32214">CVE-2022-32214</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-32213">CVE-2022-32213</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-32212">CVE-2022-32212</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3169">CVE-2022-3169</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-3114">CVE-2022-3114</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2982">CVE-2022-2982</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2980">CVE-2022-2980</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2961">CVE-2022-2961</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2946">CVE-2022-2946</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-29458">CVE-2022-29458</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2923">CVE-2022-2923</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2889">CVE-2022-2889</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2862">CVE-2022-2862</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2849">CVE-2022-2849</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2845">CVE-2022-2845</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27943">CVE-2022-27943</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-27672">CVE-2022-27672</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-25836">CVE-2022-25836</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2581">CVE-2022-2581</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2571">CVE-2022-2571</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-24963">CVE-2022-24963</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-23649">CVE-2022-23649</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2345">CVE-2022-2345</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2344">CVE-2022-2344</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2343">CVE-2022-2343</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2304">CVE-2022-2304</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2207">CVE-2022-2207</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2206">CVE-2022-2206</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2196">CVE-2022-2196</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2183">CVE-2022-2183</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2182">CVE-2022-2182</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2175">CVE-2022-2175</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2129">CVE-2022-2129</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2126">CVE-2022-2126</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2125">CVE-2022-2125</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2124">CVE-2022-2124</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2097">CVE-2022-2097</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-2068">CVE-2022-2068</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1968">CVE-2022-1968</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1942">CVE-2022-1942</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1927">CVE-2022-1927</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1898">CVE-2022-1898</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1886">CVE-2022-1886</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1851">CVE-2022-1851</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1796">CVE-2022-1796</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1785">CVE-2022-1785</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1735">CVE-2022-1735</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1733">CVE-2022-1733</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1720">CVE-2022-1720</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1674">CVE-2022-1674</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1629">CVE-2022-1629</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1292">CVE-2022-1292</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-1247">CVE-2022-1247</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0995">CVE-2022-0995</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0729">CVE-2022-0729</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0714">CVE-2022-0714</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0696">CVE-2022-0696</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0685">CVE-2022-0685</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0629">CVE-2022-0629</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0572">CVE-2022-0572</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0554">CVE-2022-0554</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0480">CVE-2022-0480</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0443">CVE-2022-0443</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0413">CVE-2022-0413</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0408">CVE-2022-0408</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0407">CVE-2022-0407</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0400">CVE-2022-0400</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0393">CVE-2022-0393</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0368">CVE-2022-0368</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0361">CVE-2022-0361</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0359">CVE-2022-0359</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0351">CVE-2022-0351</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0319">CVE-2022-0319</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0318">CVE-2022-0318</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0261">CVE-2022-0261</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0213">CVE-2022-0213</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0158">CVE-2022-0158</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0156">CVE-2022-0156</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-0128">CVE-2022-0128</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-45261">CVE-2021-45261</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-4148">CVE-2021-4148</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-4095">CVE-2021-4095</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-40812">CVE-2021-40812</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3864">CVE-2021-3864</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-3712">CVE-2021-3712</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-26934">CVE-2021-26934</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2021-23840">CVE-2021-23840</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-36634">CVE-2020-36634</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-35501">CVE-2020-35501</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-17753">CVE-2020-17753</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-14304">CVE-2020-14304</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-14145">CVE-2020-14145</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-13844">CVE-2020-13844</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2020-13401">CVE-2020-13401</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-19814">CVE-2019-19814</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-19378">CVE-2019-19378</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-1563">CVE-2019-1563</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-15213">CVE-2019-15213</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-14899">CVE-2019-14899</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2019-1010204">CVE-2019-1010204</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-6952">CVE-2018-6952</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-20699">CVE-2018-20699</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-20657">CVE-2018-20657</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-17977">CVE-2018-17977</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12931">CVE-2018-12931</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12930">CVE-2018-12930</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12929">CVE-2018-12929</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-12928">CVE-2018-12928</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-1121">CVE-2018-1121</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-10126">CVE-2018-10126</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2018-1000021">CVE-2018-1000021</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-13716">CVE-2017-13716</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-13693">CVE-2017-13693</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-13165">CVE-2017-13165</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2017-0537">CVE-2017-0537</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-8660">CVE-2016-8660</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-4472">CVE-2016-4472</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-20013">CVE-2016-20013</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-1585">CVE-2016-1585</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2016-0718">CVE-2016-0718</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2015-8553">CVE-2015-8553</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2015-1283">CVE-2015-1283</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2013-7445">CVE-2013-7445</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2013-1779">CVE-2013-1779</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2012-1148">CVE-2012-1148</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2012-0876">CVE-2012-0876</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2009-3720">CVE-2009-3720</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2007-2379">CVE-2007-2379</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2004-2761">CVE-2004-2761</a></li></ul></details>|

### <a id='1-6-1-resolved-issues'></a> v1.6.1 Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-6-1-cnrs-ri'></a> v1.6.1 Resolved issues: Cloud Native Runtimes

- New toggle feature for how to make ConfigMap updates. For some ConfigMaps in Cloud Native Runtimes,
  such as config-features, the option to update using an overlay was not taking effect.
  This issue is fixed.

  With this version, the legacy behavior remains the same, but VMware introduced
  a configuration to opt-in into updating ConfigMaps using overlays in Cloud Native Runtimes.
  To configure this option, edit your `cnr-values.yaml` file to change the following configuration:

    ```yaml
    allow_manual_configmap_update: false
    ```

#### <a id='1-6-1-crossplane-ri'></a> v1.6.1 Resolved issues: Crossplane

- The Crossplane package now more gracefully handles situations in which Crossplane is already
  installed to a cluster by using another method, for example, Helm install.

  Previously the Crossplane Package assumed that Crossplane was not already installed on the cluster,
  which is not always true.
  Rather than fail, the package completed installing, which caused non-deterministic behavior.

  Now, if you attempt to install or upgrade the Crossplane package on a cluster that has
  Crossplane installed by other means, it fails with the error `Resource already exists`.
  In such cases, you can either exclude the Crossplane package from the Tanzu Application Platform
  installation, or set `adopt_resources` to true in the Crossplane package to adopt resources from
  your existing installation.
  For more information, see [Use your existing Crossplane installation](crossplane/how-to-guides/use-existing-crossplane.hbs.md).

- Resolved an issue where Crossplane Providers did not transition to `HEALTHY=True` if using a custom
  certificate for your registry.
  This prevented the class claims used for dynamic provisioning from reconciling.
  The Crossplane Package now inherits the data configured in `shared.ca_cert_data` of `tap-values.yaml`.

#### <a id='1-6-1-namespace-provisioner-ri'></a> v1.6.1 Resolved issues: Namespace Provisioner

- Resolved an issue that prevented updates to the AWS Identity and Access Management (IAM) role
  from reflecting in the service accounts used by Supply Chains and Delivery components.

- Resolved a behavior where the Namespace Provisioner failed if the same Git secret was used multiple
  times within the `additional_sources` section of the `tap-values.yaml` file.
  This fix requires Cluster Essentials v1.6 or later installed on the cluster.

- Resolved an issue where a namespace managed by the Namespace Provisioner became stuck in the
  `Terminating` phase during deletion if it contained a workload.
  This fix requires Cluster Essentials v1.6 or later installed on the cluster.

#### <a id='1-6-1-stk-ri'></a> v1.6.1 Resolved issues: Services Toolkit

- Resolved an issue that prevented the default cluster-admin IAM role on Google Kubernetes Engine (GKE)
  clusters from claiming any of the Bitnami services.

  Previously, if a user with the cluster-admin role on a GKE cluster attempted to claim any of the
  Bitnami services, they received a validation error.

- Resolved an issue affecting the dynamic provisioning flow if you used a CompositeResourceDefinition
  that specified a schema that defined `.status` without also defining `.spec`.
  You can now use a CompositeResourceDefinition which only specifies `.status` in the schema.

  Previously, if you attempted to create a ClassClaim for a ClusterInstanceClass that referred to
  such a CompositeResourceDefinition, the ClassClaim did not transition into `Ready=True` and
  instead reported `unexpected end of JSON input`.

#### <a id='1-6-1-scst-store-ri'></a> v1.6.1 Resolved issues: Supply Chain Security Tools (SCST) - Store

- Implemented basic logging in the AMR database.

- AMR database no longer creates a load balancer when enabling the shared ingress domain and ingress
  values in `tap-values.yaml`.

- Modified the behavior of the `/v1/artifact-groups/vulnerabilities/_search` endpoint.
  It now returns a list of artifact groups affected by the vulnerability even if the images or sources
  in the query are not linked to them.

  Previously the endpoint returned the list of artifact groups the images or sources were linked to,
  even if the artifact group was not affected by the vulnerability.

#### <a id='1-6-1-apps-cli-plugin-ri'></a> v1.6.1 Resolved issues: Tanzu CLI Apps plug-in

- Implemented validations to prevent the inclusion of multiple sources through flags in the
  `workload create` and `workload apply` commands.

- Modified the behavior of the commands when waiting to apply workload changes. If the workload was
  previously in a failed state, it no longer immediately fails. When the `--wait` flag is used, the
  command continues to wait until the workload either succeeds or fails again. When the `--tail`
  flag is used, the command continues tailing logs from the Supply chain steps that were impacted by
  the workload update.

#### <a id='1-6-1-intellij-plugin-ri'></a> v1.6.1 Resolved issues: Tanzu Developer Tools for IntelliJ

- The `apply` action no longer stores the workload file path, which prevented modifying the workload
  file path later. Now this information is either computed or obtained by prompting the user as needed.

- In the Tanzu activity panel, the `config-writer-pull-requester` of the type `Runnable` is no longer
  incorrectly categorized as **Unknown**.


#### <a id='1-6-1-vscode-plugin-ri'></a> v1.6.1 Resolved issues: Tanzu Developer Tools for VS Code

- Errors in the kubeconfig file `~/.kube/config` that are not related to the current context are now
  ignored, allowing you to work with Tanzu panel without any issues.

---

### <a id='1-6-1-known-issues'></a> v1.6.1 Known issues

This release has the following known issues, listed by component and area.

> **Note** Starting in this release, the release notes list known issues in every release until
> they are resolved.

#### <a id='1-6-1-app-config-srvc-ki'></a> v1.6.1 Known issues: Application Configuration Service

- Client applications that include the `spring-cloud-config-client` dependency might fail to start or
  properly load the configuration that Application Configuration Service produced.

- Installation might fail because the pod security context does not perfectly adhere to the
  restricted pod security standard.

#### <a id='1-6-1-amr-obs-ce-hndlr-ki'></a> v1.6.1 Known issues: Artifact Metadata Repository Observer and CloudEvent Handler

- Periodic reconciliation or restarting of the AMR Observer causes reattempted posting of
  ImageVulnerabilityScan results. There is an error on duplicate submission of identical ImageVulnerabilityScans you can ignore if the previous submission was successful.

- ReplicaSet status in AMR only has two states: `created` and `deleted`.
  There is a known issue where the `available` and `unavailable` state is not showing.
  The workaround is that you can interpolate this information from the `instances` metadata in the
  AMR for the ReplicaSet.

#### <a id='1-6-1-bitnami-services-ki'></a> v1.6.1 Known issues: Bitnami Services

- If you try to configure private registry integration for the Bitnami services
  after having already created a claim for one or more of the Bitnami services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshoot Bitnami Services](bitnami-services/how-to-guides/troubleshooting.hbs.md#private-reg).

#### <a id='1-6-1-cnrs-ki'></a> v1.6.1 Known issues: Cloud Native Runtimes

- For Knative Serving, certain app name, namespace, and domain combinations produce Knative Services
  with status `CertificateNotReady`. For more information, see
  [Troubleshooting](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.3/tanzu-cloud-native-runtimes/troubleshooting.html#certificate-not-ready-kcert).

#### <a id='1-6-1-crossplane-ki'></a> v1.6.1 Known issues: Crossplane

- Crossplane Providers cannot communicate with systems using a custom CA.
  For more information and a workaround, see [Troubleshoot Crossplane](./crossplane/how-to-guides/troubleshooting.hbs.md#cp-custom-cert-inject).

- The Crossplane `validatingwebhookconfiguration` is not removed when you uninstall the
  Crossplane Package.
  To workaround, delete the `validatingwebhookconfiguration` manually by running
  `kubectl delete validatingwebhookconfiguration crossplane`.

#### <a id='1-6-1-eventing-ki'></a> v1.6.1 Known issues: Eventing

- When using vSphere sources in Eventing, the vsphere-source is using a high number of
  informers to alleviate load on the API server. This causes high memory use.

#### <a id='1-6-1-learningcenter-ki'></a> v1.6.1 Known issues: Learning Center

- [CVE-2023-26114](https://nvd.nist.gov/vuln/detail/CVE-2023-26114):
  Versions of VS Code server before v4.10.1 are vulnerable to Missing Origin Validation in WebSocket handshakes.
  For mitigation steps, see [Known issues for Learning Center](./learning-center/known-issues.hbs.md).

#### <a id='1-6-1-stk-ki'></a> v1.6.1 Known issues: Services Toolkit

- An error occurs if `additionalProperties` is `true` in a CompositeResourceDefinition.
  For more information and a workaround, see [Troubleshoot Services Toolkit](./services-toolkit/how-to-guides/troubleshooting.hbs.md#compositeresourcedef).

#### <a id='1-6-1-scc-ki'></a> v1.6.1 Known issues: Supply Chain Choreographer

- When using the Carvel Package Supply Chains, if the operator updates the parameter
  `carvel_package.name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps
  repository that uses the old value of `carvel_package.name_suffix`. You can ignore or delete this package.

- If the size of the resulting OpenAPIv3 specification exceeds a certain size, approximately 3&nbsp;KB,
  the Supply Chain does not function. If you use the default Carvel package parameters, you this
  issue does not occur. If you use custom Carvel package parameters, you might encounter this size limit.
  If you exceed the size limit, you can either deactivate this feature, or use a workaround.
  The workaround requires enabling a Tekton feature flag. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/additional-configs/#enabling-larger-results-using-sidecar-logs).

- The ClusterSupplyChain `scanning-image-scan-to-url` does not update if you attempt to update the
  `ootb_supply_chain_testing_scanning` field in the `tap-values.yaml` file to use a specified
  ClusterImageTemplate as follows:

    ```
    ootb_supply_chain_testing_scanning:
      image_scanner_template_name: CLUSTERIMAGETEMPLATE
    ```

    This is because the ClusterSupplyChain is preset to `image-scanner-template`.
    To workaround, edit the Out of the Box Supply template following the steps
    [Modifying an Out of the Box Supply template](./scc/authoring-supply-chains.hbs.md#modify-ootb-sc).

#### <a id='1-6-1-supply-chain-security-tools-store-ki'></a> v1.6.1 Supply Chain Security Tools - Store

- `Supply Chain Security Tools - Store` automatically detects PostgreSQL Database Index corruptions. Supply Chain Security Tools - Store does not reconcile if it finds a Postgres database index corruption issue. For information about remediating this issue, see [Fix Postgres Database Index Corruption](scst-store/database-index-corruption.hbs.md).

#### <a id='1-6-1-tap-gui-ki'></a> v1.6.1 Known issues: Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Developer Portal.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

#### <a id='1-6-1-sc-plugin-ki'></a> v1.6.1 Known issues: Tanzu Developer Portal - Supply Chain GUI plug-in

- Any workloads created by using a custom resource definition (CRD) might not work as expected.
  Only Out of the Box (OOTB) Supply Chains are supported in the GUI.

- [Supply Chain Security Tools - Scan v2.0](scst-scan/app-scanning-beta.hbs.md), which introduces the
  `ImageVulnerabilityScanner` CRD, is not currently supported in the Supply Chain GUI.

- Downloading the SBOM from a vulnerability scan requires additional configuration in
  `tap-values.yaml`. For more information, see
  [Troubleshooting](tap-gui/troubleshooting.hbs.md#sbom-not-working).

#### <a id='1-6-1-intellij-plugin-ki'></a> v1.6.1 Known issues: Tanzu Developer Tools for IntelliJ

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

#### <a id='1-6-1-vs-plugin-ki'></a> v1.6.1 Known issues: Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

#### <a id='1-6-1-vscode-plugin-ki'></a> v1.6.1 Known issues: Tanzu Developer Tools for VS Code

- In the Tanzu activity panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

- Tanzu Debug does not work on Windows for new workloads. When attempting to Tanzu Debug on Windows,
  the user sees an error message similar to the following:

    ```console
    Error: unable to check if filepath "'FILE-PATH'" is a valid url.
    ```

    For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#windows-quotes-error).

---

### <a id="1-6-1-components"></a> v1.6.1 Component versions

The following table lists the supported component versions for this Tanzu Application Platform release.

| Component Name                                                   | Version |
| ---------------------------------------------------------------- | ------- |
| API Auto Registration                                            | 0.3.3   |
| API portal                                                       | 1.4.0   |
| Application Accelerator                                          | 1.6.1   |
| Application Configuration Service                                | 2.1.0   |
| Application Live View APIserver                                  | 1.6.1   |
| Application Live View back end                                   | 1.6.1   |
| Application Live View connector                                  | 1.6.1   |
| Application Live View conventions                                | 1.6.1   |
| Application Single Sign-On                                       | 4.0.0   |
| Authentication and authorization                                 | 1.1.0   |
| Bitnami Services                                                 | 0.2.0   |
| Cartographer Conventions                                         | 0.7.3   |
| cert-manager                                                     | 2.3.1   |
| Cloud Native Runtimes                                            | 2.3.1   |
| Contour                                                          | 1.24.4  |
| Crossplane                                                       | 0.2.1   |
| Developer Conventions                                            | 0.11.0  |
| Eventing  (deprecated)                                           | 2.2.3   |
| External Secrets Operator                                        | 0.6.1   |
| Flux CD Source Controller                                        | 0.36.1  |
| Learning Center (deprecated)                                     | 0.3.1   |
| Learning Center workshops (deprecated)                           | 0.3.0   |
| Local Source Proxy                                               | 0.1.0   |
| Namespace Provisioner                                            | 0.4.0   |
| Out of the Box Delivery - Basic                                  | 0.13.6  |
| Out of the Box Supply Chain - Basic                              | 0.13.6  |
| Out of the Box Supply Chain - Testing                            | 0.13.6  |
| Out of the Box Supply Chain - Testing and Scanning               | 0.13.6  |
| Out of the Box Templates                                         | 0.13.6  |
| Service Bindings                                                 | 0.9.1   |
| Services Toolkit                                                 | 0.11.0  |
| Source Controller                                                | 0.8.0   |
| Spring Boot conventions                                          | 1.6.1   |
| Spring Cloud Gateway                                             | 2.0.3   |
| Supply Chain Choreographer                                       | 0.7.3   |
| Supply Chain Security Tools - Policy Controller                  | 1.4.0   |
| Supply Chain Security Tools - Scan                               | 1.6.67  |
| Supply Chain Security Tools - Store                              | 1.6.2   |
| Tanzu Developer Portal (formerly Tanzu Application Platform GUI) | 1.6.3   |
| Tanzu Application Platform Telemetry                             | 0.6.1   |
| Tanzu Build Service                                              | 1.11.10 |
| Tanzu CLI                                                        | 0.90.0  |
| Tanzu CLI Application Accelerator plug-in                        | 1.6.0   |
| Tanzu CLI Apps plug-in                                           | 0.12.1  |
| Tanzu CLI Build Service plug-in                                  | 1.0.0   |
| Tanzu CLI Insight plug-in                                        | 1.6.0   |
| Tanzu Service CLI plug-in                                        | 0.7.0   |
| Tekton Pipelines                                                 | 0.41.0  |

---

## <a id="1-6-deprecations"></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.


### <a id="1-6-tap-deprecations"></a> Tanzu Application Platform deprecations

- Minikube support is deprecated and will be removed in Tanzu Application Platform v1.7.

### <a id="1-6-alv-deprecations"></a> Application Live View deprecations

- `appliveview_connnector.backend.sslDisabled` is deprecated and marked for removal in
  Tanzu Application Platform v1.7.0.
  For more information about the migration, see [Deprecate the sslDisabled key](app-live-view/install.hbs.md#deprecate-the-ssldisabled-key).

### <a id='1-6-app-sso-deprecations'></a> Application Single Sign-On (AppSSO) deprecations

- `ClientRegistration` resource `clientAuthenticationMethod` field values
  `post` and `basic` are deprecated and marked for removal in Tanzu Application
  Platform v1.7.0. Use `client_secret_post` and `client_secret_basic` instead.

### <a id='1-6-eventing-deprecations'></a> Eventing deprecations

- Eventing in Tanzu Application Platform is deprecated and marked for removal in Tanzu Application Platform v1.7.0.

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

### <a id="1-6-lc-deprecations"></a> Learning Center deprecations

- Learning Center is deprecated and marked for removal in Tanzu Application Platform v1.7.0.
  Use [Tanzu Academy](https://tanzu.academy) instead for all Tanzu Application Platform learning and education needs.

### <a id="1-6-stk-deprecations"></a> Services Toolkit deprecations

- The `tanzu services claims` CLI plug-in command is now deprecated. It is
  hidden from help text output, but continues to work until officially removed
  after the deprecation period. The new `tanzu services resource-claims` command
  provides the same function.

### <a id="1-6-sc-deprecations"></a> Source Controller deprecations

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

### <a id="1-6-scst-scan-deprecations"></a> Supply Chain Security Tools (SCST) - Scan deprecations

- The `docker` field and related sub-fields used in SCST -
  Scan are deprecated and marked for removal in Tanzu Application Platform
  v1.7.0.

   The deprecation impacts the following components: Scan Controller, Grype Scanner, and Snyk Scanner.
   Carbon Black Scanner is not impacted.
   For information about the migration path, see
   [Troubleshooting](scst-scan/observing.hbs.md#unable-to-pull-scanner-controller-images).

- The profile based installation of Grype to a developer namespace and related
  fields in the values file, such as `grype.namespace` and
  `grype.targetImagePullSecret`, are deprecated and marked for removal in Tanzu
  Application Platform v1.8.0.

   VMware recommends using the namespace provisioner to populate namespaces with
   all the required resources, including the Grype installation.  For
   information about how to use namespace provisioner to populate a namespace
   with SCST - SCST scan, see [Setup for OOTB Supply Chains](namespace-provisioner/ootb-supply-chain.hbs.md#test-scan).

### <a id="1-6-tbs-deprecations"></a> Tanzu Build Service deprecations

- The Ubuntu Bionic stack is deprecated: Ubuntu Bionic stops receiving support in April 2023.
  VMware recommends you migrate builds to Jammy stacks in advance.
  For how to migrate builds, see [Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).

- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated.
  VMware plans to deactivate this format by default in Tanzu Application Platform v1.6.1 and remove
  support in Tanzu Application Platform v1.7.0.
  To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).

### <a id="1-6-apps-plugin-deprecations"></a> Tanzu CLI Apps plug-in deprecations

- The default value for the
  [--update-strategy](./cli-plugins/apps/reference/workload-create-apply.hbs.md#update-strategy)
  flag is planned to change from `merge` to `replace` in Tanzu Application Platform v1.7.0.

### <a id="1-6-tekton-deprecations"></a> Tekton Pipelines deprecations

- Tekton `ClusterTask` is deprecated and marked for removal in Tanzu Application
  Platform v1.9. Use the `Task` API instead. For more information, see the
  [Tekton documentation](https://tekton.dev/docs/pipelines/deprecations/).

---

## Linux Kernel CVEs

Kernel level vulnerabilities are regularly identified and patched by Canonical.
Tanzu Application Platform releases with available images, which might contain known vulnerabilities.
When Canonical makes patched images available, Tanzu Application Platform incorporates these fixed
images into future releases.

The kernel runs on your container host VM, not the Tanzu Application Platform container image.
Even with a patched Tanzu Application Platform image, the vulnerability is not mitigated until you
deploy your containers on a host with a patched OS. An unpatched host OS might be exploitable if
the base image is deployed.
