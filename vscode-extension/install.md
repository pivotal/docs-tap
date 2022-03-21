# Installing Tanzu Dev Tools for Visual Studio Code

This topic explains how to install the VMware Tanzu Developer Tools for Visual Studio Code.

## <a id="prerequisites"></a> Prerequisites

Before installing the Tanzu Developer Tools IDE extension, you must have:

- The Kubernetes command-line tool.
For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/tools/).
- [Tilt](https://docs.tilt.dev/install.html) v0.23.2 or later.
You only need to install the Tilt component. Docker Desktop and local Kubernetes are not prerequisites for VMware Tanzu Dev Tools for Visual Studio Code.
- The Tanzu CLI. See [Install the Tanzu CLI](../install-tanzu-cli.md#cli-and-plugin).
- The Tanzu CLI apps plug-ins.
  See [Install the Tanzu CLI plug-ins](../install-tanzu-cli.md#cli-and-plugin)
- A cluster with Tanzu Application Platform, the default Supply Chain, and their dependencies. Download these from Tanzu Network. For installation instructions, see [Installing the Tanzu CLI](../install-tanzu-cli.md).
- [VSCode](https://code.visualstudio.com/download)

## <a id="installation"></a> Installation

To install VMware Tanzu Developer Tools for Visual Studio Code:

1. Download Tanzu Developer Tools for Visual Studio Code from [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
1. Open VSCode. From the Command Palette (`cmd` + `shift` + `P`), run "Extensions: Install from VSIX...". Select the extension file, `tanzu-vscode-extension.vsix`.
1. When you do not already have a Java Development Kit(JDK) installed, the Java extension pack prompts you to install one.
   Accept the dialog box to install the [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)
   and the [YAML Language Support by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml).
   These are required to support debug and code snippets, respectively.
1. Ensure Language Support for Java is running in [Standard Mode](https://code.visualstudio.com/docs/java/java-project#_lightweight-mode).

When the JDK and Language Support for Java are configured correctly,
you see that the integrated development environment creates a directory "target" where the code is compiled.

## <a id="configuration"></a> Configuration

To configure VMware Tanzu Developer Tools for Visual Studio Code:

1. Ensure that you are targeting the correct cluster. See [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) in the
Kubernetes documentation.

2. Select `File` (`Code` on Mac) -> `Preferences` -> `Settings` -> `Extensions` -> `Tanzu` and set the following:
  - Source Image (required): Destination for an image containing source code to be published
    - Example: `your-registry.io/project/tanzu-java-web-app-source`
  - Local Path (optional): Path on the local file system to a directory of source code to build (defaults to current directory)
  - Namespace (optional): Namespace that workloads are be deployed into (defaults to namespace set in kubeconfig)

## <a id="quick-start"></a> Quick Start

To quickly get you started, use the sample application with the necessary configuration files.

**Option 1: Application Accelerator**

1. Set up [Application Accelerator](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/index.html).

2. Search for the Tanzu Java Web App.

3. Add the required configuration information and generate the application.

4. Unzip and open in VSCode.

**Option 2: Sample repository**

1. Use `git clone` to clone the [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app) repository from GitHub.

2. Go to the `Tiltfile` and replace `your-registry.io/project` with your registry server and repository.

---

>**Note:** To start with existing applications, see [Code Snippets](usage-getting-started.md#snippets) in the Tanzu Dev Tools Usage documentation.

## <a id="uninstall"></a> Uninstall

To uninstall the Tanzu Dev Tools extension:

1. Navigate to the extensions menu.

2. Right-click the Tanzu Dev Tools extension and select **Uninstall**.
