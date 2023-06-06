# Iterate on your new app using Tanzu Developer Tools for IntelliJ

This topic guides you through starting to iterate on your first application on
Tanzu Application Platform (commonly known as TAP).
You deployed the app in the previous how-to [Deploy your first application](deploy-first-app.hbs.md).

## <a id="you-will"></a>What you will do

- Prepare your IDE to iterate on your application.
- Live update your application to view code changes updating live on the cluster.
- Debug your application.
- Monitor your running application on the Application Live View UI.

## <a id="prepare-to-iterate"></a>Prepare your IDE to iterate on your application

In the previous Getting started how-to topic, [Deploy your first application](deploy-first-app.hbs.md),
you deployed your first application on Tanzu Application Platform.
Now that you have a skeleton workload developed, you are ready to begin to iterate on your new
application and test code changes on the cluster.

Tanzu Developer Tools for IntelliJ is VMware Tanzu’s official IDE extension for IntelliJ.
It helps you develop and receive fast feedback on your workloads running on the Tanzu Application Platform.

The IntelliJ extension enables live updates of your application while running on the cluster
and allows you to debug your application directly on the cluster.
For information about installing the prerequisites and the Tanzu Developer Tools for IntelliJ extension,
see [Install Tanzu Developer Tools for IntelliJ](../intellij-extension/install.hbs.md).

> **Important** Use Tilt v0.30.12 or later for the sample application.

1. Open the Tanzu Java Web App as a project within your IntelliJ IDE by selecting **File** > **Open**,
   then selecting the Tanzu Java Web App folder and clicking **Open**.
   If you don't have the Tanzu Java Web App you can obtain it by following the instructions in
   [Generate a new project using an Application Accelerator](generate-first-app.html), or from the
   [Application Accelerator Samples](https://github.com/vmware-tanzu/application-accelerator-samples)
   GitHub page.

2. Confirm that your current Kubernetes context contains a default namespace.
   The Tanzu Panel, found by clicking **Tanzu Panel** at the bottom-left of the IntelliJ window, uses
   the default namespace associated with your current Kubernetes context to populate the workloads
   from the cluster.

   1. Open the Terminal by clicking **View** > **Terminal**.

   2. Ensure that your current context has a default namespace by running:

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

Apply the workload to see your application running on the cluster:

1. In the **Project** tab in IntelliJ, right-click any file under the application name
   `tanzu-java-web-app` and click **Tanzu** > **Apply Workload**.

1. In the dialog box enter your **Source Image**, **Local Path**, and optionally a **Namespace**.

   1. In the **Source Image** text box, provide the destination image repository to publish an
      image containing your workload source code.

      The source image value tells the Tanzu Developer Tools for IntelliJ extension where to publish
      the container image with your uncompiled source code, and what to name that image.
      The image must be published to a container image registry where you have write (push) access.
      For example, `gcr.io/myteam/tanzu-java-web-app-source`.

      > **Note** See the documentation for the registry you're using to find out which steps are
      > necessary to authenticate and gain push access.
      >
      > For example, if you use Docker, see the [Docker documentation](https://docs.docker.com/engine/reference/commandline/login/),
      > or if you use Harbor, see the [Harbor documentation](https://goharbor.io/docs/1.10/working-with-projects/working-with-images/pulling-pushing-images/) and so on.

   1. In the **Local Path** text box, provide the path to the directory containing the Tanzu Java Web App.
      The current directory is the default.

      The local path value tells the Tanzu Developer Tools for IntelliJ extension which directory
      on your local file system to bring into the source image.
      For example, dot (`.`) uses the working directory, or you can specify a full file path.

   1. (Optional) In the **Namespace** text box, provide the namespace to be associated with the workload
      on the cluster. If you followed the steps to [Prepare your IDE to iterate on your application](#prepare-to-iterate)
      earlier, you do not need to enter a namespace because IntelliJ uses the namespace you associated with
      your context.

   1. Click the **OK** button.

The `apply workload` command runs, which opens a terminal and shows you the output of the command.
The `apply workload` command can take a few minutes to deploy your application onto the cluster.

You can also use the  **Tanzu Panel** to monitor your application as it's being deployed to the cluster.
The **Tanzu Panel** shows information about the workloads in the namespace associated with your
current Kubernetes context.
On the left side it shows the workloads in the namespace, and in the center it shows the details of
the Kubernetes resources for the running workloads.

## <a id="live-update-your-app"></a>Enable Live Update for your application

Live Update allows you to save changes to your code and see those changes reflected within seconds
in the workload running on the cluster.

The following steps enable Live Update for your application:

1. Create a Run Configuration.
   1. In IntelliJ, select the **Edit Run/Debug configurations** drop-down menu at the top-right corner.
      Alternatively, navigate to **Run** > **Edit Configurations**.
   1. Select **Tanzu Live Update**.
   1. Select **Add new run configuration**, or click the plus icon at the top of the list.
   1. Give your new run configuration a name, for example, `Tanzu Live Update - tanzu-java-web-app`.
   1. In the **Tiltfile Path** text box, provide the path to the `Tiltfile` in the Tanzu Java Web App
      project directory.
   1. Select the folder icon on the right-side of the text box, go to the `Tanzu Java Web App` directory,
      select the `Tiltfile`, and click **Open**. The `Tiltfile` facilitates Live Update using Tilt.
   1. In the **Local Path** text box, provide the path to the directory containing the Tanzu Java Web App.

      The local path value tells the Tanzu Developer Tools for IntelliJ extension which directory on
      your local file system to bring into the source image.

      For example, `/Users/developer/Documents/tanzu-java-web-app`.
   1. In the **Source Image** text box, provide the destination image repository to publish an image
      containing your workload source code.

      The source image value tells the Tanzu Developer Tools for IntelliJ extension where to publish
      the container image with your uncompiled source code, and what to name that image.
      The image must be published to a container image registry where you have write (push) access.
      For example, `gcr.io/myteam/tanzu-java-web-app-source`.

      > **Note** See the documentation for the registry you're using to find out which steps
      > are necessary to authenticate and gain push access.
      >
      > For example, if you use Docker, see the
      > [Docker documentation](https://docs.docker.com/engine/reference/commandline/login/), or
      > if you use Harbor, see the [Harbor documentation](https://goharbor.io/docs/1.10/working-with-projects/working-with-images/pulling-pushing-images/) and so on.

   1. Click **Apply**, and then click the **OK** button.

1. Begin Live Updating the application on the cluster by doing one of the following:

   - In the Project tab of IntelliJ, right-click the `Tiltfile` file under the application name
   `tanzu-java-web-app` and click **Run \'Tanzu Live Update - tanzu-java-web-app\'**.

   - Alternatively, click the **Edit Run/Debug configurations** drop-down menu in the top-right corner,
   select **Tanzu Live Update - tanzu-java-web-app**, and then click the green play button to the right
   of the **Edit Run/Debug configurations** drop-down menu.

   The **Run** tab opens and displays the output from Tanzu Application Platform and from Tilt indicating
   that the container is being built and deployed.

   On the **Tanzu Panel** tab, the status of Live Update is reflected under the
   `tanzu-java-web-app` workload entry.
   Live update can take 1 to 3 minutes while the workload deploys and the Knative service becomes available.

   >**Note** Depending on the type of cluster you use, you might see an error similar to the following:
   >
   >`ERROR: Stop! cluster-name might be production.
   >If you're sure you want to deploy there, add:
   >allow_k8s_contexts('cluster-name')
   >to your Tiltfile. Otherwise, switch k8scontexts and restart Tilt.`
   >
   >Follow the instructions and add the line, `allow_k8s_contexts('cluster-name')` to your `Tiltfile`.

1. When the Live Update task in the **Run** tab is successful, it resolves to `Live Update Started`.
   Use the hyperlink at the top of the Run output following the words **Tilt started on** to view
   your application in your browser.

1. In the IDE, make a change to the source code. For example, in `HelloController.java`, edit the
   string returned to say `Hello!` and save.

1. (Optional) Build your project by clicking **Build** > **Build Project** if you do not have
   **Build project automatically** activated under **Preferences** > **Build, Execution, Deployment** > **Compiler**.

1. The container is updated when the logs stop streaming. Navigate to your browser and refresh the page.

1. View the changes to your workload running on the cluster.

1. Either continue making changes, or stop the Live Update process when finished.
   To stop Live Update navigate to the **Run** tab at the bottom left of the IntelliJ window and click
   the red stop icon on the left side of the screen.

## <a id="debug-your-app"></a>Debug your application

Debug the cluster either on the application or in your local environment.

To debug the cluster:

1. Set a breakpoint in your code. For example, in `HelloController.java`, set a breakpoint on the
   line returning text.

1. Create a Run Configuration.
   1. In IntelliJ, select the **Edit Run/Debug configurations** drop-down menu at the top-right corner.
      Alternatively, navigate to **Run** > **Edit Configurations**.
   1. Select **Tanzu Debug Workload**.
   1. Select **Add new run configuration**, or click the plus icon at the top of the list.
   1. Give your new run configuration a name, for example, `Tanzu Debug Workload - tanzu-java-web-app`.
   1. In the **Workload File Path** text box, provide the path to the `workload.yaml` file in the
      Tanzu Java Web App project directory located at **Config** > **workload.yaml**.
   1. Select the folder icon on the right-side of the text box, navigate to the Tanzu Java Web App
      directory, select the `workload.yaml` file and click the **Open** button.
      The `workload.yaml` provides configuration instructions about your application to the Tanzu Application Platform.

   1. In the **Local Path** text box, provide the path to the directory containing the Tanzu Java Web App.

      The local path value tells the Tanzu Developer Tools for IntelliJ extension which directory on
      your local file system to bring into the source image.
      For example, `/Users/developer/Documents/tanzu-java-web-app`.

   1. In the **Source Image** text box, provide the destination image repository to publish an image
      containing your workload source code.

      The source image value tells the Tanzu Developer Tools for IntelliJ extension where to publish
      the container image with your uncompiled source code, and what to name that image.
      The image must be published to a container image registry where you have write (push) access.
      For example, `gcr.io/myteam/tanzu-java-web-app-source`.

      > **Note** See the documentation for the registry you're using to find out which steps are
      > necessary to authenticate and gain push access.
      >
      > For example, if you use Docker, see the
      > [Docker documentation](https://docs.docker.com/engine/reference/commandline/login/), or
      > if you use Harbor, see the
      > [Harbor documentation](https://goharbor.io/docs/1.10/working-with-projects/working-with-images/pulling-pushing-images/)
      > and so on.

   1. (Optional) In the **Namespace** text box, provide the namespace to be associated with the workload
      on the cluster. If you followed the steps to [Prepare your IDE to iterate on your application](#prepare-to-iterate)
      you do not need to enter a namespace because IntelliJ uses the namespace you associated with
      your context.

   1. Click **Apply**, and then click **OK**.

1. [Apply your application to the cluster.](#apply-your-app)

1. Obtain the URL for your workload:
   1. In the center panel of the **Tanzu Panel** go to
      **Workload/tanzu-java-web-app** > **Running Application** > **Service/tanzu-java-web-app**.

   1. Right-click the `Service/tanzu-java-web-app` entry and select **Describe**.

      ![IntelliJ Tanzu Panel showing the describe action on the tanzu-java-web-app service.](../images/getting-started-iterate-intellij-service-describe.png)

   1. In the resulting output, copy the value after **Status** > **URL:** that begins with
      `https://tanzu-java-web-app...`. Make sure you copy the value from
      **Status** > **URL:** and *not* the value under **Status** > **Address** > **URL**.

      ![IntelliJ terminal showing the pod URL.](../images/getting-started-iterate-intellij-service-url.png)

   1. Open your web browser and paste the URL you copied to access your workload.

1. In the Project tab of IntelliJ, right-click the `workload.yaml` file under the application name
   `tanzu-java-web-app` and select **Run \'Tanzu Debug Workload - tanzu-java-web-app\'** to begin debugging
   the application on the cluster.

    1. Alternatively, select the **Edit Run/Debug configurations** drop-down menu in the top-right corner,
       select **Tanzu Debug Workload - tanzu-java-web-app**, and then click the green debug button to the
       right of the **Edit Run/Debug configurations** drop-down menu.

1. The Debug tab opens and displays a message that it has connected.

1. In your web browser, reload your workload. IntelliJ opens to show your breakpoint.

1. You can now use the resume program action, or stop debugging, in the **Debug** tab.

## <a id="delete-your-app"></a>Delete your application from the cluster

You can use the delete action to remove your application from the cluster as follows:

1. In the **Project** tab, right-click any file under the application name `tanzu-java-web-app` and
   select **Tanzu** > **Delete Workload**.

1. Alternatively, right-click `tanzu-java-web-app` in the **TANZU WORKLOADS** panel and select
   **Delete Workload**.

1. In the confirmation dialog box that appears, click **OK** to delete the application from the cluster.

## <a id="next-steps"></a> Next steps

- [Consume services on Tanzu Application Platform](consume-services.md)
