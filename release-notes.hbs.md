# Release notes

This topic contains release notes for Tanzu Application Platform v1.5.

## <a id='1-5-0'></a> v1.5.0

**Release Date**: April 11, 2023

### <a id="1-5-0-tap-new-features"></a> Tanzu Application Platform new features

- A new Crossplane Package is now part of the iterate, run and full profiles.
- A new Bitnami Services Package is now part of the iterate, run and full profiles.

### <a id='1-5-0-new-component-features'></a> New features by component and area

#### <a id='1-5-0-app-accelerator-new-features'></a> Application Accelerator

- The Application Accelerator plug-in for IntelliJ is now available as a beta release on the [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
- The [Tanzu Java Restful Web App](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/java-rest-service) and [Tanzu Java Web App](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/tanzu-java-web-app) accelerators have the option to support Spring Boot v3.0.
- Use the `accelerator-info.yaml` file to review historical information and to determine if
  a project was generated with an accelerator.
- (Optional) Use a system-wide property in the `tap-values.yaml` configuration file to activate or
  deactivate Git repository creation. For more information, see [Deactivate Git repository creation](./tap-gui/plugins/application-accelerator-git-repo.hbs.md#deactiv-git-repo-creation).

#### <a id='1-5-0-appsso-new-features'></a> Application Single Sign-On (AppSSO)

- Introduces `AuthServer` CORS API that enables configuration of allowed HTTP origins.
  This is useful for public clients, such as single-page apps.
- Introduces an API for filtering external roles, groups, and memberships across OpenID, LDAP, and SAML identity providers
  in `AuthServer` resource into the `roles` claim of the resulting identity
  token. For more information, see [Roles claim filtering](app-sso/service-operators/identity-providers.hbs.md#roles-filters).
- Introduces mapping of users' roles, filtered and propagated in the identity
  token's `roles` claim, into scopes of the access token. For access tokens that are in the JWT format, the resulting
  scopes are part of the access token's `scope` claim, if the `ClientRegistration` contains the
  scopes. For more information, see [Configure authorization](app-sso/service-operators/configure-authorization.hbs.md).
- Introduces default access token scopes for user's authentication by using an identity
  provider. For more information, see [Default authorization scopes](app-sso/service-operators/configure-authorization.hbs.md#default-scopes).
- Introduces standardized client authentication methods to `ClientRegistration` custom resource.
  For more information, see [ClientRegistration](app-sso/crds/clientregistration.hbs.md).

#### <a id='1-5-0-services-toolkit-new-features'></a> Services Toolkit

- Services Toolkit now supports the dynamic provisioning of Services Instances. `ClusterInstanceClass` now supports the new provisioner mode. When a `ClassClaims` is created and refers to a provisioner `ClusterInstanceClass` a new Service Instance is created on-demand and claimed. This is powered by [Upbound Universal Crossplane](https://github.com/upbound/universal-crossplane).
- `tanzu services class-claim` has been updated to allow the passing of parameters to `ClusterInstanceClass` that support dynamic provisioning.
  - For example, `tanzu services class-claim create rmq-claim-1 --class rmq --parameter replicas=3  --parameter ha=true`
- Services Toolkit integrates with the new Bitnami Services Package which provides out-of-the-box support for the following Helm charts:
  - PostgreSQL
  - MySQL
  - Redis
  - RabbitMQ
- Improved the security model for which users can claim specific Service Instances. Introduced the `claim` custom RBAC verb that targets a specific `ClusterInstanceClass`. This can be bound to users for access control of who can create `ClassClaim` resources for a specific `ClusterInstanceClass`. `ResourceClaimPolicy` is now created automatically for successful `ClassClaims`.
- `ResourceClaimPolicy` now supports targeting individual resources by name via `.spec.subject.resourceNames`

#### <a id='1-5-0-crossplane-new-features'></a> Crossplane

- [Upbound Universal Crossplane](https://github.com/upbound/universal-crossplane) version `1.11.0` is a new package in TAP. This provides integration for dynamic provisioning in Services Toolkit and can be used for integration with Cloud Services.
- This ships with two Crossplane [Providers](https://docs.crossplane.io/v1.9/concepts/providers/) out-of-the-box, `provider-kubernetes` and `provider-helm`. Other providers can be added manually as required.

#### <a id='1-5-0-bitnami-services-new-features'></a> Crossplane

- Bitnami Helm charts are now shipped out-of-the-box with TAP and integrate with Services Toolkit. These include:
  - PostgreSQL
  - MySQL
  - Redis
  - RabbitMQ

#### <a id='1-5-0-scc-new-features'></a> Supply Chain Choreographer

- Introduces a variation of the OOTB Basic supply chains that output Carvel packages. Carvel packages enable configuring for each runtime environment. See [Carvel Package Workflow](scc/carvel-package-supply-chain.hbs.md). This feature is experimental.

#### <a id='1-5-0-scst-policy-new-features'></a> Supply Chain Security Tools - Policy Controller

- ClusterImagePolicy resync is triggered every 10 hours to get updated values from KMS.

#### <a id='1-5-0-cert-manager-ncf'></a> cert-manager

- `cert-manager.tanzu.vmware.com` has upgraded to cert-manager `v1.11.0`.
For more information, see [cert-manager GitHub repository](https://github.com/cert-manager/cert-manager/releases/tag/v1.11.0).

#### <a id="1-5-0-scst-scan-new-features"></a> Supply Chain Security Tools - Scan
- Supply Chain Security Tools - Scan now runs on Tanzu Service Mesh-enabled clusters, enabling end to end, secure communication.
  - Kubernetes Jobs that previously created the scan pods have been replaced with [Tekton TaskRuns](https://tekton.dev/docs/pipelines/taskruns/#overview)
  - [Observability](./scst-scan/observing.hbs.md) and [Troubleshooting](./scst-scan/troubleshoot-scan.hbs.md#scanner-pod-restarts) docs have been updated to account for the impact of these changes.
- In conformance with NIST 800-53, support for rotating certs and TLS has been added
  - Users can specify a TLS cert, minimum TLS version, and restrict TLS ciphers when using kube-rbac-proxy (see [Configure properties](./scst-scan/install-scst-scan.hbs.md#configure-scst-scan)).

#### <a id='1-5-0-intellij-plugin-ncf'></a> Tanzu Developer Tools for IntelliJ

- The Tanzu Workloads panel is updated to show workloads deployed across multiple namespaces.
- Tanzu actions for workload apply, workload delete, debug, and Live Update start are now available
  from the Tanzu Workloads panel.
- Tanzu Developer Tools for IntelliJ can be used to iterate on Spring Boot applications.

### <a id='1-5-0-vscode-plugin-ncf'></a> Tanzu Developer Tools for VS Code

- A Tanzu activity panel is added to visualize the supply chain, delivery, and running
  application pods.
  It displays detailed error messages on each resource and enables developers to describe and view
  logs on these resources from within their IDE.
- The Tanzu Workloads panel is updated to show workloads deployed across multiple namespaces.
- Tanzu commands for workload apply, workload delete, debug, and Live Update start are now available
  from the Tanzu Workloads panel.
- Tanzu Developer Tools for VS Code can be used to iterate on Spring Boot applications.

#### <a id='1-5-0-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id='1-5-0-tbs-bc'></a> Tanzu Build Service

- The default `ClusterBuilder` now uses the Ubuntu Jammy v22.04 stack instead of the Ubuntu Bionic
v18.04 stack. Previously, the default `ClusterBuilder` pointed to the Base builder based on the
Bionic stack. Now, the default `ClusterBuilder` points to the Base builder based on the Jammy stack.
Ensure that your workloads can be built and run on Jammy.

  For information about how to change the `ClusterBuilder` from the default builder, see the
  [Configure the Cluster Builder](../docs-tap/tanzu-build-service/tbs-workload-config.hbs.md#cluster-builder) in the Tanzu Build Service documentation.

  For more information about available builders, see
  [Lite Dependencies](../docs-tap/tanzu-build-service/dependencies.hbs.md#lite-dependencies) and
  [Full Dependencies](../docs-tap/tanzu-build-service/dependencies.hbs.md#full-dependencies) in the
  Tanzu Build Service documentation.

#### <a id='1-5-0-security-fixes'></a> Security fixes

This release has the following security fixes, listed by area and component.

#### <a id='1-5-0-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id='1-5-0-app-accelerator-resolved-issues'></a> Application Accelerator

* Resolved issue with `custom types` not re-ordering fields correctly in the VS Code extension.

#### <a id='1-5-0-appsso-resolved-issues'></a> Application Single Sign-On (AppSSO)

- Resolves redirect URI issue with insecure http redirection on TKGm clusters.

### <a id='1-5-0-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

### <a id='1-5-0-cnrs-ki'></a> Cloud Native Runtimes

- When using auto-tls, on by default, DomainMapping resources must have names that are less than 63 characters. Otherwise, the DomainMapping fails to become ready due to `CertificateNotReady`.

#### <a id='1-5-0-vscode-plugin-ki'></a> Tanzu Developer Tools for VS Code

- If a user restarts their computer while running Live Update, without having terminated the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again. Delete the Tilt lock file to resolve this.
  The default file location is `~/.tilt-dev/config.lock`.

- On Windows, workload commands don't work when in a project with spaces in the name, such as
  `my-app project`.
  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#ki-projects-with-spaces).

#### <a id='1-5-0-intellij-plugin-ki'></a> Tanzu Developer Tools for Intellij

- A `com.vdurmont.semver4j.SemverException: Invalid version (no major version)` error is shown in the
  error logs when attempting to take a workload action before having installed the Tanzu CLI apps
  plug-in.

- The apply action prompts and stores the workload file path when using the action for the first time,
  but modifying it afterwards is not possible.
  If the workload file location changes, the user needs to delete the module's key-value entries
  prefixed with `com.tanzu` in the `PropertiesComponent` found in the project's `.idea/workspace.xml`
  file to delete the configuration. The next apply action run prompts for new values again.

- If a user restarts their computer while running Live Update without having terminated the Tilt
  process beforehand, there is a lock that incorrectly shows that Live Update is still running and
  prevents it from starting again.
  Deleting the Tilt lock file resolves this. The default location is `~/.tilt-dev/config.lock`.

- On Windows, workload actions do not work when in a project with spaces in the name such as
  `my-app project`.
  For more information, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#ki-projects-with-spaces).

#### <a id="1-5-0-grype-scan-known-issues"></a>Grype scanner

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

### <a id='1-5-0-deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

#### <a id='1-5-0-appsso-deprecations'></a> Application Single Sign-On (AppSSO)

- `ClientRegistration` resource `clientAuthenticationMethod` field values `post` and `basic` are deprecated.
Use `client_secret_post` and `client_secret_basic` instead.

#### <a id='1-5-0-convention-controller-dp'></a> Convention Controller

- This component is deprecated in this release and is replaced by [Cartographer Conventions](https://github.com/vmware-tanzu/cartographer-conventions). Cartographer Conventions implements the `conventions.carto.run` API that includes all the features that were available in the Convention Controller component.
