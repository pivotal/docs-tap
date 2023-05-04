# Token settings

## <a id='token-expiry-settings'></a> Token expiry

AppSSO supports optional configuration of token expiry settings per `AuthServer` resource.

The default token expiry settings are as follows:

| Token type     | Lifetime                |
|----------------|-------------------------|
| Access token   | **12 hours**            |
| Identity token | **12 hours**            |
| Refresh token  | **720 hours (30 days)** |

VMware recommends setting a shorter lifetime for access tokens, typically measured in hours, 
and a longer lifetime for refresh tokens, typically measured in days. 
Refresh tokens acquire new access tokens, so they have a longer lifespan.

To override the token expiries, configure the following in your `AuthServer` resource:

```yaml
kind: AuthServer
# ...
spec:
  token:
    accessToken:
      expiry: "12h"
    idToken:
      expiry: "12h"
    refreshToken:
      expiry: "720h"
```

`expiry` field examples:

| Type    | Example            |
|---------|--------------------|
| Seconds | `10s` = 10 seconds |
| Minutes | `10m` = 10 minutes |
| Hours   | `10h` = 10 hours   |

> **Note** `expiry` field adheres to the duration constraints of the Go standard time library 
> and does not support durations in units beyond hours, such as days or weeks.
> For more information, see [Go documentation](https://pkg.go.dev/time#Duration).

### <a id='token-expiry-settings-constraints'></a> Constraints

The token expiry constraints are as follows:

- The duration of the expiry cannot be negative or zero.
- The refresh token's expiration time cannot be the same as or shorter than that of the access token.
