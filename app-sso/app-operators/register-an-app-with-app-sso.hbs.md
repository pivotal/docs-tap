# Register a workload

## Topics

- [Client registration](#client-registration)
- [Workloads](#workloads)

## Client registration

Applications or Clients must register with AppSSO to allow users to sign in with single sign on within a Kubernetes cluster.
This registration results in the creation of a Kubernetes secret.

To do this, apply a [ClientRegistration](../crds/clientregistration.md) to the appropriate Kubernetes cluster.

To confirm that the `ClientRegistration` was successfully processed, check the status:

```shell
kubectl describe clientregistrations.sso.apps.tanzu.vmware.com <client-name>
```

It is also possible, but not recommended, to register clients statically while deploying AppSSO.

VMware recommends registering clients dynamically after deploying AppSSO. When registering a client 
statically, properties cannot be changed without triggering a rollout of AppSSO.

[Grant Types](grant-types.md)
