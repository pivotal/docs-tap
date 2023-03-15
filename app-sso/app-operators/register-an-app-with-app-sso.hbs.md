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

## <a id='workloads'></a> Workloads

This guide will walk you through steps necessary to secure your deployed `Workload` with AppSSO.

### Prerequisites

Before attempting to integrate your workload with AppSSO, please ensure that the following items are addressed:

- Tanzu Application Platform (TAP) `v{{ vars.tap_version }}` or above is available on your cluster.
- AppSSO package `v{{ vars.app-sso.version }}` or above is available on your cluster.

### Configuring a Workload with AppSSO


