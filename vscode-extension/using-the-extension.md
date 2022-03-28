# Using the Tanzu Dev Tools Extension

## <a id=on-this-page></a> On this page

- [Before Beginning](#before-beginning)
- [Debugging on the Cluster](#debugging-on-the-cluster)
  - [Start Debugging on the Cluster](#start-debugging-on-the-cluster)
  - [Stop Debugging on the Cluster](#stop-debugging-on-the-cluster)
- [Live Update](#live-update)
  - [Start Live Update](#start-live-update)
  - [Stop Live Update](#stop-live-update)
  - [Disable Live Update](#disable-live-update)
  - [Live Update Status](#live-update-status)
- [Switch Namespace](#switch-namespace)
- [Workload Panel](#workload-panel)

## <a id="before-beginning"></a> Before Beginning

Ensure the project you want to use the extension with has the required files specified in the [Getting Started page](../vscode-extension/getting-started.md). Note that the Tanzu Developer Tools extension requires only one Tiltfile and one workload.yaml per project. The workload.yaml must be a single-document YAML file, not a multi-document YAML files.

## <a id="debugging-on-the-cluster"></a> Debugging on the Cluster

The Tanzu Developer Tools extension enables you to debug your application on your TAP-enabled Kubernetes cluster .

Debugging requires a **workload.yaml** file in your project. For information about creating a **workload.yaml** file, see the [Set Up section](../vscode-extension/getting-started.md#set-up-tanzu-dev-tools) on the Getting Started page.

> **Note:** Debugging on the cluster and Live Update can not be used simultaneously. If you have used Live Update for the current project, you must ensure you have stopped live update before attempting to debug on the cluster. See [Stop Live Update](#stop-live-update) below for more information.

### <a id="start-debugging-on-the-cluster"></a> Start Debugging on the Cluster

To start debugging on the cluster:
1. Add a [breakpoint](https://code.visualstudio.com/docs/editor/debugging#_breakpoints) in your code.
1. Right-click the **workload.yaml** file in your project.
1. Select `Tanzu: Java Debug Start` in the right-click menu.
![The VS Code interface showing the Explorer tab with the workload.yaml file right-click menu open and the "Tanzu: Java Debug Start" option highlighted](../images/vscode-startdebug1.png)

### <a id="stop-debugging-on-the-cluster"></a> Stop Debugging on the Cluster

To stop debugging on the cluster:
1. Select the stop button in the Debug overlay
![The VS Code interface close-up on the debug overlay showing the stop rectangle icon and mouseover description](../images/vscode-stopdebug1.png)
1. or, select the trash can icon for the debug task running in the Panel (`View -> Appearance -> Show Panel`, or hotkey `⌘+J`)
![The VS Code interface close-up on the tasks panel showing the delete trash can icon](../images/vscode-stopdebug2.png)

## <a id="live-update"></a> Live Update

Using [Live Update](../glossary.md#live-update) (facilitated by [Tilt](https://docs.tilt.dev/)) the Tanzu Developer Tools extension enables you to deploy your workload once, then save changes to the code and see those changes reflected in the workload running on the cluster within seconds.

Live update requires a **workload.yaml** file and a **Tiltfile** in your project. For information about how to create a **workload.yaml** and a **Tiltfile**, see the [Set Up section](../vscode-extension/getting-started.md#set-up-tanzu-dev-tools) on the Getting Started page.

> **Note:** Live Update and Debugging on the cluster can not be used simultaneously. If you are currently debugging on the cluster, you must stop the debugging process before attempting to use Live Update.

### <a id="start-live-update"></a> Start Live Update

There are two ways to start live update:

- Right-click your project’s `Tiltfile` and select `Tanzu: Live Update Start`.
![The VS Code interface showing the Explorer tab with the Tiltfile file right-click menu open and the "Tanzu: Live Update Start" option highlighted](../images/vscode-startliveupdate1.png)

- Start the Command Palette (`⇧⌘P`) and run the `Tanzu: Live Update Start` command.
![Command palette open showing text Tanzu: Live Update Start](../images/vscode-startliveupdate2.png)

### <a id="stop-live-update"></a> Stop Live Update

When Live Update stops, your application continues to run on the cluster, but changes you make and save in your editor will not be present in your running application unless you redeploy your application to the cluster.

There are two ways to stop live update:

- Right-click your project’s `Tiltfile` and select `Tanzu: Live Update Stop`.
![The VS Code interface showing the Explorer tab with the Tiltfile file right-click menu open and the "Tanzu: Live Update Stop" option highlighted](../images/vscode-stopliveupdate1.png)

- Start the Command Palette (`⇧⌘P`) and run the `Tanzu: Live Update Stop` command.
![Command palette open showing text Tanzu: Live Update Stop](../images/vscode-stopliveupdate2.png)

### <a id="disable-live-update"></a> Disable Live Update

The Live Update capability can be removed from your application entirely. This functionality may be useful in a troubleshooting scenario, or if you decide not to use Live Update.

> **Note:** Disabling Live Update redeploys your workload to the cluster and removes the Live Update capability.

To disable Live Update:
1. Start the Command Palette (`⇧⌘P`).
1. Run the `Tanzu: Live Update Disable` command.
![Command palette open showing text Tanzu: Live Update Disable](../images/vscode-liveupdatedisable.png)
1. Enter the name of the workload you want to deactivate live update for.

### <a id="live-update-status"></a> Live Update Status

The current status of Live Update can be seen on the right side of the Status Bar at the bottom of the VS Code window.

![The VS Code interface showing the Tanzu Live Update Status section of the Status bar](../images/vscode-liveupdatestatus1.png)

The Live Update status bar entry reflects the following states:
- Live Update Stopped
- Live Update Starting…
- Live Update Running

The Live Update status bar entry can be hidden by right-clicking on it and selecting `Hide ‘Tanzu Developer Tools (Extension)’`.

![The VS Code interface showing the Tanzu Live Update Status section of the Status bar with the right-click menu open and the "Hide 'Tanzu Developer Tools (Extension)'" option highlighted](../images/vscode-liveupdatestatus2.png)

## <a id="switch-namespace"></a> Switch Namespace

To switch the namespace that your workload is created in:
1. Navigate to settings (`Code -> Preferences -> Settings`)
1. Expand the **Extensions** section of the Settings and select **Tanzu**
1. In the Namespace option, add the namespace you want to deploy to. This defaults to the default namespace.

![The VS Code settings scrolled to the Tanzu section within the Extensions section](../images/vscode-switchnamespace1.png)

## <a id="workload-panel"></a> Workload Panel
