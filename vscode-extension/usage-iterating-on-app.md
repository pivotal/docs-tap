# Using Tanzu Dev Tools to iterate on your workload

> **Note:** The Tanzu Developer Tools extension requires only one Tiltfile and workload.yaml per project.
  These must be single-document YAML files rather than multi-document YAML files.

## <a id="debug"></a> Debug your workload

Debugging requires a `workload.yaml` file in your project.
For information about creating a `workload.yaml` file, see
[workload.yaml](usage-getting-started.md#snippets-workload) in _Using Tanzu Dev Tools to Get Started_.

After you have a `workload.yaml` file in your project, you can debug:

1. Add a breakpoint in your code.

1. Right-click your `workload.yaml`.

1. Select **Tanzu: Java Debug Start**.

## <a id="live-update"></a> Live update your workload

Live update requires a `workload.yaml` file and a `Tiltfile` in your project.

For information about how to create these files, see [Get set up with Snippets](usage-getting-started.md#snippets).


### <a id="start-live-update"></a> Starting Live Update

To start live update, do one of the following:

+ Right-click your project's **Tiltfile** and select **Tanzu: Live Update Start**.

or

+ Start the Command Palette (⇧⌘P) and run the `Tanzu: Live Update Start` command.

### <a id="stop-live-update"></a> Stopping Live Update

To stop live update, do one of the following:

+ Right-click your project's **Tiltfile** and select **Tanzu: Live Update Stop**.

or

+ Start the Command Palette (⇧⌘P) and run the `Tanzu: Live Update Stop` command.

> **Note:** When Live update stops, the application continues to run, but changes will not be present in your running application unless you redeploy it.

### <a id="deactivate-live-update"></a> Deactivate Live Update

To deactivate live update:

1. Start the Command Palette (⇧⌘P).

2. Run the `Tanzu: Live Update Disable` command.

3. Enter the name of the workload you want to deactivate live update for.

>**Note:** This redeploys your workload to the cluster and removes the live update capability.

## <a id="switch-namespace"></a> Switch a namespace

To switch the namespace that your workload is created in:

1. Navigate to the Nanzu settings: **Preferences** -> **Settings** -> **Tanzu**.

2. In the Namespace option, add the namespace you want to deploy to.
   This defaults to the `default` namespace.
