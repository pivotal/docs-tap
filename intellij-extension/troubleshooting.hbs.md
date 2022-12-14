# Troubleshoot Tanzu Developer Tools for IntelliJ

This topic describes what to do when encountering issues with Tanzu Developer Tools for IntelliJ.

## <a id="debug-reapplies-apply"></a> Tanzu Debug re-applies the workload when namespace field is empty

### Symptoms

If the `namespace` field of the debug launch configration is empty, it will re-apply the workload even if it exists on the cluster.

### Cause

Internally we gather Workloads in the cluster in the current namespace and compare it with the info specified by the user.
If the `namespace` field is empty, it will be considered `null` and our internal checks fail.

### Solution

Do not leave the `namespace` field blank.

## <a id="debug-config-from-dropdown"></a> Debug configurations created from launch configurations dropdown re-applies workload

### Symptoms

If your debug configuration is created from the launch configurations dropdown, it will re-apply the workload, even if it exists on the cluster.

### Cause

There is internal logic that is not run when a debug configuration is created from the dropdown. However, it is run when a debug configuration is created from the right-click context menu.

### Solution

Create a debug configuration from the right-click context menu.

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

## <a id='dbg-fail-crrpt-lnch-conf'>Starting a Tanzu Debug session fails with `Unable to open debugger port`

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
