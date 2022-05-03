# Troubleshoot Tanzu Application Platform GUI

This topic describes troubleshooting information for problems with installing Tanzu Application Platform GUI.


## <a id='catalog-not-found'></a> Catalog not found

### Symptom

When you pull up Tanzu Application Platform GUI, you get the error `Catalog Not Found`.

### Cause

This issue is caused because the catalog plug-in can't read the Git location of your catalog definition files.

### Solution

There are a number of potential causes:

1. Ensure you've either built your own [Backstage Compatible](http://backstage.io) catalog,
or that you've downloaded one of the Tanzu Application Platform GUI catalogs from VMware Tanzu Network.
Ensure you defined the catalog in the values file that you input as part of installation.
If you need to update this location, you can change the definition file.
Change either the Tanzu Application Platform profile file if you used the profile method to install,
or change the standalone Tanzu Application Platform GUI values file if you're only installing that package
on its own.

    ```yaml
        namespace: tap-gui
        service_type: <SERVICE-TYPE>
        app_config:
          catalog:
            locations:
              - type: url
                target: https://GIT-CATALOG-URL/catalog-info.yaml
    ```

2. Provide the proper integration information for the Git location you specified earlier.

    ```yaml
        namespace: tap-gui
        service_type: <SERVICE-TYPE>
        app_config:
          app:
            baseUrl: https://<EXTERNAL-IP>:<PORT>
          integrations:
            gitlab: # Other integrations available
              - host: GITLAB-HOST
                apiBaseUrl: https://<GITLAB-URL>/api/v4
                token: GITLAB-TOKEN
    ```

You can substitute for other integrations as defined in the
[Backstage documentation](https://backstage.io/docs/integrations/)


## <a id='updating-tap-gui-values'></a> Issues updating the values file

### Symptom

After updating the configuration of Tanzu Application Platform GUI, either by using the profiles
method or as a standalone package installation, you don't know whether the configuration has reloaded.

### Suggestions

1. Read the logs of the pods to verify whether the configuration reloaded by running:

    ```console
    kubectl get pods -n tap-gui
    ```

    For example:

    ```console
    $ kubectl get pods -n tap-gui
    NAME                      READY   STATUS    RESTARTS   AGE
    server-6b9ff657bd-hllq9   1/1     Running   0          13m

    $ kubectl logs server-6b9ff657bd-hllq9 -n tap-gui

    Find this line:
    2021-10-29T15:08:49.725Z backstage info Reloaded config from app-config.yaml, app-config.yaml
    ```

2. Try deleting and re-instantiating the pod by running:

    ```console
    kubectl delete pod -l app=backstage -n tap-gui
    ```

> **Note:** Depending on your database configuration, deleting and re-instantiating
> the pod might cause the loss of user preferences and manually registered entities.
> If you have configured an external PostgreSQL database, then `tap-gui` pods are not stateful.
> In most cases, state is held in ConfigMaps, Secrets, or the database.
> For more information, see [Configuring the Tanzu Application Platform GUI database](database.html) and
> [Register components](catalog/catalog-operations.html#register-comp).


## <a id='tap-gui-logs'></a> Pull logs from Tanzu Application Platform GUI

### Symptom

You have problems with Tanzu Application Platform GUI, such as `Catalog: Not Found`,
and you need to learn more about the problem in to diagnose it.

### Solution

Get timestamped logs from the running pod and review the logs:

1. Pull the logs using the pod label:

    ```console
    kubectl logs -l app=backstage -n tap-gui
    ```

2. Review the logs.

## <a id='runtime-resource-visibility'></a> Runtime Resources tab

Here are some common troubleshooting steps for errors presented in the Runtime Resources tab.

## <a id='rrv-network-error'></a> Error communicating with Tanzu Application Platform web server

### Symptom

When accessing the **Runtime Resource Visibility** tab, the system displays, `Error communicating with TAP GUI back end.`

### Causes

1. An interrupted Internet connection.
2. Error with the back end service.

### Solution

1. Confirm that you have Internet access.
2. Confirm that the back end service is running correctly.
3. Confirm the cluster’s configuration is correct.

##  <a id='rrv-no-data-found'></a> No data available

### Symptom

When accessing the **Runtime Resource Visibility** tab, the system displays,
`One or more resources are missing. This could be due to a label mismatch. Please make sure your resources have the label(s) "LABEL_SELECTOR".`

### Cause

No communications error has occurred, but no resources were found.

### Solution

Confirm that you are using the correct label:

- Verify the [Component definition](catalog/catalog-operations.html) includes the annotation `backstage.io/kubernetes-label-selector`.
- Confirm your Kubernetes resources match that label selector.

## Errors retrieving resources

### Symptom

When opening the **Runtime Resource Visibility** tab, the system displays, `One or more resources might be missing because of cluster query errors.`

The reported errors might not indicate a real problem. A build cluster might not have runtime CRDs
installed, such as Knative Service, and a run cluster might not have build CRDs installed, such as a
Cartographer workload. In these cases, 403 and 404 errors might be false positives.

### Error Details

You might receive the following specific error messages:

-  <a id='rrv-cluster-configuration'></a> `Access error when querying cluster CLUSTER_NAME for resource KUBERNETES_RESOURCE_PATH (status: 401). Contact your administrator.`

    #### Cause

    There is a problem with the cluster configuration.

    #### Solution

    Confirm the access token used to request information in the cluster.

- <a id='rrv-resource-access'></a> `Access error when querying cluster CLUSTER_NAME for resource KUBERNETES_RESOURCE_PATH (status: 403). Contact your administrator.`

    #### Cause

    The service account used doesn’t have access to the specific resource type in the cluster.

    #### Solution

    If the cluster is the same where **Tanzu Application Platform** is running, review the version installed to confirm it contains the desired resource.
    If the error is in a watched cluster, review the process to grant access to it in [Viewing resources on multiple clusters in Tanzu Application Platform GUI](cluster-view-setup.html).


- <a id='rrv-missing-knative'></a> `Knative is not installed on CLUSTER_NAME (status: 404). Contact your administrator.`

    #### Cause

    The cluster doesn’t have the Cloud Native Runtimes installed.

    #### Solution

    Install the Knative components by following the instructions in [Install Cloud Native Runtimes](../cloud-native-runtimes/install-cnrt.html).

- <a id='rrv-missing-resource'></a> `Error when querying cluster CLUSTER_NAME for resource KUBERNETES_RESOURCE_PATH (status: 404). Contact your administrator.`

    #### Cause

    The package that contains the resource is not installed.

    #### Solution

    Install the missing package.

## <a id='app-accelerators-page'></a> Accelerators page

Here are some common troubleshooting steps for errors presented in the App Accelerators page.

### <a id='no-accelerators'></a> No accelerators

#### Symptom

When the `app_config.backend.reading.allow` section is configured in the `tap-values-file.yml` file
during the `tap-gui` package installation, there are no accelerators on the Accelerator page.

#### Cause

This is because this section in the `tap-values-file.yml` file overrides the default configuration
that gives Tanzu Application Platform GUI access to the accelerators.

#### Solution

As a workaround, if you are modifying this section, provide a value for Application Accelerator.
For example:

```yaml
app_config:
  # Existing tap-values-file.yml above
  backend:
    reading:
      allow:
      - host: acc-server.accelerator-system.svc.cluster.local
```
