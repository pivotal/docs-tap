# Troubleshooting

## Why is my AuthServer not working?

Generally, `AuthServer.status` is designed to provide you with helpful feedback to debug a faulty `AuthServer`.

## Find all AuthServer-related Kubernetes resources

All `AuthServer` components can be identified
with [Kubernetes common labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels)
, e.g.:

```yaml
app.kubernetes.io/part-of: my-authserver
```

## Logs of all AuthServers

With [stern](https://github.com/stern/stern) you can tail the logs of all AppSSO managed `Pods` inside your cluster
with:

```shell
stern --all-namespaces --selector=app.kubernetes.io/managed-by=sso.apps.tanzu.vmware.com
```

## Change propagation

When applying changes to an `AuthServer`, keep in mind that changes to issuer URI, IDP, server and logging configuration
take a moment to be effective as the operator will roll out the authorization server `Deployment`.

## My Service is not selecting the authorization server's Deployment

If you are deploying your `Service` with [kapp](https://carvel.dev/kapp/docs/latest/) make sure to set the
annotation `kapp.k14s.io/disable-default-label-scoping-rules: ""` to avoid that kapp amends `Service.spec.selector`.

## Redirect URIs are redirecting to http instead of https with a non-internal identity provider

Follow [this workaround](../known-issues/cidr-ranges.md), adding IP ranges for the `AuthServer` to trust.

## Common issues

### Misconfigured `clientSecret`

#### Problem:
- When attempting to sign in, you see `This commonly happens due to an incorrect [client_secret].` It might be because the client secret of an identity provider is misconfigured.

#### Solution:
Validate the `spec.OpenId.clientSecretRef`.
