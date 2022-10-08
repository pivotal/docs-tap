# Troubleshooting Tanzu Developer Tools for IntelliJ

This topic describes what to do when encountering issues with Tanzu Developer Tools for IntelliJ.

## <a id="cannot-view-workloads"></a> Unable to view workloads on the panel when connected to GKE cluster

{{> 'partials/ext-tshoot/cannot-view-workloads' }}

## <a id='lu-not-working-wl-types'></a> Live update might not work when using server or worker Workload types

{{> 'partials/ext-tshoot/lu-not-working-wl-types' }}

## <a id="dsbl-lnch-ctrl"></a> Disabled launch controls after running a launch configuration

### Symptom

When a user runs or debugs a launch configuration, IntelliJ disables the launch controls.

### Cause

IntelliJ disables the launch controls to prevent other launch configurations from being launched at
the same time.
These controls are reactivated when the launch configuration is started.
As such, starting multiple Tanzu debug and live update sessions is a synchronous activity.
