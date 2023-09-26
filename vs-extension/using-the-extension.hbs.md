# Use Tanzu Developer Tools for Visual Studio

This topic tells you how to use VMware Tanzu Developer Tools for Visual Studio.

> **Note** This extension is in the beta stage of development.

## <a id="settings"></a> Configure settings

To configure settings, right-click anywhere in the Solution Explorer and click
**Tanzu** > **Settings...**.

   ![Screenshot of the Tanzu Settings window.](../images/vs-extension/tanzu-settings.png)

## <a id="workload-actions"></a> Workload Actions

The extension enables you to apply, debug, and Live Update your application on a Kubernetes cluster
that has Tanzu Application Platform.
The developer sandbox experience enables developers to Live Update their code and simultaneously
debug the updated code, without having to deactivate Live Update when debugging.

### <a id="apply-workload"></a> Apply a workload

To apply a workload, right-click anywhere in the Solution Explorer and click
**Tanzu** > **Apply Workload**, or right-click on an associated workload in the Tanzu Panel and
click **Apply Workload**.

### <a id="delete-workload"></a> Delete a workload

To delete a workload, right-click anywhere in the Solution Explorer and click
**Tanzu** > **Delete Workload**, or right-click on an associated workload in the Tanzu Panel and
click **Delete Workload**.

### <a id="debugging"></a> Start debugging on the cluster

To remote debug a workload, right-click anywhere in the Solution Explorer and click
**Tanzu** > **Debug Workload**, or right-click on an associated workload in the Tanzu Panel and
click **Debug Workload**.

> **Caution** Do not use the red square Stop button to end your debugging session.
> Doing so might cause the Tanzu Application Platform workload to fail.
> Instead, in the top menu click **Debug** > **Detach All**.
>
> If the name of your running app process (the app DLL process), does not match the name
> of your .NET project as shown in the Visual Studio Solution Explorer, the remote debugging agent
> might fail to attach.

## <a id="live-updating"></a> Live Update

See the following sections for how to use Live Update.

### <a id="start-live-update"></a> Start Live Update

Ensure the Tanzu Settings parameters are set:

   - **Local Path:** This is the path on the local file system to a directory of source code to build.
   - **Namespace:** This is the namespace that workloads are deployed into.  Optional.
   - **Source Image:** This is the registry location for publishing local source code.
     For example, `registry.io/yourapp-source`. It must include both a registry and a project name.
     The source image parameter is optional if you have configured Local Source Proxy.

To start live update, right-click anywhere in the Solution Explorer and click
**Tanzu** > **Start Live Update**, or right-click on an associated workload in the Tanzu Panel and
click **Start Live Update**.

After starting live update, local builds changes are synchronized to the container.

### <a id="stop-live-update"></a> Stop Live Update

To start live update, right-click anywhere in the Solution Explorer and click
**Tanzu** > **Stop Live Update**, or right-click on an associated workload in the Tanzu Panel and
click **Stop Live Update**.

## <a id="workload-panel"></a> Tanzu Workloads panel

The extension creates log entries in a file named `tanzu-dev-tools.log`.
This file is in the directory where Visual Studio Installer installed the extension.

To view the Tanzu Workloads panel, right-click anywhere in the Solution Explorer and click
**Tanzu** > **View Workloads**.

![Tanzu Workloads panel with the context menu open on the selected sample app.](../images/vs-extension/tanzu-panel.png)

## <a id="extension-logs"></a> Extension logs

The extension creates log entries in two files named `tanzu-dev-tools-{GUID}.log` and
`tanzu-language-server-{GUID}.log`.
These files are in the directory where Visual Studio Installer installed the extension.

To find the log files, run:

```console
# PowerShell
dir $Env:LOCALAPPDATA\Microsoft\VisualStudio\*\Extensions\*\Logs\tanzu-*.log
# CMD
dir %LOCALAPPDATA%\Microsoft\VisualStudio\*\Extensions\*\Logs\tanzu-*.log
```

    Directory: C:\Users\...

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           3/31/2023  1:07 PM           1668 tanzu-dev-tools.log
```