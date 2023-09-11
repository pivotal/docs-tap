# Session settings for AppSSO

This topic tells you how to configure the session expiry settings for Application Single
Sign-On (commonly called AppSSO).

## <a id='session-expiry-settings'></a> Session expiry

AppSSO allows you to optionally configure the session expiry settings in your
`AuthServer` resource.

The default expiry time for an AppSSO session is 15 minutes, according to the
[STIG guidelines](https://www.stigviewer.com/stig/application_security_and_development/).

To override the session expiry settings, configure the following in your `AuthServer`
resource:

```yaml
kind: AuthServer
# ...
spec:
  session:
    expiry: "30m"
```

`expiry` field examples:

| Type    | Example | Definition |
|---------|---------|------------|
| Minutes | `10m`   | 10 minutes |
| Hours   | `5h`    | 5 hours    |

> **Note** The `expiry` field adheres to the duration constraints of the Go standard time library
> and does not support durations in units beyond hours, such as days or weeks.
> For more information, see the [Go documentation](https://pkg.go.dev/time#Duration).

### <a id='constraints'></a> Constraints

The session expiry constraints are as follows:

- The duration of the `expiry` field cannot be negative or zero.
- The duration must be at least 1 minute.
