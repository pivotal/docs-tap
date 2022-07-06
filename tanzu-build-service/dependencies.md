# Dependencies

This topic describes how Tanzu Build Service uses and installs dependencies.

Tanzu Build Service requires dependencies in the form of Cloud Native
[Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html) and
[Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
to build OCI images.

## <a id="install"></a> How dependencies are installed

When Tanzu Application Platform is installed with Tanzu Build Service, it is
bootstrapped with a set of dependencies.
No extra configuration is required.
Each version of Tanzu Application Platform and Tanzu Build Service contains new dependencies.

When Tanzu Application Platform is upgraded, new dependencies are installed which might cause
workload images to rebuild.
To ensure dependency compatibility, Tanzu Build Service only releases patches for
dependencies in patch versions of Tanzu Application Platform.
For upgrade instructions, see [Upgrading Tanzu Application Platform](../upgrading.md).

By default, Tanzu Build Service is installed with the `lite` set of dependencies,
which are smaller-footprint and contain a subset of the buildpacks and stacks in
the `full` set of dependencies.
For a comparison of `lite` and `full` dependencies, see [Dependency comparison](#lite-vs-full-table)
later in this topic.

### <a id="view"></a> View installed dependencies

To view the set of dependencies installed with Tanzu Build Service, inspect the
status of the cluster builders by running:

```console
kubectl get clusterbuilder -o yaml
```

Cluster builders contain stack and buildpack metadata.

### <a id="deprecated-auto-updates"></a> Automatic dependency updates (deprecated)

The automatic updates feature is being deprecated.
The recommended way to patch dependencies is by upgrading Tanzu Application Platform
to the latest patch version. For upgrade instructions, see [Upgrading Tanzu Application Platform](../upgrading.md).

You can configure Tanzu Build Service to update dependencies in the background as they are released.
This enables workloads to keep up to date automatically.

#### <a id="descriptors"></a> Descriptors (deprecated)

Tanzu Build Service descriptors are curated sets of dependencies that include stacks and buildpacks.
Descriptors are continuously released on the [VMware Tanzu Network Build Service Dependencies](https://network.pivotal.io/products/tbs-dependencies/)
page to provide updated buildpack dependencies and updated stack images.
This allows the use of dependencies that have patched CVEs.
For more information about buildpacks and stacks, see the [VMware Tanzu Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html).

Descriptors are only used if Tanzu Build Service is configured for automatic dependency updates.
Descriptors are imported into Tanzu Build Service to update the entire cluster.

There are two types of descriptor, `lite` and `full`. <!-- are these based on the full and lite dependencies? they are separate but the do the same thing -- one for auto install and the other for not auto install -->
The different descriptors can apply to different use cases and workload types.
For the differences between the `lite` and `full` descriptors, see [Lite and full dependencies](#lite-vs-full).

## <a id="lite-vs-full"></a> Lite and full dependencies

There are two types of Tanzu Build Service dependencies: `lite` and `full`.
Each type serves different use cases.
Both types are suitable for production workloads.
Each version of Tanzu Build Service is released with a set of `lite` and `full` dependencies.

`lite` dependencies are installed by default when installing Tanzu Build Service
and require no user configuration.
The `full` set of dependencies must be installed separately.
For instructions for installing full dependencies, see [Install Tanzu Build Service with full dependencies](install-tbs.html#tap-install-full-deps).

### <a id="lite-dependencies"></a> Lite dependencies

The `lite` dependencies are the default set installed with Tanzu Build Service.

It contains a smaller footprint to speed up installation time.
However, it does not support all workload types.
For example, the `lite` descriptor does not
contain the PHP buildpack and cannot be used to build PHP workloads.

The `lite` descriptor only contains the `base` stack.
The `default` stack is installed, but is identical to the `base` stack.
For more information, see [Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
in the VMware Tanzu Buildpacks documentation.

### <a id="full-dependencies"></a> Full dependencies

The Tanzu Build Service `full` set of dependencies contains more buildpacks and stacks,
which allows for more workload types.

The dependencies are pre-packaged so builds don't have to download them from the Internet.
This can speed up build times and allows builds to occur in air-gapped environments.

The `full` descriptor contains the following stacks, which support different use cases:

- `base`
- `default` (identical to `base`)
- `full`
- `tiny`

For more information, see [Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html).
Due to the larger footprint of `full`, installations might take longer.

The `full` set of dependencies must be installed separately.
For instructions for installing full dependencies, see [Install Tanzu Build Service with full dependencies](install-tbs.html#tap-install-full-deps)

### <a id="lite-vs-full-table"></a> Dependency comparison

The following table compares the contents of the `lite` and `full` dependencies.

|  | lite | full |
|---|---|---|
| Faster installation time | Yes | No |
| Dependencies pre-packaged (faster builds) | No | Yes |
| Supports air-gapped installation | No | Yes |
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
