---
title: Dependencies
owner: Build Service Team
---

## <a id="dependencies"></a> Tanzu Build Service Dependencies

Tanzu Build Service requires dependencies in the form of Cloud Native
[Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html) and
[Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
to build OCI images.

This topic describes how Tanzu Build Service uses and installs dependencies.

### <a id="install"></a> How Dependencies are Installed

When TAP or TBS is installed, it is bootstrapped with a set of dependencies and not extra configuration is required. 
Each version of TAP/TBS contains new dependencies. 

When TAP/TBS is upgraded, new dependencies will be installed which may result in rebuilds of workload images. TAP/TBS 
will only release patches of dependencies in patch versions of TAP/TBS to ensure dependency compatibility.

By default, TAP/TBS is installed with the `lite` set of dependencies which are smaller-footprint and contain a subset of 
the buildpacks and stacks in the `full` set of dependencies. See [here](#lite-vs-full-table) for a comparison of `lite` vs `full` dependencies.

To view the set of dependencies installed with TAP/TBS, view status of the clusterbuilders which contains stack and buildpack metadata:

```console
kubectl get clusterbuilder -o yaml
```

#### <a id="deprecated-auto-updates"></a> Automatic Dependency Updates (Deprecated)

The automatic updates feature from previous TAP/TBS versions is in the process of being deprecated. 

The recommended way to patch dependencies is by upgrading or patching TAP/TBS.

### <a id="lite-vs-full"></a> Lite vs Full Dependencies

There are two types of TAP/TBS dependencies: `lite` and `full` which serve different use cases, both suitable for production workloads.
Each version of TBS is released with a set of `lite` and `full` dependencies. 

`lite` dependencies are installed by default when installing TAP or TBS and require no user configuration. The `full`
set of dependencies must be installed separately from TAP or TBS which can be found [here](install-tbs.html#tap-install-full-deps).

### <a id="lite-dependencies"></a> Lite dependencies

The `lite` dependencies are the default set installed with TAP or TBS. 

It contains a smaller footprint to speed up installation time. However, it does not support all
workload types. For example, the `lite` descriptor does not contain the PHP buildpack and cannot be used to build PHP workloads.

The `lite` descriptor only contains the `base` stack.
The `default` stack is installed, but is identical to the `base` stack.
For more information, see [Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html).

### <a id="full-dependencies"></a> Full dependencies

The Tanzu Build Service `full` set of dependencies contains more buildpacks and stacks, which allows for more workload
types.

The dependencies are pre-packaged so builds don't have to download them from the Internet.
This can speed up build times and allows builds to occur in air-gapped environments.

The `full` descriptor contains the following stacks, which support different use cases:

- `base`
- `default` (identical to `base`)
- `full`
- `tiny`

For more information, see [Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html).
Due to the larger footprint of `full`, installations might take longer.
The `full` set of dependencies must be installed separately from TAP or TBS which can be found [here](install-tbs.html#tap-install-full-deps).

#### <a id="lite-vs-full-table"></a> Lite vs Full Dependencies Table

Below is a side-by-side comparison of the `lite` and `full` dependencies.

|  | lite | full |
|---| ---|---|
| Faster installation time | Yes | No |
| Dependencies pre-packaged (faster builds) | No | Yes |
| Supports Air-Gapped installation | No | Yes |
| Contains base stack | Yes | Yes |
| Contains full stack | No | Yes |
| Contains tiny stack | No | Yes |
| Supports Java workloads | Yes | Yes |
| Supports Node.js workloads | Yes | Yes |
| Supports Go workloads | Yes | Yes |
| Supports Python workloads | Yes | Yes |
| Supports .NET Core workloads | Yes | Yes |
| Supports PHP workloads | No | Yes |
| Supports static workloads | Yes | Yes |
| Supports binary workloads | Yes | Yes |
| Supports web servers buildpack | No | Yes |
