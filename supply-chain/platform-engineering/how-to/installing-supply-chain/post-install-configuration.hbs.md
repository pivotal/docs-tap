# Configure Tanzu Supply Chain

This topic tells you what to configure to complete your Tanzu Supply Chain installation.

{{> 'partials/supply-chain/beta-banner' }}

After you install Tanzu Supply Chain, use Namespace Provisioner to configure service accounts and permissions.

VMware recommended that you use Namespace Provisioner to configure the following:

OCI Store configuration: Supply Chains persist data between stages by reading and writing to an OCI repository. The location of the OCI repository is configured by a Kubernetes Secret named `oci-store`
that exists within the developer namespace. Access to this repository is controlled by a Tekton
annotated secret that can have any name with the `tekton.dev/docker-0` annotation
pointing to the OCI repository.

Permissions for the `buildpack-build` component and Cluster Builders: You must add some additional
permissions to use the `buildpack-build`
component to create images with Tanzu Build Service configured with `ClusterBuilders.

## Configure Tanzu Supply Chain using Namespace Provisioner

1. Create a `Secret` in the `tap-install` namespace that has the location and credentials for the `oci-store` as follows:

    ```console
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
            username: REGISTRY-USERNAME
            password: REGISTRY-PASSWORD
            server: REGISTRY-SERVER
            repository: REGISTRY-REPO
    EOF
    ```

1. Configure Namespace Provisioner to use the accelerator sample. This creates
the required resources for configuring `oci-store` and `buildpack-build` permissions.
Update the `namespace_provisioner` section of your `tap-values.yaml` file as follows:

    ```console
    namespace_provisioner:
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/tanzu-supply-chain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      import_data_values_secrets:
      - name: supply-chain-oci-store-credentials
        namespace: tap-install
        create_export: true
      default_parameters:
        supply_chain_service_account:
          secrets:
          - oci-store-credentials
    ```

    Namespace Provisioner creates the required secrets and role bindings in your developer namespace.

## Create Developer Namespaces

  ```console
  kubectl create namespace dev
  kubectl label namespaces dev apps.tanzu.vmware.com/tap-ns=""
  ```

## Configure Namespace Provisioner to support custom Supply Chains

If there is a requirement for
injecting additional secrets to the Service Account such as `git-secret`, for all Developer namespaces managed by Namespace Provisioner, update the `namespace_provisioner`
section of `tap-values.yaml` as follows:

  ```console
  namespace_provisioner:
    ...
    default_parameters:
      supply_chain_service_account:
        secrets:
        # Add secrets here
        - git-secret
  ```

- Single Namespace using annotation:

```console
kubectl annotate ns DEVELOPER-NAMESPACE param.nsp.tap/delivery_service_account.secrets='["git-secret"]'
```
