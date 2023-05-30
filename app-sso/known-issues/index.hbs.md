# Known Issues

Application Single Sign-On (commonly called AppSSO) has the following known issues.

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
domain_template: "\{{.Name}}.\{{.Domain}}"
```

{{{{/raw}}}}

---
> ⚠️ Be aware that by leaving out the namespace in your domain template, application routes may conflict if there
> are multiple `AuthServer`s of the same name but in different namespaces.
---

## <a id="cidr-ranges"></a> Redirect URIs change to http instead of https

**Description**

AppSSO makes requests to external identity providers with `http` rather than `https`.

The external identity provider (IDP) informs the user that there is an issue with the `redirect_uri` upon a redirect from
the AppSSO auth server to the IDP. The payload of the request to the IDP has a `redirect_uri` of AppSSO Issuer URI that
has http protocol prefix, while the configuration on the external IDP side has it registered as https protocol prefixed.

The underlying issue is that the default Classless Inter-Domain Routing (CIDR) for pod-to-pod traffic is not a default
internal network trusted by `AppSSO`.

**Solution**

Add these CIDR ranges to the `AuthServer.spec` (this is a sample range):

 ```yaml
  server: |
    tomcat:
      remoteip:
        internal-proxies: "100\\.9[6-9]\\.\\d{1,3}\\.\\d{1,3}|\
          100\\.1[01]\\d\\.\\d{1,3}\\.\\d{1,3}|\
          100\\.12[0-7]\\.\\d{1,3}\\.\\d{1,3}"
 ```
