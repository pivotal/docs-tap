# Troubleshoot Tanzu Developer Tools for IntelliJ

This topic helps you troubleshoot issues with Tanzu Developer Tools for IntelliJ.

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

## <a id="panel-empty-kubeconfig"></a> Tanzu Panel is empty when the context is set by using the `KUBECONFIG` environment variable

### Symptom

On macOS, the Tanzu Panel doesn't display workloads or any other resources when setting the Kubernetes
context by using a `KUBECONFIG` environment variable.
Other tools, such as the [Tanzu CLI Apps plug-in](../cli-plugins/apps/overview.hbs.md), display
resources correctly.

### Cause

When starting IntelliJ from Dock or Spotlight, environment variables set by using `.profile`,
`.bash_profile`, or `.zshrc` are not available.
This causes the panels to be empty because the extension can't find the right Kubernetes context.
For more information, see this [YouTrack issue](https://youtrack.jetbrains.com/issue/IDEA-99154).

### Solution

Open IntelliJ from the CLI. For example:

```console
open /Applications/IntelliJ\ IDEA.app
```

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

## <a id="tnz-panel-actions-unavail"></a> Tanzu Workloads panel workloads only have describe and delete action

{{> 'partials/ide-extensions/ki-tnz-panel-actions-unavail' }}

## <a id="projects-with-spaces"></a> Workload actions do not work when in a project with spaces in the name

{{> 'partials/ide-extensions/ki-projects-with-spaces' }}

## <a id="lock-prevents-live-update"></a> A lock wrongly prevents Live Update from starting again

### Symptom

A lock incorrectly shows that Live Update is still running and prevents Live Update from starting again.

### Cause

Restarting your computer while running Live Update without terminating the Tilt process beforehand.

### Solution

Delete the Tilt lock file. The default location for the file is `~/.tilt-dev/config.lock`.

## <a id="ui-liveness-check-error"></a> UI liveness check causes an EDT Thread Exception error

### Symptom

An **EDT Thread Exception** error is logged or reported as a notification with a message similar to
`"com.intellij.diagnostic.PluginException: 2007 ms to call on EDT TanzuApplyAction#update@ProjectViewPopup"`.

### Cause

A UI liveness check detected something taking more time than planned on the UI thread and
freezing the UI. You might experience a brief UI freeze at the same time.
This happens more commonly when starting IntelliJ because some initialization processes are still
running. This issue is also commonly reported by users with large projects.

If slow startup processes cause the issue, the UI freeze is likely to be brief.
If a large number of files causes the issue, the UI freeze is likely to be more severe.

### Solution

There is no workaround currently other than trying to reduce the number of files in your project,
though that might not be practical in some cases. A fix is planned for the next release.

## <a id="dsbl-lnch-ctrl"></a> Frequent application restarts

### Symptom

When an application is applied from Intellij it restarts frequently.

### Cause

Application or environment behaviors triggering the application to restart on a periodic basis.

Observed trigger behaviors:
- The application itself writing logs to the filesystem into the application directory that live update is watching
- In their IDE configuration the user has autosave settings tuned to very high frequencies

### Solution

The solution depends on the trigger but can be generically described as preventing the trigger behaviors.  For example, 12-factor applications should not be writing to filesystem.  Developers usually do not require very high frequency autosaves.  Once every few minutes if sufficent.