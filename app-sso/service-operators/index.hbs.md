# Application Single Sign-On for Service Operators

`AuthServer` represents the request for an OIDC authorization server. It results in the deployment of an authorization
server backed by Redis over mTLS.

You can configure the labels with which clients can select an `AuthServer`, the namespaces it allows clients from,
its issuer URI, its token signature keys, identity providers and further details for its deployment.

For the full available configuration, `spec` and `status` see [the API reference](../crds/authserver.md).

The following sections outline the essential steps to configure a fully operational authorization server.

- [Annotations and labels](./metadata.md)
- [Issuer URI and TLS](./issuer-uri-and-tls.md)
- [Token signature](./token-signature.md)
- [Identity providers](./identity-providers.md)
- [AuthServer readiness](./readiness.md)
- [Scale AuthServer](./scale.md)
