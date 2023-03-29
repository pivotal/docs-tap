# Public clients and CORS

A public client is a client application that does not require credentials to obtain tokens, such as single-page 
apps (SPAs) or mobile devices. Public clients rely on Proof Key for Code Exchange (PKCE) Authorization Code flow extension.

Follow these steps to configure an `AuthServer` and `ClientRegistration`s for use with public clients:

1. Specify allowed HTTP origin (one or more) by using the `AuthServer.spec.cors` API.

    The authorization server relaxes the same-origin policy for the specified domain (one or more), 
    enabling browser-based, single-page applications to interact with the designated authorization server. 
    For more information, see [CORS configuration](#cors-configuration).

1. Set `clientAuthenticationMethod` to `none` within `ClientRegistration` resource.

    Native applications and browser-based applications are considered public clients
    and must not rely on client credentials. Instead, PKCE must be used. 
    Setting `clientAuthenticationMethod: none` ensures client credentials are not used, 
    and makes PKCE mandatory for those clients. 
    For more information, see [Client authentication](#client-authentication).

## <a id="cors-configuration"></a> CORS configuration

A browser-based public client can interact with an `AuthServer` if the `AuthServer` 
has the public clients' origin (one or more) specified in `AuthServer.spec.cors`.

VMware recommends designating specific origins as follows:

```yaml
kind: AuthServer
# ...
spec:
  cors:
    allowOrigins:
    - "https://example.com"        # Specific domain.
    - "https://mydept.example.com" # Specific subdomain.
    - "https://*.example.com"      # Subdomain wildcard notation.
    - "https://*.apps.example.com" # Subdomain wildcard notation.
```

You can also designate that all origins are allowed as follows:

```yaml
kind: AuthServer
metadata:
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-cors: ""
spec:
  cors:
    allowAllOrigins: true
```

> **Caution** Do not allow all origins in production environments.

You must use the `allow-unsafe-cors` annotation when allowing all origin allowance. 
The `AuthServer` sends the `Access-Control-Allow-Origin: *` HTTP response header.

Requirements for allowed origin designations include:

- Only `allowOrigins` or `allowAllOrigins` is allowed to be set.
- When using `allowAllOrigins`, you must explicitly set the annotation `sso.apps.tanzu.vmware.com/allow-unsafe-cors: ""`.
  This is an acknowledgement that using `allowAllOrigins` is inherently unsafe.

## <a id="client-authentication"></a>Client authentication

When configuring a `ClientRegistration` for a public client, you must set your client authentication method to
`none` and ensure that your public client supports Authorization Code with PKCE. 
With PKCE, the client does not authenticate, but presents a code challenge and 
subsequent code verifier to establish trust with the authorization server.

To set Client Authentication Method to `none`, ensure your `ClientRegistration` resource defines the following:

```yaml
kind: ClientRegistration
# ...
spec:
  clientAuthenticationMethod: none
```

Public clients supporting Authorization Code with PKCE flow ensure that:

- On every OAuth `authorize` request, parameters `code_challenge` and `code_challenge_method` are
  provided. Only `code_challenge_method=S256` is supported.
- On every OAuth `token` request, parameter `code_verifier` is provided.
  Public clients do not provide a Client Secret because they are not tailored to
  retain any secrets in public view.

## <a id="refs"></a>References

- [Proof Key for Code Exchange (PKCE) specification](https://www.rfc-editor.org/rfc/rfc7636.html).
- [PKCE code challenge/verifier example](https://www.ietf.org/rfc/rfc7636.html#appendix-B).
- [Client types - OAuth 2.1 Draft 7 specification](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-v2-1-07#section-2.1).
