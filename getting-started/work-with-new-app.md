# Work with your new application

In the previous Getting started topic, [Develop your first application](develop-first-app.md), you developed your first application on Tanzu Application Platform.
Now that you have a skeleton workload developed, you are ready to begin working with your new application.

## <a id="iterate"></a>Iterate on your application

Begin by iterating on your application and testing code changes on the cluster. Tanzu Developer Tools for Visual Studio Code, VMware Tanzu’s official IDE extension for VSCode,
helps you develop and receive fast feedback on your workloads running on the Tanzu Application Platform.

The VSCode extension enables live updates of your application while running on the cluster
and allows you to debug your application directly on the cluster.
For information about installing the prerequisites and the Tanzu Developer Tools extension, see
[Install Tanzu Dev Tools for VSCode](../vscode-extension/installation.md).

>**Important:** Use Tilt v0.23.2 or a later version for the sample application.

1. Open the Tanzu Java Web App as a project within your VSCode IDE.

2. To ensure your extension assists you with iterating on the correct project, configure its settings using the following instructions.

   - In Visual Studio Code, navigate to `Preferences` > `Settings` > `Extensions` > `Tanzu`.
   - In the **Local Path** field, provide the path to the directory containing the Tanzu Java Web App. The current directory is the default.
   - In the **Source Image** field, provide the destination image repository to publish an image containing your workload source code.
    For example, `gcr.io/myteam/tanzu-java-web-app-source`.

You are now ready to iterate on your application.

## <a id="live-update-your-app"></a>Live update your application

Deploy the application to view it updating live on the cluster to demonstrate how code changes are going to behave on a production cluster early in the development process.

Follow the following steps to live update your application:

1. From the Command Palette (⇧⌘P), type in and select `Tanzu: Live Update Start`.
You can view output from Tanzu Application Platform and from Tilt indicating that the container is being built and deployed.
    - You see "Live Update starting..." in the status bar at the bottom right.
    - Live update can take 1 to 3 minutes while the workload deploys and the Knative service becomes available.

    >**Note:** Depending on the type of cluster you use, you might see an error similar to the following:

    >`ERROR: Stop! cluster-name might be production.
    >If you're sure you want to deploy there, add:
    >allow_k8s_contexts('cluster-name')
    >to your Tiltfile. Otherwise, switch k8scontexts and restart Tilt.
      `
    >Follow the instructions and add the line `allow_k8s_contexts('cluster-name')` to your `Tiltfile`.

2. When the Live Update status in the status bar is visible, resolve to "Live Update Started," navigate to `http://localhost:8080` in your browser, and view your running application.
3. Enter to the IDE and make a change to the source code. For example, in `HelloController.java`, edit the string returned to say `Hello!` and save.
4. The container is updated when the logs stop streaming. Navigate to your browser and refresh the page.
5. View the changes to your workload running on the cluster.
6. Either continue making changes, or stop and deactivate the live update when finished. Open the command palette (⇧⌘P), type `Tanzu`, and choose an option.

## <a id="debug-your-app"></a>Debug your application

Debug your cluster either on the application or in your local environment.

Follow the following steps to debug your cluster:

1. Set a breakpoint in your code.
2. Right-click the file `workload.yaml` within the `config` directory, and select **Tanzu: Java Debug Start**. In a few moments, the workload is redeployed with debugging enabled. You are going to see the "Deploy and Connect" Task complete and the debug menu actions are available to you, indicating that the debugger has attached.
3. Navigate to `http://localhost:8080` in your browser. This hits the breakpoint within VSCode. Play to the end of the debug session using VSCode debugging controls.

## <a id="monitor-running-app"></a>Monitor your running application

Inspect the runtime characteristics of your running application using the Application Live View UI to monitor:

* Resource consumption
* Java Virtual Machine (JVM) status
* Incoming traffic
* Change log level

You can also troubleshoot environment variables and fine-tune the running application.

Follow the following steps to diagnose Spring Boot-based applications using Application Live View:

1. Confirm that the Application Live View components installed successfully. For instructions, see [Install Application Live View](../app-live-view/install.md#install-app-live-view-connector).

1. Access the Application Live View Tanzu Application Platform GUI. For instructions, see [Entry point to Application Live View plug-in](../tap-gui/plugins/app-live-view.md#plug-in-entry-point).

1. Select your running application to view the diagnostic options and inside the application. For more information, see [Application Live View features](../tap-gui/plugins/app-live-view.md).

## Next step

- [Create your application accelerator](create-app-accelerator.md)
