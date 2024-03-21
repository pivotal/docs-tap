# Install Tanzu Developer Tools for IntelliJ

This topic explains how to install the VMware Tanzu Developer Tools for IntelliJ IDE extension.
The extension currently only supports Java applications on macOS and Windows.

## <a id="prereqs"></a> Prerequisites

Before installing the extension, you must have:

- [IntelliJ](https://www.jetbrains.com/idea/download/#section=mac)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [Tilt](https://docs.tilt.dev/install.html) v0.30.12 or later
- [Tanzu CLI and plug-ins](../install-tanzu-cli.hbs.md#cli-and-plugin)
- [A cluster with the Tanzu Application Platform Full profile or Iterate profile](../install-online/profile.hbs.md)

> **Note** If you are an app developer, someone else in your organization might have already set up
> the Tanzu Application Platform environment.

## <a id="install"></a> Install

To install VMware Tanzu Developer Tools for IntelliJ:

1. Open IntelliJ.
2. Open the command palette, enter `Plugins`, and then click **Plugins**.
3. Select the **Marketplace** tab in the **Plugins Settings** dialog box.
4. In the search box enter `Tanzu`.
5. Click **Tanzu Developers Tools** and then click **Install**.

## <a id="update"></a> Update

To update to a later version, repeat the steps in the [Install](#install) section.
You do not need to uninstall the current version.

## <a id="uninstall"></a> Uninstall

To uninstall the VMware Tanzu Developer Tools for IntelliJ:

1. Open the **Preferences** pane and then go to **Plugins**.
1. Select the extension, click the gear icon, and then click **Uninstall**.
1. Restart IntelliJ.

## <a id="next-steps"></a> Next steps

Proceed to [Getting started](getting-started.hbs.md).
