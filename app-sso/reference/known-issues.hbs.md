# Known issues for Application Single Sign-On

This topic describes known limitations and workarounds related to working with 
Application Single Sign-On (commonly called AppSSO). For further troubleshooting 
guidance, see [Troubleshoot Application Single Sign-on](../how-to-guides/troubleshoot.hbs.md).

## <a id="unregistration"></a> Unregistration by deletion

You can only deregister an existing, ready `ClientRegistration` from its
selected `AuthServer` by deleting it. Breaking the match between the two
resources by updating either the labels of the `AuthServer` or the label
selector on the `ClientRegistration` does not deregister the client from the 
authorization server.

## <a id="clientregistrations"></a> Limited number of `ClientRegistrations` per `AuthServer`

The number of `ClientRegistration` for an `AuthServer` is limited to
around 2,000. This is a soft limitation. If you attempt to apply more
`ClientRegistration` resources than the limit, those clients applied past the 
limit will work. This is subject to change in future product versions.

## <a id="letsencrypt"></a> LetsEncrypt: domain name for Issuer URI limited to 64 characters maximum

If you use LetsEncrypt to issue TLS certificates for an `AuthServer`, the domain
name for the Issuer URI (excluding the `http{s}` prefix) cannot exceed 64
characters in length. If exceeded, you might receive a LetsEncrypt specific error
during the certificate issuance process. You might observe this limitation when your
base domain and subdomain joined together exceed the maximum limit.

If your default Issuer URI is too long, use the
`domain_template` field in Application Single Sign-On values YAML to shorten the
domain.

For example, you can forgo the namespace in the Issuer URI as follows:

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

## <a id='classclaim'></a> `ClassClaim` credential propagation time

It can take up to 60 to 120 seconds for the client credentials to propagate up into a
`ClassClaim`'s service binding secret.
