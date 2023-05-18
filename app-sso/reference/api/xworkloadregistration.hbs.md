# XWorkloadRegistration

> **Note** This API is not expected to be used directly. It is supported, but
> when you find yourself using it directly, consider `ClassClaim`,
> `WorkloadRegistration` or `ClientRegistration` instead.

`XWorkloadRegistration` is a _Crossplane_ XRD. It is cluster-scoped. It serves
as an integration API between _Services Toolkit_, _Crossplane_ and _AppSSO_.

Typically, when creating a `ClassClaim` for an AppSSO service offering, e.g.
[ClusterWorkloadRegistrationClass](./clusterworkloadregistrationclass.hbs.md),
_Services Toolkit_ creates an `XWorkloadRegistration`. By way of a
`Composition` the `XWorkloadRegistration` is reconciled into a
`WorkloadRegistration` with _Crossplane_'s _provider-kubernete_'s `Object` as
an intermediary.

The spec of `XWorkloadRegistration` is almost the same as
[WorkloadRegistration](./workloadregistration.hbs.md) but without
`spec.workloadRef.namespace` and `spec.authServerSelector`.

## Spec

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: XWorkloadRegistration
metadata:
  name: "" #! required
spec:
  workloadRef:
    name: "" #! required
  redirectPaths: #! optional
    - "" #! must be an absolute path
  scopes: #! optional
    - name: "" #! required
      description: "" #! optional
  scopes: #! optional
    - name: "" #! required
      description: "" #! optional
  authorizationGrantTypes: #! optional
    - "" #! must be one of "authorization_code", "client_credentials" or "refresh_token"
  clientAuthenticationMethod: "" #! optional, must be one of "client_secret_post", "client_secret_basic" or "none"
  requireUserConsent: false #! optional
status:
  authServerRef:
    apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
    issuerURI: ""
    kind: AuthServer
    name: ""
    namespace: ""
  binding:
    name: ""
```

> **Note** Crossplane's standard Crossplane Resource Model (XRM) fields are omitted

# Examples

Assuming that a `Composition` for `XWorkloadRegistration` exist, e.g. by way of
a `ClusterWorkloadRegistrationClass`, this is a minimal example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: XWorkloadRegistration
metadata:
  name: sample-minimal
spec:
  workloadRef:
    name: test-workload-name
```

This is a fully configured example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: XWorkloadRegistration
metadata:
  name: sample-full
spec:
  workloadRef:
    name: test-workload-name
  redirectPaths:
    - /redirect/uri/1
    - /redirect/uri/2
  scopes:
    - name: openid
    - name: email
    - name: profile
    - name: roles
    - name: coffee.make
      description: bestows the ultimate power
  authorizationGrantTypes:
    - client_credentials
    - authorization_code
    - refresh_token
  clientAuthenticationMethod: client_secret_basic
  requireUserConsent: true
```

