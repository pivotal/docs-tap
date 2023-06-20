# Iterating on your function

This topic tells you how to iterate on your function using the
VMware Tanzu Developer Tools extension for Visual Studio Code.

## <a id="prereqs"></a> Prerequisites

Before you can iterate on your function, you must have:

- [Tanzu Developer Tools for Visual Studio Code](../vscode-extension/install.md). This extension enables live updates of your application while running on the cluster, and allows you to debug your application directly on the cluster.
- [Tilt](https://docs.tilt.dev/install.html) v0.30.12 or later.

> **Important** The Tanzu Developer Tools extension currently only supports Java Functions.
## <a id="configuration"></a> Configure the Tanzu Developer Tools extension

Before iterating on your application, you must configure the Tanzu Developer Tools extension as follows:

1. Open your function as a project within your VSCode IDE.

2. To ensure your extension assists you with iterating on the correct project,
configure its settings as follows:

    1. In Visual Studio Code, navigate to Preferences > Settings > Extensions > Tanzu.

    1. In the Local Path field, provide the path to the directory containing your function project.
    The current directory is the default.

    1. In the Source Image field, provide the destination image repository to publish
    an image containing your workload source code. For example, `index.docker.io/myteam/java-function`.

You are now ready to iterate on your application.

## <a id="live-update"></a> Live update your application

Deploy your function application to view it updating live on the cluster.
This demonstrates how code changes will behave on a production cluster early in the development process.

To live update your application:

1. Open the Command Palette by pressing **⇧⌘P**.

1. From the Command Palette, type in and select **Tanzu: Live Update Start**.
You can view output from Tanzu Application Platform and from Tilt indicating that
the container is being built and deployed.

    - You see `Live Update starting…` in the status bar at the bottom right.

    - Live update can take 1 to 3 minutes while the workload deploys and the Knative service
    becomes available.

1. Depending on the type of cluster you use, you might see an error message similar to the following:

    >`ERROR: Stop! cluster-name might be production. If you're sure you want to deploy there,
    >add allow_k8s_contexts('cluster-name') to your Tiltfile. Otherwise, switch k8scontexts
    >and restart Tilt.`

    If you see this error, add the line `allow_k8s_contexts('CLUSTER-NAME')` to your Tiltfile,
    where `CLUSTER-NAME` is the name of your cluster.

1. When the Live Update status in the status bar is visible and says
`Live Update Started`, navigate to `http://localhost:8080` in your browser
and view your running application.

1. Enter the IDE and make a change to the source code.

1. The container is updated when the logs stop streaming. Navigate to your browser and refresh the page.

1. View the changes to your workload running on the cluster.

    > **Note:** When using Live Update, hot reload of your function on your cluster might not
    > display changes made to your function.
    > To manually push changes to the cluster, run the `tilt up` command.

1. If necessary, continue making changes to the source code.

1. When you have finished making changes, stop and deactivate the Live Update.
To do so, open the command palette by pressing **⇧⌘P**, type `Tanzu`, and select **Tanzu: Live Update Stop**.

## <a id="debug-app"></a> Debug your application

Debug your cluster either on the application or in your local environment.

To debug your cluster:

1. Set a breakpoint in your code.

1. Right-click the file `workload.yaml` within the `config` directory, and select **Tanzu: Java Debug Start**.

    In a few moments, the workload is redeployed with debugging enabled.
    You will see the Deploy and Connect task complete and the debug menu actions
    available to you, indicating that the debugger has attached.

1. Navigate to `http://localhost:8080` in your browser. This hits the breakpoint within VSCode.
Play to the end of the debug session using VSCode debugging controls.
