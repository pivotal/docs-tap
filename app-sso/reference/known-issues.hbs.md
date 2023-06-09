# Known Issues

As of {{ vars.app-sso.version}}, the following are known product limitations to
be aware of.

## Limited number of `ClientRegistrations` per `AuthServer`

The number of `ClientRegistration` for an `AuthServer` is limited at
**~2,000**. This is a soft limitation, and if you are attempting to apply more
`ClientRegistration` resources than the limit, we cannot guarantee those
clients applied past the limit to be in working order. This is subject to
change in future product versions.

## LetsEncrypt: domain name for Issuer URI limited to 64 characters maximum

If using LetsEncrypt to issue TLS certificates for an `AuthServer`, the domain
name for the Issuer URI (excluding the `http{s}` prefix) cannot exceed 64
characters in length. If exceeded, you may receive a LetsEncrypt-specific error
during Certificate issuance process. This limitation may be observed when your
base domain and subdomain joined together exceed the maximum limit.

**Workaround** - if your default Issuer URI is too long, utilize the
`domain_template` field in AppSSO values yaml to potentially shorten the
domain.

For example, you may forgo the namespace in the Issuer URI like so:

```yaml
domain_template: "\{{.Name}}.\{{.Domain}}"
```

> **Caution** By leaving out the namespace in your domain template, application
> routes might conflict if there are multiple `AuthServer`s with the same name
> but in different namespaces.

## <a id='boot3-clientreg'></a> Spring Boot 3 based `Workload`s and `ClientRegistration` resources

If you run a `Workload` based on Spring Boot 3 or use Spring Security OAuth2
Client 3 library in conjunction with `ResourceClaim`s, you must configure your
`ClientRegistration` resource to use either of the following client
authentication methods: 

- `client_secret_basic` (default)
- `client_secret_post`

The existing `post` and `basic` values do not work with Spring Boot 3 based
`Workloads` with Spring Cloud Bindings and are deprecated.

## `ClassClaim` credential propagation time

It can take up `~60-120s` for client credentials to propagate up into a
`ClassClaim`'s service binding secret.
