# Known Issues

This topic describes known issues with VMware Tanzu Developer Tools for IntelliJ.

## No support for multiple IntelliJ windows

**Symptom:** A notification appears saying that the Tanzu Language Server has failed to start.

**Cause:** You have more than one IntelliJ Project open in a single window.

**Solution:** Close the other windows, quit IntelliJ, and re-open IntelliJ.

## Unqualified paths for Workload File Path and Local Path properties

**Symptom:** Debug and Live Update are unable to find their paths

**Cause:** Unqualified paths for the Workload File Path and Local Path properties on Tanzu Debug and
Tanzu Live Update Run Configurations.

**Solution:** Make the Workload File Path and Local Path properties on your Debug and Live Update
configurations the fully qualified paths. Use the file picker on each input field to help you
enter the correct values.
