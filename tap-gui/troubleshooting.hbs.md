# Troubleshoot Tanzu Application Platform GUI

This topic describes troubleshooting information for problems with installing
Tanzu Application Platform GUI.

## <a id='catalog-not-found'></a> Catalog not found

### Symptom

When you pull up Tanzu Application Platform GUI, you get the error `Catalog Not Found`.

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

1. Read the log of the pod to see if the configuration reloaded by running:

    ```console
    kubectl logs NAME -n tap-gui
    ```

    Where `NAME` is the value you recorded earlier, such as `server-6b9ff657bd-hllq9`.

1. Search for a line similar to this one:

   ```console
   2021-10-29T15:08:49.725Z backstage info Reloaded config from app-config.yaml, app-config.yaml
   ```

1. If need be, delete and re-instantiate the pod.

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

## <a id='runtime-resource-visibility'></a> Runtime Resources tab

Here are some common troubleshooting steps for errors presented in the **Runtime Resources** tab.

### <a id='rrv-network-error'></a> Error communicating with Tanzu Application Platform web server

#### Symptom

When accessing the **Runtime Resource Visibility** tab, the system displays
`Error communicating with TAP GUI back end.`

#### Causes

- An interrupted Internet connection
- Error with the back end service

#### Solution

1. Confirm that you have Internet access.
2. Confirm that the back-end service is running correctly.
3. Confirm the cluster configuration is correct.

### <a id='rrv-no-data-found'></a> No data available

#### Symptom

When accessing the **Runtime Resource Visibility** tab, the system displays
`One or more resources are missing. This could be due to a label mismatch. Please make sure your resources have the label(s) "LABEL_SELECTOR".`

#### Cause

No communications error has occurred, but no resources were found.

#### Solution

Confirm that you are using the correct label:

1. Verify the [Component definition](catalog/catalog-operations.md) includes the annotation
`backstage.io/kubernetes-label-selector`.

1. Confirm your Kubernetes resources correspond to that label drop-down menu.

### Errors retrieving resources

#### Symptom

When opening the **Runtime Resource Visibility** tab, the system displays
`One or more resources might be missing because of cluster query errors.`

The reported errors might not indicate a real problem.
A build cluster might not have runtime CRDs installed, such as Knative Service, and a run cluster
might not have build CRDs installed, such as a Cartographer workload.
In these cases, 403 and 404 errors might be false positives.

You might receive the following error messages:

- `Access error when querying cluster CLUSTER_NAME for resource KUBERNETES_RESOURCE_PATH (status: 401). Contact your administrator.`
  - **Cause:** There is a problem with the cluster configuration.
  - **Solution:** Confirm the access token used to request information in the cluster.

- `Access error when querying cluster CLUSTER_NAME for resource KUBERNETES_RESOURCE_PATH (status: 403). Contact your administrator.`
  - **Cause:** The service account used doesn’t have access to the specific resource type in the cluster.
  - **Solution:** If the cluster is the same where **Tanzu Application Platform** is running, review
    the version installed to confirm it contains the desired resource.
    If the error is in a watched cluster, review the process to grant access to it in
    [Viewing resources on multiple clusters in Tanzu Application Platform GUI](cluster-view-setup.md).

- `Knative is not installed on CLUSTER_NAME (status: 404). Contact your administrator.`
  - **Cause:** The cluster does not have Cloud Native Runtimes installed.
  - **Solution:** Install the Knative components by following the instructions in
    [Install Cloud Native Runtimes](../cloud-native-runtimes/install-cnrt.md).

- `Error when querying cluster CLUSTER_NAME for resource KUBERNETES_RESOURCE_PATH (status: 404). Contact your administrator.`
  - **Cause:** The package that contains the resource is not installed.
  - **Solution:** Install the missing package.

## <a id='app-accelerators-page'></a> Accelerators page

Here are some common troubleshooting steps for errors displayed on the **Accelerators** page.

### <a id='no-accelerators'></a> No accelerators

#### Symptom

When the `app_config.backend.reading.allow` section is configured in the `tap-values.yaml` file
during the `tap-gui` package installation, there are no accelerators on the **Accelerators** page.

#### Cause

This section in `tap-values.yaml` overrides the default configuration that gives
Tanzu Application Platform GUI access to the accelerators.

#### Solution

As a workaround, provide a value for Application Accelerator in this section.
For example:

```yaml
app_config:
  # Existing tap-values yaml above
  backend:
    reading:
      allow:
      - host: acc-server.accelerator-system.svc.cluster.local
```

## <a id='maven-artifacts-error'></a> Maven artifacts access error

### Symptom

When accessing the **Runtime Resources** tab from the **Component** view, the following warning appears:

```console
Access error when querying cluster 'host' for resource '/apis/source.apps.tanzu.vmware.com/v1alpha1/mavenartifacts' (status: 403). Contact your administrator.
```

In most cases, this issue only affects the `full` profile and only when multicluster visibility is
not set up for Tanzu Application Platform GUI. It only appears in v1.2.0 and is resolved in v1.2.1.

![Screenshot warning of no Maven artifact access ](../images/../tap-gui/images/tap-gui-maven-artifact-1.png)

### Solution

Register Maven artifacts with the service account of Tanzu Application Platform GUI by using the
`package_overlays` key in the Tanzu Application Platform values file.

For instructions, see [Customizing Package Installation](../customize-package-installation.hbs.md).

The following is the overlay for adding Maven artifacts to the Tanzu Application Platform GUI service
account:

```yaml
#@ load("@ytt:overlay", "overlay")
​
#@overlay/match by=overlay.subset({"kind": "ClusterRole", "metadata": {"name": "k8s-reader"}}), expects="1+"
---
rules:
  #@overlay/match by=overlay.subset({"apiGroups": ["source.apps.tanzu.vmware.com"]})
  - resources: ['mavenartifacts']
```
