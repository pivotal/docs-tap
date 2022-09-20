# Getting Started with Tanzu Dev Tools for IntelliJ

This topic describes how to set up the Tanzu Developer Tools for IntelliJ extension for your project.

## <a id="overview"></a> Overview

To use the Tanzu Developer Tools for IntelliJ extension with your project, the project
requires three files:

- `workload.yaml`
- `catalog-info.yaml`
- `Tiltfile`

You can create these files manually using the instructions in this topic,
or use the files in the [View an example project](#example-project) section.

## <a id="prereqs"></a> Prerequisites

Before you get started, ensure you have completed [Installing Tanzu Developer Tools for IntelliJ](install.md).

## <a id="create-workload-yaml"></a> Create the workload.yaml file

In your project, you must include a file named `workload.yaml`, for example, `my-project/config/workload.yaml`.

The `workload.yaml` file provides instructions to the Supply Chain Choreographer
about how to build and manage a workload.
For more information, see the [Supply Chain Choreographer](../scc/about.md) documentation.

>**Note:** The Tanzu Developer Tools for IntelliJ extension requires only one `workload.yaml`
>file per project.
>The `workload.yaml` must be a single-document YAML file, not a multi-document YAML file.

### <a id="example-workload-yaml"></a> Example workload.yaml

The following is an example `workload.yaml`:

```yaml
apiVersion: carto.run/v1alpa1
kind: Workload
metadata:
 name: APP-NAME
 labels:
   apps.tanzu.vmware.com/workload-type: WORKLOAD-TYPE
   app.kubernetes.io/part-of: APP-NAME
spec:
 source:
   git:
     url: GIT-SOURCE-URL
     ref:
       branch: GIT-BRANCH-NAME
```

Where:

- `APP-NAME` is the name of your application. For example, `my app`.
- `WORKLOAD-TYPE` is the type of workload for your app. For example, `web`.
For more information, see [Workload types](../workloads/workload-types.md).
- `GIT-SOURCE-URL` is the Git source code URL for your app. For example, `github.com/mycompany/myapp`.
- `GIT-BRANCH-NAME` is the branch of the Git source code you want to use. For example, `main`.

Alternatively you can use the Tanzu CLI to create a `workload.yaml` file.
For more information about the Tanzu CLI command, see [Tanzu apps workload create](../cli-plugins/apps/command-reference/tanzu-apps-workload-create.md)
in the Tanzu CLI documentation.

## <a id="create-catalog-info-yaml"></a> Create the catalog-info.yaml file

In your project, you must include a file named `catalog-info.yaml`, for example, `my-project/catalog/catalog-info.yaml`.

The `catalog-info.yaml` file enables the workloads created with the
Tanzu Developer Tools for IntelliJ extension to be visible in the Tanzu Application Platform GUI.
For more information, see the [Tanzu Application Platform GUI](../tap-gui/about.md) documentation.

### <a id="example-catalog-info-yaml"></a> Example catalog-info.yaml

The following is an example `catalog-info.yaml`:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
 name: APP-NAME
 description: APP-DESCRIPTION
 tags:
   - tanzu
 annotations:
   'backstage.io/kubernetes-label-selector': 'app.kubernetes.io/part-of=APP-NAME'
spec:
 type: service
 lifecycle: experimental
 owner: default-team
```

Where:

- `APP-NAME` is the name of your application.
- `APP-DESCRIPTION` is a description of your application.

## <a id="create-tiltfile"></a> Create the Tiltfile file

In your project, you must include a file named `Tiltfile` with no extension (no filetype),
for example, `my-project/Tiltfile`.

The `Tiltfile` provides the configuration for Tilt to enable your project to [live update](glossary.md#live-update)
on the Tanzu Application Platform enabled Kubernetes cluster.
For more information, see the [Tilt](https://docs.tilt.dev/) documentation.

> **Note:** The Tanzu Developer Tools for IntelliJ extension requires only one Tiltfile per project.

### <a id="example-tiltfile"></a> Example Tiltfile

The following is an example `Tiltfile`:

```Tiltfile
SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='SOURCE-IMAGE-VALUE')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='default')

k8s_custom_deploy(
   'APP-NAME',
   apply_cmd="tanzu apps workload apply -f PATH-TO-WORKLOAD-YAMl --live-update" +
       " --local-path " + LOCAL_PATH +
       " --source-image " + SOURCE_IMAGE +
       " --namespace " + NAMESPACE +
       " --yes >/dev/null" +
       " && kubectl get workload APP-NAME --namespace " + NAMESPACE + " -o yaml",
   delete_cmd="tanzu apps workload delete -f PATH-TO-WORKLOAD-YAML --namespace " + NAMESPACE + " --yes" ,
   deps=['pom.xml', './target/classes'],
   container_selector='workload',
   live_update=[
       sync('./target/classes', '/workspace/BOOT-INF/classes')
   ]
)

k8s_resource('APP-NAME', port_forwards=["8080:8080"],
   extra_pod_selectors=[{'serving.knative.dev/service': 'APP-NAME'}])
allow_k8s_contexts('CONTEXT-NAME')
```

Where:

- `SOURCE-IMAGE-VALUE` is your [source image](glossary.md#source-image).
- `APP-NAME` is the name of your application.
- `PATH-TO-WORKLOAD-YAML` is the local file system path to your `workload.yaml` file. For example, `config/workload.yaml`.
- `CONTEXT-NAME` is the name of your current
[Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).
If your Tanzu Application Platform enabled Kubernetes cluster is running on your local machine,
you can remove the entire `allow_k8s_contexts` line.
For more information about this line, see the [Tilt documentation](https://docs.tilt.dev/api.html#api.allow_k8s_contexts).

>**Note:** If you want to compile the source image from a local directory other than the
>project directory, change the value of `local path`.
>For more information, see [local path](glossary.md#local-path) in the glossary.

## <a id="example-project"></a> View an example project

There are two ways to view a sample application that demonstrates the necessary configuration files.

Before you begin, you will need a container image registry to use the sample application.

### <a id="example-app-acc"></a>  Option 1: Application Accelerator

If your company has configured Application Accelerator, you can use it to obtain the sample
application if the application has not been removed.
For more information about Application Accelerator, see [Application Accelerator](../application-accelerator/about-application-accelerator.md).

To view the example using Application Accelerator:

1. Open Application Accelerator. The Application Accelerator location varies based on
where your company placed it. Contact the appropriate team to determine its location.

1. Search for “Tanzu Java Web App” in the Application Accelerator.

1. Add the required configuration information and generate the application.

1. Unzip the application and open the directory in IntelliJ.

### <a id="example-github-clone"></a> Option 2: Clone from GitHub

To clone the example from GitHub:

1. Use `git clone` to clone the [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app)
repository from GitHub.

1. Open the `Tiltfile` and replace `your-registry.io/project` with your registry.

## <a id="whats-next"></a> Next steps

- [Using the Tanzu Developer Tools for IntelliJ extension](using-the-extension.md).
