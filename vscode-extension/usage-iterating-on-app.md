---
title: Using Tanzu Dev Tools to Iterate on your Workload
subtitle: Using Tanzu Dev Tools to Iterate on your Workload
weight: 2
---

# Usage - Iterate on your Workload

> Note: The Tanzu Developer Tools extension requires **only one** Tiltfile and workload.yaml per project. These must be single-document YAML files rather than multi-document YAML files.

## Debugging your Workload

Debugging requires a `workload.yaml` file in your project. View instructions for how to create a `workload.yaml` file [here](usage-getting-started#workload.yaml).

Once you have a `workload.yaml` file in your project, you can debug by doing the following:

1. Add a breakpoint in your code
1. Right-click your `workload.yaml`
1. Select **Tanzu: Java Debug Start**

## Live Update your Workload

Live update requires a `workload.yaml` file and a `Tiltfile` in your project. View instructions for how to create them [here](usage-getting-started#Getting-set-up-with-Snippets).


### Starting live update

Right-click your project's **Tiltfile** and select **Tanzu: Live Update Start**.

_Or_

Start the Command Palette (⇧⌘P) and run the `Tanzu: Live Update Start` command.

### Stopping live update

Right-click your project's **Tiltfile** and select **Tanzu: Live Update Stop**.

_Or_

Start the Command Palette (⇧⌘P) and run the `Tanzu: Live Update Stop` command.

> **Note:** When Live update stops, the application continues to run, but changes won't be present in your running application unless you redeploy it.

### Disabling live update

Start the Command Palette (⇧⌘P) and run the `Tanzu: Live Update Disable` command, then enter the name of the workload you want to disable live update for.

>**Note:** This redeploys your workload to the cluster and removes the live update capability.

## Switching a Namespace

To switch the namespace that your workload is created in, you will need to:
1. Navigate to the Tanzu settings: `Preferences` -> `Settings` -> `Tanzu`
2. In the Namespace option, add the namespace you wish to deploy to. This will default to the `default` namespace.