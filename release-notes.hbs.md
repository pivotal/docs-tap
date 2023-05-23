# Tanzu Application Platform release notes

This topic contains release notes for Tanzu Application Platform v1.5.

## <a id='1-5-2'></a> v1.5.2

**Release Date**: 13 June 2023

### <a id='1-5-2-security-fixes'></a> Security fixes

This release has the following security fixes, listed by component and area.

#### <a id='1-5-2-COMPONENT-NAME-fixes'></a> COMPONENT-NAME

- Security fix description.

---

### <a id='1-5-2-resolved-issues'></a> Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-5-2-COMPONENT-NAME-ri'></a> COMPONENT-NAME

- Resolved issue description.

#### <a id='1-5-2-scst-scan-ri'></a> Supply Chain Security Tools (SCST) - Scan

- Old `TaskRuns` associated with scans are now being deleted to reduce memory consumption.
- Added support for `ConfigMaps` in custom `ScanTemplates`.

---

### <a id='1-5-2-known-issues'></a> Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-5-2-COMPONENT-NAME-ki'></a> COMPONENT-NAME

- Known issue description with link to workaround.

---

## <a id='1-5-1'></a> v1.5.1

**Release Date**: 09 May 2023

### <a id='1-5-1-security-fixes'></a> Security fixes

This release has the following security fixes, listed by component and area.

<table>
<tr>
<th>Package Name</th>
<th>Vulnerabilities Resolved</th>
</tr>
<tr>
<td>accelerator.apps.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li></ul></td>
</tr>
<tr>
<td>api-portal.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li><li>GHSA-493p-pfq6-5258 </li></ul></td>
</tr>
<tr>
<td>application-configuration-service.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li></ul></td>
</tr>
<tr>
<td>backend.appliveview.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41881">CVE-2022-41881</a></li><li>GHSA-mjmj-j48q-9wg2</li><li>GHSA-36p3-wjmg-h94x </li></ul></td>
</tr>
<tr>
<td>buildservice.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li><li>GHSA-vvpx-j8f3-3w6h</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li></ul></td>
</tr>
<tr>
<td>connector.appliveview.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-41881">CVE-2022-41881</a></li><li>GHSA-mjmj-j48q-9wg2</li><li>GHSA-36p3-wjmg-h94x</li></ul></td>
</tr>
<tr>
<td>spring-cloud-gateway.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-20860">CVE-2023-20860</a></li><li>GHSA-493p-pfq6-5258</li></ul></td>
</tr>
<tr>
<td>apiserver.appliveview.tanzu.vmware.com</td>
<td><ul><li>GHSA-r48q-9g5r-8q2h</li><li>GHSA-vvpx-j8f3-3w6h</li></ul></td>
</tr>
<tr>
<td>carbonblack.scanning.apps.tanzu.vmware.com</td>
<td><ul><li>GHSA-vvpx-j8f3-3w6h</li><li>GHSA-3vm4-22fp-5rfm</li><li>GHSA-8c26-wmh5-6g9v</li><li>GHSA-gwc9-m7rh-j2ww</li><li>GHSA-69cg-p879-7622</li><li>GHSA-fxg5-wq6x-vr4w</li><li>GHSA-vpvm-3wq2-2wvm</li><li>GHSA-69ch-w2m2-3vjp</li></ul></td>
</tr>
<tr>
<td>metadata-store.apps.tanzu.vmware.com</td>
<td><ul><li>GHSA-vvpx-j8f3-3w6h</li></ul></td>
</tr>
<tr>
<td>ootb-templates.tanzu.vmware.com</td>
<td><ul><li>GHSA-vvpx-j8f3-3w6h</li></ul></td>
</tr>
<tr>
<td>scanning.apps.tanzu.vmware.com</td>
<td><ul><li>GHSA-vvpx-j8f3-3w6h</li></ul></td>
</tr>
<tr>
<td>app-scanning.apps.tanzu.vmware.com</td>
<td><ul><li>GHSA-3vm4-22fp-5rfm</li><li>GHSA-8c26-wmh5-6g9v</li><li>GHSA-gwc9-m7rh-j2ww</li><li>GHSA-69cg-p879-7622</li><li>GHSA-fxg5-wq6x-vr4w</li></ul></td>
</tr>
<tr>
<td>learningcenter.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26114">CVE-2023-26114</a></li><li>GHSA-frjg-g767-7363</li><li>GHSA-hc6q-2mpp-qw7j</li></ul></td>
</tr>
<tr>
<td>workshops.learningcenter.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-26114">CVE-2023-26114</a></li><li>GHSA-frjg-g767-7363</li></ul></td>
</tr>
<tr>
<td>snyk.scanning.apps.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23918">CVE-2023-23918</a></li><li>GHSA-rc47-6667-2j5j</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li></ul></td>
</tr>
<tr>
<td>sso.apps.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4899">CVE-2022-4899</a></li></ul></td>
</tr>
<tr>
<td>tap-gui.tanzu.vmware.com</td>
<td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0465">CVE-2023-0465</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0466">CVE-2023-0466</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4899">CVE-2022-4899</a></li></ul></td>
</tr>
</table>

---

### <a id='1-5-1-resolved-issues'></a> Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-5-1-app-acc-ri'></a> Application Accelerator

- The IntelliJ plug-in can now be installed in IntelliJ v2023.1.

#### <a id="1-5-1-external-secrets-ri"></a> External Secrets CLI (beta)

- The external-secrets plug-in creating the `ExternalSecret` and `SecretStore` resources through stdin
  now correctly confirms resource creation. Use `-f ` to create resources using a file instead of stdin.

#### <a id='1-5-1-intellij-ext-ri'></a> Tanzu Developer Tools for IntelliJ

- Live Update now works when using the Jammy `ClusterBuilder`.

#### <a id='1-5-1-vs-ext-ri'></a> Tanzu Developer Tools for Visual Studio

- Live Update now works when using the Jammy `ClusterBuilder`.

---

### <a id='1-5-1-known-issues'></a> Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-5-1-tap-gui-ki'></a> Tanzu Application Platform GUI

- Ad-blocking browser extensions and standalone ad-blocking software can interfere with telemetry
  collection within the VMware
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html)
  and restrict access to all or parts of Tanzu Application Platform GUI.
  For more information, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#ad-block-interference).

#### <a id='1-5-1-tnz-src-cntrllr-ki'></a> Tanzu Source Controller

- In v0.7.0, when pulling images from Elastic Container Registry (ECR), Tanzu Source Controller
  keyless access to ECR through AWS IAM role binding fails to authenticate (error code: 401).
  The workaround is to set up a standard Kubernetes secret with a user-id and password to authenticate
  to ECR, instead of binding Tanzu Source Controller to an AWS IAM role to pull images from ECR.

#### <a id='1-5-1-scst-scan-ki'></a> Supply Chain Security Tools (SCST) - Scan

- `TaskRuns` associated with scans are kept during the lifetime of the owner scan. This can lead to Out of Memory restart problems in the SCST - Scan controller.
- `ConfigMaps` used in `ScanTemplates` are not supported, wether introduced by overlays or in a custom `ScanTemplate`. This is the error message you will see:
    ```
    The scan job could not be created. admission webhook "validation.webhook.pipeline.tekton.dev" denied the request: validation failed: expected exactly one, got neither: spec.workspaces[5].configmap, spec.workspaces[5].emptydir, spec.workspaces[5].persistentvolumeclaim, spec.workspaces[5].secret, spec.workspaces[5].volumeclaimtemplate
    ```

---

## <a id='1-5-0'></a> v1.5.0

**Release Date**: 11 April 2023

### <a id='1-5-0-whats-new'></a> What's new in Tanzu Application Platform

This release includes the following platform-wide enhancements.

#### <a id='1-5-0-new-components'></a> New components

- [Application Configuration Service](application-configuration-service/about.hbs.md) is a new component
  that provides a Kubernetes-native experience to enable the runtime
  configuration of existing Spring applications that were previously leveraged by using
  Spring Cloud Config Server.

- [Crossplane](crossplane/about.hbs.md) is a new component that powers a number of capabilities,
  such as dynamic provisioning of service instances with Services Toolkit and the
  pre-installed Bitnami Services. It is part of the iterate, run, and full profiles.

- [Bitnami Services](bitnami-services/about.hbs.md) is a new component that includes a set of
  backing services for Tanzu Application Platform.
  The provided services are MySQL, PostgreSQL, RabbitMQ and Redis, all of which are backed by
  the corresponding Bitnami Helm Chart. It is part of the iterate, run, and full profiles.

- [Spring Cloud Gateway](spring-cloud-gateway/about.hbs.md) is an API gateway solution based on
  the open-source Spring Cloud Gateway project.
  This new component provides a simple means to route internal or external API requests
  to application services that expose APIs.

### <a id='1-5-0-new-features'></a> New features by component and area

This release includes the following changes, listed by component and area.

#### <a id='1-5-0-app-acc-features'></a> Application Accelerator

- The Application Accelerator plug-in for IntelliJ is now available as a beta release on
  [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).

- Adds the option to support Spring Boot v3.0 for the
  [Tanzu Java Restful Web App](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/java-rest-service)
  and [Tanzu Java Web App](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/tanzu-java-web-app) accelerators.

- Application Accelerator now generates application bootstrapping provenance when a project is created using an accelerator. For more information, see [Provenance transform](application-accelerator/creating-accelerators/transforms/provenance.hbs.md).

- Adds the option to use a system-wide property in the `tap-values.yaml` configuration file to activate or
  deactivate Git repository creation. For more information, see [Deactivate Git repository creation](tap-gui/plugins/application-accelerator-git-repo.hbs.md#deactiv-git-repo-creation).

- The Accelerator Tanzu CLI plug-in now supports using the Tanzu Application Platform GUI URL
  with the `--server-url` command option.
  For more information, see [Using Tanzu Application Platform GUI URL](cli-plugins/accelerator/overview.html#server-api-tap-gui)

#### <a id='1-5-0-app-live-view'></a> Application Live View

- Application Live View now supports improved security and access control.
  Introduces the `APIServer` component that generates and validates user access to view actuator data for a pod.
  For more information, see [Improved security and access control in Application Live View](app-live-view/improved-security-and-access-control.hbs.md).

- Application Live View now supports secure access to sensitive operations that can be executed on a running application using the actuator endpoints at the cluster level.
  For more information, see [Improved security and access control in Application Live View](app-live-view/improved-security-and-access-control.hbs.md)

- The Application Live View plugin now supports CPU stats in the memory and threads pages for Steeltoe Applications.
  For more information, see
  [Application Live View for Steeltoe Applications in Tanzu Application Platform GUI](tap-gui/plugins/app-live-view-steeltoe.hbs.md).

#### <a id='1-5-0-app-sso-features'></a> Application Single Sign-On (AppSSO)

- Introduces `AuthServer` CORS API that enables configuration of allowed HTTP origins.
  This is useful for public clients, such as single-page apps.

- Introduces an API for filtering external roles, groups, and memberships across OpenID, LDAP, and SAML
  identity providers in `AuthServer` resource into the `roles` claim of the resulting identity
  token. For more information, see [Roles claim filtering](app-sso/service-operators/identity-providers.hbs.md#roles-filters).

- Introduces mapping of user roles, filtered and propagated in the identity
  token's `roles` claim, into scopes of the access token.
  For access tokens that are in the JWT format, the resulting scopes are part of the access token's
  `scope` claim, if the `ClientRegistration` contains the scopes.
  For more information, see [Configure authorization](app-sso/service-operators/configure-authorization.hbs.md).

- Introduces default access token scopes for user's authentication by using an identity
  provider. For more information, see [Default authorization scopes](app-sso/service-operators/configure-authorization.hbs.md#default-scopes).

- Introduces standardized client authentication methods to `ClientRegistration` custom resource.
  For more information, see [ClientRegistration](app-sso/crds/clientregistration.hbs.md).

#### <a id='1-5-0-bitnami-services-features'></a> Bitnami Services

- The new component [Bitnami Services](bitnami-services/about.hbs.md) is available with
  Tanzu Application Platform.

- Provides integration for dynamic provisioning of Bitnami Helm Charts included with
  Tanzu Application Platform for the following backing services:
   - PostgreSQL
   - MySQL
   - Redis
   - RabbitMQ

   For a tutorial to get started with using these services, see [Working with Bitnami Services](services-toolkit/tutorials/working-with-bitnami-services.hbs.md).


#### <a id='1-5-0-cert-manager-ncf'></a> cert-manager

- `cert-manager.tanzu.vmware.com` has upgraded to cert-manager v1.11.0.
  For more information, see [cert-manager GitHub repository](https://github.com/cert-manager/cert-manager/releases/tag/v1.11.0).

#### <a id='1-5-0-crossplane-features'></a> Crossplane

- The new component [Crossplane](crossplane/about.hbs.md) is available with Tanzu Application Platform.
  It installs [Upbound Universal Crossplane](https://github.com/upbound/universal-crossplane) v1.11.0.

- Provides integration for dynamic provisioning in Services Toolkit and can be used for
  integration with cloud services such as AWS, Azure, and GCP.
  For more information, see
  [Integrating cloud services into Tanzu Application Platform](services-toolkit/tutorials/integrate-cloud-services.hbs.md).

  For more information about dynamic provisioning, see
  [Set up dynamic provisioning of service instances](services-toolkit/tutorials/setup-dynamic-provisioning.hbs.md) to learn more.

- Includes two Crossplane [Providers](https://docs.crossplane.io/v1.9/concepts/providers/):
  `provider-kubernetes` and `provider-helm`.
  You can add other providers manually as required.

#### <a id='1-5-0-external-secrets-features'></a>External Secrets CLI (Beta)

- The external-secrets plug-in available in the Tanzu CLI interacts with the External Secrets Operator API.
  Users can use this CLI plug-in to create and view External Secrets Operator resources on a Kubernetes cluster.

   For more information about managing secrets with External Secrets in general, see the official [External Secrets Operator documentation](https://external-secrets.io).
   For installing the External Secrets Operator and the CLI plug-in, see the following documentation:

   - [Installing External Secrets Operator in TAP](external-secrets/install-external-secrets-operator.hbs.md)
   - [Installing External Secrets CLI plug-in](prerequisites.hbs.md)
   - [External-Secrets with Hashicorp Vault](external-secrets/vault-example.md)

   Additionally, see the example integration of External-Secrets with Hashicorp Vault

#### <a id="1-5-namespace-provisioner-feats"></a> Namespace Provisioner

- Includes a new GitOps workflow for managing a list of namespaces fully declaratively
  through a Git repository. Specify the location of the GitOps repository that has the list of namespaces
  that you want as ytt data values to be imported in the namespace provisioner using the `gitops_install` `tap-values.yaml` configuration.

   For more information, see the GitOps section in
   [Provision developer namespaces](namespace-provisioner/provision-developer-ns.md).

- The Namespace Provisioner controller supports adding namespace parameters from labels or annotations
  on namespace objects based on accepted prefixes defined in the `parameter_prefixes` configuration in the `tap-values.yaml`.
  You can use this feature to add custom parameters to a namespace for creating resources conditionally.

   For an example, see
   [Create Tekton pipelines and Scan policies using namespace parameters](namespace-provisioner/use-case2.md).

- Adds support for importing Kubernetes secrets that contain a ytt overlay definition that you can apply
  to the resources that Namespace Provisioner creates.

   Using the `overlays_secret` configuration in namespace provisioner `tap-values.yaml`,
   you can provide a list of secrets that contain the overlay definition to apply
   to resources created by provisioner.

   For an example of using overlays, see
   [Customize OOTB default resources](namespace-provisioner/use-case4.md).

- Adds support for reading sensitive data from a Kubernetes secret in YAML format and populating that
  information in the resources that Namespace Provisioner creates during runtime.
  This is kept in sync with the source. This removes the need to store any sensitive data in GitOps repository.
  - Using the `import_data_values_secrets` configuration in the Namespace Provisioner section of the Tanzu Application Platform values file, you can
   import sensitive data from a YAML formatted secret and make it available under `data.values.imported` for additional resource templating.
  - For an example use case, see
    [Install multiple scanners in the developer namespace](./namespace-provisioner/use-case5.md).

- Namespace Provisioner now creates a Kubernetes `LimitRange` object with acceptable default values that set
  maximum limits on many resources that pods in the managed namespace can request.
   - Run profile: Stamped by default.
   - Full and iterate profile: Opt-in using parameters.

   For a sample configuration, see [Customize OOTB Limit Range default](./namespace-provisioner/use-case4.md#customize-limit-range-defaults).

- Namespaces Provisioner enables you to use private Git repositories for storing their GitOps based
  installation files and additional platform operator templated resources that you want to create
  in your developer namespace. Authentication is provided using a secret in `tap-namespace-provisioning`
  namespace, or an existing secret in another namespace referred to in the `secretRef` in the additional sources.

   For an example use case, see [Working with private Git Repositories](./namespace-provisioner/use-case3.md)

#### <a id='1-5-0-services-toolkit-features'></a> Services Toolkit

- Services Toolkit now supports the dynamic provisioning of services instances.
  - `ClusterInstanceClass` now supports the new provisioner mode.
  When a `ClassClaim` is created which refers to a provisioner `ClusterInstanceClass`, a new
  service instance is created on-demand and claimed. This is powered by [Crossplane](crossplane/about.hbs.md).

- The `tanzu service` CLI plug-in has the following updates:
   - The command `tanzu service class-claim create`  now allows you to pass parameters to the
   provisioner-based `ClusterInstanceClass` to support dynamic provisioning.
   For example,
   `tanzu service class-claim create rmq-claim-1 --class rmq --parameter replicas=3  --parameter ha=true`
   - The `tanzu service class-claim get` now outputs parameters passed as part of claim creation.

   For more information about these commands, see [Tanzu Service CLI Plug-In](services-toolkit/reference/tanzu-service-cli.hbs.md#stk-cli-class-claim).

- Integrates with the new component [Bitnami Services](bitnami-services/about.hbs.md),
  which provides pre-installed dynamic provisioning support for the following Helm charts:
   - PostgreSQL
   - MySQL
   - Redis
   - RabbitMQ

- Improves the security model to control which users can claim specific service instances.
   - Introduced the `claim` custom RBAC verb that targets a specific `ClusterInstanceClass`.
   You can bind this to users for access control of who can create `ClassClaim` resources for
   a specific `ClusterInstanceClass`.
   - A `ResourceClaimPolicy` is now created automatically for successful `ClassClaims`.

   For more information, see [Authorize users and groups to claim from provisioner-based classes](services-toolkit/how-to-guides/authorize-claim-provisioner-classes.hbs.md) to learn more.

- The `ResourceClaimPolicy` now supports targeting individual resources by name.
  To do so, configure `.spec.subject.resourceNames`.

- The `Where-For-Dinner` sample Application Accelerator now supports dynamic provisioning.

- Changes to the Services Toolkit component documentation.
   - The [standalone Services Toolkit documentation](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/index.html)
   is no longer receiving updates.
   From now on you can find all Services Toolkit documentation in the Tanzu Application Platform
   component documentation section for [Services Toolkit](services-toolkit/about.hbs.md).
   - To learn more about working with services on Tanzu Application Platform, see the new
   [tutorials](services-toolkit/tutorials/index.hbs.md),
   [how-to guides](services-toolkit/how-to-guides/index.hbs.md),
   [concepts](services-toolkit/concepts/index.hbs.md), and
   [reference material](services-toolkit/reference/index.hbs.md).

#### <a id='1-5-0-scc-features'></a> Supply Chain Choreographer

- Introduces a variation of the Out of the Box Basic supply chains that output Carvel packages.
  Carvel packages enable configuring for each runtime environment.
  For more information, see [Carvel Package Workflow](scc/carvel-package-supply-chain.hbs.md).
  This feature is experimental.

#### <a id='1-5-0-scst-policy-features'></a> Supply Chain Security Tools (SCST) - Policy Controller

- ClusterImagePolicy resync is triggered every 10 hours to get updated values from the Key Management Service (KMS).

#### <a id="1-5-0-scst-scan-features"></a> Supply Chain Security Tools (SCST) - Scan

- SCST - Scan now runs on Tanzu Service Mesh-enabled clusters, enabling end to end, secure communication.
   - Kubernetes jobs that previously created the scan pods were replaced with [Tekton TaskRuns](https://tekton.dev/docs/pipelines/taskruns/#overview).
   - [Observability](./scst-scan/observing.hbs.md) and [Troubleshooting](./scst-scan/troubleshoot-scan.hbs.md) documentation is updated to account for the impact of these changes. For successful scans, scanner pods restart once. For more information, see [Scanner pod restarts once in SCST - Scan v1.5.0 or later](./scst-scan/troubleshoot-scan.hbs.md#scanner-pod-restarts).

- Adds support for rotating certificates and TLS, to conform with NIST 800-53. Users can specify a TLS certificate, minimum TLS version, and restrict TLS ciphers when using kube-rbac-proxy.
For more information, see [Configure properties](./scst-scan/install-scst-scan.hbs.md#configure-scst-scan).

- SCST - Scan now offers even more flexibility for users to use their existing investments in scanning solutions. In Tanzu Application Platform v1.5.0, users have early access to:
   - A new alpha integration with the [Trivy Open Source Vulnerability Scanner](https://www.aquasec.com/products/trivy/) by Aqua Security that scans source code and images from secure supply chains. See [Install Trivy (alpha)](./scst-scan/install-trivy-integration.hbs.md).
   - A simplified alpha user experience for creating custom integrations with additional vulnerability scanners that are not included by default. If you have a scanner that you would like to use with Tanzu Application Platform, see [SCST - Scan 2.0 (alpha)](./scst-scan/app-scanning-alpha.hbs.md).
   - VMware is looking for early adopters to test both of these alpha offerings and provide feedback. Email your Tanzu representative or [contact us here](https://tanzu.vmware.com/application-platform).

- Carbon Black integration is updated to use the Carbon Black scanner CLI v1.9.2.
  Notable optimizations include improved scan logic that reduces the time it takes for a scan to complete.

   For more information, see the [Carbon Black Cloud Console Release Notes](https://docs.vmware.com/en/VMware-Carbon-Black-Cloud/services/rn/vmware-carbon-black-cloud-console-release-notes/index.html#What's%20New%20-%2012%20January%202023-Container%20Essentials).

#### <a id='1-5-0-tap-gui-features'></a> Tanzu Application Platform GUI

- **Disclosure:** This upgrade includes a Java script operated by the service provider Pendo.io.
  The Java script is installed on selected pages of VMware software and collects information about
  your use of the software, such as clickstream data and page loads, hashed user ID, and limited
  browser and device information.
  VMware uses this information to better understand the way you use the software to improve
  your experience with VMware products and services.
  For more information, see the
  [Customer Experience Improvement Program](https://www.vmware.com/solutions/trustvmware/ceip.html).

- Supports automatic configuration with SCST - Store. For more information,
  see [Automatically connect Tanzu Application Platform GUI to the Metadata Store](tap-gui/plugins/scc-tap-gui.hbs.md#scan-auto).

- Enables specification of security banners. To use this customization,
  see [Customize security banners](tap-gui/customize/customize-portal.hbs.md#cust-security-banners).

- Upgrades Backstage to v1.10.1.

- Includes an optional plug-in that collects telemetry by using the Pendo tool.
  To configure Pendo telemetry and opt in or opt out, see
  [Opt out of telemetry collection](opting-out-telemetry.hbs.md).

#### <a id="tap-gui-plug-in-features"></a> Tanzu Application Platform GUI plug-ins

- **Supply Chain Plug-in:**
  - When `alvToken` has expired, the logic to fetch a new token and the API call are both retried.
  - Actions are deactivated and a message is displayed when sensitive operations are deactivated for
    the app.
  - The **Heap Dump** button deactivates when sensitive operations are deactivated for the application.
  - Enabled Secure Access Communication between App Live View components.
  - Added an API to connect to `appliveview-apiserver` by reusing `tap-gui` authentication.
  - The Application Live View plug-in now requests a token from `appliveview-apiserver` and passes it
    to every call to the Application Live View back end.
  - Provides secured sensitive operations (edit env, change log levels, download heap dump) and
    displays a message in the UI.
  - Renamed the `k8s-logging-backend` plug-in as `k8s-custom-apis-backend`.
  - The fetch token for the `logLevelsPanelToggle` component is now loaded from the workload plug-in
    PodLogs page.

- **Security Analysis GUI Plug-in:**
  - **CVE Details:** Added Impacted Workloads widget to the CVE Details page.
  - **CVE Details:** Display and navigate to latest source SHA or image digest in the Workload Builds
    table.
  - **Package Details:** Added Impacted Workloads column to the Vulnerabilities table.
  - **Package Details:** Display and navigate to latest source SHA or image digest in the Workload
    Builds table.
  - **Security Analysis Dashboard:** Added Highest Reach Vulnerabilities widget.

#### <a id="1-5-apps-plugin-features"></a> Tanzu CLI Apps plug-in

- Adds support for `-ojson` and `-oyaml` output flags in `tanzu apps workload create/apply` command.
  The CLI does not wait to print workload when using `--output` in workload create/apply unless
  `--wait` or `--tail` flags are specified as well.

- Using the `--no-color` flag in `tanzu apps workload create/apply` commands now hides progress bars
  in addition to color output and emojis.

- Adds support for unsetting `--git-repo`, `--git-commit`, `--git-tag` and `--git-branch` flags
  by setting the value to empty string.

#### <a id='1-5-0-intellij-feats'></a> Tanzu Developer Tools for IntelliJ

- Updates the Tanzu Workloads panel to show workloads deployed across multiple namespaces.

- Tanzu actions for `workload apply`, `workload delete`, `debug`, and `Live Update start` are now
  available from the Tanzu Workloads panel.

- You can use Tanzu Developer Tools for IntelliJ to iterate on Spring Boot 3-based applications.

#### <a id='1-5-0-vs-plugin-feats'></a> Tanzu Developer Tools for Visual Studio

- Supports iterative development of applications consisting of multiple microservices, enabling
  developers to debug and Live Update each microservice independently and simultaneously.

- Enables existing projects to work with Tanzu Application Platform developer tools easily by
  using templates to generate the necessary configuration files.

#### <a id='1-5-0-vscode-plugin-feats'></a> Tanzu Developer Tools for VS Code

- The Tanzu Activity tab in the Panels view enables developers to visualize the supply chain, delivery,
  and running application pods.

  The tab enables a developer to view and describe logs on each resource associated with a workload
  from within their IDE. The tab displays detailed error messages for each resource in an error state.

- Updates the Tanzu Workloads panel to show workloads deployed across multiple namespaces.

- Tanzu commands for `workload apply`, `workload delete`, `debug`, and `Live Update start` are now
  available from the Tanzu Workloads panel.

- You can use Tanzu Developer Tools for VS Code to iterate on Spring Boot 3-based applications.

---

### <a id='1-5-0-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id='1-5-convention-controller-bc'></a> Convention Controller

- Convention Controller is removed in this release and is replaced by
  [Cartographer Conventions](https://github.com/vmware-tanzu/cartographer-conventions).
  Cartographer Conventions implements the `conventions.carto.run` API that includes all the features
  that were available in the Convention Controller component.

#### <a id="1-5-scst-scan-bc"></a> Supply Chain Security Tools (SCST) - Scan

- The deprecated Grype ScanTemplates included with Tanzu Application Platform v1.2.0 and earlier are removed
  and no longer supported. Use Grype ScanTemplates v1.2 and later.

#### <a id='1-5-0-tbs-bc'></a> Tanzu Build Service

- The default `ClusterBuilder` now uses the Ubuntu Jammy v22.04 stack instead of the Ubuntu Bionic
  v18.04 stack. Previously, the default `ClusterBuilder` pointed to the Base builder based on the
  Bionic stack. Now, the default `ClusterBuilder` points to the Base builder based on the Jammy stack.
  Ensure that your workloads can be built and run on Jammy.

   For information about how to change the `ClusterBuilder` from the default builder, see the
   [Configure the Cluster Builder](tanzu-build-service/tbs-workload-config.hbs.md#cluster-builder).

   For more information about available builders, see
   [Lite Dependencies](../docs-tap/tanzu-build-service/dependencies.hbs.md#lite-dependencies) and
   [Full Dependencies](../docs-tap/tanzu-build-service/dependencies.hbs.md#full-dependencies).

- The Tanzu Build Service automatic dependency updater feature is removed in
  Tanzu Application Platform v1.5.0.
  This feature has been deprecated since Tanzu Application Platform v1.2.

---

### <a id='1-5-0-security-fixes'></a> Security fixes

This release has the following security fixes, listed by area and component.

<table>
  <tr>
  <th>Package Name</th>
  <th>Vulnerabilities Resolved</th>
  </tr>
  <tr>
  <td>buildservice.tanzu.vmware.com</td>
  <td><ul><li>GHSA-fxg5-wq6x-vr4w</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0179">CVE-2023-0179</a></li></ul></td>
  </tr>
  <tr>
  <td>carbonblack.scanning.apps.tanzu.vmware.com</td>
  <td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24827">CVE-2023-24827</a></li></ul></td>
  </tr>
  <tr>
  <td>eventing.tanzu.vmware.com</td>
  <td><ul><li> GHSA-fxg5-wq6x-vr4w</li><li>GHSA-69cg-p879-7622</li><li>GHSA-69ch-w2m2-3vjp </li></ul></td>
  </tr>
  <tr>
  <td>grype.scanning.apps.tanzu.vmware.com</td>
  <td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li></ul></td>
  </tr>
  <tr>
  <td>learningcenter.tanzu.vmware.com</td>
  <td><ul><li>GHSA-fxg5-wq6x-vr4w</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li><li>GHSA-3vm4-22fp-5rfm</li><li>GHSA-69ch-w2m2-3vjp</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li><li>GHSA-83g2-8m93-v3w7</li><li>GHSA-ppp9-7jff-5vj2</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0286">CVE-2023-0286</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li><li>GHSA-2hrw-hx67-34x6</li><li>GHSA-x4qr-2fvf-3mr5</li></ul></td>
  </tr>
  <tr>
  <td>policy.apps.tanzu.vmware.com</td>
  <td><ul><li>GHSA-fxg5-wq6x-vr4w</li></ul></td>
  </tr>
  <tr>
  <td>snyk.scanning.apps.tanzu.vmware.com</td>
  <td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li></ul></td>
  </tr>
  <tr>
  <td>tap-gui.tanzu.vmware.com</td>
  <td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0286">CVE-2023-0286</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23918">CVE-2023-23918</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0361">CVE-2023-0361</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-4450">CVE-2022-4450</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0215">CVE-2023-0215</a></li></ul></td>
  </tr>
  <tr>
  <td>workshops.learningcenter.tanzu.vmware.com</td>
  <td><ul><li> GHSA-fxg5-wq6x-vr4w</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li><li>GHSA-3vm4-22fp-5rfm</li><li>GHSA-69ch-w2m2-3vjp</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li><li>GHSA-83g2-8m93-v3w7</li><li>GHSA-ppp9-7jff-5vj2</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0286">CVE-2023-0286</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li></ul></td>
  </tr>
</table>

>**Note** CVE-2023-0179, CVE-2023-1281 and CVE-2023-0461 are high severity vulnerabilities.
>At this time, there is no available patch for them upstream for some Tanzu Application Platform components.
>After there is a patch available, Tanzu Application Platform will release a patched base stack image.
>These vulnerabilities are kernel exploits that run on your container host VM, not the Tanzu Application Platform container image.
>Running on an up to date kernel is a mitigation for these vulnerabilities.

---

### <a id='1-5-0-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id='1-5-0-app-acc-ri'></a> Application Accelerator

- Resolved issue with `custom types` not re-ordering fields correctly in the VS Code extension.

#### <a id='1-5-0-app-sso-ri'></a> Application Single Sign-On (AppSSO)

- Resolved redirect URI issue with insecure HTTP redirection on Tanzu Kubernetes Grid multicloud
(TKGm) clusters.

#### <a id='1-5-0-cnrs-ri'></a> Cloud Native Runtimes

- Resolved issue with DomainMapping names longer than 63 characters when auto-tls is enabled,
which is on by default.
- Resolved issue with certain app name, namespace, and domain combinations producing invalid
HTTPProxy resources.

#### <a id="1-5-0-namespace-provisioner-ri"></a> Namespace Provisioner

- Updated default resources to avoid ownership conflicts with the `grype` package.

#### <a id="1-5-0-tap-gui-plug-in-ri"></a>Tanzu Application Platform GUI plug-ins

- **App Accelerator Plug-in:**

  - Fixed JSON schema for Git repository creation.
  - Added missing query string parameters to accelerator provenance.

- **Supply Chain Plug-in:**

  - Fixed CPU stats in App Live View Steeltoe Threads and Memory pages.
  - The App Live View Details page now shows the correct boot version instead of **UNKNOWN**.
  - Fixed request parameters for the post-API call.
  - Fixed the UI error in the ALV request-mapping page that was caused by an unused style.
  - Fixed the ALV Request Mappings and Threads page to support Boot 3 apps.

#### <a id='1-5-0-tbs-ri'></a> Tanzu Build Service

- Builds no longer fail for upgrades on OpenShift v4.11.

#### <a id="1-5-apps-plugin-ri"></a> Tanzu CLI Apps plug-in

- Allow users to pass only `--git-commit` as Git the ref while creating a workload from a Git Repository.
  This update removes the limitation where users had to provide a `--git-tag` or `--git-branch` with the commit to create a workload.

- Fixed the behavior where `subpath` was getting removed from the workload when there are updates
  to the Git section of the workload source specification.

#### <a id="1-5-intellij-ext-ri"></a> Tanzu Developer Tools for IntelliJ

- When there are multiple resource types with the same kind, the pop-up menu **Describe** action in
  the Activity panel no longer fails when used on PodIntent resources.

---

### <a id='1-5-0-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### <a id="1-5-0-api-auto-reg-ki"></a>API Auto Registration

- Users cannot update their APIs through API Auto Registration due to a issue with the ID used to retrieve APIs.
  This issue causes errors in the API Descriptor CRD similar to the following: `Unable to find API entity's uid within TAP GUI. Retrying the sync`.

#### <a id='1-5-0-bitnami-services-ki'></a> Bitnami Services

- If you try to configure private registry integration for the Bitnami services
  after having already created a claim for one or more of the Bitnami services using the default
  configuration, the updated private registry configuration does not appear to take effect.
  This is due to caching behavior in the system which is not accounted for during configuration updates.
  For a workaround, see [Troubleshooting and limitations](services-toolkit/how-to-guides/troubleshooting.hbs.md).

#### <a id='1-5-0-eventing-ki'></a> Eventing

- When using vSphere sources in Eventing, the vsphere-source is using a high number of
  informers to alleviate load on the API server. This causes high memory utilization.

#### <a id="1-5-0-external-secrets-ki"></a> External Secrets CLI (beta)

- The external-secrets plug-in creating the `ExternalSecret` and `SecretStore` resources through stdin
  incorrectly confirms resource creation. Use `-f ` to create resources using a file instead of stdin.

#### <a id="1-5-0-grype-scan-ki"></a> Grype scanner

- **Scanning Java source code that uses Gradle package manager might not reveal
  vulnerabilities:**

  For most languages, source code scanning only scans files present in the
  source code repository. Except for support added for Java projects using
  Maven, no network calls fetch dependencies. For languages using dependency
  lock files, such as golang and Node.js, Grype uses the lock files to verify
  dependencies for vulnerabilities.

  For Java using Gradle, dependency lock files are not guaranteed, so Grype uses
  dependencies present in the built binaries, such as `.jar` or `.war` files.

  Grype fails to find vulnerabilities during a source scan because VMware
  discourages committing binaries to source code repositories. The
  vulnerabilities are still found during the image scan after the binaries are
  built and packaged as images.

#### <a id='1-5-0-scc-ki'></a> Supply Chain Choreographer

- When using the Carvel Package Supply Chains, if the operator updates the parameter `carvel_package.
  name_suffix`, existing workloads incorrectly output a Carvel package to the GitOps repository that uses
  the old value of `carvel_package.name_suffix`. You can ignore or delete this package.

#### <a id='1-5-0-tap-gui-ki'></a> Tanzu Application Platform GUI

- The portal might partially overlay text on the Security Banners customization at the bottom.

- The **Impacted Workloads** table is empty on the **CVE and Package Details** pages if the relevant
  CVE belongs to a workload that has only completed one type of vulnerability scan
  (either image or source).
  A fix is planned for Tanzu Application Platform GUI v1.5.1.

#### <a id="1-5-apps-plugin-ki"></a> Tanzu CLI Apps plug-in

- `tanzu apps workload apply` does not wait for the changes to be taken when the workload is updated
  using `--tail` or `--wait`. Instead it fails if the status before the changes shows an error.

#### <a id='1-5-0-intellij-plugin-ki'></a> Tanzu Developer Tools for IntelliJ

- The error `com.vdurmont.semver4j.SemverException: Invalid version (no major version)` is shown in the
  error logs when attempting to perform a workload action before installing the Tanzu CLI apps
  plug-in.

- The `apply` action prompts and stores the workload file path when using the action for the first
  time, but modifying it afterwards is not possible.
  If the workload file location changes you must delete the module's key-value entries to delete the
  configuration.
  These entries are prefixed with `com.tanzu` in `PropertiesComponent` in the project's
  `.idea/workspace.xml` file. The next `apply` action run prompts for new values again.

- If you restart your computer while running Live Update without terminating the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again.
  To resolve this, delete the Tilt lock file. The default location for the file is
  `~/.tilt-dev/config.lock`.

- On Windows, workload actions do not work when in a project with spaces in the name such as
  `my-app project`.
  For more information, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#projects-with-spaces).

- In the Tanzu Activity Panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

#### <a id='1-5-0-vs-plugin-ki'></a> Tanzu Developer Tools for Visual Studio

- Clicking the red square Stop button in the Visual Studio top toolbar can cause a workload to fail.
  For more information, see [Troubleshooting](vs-extension/troubleshooting.hbs.md#stop-button).

#### <a id='1-5-0-vscode-plugin-ki'></a> Tanzu Developer Tools for VS Code

- If a user restarts their computer while running Live Update, without terminating the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again. Delete the Tilt lock file to resolve this.
  The default file location is `~/.tilt-dev/config.lock`.

- On Windows, workload commands don't work when in a project with spaces in the name, such as
  `my-app project`.
  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#projects-with-spaces).

- If your kubeconfig file `~/.kube/config` is malformed, you cannot apply a workload.
  You see an error message when you attempt to do so. To resolve this, fix the kubeconfig file.

- In the Tanzu Activity Panel, the `config-writer-pull-requester` of type `Runnable` is incorrectly
  categorized as **Unknown**. The correct category is **Supply Chain**.

#### <a id="1-5-0-external-secrets-ki"></a> External Secrets CLI (beta)

- The external-secrets plug-in creating the `ExternalSecret` and `SecretStore` resources through stdin incorrectly confirms resource creation. Use `-f ` to create resources using a file instead of stdin.

#### <a id='1-5-10-tanzu-source-controller-ki'></a> Tanzu Source Controller
- **Issue:**
On Version v0.7.0, when pulling image from ECR (Elastic Container Registry) Tanzu Source Controller keyless access to ECR  via AWS IAM role binding fails to authenticate (error code: 401).
**Workaround:**
Setup standard K8s secret with user-id and password to authenticate to ECR, instead of binding Tanzu Source Controller to an AWS IAM role to pull images from ECR.

---

## <a id='1-5-deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

### <a id="1-5-alv-deprecations"></a> Application Live View

- `appliveview_connnector.backend.sslDisabled` is deprecated and marked for removal in
  Tanzu Application Platform v1.7.0.
  For more information about the migration, see [Deprecate the sslDisabled key](app-live-view/install.hbs.md#deprecate-the-ssldisabled-key).

### <a id='1-5-app-sso-deprecations'></a> Application Single Sign-On (AppSSO)

- `ClientRegistration` resource `clientAuthenticationMethod` field values `post` and `basic` are
  deprecated and marked for removal in Tanzu Application Platform v1.7.0.
  Use `client_secret_post` and `client_secret_basic` instead.

- `AuthServer.spec.tls.disabled` is deprecated and marked for removal in Tanzu Application Platform v1.6.0.
  For more information about how to migrate to `AuthServer.spec.tls.deactivated`, see
  [Migration guides](app-sso/upgrades/index.md#migration-guides).

### <a id="1-5-0-stk-deprecations"></a> Services Toolkit

- The `tanzu services claims` CLI plug-in command is now deprecated. It is
  hidden from help text output, but continues to work until officially removed
  after the deprecation period. The new `tanzu services resource-claims` command
  provides the same function.

### <a id="1-5-scst-scan-deprecations"></a> Supply Chain Security Tools (SCST) - Scan

- The `docker` field and related sub-fields used in SCST -
  Scan are deprecated and marked for removal in Tanzu Application Platform
  v1.7.0.

   The deprecation impacts the following components: Scan Controller, Grype Scanner, and Snyk Scanner.
   Carbon Black Scanner is not impacted.
   For information about the migration path, see
   [Troubleshooting](scst-scan/observing.hbs.md#unable-to-pull-scanner-controller-images).

### <a id="1-5-tbs-deprecations"></a> Tanzu Build Service

- The Ubuntu Bionic stack is deprecated: Ubuntu Bionic stops receiving support in April 2023.
  VMware recommends you migrate builds to Jammy stacks in advance.
  For how to migrate builds, see [Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).

- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated.
  VMware plans to deactivate this format by default in Tanzu Application Platform v1.5.0 and remove
  support in Tanzu Application Platform v1.6.0.
  To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).

### <a id="1-5-apps-plugin-deprecations"></a> Tanzu CLI Apps plug-in

- The default value for the
  [--update-strategy](./cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md#update-strategy)
  flag will change from `merge` to `replace` in Tanzu Application Platform v1.7.0.

- The `tanzu apps workload update` command is deprecated and marked for removal
  in Tanzu Application Platform v1.6.0. Use the command `tanzu apps workload apply` instead.
