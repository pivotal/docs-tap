# Claim credentials for an Application Single Sign-On service offering

This topic describes the recommended method for you to consume Application Single Sign-On
service offerings, which is by using a class claim.

<!--If you want to learn more
about the different levels of Application Single Sign-On, see [The three levels of Application Single Sign-On
consumption](../concepts/app-sso-consumption.hbs.md).-->

When you create a claim for an Application Single Sign-On service, you receive your service
credentials through [service bindings](https://servicebinding.io/).
This makes it easier to load the credentials into a workload running on Tanzu Application Platform.

## <a id="discover-params"></a> Discover available parameters

To create a claim for an Application Single Sign-On service, target the specific service
and provide the required and optional parameters.
These parameters allow you to configure the OAuth2 client according to your needs.
<!-- seems specific to OAuth2 - can this be made generic? -->

To discover the parameter schema for a service, run:

```console
tanzu services classes get NAME
```

For an Application Single Sign-On service, the output looks similar to the following:

```console
$ tanzu services classes get sso

NAME:           app-sso
DESCRIPTION:    Login by AppSSO - OAuth2
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
default values, and whether they are required or not. The only required parameter is `workloadRef.name`.
<!-- is this statement about the required parameter true for something other than OAuth2? -->

## <a id="claim-creds"></a>Claim credentials

To claim credentials you can either use the `tanzu services class-claims create` command
or create a `ClassClaim` directly.

- **If using the Tanzu CLI,** claim credentials by running:

    ```console
    tanzu services class-claims create CLAIM-NAME \
      --class SERVICE-NAME \
      --namespace NAMESPACE \
      --parameter workloadRef.name=WORKLOAD-NAME \
      --parameter OPTIONAL-PARAMETER

    Where:

    - `CLAIM-NAME` is the you want for your claim.
    - `SERVICE-NAME` is the name of the service that you want to claim.
    - `NAMESPACE` is the namespace ... <!-- is this the namespace that your claim is in or your workload? -->
    - `WORKLOAD-NAME` is the name of your workload.
    - `OPTIONAL-PARAMETER` is an optional parameters that you choose.

    <!-- confirm these placeholders. Also, would you be required to use different parameters if not using OAuth2? -->

    For example:

    ```console
    $ tanzu services class-claims create my-class-claim \
      --class app-sso \
      --namespace my-namespace \
      --parameter workloadRef.name=my-workload \
      --parameter redirectPaths='["/login/oauth2/code/sso"]' \
      --parameter authorizationGrantTypes='["client_credentials", "authorization_code"]' \
      --parameter requireUserConsent=false
    ```

- **If using a `ClassClaim`,** create a YAML file similar to the following example:

    ```yaml
    ---
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ClassClaim
    metadata:
      name: my-class-claim
      namespace: my-namespace
    spec:
      classRef:
        name: app-sso
      parameters:
        workloadRef:
          name: my-workload
        redirectPaths:                        # Optional
          - /login/oauth2/code/sso
        authorizationGrantTypes:              # Optional
          - client_credentials
          - authorization_code
        requireUserConsent: false             # Optional
    ```

> **Important** When iterating on your `ClassClaim`, you must recreate it when you make changes.
> Updates to an existing `ClassClaim` have no effect.
> For more information, see
> [Class claims compared to resource claims](../../../services-toolkit/concepts/class-claim-vs-resource-claim.hbs.md#classclaim).

## <a id="inspect"></a>Inspect the progress of your claim

You can inspect the progress of you claim creation by running:

```console
tanzu services class-claims get MY-CLAIM-NAME --namespace MY-NAMESPACE
```

or

```console
kubectl get classclaim MY-CLAIM-NAME --namespace MY-NAMESPACE --output yaml
```

> **Caution** It can take approximately 60 to 120 seconds for your Application Single Sign-On
> credentials propagate into your service bindings secret.

## <a id="next-steps"></a>Next steps

You now have service credentials that you can use to secure your workload with SSO.
To learn about the specific client settings and how you can use a claim to secure a workload with
Application Single Sign-On, see [Secure a workload](secure-workload.hbs.md).
To learn how to secure specific types of workloads with Application Single Sign-On, see [the how-to guides](../../how-to-guides/index.hbs.md). <!-- link to specific pages -->

If you have problems claiming credentials for an Application Single Sign-On service, learn how
to [troubleshoot](../../how-to-guides/troubleshoot.hbs.md).
For more information about the `tanzu services` command, classes, and claims, see
[Tanzu Service CLI plug-in](../../../services-toolkit/reference/tanzu-service-cli.hbs.md).


