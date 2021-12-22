---
title: Using Tanzu Dev Tools to Iterate on your Workload
subtitle: Using Tanzu Dev Tools to Iterate on your Workload
weight: 2
---

# Usage - Iterate on your workload

> **Note:** The Tanzu Developer Tools extension requires only one Tiltfile and workload.yaml per project.
  These must be single-document YAML files rather than multi-document YAML files.

## Debug your Workload

Debugging requires a `workload.yaml` file in your project.
for information about how to create a `workload.yaml` file, see [workload.yaml](usage-getting-started.md#snippets-workload)
in _Using Tanzu Dev Tools to Get Started_.

After you have a `workload.yaml` file in your project, you can debug:

1. Add a breakpoint in your code.

1. Right-click your `workload.yaml`.

1. Select **Tanzu: Java Debug Start**.

## Live update your Workload

Live update requires a `workload.yaml` file and a `Tiltfile` in your project.

For information about how to create these files, see [Get set up with Snippets](usage-getting-started.md#snippets).


### Starting live update

To start live update, do one of the following:

+ Right-click your project's **Tiltfile** and select **Tanzu: Live Update Start**.

or

+ Start the Command Palette (⇧⌘P) and run the `Tanzu: Live Update Start` command.

### Stop live update

To stop live update, do one of the following:

+ Right-click your project's **Tiltfile** and select **Tanzu: Live Update Stop**.

or

+ Start the Command Palette (⇧⌘P) and run the `Tanzu: Live Update Stop` command.

> **Note:** When Live update stops, the application continues to run, but changes won't be present in your running application unless you redeploy it.

### Deactivate live update

To deactivate live update:

1. Start the Command Palette (⇧⌘P).

2. Run the `Tanzu: Live Update Disable` command.

3. Enter the name of the workload you want to deactivate live update for.

>**Note:** This redeploys your workload to the cluster and removes the live update capability.

## Switch a Namespace

To switch the namespace that your workload is created in:

1. Navigate to the Tanzu settings: `Preferences` -> `Settings` -> `Tanzu`.

2. In the Namespace option, add the namespace you want to deploy to.
   This defaults to the `default` namespace.
