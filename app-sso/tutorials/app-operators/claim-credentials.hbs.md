# Claim credentials for an AppSSO service offering

In the previous section we have seen how to discover the available AppSSO
service offerings. The recommended way to consume such an AppSSO offering is by
claiming credentials for it through a class claim. If you want to learn more
about the different levels of AppSSO, see [The three levels of AppSSO
consumption](../concepts/app-sso-consumption.hbs.md).

When we create a claim for an AppSSO service, we will receive our service
credentials through [service bindings](https://servicebinding.io/). This makes
it easy to load the credentials into a workload running on TAP.

To create a claim for an AppSSO service we have to target the specific service
and provide a few required and optional parameters. These parameters allow us
to configure our OAuth2 client according to our needs.

Every service's parameter schema can be discovered. For an AppSSO service
it will look something like this:

```console
❯ tanzu services classes get <name>
NAME:           <name>
DESCRIPTION:    <description>
READY:          true

PARAMETERS:
  KEY                         DESCRIPTION  TYPE     DEFAULT               REQUIRED
  authorizationGrantTypes     [...]        array    [authorization_code]  false
  clientAuthenticationMethod  [...]        string   client_secret_basic   false
  redirectPaths               [...]        array    <nil>                 false
  requireUserConsent          [...]        boolean  true                  false
  scopes                      [...]        array    [map[...]]            false
  workloadRef.name            [...]        string   <nil>                 true
```

Here you can see all the parameters with a brief description, their types,
defaults and whether they are required or not. The only required parameter is
`workloadRef.name`. We will discuss the individual parameters in the next
section.

To claim credentials we can either use the `tanzu services class-claims create` command
or create a `ClassClaim` directly.

When using the `tanzu` CLI you could claim credentials like so:

```console
tanzu services class-claims create <my-claim-name> \
  --class <service-name> \
  --namespace <my-namespace> \
  --parameter workloadRef.name=my-workload \
  --parameter redirectPaths='["/login/oauth2/code/sso"]' \
  --parameter authorizationGrantTypes='["client_credentials", "authorization_code"]' \
  --parameter requireUserConsent=false
```

The following `ClassClaim` is synonymous with the command above:

```yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  name: <my-claim-name>
  namespace: <my-namespace
spec:
  classRef:
    name: <service-name>
  parameters:
    workloadRef:
      name: my-workload
    redirectPaths:
      - /login/oauth2/code/sso
    authorizationGrantTypes:
      - client_credentials
      - authorization_code
    requireUserConsent: false
```

You can inspect the progress of you claim creation with:

```console
tanzu services class-claims get <my-claim-name> --namespace <my-namespace>
```

or

```console
kubectl get classclaim <my-claim-name> --namespace <my-namespace> --output yaml
```

>**Caution** It can take `~60-120s` for your AppSSO credentials to be
>propagated into your service bindings secret.

Now you have OAuth2 client credentials which you can use to secure your
workload with SSO. Refer to [the how-to guides](../../how-to-guides/index.hbs.md)
to learn how to secure specific types of workloads with AppSSO.

When iterating on your `ClassClaim` make sure to recreate it when you make
changes. Updates to an existing `ClassClaim` [have no
effect](../../../services-toolkit/concepts/class-claim-vs-resource-claim.hbs.md#classclaim)

If you run into problems claiming credentials for an AppSSO service, learn how
to [troubleshoot](../../how-to-guides/troubleshoot.hbs.md). For in-depth
documentation on the `tanzu services` command, classes and claims, refer to
[Services Toolkit](../../tutorials/services-toolkit/about.hbs.md).

In the next section you will learn more about the specific client settings and how
you can use a claim to secure a `Workload` with AppSSO.

