# Secure a workload with Application Single Sign-On

This tutorial tells you how to secure a `Workload` running on Tanzu Application 
Platform with Application Single Sign-On (commonly called AppSSO).

For specific stack implementations, see [Secure a single-page app workload](../../how-to-guides/secure-spa-workload.hbs.md) and [Secure a Spring Boot workload](../../how-to-guides/secure-spring-boot-workload.hbs.md).

The [Getting Started](../../how-to-guides/get-started/index.hbs.md) section 
explains how to obtain OAuth2 client credentials for an authorization server by 
claiming them from an Application Single Sign-On service offering.
You can enable this by running the `tanzu service class-claims create` command or 
by using a `ClassClaim` resource. In either case, you can customize your OAuth2 client
settings by providing parameters within your claim. To secure your `Workload`, 
you must provide the appropriate parameters relevant to the given situation.

The following sections elaborate on each parameter in details and guide the process 
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
to which you application's end-users are redirected to after the authentication. 
Incorrect redirect URIs often cause errors for clients and are the most common 
source of such issues. When redirect URIs are not configured accurately, your 
application encounter errors and can not perform OAuth2 flows.

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

Behind the scenes your redirect paths are templated into the full redirect URIs
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

In OAuth2 parlance a grant type is the way your application obtains token from
authorization server. There are different grant types. Some of them allow your
application to act on behalf of an end-users others don't.

The `authorizationGrantTypes` parameter denotes all the grant types your
application will be able to make use of:

```yaml
spec:
  parameters:
    authorizationGrantTypes:
      - client_credentials
      - authorization_code
      - refresh_token
```

AppSSO supports the following OAuth2 grant types:

- Authorization Code: `authorization_code`

    This grant type is used by applications seeking to authenticate and
    authorize end-users. An `AuthServer` issues identity and access tokens to
    applications to identify end users' identity and the level of access they
    have to protected resources.

- Client Credentials: `client_credentials`

    This grant type is used by applications seeking to communicate directly to
    other protected applications, by using a client identifier and client
    secret, for example, service-to-service communication. An `AuthServer`
    issues access tokens that define the level of access that the requesting
    service has to the protected service they seek to communicate with.

    > **Note** Use cases for grant types `authorization_code` and
    > `client_credentials` are typically different, so VMware recommends
    > creating separate client registrations for each grant type.

- Refresh Token: `refresh_token`

    This grant type is used by applications seeking to obtain access tokens. If
    `refresh_token` grant type is included, on every access token issue by an
    `AuthServer`, a refresh token is included. You can use the refresh token to
    fetch new access tokens before older ones expire to continue accessing
    protected resources.

### <a id='client-auth-method'></a> Client authentication method

The client authentication method defines how your application presents its credentials to the authorization server.

```yaml
spec:
  parameters:
    clientAuthenticationMethod: client_secret_basic
```

There are three different options:

- `client_secret_basic`(default): Send client credentials using the HTTP
  "Basic" authentication scheme. This is the recommended method for
  authenticating server-based applications such as Spring Boot or .NET Core
  apps (confidential clients).
- `client_secret_post`: Send client credentials in the body of an HTTP POST
  request.
- `none`: Don't send client credentials. This is for browser-based single-page
  apps.

### <a id='scopes'></a> `scopes`

The `scopes` field defines the OAuth2 scopes your application will request,
including standard OpenID claims. 

```yaml
spec:
  parameters:
    scopes:
      - name: openid # standard OpenID scope, containing claims "sub" (subject), "aud" (audience), etc.
      - name: email # standard OpenID scope, containing claims "email" and "email_verified"
      - name: profile # standard OpenID scope, containing claims "name", "given_name", "family_name", etc.
      - name: roles # AppSSO special scope, requesting user roles/groups be populated in "roles" claim.
      - name: coffee.make # custom authorization scope
        description: bestows the ultimate power # with a custom description
```

To activate issuance of users identity tokens and authentication, you must
include the `openid` scope.

To activate fetching of user roles or groups, you must include the `roles`
scope.

### <a id='user-consent'></a> `requireUserConsent`

The `requireUserConsent` field allows for toggling scopes approval by end-users. 

```yaml
spec:
  parameters:
    requireUserConsent: true
```

If activated, end-users are prompted to consent to or reject scopes that the
client requests on behalf of them. If deactivated, all scopes that the client
requests are auto-approved or consented to without prompt.

## <a id='behind-scenes'></a> Behind the scenes

When you create a `ClassClaim` for an AppSSO service a few resources are being
created behind the scenes. Usually, you won't have to care, but when things go
wrong it can be helpful for debugging.

1. You create a `ClassClaim` for an AppSSO service with your parameters.
1. An `XWorkloadRegistration` with your parameters will be created in the same
   namespace.
1. A `WorkloadRegistration` with your parameters will be created in the same
   namespace. The `WorkloadRegistration` will template your redirect URIs.
1. A `ClientRegistration` with your parameters and the templated redirect URIs
   will be created in the same namespace.
1. The `ClientRegistration` receives client credentials and passes them up, all
   the way to your `ClassClaim`.
 
## <a id='load-credentials'></a> Loading client credentials into a `Workload`

Now that you have a client credentials for our application, you can reference
the `ClassClaim` from your `Workload`.

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
  serviceClaims:
    - name: my-sso-client # Must match the name of the referenced `ClassClaim`.
      ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ClassClaim
        name: my-sso-claim
  #! ...
```

Alternatively, you can refer to your `ClassClaim` when deploying your workload
with the `tanzu` CLI:

```shell
tanzu apps workload create my-workload \
  --service-ref "my-sso-client=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:my-sso-claim" \
  # ...
```

>**Important** The service ref name must match the name of the referenced
>`ClassClaim`.

Thanks to service bindings, your credentials will now be provided to your
`Workload`'s `Pod` (one or more) by mounting a volume containing your client
credentials.

The credentials provided by the claim are:

- `client-id`: the identifier of your `Workload` that AppSSO is registered
  with. This is a unique identifier.
- `client-secret`: secret string value used by AppSSO to verify your client.
  Keep this value secret.
- `issuer-uri`: web address of AppSSO `AuthServer` and the primary location
  that your `Workload` navigates to when interacting with AppSSO.
- `authorization-grant-types`: list of the desired OAuth 2 grant types.
- `client-authentication-method`: method in which the client is authenticated
  when requesting an identity or access token.
- `scope`: list of the desired scopes that your application's users have access
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
and bind to an AppSSO authorization server at start-up time. Reading the values
from the file system is left to the implementer.

## <a id='trust-auth'></a> Trusting an authorization server

Your application will make request to the authorization server. The
authorization server will serving traffic using TLS. It is possible that your
company is using non-public certificate authority (CA). In that case you will
have to explicitly trust the authorization server or rather the certificate
authority. See 
[Configure Workloads to trust a custom certificate authority](../../tutorials/service-operators/workload-trust-custom-ca.hbs.md).

## <a id='summary'></a> Summary

Now you know how to claim client credentials for an AppSSO authorization server
and how to secure a workload.
