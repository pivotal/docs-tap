# Developer Conventions overview

Developer Conventions is a set of conventions that enable your workloads to support live-update
and debug operations in Tanzu Application Platform (commonly known as TAP).

## Prerequisites

- [Tanzu CLI Apps plug-in](../cli-plugins/apps/overview.hbs.md)
- [Tanzu Dev Tools for VSCode](../vscode-extension/about.md) IDE extension.

## <a id='features'></a>Features

### <a id='enable-live-updates'></a>Enabling Live Updates

Developer Conventions modifies your workload to enable live updates in either of the following situations:

- You deploy a workload by using the Tanzu CLI Apps plug-in and include the flag `--live-update=true`.
  For more information about how to deploy a workload with the CLI, see
  [Tanzu apps workload apply](../cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md).
- You deploy a workload by using the `Tanzu: Live Update Start` option through the
Tanzu Developer Tools for VS Code extension. For more information about live updating with the
extension, see [Overview of Tanzu Developer Tools for Visual Studio Code](../vscode-extension/about.md).

When either of the preceding actions take place, the convention behaves as follows:

1. Looks for the `apps.tanzu.vmware.com/live-update=true` annotation on a PodTemplateSpec associated
   with a workload.
2. Verifies that the image to which conventions are applied contains a process that can be live updated.
3. Adds annotations to the PodTemplateSpec to modify the Knative properties `minScale` & `maxScale`
   such that the minimum and maximum number of pods is 1.
   This ensures the eventual running pod is not scaled down to 0 during a live update session.

After these changes are made, you can use the Tanzu Dev Tools extension
or the Tilt CLI to make live update changes to source code directly on the cluster.

### <a id='enable-debug'></a>Enabling debugging

Developer Conventions modifies your workload to enable debugging in either of the following situations:

- You deploy a workload by using the Tanzu CLI Apps plug-in and include the flag `--debug=true`.
  For more information about how to deploy a workload with the CLI, see
  [Tanzu apps workload apply](../cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md).
- You deploy a workload by using the `Tanzu Java Debug Start` option through the
  Tanzu Developer Tools for VS Code extension. For more information about debugging with the extension,
  see [Overview of Tanzu Developer Tools for Visual Studio Code](../vscode-extension/about.md).

When either of the preceding actions take place, the convention behaves as follows:

1. It looks for the `apps.tanzu.vmware.com/debug=true` annotation on a PodTemplateSpec associated with
   a workload.
2. It checks for the `debug-8` or `debug-9` labels on the image configuration's bill of materials (BOM).
3. It sets the TimeoutSeconds of the Liveness, Readiness, and Startup probes to 600 if currently set
   to a lower number.
4. It adds annotations to the PodTemplateSpec to modify the Knative properties `minScale` & `maxScale`
   such that the minimum and maximum number of pods is 1.
   This ensures the eventual running pod won't be scaled down to 0 during a debug session.

After these changes are made, you can use the Tanzu Dev Tools extension or other CLI-based debuggers
to debug your workload directly on the cluster.

> **Note** Currently, Developer Conventions only supports debug operations for Java applications.

## <a id='next-steps'></a> Next steps

- [Install Developer Conventions](install-dev-conventions.md)
