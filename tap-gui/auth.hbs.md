# Set up authentication for Tanzu Developer Portal

Tanzu Developer Portal (formerly called Tanzu Application Platform GUI) extends the current Backstage
authentication plug-in so that you can see a login page based on the authentication providers
configured at installation. This feature is a work in progress.

Tanzu Developer Portal currently supports the following authentication providers:

- [Auth0](https://backstage.io/docs/auth/auth0/provider/)
- [Azure](https://backstage.io/docs/auth/microsoft/provider/)
- [Bitbucket](https://backstage.io/docs/auth/bitbucket/provider/)
- [GitHub](https://backstage.io/docs/auth/github/provider/)
- [GitLab](https://backstage.io/docs/auth/gitlab/provider/)
- [Google](https://backstage.io/docs/auth/google/provider/)
- [Okta](https://backstage.io/docs/auth/okta/provider/)
- [OneLogin](https://backstage.io/docs/auth/onelogin/provider/)

You can also configure a custom OpenID Connect (OIDC) provider.

## <a id='backstage-identity'></a> View your Backstage Identity

A Backstage identity is defined as a combination of:

- The user reference: each entity in the catalog is uniquely identified by the triplet of its
  [kind](https://backstage.io/docs/features/software-catalog/descriptor-format/#apiversion-and-kind-required)
- A [namespace](https://backstage.io/docs/features/software-catalog/descriptor-format/#namespace-optional)
- A [name](https://backstage.io/docs/features/software-catalog/descriptor-format/#name-required)

For example, the user Jane can be assigned to the user entity `user:default/jane` and an ownership
reference, which is used to determine what that user owns.
Jane (`user:default/jane`) might have the ownership references `user:default/jane`,
`group:default/team-a`, and `group:default/admins`. This would mean that Jane belongs to those groups
and, therefore, owns those references.

To view your current Backstage identity, in the **Settings** section of the left side navigation
pane click the **General** tab.

  ![Screenshot of a Tanzu Application Platform catalog displayed within Tanzu Developer Portal.](images/backstage-identity.png)

## <a id='config-auth-prov'></a> Configure an authentication provider

Configure a supported authentication provider or a custom OIDC provider:

- To configure a supported authentication provider, see the
  [Backstage authentication documentation](https://backstage.io/docs/auth/).

- To configure a custom OIDC provider, edit your `tap-values.yaml` file or your custom configuration
  file to include an OIDC authentication provider. Configure the OIDC provider with your OAuth App
  values. For example:

    ```yaml
    shared:
      ingress_domain: "INGRESS-DOMAIN"

    # ... any existing values

    tap_gui:
      # ... any other Tanzu Developer Portal values
      app_config:
        auth:
          environment: development
          session:
            secret: custom session secret
          providers:
            oidc:
              development:
                metadataUrl: AUTH-OIDC-METADATA-URL
                clientId: AUTH-OIDC-CLIENT-ID
                clientSecret: AUTH-OIDC-CLIENT-SECRET
                tokenSignedResponseAlg: AUTH-OIDC-TOKEN-SIGNED-RESPONSE-ALG # default='RS256'
                scope: AUTH-OIDC-SCOPE # default='openid profile email'
                prompt: auto # default=none (allowed values: auto, none, consent, login)
    ```

  Where `AUTH-OIDC-METADATA-URL` is a JSON file with generic OIDC provider configuration.
  It contains `authorizationUrl` and `tokenUrl`.
  Tanzu Developer Portal reads these values from `metadataUrl`,
  so you must not specify these values explicitly in the earlier authentication configuration.

  You must also the provide the redirect URI of the Tanzu Developer Portal instance to your
  identity provider.
  The redirect URI is sometimes called the redirect URL, the callback URL, or the callback URI.
  The redirect URI takes the following form:

  ```code
  SCHEME://tap-gui.INGRESS-DOMAIN/api/auth/oidc/handler/frame
  ```

  Where:

  - `SCHEME` is the URI scheme, most commonly `http` or `https`
  - `INGRESS-DOMAIN` is the host name you selected for your Tanzu Developer Portal instance

  When using `https` and `example.com` as examples for the two placeholders respectively, the
  redirect URI reads as follows:

  ```code
  https://tap-gui.example.com/api/auth/oidc/handler/frame
  ```

  For more information, see
  [this example](https://github.com/backstage/backstage/blob/e4ab91cf571277c636e3e112cd82069cdd6fca1f/app-config.yaml#L333-L347)
  in GitHub.

- (Optional) Configure offline access scope for the OIDC provider by adding the `scope` parameter
  `offline_access` to either `tap-values.yaml` or your custom configuration file. For example:

    ```yaml
    auth:
      providers:
        oidc:
          development:
            ... # auth configs
            scope: 'openid profile email offline_access'
    ```

  By default, `scope` is not configured to provide persistence to user login sessions, such as in
  the case of a page refresh. Not all identity providers support the `offline_access` scope.
  For more information, see your identity provider documentation.

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

For a provider to appear on the login page, ensure that it is properly configured under the
`auth.providers` section of your values file.
