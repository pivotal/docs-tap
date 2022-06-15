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

## <a id="uninstallation"></a> Uninstallation

To uninstall the Tanzu Dev Tools extension:

1. Navigate to **Preferences -> Plugins**.
2. Select the Tanzu Dev Tools plugin, navigate to the gear icon and select `Uninstall`.

>**Note:** You might need to restart IntelliJ for the changes to take effect.

## <a id="whats-next"></a> What's Next

When finished on this page, proceed to [Using Tanzu Dev Tools to get started](getting-started.md).
