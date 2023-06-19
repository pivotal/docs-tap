# Iterate on your new app using Tanzu Developer Tools for Visual Studio

This topic guides you through starting to iterate on your first application on
Tanzu Application Platform (commonly known as TAP).
You deployed the app in the previous how-to [Deploy your first application](deploy-first-app.hbs.md).

## <a id="you-will"></a>What you will do

- Prepare to iterate on your application.
  - Prepare your project to support Live Update.
  - Prepare your IDE to iterate on your application.
- Apply your application to the cluster.
- Live update your application to view code changes updating live on the cluster.
- Debug your application.
- Monitor your running application on the Application Live View UI.
- Delete your application from the cluster.

## <a id="prepare-to-iterate"></a>Prepare to iterate on your application

In the previous Getting started how-to topic, [Deploy your first application](deploy-first-app.hbs.md),
you deployed your first application on Tanzu Application Platform.
Now that you have developed a skeleton workload, you are ready to begin to iterate on your new
application and test code changes on the cluster.

Tanzu Developer Tools for Visual Studio is VMware Tanzu’s official IDE extension for Visual Studio.
It helps you develop and receive fast feedback on your workloads running on the Tanzu Application Platform.

The Visual Studio extension enables live updates of your application while running on the cluster
and allows you to debug your application directly on the cluster.

For information about installing the prerequisites and the Tanzu Developer Tools for Visual Studio extension,
see [Install Tanzu Developer Tools for Visual Studio](../vs-extension/install.hbs.md).

> **Important** Use Tilt v0.30.12 or later for the sample application.

To prepare to iterate on your application, you must:

1. [Prepare your project to support Live Update](#prepare-live-update)
1. [Set up the IDE](#set-up-ide)

### <a id="prepare-live-update"></a>Prepare your project to support Live Update

Tanzu Live Update uses [Tilt](https://tilt.dev/). This requires a suitable
`Tiltfile` to exist at the root of your project.

Your `Tiltfile` must be similar to the following:

```starlark
SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='your-registry.io/project/weatherforecast-steeltoe-source')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='default')
NAME = os.getenv("NAME", default='sample-app')

k8s_custom_deploy(
    NAME,
    apply_cmd="tanzu apps workload apply -f config/workload.yaml --update-strategy replace --debug --live-update" +
               " --local-path " + LOCAL_PATH +
               " --namespace " + NAMESPACE +
               " --yes --output yaml",
    delete_cmd="tanzu apps workload delete " + NAME + " --namespace " + NAMESPACE + " --yes",
    deps=['./bin'],
    container_selector='workload',
    live_update=[
      sync('./bin/Debug/net6.0', '/workspace')
    ]
)

k8s_resource('tanzu-java-web-app', port_forwards=["8080:8080"],
            extra_pod_selectors=[{'carto.run/workload-name': 'sample-app', 'app.kubernetes.io/component': 'run'}])
```

### <a id="set-up-ide"></a>Set up the IDE

After verifying your project has the required `Tiltfile`,
you are ready to set up your development environment.

1. Open the Weather Forecast solution in Visual Studio by selecting **File** > **Open** > **Project/Solution...**.
   If you don't have the Weather Forecast app you can obtain it by following the instructions in
   [Generate an application with Application Accelerator](generate-first-app.html), or from the
   [Application Accelerator Samples](https://github.com/vmware-tanzu/application-accelerator-samples)
   GitHub page.

You are now ready to iterate on your application.

## <a id="apply-your-app"></a>Apply your application to the cluster

Apply the workload to see your application running on the cluster:

1. In **Solution Explorer**, right-click any file under the application name and click **Tanzu** > **Apply Workload**.

1. In the dialog box, enter the following:

   1. In the **Local Path** text box, provide the path to the directory containing the Weather Forecast app.
      The current directory is the default.

      The local path value tells the Tanzu Developer Tools for Visual Studio extension which directory
      on your local file system to bring into the source image.
      For example, dot (`.`) uses the working directory, or you can specify a full file path.

   1. In the **Namespace** text box, provide the namespace to be associated with the workload
      on the cluster.

   1. (Optional) In the **Source Image** text box, provide the destination image repository to publish the
      image containing your workload source code.

      The source image value tells the Tanzu Developer Tools for Visual Studio extension where to publish
      the container image with your uncompiled source code, and what to name that image.
      The image must be published to a container image registry where you have write (push) access.
      For example, `gcr.io/myteam/weather-forecast-source`.

      > **Note** See the documentation for the registry you're using to find out which steps are
      > necessary to authenticate and gain push access.
      >
      > For example, if you use Docker, see the [Docker documentation](https://docs.docker.com/engine/reference/commandline/login/),
      > or if you use Harbor, see the [Harbor documentation](https://goharbor.io/docs/1.10/working-with-projects/working-with-images/pulling-pushing-images/) and so on.

   1. Click the **OK** button.

The `apply workload` command runs and opens a an output window in which you can monitor the output of the command.
The `apply workload` command can take a few minutes to deploy your application onto the cluster.

## <a id="live-update-your-app"></a>Enable Live Update for your application

Live Update allows you to save changes to your code and see those changes reflected within seconds
in the workload running on the cluster.

To enable Live Update for your application:

1. In **Solution Explorer**, right-click any file under the application name and click **Tanzu** > **Start Live Update**.

1. Live update can take 1 to 3 minutes while the workload deploys and the Knative service becomes available.

   >**Note** Depending on the type of cluster you use, you might see an error similar to the following:
   >
   >`ERROR: Stop! cluster-name might be production.
   >If you're sure you want to deploy there, add:
   >allow_k8s_contexts('cluster-name')
   >to your Tiltfile. Otherwise, switch k8scontexts and restart Tilt.`
   >
   >Follow the instructions and add the line, `allow_k8s_contexts('cluster-name')` to your `Tiltfile`.

1. In the IDE, make a change to the source code.

1. Build your project.

1. The container is updated when the logs stop streaming. Go to your browser and refresh the page.

1. View the changes to your workload running on the cluster.

1. Either continue making changes, or stop the Live Update process when finished.
   To stop Live Update, in **Solution Explorer**, right-click any file under the application name
   and click **Tanzu** > **Stop Live Update**.

## <a id="debug-your-app"></a>Debug your application

Debug the cluster either on the application or in your local environment.

To start debugging the cluster:

1. Set a breakpoint in your code.

1. [Apply your application to the cluster.](#apply-your-app)

1. In **Solution Explorer**, right-click any file under the application name  and click **Tanzu** > **Debug Workload**.

To stop debugging the cluster:

1. In main main, click **Debug** > **Detach All**

## <a id="delete-your-app"></a>Delete your application from the cluster

You can use the delete action to remove your application from the cluster as follows:

1. In **Solution Explorer**, right-click any file under the application name and click **Tanzu** > **Delete Workload**.

1. In the confirmation dialog box that appears, click **OK** to delete the application from the cluster.

## <a id="next-steps"></a> Next steps

- [Consume services on Tanzu Application Platform](consume-services.md)
