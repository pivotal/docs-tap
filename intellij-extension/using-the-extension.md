# Using the Tanzu Dev Tools Extension

## <a id="before-beginning"></a> Before Beginning

Ensure the project you want to use the extension with has the required files specified in [Using Tanzu Dev Tools to get started](getting-started.html). 

>**Note:** The Tanzu Developer Tools extension requires only one Tiltfile and one `workload.yaml` per project. The `workload.yaml` must be a single-document YAML file, not a multi-document YAML file.

## <a id="debugging-on-the-cluster"></a> Debugging on the Cluster

The Tanzu Developer Tools extension enables you to debug your application on your Kubernetes cluster enabled by Tanzu Application Platform.

Debugging requires a `workload.yaml` file in your project. For information about creating a `workload.yaml` file, see [Set Up Tanzu Dev Tools](getting-started.html#set-up-tanzu-dev-tools).

> **Note:** Debugging on the cluster and Live Update can not be used simultaneously. If you use Live Update for the current project, you must ensure that you stop the Tanzu Live Update Run Configuration before attempting to debug on the cluster.

### <a id="start-debugging-on-the-cluster"></a> Start Debugging on the Cluster

To start debugging on the cluster:

1. Add a [breakpoint](https://www.jetbrains.com/help/idea/using-breakpoints.html) in your code.
2. Right-click the `workload.yaml` file in your project.
3. Select **Debug 'Tanzu Debug Workload...'** in the right-click menu.

    ![The IntelliJ interface showing the project tab with the workload.yaml file right-click menu open and the "Tanzu -> Debug Workload" option highlighted](../images/intellij-debugWorkload.png)

4. Ensure the configuration parameters are set.
    - Source Image: Registry location to publish local source code, for example registry.io/yourapp-source. This must include both a registry and a project name.
    - Local Path: Path on the local file system to a directory of source code to build.
    - Namespace: Namespace that workloads are deployed into.

    ![Debug config parameters](../images/intellij-config.png)

5. You can also manually create Tanzu Debug Configurations by using the `Edit Configurations` IntelliJ UI.

### <a id="stop-debugging-on-the-cluster"></a> Stop Debugging on the Cluster

Click the stop button in the Debug overlay to stop debugging on the cluster:

![The IntelliJ interface showing the debug interface pointing out the stop rectangle icon and mouseover description](../images/intellij-stopDebug.png)

### <a id="start-live-update"></a> Start Live Update
> **Note:** Only one Live Update session can be active at a time. Stop any running session before starting a new one.

1. Right-click your project’s `Tiltfile` and select **Run 'Tanzu Live Update - ...'**.
![The IntelliJ interface showing the project tab with the Tiltfile file right-click menu open](../images/intellij-startLiveUpdate.png)
2. Ensure the configuration parameters are set.
    - Source Image: Registry location to publish local source code, for example registry.io/yourapp-source. This must include both a registry and a project name.
    - Local Path: Path on the local file system to a directory of source code to build.
    - Namespace: Namespace that workloads are deployed into.

    ![Live Update config parameters](../images/intellij-liveupdate-config.png)

> **Note:** You must compile your code before the changes are synchronized to the container. For example, `Build Project`: `⌘`+`F9`. 

### <a id="stop-liveupdate"></a> Stop Live Update
- To stop Live Update, use the native controls to stop the currently running `Tanzu Live Update` Run Configuration

![Stop Live Update](../images/intellij-stopliveupdate.png)
