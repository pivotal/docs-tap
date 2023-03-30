# Get Started with Tanzu Developer Tools for IntelliJ

This topic guides you through getting started with Tanzu Developer Tools for IntelliJ.

## <a id="prereqs"></a> Prerequisite

[Install Tanzu Developer Tools for IntelliJ](install.hbs.md).

## <a id="set-up-tanzu-dev-tools"></a> Set up Tanzu Developer Tools

{{> 'partials/ide-extensions/set-up-tanzu-dev-tools' }}

## <a id="create-workload-yaml"></a> Create the `workload.yaml` file

You must include a file named `workload.yaml` in your project.
For example, `my-project/config/workload.yaml`.

`workload.yaml` provides instructions to Supply Chain Choreographer about how to build and manage
a workload.
For more information, see [Supply Chain Choreographer for Tanzu](../scc/about.hbs.md).

The Tanzu Developer Tools for IntelliJ extension requires only one `workload.yaml` file per project.
`workload.yaml` must be a single-document YAML file, not a multi-document YAML file.

To create a `workload.yaml` file by using code snippets:

1. Right-click on the IntelliJ project explorer and then click **New**.
2. Select the Tanzu workload.
3. Add the filename `workload`.
4. Fill in the template.

See the following `workload.yaml` example:

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
  For more information, see [Workload types](../workloads/workload-types.hbs.md).
- `GIT-SOURCE-URL` is the Git source code URL for your app. For example, `github.com/mycompany/myapp`.
- `GIT-BRANCH-NAME` is the branch of the Git source code you want to use. For example, `main`.

Alternatively you can use the Tanzu CLI to create a `workload.yaml` file.
For more information about the relevant Tanzu CLI command, see
[Tanzu apps workload apply](../cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md).

## <a id="create-catalog-info-yaml"></a> Create the `catalog-info.yaml` file

You must include a file named `catalog-info.yaml` in your project.
For example, `my-project/catalog/catalog-info.yaml`.

`catalog-info.yaml` enables the workloads created with Tanzu Developer Tools for IntelliJ to be
visible in Tanzu Application Platform GUI.
For more information, see [Overview of Tanzu Application Platform GUI](../tap-gui/about.hbs.md).

To create a `catalog-info.yaml` file by using the code snippets:

1. Right-click on the IntelliJ project explorer and then click **New**.
2. Select the Tanzu Catalog.
3. Add the filename `catalog-info`.
4. Fill in the template.

See the following `workload.yaml` example:

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

In your project you must include a file named `Tiltfile` with no extension (no filetype), such as
`my-project/Tiltfile`.

The `Tiltfile` provides the configuration for Tilt to enable your project to
[Live Update](glossary.hbs.md#live-update) on the Tanzu Application Platform-enabled Kubernetes
cluster.
For more information, see the [Tilt](https://docs.tilt.dev/) documentation.

The Tanzu Developer Tools for IntelliJ extension requires only one Tiltfile per project.

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
   extra_pod_selectors=[{'carto.run/workload-name': 'APP-NAME', 'app.kubernetes.io/component': 'run'}])
allow_k8s_contexts('CONTEXT-NAME')
```

Where:

- `SOURCE-IMAGE-VALUE` is your [source image](glossary.hbs.md#source-image).
- `APP-NAME` is the name of your application.
- `PATH-TO-WORKLOAD-YAML` is the local file system path to your `workload.yaml` file.
  For example, `config/workload.yaml`.
- `CONTEXT-NAME` is the name of your current
  [Kubernetes context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).
  If your Tanzu Application Platform-enabled Kubernetes cluster is running on your local machine,
  you can remove the entire `allow_k8s_contexts` line.
  For more information about this line, see the
  [Tilt documentation](https://docs.tilt.dev/api.html#api.allow_k8s_contexts).

If you want to compile the source image from a local directory other than the project directory,
change the value of `local path`.
For more information, see [local path](glossary.hbs.md#local-path) in the glossary.

## <a id="create-tanzuignore"></a> Create the `.tanzuignore` file

In your project, you can include a file named `.tanzuignore` with no file extension.
For example, `my-project/.tanzuignore`.

When working with local source code, `.tanzuignore` excludes files from the source code that are
uploaded within the image.
It has syntax similar to the `.gitignore` file.

For an example, see the `.tanzuignore`
[file](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/tanzu-java-web-app/.tanzuignore)
in GitHub that is used for the sample Tanzu Java web app.
You can use the file as it is or edit it for your needs.

## <a id="example-project"></a> View an example project

Before you begin, you need a container image registry to use the sample application.
There are two ways to view a sample application that demonstrates the necessary configuration files.

Use Application Accelerator
: If your company has configured
[Application Accelerator](../application-accelerator/about-application-accelerator.hbs.md),
you can obtain the sample application there if it was not removed.
To view the example using Application Accelerator:
  1. Open Application Accelerator. The Application Accelerator location varies based on where your
     company placed it. Contact the appropriate team to learn its location.
  2. Search for `Tanzu Java Web App` in the Application Accelerator.
  3. Add the required configuration information and generate the application.
  4. Unzip the application and open the directory in IntelliJ.

Clone from GitHub
: To clone the example from GitHub:
  1. Use `git clone` to clone the
     [application-accelerator-samples](https://github.com/vmware-tanzu/application-accelerator-samples)
     repository from GitHub.
  2. Go to the `tanzu-java-web-app` directory.
  3. Open the `Tiltfile` and replace `your-registry.io/project` with your registry.

## <a id="whats-next"></a> Next steps

[Use Tanzu Developer Tools for IntelliJ](using-the-extension.hbs.md).
