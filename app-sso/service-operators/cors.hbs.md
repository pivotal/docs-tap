# Public clients and CORS

>**Note** A _public client_ is a client application that does not require credentials to obtain tokens, such as single-page
> apps (SPAs) or mobile devices. Public clients rely on Proof Key for Code Exchange (PKCE) Authorization Code flow extension.

To configure an `AuthServer` and `ClientRegistration`s for use with public clients (single-page apps, mobile devices),
the following steps are involved:

- [**Allowed HTTP origin(s) must be explicitly specified via `AuthServer.spec.cors` API**](#cors-configuration) - when specified, the
  authorization server will relax the same-origin policy for the specified domain(s), enabling browser-based, single-page applications to
  interact with the designated authorization server.
- [**Client authentication method is set to `none` within `ClientRegistration` resource**](#client-authentication) -
  native applications and browser-based applications are considered public clients
  and should not rely on client credentials. Instead, PKCE should be used. Setting `clientAuthenticationMethod: none`
  ensures client credentials are not used, and makes PKCE mandatory for those clients.

## <a id="cors-configuration"></a> CORS configuration

A browser-based (public) client will be able to interact with an `AuthServer` if the `AuthServer` has the public clients' origin(s)
specified within `AuthServer.spec.cors`.

_Example_: designating specific origins (recommended approach)

```yaml
kind: AuthServer
# ...
spec:
  cors:
    allowOrigins:
    - "https://example.com"        # Specific domain
    - "https://mydept.example.com" # Specific subdomain
    - "https://*.example.com"      # Subdomain wildcard notation
    - "https://*.apps.example.com" # Subdomain wildcard notation
```

_Example_: designating that all origins are allowed. You must use `allow-unsafe-cors` annotation when defining all 
origin allowance. The `AuthServer` will send the `Access-Control-Allow-Origin: *` HTTP response header.

> **Caution** Allowing all origins should not be used in production environments.

```yaml
kind: AuthServer
metadata:
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-cors: ""
spec:
  cors:
    allowAllOrigins: true
```

**Requirements for allowed origin designations**

- Only one of `allowOrigins` or `allowAllOrigins` can be set.
- When using `allowAllOrigins`, you **must** explicitly set
  annotation `sso.apps.tanzu.vmware.com/allow-unsafe-cors: ""`. This is an acknowledgement that using `allowAllOrigins`
  will be used, but is inherently unsafe.

## <a id="client-authentication"></a>Client authentication

When configuring a `ClientRegistration` for a public client, you must set your client authentication method to
`none` and ensure that your public client supports Authorization Code with PKCE. With PKCE,
the client does not authenticate, but presents a code challenge and subsequent code verifier to establish trust with 
the authorization server.

To set Client Authentication Method to `none`, ensure your `ClientRegistration` resource defines the following:

```yaml
kind: ClientRegistration
# ...
spec:
  clientAuthenticationMethod: none
```

Public clients that support Authorization Code with PKCE flow ensure that:

- On every OAuth `authorize` request, parameters `code_challenge` and `code_challenge_method` are
  provided. Only `code_challenge_method=S256` is supported.
- On every OAuth `token` request, parameter `code_verifier` is provided. Public clients do not provide a Client Secret
  because they are not tailored to retain any secrets in public view.

## References

- [Proof Key for Code Exchange (PKCE) specification](https://www.rfc-editor.org/rfc/rfc7636.html)
- [PKCE code challenge/verifier example](https://www.ietf.org/rfc/rfc7636.html#appendix-B)
- [Client types - OAuth 2.1 Draft 7 specification](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-v2-1-07#section-2.1)
