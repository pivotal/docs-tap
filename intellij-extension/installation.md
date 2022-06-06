# Installing Tanzu Dev Tools for IntelliJ

This topic explains how to install the VMware Tanzu Developer Tools extension for IntelliJ IDEA.

## <a id="prerequisites"></a> Prerequisites

> **Note:** The Tanzu Developer Tools extension currently only supports macOS, and Java Applications.

Before installing the Tanzu Developer Tools IDE extension, you must have:

- [IntelliJ](https://www.jetbrains.com/idea/download/#section=mac)
- The Kubernetes command-line tool. For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/tools/#kubectl).
- [Tilt](https://docs.tilt.dev/install.html) v0.24.0 or later

    >**Note:** Docker Desktop and local Kubernetes are not prerequisites for using Tanzu Developer Tools for VS Code.

- The Tanzu CLI and plug-ins. See [Install or update the Tanzu CLI and plug-ins](../install-tanzu-cli.html#-install-or-update-the-tanzu-cli-and-plug-ins) for more information.
- A cluster with Tanzu Application Platform’s Iterate or Full profiles. Download the profiles from the [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/). See [Installing the Tanzu Application Platform package and profiles](install.html) for more information.

> **Note:** If you are an app developer, the Tanzu Application Platform environment might be set up by someone else in your organization. Contact the respective group within your organization to verify if a Tanzu Application Platform environment already exists.

## <a id="installation"></a> Installation

To install VMware Tanzu Developer Tools for IntelliJ:

1. Download Tanzu Developer Tools for IntelliJ from the [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
1. Open IntelliJ.
  1. Open the Preferences pane by pressing `cmd` + `,` and navigate to **Plugins**.
  2. Select the gear icon and choose **Install Plugin from disk...**.
  ![Gear icon inside the Plugins Preferences pane.](../images/intellij-gearIconPrefs.png)
  3. Use the file picker to select the `.zip` downloaded from the Tanzu Network.

## <a id="configuration"></a> Configuration

To configure the VMware Tanzu Developer Tools extension for IntelliJ:

1. Ensure that you target the correct cluster. See [Kubernetes documentation](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) for more information.
1. Select **Preferences -> Build, Execution, Deployment -> Tanzu** and set the following:

    - [Source Image](glossary.md#source-image) (required): Destination for an image containing the source code to be published.

        Example: `your-registry.io/project/tanzu-java-web-app-source`

    - [Local Path](glossary.md#local-path) (required): Path on the local file system to a directory of the source code to build.

        >**Note:** This must be the full path to your source code directory. You can use the file picker or enter it manually.
        
    - [Namespace](glossary.md#namespace) (optional): Namespace that the workloads are deployed into (defaults to `default`).

## <a id="uninstallation"></a> Uninstallation

To uninstall the Tanzu Dev Tools extension:

1. Navigate to **Preferences -> Plugins**.
2. Select the Tanzu Dev Tools plugin, navigate to the gear icon and select `Uninstall`.

>**Note:** You might need to restart IntelliJ for the changes to take effect.

## <a id="whats-next"></a> What's Next

When finished on this page, proceed to [Using Tanzu Dev Tools to get started](getting-started.md).
