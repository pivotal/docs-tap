# Configure Tanzu Supply Chain

{{> 'partials/supply-chain/beta-banner' }}

This topic tells you what to configure to complete your Tanzu Supply Chain installation.

After you have installed Tanzu Supply Chain, there are several steps you must complete to ensure you have a functioning installation.

## Namespace Provisioner

The recommended way of configuring service accounts and permissions on Tanzu Application Platform is
to use the Namespace Provisioner.

```shell
❯ kubectl create namespace my-supply-chains
❯ kubectl label namespaces my-supply-chains apps.tanzu.vmware.com/tap-ns=""
```

If Namespace Provisioner is not enabled in your environment, add the following section in `tap-values.yaml` to enable it:

```yaml
namespace_provisioner:
  controller: true
  default_parameters:
    supply_chain_service_account:
      secrets:
        # List your git & docker secrets here
        - git-secret
        - my-oci-store-credentials # this secret is described below
```

## OCI Store

Supply Chains persist data between stages by reading and writing to an OCI repository.  The location
of the OCI repository is configured by a Kubernetes Secret named `oci-store` that exists within
the developer namespace.

An example of the structure of this secret is shown below:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: oci-store
  namespace: <developer-namespace>
stringData:
  repository: my-oci-store # the path in the repository to store intermediate artifacts
  server: gcr.io           # the server url of the oci repository
type: Opaque
```

Access to this repository is controlled by a tekton annotated secret:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-oci-store-credentials
  annotations:
    tekton.dev/docker-0: gcr.io/my-oci-store # the server/repository of the repository to store intermediate artifacts
stringData:
  .dockerconfigjson: '<secret>'
type: kubernetes.io/dockerconfigjson
```

## Additional Permissions for Buildpacks Cluster Builders

If you are planning to use the `buildpack-build` component to create images using TBS configured with `ClusterBuilders`
then there are some additional permissions that need to be added that can't yet be configured by Namespace Provisioner.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: buildpack-build-workload-cluster-role-my-supply-chains
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: buildpack-build-workload-cluster-role
subjects:
- kind: ServiceAccount
  name: default
  namespace: my-supply-chains
```
