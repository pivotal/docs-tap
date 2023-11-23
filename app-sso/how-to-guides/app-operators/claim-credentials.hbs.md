# Claim credentials for an Application Single Sign-On service offering

This topic describes the recommended method for you to consume Application Single Sign-On
service offerings, which is by using a class claim.

When you create a claim for an Application Single Sign-On service, you receive your service
credentials through [service bindings](https://servicebinding.io/).
This makes it easier to load the credentials into a workload running on Tanzu Application Platform.

To learn about the different levels of Application Single Sign-On service consumption, see
[The three levels of Application Single Sign-On consumption](../../concepts/levels-of-consumption.hbs.md).

## <a id="discover-params"></a> Discover available parameters

To create a claim for an Application Single Sign-On service, target the specific service
and provide the required and optional parameters.
These parameters allow you to configure the OAuth2 client according to your needs.

To discover the parameter schema for a service, run:

```console
tanzu service class get NAME
```

For example:

```console
$ tanzu service class get sso

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

## <a id="claim-creds"></a>Claim credentials

To claim credentials you can either use the `tanzu service class-claim create` command
or create a `ClassClaim` directly.

- **If using the Tanzu CLI,** claim credentials by running:

    ```console
    tanzu service class-claim create CLAIM-NAME \
      --class SERVICE-NAME \
      --namespace NAMESPACE \
      --parameter workloadRef.name=WORKLOAD-NAME \
      --parameter PARAMETER
    ```

    Where:

    - `CLAIM-NAME` is a name you choose for your claim.
    - `SERVICE-NAME` is the name of the service that you want to claim.
    - `NAMESPACE` is the namespace that your workload is in.
    - `WORKLOAD-NAME` is the name of your workload.
    - (Optional) `PARAMETER` is a parameter that you choose in the format `KEY=VALUE`.
      You can add more than one optional parameter.
      For how to discover parameters you can add, see [Discover available parameters](#discover-params).

    For example:

    ```console
    $ tanzu service class-claim create my-class-claim \
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

You can inspect the progress of your claim creation by running:

```console
tanzu service class-claim get MY-CLAIM-NAME --namespace MY-NAMESPACE
```

or

```console
kubectl get classclaim MY-CLAIM-NAME --namespace MY-NAMESPACE --output yaml
```

> **Caution** It can take approximately 60 to 120 seconds for your Application Single Sign-On
> credentials to propagate into your service bindings secret.

## <a id="next-steps"></a>Next steps

You now have service credentials that you can use to secure your workload with SSO.
To learn about the specific client settings and how you can use a claim to secure a workload with
Application Single Sign-On, see [Secure a workload](secure-workload.hbs.md).
For tutorials that show how to secure specific types of workloads with Application Single Sign-On, see
[Secure a single-page app workload](./secure-spa-workload.hbs.md) and
[Secure a Spring Boot workload](./secure-spring-boot-workload.hbs.md).

If you have problems claiming credentials for an Application Single Sign-On service, learn how
to [troubleshoot](../troubleshoot.hbs.md).
For more information about the `tanzu service` command, classes, and claims, see the
[Tanzu Service CLI plug-in reference](../../../services-toolkit/reference/tanzu-service-cli.hbs.md).
