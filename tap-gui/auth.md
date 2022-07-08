# Setting up a Tanzu Application Platform GUI authentication provider

Tanzu Application Platform GUI extends the current Backstage's authentication plug-in so that you
can see a login page based on the authentication providers configured at installation.
This feature is a work in progress. It currently supports the following authentication providers
as standard:

- [Auth0](https://backstage.io/docs/auth/auth0/provider)
- [Azure](https://backstage.io/docs/auth/microsoft/provider)
- [Bitbucket](https://backstage.io/docs/auth/bitbucket/provider)
- [GitHub](https://backstage.io/docs/auth/github/provider)
- [GitLab](https://backstage.io/docs/auth/gitlab/provider)
- [Google](https://backstage.io/docs/auth/google/provider)
- [Okta](https://backstage.io/docs/auth/okta/provider)
- [OneLogin](https://backstage.io/docs/auth/onelogin/provider)

## <a id='config-auth-prov'></a> Configure an authentication provider

Configure a supported authentication provider or a custom OpenID Connect (OIDC) provider:

- To configure a supported authentication provider, see the
[Backstage authentication documentation](https://backstage.io/docs/auth/).

- To configure a custom OpenID Connect (OIDC) provider, edit your `tap-values.yaml` or your custom
configuration file to include an OIDC authentication provider.
Configure the OIDC provider with your OAuth App values. For example:

    ```yaml
    shared:
      ingress_domain: "INGRESS-DOMAIN"

    tap_gui:
      service_type: ClusterIP
      app_config:
        app:
          baseUrl: http://tap-gui.INGRESS-DOMAIN
        catalog:
          locations:
            - type: url
              target: https://GIT-CATALOG-URL/catalog-info.yaml
        backend:
          baseUrl: http://tap-gui.INGRESS-DOMAIN
          cors:
            origin: http://tap-gui.INGRESS-DOMAIN
    #Existing values file above
        auth:
          environment: development
          session:
            secret: custom session secret
          providers:
            oidc:
              development:
                metadataUrl: ${AUTH_OIDC_METADATA_URL}
                clientId: ${AUTH_OIDC_CLIENT_ID}
                clientSecret: ${AUTH_OIDC_CLIENT_SECRET}
                tokenSignedResponseAlg: ${AUTH_OIDC_TOKEN_SIGNED_RESPONSE_ALG} # default='RS256'
                scope: ${AUTH_OIDC_SCOPE} # default='openid profile email'
                prompt: auto # default=none (allowed values: auto, none, consent, login)
    ```

    Where `metadataUrl` is a JSON file with generic OIDC provider configuration.
    It contains `authorizationUrl` and `tokenUrl`.
    These values are read from the `metadataUrl` file by Tanzu Application Platform GUI,
    so you must not specify these values explicitly in the earlier authentication configuration.

    For more information, see
    [this example](https://github.com/backstage/backstage/blob/e4ab91cf571277c636e3e112cd82069cdd6fca1f/app-config.yaml#L333-L347)
    in GitHub.

## <a id='allow-guest-access'></a> (Optional) Allow guest access

Enable guest access with other providers by adding the following flag under your authentication
configuration:

```yaml
auth:
  allowGuestAccess: true
```

## <a id='customize-login'></a> (Optional) Customize the login page

Change the card's title or description for a specific provider with the following configuration:

```yaml
auth:
  environment: development
  providers:
    ... # auth providers config
  loginPage:
    github:
      title: Github Login
      message: Enter with your GitHub account
```

For a provider to appear on the login page, ensure it is properly configured under the `auth.providers`
section of your values file.
