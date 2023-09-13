# Tanzu Application Platform release notes

This topic describes the changes in Tanzu Application Platform (commonly known as TAP)
v{{ vars.url_version }}.

## <a id='1-7-0'></a> v1.7.0

**Release Date**: 7 November 2023

### <a id='1-7-0-whats-new'></a> What's new in Tanzu Application Platform v1.7

This release includes the following platform-wide enhancements.

#### <a id='1-7-0-new-platform-features'></a> New platform-wide features

- Feature Description.

#### <a id='1-7-0-new-components'></a> New components

- [Service Registry for VMware Tanzu](service-registry/overview.hbs.md) provides on-demand Eureka
  servers for Tanzu Application Platform clusters. With Service Registry, you can create Eureka
  servers in your namespaces and bind Spring Boot workloads to them.

### <a id='1-7-0-new-features'></a> v1.7.0 New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-7-0-COMPONENT-NAME'></a> v1.7.0 Features: COMPONENT-NAME

- Feature description.

#### <a id='1-7-0-app-config-service'></a> v1.7.0 Features: Application Configuration Service

- The default interval for new `ConfigurationSlice` resources is now 60 seconds.

#### <a id='1-7-0-eso'></a> v1.7.0 Features: External Secrets Operator

- External Secrets Operator is now GA.
- Adds SYNC, GET, LIST and CREATE commands to the CLI. The GET command lets you get more details
  about your external secrets and secret stores. The CREATE command lets you create cluster
  external secret and cluster secret stores. For more information, see the commands in the
  [External Secrets CLI reference section](external-secrets/reference/external-secrets.hbs.md).

#### <a id='1-7-0-cli'></a> v1.7.0 Features: Tanzu CLI & plugins

- This release includes Tanzu CLI v1.0.0 and a set of installable plug-in groups that are versioned
  so that the CLI is compatible with every supported version of Tanzu Application Platform.
  See [Install Tanzu CLI](install-tanzu-cli.hbs.md) for more details.

##### <a id='1-7-0-tanzu-cli-insight-plugin'></a> v1.7.0 Features: Tanzu CLI Insight plug-in

- You can access reports from each scan to find out what packages and vulnerabilites were discovered using `tanzu insight report`. For more information, see <TODO: add in link>
- You can rebase vulnerability triage analyses using `tanzu insight triage rebase`. For more information, see [Rebase multiple analyses](cli-plugins/insight/triaging-vulnerabilities.hbs.md#rebase-multiple-analyses) and [tanzu insight triage rebase](https://github.com/pivotal/docs-tap/blob/main/cli-plugins/insight/cli-docs/tanzu_insight_triage_rebase.hbs.md#tanzu-insight-triage-rebase).

#### <a id='1-7-0-cli'></a> v1.7.0 Features: Tanzu Developer Portal & plugins


##### <a id='1-7-0-tanzu-cli-insight-plugin'></a> v1.7.0 Features: Supply Chain plug-in

- You can add triage analysis to vulnerabilities from a vulnerability scanner step. For more information, see [Triage Vulnerabilities](tap-gui/plugins/scc-tap-gui.hbs.md#triage-vulnerabilities)

#### <a id='1-7-0-cert-manager'></a> v1.7.0 Features: cert-manager

- `cert-manager.tanzu.vmware.com` is upgraded to `cert-manager@1.12`.
  For more information, see the [upstream release notes](https://cert-manager.io/docs/release-notes/release-notes-1.12/).

#### <a id='1-7-0-cnrs'></a> v1.7.0 Features: Cloud Native Runtimes

- **New config option `resource_management`**: Allows configuration of CPU and memory resources that follow Kubernetes requests and limitsfor all Knative Serving deployments in the `knative-serving` namespace. For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
  For example, to configure the CPU and memory requirements for the `activator` deployment:

    ```console
    resource_management:
      - name: "activator"
        requests:
          memory: "100Mi"
          cpu: "100m"
        limits:
          memory: "1000Mi"
          cpu: "1"
    ```

- **New config option `cnrs.contour.default_tls_secret`**: This option has the same meaning as `cnrs.default_tls_secret`.
  `cnrs.default_tls_secret` is deprecated in this release and will be removed in Tanzu Application Platform v1.10.0, which includes Cloud Native Runtimes v2.7.0.
  In the meantime both options are supported and `cnrs.contour.default_tls_secret` takes precedence over `cnrs.default_tls_secret`.

- **New config options `cnrs.contour.[internal/external].namespace`**: These new options have the same meaning as `cnrs.ingress.[internal/external].namespace`.
  `cnrs.ingress.[internal/external].namespace` is deprecated in this release and will be removed in Tanzu Application Platform v1.10.0, which includes Cloud Native Runtimes v2.7.0.
  In the meantime both options are supported and `cnrs.contour.[internal/external].namespace` takes precedence
  over `cnrs.ingress.[internal/external].namespace`.

- **New Knative Garbage Collection Defaults**: CNRs is reducing the number of revisions kept for each knative service from 20 to 5.
  This improves the knative controller's memory consumption when having several Knative services.
  Knative manages this through the config-gc ConfigMap under `knative-serving` namespace and is documented [here](https://knative.dev/docs/serving/revisions/revision-admin-config-options/).

  The following defaults are set for Knative garbage collection:
    - `retain-since-create-time: "48h"`: Any revision created with an age of 2 days is considered for garbage collection.
    - `retain-since-last-active-time: "15h"`: Revision that was last active at least 15 hours ago is considered for garbage collection.
    - `min-non-active-revisions: "2"`: The minimum number of inactive Revisions to retain.
    - `max-non-active-revisions: "5"`: The maximum number of inactive Revisions to retain.

  For more information about updating default values, see [Configure Garbage collection for the Knative revisions](cloud-native-runtimes/how-to-guides/garbage_collection.hbs.md).

- **Knative Serving v1.11**: Knative Serving v1.11 is available in Cloud Native Runtimes. For more information, see the [Knative v1.11 release notes](https://knative.dev/blog/releases/announcing-knative-v1-11-release/).

#### <a id='1-7-0-tanzu-cli-insight-plugin'></a> v1.7.0 Features: Supply Chain Security Tools (SCST) - Store

- Artifact Metadata Repository (AMR) is deployed by default. For more information, see [Artifact Metadata Repository](scst-store/amr/overview.hbs.md).
- AMR [Authentication and authorization feature](scst-store/amr/auth.hbs.md) has been introduced.
- AMR GraphQL now contains data for Images, Containers and Location. For more information, see [Data Model and Concepts](scst-store/amr/data-model-and-concepts.hbs.md)

---

### <a id='1-7-0-breaking-changes'></a> v1.7.0 Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='1-7-0-eventing-br'></a> v1.7.0 Breaking changes: Eventing

- Eventing is removed in this release. Install and manage Knative Eventing as an alternative solution.

#### <a id='1-7-0-lc-br'></a> v1.7.0 Breaking changes: Learning Center

- Learning Center is removed in this release. Use [Tanzu Academy](https://tanzu.academy/) instead for
all Tanzu Application Platform learning and education needs.

#### <a id='1-7-0-workloads-br'></a> v1.7.0 Breaking changes: Workloads

- Function Buildpacks for Knative and the corresponding
Application Accelerator starter templates for Python and Java are removed in this release.

#### <a id='1-7-0-services-toolkit-br'></a> v1.7.0 breaking changes: Services Toolkit

- Services Toolkit forces explicit cluster-wide permissions to `claim` from a `ClusterInstanceClass`

---

### <a id='1-7-0-security-fixes'></a> v1.7.0 Security fixes

This release has the following security fixes, listed by component and area.

#### <a id='1-7-0-COMPONENT-NAME-fixes'></a> v1.7.0 Security fixes: COMPONENT-NAME

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

#### <a id='1-7-0-COMPONENT-NAME-ri'></a> v1.7.0 Resolved issues: COMPONENT-NAME

- Resolved issue description.

#### <a id='1-7-0-supply-chain-choreographer-ri'></a> v1.7.0 Resolved issues: Supply Chain Choreographer

- You can safely ignore the label `apps.tanzu.vmware.com/carvel-package-workflow` when the Package Supply Chain is disabled. Previously, workloads with this label fail when the Package Supply Chain is disabled.
- Workloads failed on the image supply chains with `multiple supply chain matches` when testing or scanning supply chains are side loaded with the basic supply chain. Though side loading these supply chains is not a supported configuration, this fix allows you to continue to create workloads.

---

### <a id='1-7-0-known-issues'></a> v1.7.0 Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-7-0-COMPONENT-NAME-ki'></a> v1.7.0 Known issues: COMPONENT-NAME

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
| External Secrets Operator                                        |         |
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

### <a id='cloud-native-runtimes-deprecations'></a> Cloud Native Runtimes deprecations

- **`default_tls_secret` config option**: After the recent changes in this release, this config option is moved to
  `contour.default_tls_secret`. `default_tls_secret` will be removed in CNRs 2.7.0. In the meantime both options
  are going to be supported and `contour.default_tls_secret` will take precedence over `default_tls_secret`.

- **`ingress.[internal/external].namespace` config options**: After the recent changes in this release, these config options
  are moved to `contour.[internal/external].namespace`. `ingress.[internal/external].namespace` will be removed in CNRs 2.7.0.
  In the meantime both options are going to be supported and `contour.[internal/external].namespace` will take precedence
  over `ingress.[internal/external].namespace`.

### <a id="scst-scan-deprecations"></a> Supply Chain Security Tools (SCST) - Scan deprecations

- The profile based installation of Grype to a developer namespace and related fields in the values file, such as `grype.namespace` and
  `grype.targetImagePullSecret`, were deprecated in Tanzu Application Platform v1.6.0 and are marked for removal in v1.8.0. Before removal, you can opt-in to use the profile based installation of Grype to a single namespace by setting `grype.namespace` in the `tap-values.yaml` configuration file.
- The `docker` field and related sub-fields used in Supply Chain Security Tools - Scan are deprecated and have been removed in Tanzu Application Platform v1.7.0.
---
