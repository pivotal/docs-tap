# Troubleshooting Tanzu Developer Tools for IntelliJ

This topic describes what to do when encountering issues with Tanzu Developer Tools for IntelliJ.

## <a id="debug-ends-early"></a> First debugging session ends prematurely

{{> 'partials/ext-tshoot/debug-ends-early' }}

## <a id='no-support-multi-windows'></a> No support for multiple IntelliJ windows

**Symptom:** A notification appears saying that the Tanzu Language Server has failed to start.

**Cause:** You have more than one IntelliJ Project open in a single window.

**Solution:** Close the other windows, quit IntelliJ, and re-open IntelliJ.

## <a id='unqual-paths'></a> Unqualified paths for Workload File Path and Local Path properties

**Symptom:** Debug and Live Update are unable to find their paths

**Cause:** Unqualified paths for the Workload File Path and Local Path properties on Tanzu Debug and
Tanzu Live Update Run Configurations.

**Solution:** Make the Workload File Path and Local Path properties on your Debug and Live Update
configurations the fully qualified paths. Use the file picker on each input field to help you
enter the correct values.

## <a id='cannot-view-workloads'></a> Unable to view workloads on the panel when connected to GKE cluster

{{> 'partials/ext-tshoot/cannot-view-workloads' }}

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
