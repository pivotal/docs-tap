# Install Tanzu Developer Tools for Visual Studio

This topic tells you how to install VMware Tanzu Developer Tools for Visual Studio.

## <a id="prereqs"></a> Prerequisites

Ensure that you have the following installed on your workstation before installing
Tanzu Developer Tools for Visual Studio:

- [Visual Studio 2022](https://visualstudio.microsoft.com/vs/) v17.7 or later
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Tilt](https://docs.tilt.dev/install.html) v0.30.12 or later
- [Tanzu CLI and plug-ins](../install-tanzu-cli.hbs.md#cli-and-plugin)
- [A cluster with the Tanzu Application Platform Full profile or Iterate profile](../install-online/profile.hbs.md)

> **Note** If you are an app developer, someone else in your organization might have already set up
> the Tanzu Application Platform environment.

## <a id="install"></a> Install

To install the extension:

1. Sign in to VMware Tanzu Network and
   [download Tanzu Developer Tools for Visual Studio](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
2. Double-click the `.vsix` install file and click through the prompts.
3. Open Visual Studio and verify that the extension is installed and enabled.

   ![Tanzu Developer Tools is selected within the Manage Extensions pane.](../images/vs-extension/about.png)

## <a id="uninstall"></a> Uninstall

To uninstall:

1. From the top menu, click the **Extensions** tab and then click **Manage Extensions**.
1. Select the **Installed** section and then click the **Uninstall** button for this extension.

## <a id="next-steps"></a> Next steps

[Use Tanzu Developer Tools for Visual Studio](using-the-extension.hbs.md).
