---
title: Install the Visual Studio Code Tanzu Extension
subtitle: How to install the VSCode Tanzu Extension
weight: 2
---

This topic explains how to install the Visual Studio Code Tanzu Extension.

## Prerequisites

Prior to installing the VSCode Tanzu Extension, you must have:

- The Kubernetes command-line tool, [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Tilt](https://docs.tilt.dev/install.html) version >= v0.22.6
- The Tanzu CLI.
  See [Install the Tanzu CLI](../install-general.md#cli-and-plugin).
- The Tanzu CLI package plugin.
  See [Install the Tanzu CLI Plugins](../install-general.md#install-the-tanzu-cli-plugins).
- A cluster with Tanzu Application Platform, the default Supply Chain, and their dependencies. Download these from Tanzu Network. For installation instructions, see [Installing Part I: Prerequisites, EULA, and CLI](../install-general.md).
- [VSCode](https://code.visualstudio.com/download)

---

## Installation

Download the extension from Tanzunet [here](https://network.tanzu.vmware.com/products/tanzu-developer-tools-for-vscode/)

Launch VSCode and navigate to the `Extensions` menu (⇧⌘X), then from the `Views and More Actions` menu (...) select `Install from VSIX...` Select the `tanzu-vscode-extension.vsix` file downloaded from Tanzunet.

> **Note:** Upon installation, you will be prompted to install the [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack) and the [YAML Language Support by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml). These are required dependencies for debugging, live-reloading, and enabling snippets. Ensure Language Support for Java is running in [Standard Mode](https://code.visualstudio.com/docs/java/java-project#_lightweight-mode).

When you do not already have a Java Development Kit installed, the Java extension pack prompts you to install one.
When the JDK and Language Support for Java are configured correctly,
you see that the intigrated development enviroment creates a directory "target" where the code is compiled.

> Note: `Extensions: Install from VSIX...` can also be launched via the `Command Palette` (⇧⌘P)

---

## Configuration

Ensure that you are targeting the correct cluster. See [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).

### Quick start

Get up and running quickly by using Application Accelerator and bootstrapping your development with the [Tanzu Java Web App](https://github.com/sample-accelerators/tanzu-java-web-app). For information about how to use Application Accelerator, see [Installing Application Accelerator for VMware Tanzu](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.3/acc-docs/GUID-installation-install.html). This accelerator will require you to specify a name for your application and an image repository. This accelerator will also  handle other configurations.

> **Note:** We recommend that you use this accelerator to bootstrap your application for the smoothest experience with the extension.

### Manual

Create a `workload.yaml` file in your project. See [config/workload.yaml](https://github.com/sample-accelerators/tanzu-java-web-app) in the Tanzu Java Web App.

Create a `Tiltfile` for your project. See [Tiltfile](https://github.com/sample-accelerators/tanzu-java-web-app) in the Tanzu Java Web App. For information about `Tiltfile's`, see [Tiltfile API Reference](https://docs.tilt.dev/api.html).

### Snippets

If you'd like to bootstrap your own project, snippets are provided to help you write a workload.yaml, catalog-info.yaml, or ``Tiltfile`.

To trigger the `yaml` snippets, use the keywords `tanzu workload` or `tanzu catalog-info` respectively when editing a .yaml file. The `Tiltfile` snippet can be triggered with `tanzu tiltfile` when editing in plain text or python.
