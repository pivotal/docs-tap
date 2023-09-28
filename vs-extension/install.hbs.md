# Install Tanzu Developer Tools for Visual Studio

This topic tells you how to install VMware Tanzu Developer Tools for Visual Studio.

## <a id="prereqs"></a> Prerequisites

Ensure that you have the following installed on your workstation before installing
Tanzu Developer Tools for Visual Studio:

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Tilt](https://docs.tilt.dev/install.html)
- [Tanzu CLI](../cli-plugins/tanzu-cli.hbs.md#tanzu-cli-install) and
  [plug-ins](../cli-plugins/tanzu-cli-plugin.hbs.md).
- A supported Kubernetes cluster with the Tanzu Application Platform Iterate profile or Full profile
  installed.
  Download Tanzu Application Platform from [VMware Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
  For more information about the profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).
- [Visual Studio 2022](https://visualstudio.microsoft.com/vs/)

## <a id="install"></a> Install

To install the extension:

1. Sign in to VMware Tanzu Network and
   [download Tanzu Developer Tools for Visual Studio](https://network.pivotal.io/products/tanzu-application-platform/).
2. Double-click the `.vsix` install file and click through the prompts.
3. Open Visual Studio and verify that the extension is installed and enabled.

## <a id="next-steps"></a> Next steps

See [Use Tanzu Developer Tools for Visual Studio](using-the-extension.hbs.md).

## <a id="uninstall"></a> Uninstall

To uninstall VMware Tanzu Developer Tools for Visual Studio:

1. Go to the **Extensions** tab and click **Manage Extensions**.
2. Click on the **Installed** section and then click the **Uninstall** button for this extension.
