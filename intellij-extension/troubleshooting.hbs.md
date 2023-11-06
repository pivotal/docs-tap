# Troubleshoot Tanzu Developer Tools for IntelliJ

This topic helps you troubleshoot issues with Tanzu Developer Tools for IntelliJ.

## <a id="debug-reapplies-apply"></a> Tanzu Debug re-applies the workload when namespace field is empty

### Symptoms

If the `namespace` field of the debug launch configuration is empty, the workload is re-applied even
if it exists on the cluster.

### Cause

Internally, workloads are gathered in the cluster in the current namespace and compared with the
information that you specify.
If the `namespace` field is empty, it is considered `null` and the internal checks fail.

### Solution

Do not leave the `namespace` field blank.

## <a id="debug-confg-from-dropdown"></a> Workload is wrongly re-applied because of debug configuration selected from the launch configuration drop-down menu

### Symptoms

If your debug configuration is created from the launch configuration drop-down menu, it re-applies
the workload even if the workload already exists on the cluster.

### Cause

There is internal logic that is not run when debug configuration is created from the drop-down menu.
However, the logic is run when debug configuration is selected from the right-click pop-up menu.

### Solution

Select debug configuration from the right-click pop-up menu.

## <a id="cannot-view-workloads"></a> Unable to view workloads on the panel when connected to GKE cluster

{{> 'partials/ide-extensions/ki-cannot-view-workloads' }}

## <a id="dsbl-lnch-ctrl"></a> Deactivated launch controls after running a launch configuration

### Symptom

When you run or debug a launch configuration, IntelliJ deactivates the launch controls.

### Cause

IntelliJ deactivates the launch controls to prevent other launch configurations from being launched
at the same time.
These controls are reactivated when the launch configuration is started.
As such, starting multiple Tanzu debug and live update sessions is a synchronous activity.

## <a id='dbg-fail-crrpt-lnch-conf'></a> Starting a Tanzu Debug session fails with `Unable to open debugger port`

### Symptom

You try to start a Tanzu Debug session and it immediately fails with an error message similar to:

```console
Error running 'Tanzu Debug - fortune-teller-fortune-service': Unable to open debugger port (localhost:5005): java.net.ConnectException "Connection refused"
```

### Cause

Old Tanzu Debug launch configurations sometimes appear to be corrupted after installing a later
version of the plug-in.
You can see whether this is the problem you are experiencing by opening the launch configuration:

1. Right-click `workload.yaml`.
1. Click **Modify Run Configuration...** in the menu.
1. Scroll down and expand the **Before Launch** section of the dialog.
1. Verify that it contains the two Unknown Task entries
   `com.vmware.tanzu.tanzuBeforeRunPortForward` and `com.vmware.tanzu.tanzuBeforeRunWorkloadApply`.

Because these two tasks are unknown causes, these steps of the debug launch are not run.
This in turn means that the target application is not deployed and accessible on the expected port,
which causes an error when the debugger tries to connect to it.

It might be that although the launch configuration appears corrupt when seen in the launch config
editor, in fact there is no corruption.
It's suspected that this problem only occurs when you install a new version of the plug-in and start
using it before first restarting IntelliJ.

There is possibly an issue in the IntelliJ platform that prevents completely or correctly initializing
the plug-in when the plug-in is hot-swapped into an active session instead of loaded on startup.

### Solution

Closing and restarting IntelliJ typically fixes this problem.
If that doesn't work for you, delete the old corrupted launch configuration and recreate it.

## <a id="live-update-timeout"></a> Timeout error when Live Updating

{{> 'partials/ide-extensions/ki-timeout-err-live-updating' }}

## <a id="panel-empty-gke"></a> Tanzu Panel empty when using a GKE cluster on macOS

### Symptom

On macOS, the Tanzu Panel doesn't display workloads or any other resources when using a GKE cluster.
Other tools, such as the [Tanzu CLI Apps plug-in](../cli-plugins/apps/overview.hbs.md), display
resources correctly.

### Cause

`gke-cloud-auth-plugin` is required to properly authenticate to a GKE cluster.
However, when starting IntelliJ from Dock or Spotlight, environment variables set by using
`.profile`, `.bash_profile`, or `.zshrc` are not available. For more information, see this
[YouTrack issue](https://youtrack.jetbrains.com/issue/IDEA-99154).

This might cause `gke-cloud-auth-plugin` to be missing from `PATH` when launching IntelliJ and prevent
the Tanzu Panel from reaching the cluster.

### Solution

Open IntelliJ from the CLI. Example command:

```console
open /Applications/IntelliJ\ IDEA.app
```

## <a id="describe-action-fail"></a> The Describe action in the Activity panel fails when used on PodIntent resources

### Symptom

The pop-up menu **Describe** action in the Activity panel fails when used on PodIntent resources.
The error message is similar to the following:

   ```console
   Warning: conventions.apps.tanzu.vmware.com/v1alpha1 PodIntent is deprecated; \
   use conventions.carto.run/v1alpha1 PodIntent instead
   Error from server (NotFound): podintents.conventions.apps.tanzu.vmware.com "my-app" not found

   Process finished with exit code 1
   ```

### Cause

When there are multiple resource types with the same kind, attempting to describe a resource of that
kind without fully qualifying the API version causes this error.

### Solution

There is no workaround for this issue at present. A fix is planned for this issue in the next version.

## <a id="tnz-panel-k8s-rsrc-fail"></a> Tanzu panel shows workloads but doesn't show Kubernetes resources

### Symptom

The Tanzu panel shows workloads but doesn't show Kubernetes resources in the center panel of the
activity pane.

### Cause

When switching the Kubernetes context, the activity pane doesn't automatically update the namespace,
but the workload pane detects the new namespace.
Therefore, the Tanzu panel shows workloads but doesn't show Kubernetes resources in the center panel
of the activity pane.

### Solution

Restart IntelliJ to properly detect the context change.

## <a id="live-update-jammy-fail"></a> Live Update does not work with the Jammy `ClusterBuilder`

{{> 'partials/ide-extensions/ki-live-update-jammy' }}

## <a id="freq-app-restarts"></a> Frequent application restarts

### Symptom

When an application is applied from IntelliJ it restarts frequently.

### Cause

An application or environment behavior is triggering the application to restart.

Observed trigger behaviors include:

- The application itself writing logs to the file system in the application directory that Live Update
  is watching
- Autosave being set to a very high frequency in the IDE configuration

### Solution

Prevent the trigger behavior. Example solutions include:

- Prevent 12-factor applications from writing to the file system.
- Reduce the autosave frequency to once every few minutes.