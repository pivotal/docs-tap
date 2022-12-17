# Use Tanzu Developer Tools for Visual Studio

This topic describes how to use Tanzu Developer Tools for Visual Studio.

## <a id="apply-workload"></a> Apply a workload

To apply a workload:

1. Ensure that you have the following prerequisites:

   - A `tanzu` command in `PATH`.
   - A valid `workload.yaml` file in the project. For more information, see the specification for
     [Tanzu apps workload apply](../cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md).
   - A functional Tanzu Application Platform environment.
   - Your kubeconfig file is modified for Tanzu Application Platform workload deployments.
     There must be a preferred `namespace`, for example.
   - An image repository where source code can be staged before being built.

2. Right-click the project node or any file node in the Solution Explorer.
3. Click **Tanzu: Apply Workload**.
4. Specify an address to your image repository in the confirmation dialog box.
5. (Optional) adjust additional settings for the `apply` path to your local source code, Kubernetes
   namespace, and path to `workload.yaml`.
   If a `workload.yaml` file exists somewhere in the project file structure, it is used by default.
6. Click **Apply Workload**.
7. Verify that output appears in the Tanzu Output pane of the Visual Studio Output tool window.

## <a id="delete-workload"></a> Delete a workload

To delete a workload:

1. Ensure that you have the following prerequisites:

   - A `tanzu` command in `PATH`
   - A running Tanzu Application Platform workload
   - A valid `workload.yaml` file in the project that describes the workload to delete

2. Right-click the project node or any file node in the Solution Explorer.
3. Click **Tanzu: Delete Workload**.
4. If a `workload.yaml` exists somewhere in the project file structure, delete the workload by running:

    ```console
    tanzu apps workload delete --file=WORKLOAD-PATH --yes
    ```

    Where `WORKLOAD-PATH` is your workload path

## <a id="use-live-update"></a> Use Live Update

To use Live Update:

1. Ensure that you have the following prerequisites:

   - A project with a `Tiltfile` in the project root
   - A `tilt` command in `PATH`
   - A `tanzu` command in `PATH`

2. Start Live Update by right-clicking on **Tiltfile** and then selecting **Tanzu: Start Live Update**.
3. Stop Live Update by right-clicking on **Tiltfile** and then selecting **Tanzu: Stop Live Update**.

### <a id="stop-rogues"></a> Stop rogue Tilt processes

If a `tilt` process is already running and you try to start Live Update, a message in the Tanzu Output
window appears, which is similar to:

```console
Error: listen tcp 127.0.0.1:10350: bind: Only one usage of each socket address \
(protocol/network address/port) is normally permitted.
```

To resolve this, stop any running `tilt` processes. The following example is a PowerShell snippet,
but you can get a similar result by using Task Manager.

```console
Get-Process "tilt" | ForEach-Object { $_.kill() }
```

## <a id="use-remote-debug"></a> Use Remote Debug

To use Remote Debug:

1. Ensure that you have the following prerequisites:

   - A running .NET workload in Tanzu Application Platform
   - A `tanzu` command in `PATH`
   - A `kubectl` command in `PATH`

### <a id="run-workload"></a> Run a workload in Tanzu Application Platform

To run a workload in Tanzu Application Platform:

1. Use the Tanzu CLI `apps` plug-in to push workloads to Tanzu Application Platform by running:

   ```console
   workload apply
   ```

  For more information, see
  [Tanzu apps workload apply](../cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md).

1. Clone the project
   [`steeltoe-weatherforecast` accelerator](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/weatherforecast-steeltoe),
   which provides a sample .NET app that is ready for immediate deployment to Tanzu Application Platform.
2. Go to `weatherforecast-steeltoe`.
3. From the project's root directory, run:

   ```console
   tanzu apps workload apply -f config/workload.yaml
   ```

   By default, this creates a workload from the code in the GitHub repository.
   For more information about deploying from your local source, see the repository README file.

### <a id="start-remote-debug"></a> Start Remote Debug

To start a remote debug, right-click on a project in the Solution Explorer and then click on
**Tanzu: Remote Debug**.

- If no workload pods are running, you are prompted to deploy a new workload.
  If you want to do so, click on **OK** in the dialog box and proceed with the steps in
  [Apply a Workload](#apply-workload).
  After the workload is deployed, click **Tanzu: Remote Debug** again to start debugging.

- If just one workload pod is running, the debugger attaches to your running app process
  automatically.

- If more than one workload pod is running, you are prompted to select the workload that corresponds
  to the project you want to debug. Select the relevant pod name and then click **Begin Debugging**.
  The pod confirmation window then closes and the Output window opens to the Debug Adapter Host Log
  pane as Visual Studio enters debug mode.

Visual Studio prompts the debugging agent to attach to a running app process with the name
`/workspace/DOT-NET-PROJECT-NAME`.

> **Caution** If the name of your running app process (the app DLL process), does not match the name
> of your .NET project as shown in the Visual Studio Solution Explorer, the remote debugging agent
> might fail to attach.

A file named `.tanzu-vs-launch-config.json` is created at the root directory of your project.
This file specifies the configuration needed to attach Visual Studio's debugger to the agent running
in your workload's container.
It is only needed to initiate remote debugging and can be safely deleted at any time.
This file location is temporary and will change in future versions.

### <a id="stop-remote-debug"></a> Stop Remote Debug

Using the red square stop button in Visual Studio's top toolbar can cause the Tanzu Application Platform
workload to fail or become unresponsive indefinitely.
A fix is planned for a future release. In the meantime, open the **Debug** menu and click **Detach All**.

## <a id="troubleshoot"></a> Troubleshooting

This extension records logs in a `.log` file whose name starts with `tanzu-dev-tools` and ends with
a string of numbers representing the date, such as `tanzu-dev-tools20221202.log`.
A new log file is created for each day and retained for a maximum of 31 days.
These log files are in the installation directory of the `.vsix` file.
By default, this is

```text
C:\Users\NAME\AppData\Local\Microsoft\VisualStudio\VERSION\Extensions\VMware\Tanzu Developer Tools\VSIX-VERSION
```

Where `NAME`, `VERSION`, and `VSIX-VERSION` are placeholders.
