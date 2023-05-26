# Curating a service offering

Assuming that you have an `AuthServer` which is configured to your needs after
the previous sections, here is how you expose it as a ready-to-claim service
offering.

`ClusterWorkloadRegistrationClass` creates resources so that _application
operators_ can discover and claim credentials for an AppSSO service offering.

A `ClusterWorkloadRegistrationClass` has a description which will be shown when
it gets discovered with `tanzu services classes list`. This allows you identity
the offering as an AppSSO service and say more about it if you like.

Furthermore, `ClusterWorkloadRegistrationClass` carries a base
`WorkloadRegistration` which is the blueprint for claims against this service.
This base selects the target `AuthServer`. It also can receive labels and
annotations which all `WorkloadRegistration` will inherit.

Say, we have an `AuthServer` with the following labels:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  labels:
    sso.apps.tanzu.vmware.com/env: staging
    sso.apps.tanzu.vmware.com/ldap: ""
#! ...
```

We can expose it as a claimable service offering with the following
`ClusterWorkloadRegistrationClass`:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterWorkloadRegistrationClass
metadata:
  name: demo
spec:
  description:
    short: Single Sign-On with LDAP
  base:
    authServerSelector:
      matchLabels:
        sso.apps.tanzu.vmware.com/env: staging
        sso.apps.tanzu.vmware.com/ldap: ""
```

After applying this resource, _application operators_ can discover it like so:

```plain
❯ tanzu services classes list
  NAME  DESCRIPTION
  demo  Single sign-on with LDAP
```

When they claim credentials from this class, a `WorkloadRegistration` is
created and it will target our `AuthServer`. They can either use the command
`tanzu services class-claims create` or create a `ClassClaim` directly.

It is possible to further customize the minted `WorkloadRegistration` by
setting labels and annotations for them. For example, if you would like for
`WorkloadRegistration` to template redirect URIs with both `https://` _and_
`http://`, then you modify the `ClusterWorkloadRegistrationClass` like so:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterWorkloadRegistrationClass
metadata:
  name: demo
spec:
  description:
    short: Single Sign-On with LDAP
  base:
    metadata:
      annotations:
        sso.apps.tanzu.vmware.com/template-unsafe-redirect-uris: ""
    authServerSelector:
      matchLabels:
        sso.apps.tanzu.vmware.com/env: staging
        sso.apps.tanzu.vmware.com/ldap: ""
```
