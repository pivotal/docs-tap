# Application Single Sign-On for Service Operators

The following topics tell you how to configure a fully operational authorization
server for Application Single Sign-On (commonly called AppSSO).

`AuthServer` represents the request for an OIDC authorization server. It
results in the deployment of an authorization server backed by Redis. A Redis
with mTLS is either automatically deployed for `AuthServer` or credentials to
[external storage](storage.hbs.md) can be provided. You can configure the
labels with which clients can select an `AuthServer`, the namespaces it allows
clients from, its issuer URI, its token signature keys, identity providers, and
further details for its deployment.

`ClusterWorkloadRegistrationClass` exposes an `AuthServer` as a ready-to-claim
service offering. Application operators can discover this offering and claim
credentials. The mechanisms for this are provided by [Services
Toolkit](../../../services-toolkit/about.hbs.md). This is the recommended way for
offering and consuming AppSSO.

If you just want to get started in a non-production environment,
`ClusterUnsafeTestLogin` is a zero-config API that produces an unsafe,
ready-to-claim AppSSO service offering. It is a higher-level alternative to the
combination of `AuthServer` and `ClusterWorkloadRegistrationClass`.

For a full explanation of the available APIs, refer to [the API
reference](../../reference/api/index.hbs.md).

The following sections outline the essential steps to configure a fully
operational, ready-to-claim AppSSO service offering:

- [Configure an unsafe test login](unsafe-test-login.hbs.md)
- [Annotations and labels](metadata.hbs.md)
- [Issuer URI and TLS](issuer-uri-and-tls.hbs.md)
- [TLS scenario guides](tls-scenario-guides.hbs.md)
- [CA certificates](ca-certs.hbs.md)
- [Configure workloads to trust a custom CA](workload-trust-custom-ca.hbs.md)
- [Identity providers](identity-providers.hbs.md)
- [Configure authorization](configure-authorization.hbs.md)
- [Public clients and CORS](cors.hbs.md)
- [Token settings](token-settings.hbs.md)
- [Token signatures](configure-token-signature.hbs.md)
- [Storage](storage.hbs.md)
- [AuthServer readiness](readiness.hbs.md)
- [Scale AuthServer](scale.hbs.md)
- [Curate an AppSSO service offering](curate-service-offering.hbs.md)
