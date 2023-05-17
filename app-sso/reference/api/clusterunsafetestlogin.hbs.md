# ClusterUnsafeTestLogin

> **Caution** This API is not safe for production!

`ClusterUnsafeTestLogin` is the recommended way to get started with AppSSO in
non-production environments.

`ClusterUnsafeTestLogin` represents the request for an unsafe, ready-to-claim
AppSSO service offering. It reconciles into an unsafe `AuthServer`, a token
signing key `Secret` and a `ClusterWorkloadRegistrationClass`. It is
cluster-scoped. It has no spec. Its short name is `cutl`.

Its `AuthServer` is `http` only, allows all CORS origins, runs a single
replica, and has a single `user:password` login. Its name will be prefixed with
`unsafe-`. Its issuer URI will typically look like
`http://unsafe-demo.appsso.example.com`.

Its `ClusterWorkloadRegistrationClass` templates `WorkloadRegistration` with
safe _and_ unsafe redirect URIs. That means a redirect paths will be templated with
both `https` and `http` as the scheme.

Its namespace-scoped resources are placed in the cluster resource namespace.
The cluster resource namespace is
[configurable](../package-configuration.hbs.md). The default cluster resource
namespace is `appsso`.

Once created the offering can be discovered with the `tanzu` CLI:

```
❯ tanzu services classes list
  NAME      DESCRIPTION
  <name>    Single sign-on for testing - user:password - UNSAFE FOR PRODUCTION!
```

## Spec

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterUnsafeTestLogin
metadata:
  name: "" #! required
status:
  clusterResourceNamespace: ""
  conditions:
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: AuthServerReady
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: ClusterWorkloadRegistrationClassReady
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: Ready
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: SignAndVerifyKeyConditionReady
  observedGeneration: 0
  tokenSignature:
    signAndverifyKey:
      name: ""
      pem: ""
```

## Examples

Since this is a zero-config API, there's only one possible example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterUnsafeTestLogin
metadata:
  name: demo
```

