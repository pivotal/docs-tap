# Install Tanzu Developer Tools for Visual Studio

This topic explains how to install VMware Tanzu Developer Tools for Visual Studio.

## <a id="prereqs"></a> Prerequisites

Ensure you have the following installed on your workstation before installing
Tanzu Developer Tools for Visual Studio:

- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/)
- [Tilt](https://docs.tilt.dev/install.html)
- [Tanzu CLI](../cli-plugins/tanzu-cli.hbs.md#tanzu-cli-install) and [plug-ins](../cli-plugins/tanzu-cli-plugin.hbs.md).
- A supported Kubernetes cluster with the Tanzu Application Platform Iterate profile or Full profile
  installed.
  Download Tanzu Application Platform from [VMware Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
  For more information about the profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).
- [Visual Studio](https://visualstudio.microsoft.com/vs/)

## <a id="install"></a> Install

To install the extension:

1. Sign in to VMware Tanzu Network and [download Tanzu Developer Tools for Visual Studio](https://network.pivotal.io/products/tanzu-application-platform/).
2. Download the artifact titled `Tanzu Developer Tools for Visual Studio`
3. Click on the installed `.vsix` file and go through the prompts.
4. Open Visual Studio and the extension should be installed and enabled.

## <a id="next-steps"></a> Next steps

Proceed to [Using Tanzu Developer Tools for Visual Studio](/docs-tap/vs-extension/using-the-extension.hbs.md) for steps on how to utilize the extension.


## <a id="uninstall"></a> Uninstall

To uninstall VMware Tanzu Developer Tools for Visual Studio:

1. Go to the `Extensions` tab and click on `Manage Extensions`
1. Clicki on the `Installed` section and then proceed to click on the `Uninstall` button for this extension.

