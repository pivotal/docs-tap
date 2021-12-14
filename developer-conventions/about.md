---
title: Developer Conventions for Tanzu Application Platform
subtitle: Developer Conventions
weight: 1
---

## Overview

Developer Conventions for VMware Tanzu Application Platform is a convention that can enable your workloads to be live-updatable and debuggable. To learn more about the Convention Service, check out there docs [here](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.4/tap/GUID-convention-service-about.html).

## Features
### Enabling live updates
The convention looks for the `apps.tanzu.vmware.com/live-update=true` annotation on a PodTemplateSpec associated with a workload. It will also check that the image having conventions applied contains a live update-able process.

The convention will then add annotations to the PodTemplateSpec to set the minimum and maximum Knative scaling to 1. This is to ensure the eventual running pod will not be downscaled to 0 during a live update session.

### Enabling Debugging
The convention looks for the `apps.tanzu.vmware.com/debug=true` annotation on a PodTemplateSpec associated with a workload. It will also check for the `debug-8` or `debug-9` labels in the on the image configurations Bill of Materials (BOM).

The convention will then set the Liveness, Readiness, and Startup probe's TimeoutSeconds to 600 if they are currently less than that.

Similarly to when live update is being enabled, it will also set the minimum and maximum Knative scaling to 1.

### Resource Limits
The following resource limits are set on the Developer Conventions service.
```yaml
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
To uninstall Developer Conventions, you can follow the following guide for uninstalling Tanzu Application Platform components [here](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.4/tap/GUID-uninstall.html). The package name for developer conventions is `developer-conventions`.