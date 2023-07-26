# Secure Ingress certificates in Tanzu Application Platform

This topic tells you about securing ingress communication in Tanzu Application Platform (commonly known as TAP).

By default, Tanzu Application Platform installs and uses a self-signed CA for issuing TLS
certificates to components for the purpose of securing ingress communication.

The ingress issuer is a self-signed `cert-manager.io/v1/ClusterIssuer` and is provided by Tanzu
Application Platform's [cert-manager package](../cert-manager/about.hbs.md). Its default name is
`tap-ingress-selfsigned`.

To understand how each component uses the ingress issuer, see [Component documentation](../components.hbs.md).

As of v1.4.0, not all components use the ingress issuer. For an overview of the components
that participate, see the [Release notes](../release-notes.hbs.md).

## <a id="replace-ingress-issuer"></a>Replacing the default ingress issuer

Tanzu Application Platform's default ingress issuer can be replaced by any other `cert-manager.io/v1/ClusterIssuer`.

To replace the default ingress issuer, create a `ClusterIssuer` and set
`shared.ingress_issuer` to the name of the issuer. After the configuration is applied, components
eventually obtain certificates from the new issuer and serve them.

Tanzu Application Platform's[cert-manager package](../cert-manager/about.hbs.md) must be present for
the `ClusterIssuer` API to be available. This means you can only provide your own `ClusterIssuer`
after the initial installation. You can, however, reference your issuer in the initial
installation.

For example, to use [Let's Encrypts](https://letsencrypt.org) production API to
issue TLS certificates:

1. Update and apply Tanzu Application Platform's installation values
such that `shared.ingress_issuer` denotes the bespoke issuer:

    ```yaml
    #! my-tap-values.yaml
    #! ...
    shared:
      ingress_issuer: letsencrypt-production
    #! ...
    ```

1. Create a `ClusterIssuer` for [Let's Encrypts](https://letsencrypt.org) production API:

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

For more information about the possible configurations of `ClusterIssuer`,
see [cert-manager documentation](https://cert-manager.io/docs/configuration/).

## Deactivating TLS for ingress

Although VMware discourages this, you can deactivate the ingress issuer by setting
`shared.ingress_issuer: ""`. As a result, components consider TLS for ingress to be deactivated.

## Overriding TLS for components

You can override TLS settings for each component. In your Tanzu Application Platform installation
values, set the component's values that you want, and they take precedence over `shared` values. See
[components](../components.hbs.md) to understand its settings for ingress and TLS.
