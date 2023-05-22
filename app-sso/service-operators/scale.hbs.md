# Scale AuthServer

The number of authorization server replicas for an `AuthServer` can be specified under `spec.replicas`.

Furthermore, `AuthServer` implements the `scale` subresource. That means you can scale an `AuthServer`
with the existing tooling. For example:

```shell
kubectl scale authserver authserver-sample --replicas=3
```

The resource of the authorization server and Redis `Deployments` can be configured under `spec.resources`
and `spec.redisResources` respectively. See the [API reference](../crds/authserver.md) for details.
