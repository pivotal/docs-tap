## Documentation

### Apply Workload

###### Requirements:
* `tanzu` command in `PATH`.
* A valid `workload.yaml` file in the project ([spec](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-cli-plugins-apps-command-reference-commands-details-workload_create_update_apply.html)).
* A functional TAP environment.
* Kube config is properly configured for TAP workload deployments (e.g. preferred `namespace` is set, etc.).
* An image repository where source code can be staged before being built.

###### Applying a Workload:
* Right-click the Project node or any file node in the Solution Explorer.
* Click "Tanzu: Apply Workload".
* Specify an address to your image repository in the confirmation pop-up.
* Optionally adjust additional settings for the `apply`: path to your local source code, k8s namespace, and path to `workload.yaml`.
  * If a `workload.yaml` file exists somewhere in the project file structure, it will be used by default.
* Click "Apply Workload".
* Output can be seen in the "Tanzu Output" pane of Visual Studio's Output tool window.

More info in our [Wiki](https://github.com/vmware-tanzu/tanzu-developer-tools-for-visual-studio/wiki/Deploying-workloads-to-TAP)!

### Delete Workload

###### Requirements:
* `tanzu` command in `PATH`.
* A running TAP workload.
* A valid `workload.yaml` file in the project, describing the workload to delete.

###### Deleting a Workload:
* Right-click the Project node or any file node in the Solution Explorer.
* Click "Tanzu: Delete Workload".
* If a `workload.yaml` exists somewhere in the project file structure, it will be used to delete the workload via `tanzu apps workload delete --file={workload_path} --yes`

### Live Update

###### Requirements:
* Project with a `Tiltfile` in the project root.
* `tilt` command in `PATH`.
* `tanzu` command in `PATH`.

###### Starting Live Update:
* Right click on `Tiltfile`, select _Tanzu: Start Live Update_.

###### Stopping Live Update:
* Right click on `Tiltfile`, select _Tanzu: Stop Live Update_.


#### Rogue tilt Processes

If a `tilt` process is already running and you try to start Live Update, you'll get a message in the Tanzu Output window like:

```
Error: listen tcp 127.0.0.1:10350: bind: Only one usage of each socket address (protocol/network address/port) is normally permitted.

```

To resolve, kill any running `tilt` processes.  The following is a PowerShell snippet, but a similar result can be obtained using Task Manager.

```
Get-Process "tilt" | ForEach-Object { $_.kill() }
```

### Remote Debug

###### Requirements:
* A running .NET workload in TAP.
* `tanzu` command in `PATH`.
* `kubectl` command in `PATH`.

###### Getting a workload running in TAP:
* The `tanzu` cli `apps` plugin facilitates pushing workloads to TAP via `workload apply` ([read all about it here](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-cli-plugins-apps-command-reference-commands-details-workload_create_update_apply.html?)).
* The [`steeltoe-weatherforecast` accelerator](https://github.com/sample-accelerators/steeltoe-weatherforecast) provides a sample .NET app which is ready to be deployed to TAP out-of-the-box.
  * Clone `https://github.com/sample-accelerators/steeltoe-weatherforecast.git`
  * From the project's root directory, invoke `tanzu apps workload apply -f config/workload.yaml`
    * NOTE: by default this will create workload from the code in the GitHub repo. More info on deploying from your local source can be found in the [docs](https://github.com/sample-accelerators/steeltoe-weatherforecast#deploying-to-kubernetes-as-a-tap-workload-with-tanzu-cli).

###### Starting Remote Debug:
* Right click on a project in the Solution Explorer, select _Tanzu: Remote Debug_.
* If no workload pods are running, you will be prompted to deploy a new workload. If you'd like to, click 'OK' on the prompt and proceed with the directions in [Applying a Workload](#Applying-a-Workload).
  * Once the workload is finished deploying, click the _Tanzu: Remote Debug_ button again to start debugging.
* If just 1 workload pod is running, the debugger should attach to your running app process automatically (see disclaimer below for an important caveat).
* If more than 1 workload pod is running, you will be prompted to select which one corresponds to the project you'd like to debug. Select the relevant pod name & click "Begin Debugging". You should see the pod confirmation window close and the Output window open to the "Debug Adapter Host Log" pane as Visual Studio enters debug mode. 
> _**NOTE:** Visual Studio will prompt the debugging agent to attach to a running app process with a particular name: `/workspace/{DotNetProjectName}`. By default this should succeed without issue, but if for some reason the name of your running app process (i.e. that of the app DLL) does not match the name of your .NET project as shown in the Visual Studio Solution Explorer, the remote debugging agent may fail to attach._  

> _**NOTE:** A file named `.tanzu-vs-launch-config.json` will be created at the root directory of your project. This file specifies the configuration needed to attach Visual Studio's debugger to the agent running in your workload's container; it is only needed to initiate remote debugging & can be safely deleted at any time. This file location is temporary and will be moved in future versions._

###### Stopping Remote Debug:
***CAREFUL:** Using the red square "stop" button in Visual Studio's top toolbar can cause the TAP workload to either crash or hand indefinitely. We're working on a fix, but in the meantime you should:*
* Open the **Debug** menu and click **Detach All**.

##### Troubleshooting:
This extension records logs in a `.log` file whose name starts with "tanzu-dev-tools" and ends with a string of numbers representing the date (e.g. `tanzu-dev-tools20221202.log`).
A new log file is created for each day and retained for a maximum of 31 days. These log files can be found in the installation directory of the `.vsix` file
(by default this is "C:\Users\\\{name}\AppData\Local\Microsoft\VisualStudio\\\{version}\Extensions\VMware\Tanzu Developer Tools\\\{vsix version}").
