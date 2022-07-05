# Using Tanzu Dev Tools to get started

## <a id="before-beginning"></a> Before Beginning

Ensure you have completed the [Installation page](installation.md) before starting this page.

## <a id="set-up-tanzu-dev-tools"></a> Set Up Tanzu Dev Tools

In order to use the Tanzu Developer Tools extension with a project, the project must have 3 required files. The three files can be created manually (link to Set Up Manually section), or will be included in the sample applications detailed below. The required files are:

1. **workload.yaml**

    A file named **workload** with the extension **.yaml** must be included in the project (Eg. `my project/config/workload.yaml`). The **workload.yaml** file provides instructions to the [Supply Chain Choreographer](https://github.com/pivotal/docs-tap/blob/main/scc/about.md) for how a workload should be built and managed.

    > **Note:** The Tanzu Developer Tools extension requires only one workload.yaml per project. The workload.yaml must be a single-document YAML file, not a multi-document YAML file.

1. **catalog-info.yaml**

    A file named **catalog-info** with the extension **.yaml** must be included in the project. (Eg. `my project/catalog/catalog-info.yaml`). The **catalog-info.yaml** file enables the workloads created with the Tanzu Developer Tools extension to be visible in the [TAP GUI](https://github.com/pivotal/docs-tap/blob/main/tap-gui/about.md).

1. **Tiltfile**

    A file named **Tiltfile** with no extension (no filetype) must be included in the project. (Eg. `My project/Tiltfile`). The **Tiltfile** provides the configuration for [Tilt](https://docs.tilt.dev/) to enable your project to live update on the Tanzu Application Platform.
    
    > **Note:** The Tanzu Developer Tools extension requires only one Tiltfile per project.


### <a id="creating-a-workload-yaml-file"></a> Creating a **workload.yaml** File

The “workload.yaml” file provides instructions to the Supply Chain Choreographer for how a workload should be built and managed.

> **Note:** The Tanzu Developer Tools extension requires only one workload.yaml per project. The workload.yaml must be a single-document [YAML](glossary.md#yaml) file, not a multi-document YAML file.

Before beginning to write your workload.yaml file, ensure you:

- Know what you will name your application (eg. `my app`)
- Know what type of workload the app will be (eg. `web`, see [Workload in the Glossary](glossary.md#workload) for more information)
- Have the git source code URL (eg. `github.com/mycompany/myapp`)
- Know which branch of the git source code you will use (eg. `main`)

The following is an example **workload.yaml** file:

```
apiVersion: carto.run/v1alpa1
kind: Workload
metadata:
 name: <app-name>
 labels:
   apps.tanzu.vmware.com/workload-type: <workload-type>
   app.kubernetes.io/part-of: <app-name>
spec:
 source:
   git:
     url: <git-source-url>
     ref:
       branch: <git-branch-name>
```

Certain sections of the example **workload.yaml** file above must be replaced with your values for it to function:

- Replace `<app-name>` with the name of your application
- Replace `<workload-type>` with the type of this workload (eg. web, see [Workload in the Glossary](glossary.md#workload) for more information)
- Replace `<git-source-url>` with your git source code URL
- Replace `<git-branch-name>` with the branch of your git source code you want to use

Alternatively you can use the Tanzu CLI to create a workload.yaml file. For more information about the Tanzu CLI command, see [Tanzu apps workload create in the Tanzu CLI documentation](https://github.com/pivotal/docs-tap/blob/main/cli-plugins/apps/command-reference/tanzu-apps-workload-create.md).

### <a id="creating-a-catalog-info-yaml-file"></a> Creating a **catalog-info.yaml** File

The **catalog-info.yaml** file enables the [workloads](glossary.md#workload) created with this project to be visible in the [TAP GUI](https://github.com/pivotal/docs-tap/blob/main/tap-gui/about.md).

Before beginning to write your **catalog-info.yaml** file, ensure you:

- Know what you will name the workload (eg. `my app`)
- Have a description of your application ready.

The following is an example **catalog-info.yaml** file:

```
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
 name: <app-name>
 description: <app-description>
 tags:
   - tanzu
 annotations:
   'backstage.io/kubernetes-label-selector': 'app.kubernetes.io/part-of=<app-name>'
spec:
 type: service
 lifecycle: experimental
 owner: default-team
```

Certain sections of the example **catalog-info.yaml** file above must be replaced with your values for it to function:

- Replace both occurrences of `<app-name>` with the name of your application
- Replace `<app-description>` with a description of your application

### <a id="creating-a-tiltfile-file"></a> Creating a **Tiltfile** File

The **Tiltfile** file enables the configuration for [Tilt](https://docs.tilt.dev/) to enable your project to [live update](glossary.md#live-update) on your Tanzu Application Platform enabled Kubernetes cluster.

> **Note:** The Tanzu Developer Tools extension requires only one **Tiltfile** per project.

Before beginning to write your **Tiltfile** file, ensure you:

- Know what you will name your application (eg. `my app`)
- Know the [source image](glossary.md#source-image) value (eg. `docker.io/mycompany/myapp`)
- Know whether you want to compile the source image from a local directory other than the project directory, otherwise leave the `local path` value unchanged (for more information see [local path](glossary.md#local-path) in the glossary)
- Know the path to your `workload.yaml` file (eg. `config/workload.yaml`)
- If the TAP-enabled Kubernetes cluster you’re targeting is not running on your local machine, know the name of your current [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).


The following is an example **Tiltfile** file:

```
SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='<source-image>')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='default')

k8s_custom_deploy(
   '<app-name>',
   apply_cmd="tanzu apps workload apply -f <path-to-workload-yaml> --live-update" +
       " --local-path " + LOCAL_PATH +
       " --source-image " + SOURCE_IMAGE +
       " --namespace " + NAMESPACE +
       " --yes >/dev/null" +
       " && kubectl get workload <app-name> --namespace " + NAMESPACE + " -o yaml",
   delete_cmd="tanzu apps workload delete -f <path-to-workload-yaml> --namespace " + NAMESPACE + " --yes" ,
   deps=['pom.xml', './target/classes'],
   container_selector='workload',
   live_update=[
       sync('./target/classes', '/workspace/BOOT-INF/classes')
   ]
)

k8s_resource('<app-name>', port_forwards=["8080:8080"],
   extra_pod_selectors=[{'serving.knative.dev/service': '<app-name>'}])
allow_k8s_contexts('<context-name>')
```

Certain sections of the example **Tiltfile** file above must be replaced with your values for it to function:

- Replace `<source-image>` with the [source image](glossary.md#source-image) value
- Replace all 4 occurrences of `<app-name>` with the name of your application
- Replace both occurrences of `<path-to-workload-yaml>` with the local file system path to your **workload.yaml** file (eg. `config/workload.yaml`)
- Replace `<context-name>` with the name of your current [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/). If your TAP-enabled Kubernetes cluster is running locally on your machine, the entire `allow_k8s_contexts` line can be removed. For more information on this line see the [Tilt documentation](https://docs.tilt.dev/api.html#api.allow_k8s_contexts).

### <a id="example-project"></a> Example Project

If you’d like to view a sample application which demonstrates the necessary configuration files there are two ways you can obtain the sample application.

Before you begin, you will need a [container registry](glossary.md#container-registry) to use the sample application.

**Option 1: Application Accelerator**

If your company has configured [Application Accelerator](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/index.html) you can obtain the sample application there (as long as it has not been removed).

1. Open Application Accelerator (the application accelerator location will vary based on where your company placed it, contact the appropriate team to determine its location)
1. Search for “Tanzu Java Web App” in the Application Accelerator.
1. Add the required configuration information and generate the application.
1. Unzip the application and open the directory in IntelliJ

**Option 2: Clone from GitHub**

1. Use `git clone` to clone the [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app) repository from GitHub.
1. Open the `Tiltfile` and replace `your-registry.io/project` with your container registry.

## <a id="whats-next"></a> What's Next

When finished on this page, proceed to the [Using the Extension](using-the-extension.md) page.

---
## <a id="known-issues"></a> Known Issues

If you encounter any issues while using the plugin please refer to the [Known Issues](known-issues.md) page.