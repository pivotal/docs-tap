# Get Started with Tanzu Developer Tools for Visual Studio

This topic guides you through getting started with VMware Tanzu Developer Tools for Visual Studio.

## <a id="prereqs"/> Prerequisite

[Install Tanzu Developer Tools for Visual Studio](install.hbs.md).

## <a id="config-src-img-registry"/> Configure Local Source Proxy

{{> 'partials/ide-extensions/config-src-img-registry' }}

## <a id="set-up-tanzu-dev-tools"/> Set up Tanzu Developer Tools

{{> 'partials/ide-extensions/set-up-tanzu-dev-tools' }}

## <a id="create-workload-yaml"/> Create the `workload.yaml` file

Your project must contain a file named `workload.yaml`.
For example, `MyApp\Config\workload.yaml`.

`workload.yaml` provides instructions to Supply Chain Choreographer for how to build and manage a
workload. For more information, see [Supply Chain Choreographer for Tanzu](../scc/about.hbs.md).

The Tanzu Developer Tools for Visual Studio extension requires at least one `workload.yaml` file per
project. `workload.yaml` must be a single-document YAML file, not a multi-document YAML file.

To create a `workload.yaml` file by using Visual Studio:

1. Right-click the Solution Explorer project.
2. Click **Add** > **New Folder**.
3. Name the folder `Config`.
4. Right-click the new `Config` folder and then click **Add** > **New Item...**.
5. From the available list of items, click **Tanzu Workload** > **Add**.
6. Follow the instructions at the top of the created file.

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

- `APP-NAME` is the name of your application. For example, `my-app`.
- `WORKLOAD-TYPE` is the type of workload for your app. For example, `web`.
  For more information, see [Workload types](../workloads/workload-types.hbs.md).
- `GIT-SOURCE-URL` is the Git source code URL for your app. For example, `github.com/mycompany/myapp`.
- `GIT-BRANCH-NAME` is the branch of the Git source code you want to use. For example, `main`.

Alternatively, you can use the Tanzu CLI to create a `workload.yaml` file.
For more information about the relevant Tanzu CLI command, see
[Tanzu apps workload apply](../cli-plugins/apps/command-reference/workload_create_update_apply.hbs.md).

## <a id="create-catalog-info-yaml"/> Create the `catalog-info.yaml` file

Your project must contain a file named `catalog-info.yaml`.
For example, `MyApp\Catalog\catalog-info.yaml`.

`catalog-info.yaml` enables the workloads created with Tanzu Developer Tools for Visual Studio to
appear in Tanzu Developer Portal (formerly named Tanzu Application Platform GUI).
For more information, see [Overview of Tanzu Developer Portal](../tap-gui/about.hbs.md).

To create a `catalog-info.yaml` file by using Visual Studio:

1. Right-click the Solution Explorer project.
2. Click **Add** > **New Folder**.
3. Name the folder `Catalog`.
4. Right-click the new `Catalog` folder and then click **Add** > **New Item...**.
5. From the available list of items, click **Tanzu Catalog Info** > **Add**.
6. Follow the instructions at the top of the created file.

See the following `catalog-info.yaml` example:

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

## <a id="create-tiltfile"/> Create the Tiltfile file

Your project must contain a file named `Tiltfile`.
For example, `MyApp\Tiltfile`.

The `Tiltfile` provides the configuration for Tilt to enable your project to Live Update on the
Tanzu Application Platform-enabled Kubernetes cluster.
For more information, see the [Tilt](https://docs.tilt.dev/) documentation.

To create a `Tiltfile` file by using Visual Studio:

1. Right-click the Solution Explorer project.
2. Click **Add** > **New Item...**
3. From the available list of items, click **Tanzu Tiltfile** > **Add**.
4. Follow the instructions at the top of the created file.

See the following `Tiltfile` example:

```Tiltfile
SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='SOURCE-IMAGE-VALUE')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='default')
LIVE_UPDATE_PATH = os.getenv("LIVE_UPDATE_PATH", default='bin/Debug/net6.0')

k8s_custom_deploy(
   'APP-NAME',
   apply_cmd="tanzu apps workload apply -f Config/workload.yaml --live-update" +
       " --local-path " + LOCAL_PATH +
       " --build-env BP_DEBUG_ENABLED=true" +
       " --namespace " + NAMESPACE +
       " --output yaml" +
       " --yes",
   delete_cmd="tanzu apps workload delete " +  APP-NAME + " --namespace " + NAMESPACE + " --yes" ,
   deps=['bin'],
   container_selector='workload',
   live_update=[
       sync(LIVE_UPDATE_PATH, '/workspace')
   ]
)

k8s_resource('APP-NAME', port_forwards=["8080:8080"],
   extra_pod_selectors=[{'carto.run/workload-name': 'APP-NAME', 'app.kubernetes.io/component': 'run'}])
allow_k8s_contexts('CONTEXT-NAME')
```

Where `APP-NAME` is the name of your application

If your Tanzu Application Platform-enabled Kubernetes cluster is running on your local machine, you
can remove the entire `allow_k8s_contexts` line.
For more information about this line, see the
[Tilt documentation](https://docs.tilt.dev/api.html#api.allow_k8s_contexts).

## <a id="create-tanzuignore"/> Create the `.tanzuignore` file

Your project can contain a file named `.tanzuignore`.
When working with local source code, `.tanzuignore` excludes files from the source code that is
uploaded within the image. It has syntax similar to the `.gitignore` file.

This file must be placed in the project root to work. For example, `MyApp\.tanzuignore`.

To create a `Tiltfile` file by using Visual Studio:

1. Right-click the Solution Explorer project.
2. Click **Add** > **New Item...**.
3. From the available list of items, click **Tanzu Ignore file** > **Add**.

For an example, see the `.tanzuignore`
[file](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/tanzu-java-web-app/.tanzuignore)
in GitHub that is used for the sample Tanzu Java web app.
You can use the file as it is or edit it for your needs.

## <a id="example-project"/> View an example project

Before you begin, you need a container image registry to use the sample application.
There are two ways to view a sample application that demonstrates the necessary configuration files:

Use Application Accelerator
: If your company has configured
  [Application Accelerator](../application-accelerator/about-application-accelerator.hbs.md),
  you can obtain the sample application there if it was not removed.

  To view the example by using Application Accelerator:

  1. Open Application Accelerator. You might need to contact a separate team in your organization
     to learn they placed it.
  2. Search for `Steeltoe Weather Forecast` in Application Accelerator.
  3. Add the required configuration information and generate the application.
  4. Unzip the application and open the directory in Visual Studio.

Clone from GitHub
: To clone the example from GitHub:

  1. Use `git clone` to clone the
     [application-accelerator-samples](https://github.com/vmware-tanzu/application-accelerator-samples)
     repository from GitHub.
  1. Go to the `weatherforecast-steeltoe` directory.
  1. Open the `Tiltfile` and replace `your-registry.io/project` with your registry.

## <a id="whats-next"/> Next steps

[Use Tanzu Developer Tools for Visual Studio](using-the-extension.hbs.md).
