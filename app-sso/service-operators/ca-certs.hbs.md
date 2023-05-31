# CA certificates for AppSSO

This topic tells you how to configure CA certificates for `AuthServer` in 
Application Single Sign-On (commonly called AppSSO).

An `AuthServer` can trust custom CAs. You can establish either [for 
all `AuthServer`s](../platform-operators/configuration.md#ca) or for a single `AuthServer`. This is useful when either
your [identity provider](identity-providers.hbs.md) or [storage](storage.hbs.md) serves certificates from a custom CA.

In most cases, CA certificates are PEM-encoded and located in a `Secret` referred 
from `.spec.caCerts[].secretRef.name`. The controller considers all `Secret` entries matching `*.(crt|ca-bundle)`.
That means you can include multiple CA certificates in a single `Secret` or spread them across multiple `Secret`s.

After being created, an `AuthServer` reports the trusted, total custom CA certificates in its `.status.caCerts` together
with the location where it sources them from. This includes the CA certificates that are trusted by all
`AuthServer`s.

For example:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: my-ca
  namespace: services
stringData:
  my.ca-bundle: |
    This is My Company's custom CA. It's common name is "My CA".
    -----BEGIN CERTIFICATE-----
    ...
    -----END CERTIFICATE-----

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: login
  namespace: services
  # ...
spec:
  caCerts:
    - secretRef:
        name: my-ca
  # ...
status:
  caCerts:
    - cert:
        subject: CN=My CA,O=My Company,C=Happyland
      source:
        secretEntry: service/my-ca[my.ca-bundle]
    - cert:
        subject: CN=My other CA,O=My Company,C=Happyland
      source:
        secretEntry: appsso/appsso-controller[controller.yaml]
  # ...
```

CA certificates configured for all `AuthServer`s by using the package installation's `ca_cert_data` 
are sourced from `secretEntry: appsso/appsso-controller[controller.yaml]`. This denotes the AppSSO controller's
configuration `Secret`. 
