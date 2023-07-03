# Overview of enabling TLS for Tanzu Developer Portal

Many users want inbound traffic to Tanzu Developer Portal
(formerly called Tanzu Application Platform GUI) to be properly encrypted.
These topics tell you how to enable TLS encryption either with an existing certificate or by using
the included cert-manager instance.

## <a id="concepts"></a> Concepts

The two key concepts are certificate delegation and the relationship between cert-manager,
certificates, and ClusterIssuers.

### <a id="cert-delegation"></a> Certificate delegation

Tanzu Developer Portal uses the established shared Contour ingress for TLS termination.

This enables you to store the certificate in a Kubernetes `secret` and then pass that `secret` and
`namespace` to the `httpProxy` that was created during installation.
To do this, see
[Configuring a TLS certificate by using an existing certificate](enable-tls-existing-cert.hbs.md).

![TLS diagram showing the relationships between Tanzu Developer Portal, the certificate, and Contour Shared Ingress.](images/TAP-GUI-TLS.png)

### <a id="cert-mngr-certs-clustiss"></a> cert-manager, certificates, and ClusterIssuers

Tanzu Developer Portal can also use the `cert-manager` package that is installed when
the profile was installed.

This tool allows cert-manager to automatically acquire a certificate from a `clusterIssuer` entity.

This external entity can be an external certificate authority, such as Let's Encrypt, or a
self-signed certificate.

![TLS diagram showing the relationships between Tanzu Developer Portal, the cert dash manager, and Contour Shared Ingress.](images/TAP-GUI-TLS-CERT.png)

## <a id="guides"></a> Guides

The following topics describe different ways to configure TLS:

- [Configuring a TLS certificate by using an existing certificate](enable-tls-existing-cert.hbs.md)
- [Configuring a TLS certificate by using a self-signed certificate](enable-self-signed-cert.hbs.md)
- [Configuring a TLS certificate by using cert-manager and a ClusterIssuer](cert-mngr-ext-clusterissuer.hbs.md)
