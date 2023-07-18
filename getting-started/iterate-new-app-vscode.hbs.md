# Iterate on your new app using Tanzu Developer Tools for VS Code

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

Tanzu Developer Tools for VS Code is VMware Tanzu’s official IDE extension for VS Code.
It helps you develop and receive fast feedback on your workloads running on the Tanzu Application Platform.

The VS Code extension enables live updates of your application while running on the cluster
and allows you to debug your application directly on the cluster.
For information about installing the prerequisites and the Tanzu Developer Tools for VS Code extension, see
[Install Tanzu Developer Tools for your VS Code](../vscode-extension/install.md).

>**Important** Use Tilt v0.30.12 or a later version for the sample application.

To prepare to iterate on your application, you must:

1. [Prepare your project to support Live Update](#prepare-live-update)
1. [Set up the IDE](#set-up-ide)

### <a id="prepare-live-update"></a>Prepare your project to support Live Update

Tanzu Live Update uses [Tilt](https://tilt.dev/). This requires a suitable
`Tiltfile` to exist at the root of your project. Both Gradle and Maven projects are
supported, but each requires a `Tiltfile` specific to that type of project.

The Tanzu Java Web App accelerator allows you to choose between Maven and Gradle and includes a `Tiltfile`.
If you used the accelerator, your project is already set up correctly.

To verify your project is set up correctly, review the following requirements depending on your chosen
build system.

#### <a id="maven"></a>Maven Spring Boot project requirements

If you are using Maven, your `Tiltfile` must be similar to the following:

```starlark
SOURCE_IMAGE = os.getenv("SOURCE_IMAGE", default='your-registry.io/project/tanzu-java-web-app-source')
LOCAL_PATH = os.getenv("LOCAL_PATH", default='.')
NAMESPACE = os.getenv("NAMESPACE", default='default')

k8s_custom_deploy(
    'tanzu-java-web-app',
    apply_cmd="tanzu apps workload apply -f config/workload.yaml --update-strategy replace --debug --live-update" +
               " --local-path " + LOCAL_PATH +
               " --source-image " + SOURCE_IMAGE +
               " --namespace " + NAMESPACE +
               " --yes --output yaml",
    delete_cmd="tanzu apps workload delete -f config/workload.yaml --namespace " + NAMESPACE + " --yes",
    container_selector='workload',
    deps=['pom.xml', './target/classes'],
    live_update=[
      sync('./target/classes', '/workspace/BOOT-INF/classes')
    ]
)

k8s_resource('tanzu-java-web-app', port_forwards=["8080:8080"],
            extra_pod_selectors=[{'carto.run/workload-name': 'tanzu-java-web-app', 'app.kubernetes.io/component': 'run'}])
```

#### <a id="gradle"></a>Gradle Spring Boot project requirements

If you are using Gradle, review the following requirements:

- The `Tiltfile` looks like a [Maven Tiltfile](#maven) except for some key differences in the `deps=`
  and `live-update=` sections:

    ```starlark
        ...
        deps=['build.gradle.kts', './bin/main'],
        live_update=[
            sync('./bin/main', '/workspace/BOOT-INF/classes')
        ]
        ...
    ```

- The project must be built as an exploded JAR. This is not the default behavior for a Gradle-based build.
  For a typical Spring Boot Gradle project, you must deactivate the `jar` task in the `build.gradle.kts`
  file as follows:

    ```kotlin
    ...
    tasks.named<Jar>("jar") {
        enabled = false
    }
    ```

### <a id="set-up-ide"></a>Set up the IDE

After verifying your project has the required `Tiltfile` and Maven or Gradle build
support, you are ready to set up your development environment.

1. Open the Tanzu Java Web App as a project within your VS Code IDE by clicking **File** > **Open Folder**,
   select the Tanzu Java Web App folder and click **Open**.

   If you don't have the Tanzu Java Web App you can obtain it by following the instructions in
   [Generate a new project using an Application Accelerator](generate-first-app.html), or from the
   [Application Accelerator Samples](https://github.com/vmware-tanzu/application-accelerator-samples)
   GitHub page.

1. To ensure that your extension assists you with iterating on the correct project, configure its
   settings as follows:

   1. In Visual Studio Code, navigate to **Preferences** > **Settings** > **Extensions** > **Tanzu Developer Tools**.

   1. In the **Local Path** text box, provide the path to the directory containing the Tanzu Java Web App.
      The current directory is the default.

      The local path value tells the Tanzu Developer Tools for VS Code extension which directory on
      your local file system to bring into the source image.
      For example, dot (`.`) uses the working directory, or you can specify a full file path.

   1. [Customize the installation](../local-source-proxy/install.hbs.md#customize-install) of
      Local Source Proxy.

      If you don't have Local Source Proxy configured, you can use the source image parameter instead.
      The source image value tells the Tanzu Developer Tools for VS Code extension where to publish
      the container image with your non-compiled source code, and what to name that image.
      The image must be published to a container image registry where you have write access.
      For example, `gcr.io/myteam/tanzu-java-web-app-source`.

      > **Note** See the documentation for the registry you're using to find out which steps
      > are necessary to authenticate and gain push access.
      >
      > For example, if you use Docker, see the
      > [Docker documentation](https://docs.docker.com/engine/reference/commandline/login/), or
      > if you use Harbor, see the [Harbor documentation](https://goharbor.io/docs/1.10/working-with-projects/working-with-images/pulling-pushing-images/).
      >
      > For troubleshooting failed registry authentication, see
      > [Troubleshoot using Tanzu Application Platform](../troubleshooting-tap/troubleshoot-using-tap.md)

1. Confirm that your current Kubernetes context has a namespace associated with it.
   The **TANZU WORKLOADS** section of the **Explorer** view in the left Side Bar uses the namespace
   associated with your current Kubernetes context to populate the workloads from the cluster.

   1. Open the Terminal by clicking **View** > **Terminal**.

   2. Ensure your current context has a default namespace by running:

      ```console
      kubectl config get-contexts
      ```

      This command returns a list of all of your Kubernetes contexts with an asterisk (`*`) in front
      of your current context.
      Verify that your current context has a namespace in the namespace column.

   3. If your current context does not have a namespace in the namespace column, run:

      ```console
      kubectl config set-context --current --namespace=YOUR-DEVELOPER-NAMESPACE
      ```

      Where `YOUR-DEVELOPER-NAMESPACE` is the namespace value you want to assign to your
      current Kubernetes context.

You are now ready to iterate on your application.

## <a id="apply-your-app"></a>Apply your application to the cluster

Apply the workload to see your application running on the cluster by doing one of the following:

- In the **Explorer** view in the left Side Bar, right-click any file under the application name
  `tanzu-java-web-app` and click **Tanzu: Apply Workload** to begin applying the workload to the cluster.

- Alternatively, use the Command Palette, ⇧⌘P on Mac and Ctrl+Shift+P on Windows or
  **View** > **Command Palette**, to run the `Tanzu: Apply Workload` command.

The `apply workload` command runs, which opens a terminal and shows you the output of the workload apply.

You can also monitor your application as it's being deployed to the cluster using the **TANZU ACTIVITY**
tab in the Panel at the bottom of VS Code.
The **TANZU ACTIVITY** tab shows the details of the Kubernetes resources for the workloads running
in the namespace associated with your current Kubernetes context.

To view the **TANZU ACTIVITY** tab, open the Panel at the bottom of VS Code
(**View** > **Appearance** > **Panel**) and then click the **TANZU ACTIVITY** tab.
The apply workload command can take a few minutes to deploy your application onto the cluster.
After complete, you can see the workload running in the **TANZU WORKLOADS** section of the **Explorer**
view in the left Side Bar.

## <a id="live-update-your-app"></a>Enable Live Update for your application

Live Update allows you to save changes to your code and see those changes reflected within seconds
in the workload running on the cluster.

To enable Live Update for your application:

1. To begin Live Updating the workload on the cluster, do one of the following:

   - In the **Explorer** view in the left Side Bar, right-click any file under the application name
     `tanzu-java-web-app` and click `Tanzu: Live Update Start`.

   - Right-click the `tanzu-java-web-app` in the **TANZU WORKLOADS** section of the **Explorer** view
     and click `Tanzu: Live Update Start`.

   - From the Command Palette, ⇧⌘P on Mac and Ctrl+Shift+P on Windows, type in and select
     `Tanzu: Live Update Start`.

   You can view output from Tanzu Application Platform indicating that the container is being built
   and deployed.

   The status of Live Update is reflected in the **TANZU WORKLOADS** view under the `tanzu-java-web-app`
   workload entry. You can also see `Live Update starting...` in the status bar at the bottom right.
   Live update can take up to three minutes while the workload deploys and the Knative service becomes available.

   >**Note** Depending on the type of cluster you use, you might see an error similar to the following:
   >
   >`ERROR: Stop! cluster-name might be production.
   >If you're sure you want to deploy there, add:
   >allow_k8s_contexts('cluster-name')
   >to your Tiltfile. Otherwise, switch k8scontexts and restart Tilt.`
   >
   >Follow the instructions and add the line, `allow_k8s_contexts('cluster-name')` to your `Tiltfile`.

1. When the Live Update status in the **TANZU WORKLOADS** view changes from `Live Update Stopped` to
   `Live Update Running`, navigate to `http://localhost:8080` in your browser to view your running application.

1. In the IDE, make a change to the source code. For example, in `HelloController.java`,
   edit the string returned to say `Hello!`, and save.

1. The container is updated when the logs stop streaming. Go to your browser and refresh the page.

1. View the changes to the workload running on the cluster.

1. Either continue making changes, or stop the Live Update process when finished.
   To stop Live Update, open the Terminal by navigating to **View** > **Terminal**, and
   click the trash can icon that appears when you place your hover over the
   **tilt: up - tanzu-java-web-app** process, or select the process and use hot key ⌘+Backspace.

## <a id="debug-your-app"></a>Debug your application

Debug your application in a production-like environment by debugging on your Kubernetes cluster.

To debug the cluster:

1. Set a breakpoint in your code. For example, in `HelloController.java`, set a breakpoint on the
   line returning text.

1. [Apply your application to the cluster.](#apply-your-app)

1. Open the Panel at the bottom of VS Code by clicking **View** > **Appearance** > **Panel**.

1. In the Panel, click the **TANZU ACTIVITY** tab.

1. In the **TANZU ACTIVITY** tab, go to **Workload/tanzu-java-web-app** > **Running Application** > **Service/tanzu-java-web-app**.

1. Right-click the **Pod...** entry and select **Describe**.

   ![VS Code Tanzu Activity tab showing the describe action on the tanzu-java-web-app service.](../images/getting-started-iterate-vscode-service-describe.png)

1. In resulting output, copy the value after **Status** > **URL:** that begins with
   `https://tanzu-java-web-app...`. Make sure you copy the value from
   **Status** > **URL:** and *not* the value under **Status** > **Address** > **URL**.

   ![VS Code terminal showing the pod url.](../images/getting-started-iterate-vscode-service-url.png)

1. Open your web browser and paste the URL you copied to access your workload.

1. Begin debugging the workload on the cluster by doing one of the following:

   - In the **Explorer** view in the left Side Bar, right-click any file under the application name
     `tanzu-java-web-app` and click **Tanzu: Java Debug Start**.

   - Alternatively, right-click the `tanzu-java-web-app` in the **TANZU WORKLOADS** view and
     click **Tanzu: Java Debug Start**.

1. In a few moments, debugging is enabled on the workload. The **Deploy and Connect** task completes
   and the debug actions are made available to you in the debug overlay, indicating that the debugger
   has attached.

   The **TANZU WORKLOADS** view shows **Debug Running** under the `tanzu-java-web-app` workload.

1. In your web browser, reload your workload. VS Code opens to show your breakpoint.

1. You can now continue the program, or stop debugging, using the debug controls overlay.

## <a id="monitor-running-app"></a>Monitor your running application

Inspect the runtime characteristics of your running application using the Application Live View UI
to monitor:

- Resource consumption
- Java Virtual Machine (JVM) status
- Incoming traffic
- Change log level

You can also troubleshoot environment variables and fine-tune the running application.

Use the following steps to diagnose Spring Boot-based applications by using Application Live View:

1. Confirm that the Application Live View components are installed.
   For instructions, see [Install Application Live View](../app-live-view/install.md#install-alv-connector).

1. Access the Application Live View UI plug-in in Tanzu Developer Portal
   (formerly named Tanzu Application Platform GUI). For instructions, see
   [Entry point to Application Live View plug-in](../tap-gui/plugins/app-live-view.md#plug-in-entry-point).

1. Select your running application to view the diagnostic options and inside the application.
   For more information, see [Application Live View features](../tap-gui/plugins/app-live-view.md).

## <a id="delete-your-app"></a>Delete your application from the cluster

You can use the delete action to remove your application from the cluster by doing one of the following:

- In the **Explorer** view in the left Side Bar, right-click any file under the application name
  `tanzu-java-web-app` and click **Tanzu: Delete Workload** to delete the workload from the cluster.

- Alternatively, right-click the `tanzu-java-web-app` in the **TANZU WORKLOADS** view and click
  **Tanzu: Delete Workload**.

## <a id="next-steps"></a>Next steps

- [Consume services on Tanzu Application Platform](consume-services.md)
