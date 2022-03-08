# Using Tanzu Dev Tools to Get Started

This topic explains how to use the VMware Tanzu Developer Tools for Visual Studio Code.
For a more detailed step-by-step walk-through, see [Getting Started instructions](../getting-started.md).

## <a id="snippets"></a> Set Up with Snippets

Code snippets allow you to add the config files necessary to develop against the Tanzu Application Platform (TAP) to existing projects. You must create three files. After you select a file, you will be guided through the values requiring user input. You can use the `Tab` key to move through those values.

### <a id="snippets-workload"></a> The workload.yaml File

The workload.yaml file provides instructions to the [Supply Chain Choreographer](../scc/about.md) for how a workload should be built and managed.

It can be triggered by creating a new file of type "YAML" and typing the keywords `tanzu workload`.

> **Note:** To create your workload.yaml file manually, see [Set Up Manually](#create-workload) below.

### <a id="catalog-information"></a> The catalog.yaml File

The catalog-info.yaml file enables the workloads created with this project to be visible in the [TAP GUI](../tap-gui/about.md).

It can be triggered by creating a new file of type "YAML" and typing the keywords `tanzu catalog-info` or `component`.

### <a id="snippets-tiltfile"></a> Tiltfile

The Tiltfile provides the configuration for Tilt to enable your project to live update on the Tanzu Application Platform.

It can be triggered by typing the keywords `Tiltfile` or `tanzu tiltfile`. This file should start as a plaintext file, not a YAML file.

> **Note:** To create your Tiltfile manually, see [Create a Tiltfile](#create-tiltfile) below.

---

## <a id="set-up-manually"></a> Set Up Manually

You can manually create a workload.yaml and Tiltfile.

### <a id="create-workload"></a> Creating a workload.yaml File

Use the Tanzu CLI to create a workload.yaml file. For example:

```
tanzu apps workload create my-workload --git-repo https://example.com/my-workload.git > workload.yaml
```

For more information about this Tanzu CLI command, see [Tanzu apps workload create](../cli-plugins/apps/command-reference/tanzu_apps_workload_create.md) in the Tanzu CLI documentation.

### <a id="create-tiltfile"></a> Create a Tiltfile

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

1. `<source-image>`: Destination for an image containing source code to be published.
2. `<app-name>`: The name of the application.
3. `<path-to-workload>`: Path to a file containing the workload resource for your application.

If you target a remote cluster, add the following to the Tiltfile:

```
allow_k8s_contexts('context-name')
```

For more information, see the [Tilt documentation](https://docs.tilt.dev/api.html#api.allow_k8s_contexts).
