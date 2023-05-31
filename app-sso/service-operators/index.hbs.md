# Application Single Sign-On for Service Operators

The following topics tell you how to configure a fully operational authorization 
server for Application Single Sign-On (commonly called AppSSO):

- [Annotations and labels](./metadata.md)
- [Issuer URI and TLS](./issuer-uri-and-tls.md)
- [TLS scenario guides](./tls-scenario-guides.hbs.md)
- [CA certificates](./ca-certs.md)
- [Configure Workloads to trust a custom CA](./workload-trust-custom-ca.hbs.md)
- [Identity providers](./identity-providers.md)
- [Configure authorization](./configure-authorization.md)
- [Public clients and CORS](./cors.md)
- [Token signatures](./token-signature.md)
- [Storage](./storage.hbs.md)
- [AuthServer readiness](./readiness.md)
- [Scale AuthServer](./scale.md)
- [AuthServer audit logs](./audit-logs.md)

`AuthServer` represents the request for an OIDC authorization server. It results in the deployment of an authorization
server backed by Redis over mutual TLS if no [external storage](storage.hbs.md) is explicitly configured.

You can configure the labels with which clients can select an `AuthServer`, the namespaces it allows clients from,
its issuer URI, its token signature keys, identity providers and further details for its deployment.

For the full available configuration, `spec` and `status` see [the API reference](../reference/api/authserver.hbs.md).
