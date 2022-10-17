# AuthServer audit logs

AppSSO `AuthServer`s do the following:

- Handle user authentication
- Issue `id_token` and `access_token`

Each audit event contains the following:

- `ts` - date/time of the event
- `remoteIpAddress` - the IP of the user-authentication or if not attainable, the IP of the last proxy

## Authentication

`AuthServer` produce the following authentication events:

- `AUTHENTICATION_SUCCESS`
    - **Trigger** successful authentication
    - **Data recorded** Username, Provider ID, Provider Type (INTERNAL, OPENID, ...)
- `AUTHENTICATION_LOGOUT`
    - **Trigger** successful logout
    - **Data recorded** Username, Provider ID, Provider Type (INTERNAL, OPENID, ...)
- `AUTHENTICATION_FAILURE`
    - **Trigger** failed authentication using either `internalUnsafe` or `ldap` identity provider
    - **Data recorded** Username, Provider ID, Provider Type (INTERNAL or LDAP)
- `INVALID_IDENTITY_PROVIDER_CONFIGURATION`
    - **Trigger** some cases of failed authentication with an `openId` or `saml` identity provider
    - **Data recorded** Provider ID, Provider Type, error
    - **Note** usually followed by a human-readable help message, with `"logger": "appsso.help"`

## Token flows

`AuthServer` produce the following authorization_code and token events:

- `AUTHORIZATION_CODE_ISSUED`
    - **Trigger** `authorization_code` grant type, successful call to `/oauth2/authorize`
    - **Data recorded** Username, Provider ID, Provider Type, Client ID, Scopes requested, Redirect URI
- `AUTHORIZATION_CODE_REQUEST_REJECTED`
    - **Trigger** `authorization_code` grant type, unsuccessful call to `/oauth2/authorize`, for example invalid Client
      ID, invalid Redirect URI, ...
    - **Data recorded** Error, Error Code (ex: `invalid_scope`), Client ID, Scopes requested Redirect URI, Username (may
      be `anonymousUser`), Provider ID and Provider Type if available
- `TOKEN_ISSUED`
    - **Trigger** successful call to `/oauth2/token`
    - **Data recorded** Scopes, Client ID, Grant Type (`authorization_code` or `client_credentials`), Username
- `TOKEN_REQUEST_REJECTED`
    - **Trigger** unsuccessful call to `/oauth2/token`, for example invalid Client Secret
    - **Data recorded** Client ID, Scopes requested, Error
