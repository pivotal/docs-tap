# Configure your access tokens for Supply Chain Security Tools - Store

This topic describes how to configure your access tokens for Supply Chain Security Tools - Store.

The access token is a `Bearer` token used in the http request header
`Authorization`. For example, `Authorization: Bearer
eyJhbGciOiJSUzI1NiIsImtpZCI6IjhMV0...`.

Service accounts are required to have associated access tokens. Before
Kubernetes 1.24, service accounts generated access tokens automatically. Since
Kubernetes 1.24, a secret must be applied manually.

By default, Supply Chain Security Tools - Store includes a `read-write` service
account installed with an access token generated. This service account is
cluster-wide. If you want to create your own service accounts, see [Create
Service Accounts](create-service-account.hbs.md).

## Setting the Access Token

{{> 'partials/insight-set-access-token' }}

## Additional Resources

- [Retrieve access tokens](retrieve-access-tokens.hbs.md)
- [Create service accounts](create-service-account.hbs.md)
- [Create a service account with a custom cluster role](custom-role.hbs.md)
