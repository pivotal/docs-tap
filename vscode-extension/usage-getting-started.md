# Using Tanzu Dev Tools to get started

This topic explains how to use the VMware Tanzu Developer Tools for Visual Studio Code.
For a more detailed step-by-step walk-through, see [Getting Started instructions](../getting-started.md).

## <a id='snippets'></a>Get set up with snippets

Code snippets allow you to add the config files necessary to develop against the Tanzu Application Platform (TAP) to existing projects. There are three files you will need to create. Once you select a file, you will be guided through the values requiring user input. You can use the `Tab` key to move through those values.

### <a id='snippets-workload'></a> workload.yaml

The workload.yaml file provides instructions to the [Supply Chain Choreographer](../scc/about.md) for how a workload should be built and managed.

It can be triggered by creating a new file of type "YAML" and typing the keywords `tanzu workload`.

> **Note:** If you would like to create your workload.yaml file manually, see the [manual configuration steps](#create-workload) below.

### <a id='catalog-info.yaml'></a> catalog-info.yaml
The catalog-info.yaml file enables the workload(s) created with this project to be visible in the [TAP GUI](../tap-gui/about.md).

It can be triggered by creating a new file of type "YAML" and typing the keywords `tanzu catalog-info` or `component`.

### <a id='snippets-tiltfile'></a>  `Tiltfile`

The Tiltfile provides the configuration for Tilt to enable your project to live update on the Tanzu Application Platform.

It can be triggered by typing the keywords `Tiltfile` or `tanzu tiltfile`. This file should start as a plaintext file, *not* a YAML file.

> **Note:** If you would like to create your Tiltfile manually, see the [manual configuration steps](#create-tiltfile) below.

---

## Get set up - manually
### <a id='create-workload'></a> Creating a workload.yaml file

The easiest way to create a workload.yaml file is to use the Tanzu CLI, for example:

```
tanzu apps workload create my-workload --git-repo https://example.com/my-workload.git > workload.yaml
```

See the [Tanzu CLI docs](../cli-plugins/apps/command-reference/tanzu_apps_workload_create.md) for all CLI options.

### <a id='create-tiltfile'></a> Create a Tiltfile

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

If you're targeting a remote cluster, add the following to the Tiltfile:

```
allow_k8s_contexts('context-name')
```

See [Tilt docs](https://docs.tilt.dev/api.html#api.allow_k8s_contexts) for more information.
