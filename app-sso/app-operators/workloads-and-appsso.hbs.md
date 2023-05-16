# Workloads and AppSSO

This topic walks you through how to navigate AppSSO configuration when defining workloads. For specific 
stack implementations such as Spring Boot, see [Application Single Sign-On for App Operators](index.hbs.md).

An AppSSO `AuthServer` and your `Workload` must be able to detect each other and can communicate bidirectionally:

- To make `AuthServer` detect your `Workload`, for example, `AuthServer` is 
  responsible for authentication and authorization duties, you must create and 
  apply a `ClientRegistration` resource. 
  For more information, see [The ClientRegistration resource](#clientregistration).
- To make your `Workload` detect an `AuthServer`, for example, your application 
  relies on AppSSO for authentication and authorization requests, you must specify 
  a service resource claim of a `ClientRegistration`, which produces the necessary 
  credentials for your `Workload` to consume. 
  For more information, see [Claim a ClientRegistration](#claim).
- (Optional) Ensure your `Workload` trusts a TLS-enabled `AuthServer`.
  For more information, see [Configure Workloads to trust a custom Certificate Authority (CA)](../service-operators/workload-trust-custom-ca.hbs.md).

    > **Important** You must ensure `Workload` trusts the `AuthServer` if you use the default self-signed
    > certificate `ClusterIssuer` while installing Tanzu Application Platform.

The following sections elaborate on these concepts in detail.

## <a id='clientregistration'></a> The `ClientRegistration` resource

A `ClientRegistration` registers a client entity with an `AuthServer`.

**Example:** A `ClientRegistration` resource, residing in a workloads-ready namespace `my-apps`.

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: my-workload-client
  namespace: my-apps
spec:
  authServerSelector:
    matchLabels:
    # Ask your Service Operator for labels to target an `AuthServer`
    # or run `kubectl label --list authserver/<authserver-name> -n <authserver-ns>`
  authorizationGrantTypes:
    - authorization_code
  clientAuthenticationMethod: client_secret_basic
  requireUserConsent: true
  redirectURIs:
    - "<MY_WORKLOAD_HOSTNAME>/redirect-uri"
  scopes:
    - name: openid
```

To verify the status of the `ClientRegistration`, run:

```shell
kubectl get clientregistration my-workload-client --namespace my-apps
```

After a `ClientRegistration` is applied and has status of `Ready`, it is claimable 
by a `Workload`, which provides the necessary credentials to your application. 
For more information, see [Claim a ClientRegistration](#claim).

For more information about the schema and specification of the resource, 
see [ClientRegistration](../reference/api/clientregistration.hbs.md).

### <a id='redirect-uris'></a> Redirect URIs

A client registration's `redirectURIs` define the location for an `AuthServer` 
to send the user back to after they are authenticated. 
You must configure the redirect locations based on your implementation method.

> **Caution** Redirect URIs might not contain loopback alias `localhost`, for example, `http://localhost:8080`. 
> You can use `127.0.0.1` instead, for example, `http://127.0.0.1:8080`.

For servlet-based Spring Boot workloads using Spring Security OAuth 2 Client library, 
the default redirect URI template is: `{workloadBaseUrl}/login/oauth2/code/{ClientRegistration.metadata.name}`. 
For more information about the format, see [Spring documentation](https://docs.spring.io/spring-security/reference/servlet/oauth2/login/core.html#oauth2login-sample-redirect-uri).

**Example:** If a `Workload` base domain is `https://app.my-apps.prod.example.com`, 
where `prod.example.com` is your `shared.ingress_domain` value 
and `ClientRegistration` is named as `my-workload-client`, the redirect URI is:

```yaml
spec:
  redirectUris:
    - "https://app.my-apps.prod.example.com/login/oauth2/code/my-workload-client"
```

### <a id='auth-grant-types'></a> Authorization grant types

AppSSO supports the following OAuth grant types:

- Authorization Code: `authorization_code`

    This grant type is used by applications seeking to authenticate and authorize end-users. An `AuthServer` issues
    identity and access tokens to applications to identify end users' identity and the level of access they have
    to protected resources.

- Client Credentials: `client_credentials`

    This grant type is used by applications seeking to communicate directly to other protected applications, by using a client
    identifier and client secret, for example, service-to-service communication. An `AuthServer` issues access tokens that
    define the level of access that the requesting service has to the protected service they seek to communicate with.

    > **Note** Use cases for grant types `authorization_code` and `client_credentials` are typically different, so VMware recommends
    > creating separate client registrations for each grant type.

- Refresh Token: `refresh_token`

    This grant type is used by applications seeking to obtain access tokens. If `refresh_token` grant type is included, on 
    every access token issue by an `AuthServer`, a refresh token is included. You can use the refresh token to fetch new
    access tokens before older ones expire to continue accessing protected resources.

### <a id='client-auth-methods'></a> Client authentication method

Client authentication method is the approach the client takes to authenticate with an authorization server. The default
value of `client_secret_basic` is the recommended method for authenticating server-based applications such as
Spring Boot or .NET Core apps (confidential clients).

For browser-based single-page apps, client authentication method must be set to `none`.
For more information, see [Configure authorization](../service-operators/configure-authorization.hbs.md) 
and [Client authentication methods](../reference/api/clientregistration.hbs.md#client-auth-methods).

### <a id='scopes'></a> Scopes

The `scopes` field allows for configuring requested OAuth2 scopes including standard OpenID claims. 
The scopes provided within this field can be mapped to upstream identity provider roles. 
For more information, see [Configure authorization](../service-operators/configure-authorization.hbs.md).

To activate issuance of uers' identity tokens and authentication, you must include the `openid` scope.

To activate fetching of user roles or groups, you must include the `roles` scope.

**Example:** a `ClientRegistration` allows the client to request identity tokens 
with user information and specific read, write, and delete developer privileges, 
given a user has any of the scopes listed.

```yaml
kind: ClientRegistration
# ...
spec:
  scopes:
    - name: openid             # standard OpenID scope, containing claims "sub" (subject), "aud" (audience), etc.
    - name: email              # standard OpenID scope, containing claims "email" and "email_verified"
    - name: profile            # standard OpenID scope, containing claims "name", "given_name", "family_name", etc.
    - name: roles              # AppSSO special scope, requesting user roles/groups be populated in "roles" claim.
    - name: developer.read     # custom authorization scope
    - name: developer.write    # ^^
    - name: developer.delete   # ^^
```

### <a id='consent'></a> Requiring user consent

The `requireUserConsent` field allows for toggling scopes approval for end-users. 
If activated, every end user is prompted to consent to or reject scopes that the 
client requests on behalf of the user. If deactivated, all scopes that the client 
requests are auto-approved or consented to without prompt.

## <a id='claim'></a> Claim a `ClientRegistration`

When a `ClientRegistration` resource is ready, you can claim it by using a `ResourceClaim` resource:

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

Alternatively, you can also claim a `ClientRegistration` by using tanzu service CLI:

```shell
tanzu service resource-claim create my-client-claim \
  --namespace my-apps \
  --resource-api-version sso.apps.tanzu.vmware.com/v1alpha1 \
  --resource-kind ClientRegistration \
  --resource-name my-workload-client \
  --resource-namespace my-apps
```

Verify the status of the service resource claim by running `tanzu service resource-claim list -n my-apps -o wide`:

```text
NAMESPACE   NAME             READY  REASON  CLAIM REF
my-apps     my-client-claim  True           services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:my-client-claim
```

## <a id='connect'></a> Connecting a `Workload` to an `AuthServer`

Now you can reference the created service resource claim by a `Workload`.

**Example:** An example `Workload` in `my-apps` namespace.

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
    - name: my-workload-client # Must match the name of the referenced `ClientRegistration`.
      ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ResourceClaim
        name: my-client-claim
```

Alternatively, you can refer to your `ClientRegistration` when deploying your workload with the `tanzu` CLI:

```shell
tanzu apps workload create my-workload \
  --service-ref "my-workload-client=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:my-client-claim" \
  # ...
```

>**Important** The service ref name must match the name of the referenced `ClientRegistration`.

The service resource claim reference binding ensures that your `Workload`'s `Pod` (one or more) is
mounted with a volume containing the necessary credentials required by your application to detect AppSSO.

The credentials provided by the service resource claim are:

- `client-id`: the identifier of your `Workload` that AppSSO is registered with. This is a unique identifier.
- `client-secret`: secret string value used by AppSSO to verify your client. Keep this value secret.
- `issuer-uri`: web address of AppSSO `AuthServer` and the primary location that your `Workload` navigates to when
  interacting with AppSSO.
- `authorization-grant-types`: list of the desired OAuth 2 grant types.
- `client-authentication-method`: method in which the client is authenticated when requesting an identity or access token.
- `scope`: list of the desired scopes that your application's users have access to.

These credentials are mounted onto your `Workload`'s `Pod`(one or more) as individual files at the following locations:

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

Following the earlier example, you can find the location of mounted credentials on every `Workload Pod` at:

```shell
/bindings/my-workload-client
```

Given these auto-generated values, your `Workload` can now load them at runtime and bind to an AppSSO `AuthServer`
at start-up time. Reading the values from the file system is left to the implementor as to the approach taken.
