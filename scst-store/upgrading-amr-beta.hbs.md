# Upgrading from AMR Beta to AMR GA release

This topic tells you how to upgrade from Tanzu Application Platform 1.6 to
Tanzu Application Platform 1.7 with Artifact Metadata Repository (AMR) beta
enabled. Because AMR is not enabled by default in Tanzu Application Platform
1.6, most users will not encounter this scenario. To upgrade without AMR, see
[Supply Chain Security Tools - Store - Upgrading](upgrading.hbs.md).

## <a id='ki'></a>Known issues and workarounds

Because AMR was in beta in Tanzu Application Platform 1.6, there are breaking
changes when upgrading to Tanzu Application Platform 1.7. This section lists all
the known issues and workarounds.

### <a id='config-changes'></a>Configuration Changes

In the AMR Beta release, most of the AMR configurations are in-line with `metadata_store` section inside `values.yaml` file. You must remove `metadata_store.amr` from the `values.yaml` file.

1. Remove `metadata_store.amr` from the values file.
    
    ```code
    metadata_store:
      amr:
        deploy: true
        graphql:
        app_service_type: "ClusterIP"
    ```

2. Remove `amr.deploy_observer: true` from the values file
3. Remove Alias from the `amr.observer.location` configmap
  
  ```code observer:
    location: |
      alias: my-cluster
  ```

### <a id='db-changes'></a>Database changes

In the AMR Beta release, the `Alias` field was introduced in the `Location` table. The `Alias` field is removed in Tanzu Application Platform 1.7. To drop this field from Tanzu Application Platform 1.7:

1. Connect to the [Postgres database](./connect-to-database.hbs.md).
1. Run the following SQL command:
  
  ```code
  ALTER TABLE artifact_locations DROP COLUMN IF EXISTS alias;
  ```
