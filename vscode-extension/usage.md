---
title: Using Tanzu Developer Tools for Visual Studio Code
subtitle: Using Tanzu Developer Tools for Visual Studio Code
weight: 2
---

This topic explains how to use the Tanzu Developer Tools extension for Visual Studio Code.
For a more detailed step-by-step walk-through, see Getting Started instructions](../getting-started.md).

# Usage

### Configure extension settings

You must configure the following required Visual Studio Code settings for your app.

To configure Visual Studio Code settings for your app:

  1. Go to **Preferences -> Settings -> Extensions -> Tanzu**.
  2. For Source Image, enter the destination for an image containing source code to be
  published.
  For Local Path, enter the path on the local file system to a directory of code to build.

## Live update

Live update requires a workload.yaml file and a Tiltfile.
You can generate a sample Java app that includes these files by using
Application Accelerator. Alternately, you can create them manually as follows.

### Creating a workload.yaml file

The easiest way to create a workload.yaml file is to use the Tanzu CLI, for example:

```
tanzu apps workload create my-workload --git-repo https://example.com/my-workload.git > workload.yaml
```

See the [Tanzu CLI docs](../cli-plugins/apps/command-reference/tanzu_apps_workload_create.md) for all CLI options.

### Creating a Tiltfile

The following is an example Tiltfile:

```
SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='<source-image>')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='default')

k8s_custom_deploy(
    '<app-name>',
    apply_cmd="tanzu apps workload apply -f <path-to-workload> --live-update" +
               " --local-path " + LOCAL_PATH +
               " --source-image " + SOURCE_IMAGE +
               " --namespace " + NAMESPACE +
               " --yes >/dev/null" +
               " && kubectl get workload <app-name> --namespace " + NAMESPACE + " -o yaml",
    delete_cmd="tanzu apps workload delete -f <path-to-workload> --namespace " + NAMESPACE + " --yes",
    deps=['pom.xml', './target/classes'],
    container_selector='workload',
    live_update=[
      sync('./target/classes', '/workspace/BOOT-INF/classes')
    ]
)

k8s_resource(<app-name>, port_forwards=["8080:8080"],
            extra_pod_selectors=[{'serving.knative.dev/service': <app-name>}])
```

Update the following parameters in the preceding example:

  1. <source-image>: Destination for an image containing source code to be published.
  2. <app-name>: The name of the application.
  3. <path-to-workload>: Path to a file containing the workload resource for your application.

If you're targeting a remote cluster, add the following to the Tiltfile:

```
allow_k8s_contexts('context-name')
```

See [Tilt docs](https://docs.tilt.dev/api.html#api.allow_k8s_contexts)

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

## Debug

Right-click your workload.yaml and select **Tanzu: Java Debug Start**.
