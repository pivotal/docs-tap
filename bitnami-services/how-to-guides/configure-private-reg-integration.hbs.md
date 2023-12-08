# Configure private registry and VMware Tanzu Application Catalog integration for Bitnami Services

This topic tells you how to integrate Bitnami Services with private registries
or with VMware Tanzu Application Catalog.
You can configure this globally for all services, or on a per-service basis.

## <a id="prereqs"></a>Prerequisites

Before you integrate Bitnami Services with a private registry or VMware Tanzu Application Catalog, you must:

- Have your Helm Chart repository URL in the format `oci://REPOSITORY-NAME/charts`.
- Have the credentials to access the private registry.

For how to obtain both of these prerequisites for VMware Tanzu Application Catalog integration, see
[Obtain credentials for VMware Tanzu Application Catalog integration](./obtain-credentials-for-vac-integration.hbs.md).

## <a id="procedure"></a>Procedure

1. Create two Kubernetes `Secrets`, one with credentials to pull Helm charts and the other with credentials to pull images.
The following examples put these in the `default` namespace, but you can choose to place them in any namespace you prefer.

    ```console
    $ kubectl create secret generic vac-chart-pull \
      -n default \
      --from-literal=username='USERNAME' \
      --from-literal=password='TOKEN'
    ```

    ```console
    $ kubectl create secret docker-registry vac-container-pull \
      -n default \
      --docker-server='REGISTRY-HOSTNAME' \
      --docker-username='USERNAME' --docker-password='TOKEN'
    ```

1. Apply the configuration either to all Bitnami services or to one specific service.
    - **Apply configuration to all Bitnami services:**

        1. Add the following to your `tap-values.yaml` file:

            ```yaml
            bitnami_services:
              globals:
                helm_chart:
                  repo: oci://REPOSITORY-NAME/charts # update this
                  chart_pull_secret_ref:
                    name: vac-chart-pull
                    namespace: default
                  container_pull_secret_ref:
                    name: vac-container-pull
                    namespace: default
            ```

        2. Update Tanzu Application Platform by running:

            ```console
            tanzu package installed update tap -p tap.tanzu.vmware.com --values-file tap-values.yaml -n tap-install
            ```

    - **Apply configuration to one specific Bitnami service:**

        1. Add the following to your `tap-values.yaml` file:

            ```yaml
            bitnami_services:
              mysql: # choose from 'mysql', 'postgresql', 'rabbitmq' and 'redis'
                helm_chart:
                  repo: oci://REPOSITORY-NAME/charts # update this
                  chart_pull_secret_ref:
                    name: vac-chart-pull
                    namespace: default
                  container_pull_secret_ref:
                    name: vac-container-pull
                    namespace: default
            ```

        2. Update Tanzu Application Platform by running:

            ```console
            tanzu package installed update tap -p tap.tanzu.vmware.com --values-file tap-values.yaml -n tap-install
            ```

## Known issue

As of Tanzu Application Platform v1.5.0 there is a known issue that occurs if you try to configure
private registry integration for the Bitnami services after having already created a claim for one or
more of the Bitnami services using the default configuration.
The issue is that the updated private registry configuration does not appear to take effect.
This is due to caching behavior in the system which is not currently accounted for during configuration
updates.

### Workaround

There is a temporary workaround to this issue, which is to delete the `provider-helm-*` pods
in the `crossplane-system` namespace and wait for new pods to come back online after having applied
updated registry configuration.
