# Known Issues

## Only supports using a single IntelliJ window
- You may see a notification that the Tanzu Language Server has failed to start. Check that you only have one IntelliJ Project open in a single window. Try close the other windows, quitting IntelliJ, and trying again.

## Workload File Path and Local Path properties on Tanzu Debug and Tanzu Live Update Run Configurations must be fully qualified paths
- Ensure the `Workload File Path` and `Local Path` properties on your debug and live update configurations are the fully qualified paths. You can use the file picker provided on each input field to help enter correct values.