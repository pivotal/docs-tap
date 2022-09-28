# Troubleshooting Tanzu Developer Tools for VS Code

## <a id='cannot-config-task'></a> Unable to to configure task

### Symptom

After launching `Extension Host`, you cannot configure `tasks` in a workspace that does not contain
workload YAML files.

### Solution

Re-install the Tanzu Developer Tools for VS Code extension.

## <a id='no-auto-install-ext-pack'></a> Extension Pack for Java has not automatically installed

### Symptom

The Extension Pack for Java (`vscjava.vscode-java-pack`) hasn't automatically installed.
This prevents debugging from working after Tanzu Developer Tools for VS Code installs `live-update`.

### Solution

Manually install `vscjava.vscode-java-pack` from the extension marketplace.
