# Troubleshooting Tanzu Developer Tools for VS Code

This topic describes what to do when encountering issues with Tanzu Developer Tools for VS Code.

## <a id="debug-ends-early"></a> First debugging session ends prematurely

{{> 'partials/ext-tshoot/debug-ends-early' }}

## <a id='cannot-view-workloads'></a> Unable to view workloads on the panel when connected to GKE cluster

{{> 'partials/ext-tshoot/cannot-view-workloads' }}

## <a id='cancel-action-warning'></a> Warning notification when canceling an action

{{> 'partials/ext-tshoot/cancel-action-warning' }}

## <a id='lu-not-working-wl-types'></a> Live update might not work when using server or worker Workload types

{{> 'partials/ext-tshoot/lu-not-working-wl-types' }}

## <a id="live-update-timeout"></a> Timeout error when Live Updating

### Sympton
When a user attempts to Live Update their workload, they may get the following error in the logs:

`ERROR: Build Failed: apply command timed out after 30s - see }}{{https://docs.tilt.dev/api.html#api.update_settings{{ for how to increase}}`

### Cause

Kubernetes times out on upserts over 30 seconds.

### Solution

Add `update_settings (k8s_upsert_timeout_secs = 300)` to the Tiltfile. See Tiltfile [docs](https://docs.tilt.dev/api.html#api.update_settings).
