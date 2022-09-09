# Known Limitations

As of {{ vars.app-sso.version}}, the following are known product limitations to be aware of.

## Limited number of `ClientRegistrations` per `AuthServer`

The number of `ClientRegistration` for an `AuthServer` is limited at **~2,000**. This is a soft limitation, and
if you are attempting to apply more `ClientRegistration` resources than the limit, we cannot guarantee those clients
applied past the limit to be in working order. This is subject to change in future product versions.

## LetsEncrypt: domain name for Issuer URI limited to 64 characters maximum

If using LetsEncrypt to issue TLS certificates for an `AuthServer`, the domain name for the
Issuer URI (excluding the `http{s}` prefix) cannot exceed 64 characters in length. If exceeded, you may receive a
LetsEncrypt-specific error during Certificate issuance process. This limitation may be observed when your base domain
and subdomain joined together exceed the maximum limit.

**Workaround** - if your default Issuer URI is too long, utilize the `domain_template` field in AppSSO values yaml to
potentially shorten the domain.

For example, you may forgo the namespace in the Issuer URI like so:

{{{{raw}}}}

```yaml
domain_template: "{{.Name}}.{{.Domain}}"
```

{{{{/raw}}}}

---
> ⚠️ Be aware that by leaving out the namespace in your domain template, application routes may conflict if there
> are multiple `AuthServer`s of the same name but in different namespaces.
---
