# Curate a service offering

This topic describes how you expose an `AuthServer` as a ready-to-claim service
offering using a `ClusterWorkloadRegistrationClass`.

`ClusterWorkloadRegistrationClass` creates resources so that application
operators can discover and claim credentials for an Application Single Sign-On service offering.

A `ClusterWorkloadRegistrationClass` has a description that is shown
when application operators discover services by running `tanzu services classes list`.
This allows you identify the offering as an Application Single Sign-On service.

Furthermore, `ClusterWorkloadRegistrationClass` carries a base
`WorkloadRegistration`, which is the blueprint for claims against this service.
This base selects the target `AuthServer`. It can optionally receive a custom
domain template, labels, and annotations that all `WorkloadRegistration` inherit.

## <a id="prerequisites"></a>Prerequisites

Before you create a service offering, you must create and configure an `AuthServer`.
For instructions, see []().
<!-- there are many topics for configuring an AuthServer. work out how to link. should it be a subsection? -->

## <a id="create"></a>Create a `ClusterWorkloadRegistrationClass`

For an `AuthServer` with the following labels:

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

You can expose it as a claimable service offering with a `ClusterWorkloadRegistrationClass`
with configured:

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

After applying this resource, application operators can discover it by running:

```console
$ tanzu services classes list
  NAME  DESCRIPTION
  demo  Login by AppSSO
```
<!--฿ Use the dollar sign only inside example terminal code, not in commands to run. ฿-->
Credentials for this service can be<!--฿ Consider switching to active voice. ฿--> claimed either with the command `tanzu
services class-claims create` or with a `ClassClaim` resource.

When a claim is created, a `WorkloadRegistration` gets<!--฿ There is likely a more precise and formal word to use here than |gets|. ฿--> stamped out from the
base and it will<!--฿ Avoid |will|: present tense is preferred. ฿--> target our `AuthServer`.

## <a id="customize"></a>Customize the `ClusterWorkloadRegistrationClass`

Each `WorkloadRegistration` gets<!--฿ There is likely a more precise and formal word to use here than |gets|. ฿--> `https://` redirect URIs templated. The
default template is configured with
[default_workload_domain_template](../../reference/package-configuration.hbs.md#default_workload_domain_template)
If omitted the default template is used. Otherwise you can customize it by
setting a template on the base.

You can further customize each `WorkloadRegistration` created by
setting labels and annotations for them.

The default description of an Application Single Sign-On service offering is `"Login by AppSSO"`,
but you can customize this. Consider using a good name and description.
For more information, see [Names and descriptions](#names-and-descriptions) later in this topic.

For example, if you want the `WorkloadRegistration` to template redirect
URIs from a custom template and with both `https://` and `http://`, _and_ you
want to say that in the service's description, modify<!--฿ |edit| is preferred. ฿--> the
`ClusterWorkloadRegistrationClass` as follows:

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

## <a id="name-and-desc"></a>Names and descriptions

When choosing a name and a description for a `ClusterWorkloadRegistrationClass`
consider the following:

- When the name of a service is stable across environments, for example, from dev to
  production, application operators can use the same `ClassClaim` in all environments.

- The description of a service must clearly communicate its flavor and provider.
  The default description of a `ClusterWorkloadRegistrationClass` is `"Login by AppSSO"`.

  If there is a single Application Single Sign-On service offering the default description is
  usually good enough.

  If you want to customize the description for your `ClusterWorkloadRegistrationClass`,
  consider prefixing it with `"Login by AppSSO - "`, for example, `"Login by AppSSO - LDAP and GitHub`.
