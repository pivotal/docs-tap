# Troubleshoot Tanzu Developer Tools for IntelliJ

This topic describes what to do when encountering issues with Tanzu Developer Tools for IntelliJ.

## <a id="debug-reapplies-apply"></a> Tanzu Debug re-applies the workload when namespace field is empty

### Symptoms

If the `namespace` field of the debug launch configuration is empty, the workload is re-applied even
if it exists on the cluster.

### Cause

Internally, workloads are gathered in the cluster in the current namespace and compared with the
information that the user specifies.
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

{{> 'partials/ext-tshoot/cannot-view-workloads' }}

## <a id="dsbl-lnch-ctrl"></a> Deactivated launch controls after running a launch configuration

### Symptom

When a user runs or debugs a launch configuration, IntelliJ deactivates the launch controls.

### Cause

IntelliJ deactivates the launch controls to prevent other launch configurations from being launched at
the same time.
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

{{> 'partials/ext-tshoot/timeout-err-live-updating' }}