# Dependencies

> **Important** Ubuntu Bionic will stop receiving support in April 2023.
> The Bionic stack for Tanzu Build Service is deprecated and will be removed in a future release.
> VMware recommends that you migrate builds to Jammy stacks.
> For how to migrate builds, see [Use Jammy stacks for a workload](#using-jammy).

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

To upgrade Tanzu Build Service dependencies outside of Tanzu Application Platform releases, use the
`kpack` CLI. This enables you to consume new versions of buildpacks and stacks and remediate
vulnerabilities more quickly. For more information, see [Updating Build Service Dependencies](https://docs.vmware.com/en/Tanzu-Build-Service/1.7/vmware-tanzu-build-service/GUID-updating-deps.html#bulk-update).

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

## <a id="bionic-vs-jammy"></a> Bionic and Jammy stacks

Tanzu Application Platform v1.3 supports Ubuntu v22.04 (Jammy) based builds.
Ubuntu Bionic will stop receiving support in April 2023.
VMware recommends that you migrate builds to Jammy.

For more information about support for Jammy stacks, see
[About lite and full dependencies](#lite-vs-full) later in this topic.

### <a id="using-jammy"></a> Use Jammy stacks for a workload

To use the Jammy stacks or migrate an existing workload, configure the workload with a Jammy
builder by using the `param` flag, for example, `--param clusterBuilder=base-jammy`.
For further instructions, see [Configure the cluster builder](tbs-workload-config.md#cluster-builder).

> **Note** While upgrading apps to a newer stack, you might encounter the build platform
> erroneously reusing the old build cache. If you encounter this issue, delete
> and recreate the workload in Tanzu Application Platform, or delete and
> recreate the image in Tanzu Build Service.

### <a id="defaulting-to-jammy"></a> Default all workloads to Jammy stacks

By default, Tanzu Application Platform is installed with Bionic as the default stack.

To default all workloads to the Jammy stack, include the `stack_configuration: jammy-only` field under the `buildservice:` section in `tap-values.yaml`.
This installs Tanzu Application Platform and Tanzu Build Service with no Bionic-based builders,
and all workloads will be built with Jammy.

> **Important** Only use this configuration if you are sure all workloads can be safely built with Jammy.

## <a id="lite-vs-full"></a> About lite and full dependencies

Each version of Tanzu Application Platform is released with two types of
Tanzu Build Service dependencies: `lite` and `full`.
These dependencies consist of the buildpacks and stacks required for application builds.
Each type serves different use cases.
Both types are suitable for production workloads.

By default, Tanzu Build Service is installed with `lite` dependencies, which do
not contain all buildpacks and stacks.
To use all buildpacks and stacks, you must install the `full` dependencies.
For instructions about installing `full` dependencies, see [Install full dependencies](install-tbs.html#tap-install-full-deps).

For a table comparing the differences between `full` and `lite` dependencies, see
[Dependency comparison](#lite-vs-full-table).

### <a id="lite-dependencies"></a> Lite dependencies

The `lite` dependencies are the default set installed with Tanzu Build Service.

`lite` dependencies contain a smaller footprint to speed up installation time,
but do not support all workload types.
For example, `lite` dependencies do not contain the PHP buildpack and
cannot be used to build PHP workloads.

#### <a id="lite-stacks"></a> Lite dependencies: stacks

The `lite` dependencies contain the following stacks:

- `base` (ubuntu Bionic)
- `default` (identical to `base`)
- `base-jammy` (ubuntu Jammy)

For more information, see [Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
in the VMware Tanzu Buildpacks documentation.

#### <a id="lite-buildpacks"></a> Lite dependencies: buildpacks

The `lite` dependencies contain the following buildpacks in Tanzu Application Platform v1.3:

| Buildpack | Version | Supported Stacks |
|-----------|---------|------------------|
| Java Buildpack for VMware Tanzu (Lite) | 7.5.0 | Bionic, Jammy |
| Java Native Image Buildpack for Tanzu (Lite) | 6.31.0 | Bionic, Jammy |
| .NET Core Buildpack for VMware Tanzu (Lite) | 1.18.1 | Bionic, Jammy |
| Node.js Buildpack for VMware Tanzu (Lite) | 1.16.0 | Bionic, Jammy |
| Python Buildpack for VMware Tanzu (Lite) | 2.1.2 | Bionic, Jammy |
| Go Buildpack for VMware Tanzu (Lite) | 2.0.2 | Bionic, Jammy |
| Web Servers Buildpack for VMware Tanzu (Lite) | 0.3.0 | Bionic |
| Ruby Buildpack for VMware Tanzu (Lite) | 1.1.0 | Bionic |
| Procfile Buildpack for VMware Tanzu (Lite) | 5.4.0 | Bionic, Jammy |

And the following components:

| Component | Version | Supported Stacks |
|-----------|---------|------------------|
| CNB Lifecycle | 0.14.2 | Bionic, Jammy |
| Base Stack of Ubuntu Bionic for VMware Tanzu | 1.2.17 | Bionic |
| Base Stack of Ubuntu Jammy for VMware Tanzu | 0.1.1 | Jammy |

### <a id="full-dependencies"></a> Full dependencies

The Tanzu Build Service `full` set of dependencies contain more buildpacks and stacks,
which allows for more workload types.

The dependencies are pre-packaged, so builds do not have to download them from the Internet.
This can speed up build times and allows builds to occur in air-gapped environments.
Due to the larger footprint of `full`, installations might take longer.

The `full` dependencies are not installed with Tanzu Build Service by default,
you must install them.
For instructions for installing `full` dependencies, see [Install Tanzu Build Service with full dependencies](install-tbs.html#tap-install-full-deps).

#### <a id="full-stacks"></a> Full dependencies: stacks

The `full` dependencies contain the following stacks, which support different use cases:

- `base` (ubuntu Bionic)
- `default` (identical to `base`)
- `full` (ubuntu Bionic)
- `tiny` (ubuntu Bionic)
- `base-jammy` (ubuntu Jammy)
- `full-jammy` (ubuntu Jammy)
- `tiny-jammy` (ubuntu Jammy)

For more information, see [Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
in the VMware Tanzu Buildpacks documentation.

#### <a id="full-buildpacks"></a> Full dependencies: buildpacks

The `full` dependencies contain the following buildpacks in Tanzu Application Platform v1.3:

| Buildpack | Version | Supported Stacks |
|-----------|---------|------------------|
| Java Buildpack for VMware Tanzu | 7.5.0 | Bionic, Jammy |
| Java Native Image Buildpack for Tanzu | 6.31.0 | Bionic, Jammy |
| .NET Core Buildpack for VMware Tanzu | 1.18.1 | Bionic, Jammy |
| Node.js Buildpack for VMware Tanzu | 1.16.0 | Bionic, Jammy |
| Python Buildpack for VMware Tanzu | 2.1.2 | Bionic, Jammy |
| Ruby Buildpack for VMware Tanzu | 1.1.0 | Bionic |
| Go Buildpack for VMware Tanzu | 2.0.2 | Bionic, Jammy |
| PHP Buildpack for VMware Tanzu | 1.2.0 | Bionic |
| Web Servers Buildpack for VMware Tanzu | 0.3.0 | Bionic |
| Procfile Buildpack for VMware Tanzu | 5.3.0 | Bionic, Jammy |

And the following components:

| Component | Version | Supported Stacks |
|-----------|---------|------------------|
| CNB Lifecycle | 0.14.2 | Bionic, Jammy |
| Tiny Stack of Ubuntu Bionic for VMware Tanzu | 1.3.72 | Bionic |
| Base Stack of Ubuntu Bionic for VMware Tanzu | 1.2.17 | Bionic |
| Full Stack of Ubuntu Bionic for VMware Tanzu | 1.3.88 | Bionic |
| Tiny Stack of Ubuntu Jammy for VMware Tanzu | 0.1.1 | Jammy |
| Base Stack of Ubuntu Jammy for VMware Tanzu | 0.1.1 | Jammy |
| Full Stack of Ubuntu Jammy for VMware Tanzu | 0.1.1 | Jammy |

### <a id="lite-vs-full-table"></a> Dependency comparison

The following table compares the contents of the `lite` and `full` dependencies.

|   | lite | full |
|---|---|---|
| Faster installation time | Yes | No |
| Dependencies pre-packaged (faster builds) | No | Yes |
| Supports air-gapped installation | No | Yes |
| Contains base stack | Yes | Yes |
| Contains full stack | No | Yes |
| Contains tiny stack | No | Yes |
| Contains Jammy stack | Yes | Yes |
| Supports Java workloads | Yes | Yes |
| Supports Node.js workloads | Yes | Yes |
| Supports Go workloads | Yes | Yes |
| Supports Python workloads | Yes | Yes |
| Supports Ruby workloads | No | Yes |
| Supports .NET Core workloads | Yes | Yes |
| Supports PHP workloads | No | Yes |
| Supports static workloads | Yes | Yes |
| Supports binary workloads | Yes | Yes |
| Supports web servers buildpack | Yes | Yes |

## <a id="deprecated-auto-updates"></a> About automatic dependency updates (deprecated)

>**Important** The automatic updates feature is being deprecated.
>The recommended way to patch dependencies is by upgrading Tanzu Application Platform
>to the latest patch version. For upgrade instructions, see [Upgrading Tanzu Application Platform](../upgrading.md).

You can configure Tanzu Build Service to update dependencies in the background as they are released.
This enables workloads to keep up to date automatically.

### <a id="descriptors"></a> Descriptors (deprecated)

Tanzu Build Service descriptors are curated sets of dependencies that include stacks and buildpacks.
Descriptors are only used if Tanzu Build Service is configured for automatic dependency updates.
Descriptors are imported into Tanzu Build Service to update the entire cluster.

Descriptors are continuously released on the [VMware Tanzu Network Build Service Dependencies](https://network.pivotal.io/products/tbs-dependencies/)
page to provide updated buildpack dependencies and updated stack images.
This allows the use of dependencies that have patched CVEs.
For more information about buildpacks and stacks, see the [VMware Tanzu Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html).

There are two types of descriptor, `lite` and `full`.
The different descriptors can apply to different use cases and workload types.
The differences between the `full` and `lite` descriptors are the same as the the differences
between `full` and `lite` dependencies.
For a comparison of the `lite` and `full` descriptors, see [About lite and full dependencies](#lite-vs-full).
