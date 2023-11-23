# Secure a workload with Application Single Sign-On

This tutorial tells you how to secure a `Workload` running on Tanzu Application
Platform with Application Single Sign-On (commonly called AppSSO).

For specific stack implementations, see [Secure a single-page app workload](../../how-to-guides/app-operators/secure-spa-workload.hbs.md) and [Secure a Spring Boot workload](../../how-to-guides/app-operators/secure-spring-boot-workload.hbs.md).

The [Getting Started](../../getting-started/index.hbs.md) section
explains how to obtain OAuth2 client credentials for an authorization server by
claiming them from an Application Single Sign-On service offering.
You can enable this by running the `tanzu service class-claims create` command or
by using a `ClassClaim` resource. In either case, you can customize your OAuth2 client
settings by providing parameters within your claim. To secure your `Workload`,
you must provide the appropriate parameters relevant to the given situation.

The following sections elaborate on each parameter in detail and guide the process
of loading credentials into a `Workload`.

When editing your `ClassClaim`, you must recreate it in order for the changes to
take effect. Updating an existing `ClassClaim` does not produce any impact.
For more information, see [Using a `ClassClaim`](../../../services-toolkit/concepts/class-claim-vs-resource-claim.hbs.md#classclaim).

## <a id="oauth2"></a> OAuth2 client parameters

A `ClassClaim` for an Application Single Sign-On service is the request for
OAuth2 client credentials for an authorization server.

The following is an example of a claim for a service called `sso`, which
customizes all available client parameters:

```yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  name: my-sso-client
  namespace: my-apps
spec:
  classRef:
    name: sso
  parameters:
    workloadRef:
      name: my-workload
    redirectPaths:
      - /login/oauth2/code/my-sso-client
    scopes:
      - name: openid
      - name: email
      - name: profile
      - name: roles
      - name: coffee.make
        description: bestows the ultimate power
    authorizationGrantTypes:
      - client_credentials
      - authorization_code
      - refresh_token
    clientAuthenticationMethod: client_secret_basic
    requireUserConsent: true
```

To verify the status of this `ClassClaim`, run:

```shell
kubectl get classclaim my-sso-client --namespace my-apps
```

After a `ClassClaim` is applied and its status shows `Ready`, it can be consumed
by a `Workload`. When the credentials are loaded into a `Workload`, your
application code can use them to initiate OAuth2 flows.

### <a id='redirect-paths'></a> `redirectPaths`

As a critical part of your client parameters, `redirectPaths` define the locations
to which your application's end-users are redirected to after the authentication.
Incorrect redirect URIs often cause errors for clients and are the most common
source of such issues. When redirect URIs are not configured accurately, your
application encounters errors and can not perform OAuth2 flows.

For servlet-based Spring Boot workloads using Spring Security OAuth 2 Client
library, the default redirect path template looks as follows:

```plain
/login/oauth2/code/{ClassClaim.metadata.name}`
```

For more information about the format, see the [Spring documentation](https://docs.spring.io/spring-security/reference/servlet/oauth2/login/core.html#oauth2login-sample-redirect-uri).

For example, configure a single redirect path in `ClassClaim`:

```yaml
spec:
  parameters:
    redirectPaths:
      - /login/oauth2/code/my-sso-client
```

Behind the scenes, your redirect paths are templated into the full redirect URIs
including a scheme and fully-qualified domain name. For example, your actual
redirect URI might look as follows:

```plain
https://my-workload.my-apps.example.com/login/oauth2/code/my-sso-client
```

The choice of scheme (`https` or `http`), the template for the subdomain and the
ingress domain are under the control of your service operators and platform
operators. If your redirect URIs do not template according to your needs,
reach out to your service operators and platform operators and request adjustments
to the templates.

Redirect paths are one of the values for templating redirect URIs.
However, there is another parameter that needs to be considered,
which leads us to the next parameter.

### <a id="workload-ref"></a> `workloadRef`

`workloadRef.name` is the name of the workload which acts as the OAuth2 client.
You can use this value when templating the fully-qualified domain name of your
redirect URIs.

```yaml
spec:
  parameters:
    workloadRef:
      name: my-workload
```

Therefore, if you rename your workload from `my-workload` to a different name,
you must update this parameter to align with the new name.

> **Note** `workloadRef` is not resolved to an actual `Workload` existing on the
> cluster. This means that the claim does not depend on the existence of a `Workload`.

### <a id='auth-grant-types'></a> `authorizationGrantTypes`

In OAuth2, a grant type is the way your application obtains tokens from the
authorization server. There are different grant types. Some of them allow your
application to act on behalf of an end user, but others do not.

The `authorizationGrantTypes` parameter denotes all the grant types your
application can use:

```yaml
spec:
  parameters:
    authorizationGrantTypes:
      - client_credentials
      - authorization_code
      - refresh_token
```

Application Single Sign-On supports the following OAuth2 grant types:

- Authorization Code: `authorization_code`

    Applications use this grant type to authenticate and authorize end users.
    An `AuthServer` issues identity and access tokens to applications to identify
    end users' identities and their level of access to the protected resources.

- Client Credentials: `client_credentials`

    Applications use this grant type to communicate directly to other protected
    applications through a client identifier and a client secret.
    For example, in service-to-service communication, an `AuthServer`
    issues access tokens that define the level of access that the requesting
    service has to the protected service they seek to communicate with.

    > **Note** Use cases for the grant type `authorization_code` and
    > `client_credentials` are typically different, so VMware recommends
    > creating separate client registrations for each grant type.

- Refresh Token: `refresh_token`

    Applications use this grant type to obtain access tokens. If the
    `refresh_token` grant type is included, a refresh token is attached to every
    access token issued by an `AuthServer`. You can use the refresh token to
    fetch the new access tokens before the older ones expire to continue accessing
    the protected resources.

### <a id='client-auth-method'></a> Client authentication method

A client authentication method defines how your application presents its
credentials to the authorization server.

```yaml
spec:
  parameters:
    clientAuthenticationMethod: client_secret_basic
```

There are three client authentication methods:

- `client_secret_basic`(default): Send the client credentials by using the HTTP
  "Basic" authentication scheme. This is the recommended method for
  authenticating server-based applications such as Spring Boot or .NET Core
  apps (confidential clients).
- `client_secret_post`: Send the client credentials in the body of an HTTP POST
  request.
- `none`: Do not send the client credentials. This is for browser-based single-page
  apps.

### <a id='scopes'></a> `scopes`

The `scopes` field defines the OAuth2 scopes requested by your application,
including the standard OpenID claims.

```yaml
spec:
  parameters:
    scopes:
      - name: openid # Standard OpenID scope, containing claims "sub" (subject), "aud" (audience) and so on.
      - name: email # Standard OpenID scope, containing claims "email" and "email_verified".
      - name: profile # Standard OpenID scope, containing claims "name", "given_name", "family_name" and so on.
      - name: roles # AppSSO special scope, requesting the user roles or groups be populated in the "roles" claim.
      - name: coffee.make # Custom the authorization scope.
        description: bestows the ultimate power # With a custom description.
```

To activate the issuance of the users' identity tokens and authentication, you must
include the `openid` scope.

To activate fetching of the user roles or groups, you must include the `roles`
scope.

### <a id='user-consent'></a> `requireUserConsent`

The `requireUserConsent` field defines the toggling scopes approved by the end users.

```yaml
spec:
  parameters:
    requireUserConsent: true
```

If activated, the end users are prompted to consent to or reject the scopes that the
client requests on behalf of them. If deactivated, all scopes that the client
requests are auto-approved or consented to without prompting.

## <a id='behind-scenes'></a> Behind the scenes

When you create a `ClassClaim` for an Application Single Sign-On service, several
resources are created behind the scenes. These resources can be helpful for
debugging purposes.

- You create a `ClassClaim` for an Application Single Sign-On service with your
  parameters.
- An `XWorkloadRegistration` with your parameter is created in the same
  namespace.
- A `WorkloadRegistration` with your parameter is created in the same namespace.
  The `WorkloadRegistration` templates your redirect URIs.
- A `ClientRegistration` with your parameters and the templated redirect URIs
   are created in the same namespace.
- The `ClientRegistration` receives the client credentials and passes them all
   the way to your `ClassClaim`.

## <a id='load-credentials'></a> Loading client credentials into a `Workload`

Now that you have a client credentials for your application, you can reference
the `ClassClaim` from your `Workload`.

An example `Workload` in `my-apps` namespace is as follows:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: my-workload
  namespace: my-apps
spec:
  serviceClaims:
    - name: my-sso-client # Must match the name of the referenced `ClassClaim`.
      ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ClassClaim
        name: my-sso-claim
  #! ...
```

Alternatively, you can refer to your `ClassClaim` when deploying your workload
with the Tanzu CLI:

```shell
tanzu apps workload create my-workload \
  --service-ref "my-sso-client=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:my-sso-claim" \
  # ...
```

>**Important** The service ref name must match the name of the referenced
>`ClassClaim`.

Thanks to service bindings, your credentials are provided to your
`Workload`'s `Pod` (one or more) by mounting a volume containing your client
credentials.

The credentials provided by the claim are:

- `client-id`: The identifier of your `Workload` that Application Single Sign-On
  is registered with. This is a unique identifier.
- `client-secret`: The secret string value used by Application Single Sign-On to
  verify your client. Keep this value secret.
- `issuer-uri`: The web address of the Application Single Sign-On `AuthServer` and
  the primary location that your `Workload` goes to when interacting with
  Application Single Sign-On.
- `authorization-grant-types`: A list of the desired OAuth 2 grant types.
- `client-authentication-method`: The method in which the client is authenticated
  when requesting an identity or access token.
- `scope`: A list of the desired scopes that your application's users have access
  to.

These credentials are mounted onto your `Workload`'s `Pod`(one or more) as
individual files at the following locations:

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

Following the earlier example, you can find the location of mounted credentials
on every `Pod` at:

```shell
/bindings/my-sso-client
```

Given these auto-generated values, your `Workload` can now load them at runtime
and bind to an Application Single Sign-On authorization server at startup time.
Reading the values from the file system is left to the implementer.

## <a id='trust-auth'></a> Trusting an authorization server

Your application makes a request to the authorization server. The authorization server
serves traffic using TLS. If your company uses non-public certificate authority (CA),
you must explicitly trust the authorization server or rather the certificate
authority. For more information, see
[Configure Workloads to trust a custom certificate authority](../service-operators/workload-trust-custom-ca.hbs.md).

## <a id='summary'></a> Summary

This concludes the tutorial explaining how to claim the client credentials for an
Application Single Sign-On authorization server and how to secure a workload.
