# Getting Started with Tanzu Developer Tools for VS Code

This topic guides you through getting started with VMware Tanzu Developer Tools for Visual Studio Code
(VS Code).

## <a id="prereqs"></a> Prerequisite

[Install VMware Tanzu Developer Tools for Visual Studio Code](../vscode-extension/install.hbs.md).

## <a id="set-up-tanzu-dev-tools"></a> Set up Tanzu Developer Tools

To use the extension with a project, the project must have these required files:

- `workload.yaml`: A file named `workload` with the extension `.yaml` must be in the project.
  For example, `my-project/config/workload.yaml`. The `workload.yaml` file provides instructions to
  the [Supply Chain Choreographer](../scc/about.hbs.md) for how a workload must be built and managed.
  The extension requires only one `workload.yaml` per project. `workload.yaml` must be a
  single-document YAML file, not a multidocument YAML file.

- `catalog-info.yaml`: A file named `catalog-info` with the extension `.yaml` must be in the project.
  For example, `my-project/catalog/catalog-info.yaml`. The `catalog-info.yaml` file enables the
  workloads created with the Tanzu Developer Tools extension to appear in
  [Tanzu Application Platform GUI](../tap-gui/about.hbs.md).

- `Tiltfile`: A file named `Tiltfile` with no extension (no filetype) must be in the project.
  For example, `my-project/Tiltfile`. The Tiltfile provides the [Tilt](https://docs.tilt.dev/)
  configuration for to enable your project to Live Update on the Tanzu Application Platform.
  The Tanzu Developer Tools extension requires only one Tiltfile per project.

- `.tanzuignore`: A file named `.tanzuignore` with no extension (no filetype) must be in the project.
  For example `my-project/.tanzuignore`. The `.tanzuignore` file specifies filepaths to be excluded
  from the source code image. When working with local source code, you can exclude files from the
  source code to be uploaded within the image.

There are two ways to create these files:

- Use the [VS Code snippets](#catalog-information) that Tanzu Developer Tools provides.
  For more information about the snippets, see the
  [VS Code documentation](https://code.visualstudio.com/docs/editor/userdefinedsnippets).

- Write the files by [setting up manually](#set-up-manually).

## <a id="catalog-information"></a> Set up using code snippets

[Code snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets) enable you to quickly
add the files necessary to develop against the Tanzu Application Platform to existing projects.
This is done by creating a template in an empty file that you then fill in with the required information.

You must create the files described in the [Set up Tanzu Developer Tools](#set-up-tanzu-dev-tools)
section. After generating the file contents by using the code snippet, press the Tab key to fill in
the required values.

### <a id="the-workload-yaml-file"></a> The `workload.yaml` file

The `workload.yaml` file provides instructions to the Supply Chain Choreographer to build and manage
a workload.

The extension requires only one `workload.yaml` per project. The `workload.yaml` must be a
single-document YAML file, not a multidocument YAML file.

Before beginning to write your `workload.yaml` file, ensure that you know:

- The name of your application. For example, `my app`.
- The workload type of your application. For example, `web`.
- The GitHub source code URL. For example, `github.com/mycompany/myapp`.
- The Git branch of the source code that you intend to use. For example, `main`.

To create a `workload.yaml` file by using the code snippets:

1. (Optional) Create a directory named `config` in the root directory of your project.
   For example, `my project/config`.
2. Create a file named `workload.yaml` in the new config directory. For example,
   `my project/config/workload.yaml`.
3. Open the new `workload.yaml` file in VS Code, enter `tanzu workload` in the file to trigger the
   code snippets, and either press Enter or left-click the `tanzu workload` text in the drop-down menu.

   ![A new file called workload.yaml with the words "tanzu workload" written in it and an action menu showing "tanzu workload"](../images/vscode-workload.png)

4. Fill in the template by pressing the Tab key.

To create your `workload.yaml` file manually, see [Create a `workload.yaml` file](#create-workload-yaml).

### <a id="catalog-info-yaml-file"></a> The `catalog-info.yaml` file

The `catalog-info.yaml` file enables the workloads of this project to appear in
[Tanzu Application Platform GUI](../tap-gui/about.hbs.md).

Before beginning to write your `catalog-info.yaml` file, ensure that you:

- know the name of your application. For example, `my app`.
- have a description of your application ready.

To create a `catalog-info.yaml` file by using the code snippets:

1. (Optional) Create a directory named `catalog` in the root directory of your project. For example,
   `my project/catalog`
2. Create a file named `catalog-info.yaml` in the new config directory.
   For example, `my project/catalog/catalog-info.yaml`
3. Open the new `catalog-info.yaml` file in VS Code, enter `tanzu catalog-info` in the file to trigger
   the code snippets, and then either press Enter or left-click the `tanzu catalog-info` text in the
   drop-down menu.

    ![A new file called catalog-info.yaml with the words "tanzu catalog-info" written in it and an action menu showing "tanzu catalog-info"](../images/vscode-cataloginfo.png)

4. Fill in the template by pressing the Tab key.

> **Note:** To create your `catalog-info.yaml` file manually, see
> [Create a `catalog-info.yaml` file](#create-catalog-info-yaml).

### <a id="tiltfile-file"></a> The Tiltfile file

The Tiltfile file provides the [Tilt](https://docs.tilt.dev/) configuration to enable your project to
Live Update on your Kubernetes cluster that has Tanzu Application Platform.
The Tanzu Developer Tools extension requires only one **Tiltfile** per project.

Before beginning to write your Tiltfile file, ensure that you know:

- the name of your application. For example, `my app`.
- the value of the source image. For example, `docker.io/mycompany/myapp`.
- whether you want to compile the source image from a local directory other than the project directory
  or otherwise leave the `local path` value unchanged. For more information, see local path in the glossary.
- the path to your `workload.yaml` file. For example, `config/workload.yaml`.
- the name of your current
  [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/),
  if the targeting Kubernetes cluster enabled by Tanzu Application Platform is not running on your
  local machine.

To create a `Tiltfile` file by using the Code Snippets:

1. Create a file named `Tiltfile` with no file extension in the root directory of your project.
   For example, `my project/Tiltfile`.
2. Open the new Tiltfile file in VS Code and enter `tanzu tiltfile` in the file to trigger the
   code snippets, and then either press Enter or left-click the `tanzu tiltfile` text in the drop-down
   menu.

   ![A new file called Tiltfile with the words "tanzu tiltfile" written in it and an action menu showing "tanzu tiltfile"](../images/vscode-tiltfile.png)

3. Fill in the template by pressing the Tab key.
4. If the targeting Kubernetes cluster enabled by Tanzu Application Platform is not running on your
   local machine, add a new line to the end of the **Tiltfile** template and enter:

    ```text
    allow_k8s_contexts('CONTEXT-NAME')
    ```

    Where `CONTEXT-NAME` is the name of your current Kubernetes context.

To create your Tiltfile file manually, see [Create a Tiltfile file](#create-a-tiltfile-file).

## <a id="set-up-manually"></a> Set up manually

If you don’t want to use the Code Snippets templates to create the files required in your existing
project for the extension, you can manually create the required files.

### <a id="create-workload-yaml"></a> Create a `workload.yaml` file

The `workload.yaml` file provides instructions to the Supply Chain Choreographer for how to build
and manage a workload.
The Tanzu Developer Tools extension requires only one `workload.yaml` per project.
The `workload.yaml` must be a single-document YAML file, not a multidocument YAML file.

Before beginning to write your `workload.yaml` file, ensure that you know:

- the name of your application. For example, `my app`.
- the workload type of your application. For example, `web`.
- the GitHub source code URL. For example, `github.com/mycompany/myapp`.
- the Git branch of the source code that you intend to use. For example, `main`.

The following is an example `workload.yaml` file:

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

- `APP-NAME` is the name of your application.
- `WORKLOAD-TYPE` is the type of this workload. For example, `web`.
- `GIT-SOURCE-URL` is your GitHub source code URL.
- `GIT-BRANCH-NAME` is the Git branch of your source code.

Alternatively, you can use the Tanzu CLI to create a `workload.yaml` file.
For more information about the Tanzu CLI command, see
[Tanzu apps workload create](../cli-plugins/apps/command-reference/tanzu-apps-workload-create.hbs.md)
in the Tanzu CLI documentation.

### <a id="create-catalog-info"></a> Create a `catalog-info.yaml` file

The `catalog-info.yaml` file enables the workloads of this project to appear in
[Tanzu Application Platform GUI](../tap-gui/about.hbs.md).

Before beginning to write your `catalog-info.yaml` file, ensure that you:

- know the name of your application. For example, `my app`.
- have a description of your application ready.

The following is an example `catalog-info.yaml` file:

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
- `APP-DESCRIPTION` is the description of your application.

### <a id="create-tiltfile-file"></a> Create a `Tiltfile` file

The `Tiltfile` file provides the [Tilt](https://docs.tilt.dev/) configuration for enabling your project
to Live Update on your Kubernetes cluster that has Tanzu Application Platform.
The extension requires only one Tiltfile per project.

Before beginning to write your Tiltfile file, ensure that you know:

- the name of your application. For example, `my app`.
- the value of the source image. For example, `docker.io/mycompany/myapp`.
- whether you want to compile the source image from a local directory other than the project directory,
  or otherwise leave the `local path` value unchanged. For more information, see local path in the glossary.
- the path to your `workload.yaml` file. For example, `config/workload.yaml`.
- the name of your current
  [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/),
  if the targeting Kubernetes cluster enabled by Tanzu Application Platform is not running on your local
  machine.

The following is an example `Tiltfile` file:

```text
SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='SOURCE-IMAGE')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='default')

k8s_custom_deploy(
   'APP-NAME',
   apply_cmd="tanzu apps workload apply -f PATH-TO-WORKLOAD-YAML --live-update" +
       " --local-path " + LOCAL_PATH +
       " --SOURCE-IMAGE " + SOURCE_IMAGE +
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
   extra_pod_selectors=[{'carto.run/workload-name': 'APP-NAME', 'app.kubernetes.io/component': 'run'}])
allow_k8s_contexts('CONTEXT-NAME')
```

Where:

- `SOURCE-IMAGE` is the value of source image.
- `APP-NAME` is the name of your application.
- `PATH-TO-WORKLOAD-YAML` is the local file system path to `workload.yaml`. For example, `config/workload.yaml`.
- `CONTEXT-NAME` is the name of your current
  [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).
  If your Kubernetes cluster enabled by Tanzu Application Platform is running locally on your local
  machine, you can remove the entire `allow_k8s_contexts` line. For more information, see the
  [Tilt documentation](https://docs.tilt.dev/api.html#api.allow_k8s_contexts).

### <a id="create-tanzuignore-file"></a> Create a `.tanzuignore` file

The `.tanzuignore` file specifies the file paths to exclude from the source code image.
When working with local source code, you can exclude files from the source code to be uploaded within
the image.
Directories must not end with the system path separator (`/` or `\`).
See this [example](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/tanzu-java-web-app/.tanzuignore).
in GitHub.

### <a id="example-project"></a> Example project

You can view a sample application that demonstrates the necessary configuration files.
There are two ways to obtain the sample application.

Before you begin, you need a container registry for the sample application.

#### Option 1: Application Accelerator

If your company has configured
[Application Accelerator](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/index.html),
you can obtain the sample application there if it was not removed.

1. Open Application Accelerator.
2. Search for `Tanzu Java Web App` in Application Accelerator.
3. Add the required configuration information and generate the application.
4. Unzip the file and open the project in a VS Code workspace.

#### Option 2: Clone from GitHub

1. Run `git clone` to clone the
   [tanzu-java-web-app](https://github.com/vmware-tanzu/application-accelerator-samples) repository
   from GitHub.
2. Change into the `tanzu-java-web-app` directory.
3. Open the Tiltfile and replace `your-registry.io/project` with your container registry.

## <a id="next-steps"></a> Next steps

Proceed to [Using Tanzu Developer Tools for VS Code](../vscode-extension/using-the-extension.hbs.md).
