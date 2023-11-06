# Tanzu Build Service Dependencies

This topic tells you about Tanzu Build Service dependencies.

> **Important** Ubuntu Bionic stack is deprecated and will be removed in a future release.
> VMware recommends that you migrate builds to Jammy stacks.
>For Tanzu Application Platform v1.5 and later, the default stack for Tanzu
> Build Service is Jammy.

To build OCI images, Tanzu Build Service has the following dependencies: Cloud Native
[Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html),
[Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html),
and [Lifecycles](https://docs.vmware.com/en/Tanzu-Build-Service/1.11/vmware-tanzu-build-service/managing-builders.html#update-lifecycle).

## <a id="install"></a> How dependencies are installed

When Tanzu Application Platform is installed with Tanzu Build Service, it is
bootstrapped with a set of dependencies.
No extra configuration is required.
Each version of Tanzu Application Platform and Tanzu Build Service contains new dependencies.

When Tanzu Application Platform is upgraded, new dependencies are installed which might cause
workload images to rebuild.
To ensure dependency compatibility, Tanzu Build Service only releases patches for
dependencies in patch versions of Tanzu Application Platform.
For upgrade instructions, see [Upgrade the full dependencies package](../upgrading.md#full-profile-upgrade-tbs-deps).

By default, Tanzu Build Service is installed with the `lite` set of dependencies,
which have a smaller-footprint and contain a subset of the buildpacks and stacks in
the `full` set of dependencies.
For a comparison of `lite` and `full` dependencies, see [Dependency comparison](#lite-vs-full-table).

### <a id="view"></a> View installed dependencies

To view the set of dependencies installed with Tanzu Build Service, inspect the
status of the cluster builders by running:

```console
kubectl get clusterbuilder -o yaml
```

Cluster builders contain stack and buildpack metadata.


## <a id="bionic-vs-jammy"></a> Bionic and Jammy stacks

Tanzu Application Platform v1.3 and later supports Ubuntu v22.04 (Jammy) based
builds and will default to it from Tanzu Application Platform v1.5 and later.

Ubuntu Bionic will stop receiving support in April 2023. VMware recommends that
you migrate builds to Jammy.

For more information about support for Jammy stacks, see
[About lite and full dependencies](#lite-vs-full) later in this topic.

> **Note** While upgrading apps to a later stack, you might encounter the build platform
> erroneously reusing the old build cache. If you encounter this issue, delete
> and recreate the workload in Tanzu Application Platform, or delete and
> recreate the image in Tanzu Build Service.

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

- `base-jammy` (Ubuntu Jammy)
- `default` (identical to `base-jammy`)

For more information, see [Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
in the VMware Tanzu Buildpacks documentation.

#### <a id="lite-buildpacks"></a> Lite dependencies: buildpacks

The `lite` dependencies contain the following buildpacks in Tanzu Application Platform v1.6:

| Buildpack | Version | Supported Stacks |
|-----------|---------|------------------|
| Java Buildpack for VMware Tanzu (Lite) | 9.0.4 | Bionic, Jammy |
| Java Native Image Buildpack for Tanzu (Lite) | 7.0.4 | Bionic, Jammy |
| .NET Core Buildpack for VMware Tanzu (Lite) | 2.6.2 | Bionic, Jammy |
| Node.js Buildpack for VMware Tanzu (Lite) | 2.2.3 | Bionic, Jammy |
| Python Buildpack for VMware Tanzu (Lite) | 2.3.8 | Bionic, Jammy |
| Go Buildpack for VMware Tanzu (Lite) | 2.1.4 | Bionic, Jammy |
| Web Servers Buildpack for VMware Tanzu (Lite) | 0.13.1 | Bionic, Jammy |
| Ruby Buildpack for VMware Tanzu (Lite) | 2.5.2 | Bionic, Jammy |

And the following components:

| Component | Version | Supported Stacks |
|-----------|---------|------------------|
| CNB Lifecycle | 0.16.0 | Bionic, Jammy |
| Base Stack of Ubuntu Jammy for VMware Tanzu | 0.1.41 | Jammy |

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

- `base-jammy` (Ubuntu Jammy)
- `full-jammy` (Ubuntu Jammy)
- `tiny-jammy` (Ubuntu Jammy)
- `default` (identical to `base-jammy`)

For more information, see [Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
in the VMware Tanzu Buildpacks documentation.

#### <a id="full-buildpacks"></a> Full dependencies: buildpacks

The `full` dependencies contain the following buildpacks in Tanzu Application Platform v1.6:

| Buildpack | Version | Supported Stacks |
|-----------|---------|------------------|
| Java Buildpack for VMware Tanzu | 9.0.4 | Bionic, Jammy |
| Java Native Image Buildpack for Tanzu | 7.0.4 | Bionic, Jammy |
| .NET Core Buildpack for VMware Tanzu | 2.6.2 | Bionic, Jammy |
| Node.js Buildpack for VMware Tanzu | 2.2.3 | Bionic, Jammy |
| Python Buildpack for VMware Tanzu | 2.3.8 | Bionic, Jammy |
| Ruby Buildpack for VMware Tanzu | 2.5.2 | Bionic, Jammy |
| Go Buildpack for VMware Tanzu | 2.1.4 | Bionic, Jammy |
| PHP Buildpack for VMware Tanzu | 2.3.3 | Bionic, Jammy |
| Web Servers Buildpack for VMware Tanzu | 0.13.1 | Bionic, Jammy |
| Procfile Buildpack for VMware Tanzu | 5.6.1 | Bionic, Jammy |

And the following components:

| Component | Version | Supported Stacks |
|-----------|---------|------------------|
| CNB Lifecycle | 0.16.0 | Bionic, Jammy |
| Tiny Stack of Ubuntu Jammy for VMware Tanzu | 0.1.43 | Jammy |
| Base Stack of Ubuntu Jammy for VMware Tanzu | 0.1.41 | Jammy |
| Full Stack of Ubuntu Jammy for VMware Tanzu | 0.1.70 | Jammy |

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
| Supports Ruby workloads | Yes | Yes |
| Supports .NET Core workloads | Yes | Yes |
| Supports PHP workloads | No | Yes |
| Supports static workloads | Yes | Yes |
| Supports binary workloads | Yes | Yes |
| Supports web servers buildpack | Yes | Yes |

## <a id="update"></a> Updating dependencies

New versions of dependencies such as buildpacks, and stacks are available in new versions of Tanzu Application Platform. To update dependencies, VMware recommends that you update to the latest patch
version of Tanzu Application Platform.

- If you are using `lite` or `full` dependencies, upgrade to the latest patch version of Tanzu Application Platform to update your dependencies.
- If you are using `full` dependencies, you must complete some extra steps after you upgrade to the latest patch. For more information, see [Upgrading the full dependencies package](../upgrading.md#full-profile-upgrade-tbs-deps).

> **Note** When Tanzu Application Platform is upgraded, new dependencies are installed which might cause workload images to rebuild.

### Upgrading Buildpacks between Tanzu Application Platform releases

While updating buildpack dependencies outside of upgrades to Tanzu Application Platform is possible,
VMware recommends upgrading Tanzu Application Platform to consume new build dependencies.

Before you begin:  Sign into [VMware Tanzu Network](https://network.tanzu.vmware.com/) so that
the image can be retrieved from the registry.

1. Use the links
provided in the [Language Family Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html) page in the Tanzu Buildpacks documentation to locate the buildpack
image URL on VMware Tanzu Network. Select `tanzu-buildpacks/<LANGUAGE-FAMILY>` for `full`
dependencies, or `tanzu-buildpacks/<LANGUAGE-FAMILY>-lite`  for `lite` dependencies. Scroll to the
Docker command at the bottom, and copy the buildpack image URL for use in the next step.

1. Relocate the buildpack image using imgpkg copy:

    ```console
    imgpkg copy -b <BUILDPACK-IMAGE-URL> --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tbs-deps/<BUILDPACK LANGUAGE>
    ```

    Where `BUILDPACK-IMAGE-URL` is the buildpack image URL copied from the Docker command in the previous step

1. Create a `ClusterBuildpack` resource referencing the copied buildpack image:

    ```console
    apiVersion: kpack.io/v1alpha2
    kind: ClusterBuildpack
    metadata:
      name: out-of-band-<LANGUAGE-NAME>-<BUILDPACK-VERSION>
    spec:
      image: <RELOCATED-BUILDPACKIMAGE>
      serviceAccountRef:
        name: dependencies-pull-serviceaccount
        namespace: build-service
    ```

    Where `RELOCATED-BUILDPACKIMAGE` is the URL of relocated buildpack image from previous step.

    To avoid naming collisions, follow the name conventions specified in `metadata.name`. The name
    can follow any convention that allows the Cluster Operator to distinguish this `ClusterBuildpack`
    from others installed by Tanzu Application Platform.

1. Apply the YAML from the previous step to the Tanzu Application Platform cluster:

    ```console
    kubectl apply -f <FILE-FROM-PREVIOUS-STEP>
    ```

The ClusterBuildpack is now deployed. Tanzu Build Service uses the latest
available version to execute builds. All images that were built with older versions of the buildpack
are rebuilt.

When you upgrade Tanzu Application Platform, new buildpacks with later versions are installed.
After an upgrade, the `ClusterBuildpack` created in this procedure is not needed and can be removed.
