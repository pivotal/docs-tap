# Getting Started Using Tanzu Dev Tools

## <a id=on-this-page></a> On this page

- [Before Beginning](#before-beginning)
- [Set Up Tanzu Dev Tools](#set-up-tanzu-dev-tools)
- [Set Up Using Code Snippets](#set-up-using-code-snippets)
- [Set Up Manually](#set-up-manually)
- [Example Project](#example-project)
- [What’s Next](#whats-next)

## <a id="prereqs"></a> Prerequisites

Ensure you have completed the [Installation](../vscode-extension/installation.md) before continuing on to the following sections.

## <a id="set-up-tanzu-dev-tools"></a> Set Up Tanzu Dev Tools

To use the Tanzu Developer Tools extension with a project, the project must have 3 required files. There are two ways to create these files:

- Use the [VS Code Snippets](#catalog-information) that the Tanzu Developer Tools provides. For more information about the Snippets, see the [VS Code Documentation](https://code.visualstudio.com/docs/editor/userdefinedsnippets). 

- Write the three files manually by following [Set Up Manually](#set-up-manually). The required files are:

    - **workload.yaml**
    
        A file named **workload** with the extension **.yaml** must be included in the project. For example, `my project/config/workload.yaml`. The **workload.yaml** file provides instructions to the [Supply Chain Choreographer](../scc/about.md) for how a workload must be built and managed.
        
        >**Note:** The Tanzu Developer Tools extension requires only one workload.yaml per project. The workload.yaml must be a single-document YAML file, not a multidocument YAML file.

    - **catalog-info.yaml**
    
        A file named **catalog-info** with the extension **.yaml** must be included in the project. For example, `my project/catalog/catalog-info.yaml`. The **catalog-info.yaml** file enables the workloads created with the Tanzu Developer Tools extension to be visible in the [TAP GUI](../tap-gui/about.md).

    - **Tiltfile**
    
        A file named **Tiltfile** with no extension (no filetype) must be included in the project. For example, `My project/Tiltfile`. The **Tiltfile** provides the configuration for [Tilt](https://docs.tilt.dev/) to enable your project to live update on the Tanzu Application Platform.
        
        >**Note:** The Tanzu Developer Tools extension requires only one Tiltfile per project.

## <a id="catalog-information"></a> Set Up Using Code Snippets

[Code snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets) enable you to quickly add the files necessary to develop against the Tanzu Application Platform (TAP) to existing projects by creating a template in an empty file which you fill out with the required information. You must create the three files described in the [Set Up Tanzu Dev Tools](#set-up-tanzu-dev-tools) section. After generating the file contents by using the code snippet, you can use the **Tab** key to fill out the required values.

### <a id="the-workload-yaml-file"></a> The **workload.yaml** file

The **workload.yaml** file provides instructions to the Supply Chain Choreographer to build and manage a workload.

>**Note:** The Tanzu Developer Tools extension requires only one workload.yaml per project. The workload.yaml must be a single-document YAML file, not a multidocument YAML file.

Before beginning to write your **workload.yaml** file, ensure that you know:

- the name of your application. For example, `my app`.
- the workload type of your application. For example, `web`.
- the git source code URL. For example, `github.com/mycompany/myapp`.
- the branch of the git source code that you will use. For example, `main`.

To create a workload.yaml file by using the Code Snippets:

1. (Optional) Create a folder named `config` in the root directory of your project. For example, `my project -> config`.
1. Create a file named **workload** with the extension **.yaml** in the new config folder. For example, `my project -> config -> workload.yaml`.
1. Open the new **workload.yaml** file in VS Code, enter `tanzu workload` in the file to trigger the Code Snippets, then either press **return** or left-click the `tanzu workload` text in the dropdown.
    ![A new file called workload.yaml with the words "tanzu workload" written in it and an action menu showing "tanzu workload"](../images/vscode-workload.png)
1. Fill out the template by using the **tab** key.

> **Note:** To create your **workload.yaml** file manually, see [Creating a **workload.yaml** file](#creating-a-workload-yaml-file).


### <a id="the-catalog-info-yaml-file"></a> The **catalog-info.yaml** file

The **catalog-info.yaml** file enables the workloads of this project to be visible in the [Tanzu Application Platform GUI](../tap-gui/about.md).

Before beginning to write your **catalog-info.yaml** file, ensure that you:

- know the name of your application. For example, `my app`.
- have a description of your application ready.

To create a **workload.yaml** file by using the Code Snippets:

1. (Optional) Create a folder named `catalog` in the root directory of your project. For example, `my project -> catalog`
1. Create a file named **catalog-info** with the extension **.yaml** in the new config folder. For example, `my project -> catalog -> catalog-info.yaml`
1. Open the new **catalog-info.yaml** file in VS Code, enter `tanzu catalog-info` in the file to trigger the Code Snippets, then either press **return** or left-click the `tanzu catalog-info` text in the dropdown.
    ![A new file called catalog-info.yaml with the words "tanzu catalog-info" written in it and an action menu showing "tanzu catalog-info"](../images/vscode-cataloginfo.png)
1. Fill out the template by using the **tab** key.

> **Note:** To create your **catalog-info.yaml** file manually, see [Creating a **catalog-info.yaml** file](#creating-a-catalog-info-yaml-file).

### <a id="the-tiltfile-file"></a> The **Tiltfile** file

The **Tiltfile** file provides the configuration for [Tilt](https://docs.tilt.dev/) to enable your project to live update on your Kubernetes cluster enabled by Tanzu Application Platform.

>**Note:** The Tanzu Dev Tools extension requires only one **Tiltfile** per project.

Before beginning to write your **Tiltfile** file, ensure that you know:

- the name of your application. For example, `my app`.
- the value of the source image. For example, `docker.io/mycompany/myapp`.
- whether you want to compile the source image from a local directory other than the project directory, otherwise leave the `local path` value unchanged. For more information, see local path in the glossary.
- the path to your `workload.yaml` file. For example, `config/workload.yaml`.
- the name of your current [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/), if the targeting Kubernetes cluster enabled by Tanzu Application Platform is not running on your local machine.

To create a **workload.yaml** file by using the Code Snippets:

1. Create a file named **Tiltfile** with no file extension in the root folder of your project. For example, `my project -> Tiltfile`.
1. Open the new **Tiltfile** file in VS Code and enter `tanzu tiltfile` in the file to trigger the Code Snippets, then either press **return** or left-click the `tanzu catalog-info` text in the dropdown.
    ![A new file called Tiltfile with the words "tanzu tiltfile" written in it and an action menu showing "tanzu tiltfile"](../images/vscode-tiltfile.png)
1. Fill out the template by using the **tab** key.
1. If the targeting Kubernetes cluster enabled by Tanzu Application Platform is not running on your local machine, add a new line to the end of the **Tiltfile** template and enter the following text:

    ```
    allow_k8s_contexts('<context-name>')
    ```

    Where `<context-name>` is the name of your current Kubernetes context.

>**Note:** To create your “Tiltfile” file manually, see [Creating a “Tiltfile” file](#creating-a-tiltfile-file).

## <a id="set-up-manually"></a> Set Up Manually

If you don’t want to use the Code Snippets templates to create the files required for the Tanzu Developer Tools extension of your existing project, you can manually create the required files.

### <a id="creating-a-workload-yaml-file"></a> Creating a **workload.yaml** File

The **workload.yaml** file provides instructions to the Supply Chain Choreographer for how to build and manage a workload.

>**Note:** The Tanzu Developer Tools extension requires only one **workload.yaml** per project. The **workload.yaml** must be a single-document YAML file, not a multidocument YAML file.

Before beginning to write your workload.yaml file, ensure that you know:

- the name of your application. For example, `my app`.
- the workload type of your application. For example, `web`.
- the git source code URL. For example, `github.com/mycompany/myapp`.
- the branch of the git source code that you will use. For example, `main`.

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

Where:

- `<app-name>` is the name of your application.
- `<workload-type>` is the type of this workload. For example, `web`.
- `<git-source-url>` is your git source code URL.
- `<git-branch-name>` is the branch of your git source code.

Alternatively, you can use the Tanzu CLI to create a **workload.yaml** file. For more information about the Tanzu CLI command, see [Tanzu apps workload create](../cli-plugins/apps/command-reference/tanzu-apps-workload-create.md) in the Tanzu CLI documentation.

### <a id="creating-a-catalog-info-yaml-file"></a> Creating a **catalog-info.yaml** File

The **catalog-info.yaml** file enables the workloads of this project to be visible in the [TAP GUI](../tap-gui/about.md).

Before beginning to write your **catalog-info.yaml** file, ensure that you:

- know the name of your application. For example, `my app`.
- have a description of your application ready.

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

Where:

- `<app-name>` is the name of your application.
- `<app-description>` is the description of your application.

### <a id="creating-a-tiltfile-file"></a> Creating a **Tiltfile** File

The **Tiltfile** file provides the configuration for [Tilt](https://docs.tilt.dev/) to enable your project to live update on your Kubernetes cluster enabled by Tanzu Application Platform.

>**Note:** The Tanzu Developer Tools extension requires only one **Tiltfile** per project.

Before beginning to write your **Tiltfile** file, ensure that you know:

- the name of your application. For example, `my app`.
- the value of the source image. For example, `docker.io/mycompany/myapp`.
- whether you want to compile the source image from a local directory other than the project directory, otherwise leave the `local path` value unchanged. For more information, see local path in the glossary.
- the path to your `workload.yaml` file. For example, `config/workload.yaml`.
- the name of your current [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/), if the targeting Kubernetes cluster enabled by Tanzu Application Platform is not running on your local machine.

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

Where:

- `<source-image>` is the value of source image.
- `<app-name>` is the name of your application.
- `<path-to-workload-yaml>` is the local file system path to your **workload.yaml** file. For example, `config/workload.yaml`.
- `<context-name>` is the name of your current [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/). If your Kubernetes cluster enabled by Tanzu Application Platform is running locally on your machine, the entire `allow_k8s_contexts` line can be removed. For more information, see the [Tilt documentation](https://docs.tilt.dev/api.html#api.allow_k8s_contexts).

### <a id="example-project"></a> Example Project

You can view a sample application that demonstrates the necessary configuration files. There are two ways to obtain the sample application.

Before you begin, you will need a container registry for the sample application.

**Option 1: Application Accelerator**

If your company has configured [Application Accelerator](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/index.html), you can obtain the sample application there if it has not been removed.

1. Open **Application Accelerator**.

    >**Note:** The application accelerator location will vary based on where your company placed it, contact the appropriate team to determine its location.
    
1. Search for **Tanzu Java Web App** in the Application Accelerator.
1. Add the required configuration information and generate the application.
1. Unzip the file and open the project in a VS Code workspace.

**Option 2: Clone from GitHub**

1. Use `git clone` to clone the [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app) repository from GitHub.
1. Open the `Tiltfile` and replace `your-registry.io/project` with your container registry.

## <a id="whats-next"></a> What's Next

Proceed to the [Using the Extension](../vscode-extension/using-the-extension.md) page.
