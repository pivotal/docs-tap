# Ingress certificates

By default, TAP installs and uses a self-signed CA for issuing TLS certificates to components for the purpose of
securing ingress communication.

This _ingress issuer_ is a self-signed `cert-manager.io/v1/ClusterIssuer` and is provided by
TAP's [cert-manager package](../cert-manager/about.hbs.md). Its default name is `tap-ingress-selfsigned`.

To understand how each component is using the ingress issuer refer to the [component in question](../components.hbs.md).

> ℹ️ As of 1.4.0, not all components are using the ingress issuer yet. To get an overview of the components
> which participate, refer to the [release notes](../release-notes.hbs.md).

## Replacing the default ingress issuer

TAP's default ingress issuer can be replaced by any other `cert-manager.io/v1/ClusterIssuer`.

To replace the default ingress issuer, create your own `ClusterIssuer` and set `shared.ingress_issuer` to the name of
your issuer. Once the configuration is applied, components will eventually obtain certificates from the new issuer and
serve them.

Keep in mind that TAP's [cert-manager package](../cert-manager/about.hbs.md) needs to be present for
the `ClusterIssuer` API to be available. That means you can only provide your own `ClusterIssuer` after the initial
installation. You can, however, already refer your issuer in the initial installation.

For example, let's say you wanted to use [_Let's Encrypt_](https://letsencrypt.org)'s production API to issue TLS
certificates. First, update and apply TAP's installation values such that `shared.ingress_issuer` denotes the bespoke
issuer:

```yaml
#! my-tap-values.yaml
#! ...
shared:
  ingress_issuer: letsencrypt-production
#! ...
```

Then, create a `ClusterIssuer` for [_Let's Encrypt_](https://letsencrypt.org)'s production API:

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
spec:
  acme:
    email: certificate-notices@my-company.com
    privateKeySecretRef:
      name: letsencrypt-production
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - http01:
          ingress:
            class: contour
```

> ⚠️ _Let's Encrypt_'s production API has [rate limits](https://letsencrypt.org/docs/rate-limits/).

> ℹ️ Learn about the possible configurations of `ClusterIssuer`
> from [cert-manager's documentation](https://cert-manager.io/docs/configuration/).

## Disabling TLS for ingress

Although it is not recommended, you can disable the ingress issuer by setting `shared.ingress_issuer: ""`. As a result,
components will consider TLS for ingress to be disabled.

## Overriding TLS for components

You can override TLS settings for each component. In your TAP installation values, set the component's values as
desired, and they will take precedence over `shared` values. Refer to the [component in question](../components.hbs.md)
to understand its settings for ingress and TLS.
