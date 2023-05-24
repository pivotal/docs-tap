# Deployment details and configurations of Tanzu Application Platform Telemetry

Use this topic to learn the deployment details and configurations of your 
Tanzu Application Platform Telemetry (commonly known as TAP Telemetry).

## <a id='what-deploy'></a>What is deployed

The installation creates the following in your Kubernetes cluster:

- A deployment.
- A pod.
- A namespace `tap-telemetry`.
- A service account with read-write privileges named `informer`, and a corresponding secret for the service account. This secret is bound to a ClusterRole named `tap-telemetry-admin`.
* A Role `tap-telemetry-informer` to retrieve the deployment id, which is sent as sender id in heartbeat metrics.
* A RoleBinding `tap-telemetry-informer-admin` that binds the `informer` serviceaccount to the `tap-telemetry-informer` role.
* A ClusterRole `tap-telemetry-admin` that has access to each Tanzu Application Platform component to gather information from.
* A ClusterRoleBinding `tap-telemetry-informer-admin` that binds the `informer` servicceaccount to the `tap-telemetry-informer` cluster role.

## <a id='configuration'></a> Deployment configuration

`customer_entitlement_account_number` is the unique identifer to differentiate the data from your cluster and the data from other clusters. 
You can configure this property in your `tap-telemetry-values.yaml`:

```yaml
customer_entitlement_account_number: "12345"
```

It creates a config map named `vmware-telemetry-identifiers` in the `vmware-system-telemetry` namespace, which is used internally to log your information.

Repeat these steps for the Build, Run, and View Cluster. See [Install multicluster Tanzu Application Platform profiles](../multicluster/installing-multicluster.hbs.md) for more information.
