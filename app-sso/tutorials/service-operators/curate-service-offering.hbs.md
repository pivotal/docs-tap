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
This base selects the target `AuthServer`. It can optionally receive a custom
domain template, labels and annotations which all `WorkloadRegistration` will
inherit.

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
  demo  Login by AppSSO
```

Credentials for this service can be claimed either with the command `tanzu
services class-claims create` or with a `ClassClaim` resource.

When a claim is created, a `WorkloadRegistration` gets stamped out from the
base and it will target our `AuthServer`.

Each `WorkloadRegistration` gets `https://` redirect URIs templated. The
default template is configured with
[default_workload_domain_template](../../reference/package-configuration.hbs.md#default_workload_domain_template)
If omitted the default template is used. Otherwise it can be customized by
setting a template on the base.

It is possible to further customize each minted `WorkloadRegistration` by
setting labels and annotations for them.

The default description of an AppSSO service offering is `"Login by AppSSO"`.
This can be customized. Consider good [names and
descriptions](#names-and-descriptions).

For example, if you would like for `WorkloadRegistration` to template redirect
URIs from a custom template and with both `https://` and `http://`, _and_ you
would like to say that in the service's description, then you modify the
`ClusterWorkloadRegistrationClass` like so:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterWorkloadRegistrationClass
metadata:
  name: demo
spec:
  description:
    short: Login by AppSSO with LDAP for apps in the "demo" subdomain
  base:
    metadata:
      annotations:
        sso.apps.tanzu.vmware.com/template-unsafe-redirect-uris: ""
    spec:
      workloadDomainTemplate: "\{{.Name}}-\{{.Namespace}}.demo.\{{.Domain}}"
      authServerSelector:
        matchLabels:
          sso.apps.tanzu.vmware.com/env: staging
          sso.apps.tanzu.vmware.com/ldap: ""
```

## Names and descriptions

When choosing a name and a description for a `ClusterWorkloadRegistrationClass`
consider the following:

* When names of a service are stable across environments (say, from dev to
  production), then _application operators_ can use the same `ClassClaim` in
  all environments.

* The description of a service should clearly communicate its flavour and
  provider. The default description of a `ClusterWorkloadRegistrationClass` is
  `"Login by AppSSO"`.

  If there is a single AppSSO service offering the default description is
  usually good enough.

  If you would like to customize your `ClusterWorkloadRegistrationClass`'s
  description consider prefixing it with `"Login by AppSSO - "`, e.g. `"Login
  by AppSSO - LDAP and GitHub`.

