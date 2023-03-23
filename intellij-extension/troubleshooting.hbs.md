# Troubleshooting Tanzu Developer Tools for IntelliJ

This topic describes what to do when encountering issues with Tanzu Developer Tools for IntelliJ.

## <a id="debug-ends-early"></a> First debugging session ends prematurely

{{> 'partials/ide-extensions/ki-debug-ends-early' }}

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

{{> 'partials/ide-extensions/ki-cannot-view-workloads' }}

## <a id='lu-not-working-wl-types'></a> Live update might not work when using server or worker Workload types

{{> 'partials/ide-extensions/ki-lu-not-working-wl-types' }}

## <a id="live-update-timeout"></a> Timeout error when Live Updating

{{> 'partials/ide-extensions/ki-timeout-err-live-updating' }}
