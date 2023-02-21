# Release notes

This topic contains release notes for Tanzu Application Platform v1.5.

## <a id='1-5-0'></a> v1.5.0

**Release Date**: April 11, 2023

### <a id="1-5-0-tap-new-features"></a> Tanzu Application Platform new features

### <a id='1-5-0-new-component-features'></a> New features by component and area

### <a id='1-5-0-appsso-new-features'></a> Application Single Sign-On (AppSSO)

- Adds a consistent roles claim mapping API across OpenID, LDAP, and SAML identity providers
- Introduces roles claim filtering API within an `AuthServer`s identity provider configuration.
- Introduces standardized client authentication methods to `ClientRegistration` custom resource. See [`ClientRegistration` resource docs](./app-sso/crds/clientregistration.md) for more.

### <a id='1-5-0-cert-manager-ncf'></a> cert-manager

- `cert-manager.tanzu.vmware.com` has upgraded to cert-manager `v1.11.0`. 
For more information, see [cert-manager GitHub repository](https://github.com/cert-manager/cert-manager/releases/tag/v1.11.0).

### <a id='1-5-0-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

### <a id='1-5-0-policy-bc'></a> Supply Chain Security Tools - Policy Controller

- `Keyless` authorities in the `ClusterImagePolicy` now require identities. Identities consists of a combination of `issuer` or `issuerRegExp` with `subject` or `subjectRegExp`. For more information, see [Supply Chain Security Tools - Policy Controller Authorities](./scst-policy/configuring.hbs.md#authorities).

### <a id='1-5-0-security-fixes'></a> Security fixes

This release has the following security fixes, listed by area and component.

### <a id='1-5-0-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

### <a id='1-5-0-appsso-resolved-issues'></a> Application Single Sign-On (AppSSO)

- Resolves redirect URI issue with insecure http redirection on TKGm clusters.

### <a id='1-5-0-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

### <a id='1-5-0-deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

### <a id='1-5-0-appsso-deprecations'></a> Application Single Sign-On (AppSSO)

- `ClientRegistration` resource `clientAuthenticationMethod` field values `post` and `basic` have been deprecated. Please rely on `client_secret_post` and `client_secret_basic`, respectively, instead.

#### <a id='1-5-0-convention-controller-dp'></a> Convention Controller
- This component is now fully deprecated in this release and is now fully replaced by [Cartographer Conventions](https://github.com/vmware-tanzu/cartographer-conventions) which implements the `conventions.carto.run` API that implementes all the features that were avaialble in the Convention Controller component.
