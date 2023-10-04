# Upgrading from AMR Beta to AMR GA release

This topic is about a special upgrade scenario for AMR: Upgrading from TAP 1.6 with AMR beta enabled to TAP 1.7. Because AMR was not enabled by default in TAP 1.6, most users will not encounter this scenario. For a normal upgrade scenario, read [Supply Chain Security Tools - Store - Upgrading](upgrading.hbs.md).

## Known issues and workarounds

Since AMR was in beta in TAP 1.6, there were breaking changes when upgrading to TAP 1.7. This section lists all the known issues and workarounds.

### Configuration Changes

In the AMR Beta release, most of the AMR configurations were inline with `metadata_store` section inside values.yaml file. `metadata_store.amr` should be removed from values.yaml file.

*  Remove `metadata_store.amr` from the values file.
    ```code
    metadata_store:
      amr:
        deploy: true
        graphql:
        app_service_type: "ClusterIP"
    ```
*  Remove `amr.deploy_observer: true` from the values file
*  Remove Alias from the `amr.observer.location` configmap
  ```code observer:
    location: |
      alias: my-cluster
  ```

### DB changes

In the AMR Beta release, the `Alias` field was introduced in the `Location` table. The `Alias` field was removed in TAP 1.7. To drop this field from TAP 1.7 follow below mentioned steps.

* Connect to [Postgres Database](./connect-to-database.hbs.md)
* Run the following SQL command
  ```code
  ALTER TABLE artifact_locations DROP COLUMN IF EXISTS alias;
  ```
