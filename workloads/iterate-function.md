# Iterate on your function

This topic provides instructions about how to iterate on your function using the
VMware Tanzu Developer Tools extension for Visual Studio Code.
This extension enables live updates of your application while running on the
cluster, and allows you to debug your application directly on the cluster.

## <a id="prereqs"></a> Prerequisites

Before you can iterate on your function, you must have:

- [Tanzu Developer Tools for Visual Studio Code](../vscode-extension/installation.md)
- [Tilt](https://docs.tilt.dev/install.html) v0.27.2 or later.
<!-- get links for these? -->

> **Note:** The Tanzu Developer Tools extension currently only supports Java Functions.

## <a id="configuration"></a> Configuration

<!-- Configure VSCode? Configure the Tanzu Developer Tools extension? -->

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

Deploy your function application to view it updating live on the cluster to demonstrate
how code changes are going to behave on a production cluster early in the development process.

To live update your application:

1. Open the Command Palette by pressing **⇧⌘P**.

1. Form the Command Palette, type in and select **Tanzu: Live Update Start**.
You can view output from Tanzu Application Platform and from Tilt indicating that
the container is being built and deployed.

    - You see `Live Update starting…` in the status bar at the bottom right.
    
    - Live update can take 1 to 3 minutes while the workload deploys and the Knative service becomes available.

2. Note: Depending on the type of cluster you use, you might see an error message similar to the following:
`ERROR: Stop! cluster-name might be production.` If you're sure you want to deploy there, add: allow_k8s_contexts('cluster-name') to your Tiltfile. Otherwise, switch k8scontexts and restart Tilt. Follow the instructions and add the line allow_k8s_contexts('cluster-name') to your Tiltfile. <!-- Clarify this step. Is this all part of the error message or are these instructions? -->

3. When the Live Update status in the status bar is visible, resolve to
`Live Update Started`, <!-- clarify --> navigate to `http://localhost:8080` in your browser,
and view your running application.

4. Enter the IDE and make a change to the source code.
For example, in `HelloController.java`, edit the string returned to say `Hello!` and save.

5. The container is updated when the logs stop streaming. Navigate to your browser and refresh the page.

6. View the changes to your workload running on the cluster.

7. Either continue making changes, or stop and deactivate the live update when finished.
Open the command palette by pressing **⇧⌘P**, type Tanzu, and choose an option. <!-- Clarify -->

## <a id="debug-app"></a> Debug your application

Debug your cluster either on the application or in your local environment.

To debug your cluster:

1. Set a breakpoint in your code.

2. Right-click the file `workload.yaml` within the config directory, and select **Tanzu: Java Debug Start**.

    In a few moments, the workload is redeployed with debugging enabled.
    You will see the `Deploy and Connect` task complete and the debug menu actions
    are available to you, indicating that the debugger has attached.

3. Navigate to `http://localhost:8080` in your browser. This hits the breakpoint within VSCode.
Play to the end of the debug session using VSCode debugging controls.
