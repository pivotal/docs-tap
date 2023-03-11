# Release notes

This topic contains release notes for Tanzu Application Platform v1.5.

## <a id='1-5-0'></a> v1.5.0

**Release Date**: April 11, 2023

### <a id="1-5-0-tap-new-features"></a> Tanzu Application Platform new features

### <a id='1-5-0-new-component-features'></a> New features by component and area

### <a id='1-5-0-app-accelerator-new-features'></a> Application Accelerator
- The Application Accelerator plugin for IntelliJ is now available as a Beta release on the [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
- The [`Tanzu Java Restful Web App`](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/java-rest-service) and [`Tanzu Java Web App`](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/tanzu-java-web-app) accelerators have been updated to include an option to support of Spring Boot 3.0.
- Accelerator provenance information (`accelerator-info.yaml`) is now available as a way to determine if a project has been generated with an accelerator as well as additional historical information.
- Optional git repository creation now [has a system-wide flag](./tap-gui/plugins/application-accelerator-git-repo.hbs.md#deactiv-git-repo-creation) to activate/deactivate the feature through the `tap-values.yaml` configuration file.

### <a id='1-5-0-appsso-new-features'></a> Application Single Sign-On (AppSSO)

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

### <a id='1-5-0-scst-policy-new-features'></a> Supply Chain Security Tools - Policy Controller

- ClusterImagePolicy resync is triggered every 10 hours to get updated values from KMS.

### <a id='1-5-0-cert-manager-ncf'></a> cert-manager

- `cert-manager.tanzu.vmware.com` has upgraded to cert-manager `v1.11.0`. 
For more information, see [cert-manager GitHub repository](https://github.com/cert-manager/cert-manager/releases/tag/v1.11.0).

### <a id='1-5-0-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

### <a id='1-5-0-tbs-bc'></a> Tanzu Build Service

- The default `ClusterBuilder` now uses the Ubuntu Jammy (22.04) instead of Bionic (18.04) stack,
ensure that your workloads can be built and run on Jammy.

### <a id='1-5-0-security-fixes'></a> Security fixes

This release has the following security fixes, listed by area and component.

### <a id='1-5-0-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

### <a id='1-5-0-app-accelerator-resolved-issues'></a> Application Accelerator

* Resolved issue with `custom types` not re-ordering fields correctly in the VS Code extension.

### <a id='1-5-0-appsso-resolved-issues'></a> Application Single Sign-On (AppSSO)

- Resolves redirect URI issue with insecure http redirection on TKGm clusters.

### <a id='1-5-0-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

### <a id='1-5-0-cnrs-ki'></a> Cloud Native Runtimes

- When using auto-tls, on by default, DomainMapping resources must have names that are less than 63 characters. Otherwise, the DomainMapping fails to become ready due to `CertificateNotReady`.

### <a id='1-5-0-deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

### <a id='1-5-0-appsso-deprecations'></a> Application Single Sign-On (AppSSO)

- `ClientRegistration` resource `clientAuthenticationMethod` field values `post` and `basic` are deprecated. 
Use `client_secret_post` and `client_secret_basic` instead.

#### <a id='1-5-0-convention-controller-dp'></a> Convention Controller

- This component is deprecated in this release and is replaced by [Cartographer Conventions](https://github.com/vmware-tanzu/cartographer-conventions). Cartographer Conventions implements the `conventions.carto.run` API that includes all the features that were available in the Convention Controller component.
