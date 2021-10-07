---
title: Install
subtitle: How to install the VSCode Tanzu Extension
weight: 2
---

This topic explains how to install the VSCode Tanzu Extension.

## Prerequisites

Prior to installing the VSCode Tanzu Extension, you must have:

- The Kubernetes command-line tool, [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Tilt](https://docs.tilt.dev/install.html) version >= v0.22.6
- The [Tanzu CLI and apps plugin](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.1/tap-0-1/GUID-install.html#install-the-tanzu-cli-and-package-plugin-4)
- A cluster with Tanzu Application Platform, the Default Supply Chain, and their dependencies. Download these from Tanzu Network. Follow the instructions [here](../install-general.md) to install.
- [VSCode](https://code.visualstudio.com/download)

---

## Installation

Download the extension from Tanzunet [here](https://network.tanzu.vmware.com/products/tanzu-developer-tools-for-vscode/)

Launch VSCode and navigate to the `Extensions` menu (⇧⌘X), then from the `Views and More Actions` menu (...) select `Install from VSIX...` Select the `tanzu-vscode-extension.vsix` file downloaded from Tanzunet.

> Note: Upon installation, you should be prompted to install the [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack). These are required dependencies for debugging and live-reloading. Ensure Language Support for Java is running in [Standard Mode](https://code.visualstudio.com/docs/java/java-project#_lightweight-mode).

If you do not already have a JDK installed, the Java extension pack prompts you to install one.
If the JDK and Language Support for Java are configured correctly,
you see that IDE creates a directory "target" where the code is compiled.

> Note: `Extensions: Install from VSIX...` can also be launched via the `Command Palette` (⇧⌘P)

---

## Configuration

Start by ensuring that you're targeted to the right cluster by following [these instructions](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).

### Quickstart

Get up and running quickly by using Application Accelerator and bootstrapping your development with the [Tanzu Java Web App](https://github.com/sample-accelerators/tanzu-java-web-app). You can find instructions to use Application Accelerator [here](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.3/acc-docs/GUID-installation-install.html#using-application-accelerator-for-vmware-tanzu-0). This accelerator will require you to specify a name for your application and an image repository, and will handle other configuration.


> Note: For this beta, we recommend that you use this accelerator to bootstrap your application for the smoothest experience with the extension.

### Manual

Create a `workload.yaml` file in your project. For reference, take a look at `config/workload.yaml` in the Tanzu Java Web App [here](https://github.com/sample-accelerators/tanzu-java-web-app).

Create a `Tiltfile` for your project. For reference, take a look at `Tiltfile` in the Tanzu Java Web App [here](https://github.com/sample-accelerators/tanzu-java-web-app). Tiltfile documentation can be found [here](https://docs.tilt.dev/api.html).
