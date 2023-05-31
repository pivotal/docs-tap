# Identity providers for AppSSO

This topic tells you how to configure Application Single Sign-On (commonly called AppSSO) 
to use external identity providers (commonly called IdPs).

An `AuthServer` does not manage users internally. Instead, users log in through external identity providers (IdPs).
Currently, `AuthServer` supports OpenID Connect providers, as well a list of "static" hard-coded users for development
purposes. `AuthServer` also has limited, experimental support for LDAP and SAML providers.

Identity providers are configured under `spec.identityProviders`, learn more
from [the API reference](../crds/authserver.md).

> ⚠️ Changes to `spec.identityProviders` take some time to be effective as the operator will roll out a new deployment
> of the authorization server.

End-users will be able to log in with these providers when they go to `{spec.issuerURI}` in their browser.

Learn how to configure identity providers for an `AuthServer`:

- [OpenID Connect providers](#openid-connect-providers)
- [LDAP (experimental)](#ldap-experimental)
- [SAML (experimental)](#saml-experimental)
- [Internal, static user](#internal-users)
- [Restrictions](#restrictions)

## OpenID Connect providers

To set up an OpenID Connect provider, provide the following information for your `AuthServer`:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: my-oidc-provider
      openID:
        issuerURI: https://openid.example.com
        clientID: my-client-abcdef
        clientSecretRef:
          name: my-openid-client-secret
        scopes:
          - "openid"
          - "other-scope"
        authorizationUri: https://example.com/oauth2/authorize
        tokenUri: https://example.com/oauth2/token
        jwksUri: https://example.com/oauth2/jwks
        claimMappings:
          roles: my-oidc-provider-groups
  # ...
---
apiVersion: v1
kind: Secret
metadata:
  name: my-openid-client-secret
  # ...
stringData:
  clientSecret: very-secr3t
```

Where:

- `openID` is the issuer identifier. You can define as many OpenID providers as you like. If the provider supports OpenID Connect Discovery, 
the value of `openID` is used to auto-configure the provider by using information from `https://openid.example.com/.well-known/openid-configuration`.
- The value of `issuerURI` must not contain `.well-known/openid-configuration` and must match 
the value of the `issuer` field. See OpenID Connect documentation at `https://openid.example.com/.well-known/openid-configuration` for more information.
    >**Note** You can retrieve the values of `issuerURI` and `clientID` when registering a client with the provider, which in most cases, is by using a web UI. 
- `scopes` is used in the authorization request. Its value must contain `"openid"`. 
Other common `OpenID` values include `"profile"` and `"email"`.
You can also run `curl -s "https://openid.example.com/.well-known/openid-configuration" | jq -r ".issuer"` to retrieve the correct `issuerURI` value.
- The value of `clientSecretRef` must be a `Secret` with the entry `clientSecret`.
- `authorizationUri` (optional) is the URI for performing an authorization request and obtaining an `authorization_code`.
- `tokenUri` (optional) is the URI for performing a token request and obtaining a token.
- `jwksUri` (optional) is the JSON Web Key Set (JWKS) endpoint for obtaining the JSON Web Keys to verify token signatures.
- `claimMappings` (optional) selects which claim in the `id_token` contains the `roles` of the user. 
`roles` is a non-standard OpenID Connect claim. When `ClientRegistrations` has a `roles` scope, 
it is used to populate the `roles` claim in the `id_token` issued by the `AuthServer`.
- `my-oidc-provider-groups` claim from the ID token issued by `my-oidc-provider` is mapped into the `roles` claim in tokens issued by AppSSO.

Verify the configuration by visiting the `AuthServer`'s issuer URI in your browser and select `my-oidc-provider`.

### Note for registering a client with the identity provider

The `AuthServer` will set up redirect URIs based on the provider name in the configuration. For example, for a provider
with `name: my-provider`, the redirect URI will be `{spec.issuerURI}/login/oauth2/code/my-provider`. The externally
accessible user URI for the `AuthServer`, including scheme and port is `spec.issuerURI`. If the `AuthServer` is
accessible on `https://appsso.company.example.com:1234/`, the redirect URI registered with the identity provider should
be `https://appsso.company.example.com:1234/login/oauth2/code/my-provider`.

## LDAP (experimental)

> *WARNING:* Support for LDAP providers is considered "experimental".

**At most one** `ldap` identity provider can be configured.

For example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  identityProviders:
    - name: ldap
      ldap:
        server:
          scheme: ldap
          host: my-ldap.com
          port: 389
          base: ""
        bind:
          dn: uid=binduser,ou=Users,o=5d03d6ac6eed091436a8d664,dc=jumpcloud,dc=com
          passwordRef:
            name: ldap-password
        user:
          searchFilter: uid={0}
          searchBase: ou=Users,o=5d03d6ac6eed091436a8d664,dc=jumpcloud,dc=com
        group:
          searchFilter: member={0}
          searchBase: ou=Users,o=5d03d6ac6eed091436a8d664,dc=jumpcloud,dc=com
          searchSubTree: true
          searchDepth: 10
          roleAttribute: cn
  # ...
---
apiVersion: v1
kind: Secret
metadata:
  name: ldap-password
  namespace: default
stringData:
  password: very-z3cret
```

It is essential that `ldap.bind.passwordRef` is a `Secret` with the entry `password`.

Verify the configuration by visiting the `AuthServer`'s issuer URI in your browser and select `my-oidc-provider`.

## SAML (experimental)

> *WARNING:* Support for SAML providers is considered "experimental".

For SAML providers only autoconfiguration through `metadataURI` is supported.

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
# ...
spec:
  - name: my-saml-provider
    saml:
      metadataURI: https://saml.example.com/sso/saml/metadata # required
      claimMappings: # optional
        # Map SAML attributes into claims in id_tokens issued by AppSSO. The key
        # on the left represents the claim, the value on the right the attribute.
        # For example:
        # The "saml-groups" attribute from the assertion issued by "my-saml-provider"
        # will be mapped into the "roles" claim in id_tokens issued by AppSSO
        roles: saml-groups
        givenName: FirstName
        familyName: LastName
        emailAddress: email
```

### Note for registering a client with the identity provider

The `AuthServer` will set up SSO and metadata URLs based on the provider name in the configuration.
For example, for a SAML provider with `name: my-provider`, the SSO URL will be
`{spec.issuerURI}/login/saml2/sso/my-provider`. The metadata URL will be
`{spec.issuerURI}/saml2/service-provider-metadata/my-provider`. `spec.issuerURI` is the externally
accessible issuer URI for an `AuthServer`, including scheme and port. If the `AuthServer` is accessible on
`https://appsso.company.example.com:1234/`, the SSO URL registered with the identity
provider should be `https://appsso.company.example.com:1234/login/saml2/sso/my-provider`.

## Internal users

> ⛔️ *WARNING:* `InternalUnsafe` considered **unsafe**, and **not** recommended for production!

During development, static users may be useful for testing purposes. **At most one** `internalUnsafe` identity
provider can be configured.

For example:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
  # ...
spec:
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: ernie
            password: "password" # plain text
            roles:
              - "silly"
          - username: bert
            password: "{bcrypt}$2a$10$201z9o/tHlocFsHFTo0plukh03ApBYe4dRiXcqeyRQH6CNNtS8jWK" # bcrypt-hashed "password"
            roles:
              - "grumpy"
  # ...
```

`InternalUnsafe` needs to be explicitly allowed by setting the
annotation `sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""`.

The passwords can be plain text or bcrypt-hashed. When bcrypt-hashing passwords they have to be prefixed with `{bcrypt}`
. Learn how to bcrypt-hash string below.

Verify the configuration by visiting the `AuthServer`'s issuer URI in your browser and logging in as `ernie/password`
or `bert/password`.

### Generating a bcrypt hash from a plain-text password

There are multiple options for generating bcrypt hashes:

1. Use an [online bcrypt generator](https://bcrypt-generator.com/)
2. On Unix platforms, use `htpasswd`. Note, you may need to install it, for example on Ubuntu by
   running `apt install apache2-utils`

  ```shell
  htpasswd -bnBC 12 "" your-password-here | tr -d ':\n'
  ```

## Restrictions

Each identity provider has a declared `name`. The following conditions apply:

- the names must be unique
- the names must not be blank
- the names must
  follow [Kubernetes' DNS Subdomain Names guidelines](https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#dns-subdomain-names)
    - contain no more than 253 characters
    - contain only lowercase alphanumeric characters, '-' or '.'
    - start with an alphanumeric character
    - end with an alphanumeric character
- the names may not start with `client` or `unknown`

There can be at most one of each `internalUnsafe` and `ldap`.
