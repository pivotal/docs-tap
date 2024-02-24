## Post Install Configuration

{{> 'partials/supply-chain/beta-banner' }}

Once you have Tanzu Supply Chain installed, there are a number of step you'll need to complete to ensure 
you have a functioning installation. The recommended way of configuring service accounts/permissions on TAP is to use the namespace-provisioner.

## Things to configure

* OCI Store Configuration
  * Supply Chains persist data between stages by reading and writing to an OCI repository.  The location of the OCI repository is configured by a Kubernetes Secret named `oci-store` that exists within the developer namespace. 
  * Access to this repository is controlled by a tekton annotated secret which can have any name as long as it has the `tekton.dev/docker-0` annotation pointing to the OCI repository.
* Permissions for Buildpacks Cluster Builders for buildpack-build component
  * If you are planning to use the `buildpack-build` component to create images using TBS configured with `ClusterBuilders` then there are some additional permissions that need to be added.

## Setup using Namespace Provisioner
Recommended way is to use the Namespace provisioner for the entire setup:

**Step 1**: is to create a `Secret` in the `tap-install` namespace that has the location and credentials for the `oci-store` as follows:

```
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: supply-chain-oci-store-credentials
  namespace: tap-install
type: Opaque
stringData:
  ocistore.yaml: |
    tanzusupplychain:
      ocistore:
        username: <registry-username>
        password: <registry-password>
        server: <registry-server>
        repository: <registry-repo>
EOF
```

**Step 2**: Configure Namespace Provisioner to use the accelerator sample that will help with creation of all required resources for configuring `oci-store` as well as `buildpack-build` permissions.

```
namespace_provisioner:
  additional_sources:
  - git:
      ref: origin/main
      subPath: samples/tanzu-supply-chain
      url: https://github.com/atmandhol/tap-nsp-gitops.git
  import_data_values_secrets:
  - name: supply-chain-oci-store-credentials
    namespace: tap-install
    create_export: true
  default_parameters:
    supply_chain_service_account:
      secrets:
      - oci-store-credentials
```

## Create Developer Namespaces
```
$ kubectl create namespace dev
$ kubectl label namespaces dev apps.tanzu.vmware.com/tap-ns=""
```

## Configure Namespace Provisioner to support custom Supply Chains
If there is a requirement for injecting additional secrets to the Service Account like the `git-secret`, they can be added as follows:

* For all Developer namespaces managed by Namespace provisioner, update the `namespace_provisioner` section of the `tap-values.yaml`:

```
namespace_provisioner:
  ...
  default_parameters:
    supply_chain_service_account:
      secrets:
      # Add secrets here
      - git-secret
```

* Single Namespace using annotation:

```
kubectl annotate ns <developer-namespace> param.nsp.tap/delivery_service_account.secrets='["git-secret"]'
```

