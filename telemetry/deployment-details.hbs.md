# Deployment details and configuration

## <a id='what-deploy'></a>What is deployed

The installation creates the following in your Kubernetes cluster:

* A deployment
* A Pod
* A namespace called `tap-telemetry`.
* A service account with read-write privileges named `informer`, and a corresponding secret for the service account. It's bound to a ClusterRole named `tap-telemetry-admin`.
* A Role named `tap-telemetry-informer` that is used to get the deployment id to send it as sender id in heartbeat metrics
* A RoleBinding named `tap-telemetry-informer-admin` that binds the `informer` serviceaccount to the `tap-telemetry-informer` role
* A ClusterRole named `tap-telemetry-admin` that has access to each Tap component to gather information from.
* A ClusterRoleBinding named `tap-telemetry-informer-admin` that binds the `informer` servicceaccount to the `tap-telemetry-informer` cluster role

## <a id='configuration'></a> Deployment configuration

If you're deploying with Tanzu Application Platform profiles, in `tap-values.yaml`, put:

```yaml
tap_telemetry:
  customer_entitlement_account_number: "12345"
```

Repeat these steps for the Build, Run, and View Cluster documentation
* https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-multicluster-installing-multicluster.html

See more information about these values below.

### <a id='user-ean'></a>Customer Entitlement Number

The `customer_entitlement_account_number` is set to differentiate the data from your cluster and everyone else. Configure this property in your `tap-telemetry-values.yaml`:

```yaml
customer_entitlement_account_number: "12345"
```

This will create a config map named `vmware-telemetry-identifiers` in the `vmware-system-telemetry` namespace which will be used internally to properly log your information.

