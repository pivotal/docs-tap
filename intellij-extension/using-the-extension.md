# Using the Tanzu Dev Tools Extension

## <a id=on-this-page></a> On this page

- [Before Beginning](#-before-beginning)
  - [Required Settings](#-required-settings)
- [Debugging on the Cluster](#-debugging-on-the-cluster)
  - [Start Debugging on the Cluster](#-start-debugging-on-the-cluster)
  - [Stop Debugging on the Cluster](#-stop-debugging-on-the-cluster)
  - [Start Live Update](#-start-live-update)
  - [Stop Live Update](#-stop-live-update)
- [Switch Namespace](#-switch-namespace)

## <a id="before-beginning"></a> Before Beginning

Ensure the project you want to use the extension with has the required files specified in the [Getting Started page](getting-started.md). Note that the Tanzu Developer Tools extension requires only one Tiltfile and one workload.yaml per project. The workload.yaml must be a single-document YAML file, not a multi-document YAML files.

## <a id="debugging-on-the-cluster"></a> Debugging on the Cluster

The Tanzu Developer Tools extension enables you to debug your application on your TAP-enabled Kubernetes cluster .

Debugging requires a **workload.yaml** file in your project. For information about creating a **workload.yaml** file, see the [Set Up section](getting-started.md#set-up-tanzu-dev-tools) on the Getting Started page.

> **Note:** Debugging on the cluster and Live Update can not be used simultaneously. If you have used Live Update for the current project, you must ensure you have stopped live update before attempting to debug on the cluster. See [Stop Live Update](#stop-live-update) below for more information.

### <a id="start-debugging-on-the-cluster"></a> Start Debugging on the Cluster

To start debugging on the cluster:
1. Add a [breakpoint](https://www.jetbrains.com/help/idea/using-breakpoints.html) in your code.
2. Right-click the **workload.yaml** file in your project.
3. Select `Debug 'Tanzu Debug Workload...'` in the right-click menu.
![The IntelliJ interface showing the project tab with the workload.yaml file right-click menu open and the "Tanzu -> Debug Workload" option highlighted](../images/intellij-debugWorkload.png)
4. Ensure the configuration parameters are set.
![Debug config parameters](../images/intellij-config.png)
5. You can also manually create Tanzu Debug Configurations via the `Edit Configurations` IntelliJ UI.

### <a id="stop-debugging-on-the-cluster"></a> Stop Debugging on the Cluster

To stop debugging on the cluster:
1. Select the stop button in the Debug overlay
![The IntelliJ interface showing the debug interface pointing out the stop rectangle icon and mouseover description](../images/intellij-stopDebug.png)

### <a id="start-live-update"></a> Start Live Update

- Right-click your project’s `Tiltfile` and select `Run 'Tanzu Live Update - ...'`.
![The IntelliJ interface showing the project tab with the Tiltfile file right-click menu open](../images/intellij-startLiveUpdate.png)
