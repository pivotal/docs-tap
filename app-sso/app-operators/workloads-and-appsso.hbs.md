# Workloads and AppSSO

This section will help you understand how to navigate AppSSO configuration when defining workloads. For specific 
stack implementations such as Spring Boot, refer to table of contents in this section for detailed guides.

An AppSSO `AuthServer` and your `Workload` need to establish a bidirectional relationship: `AuthServer` is aware of your 
`Workload` and your `Workload` is aware of an `AuthServer`. How does that work?

- To make `AuthServer` aware of your `Workload` (i.e. that `AuthServer` should be responsible for authentication and authorization
  duties), you have to [create and apply a `ClientRegistration` resource](#clientregistration).
- To make your Workload aware of an `AuthServer` (i.e. that your application shall now rely on AppSSO for authentication and
  authorization requests), you must [specify a service resource claim of a `ClientRegistration`](#claim)
  which produces the necessary credentials for your Workload to consume.
- (Optional) Ensure your `Workload` trusts a TLS-enabled `AuthServer`.
  For more information, see [Configure Workloads to trust a custom Certificate Authority (CA)](../service-operators/workload-trust-custom-ca.hbs.md).

> **Important** You must ensure `Workload` trusts the `AuthServer` if you use the default self-signed
> certificate `ClusterIssuer` while installing Tanzu Application Platform.

The following sections elaborate on these concepts in detail.

## <a id='clientregistration'></a> The `ClientRegistration` resource

A `ClientRegistration` registers a client entity with an `AuthServer`.

> **Note** Please refer to the [`ClientRegistration` resource documentation page](../crds/clientregistration.md) for
> additional details on schema and specification of the resource.

_Example_: A `ClientRegistration` resource, residing in a workloads-ready namespace `my-apps`.

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: my-workload-client
  namespace: my-apps
spec:
  authServerSelector:
    matchLabels:
    # ask your Service Operator for labels to target an `AuthServer`
  authorizationGrantTypes:
    - authorization_code
  clientAuthenticationMethod: client_secret_basic
  requireUserConsent: true
  redirectURIs:
    - "<MY_WORKLOAD_HOSTNAME>/redirect-uri"
  scopes:
    - name: openid
```

Once a `ClientRegistration` is applied and has status of `Ready`, it is [claimable by a `Workload`](#claim) which provides
the credentials to your application to use as necessary.

### <a id='redirect-uris'></a> Redirect URIs

A client registration's `redirectURIs` define the location for an `AuthServer` to send the user back to once they are
authenticated. The redirect locations vary by implementation, and you should choose them appropriately. 

> **Caution** Redirect URIs may not contain loopback alias `localhost` (e.g. `http://localhost:8080`). Rely on
> `127.0.0.1` instead (e.g. `http://127.0.0.1:8080`)

**Spring Boot**

For servlet-based Spring Boot workloads using Spring Security OAuth 2 Client library, the default redirect URI template
is: `{workloadBaseUrl}/login/oauth2/code/{ClientRegistration.metadata.name}` ([read more about this format here](https://docs.spring.io/spring-security/reference/servlet/oauth2/login/core.html#oauth2login-sample-redirect-uri)).

_Example_: given a `Workload` base domain is `https://app.my-apps.example.com` and `ClientRegistration` with
name `my-workload-client`, the redirect URI to set would be:

```yaml
spec:
  redirectUris:
    - "https://app.my-apps.example.com/login/oauth2/code/my-workload-client"
```

### Scopes

TODO

### Authorization Grant Types

AppSSO supports Authorization Code (`authorization_code`), Client Credentials (`client_credentials`), and Refresh
Token (`refresh_token`) OAuth grant types. 

**Authorization Code grant type**

This grant type is used by applications seeking to authenticate and authorize end-users. An `AuthServer` will issue
identity and access tokens to applications to identify end users' identity as well as the level of access they have
to protected resources.

**Client Credentials grant type**

This grant type is used by applications seeking to communicate directly to other protected applications, using a client
identifier and client secret (e.g. service-to-service communication). An `AuthServer` will issue access tokens, that
define the level of access that the requesting service has to the protected service they seek to communicate with.

> **Note** It is recommended to choose only `authorization_code` or `client_credentials` grant type per client registration
> as the use cases for both grant types differ, and so creating multiple registrations is preferred.

**Refresh Token grant type**

This grant type is used by applications seeking to obtain access tokens. If `refresh_token` grant type is included, on 
every access token issue by an `AuthServer`, a refresh token is included. This refresh token can be used to fetch new
access tokens before older ones expire to continue accessing protected resources.

### Client Authentication Method

Client authentication method is the approach the client will take to authenticate with an authorization server. The default
value of `client_secret_basic` is the recommended method for authentication for non-browser-based applications such as
Spring Boot or .NET Core apps (confidential clients).

**Browser-based single-page apps**

Client authentication method value `none` **must** be set.
See [Configure authorization - client authentication](../service-operators/configure-authorization.hbs.md#client-authentication)
for details.

Read more about all available [client authentication methods here](../crds/clientregistration.hbs.md#client-auth-methods)

### Requiring user consent

TODO

## <a id='claim'></a> Claim a `ClientRegistration`

Once a `ClientRegistration` resource has been applied, you may claim it using tanzu service CLI:

```shell
tanzu service resource-claim create my-client-claim \
  --namespace my-apps \
  --resource-api-version sso.apps.tanzu.vmware.com/v1alpha1 \
  --resource-kind ClientRegistration \
  --resource-name my-workload-client \
  --resource-namespace my-apps
```

Alternatively, you may claim it using `ResourceClaim` resource definition:

```shell
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ResourceClaim
metadata:
  name: my-client-claim
  namespace: my-apps
spec:
  ref:
    apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
    kind: ClientRegistration
    name: my-workload-client
    namespace: my-apps
```

Observe the status of the service resource claim by running `tanzu service resource-claim list -n my-apps -o wide`:

```text
NAMESPACE   NAME             READY  REASON  CLAIM REF
my-apps     my-client-claim  True           services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:my-client-claim
```

## Connecting a `Workload` to an `AuthServer`

The created service resource claim will be referable within a `Workload`:

_Example_: An example `Workload` in `my-apps` namespace

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: my-workload
  namespace: my-apps
spec:
  source:
    git:
      url: https://github.com/my-company/my-app.git
      ref:
        branch: main
  serviceClaims:
    - name: my-client-claim
      ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ResourceClaim
        name: my-client-claim
```

Alternatively, you can refer to your `ClientRegistration` when deploying your workload with the `tanzu` CLI as such

```shell
tanzu apps workload create my-workload \
  --service-ref "my-client-claim=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:my-client-claim" \
  # ...
```

What this service resource claim reference binding does under the hood is ensures that your `Workload`'s `Pod`(s) is
mounted with a volume containing the necessary credentials required by your application to become aware of AppSSO.

The credentials provided by the service resource claim are:

- `client-id`: the identifier of your `Workload` that AppSSO is registered with. This is a unique identifier.
- `client-secret`: secret string value used by AppSSO to verify your client. Keep this value secret.
- `issuer-uri`: web address of AppSSO `AuthServer`, and the primary location that your `Workload` navigates to when
  interacting with AppSSO.
- `authorization-grant-types`: list of desired OAuth 2 grant types.
- `client-authentication-method`: method in which the client is authenticated when requesting an identity or access token.
- `scope`: list of desired scopes that your application's users have access to.

The above credentials are mounted onto your `Workload`'s `Pod`(s) as individual files at the following locations:

```shell
/bindings
  /<name-of-service-claim>
    /client-id
    /client-secret
    /issuer-uri
    /authorization-grant-types
    /client-authentication-method
    /scope
```

Taking our example from above, the location of mounted credentials can be found on every Workload Pod at the following location:

```shell
/bindings/my-client-claim
```

Given these auto-generated values, your `Workload` is now able to load them at runtime and bind to an AppSSO `AuthServer` 
at start-up time. Reading the values from the file system is left to the implementor as to the approach taken.
