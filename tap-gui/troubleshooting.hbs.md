# Troubleshoot Tanzu Application Platform GUI

This topic describes troubleshooting information for problems with installing
Tanzu Application Platform GUI.

## <a id='safari-not-working'></a> Tanzu Application Platform GUI does not work in Safari

### Symptom

Tanzu Application Platform GUI does not work in the Safari web browser.

### Solution

Currently there is no way to use Tanzu Application Platform GUI in Safari. Please use a different
web browser.

## <a id='catalog-not-found'></a> Catalog not found

### Symptom

When you pull up the Tanzu Application Platform UI, you get the error `Catalog Not Found`.

### Cause

The catalog plug-in can't read the Git location of your catalog definition files.

### Solution

1. Ensure you have built your own [Backstage](https://backstage.io/)-compatible catalog or that
   you have downloaded one of the Tanzu Application Platform GUI catalogs from VMware Tanzu
   Network.
2. Ensure you defined the catalog in the values file that you input as part of installation.
   To update this location, change the definition file:

      - Change the Tanzu Application Platform profile file if installed by using a profile.
      - Change the standalone Tanzu Application Platform GUI values file if you're only installing
        that package on its own.

    ```yaml
        namespace: tap-gui
        service_type: SERVICE-TYPE
        app_config:
          catalog:
            locations:
              - type: url
                target: https://GIT-CATALOG-URL/catalog-info.yaml
    ```

3. Provide the proper integration information for the Git location you specified earlier.

    ```yaml
        namespace: tap-gui
        service_type: SERVICE-TYPE
        app_config:
          app:
            baseUrl: https://EXTERNAL-IP:PORT
          integrations:
            gitlab: # Other integrations available
              - host: GITLAB-HOST
                apiBaseUrl: https://GITLAB-URL/api/v4
                token: GITLAB-TOKEN
    ```

You can substitute for other integrations as defined in the
[Backstage documentation](https://backstage.io/docs/integrations/).

## <a id='updating-tap-gui-values'></a> Issues updating the values file
### Symptom

After updating the configuration of Tanzu Application Platform GUI, either by using a profile
or as a standalone package installation, you don't know whether the configuration has reloaded.

### Solution

1. Get the name you need by running:

    ```console
    kubectl get pods -n tap-gui
    ```

    For example:

    ```console
    $ kubectl get pods -n tap-gui
    NAME                      READY   STATUS    RESTARTS   AGE
    server-6b9ff657bd-hllq9   1/1     Running   0          13m
    ```

2. Read the log of the pod to see if the configuration reloaded by running:

    ```console
    kubectl logs NAME -n tap-gui
    ```

    Where `NAME` is the value you recorded earlier, such as `server-6b9ff657bd-hllq9`.

3. Search for a line similar to this one:

   ```console
   2021-10-29T15:08:49.725Z backstage info Reloaded config from app-config.yaml, app-config.yaml
   ```

4. If need be, delete and re-instantiate the pod.

   > **Caution:** Depending on your database configuration, deleting, and re-instantiating
   > the pod might cause the loss of user preferences and manually registered entities.
   > If you have configured an external PostgreSQL database, `tap-gui` pods are not stateful.
   > In most cases, state is held in ConfigMaps, Secrets, or the database.
   > For more information, see [Configuring the Tanzu Application Platform GUI database](database.md)
   > and [Register components](catalog/catalog-operations.md#register-comp).

   To delete and re-instantiate the pod, run:

    ```console
    kubectl delete pod -l app=backstage -n tap-gui
    ```

## <a id='tap-gui-logs'></a> Pull logs from Tanzu Application Platform GUI

### Symptom

You have a problem with Tanzu Application Platform GUI, such as `Catalog: Not Found`, and don't have
enough information to diagnose it.

### Solution

Get timestamped logs from the running pod and review the logs:

1. Pull the logs by using the pod label by running:

    ```console
    kubectl logs -l app=backstage -n tap-gui
    ```

2. Review the logs.
