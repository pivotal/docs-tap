# Configure Tanzu Supply Chain

This topic tells you what to configure to complete your Tanzu Supply Chain installation.

{{> 'partials/supply-chain/beta-banner' }}

After you have installed Tanzu Supply Chain, there are several steps you must complete to ensure that
you have a functioning installation. Use Namespace Provisioner to configure service accounts and permissions.

## Things to configure

- OCI Store Configuration
  - Supply Chains persist data between stages by reading and writing to an OCI repository.
  The location of the OCI repository is configured by a Kubernetes Secret named `oci-store` that exists within the developer namespace.
  - Access to this repository is controlled by a Tekton annotated secret which can have any name as long as it has the `tekton.dev/docker-0` annotation pointing to the OCI repository.
- Permissions for Buildpacks Cluster Builders for buildpack-build component
  - If you are planning to use the `buildpack-build` component to create images using TBS configured with `ClusterBuilders` you must add some additional permissions.

## Setup using Namespace Provisioner

VMware recommended you use Namespace Provisioner for the entire setup:

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
            server: RESISTRY-SERVER
            repository: REGISTRY-REPO
    EOF
    ```

2. Configure Namespace Provisioner to use the accelerator sample that will help with the creation of
all required resources for configuring `oci-store` as well as `buildpack-build` permissions.

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

## Create Developer Namespaces

```console
kubectl create namespace dev
kubectl label namespaces dev apps.tanzu.vmware.com/tap-ns=""
```

## Configure Namespace Provisioner to support custom Supply Chains

If there is a requirement for injecting additional secrets to the Service Account like the `git-secret`, add as follows:

- For all Developer namespaces managed by Namespace Provisioner, update the `namespace_provisioner`
section of the `tap-values.yaml`:

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
