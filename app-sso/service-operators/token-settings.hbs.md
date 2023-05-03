# Token settings

## <a id='token-expiry-settings'></a> Token expiry

AppSSO supports optional configuration of token expiry settings per `AuthServer` resource.

The default token expiry settings are as follows:

| Token type     | Lifetime                |
|----------------|-------------------------|
| Access token   | **12 hours**            |
| Identity token | **12 hours**            |
| Refresh token  | **720 hours (30 days)** |

VMware recommends configuring a **shorter lifetime for an access token** (on the scale of hours), and a **longer lifetime for
refresh tokens** (on the scale of multiple days). Refresh tokens are used to acquire new access tokens, hence the reason
for their recommended longevity.

To override any of the above token expiries, configure the following in your `AuthServer` resource:

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

> **Note** `expiry` field follows [Go standard 'time' library duration](https://pkg.go.dev/time#Duration) constraints
> and does not support durations such as 'days', 'weeks', or any duration units above 'hours'.

### <a id='token-expiry-settings-constraints'></a> Constraints

The following are token expiry constraints:

- Expiry may not be a negative or zero value time duration.
- Refresh token expiry must not be the same or shorter time duration than an access token.
