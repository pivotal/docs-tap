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
- A cluster with Tanzu Application Platform, the Default Supply Chain, and their dependencies. Download these from Tanzunet. **!! Placeholder for link to docs written for [TD-286](https://jira.eng.vmware.com/browse/TD-286) !!**
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

[Ensure that you're targeted to the right cluster](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)

Create a `workload.yaml` file in your project. For reference, take a look at `config/workload.yaml` in our app-accelerator project [here](https://preview-scdc1-staging-tss-server.svc-stage.eng.vmware.com/dashboard/accelerators/tanzu-java-web-app). **!! Placeholder for link to supply-chain-choreographer docs on workloads here !!**

Create a `Tiltfile` for your project. For reference, take a look at `Tiltfile` in our app-accelerator project [here](https://preview-scdc1-staging-tss-server.svc-stage.eng.vmware.com/dashboard/accelerators/tanzu-java-web-app). Tiltfile documentation can be found [here](https://docs.tilt.dev/api.html).

---

## Quickstart

Get up and running quickly by downloading the Tanzu Java Web App from the App Accelerator [here](https://preview-scdc1-staging-tss-server.svc-stage.eng.vmware.com/dashboard/accelerators/tanzu-java-web-app).
