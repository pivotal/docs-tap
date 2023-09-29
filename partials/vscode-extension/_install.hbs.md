This topic tells you how to install VMware Tanzu Developer Tools for Visual Studio Code (VS Code).

## <a id="prereqs"></a> Prerequisites

Before installing the extension, you must have:

- [VS Code](https://code.visualstudio.com/download)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [Tilt](https://docs.tilt.dev/install.html) v0.30.12 or later
- [Tanzu CLI and plug-ins](/docs-tap/install-tanzu-cli.hbs.md#cli-and-plugin)
- [A cluster with the Tanzu Application Platform Full profile or Iterate profile](/docs-tap/install-online/profile.hbs.md)

If you are an app developer, someone else in your organization might have already set up the
Tanzu Application Platform environment.

Docker Desktop and local Kubernetes are not prerequisites for using Tanzu Developer Tools for VS Code.

## <a id="install"></a> Install

VMware Tanzu Developer Tools for VS Code is available from:

- [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=vmware.tanzu-dev-tools)
- [VMware Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform).

Visual Studio Marketplace (recommended)
: To install Visual Studio Marketplace:

   1. Open Visual Studio Code.
   2. Open the command palette.
   3. In the search box enter `Extension`.
   4. Click **Extensions: Install Extensions**.
   5. The **Extensions** view opens on the left side of your screen. In the search box enter `Tanzu`.
   6. Click **Tanzu Developer Tools** and then click **Install**.

VMware Tanzu Network
: To install from VMware Tanzu Network:

   1. Sign in to VMware Tanzu Network and
      [download Tanzu Developer Tools for VS Code](https://network.tanzu.vmware.com/products/tanzu-application-platform).
   2. Open VS Code.
   3. From the command palette run `Extensions: Install from VSIX...`.
   4. Click the extension file `tanzu-vscode-extension.vsix`.
   5. If you do not have the following extensions, and they do not automatically install, install
      them from Visual Studio Marketplace:

      - [Debugger for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug)
      - [Language Support for Java(™) by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.java)
      - [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)

   6. Go to **Code** > **Preferences** > **Settings** > **Java** > **Server: Launch Mode** and verify
      that Language Support for Java is running in
      [Standard Mode](https://code.visualstudio.com/docs/java/java-project#_lightweight-mode).

      When the Java Development Kit and Language Support for Java are configured correctly, you
      can see that the integrated development environment creates a directory target where the code is
      compiled.

## <a id="configure"></a> Configure

To configure VMware Tanzu Developer Tools for VS Code:

1. Ensure that you are targeting the correct cluster. For more information, see the
   [Kubernetes documentation](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).

2. Go to **Code** > **Preferences** > **Settings** > **Extensions** > **Tanzu Developer Tools** and
   set the following:

   - **Confirm Delete**: This controls whether the extension asks for confirmation when deleting a
     workload.
   - **Enable Live Hover**: For more information, see
     [Integrating Live Hover by using Spring Boot Tools](/docs-tap/vscode-extension/live-hover.hbs.md).
     Reload VS Code for this change to take effect.
   - **Source Image**: The registry location for publishing local source code. For example,
     `registry.io/yourapp-source`. This must include both a registry and a project name. A source
     image registry location is optional when Local Source Proxy is configured.
   - **Local Path**: (Optional) The path on the local file system to a directory of source code to
     build. This is the current directory by default.
   - **Namespace**: (Optional) This is the namespace that workloads are deployed into. The namespace
     set in `kubeconfig` is the default.

## <a id="uninstall"></a> Uninstall

To uninstall VMware Tanzu Developer Tools for VS Code:

1. Go to **Code** > **Preferences** > **Settings** > **Extensions**.
1. Right-click the extension and select **Uninstall**.

## <a id="next-steps"></a> Next steps

Proceed to [Getting started with Tanzu Developer Tools for Visual Studio Code](/docs-tap/vscode-extension/getting-started.hbs.md).
