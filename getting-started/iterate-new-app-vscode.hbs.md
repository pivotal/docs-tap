# Iterate on your new app using Tanzu Developer Tools for VS Code

This how-to guide walks you through starting to iterate on your first application on Tanzu Application Platform, which you deployed in the previous how-to, [Deploy your first application](deploy-first-app.md).

## <a id="you-will"></a>What you will do

- Prepare your IDE to iterate on your application.
- Apply your application to the cluster.
- Live update your application to view code changes updating live on the cluster.
- Debug your application.
- Monitor your running application on the Application Live View UI.
- Delete your application from the cluster.

## <a id="prepare-to-iterate"></a>Prepare your IDE to iterate on your application

In the previous Getting started how-to topic, [Deploy your first application](deploy-first-app.md), you deployed your first application on Tanzu Application Platform.
Now that you have a skeleton workload developed, you are ready to begin to iterate on your new application and test code changes on the cluster.

Tanzu Developer Tools for Visual Studio Code is VMware Tanzu’s official IDE extension for VS Code.
It helps you develop and receive fast feedback on your workloads running on the Tanzu Application Platform.

The VS Code extension enables live updates of your application while running on the cluster
and allows you to debug your application directly on the cluster.
For information about installing the prerequisites and the Tanzu Developer Tools for VS Code extension, see
[Install Tanzu Developer Tools for Visual Studio Code](../vscode-extension/install.md).

>**Important** Use Tilt v0.30.12 or a later version for the sample application.

1. Open the Tanzu Java Web App as a project within your VS Code IDE by selecting `File` > `Open Folder`, then selecting the Tanzu Java Web App folder and clicking the Open button. If you don't have the Tanzu Java Web App you can obtain it by following the [Generate a new project using an application accelerator](deploy-first-app.html#generate-a-new-project-using-an-application-accelerator-1) section of the Deploy an app page in the getting started guide, or from the [Application Accelerator Samples](https://github.com/vmware-tanzu/application-accelerator-samples) GitHub page.

2. To ensure your extension assists you with iterating on the correct project, configure its settings using the following instructions.

   1. In Visual Studio Code, navigate to `Preferences` > `Settings` > `Extensions` > `Tanzu Developer Tools`.
   2. In the **Local Path** field, provide the path to the directory containing the Tanzu Java Web App. The current directory is the default. The Local Path value tells the Tanzu Developer Tools extension which directory on your local file system to bring into the source image container image.
    For example, `.` uses the working directory, or you can specify a full file path.
   3. In the **Source Image** field, provide the destination image repository to publish an image containing the workload source code. The Source Image value tells the Tanzu Developer Tools extension where to publish the container image with your uncompiled source code, and what to name that image. The image must be published to a container registry where you have write (push) access.
    For example, `gcr.io/myteam/tanzu-java-web-app-source`.

    >**Note** Consult the documentation for the registry you're using to determine which steps are necessary to authenticate and gain push access.

    >For example, if you use docker consult [docker's docs](https://docs.docker.com/engine/reference/commandline/login/), if you use Harbor consult [Harbor's docs](https://goharbor.io/docs/1.10/working-with-projects/working-with-images/pulling-pushing-images/), etc. For troubleshooting failed registry authentication, consult our [troubleshooting docs](../troubleshooting-tap/troubleshoot-using-tap.md)

3. Confirm your current Kubernetes context has a namespace associated with it. The `TANZU WORKLOADS` panel, found on the left side of the VS Code Explorer tab, uses the namespace associated with your current Kubernetes context to populate the workloads from the cluster.
    - Open the Terminal (⌃\`), or by navigating to `View` > `Terminal`.
    - Ensure your current Kubernetes context has an associated namespace using the command `kubectl config get-contexts`. This command will return a list of all of your Kubernetes contexts with an asterisk (*) in front of your current context. Verify your current context has a namespace in the namespace column.
    - If your current context does not have a namespace in the namespace column, use the command `kubectl config set-context --current --namespace=YOUR-DEVELOPER-NAMESPACE`, replacing `YOUR-DEVELOPER-NAMESPACE` with the namespace value you would like to deploy the workload to.

You are now ready to iterate on your application.

## <a id="apply-your-app"></a>Apply your application to the cluster

Apply the workload to see your application running on the cluster.

1. In the Explorer tab of VS Code, right-click any file under the application name `tanzu-java-web-app` and select `Tanzu: Apply Workload` to begin applying the workload to the cluster.
1. Alternatively, use the Command Palette (⇧⌘P) or `View` > `Command Palette` to run the `Tanzu: Apply Workload` command.

The Apply Workload command will run, which opens a terminal and shows you the output of the Workload Apply. You can also monitor your application as it's being deployed to the cluster on the `Tanzu Activity` panel. The `Tanzu Activity` panel shows the details of the Kubernetes resources for the workloads running in the namespace associated with your current Kubernetes context. To view the `Tanzu Activity` panel, open the Terminal (⌃\`) and then click on the `Tanzu Activity` tab. The Apply Workload command can take a few minutes to deploy your application onto the cluster. Once complete, you will see the workload running in the `TANZU WORKLOADS` panel on the left side of the VS Code Explorer tab.


## <a id="live-update-your-app"></a>Live update your application

Live Update allows you to save changes to your code and see those changes reflected within seconds in the workload running on the cluster.

The following steps enable live update for your application:

1. On the left side of the Explorer tab of VS Code, right-click any file under the application name `tanzu-java-web-app` and select `Tanzu: Live Update Start` to begin Live Updating the workload on the cluster.
1. Alternatively, from the Command Palette (⇧⌘P) type in and select `Tanzu: Live Update Start`, or right-click the `tanzu-java-web-app` in the `TANZU WORKLOADS` panel and select `Tanzu: Live Update Start`.
You can view output from Tanzu Application Platform indicating that the container is being built and deployed.
    - You will see the status of Live Update reflected in the `TANZU WORKLOADS` panel under the `tanzu-java-web-app` workload entry.
    - You can also see "Live Update starting..." in the status bar at the bottom right.
    - Live update can take 1 to 3 minutes while the workload deploys and the Knative service becomes available.

    >**Note** Depending on the type of cluster you use, you might see an error similar to the following:

    >`ERROR: Stop! cluster-name might be production.
    >If you're sure you want to deploy there, add:
    >allow_k8s_contexts('cluster-name')
    >to your Tiltfile. Otherwise, switch k8scontexts and restart Tilt.
      `
    >Follow the instructions and add the line, `allow_k8s_contexts('cluster-name')` to your `Tiltfile`.

2. When the Live Update status in the `TANZU WORKLOADS` panel changes from `Live Update Stopped` to `Live Update Running`, navigate to `http://localhost:8080` in your browser to view your running application.
3. In the IDE, make a change to the source code. For example, in `HelloController.java`, edit the string returned to say `Hello!` and save.
4. The container is updated when the logs stop streaming. Navigate to your browser and refresh the page.
5. View the changes to the workload running on the cluster.
6. Either continue making changes, or stop the live update process when finished. To stop Live Update, open the Terminal (⌃\`), or by navigating to `View` > `Terminal`, and click the trash can icon that appears when you place your mouse over the `tilt: up - tanzu-java-web-app` process, or select the process and use hotkey (⌘Backspace).

## <a id="debug-your-app"></a>Debug your application

Debug your application in a production-like environment by debugging on your Kubernetes cluster.

Use the following steps to debug the cluster:

1. Set a breakpoint in your code. For example, in `HelloController.java`, set a breakpoint on the line `return`ing text.
1. [Apply your application to the cluster.](#apply-your-app)
1. Begin port forwarding.
  1. In the panel (`View` > `Appearance` > `Panel`) open the `Tanzu Activity` tab.
  1. Navigate to: `Workload/tanzu-java-web-app` > `Running Application` > `Service/tanzu-java-web-app` > `Configuration/tanzu-java-web-app` > `Revision/tanzu-java-web-app...` > `Deployment-tanzu-java-web-app...` > `ReplicaSet/tanzu-java-web-app...` > `Pod/tanzu-java-web-app...`
  1. Right-click on the `Pod...` entry and select `Describe`.
  1. Scroll to the top of the resulting output and highlight the content after `Name:`, it should begin with `tanz-java-web-app-0000...` and end with `deployment` followed by some characters. Copy this value.
  1. Scroll to the bottom of the same Terminal tab and run the command `kubectl port-forward <NAME> <PORT>:8080`, where the <NAME> value is the `Name:` from the previous step, and the <PORT> value is some port you would like to use, such as 8080.
  1. You will see output indicating that port forwarding has begun.
1. In the Explorer tab of VS Code, right-click any file under the application name `tanzu-java-web-app` and select `Tanzu: Java Debug Start` to begin debugging the workload on the cluster.
1. Alternatively, right-click the `tanzu-java-web-app` in the `TANZU WORKLOADS` panel and select `Tanzu: Java Debug Start`.
1. In a few moments debugging is enabled on the workload. The **Deploy and Connect** task completes and the debug actions are made available to you in the debug overlay, indicating that the debugger has attached.
1. You will notice that the `TANZU WORKLOADS` panel shows **Debug Running** under the `tanzu-java-web-app` workload.
1. In your browser, navigate to `localhost:<PORT>`, where the <PORT> value is the value you entered for <PORT> in the port forwarding command step.
1. You will see the tanzu-java-web-app running in your browser, and VS Code will open to show your breakpoint.
1. You can now resume the program, or stop debugging, using the debug controls overlay.
1. To stop port forwarding, navigate back to the `Terminal` in the Explorer tab and select the trash can icon next to the port forwarding terminal process.

## <a id="monitor-running-app"></a>Monitor your running application

Inspect the runtime characteristics of your running application using the Application Live View UI to monitor:

* Resource consumption
* Java Virtual Machine (JVM) status
* Incoming traffic
* Change log level

You can also troubleshoot environment variables and fine-tune the running application.

Use the following steps to diagnose Spring Boot-based applications by using Application Live View:

1. Confirm that the Application Live View components installed successfully. For instructions, see [Install Application Live View](../app-live-view/install.md#install-alv-connector).

1. Access the Application Live View Tanzu Application Platform GUI. For instructions, see [Entry point to Application Live View plug-in](../tap-gui/plugins/app-live-view.md#plug-in-entry-point).

1. Select your running application to view the diagnostic options and inside the application. For more information, see [Application Live View features](../tap-gui/plugins/app-live-view.md).

## <a id="delete-your-app"></a>Delete your application from the cluster

You can use the delete action to remove your application from the cluster.

1. In the Explorer tab of VS Code, right-click any file under the application name `tanzu-java-web-app` and select `Tanzu: Delete Workload` to delete the workload from the cluster.
1. Alternatively, right-click the `tanzu-java-web-app` in the `TANZU WORKLOADS` panel and select `Tanzu: Delete Workload`.

## Next steps

- [Consume services on Tanzu Application Platform](consume-services.md)
