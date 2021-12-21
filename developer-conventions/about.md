---
title: Developer Conventions for Tanzu Application Platform
subtitle: Developer Conventions
weight: 1
---

## Overview

Developer Conventions are a set of [conventions](../convention-service/about.md) that can enable your workloads to support live-update and debug operations. They are used alongside the [Tanzu CLI Apps Plugin](../cli-plugins/apps/overview-installation.md) and the [Tanzu Dev Tools for VSCode](../vscode-extension/about.md) IDE extension.

## Features

### Enabling Live Updates

Developer Conventions will modify your workload to enable live updates in one of the following situations:

1. A workload is deployed using the Tanzu CLI Apps plugin and includes the flag `--live-update=true`. More information on how to deploy a workload with the CLI [here](../cli-plugins/apps/command-reference/tanzu_apps_workload_apply.md).
1. A workload is deployed using the `Tanzu: Live Update Start` option through the Tanzu Dev Tools for VSCode extension. More information on live updating with the Tanzu Dev Tools extension [here](../vscode-extension/usage.md).

When one of the above actions take place, the convention will behave as follows:

- It will look for the `apps.tanzu.vmware.com/live-update=true` annotation on a PodTemplateSpec associated with a workload. 
- It will check that the image having conventions applied contains a live update-able process.
- It will then add annotations to the PodTemplateSpec to modify the Knative properties `minScale` & `maxScale` such that the minimum and maximum number of pods to 1. This is to ensure the eventual running pod will not be scaled down to 0 during a live update session.

Once the above changes are made, you will be able to use the Tanzu Dev Tools extension or the Tilt CLI to live update changes to source code directly onto the cluster.

### Enabling Debugging

Developer Conventions will modify your workload to enable debugging in one of the following situations:

1. A workload is deployed using the Tanzu CLI Apps plugin and includes the flag `--debug=true`. More information on how to deploy a workload with the CLI [here](../cli-plugins/apps/command-reference/tanzu_apps_workload_apply.md).
1. A workload is deployed using the `Tanzu Java Debug Start` option through the Tanzu Dev Tools for VSCode extension. More information on debugging with the Tanzu Dev Tools extension [here](../vscode-extension/usage.md).

When one of the above actions take place, the convention will behave as follows:

- It will look for the `apps.tanzu.vmware.com/debug=true` annotation on a PodTemplateSpec associated with a workload. 
- It will check for the `debug-8` or `debug-9` labels in the on the image configurations Bill of Materials (BOM).
- It will then set the TimeoutSeconds of the Liveness, Readiness, and Startup probes to 600 if currently set to a lower amount.
- It will then add annotations to the PodTemplateSpec to modify the Knative properties `minScale` & `maxScale` such that the minimum and maximum number of pods to 1. This is to ensure the eventual running pod will not be scaled down to 0 during a debug session.

Once the above changes are made, you will be able to use the Tanzu Dev Tools extension or other CLI-based debuggers to debug your workload directly on the cluster.

>**Note**: Developer Conventions only supports debug operations for Java applications today.

### Resource Limits

The following resource limits are set on the Developer Conventions service:

```
resources:
  limits:
	cpu: 100m
	memory: 256Mi
  requests:
	cpu: 100m
	memory: 20Mi
```

## Installing

Developer Conventions is released as a Tanzu Package. For information on installing Developer Conventions, see [Installing Tanzu Application Platform](../install-intro.md).

## Uninstalling

To uninstall Developer Conventions, you can follow the  guide for uninstalling Tanzu Application Platform packages [here](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.4/tap/GUID-uninstall.html). The package name for developer conventions is `developer-conventions`.
