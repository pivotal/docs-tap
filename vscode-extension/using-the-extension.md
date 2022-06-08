# Using the Tanzu Dev Tools Extension

## <a id=on-this-page></a> On this page

- [Before Beginning](#before-beginning)
- [Multiple Projects in Workspace](#multiple-projects-in-workspace)
- [Debugging on the Cluster](#debugging-on-the-cluster)
  - [Start Debugging on the Cluster](#start-debugging-on-the-cluster)
  - [Stop Debugging on the Cluster](#stop-debugging-on-the-cluster)
- [Live Update](#live-update)
  - [Start Live Update](#start-live-update)
  - [Stop Live Update](#stop-live-update)
  - [Disable Live Update](#disable-live-update)
  - [Live Update Status](#live-update-status)
- [Switch Namespace](#switch-namespace)

## <a id="before-beginning"></a> Before Beginning

Ensure the project to use the extension with has the required files specified in the [Getting Started page](../vscode-extension/getting-started.md).

>**Note:** The Tanzu Developer Tools extension requires only one **Tiltfile** and one **workload.yaml** per project. The **workload.yaml** must be a single-document YAML file, not a multidocument YAML files.

## <a id="multiple-projects-in-workspace"></a> Multiple Projects in Workspace

When working with multiple projects in a single workspace, you can configure the Tanzu Dev Tools Extension settings on a per-project basis by using the dropdown selector in the `Settings` page.

![The VS Code interface showing Tanzu Extension selected in the settings. The Project drop-down menu is expanded to show both projects in the current workspace.](../images/vscode-multiple-projects.png)

## <a id="apply-workload"></a> Apply Workload

The Tanzu Developer Tools extension enables you to apply workloads on your TAP-enabled Kubernetes cluster.

To apply a workload from the command palette:

1. Start the Command Palette (`⇧⌘P`).

2. Run the `Tanzu: Apply Workload` command.

    ![Command palette open showing text Tanzu: Apply Workload](../images/vscode-applyworkload1.png)

    - If there are multiple projects with workloads, select the workload to apply.

        ![Apply Workload menu open showing workloads available to apply](../images/vscode-applyworkload2.png)

3. A notification appears showing that the workload was applied.

    ![Apply Workload notification showing workload has been applied](../images/vscode-applyworkload3.png)

To apply a workload from the context menu:

1. Right click on your workload file and select `Tanzu: Apply Workload`.

    ![Context menu open showing text Tanzu: Apply Workload](../images/vscode-applyworkload4.png)

2. A notification appears showing that the workload was applied.

    ![Apply Workload notification showing workload has been applied](../images/vscode-applyworkload3.png)

## <a id="debugging-on-the-cluster"></a> Debugging on the Cluster

The Tanzu Developer Tools extension enables you to debug your application on your TAP-enabled Kubernetes cluster.

Debugging requires a **workload.yaml** file in your project. For information about creating a **workload.yaml** file, see the [Set Up section](../vscode-extension/getting-started.md#set-up-tanzu-dev-tools).

>**Note:** Debugging on the cluster and Live Update can not be used simultaneously. If you have used Live Update for the current project, you must ensure you have stopped live update before attempting to debug on the cluster. See [Stop Live Update](#stop-live-update) for more information.

### <a id="start-debugging-on-the-cluster"></a> Start Debugging on the Cluster

To start debugging on the cluster:

1. Add a [breakpoint](https://code.visualstudio.com/docs/editor/debugging#_breakpoints) in your code.
1. Right-click the **workload.yaml** file in your project.
1. Select `Tanzu: Java Debug Start` in the right-click menu.

![The VS Code interface showing the Explorer tab with the workload.yaml file right-click menu open and the "Tanzu: Java Debug Start" option highlighted](../images/vscode-startdebug1.png)

### <a id="stop-debugging-on-the-cluster"></a> Stop Debugging on the Cluster

To stop debugging on the cluster:

- Select the stop button in the Debug overlay.

    ![The VS Code interface close-up on the debug overlay showing the stop rectangle icon and mouseover description](../images/vscode-stopdebug1.png)

- Or select the trash can icon for the debug task running in the Panel (`View -> Appearance -> Show Panel`, or hotkey `⌘+J`).

    ![The VS Code interface close-up on the tasks panel showing the delete trash can icon](../images/vscode-stopdebug2.png)

## <a id="live-update"></a> Live Update

By using Live Update facilitated by [Tilt](https://docs.tilt.dev/), the Tanzu Developer Tools extension enables you to deploy your workload once, save changes to the code and see those changes reflected in the workload running on the cluster within seconds.

Live update requires a **workload.yaml** file and a **Tiltfile** in your project. For information about how to create a **workload.yaml** and a **Tiltfile**, see the [Set Up section](../vscode-extension/getting-started.md#set-up-tanzu-dev-tools) on the Getting Started page.

>**Note:** Live Update and Debugging on the cluster can not be used simultaneously. If you are currently debugging on the cluster, you must stop the debugging process before attempting to use Live Update.

### <a id="start-live-update"></a> Start Live Update

There are two ways to start live update:

- Right-click your project’s `Tiltfile` and select `Tanzu: Live Update Start`.

    ![The VS Code interface showing the Explorer tab with the Tiltfile file right-click menu open and the "Tanzu: Live Update Start" option highlighted](../images/vscode-startliveupdate1.png)

- Start the Command Palette (`⇧⌘P`) and run the `Tanzu: Live Update Start` command.

    ![Command palette open showing text Tanzu: Live Update Start](../images/vscode-startliveupdate2.png)

### <a id="stop-live-update"></a> Stop Live Update

When Live Update stops, your application continues to run on the cluster, but the changes you made and saved in your editor will not be present in your running application unless you redeploy your application to the cluster.

There are two ways to stop live update:

- Right-click your project’s `Tiltfile` and select `Tanzu: Live Update Stop`.

    ![The VS Code interface showing the Explorer tab with the Tiltfile file right-click menu open and the "Tanzu: Live Update Stop" option highlighted](../images/vscode-stopliveupdate1.png)

- Start the Command Palette (`⇧⌘P`) and run the `Tanzu: Live Update Stop` command.

    ![Command palette open showing text Tanzu: Live Update Stop](../images/vscode-stopliveupdate2.png)

### <a id="disable-live-update"></a> Disable Live Update

You can remove the Live Update capability from your application entirely. This functionality can be useful in a troubleshooting scenario, or when you decide not to use Live Update.

>**Note:** Disabling Live Update redeploys your workload to the cluster and removes the Live Update capability.

To disable Live Update:

1. Start the Command Palette (`⇧⌘P`).

1. Run the `Tanzu: Live Update Disable` command.

    ![Command palette open showing text Tanzu: Live Update Disable](../images/vscode-liveupdatedisable.png)

1. Enter the name of the workload you want to deactivate live update for.

### <a id="live-update-status"></a> Live Update Status

The current status of Live Update is visible on the right side of the Status Bar at the bottom of the VS Code window.

![The VS Code interface showing the Tanzu Live Update Status section of the Status bar](../images/vscode-liveupdatestatus1.png)

The Live Update status bar entry reflects the following states:

- Live Update Stopped
- Live Update Starting…
- Live Update Running

The Live Update status bar entry can be hidden by right-clicking on it and selecting `Hide ‘Tanzu Developer Tools (Extension)’`.

![The VS Code interface showing the Tanzu Live Update Status section of the Status bar with the right-click menu open and the "Hide 'Tanzu Developer Tools (Extension)'" option highlighted](../images/vscode-liveupdatestatus2.png)

## <a id="delete-workload"></a> Delete Workload

The Tanzu Developer Tools extension enables you to delete workloads on your TAP-enabled Kubernetes cluster.

To delete a workload:

1. Start the Command Palette (`⇧⌘P`).

2. Run the `Tanzu: Delete Workload` command.

    ![Command palette open showing text Tanzu: Delete Workload](../images/vscode-deleteworkload1.png)

3. Select the workload to delete.

    ![Delete Workload menu open showing workloads available to delete](../images/vscode-deleteworkload2.png)

    - If the `Tanzu: Confirm Delete` setting is enabled, a notification appears allowing you to delete the workload and not warn again, delete the workload, or cancel.

    ![Delete Confirmation Notification showing delete options](../images/vscode-deleteworkload3.png)

4. A notification appears showing that the workload was deleted.

    ![Delete Workload Notification showing workload has been deleted](../images/vscode-deleteworkload4.png)

## <a id="switch-namespace"></a> Switch Namespace

To switch the namespace where you created the workload:

1. Navigate to settings (`Code -> Preferences -> Settings`).
1. Expand the **Extensions** section of the Settings and select **Tanzu**.
1. In the Namespace option, add the namespace you want to deploy to. This is the `default` namespace by default.

![The VS Code settings scrolled to the Tanzu section within the Extensions section](../images/vscode-switchnamespace1.png)
