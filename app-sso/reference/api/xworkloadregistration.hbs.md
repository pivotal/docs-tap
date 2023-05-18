# XWorkloadRegistration

`XWorkloadRegistration` is a cluster-scoped Crossplane XRD. It serves as an integration 
API between Services Toolkit, Crossplane and AppSSO.

> **Note** This API is not intended for direct usage. Although it is supported, 
> VMware recommend using `ClassClaim`, `WorkloadRegistration`, or `ClientRegistration` 
> instead when you need direct access to this API.

In most cases, when creating a `ClassClaim` for an AppSSO service offering, 
for example, [ClusterWorkloadRegistrationClass](clusterworkloadregistrationclass.hbs.md), 
Services Toolkit creates an `XWorkloadRegistration`. By using a `Composition`, 
the `XWorkloadRegistration` is reconciled into a
`WorkloadRegistration` with Crossplane's `provider-kubernete`'s `Object` as
an intermediary.

The specification of `XWorkloadRegistration` is identical to
[WorkloadRegistration](workloadregistration.hbs.md) but without 
`spec.workloadRef.namespace` and `spec.authServerSelector`.

## <a id="spec"></a> Specification

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

> **Note** Crossplane's standard Crossplane Resource Model (commonly called XRM) 
> fields are omitted.

# <a id="example"></a> Examples

If a `Composition` for `XWorkloadRegistration` exists, for example, 
by using a `ClusterWorkloadRegistrationClass`, this is a minimal example:

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
