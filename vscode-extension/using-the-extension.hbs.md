# Using Tanzu Developer Tools for Visual Studio Code

Ensure the project that you want to use the extension with has the required files specified in
[Getting started with Tanzu Developer Tools for Visual Studio Code](../vscode-extension/getting-started.md).

The extension requires only one Tiltfile and one `workload.yaml` per project.
The `workload.yaml` must be a single-document YAML file, not a multidocument YAML file.

## <a id="multiple-projects"></a> Configure for multiple projects in the workspace

When working with multiple projects in a single workspace, you can configure the Tanzu Dev Tools Extension settings on a per-project basis by using the dropdown selector in the `Settings` page.

![The VS Code interface showing the Settings open to the Tanzu Extension, with the "project" dropdown expanded to show both projects in the current workspace.](../images/vscode-multiple-projects.png)

## <a id="debugging-on-clust"></a> Debugging on the cluster

The extension enables you to debug your application on your Kubernetes cluster that has
Tanzu Application Platform.

Debugging requires a `workload.yaml` file in your project.
For information about creating a `workload.yaml` file, see
[Set up Tanzu Developer Tools](../vscode-extension/getting-started.md#set-up-tanzu-dev-tools).

Debugging on the cluster and Live Update cannot be used simultaneously.
If you use Live Update for the current project, ensure that you stop the
Tanzu Live Update Run Configuration before attempting to debug on the cluster.
For more information, see [Stop Live Update](#stop-live-update).

### <a id="start-debugging"></a> Start debugging on the cluster

To start debugging on the cluster:

1. Add a [breakpoint](https://code.visualstudio.com/docs/editor/debugging#_breakpoints) in your code.
1. Right-click the `workload.yaml` file in your project.
1. Select **Debug 'Tanzu Debug Workload...'** in the pop-up menu.

    ![The VS Code interface showing the Explorer tab with the workload.yaml file pop-up menu open and the Tanzu: Java Debug Start option highlighted](../images/vscode-startdebug1.png)

### <a id="stop-debugging"></a> Stop Debugging on the cluster

To stop debugging on the cluster, do one of the following:

- Click the stop button in the Debug overlay.

    ![The VS Code interface close-up on the debug overlay showing the stop rectangle icon and mouseover description](../images/vscode-stopdebug1.png)

- Press ⌘+J to open the panel and then click the trash can icon for the debug task running in the panel.

    ![The VS Code interface close-up on the tasks panel showing the delete trash can icon](../images/vscode-stopdebug2.png)

## <a id="live-update"></a> Live Update

With the use of Live Update facilitated by [Tilt](https://docs.tilt.dev/), the extension enables you
to deploy your workload once, save changes to the code, and see those changes
reflected in the workload running on the cluster within seconds.

Live Update requires a `workload.yaml` file and a Tiltfile in your project.
For information about how to create a `workload.yaml` and a Tiltfile, see
[Set up Tanzu Developer Tools](../vscode-extension/getting-started.md#set-up-tanzu-dev-tools).

Live Update and Debugging on the cluster cannot be used simultaneously.
If you are currently debugging on the cluster, stop debugging before attempting to use Live Update.

### <a id="start-live-update"></a> Start Live Update

There are two ways to start live update:

- Right-click your project’s `Tiltfile` and select `Tanzu: Live Update Start`.

    ![The VS Code interface showing the Explorer tab with the Tiltfile file right-click menu open and the "Tanzu: Live Update Start" option highlighted](../images/vscode-startliveupdate1.png)

- Start the Command Palette (`⇧⌘P`) and run the `Tanzu: Live Update Start` command.

    ![Command palette open showing text Tanzu: Live Update Start](../images/vscode-startliveupdate2.png)

### <a id="stop-live-update"></a> Stop Live Update

When Live Update stops, your application continues to run on the cluster, but the changes you made
and saved in your editor are not present in your running application unless you redeploy your
application to the cluster.

There are two ways to stop live update:

- Right-click your project’s Tiltfile and select `Tanzu: Live Update Stop`.

    ![The VS Code interface showing the Explorer tab with the Tiltfile file right-click menu open and the "Tanzu: Live Update Stop" option highlighted](../images/vscode-stopliveupdate1.png)

- Press ⇧⌘P to start the Command Palette and then run `Tanzu: Live Update Stop`.

    ![Command palette open showing text Tanzu: Live Update Stop](../images/vscode-stopliveupdate2.png)

### <a id="disable-live-update"></a> Deactivate Live Update

You can remove the Live Update capability from your application entirely.
This option can be useful in a troubleshooting scenario.
Disabling Live Update redeploys your workload to the cluster and removes the Live Update capability.

To disable Live Update:

1. Press ⇧⌘P to open the Command Palette.
1. Run `Tanzu: Live Update Disable`.

    ![Command palette open showing text Tanzu: Live Update Disable](../images/vscode-liveupdatedisable.png)

1. Type the name of the workload for which you want to deactivate Live Update.

### <a id="live-update-status"></a> Live Update status

The current status of Live Update is visible on the right side of the status bar at the bottom of
the VS Code window.

![The VS Code interface showing the Tanzu Live Update Status section of the Status bar](../images/vscode-liveupdatestatus1.png)

The Live Update status bar entry shows the following states:

- Live Update Stopped
- Live Update Starting…
- Live Update Running

The Live Update status bar entry can be hidden by right-clicking on it and selecting
**Hide 'Tanzu Developer Tools (Extension)'**.

![The VS Code interface showing the Tanzu Live Update Status section of the Status bar with the right-click menu open and the "Hide 'Tanzu Developer Tools (Extension)'" option highlighted](../images/vscode-liveupdatestatus2.png)

## <a id="switch-namespace"></a> Switch Namespace

To switch the namespace where you created the workload:

1. Navigate to settings (**Code** > **Preferences** > **Settings**).
1. Expand the **Extensions** section of the Settings and select **Tanzu**.
1. In the Namespace option, add the namespace you want to deploy to. This defaults to the default namespace.

![The VS Code settings scrolled to the Tanzu section within the Extensions section](../images/vscode-switchnamespace1.png)
