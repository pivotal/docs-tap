# ClusterUnsafeTestLogin API for Application Single Sign-On

`ClusterUnsafeTestLogin` is the recommended way to get started with Application
Single Sign-On (commonly called AppSSO) in non-production environments, and it is
not safe for production.

`ClusterUnsafeTestLogin` represents the request for an unsafe, ready-to-claim
AppSSO service offering. It reconciles into an unsafe `AuthServer`, a token
signing key `Secret`, and a `ClusterWorkloadRegistrationClass`. It is
cluster-scoped and has no specifications.

Its `AuthServer` is `http` only, which allows all CORS origins and runs with a
single replica. Its name is prefixed with `unsafe-`. Its issuer URI resembles
`http://unsafe-demo.appsso.example.com`.

There is a single `user:password` login. That user has roles `user` and `test`
and claims `first_name=First-Name`, `last_name=Last-Name` and
`email=user@example.com`.

Its `ClusterWorkloadRegistrationClass` templates `WorkloadRegistration` with
safe and unsafe redirect URIs. That means a redirect path is templated with
both `https` and `http` as the scheme.

Its namespace-scoped resources are placed in the cluster resource namespace.
The cluster resource namespace is
[configurable](../package-configuration.hbs.md). The default cluster resource
namespace is `appsso`.

Once created, you can discover it with the Tanzu Service CLI:

```console
$ tanzu service class list
  NAME      DESCRIPTION
  <name>    Login by AppSSO - user:password - UNSAFE FOR PRODUCTION!
```

## <a id="spec"></a> Specification

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterUnsafeTestLogin
metadata:
  name: "" #! required
status:
  issuerURI: ""
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

## <a id="example"></a> Example

Due to the zero-configuration nature of the `ClusterUnsafeTestLogin` API,
there exists only a single feasible example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterUnsafeTestLogin
metadata:
  name: demo
```
