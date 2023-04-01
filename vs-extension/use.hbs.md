# Use Tanzu Developer Tools for Visual Studio

> **Note** This extension is in the beta stage of development.

This topic describes how to use Tanzu Developer Tools for Visual Studio.

## <a id="prereqs"/>Prerequisites

Ensure that you meet the following prerequisites:
 - The Tanzu CLI is installed in a location included in your `PATH` environment variable.
 - A valid `workload.yaml` file is in the project. For more information, see the specification for
   [Tanzu apps workload apply](../cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md).
 - You have a functional Tanzu Application Platform environment.
 - Your kubeconfig file is modified for Tanzu Application Platform workload deployments.
 - You have an image repository to which source code in the local file system can be uploaded before Build Service builds it.

## <a id="settings"/>Configure Tanzu settings

To configure settings:

1. Right-click on the Solution Explorer project.
1. Select **Tanzu: Settings**.
1. Confirm or enter the settings.
   ![Tanzu settings](../images/vs-settings.png)

## <a id="apply-workload"/>Apply a workload

To apply a workload:

1. Right-click on the Solution Explorer project.
1. Select **Tanzu: Apply Workload**.
1. Output appears in the Tanzu Output pane of the Visual Studio Output tool window.

## <a id="delete-workload"/>Delete a workload

To delete a workload:

1. Right-click on the Solution Explorer project.
1. Select **Tanzu: Delete Workload**.
1. Output appears in the Tanzu Output pane of the Visual Studio Output tool window.

## <a id="use-live-update"/>Use Live Update

To use Live Update:

1. Right-click on the Solution Explorer project.
1. To Start Live Update, select **Tanzu: Start Live Update**.
1. To Stop Live Update, select **Tanzu: Stgop Live Update**.

## <a id="use-remote-debug"/>Use Remote Debug

1. Deploy a workload using Apply Workload or Live Update.
1. Right-click on the Solution Explorer project.
1. Select **Tanzu: Remote Debug**.
1. Select your application pod from the prompted list.

Visual Studio will establish a debugging session with your remote application.

A file named `.tanzu-vs-launch-config.json` is created at the root directory of your project.
This file specifies the configuration needed to attach Visual Studio's debugger to the agent running in your workload's container.
It is only needed to initiate remote debugging and can be safely deleted at any time.
This file location is temporary and will change in a future version.

> **Caution** Do not use the red square stop button in Visual Studio's top toolbar.
> Doing so will cause the Tanzu Application Platform workload to fail or become unresponsive indefinitely.
> Instead, from the top menu select **Debug**, then select **Detach All**.
> A fix is planned for a future release.

> **Caution** If the name of your running app process (the app DLL process), does not match the name of your .NET project as shown in the Visual Studio Solution Explorer, the remote debugging agent may fail to attach.

[Troubleshoot Tanzu Developer Tools for Visual Studio](troubleshoot.hbs.md).
