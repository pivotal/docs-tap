# Ingress certificates

By default, Tanzu Application Platform installs and uses a self-signed CA for issuing TLS
certificates to components for the purpose of securing ingress communication.

The ingress issuer is a self-signed `cert-manager.io/v1/ClusterIssuer` and is provided by Tanzu
Application Platforms [cert-manager package](../cert-manager/about.hbs.md). Its default name is
`tap-ingress-selfsigned`.

To understand how each component is using the ingress issuer see [components](../components.hbs.md).

As of v1.4.0, not all components are using the ingress issuer yet. To get an overview of the components
which participate, see the [release notes](../release-notes.hbs.md).

## Replacing the default ingress issuer

Tanzu Application Platforms default ingress issuer can be replaced by any other `cert-manager.io/v1/ClusterIssuer`.

To replace the default ingress issuer, create a `ClusterIssuer` and set
`shared.ingress_issuer` to the name of the issuer. After the configuration is applied, components
eventually obtain certificates from the new issuer and serve them.

Tanzu Application Platforms[cert-manager package](../cert-manager/about.hbs.md) must be present for
the `ClusterIssuer` API to be available. That means you can only provide your own `ClusterIssuer`
after the initial installation. You can, however, refer your issuer in the initial
installation.

For example, to use [Let's Encrypts](https://letsencrypt.org) production API to
issue TLS certificates. First, update and apply; Tanzu Application Platforms installation values
such that `shared.ingress_issuer` denotes the bespoke issuer:

```yaml
#! my-tap-values.yaml
#! ...
shared:
  ingress_issuer: letsencrypt-production
#! ...
```

Then, create a `ClusterIssuer` for [Let's Encrypts](https://letsencrypt.org) production API:

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

`Let's Encrypts` production API has [rate limits](https://letsencrypt.org/docs/rate-limits/).

For more information about the possible configurations of `ClusterIssuer`
see [cert-manager documentation](https://cert-manager.io/docs/configuration/).

## Deactivating TLS for ingress

Although VMware discourages this, you can deactivate the ingress issuer by setting
`shared.ingress_issuer: ""`. As a result, components consider TLS for ingress to be deactivated.

## Overriding TLS for components

You can override TLS settings for each component. In your Tanzu Application Platform installation
values, set the component's values that you want, and they take precedence over `shared` values. See
[components](../components.hbs.md) to understand its settings for ingress and TLS.
