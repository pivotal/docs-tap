# Tanzu Build Service Dependencies

This topic tells you about Tanzu Build Service dependencies.

> **Important** Ubuntu Bionic will stop receiving support in April 2023. The
> Bionic stack is deprecated and will be removed in a future release.
> VMware recommends that you migrate builds to Jammy stacks.
>For Tanzu Application Platform v1.5 and later, the default stack for Tanzu
> Build Service is Jammy.

To build OCI images, Tanzu Build Service has the following dependencies: Cloud Native
[Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html),
[Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html),
and [Lifecycles](https://docs.vmware.com/en/Tanzu-Build-Service/1.12/vmware-tanzu-build-service/managing-builders.html#update-lifecycle).

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

Tanzu Application Platform v1.3 and later supports Ubuntu v22.04 (Jammy) based
builds and will default to it from Tanzu Application Platform v1.5 and later.

Ubuntu Bionic will stop receiving support in April 2023. VMware recommends that
you migrate builds to Jammy.

For more information about support for Jammy stacks, see
[About lite and full dependencies](#lite-vs-full) later in this topic.

> **Note** While upgrading apps to a newer stack, you might encounter the build platform
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

The `lite` dependencies contain the following buildpacks in Tanzu Application Platform v1.7:

| Buildpack | Version | Supported Stacks |
|-----------|---------|------------------|
| Java Buildpack for VMware Tanzu (Lite) | 9.11.0 | Bionic, Jammy |
| Java Native Image Buildpack for Tanzu (Lite) | 7.8.0 | Bionic, Jammy |
| .NET Core Buildpack for VMware Tanzu (Lite) | 2.8.1 | Bionic, Jammy |
| Node.js Buildpack for VMware Tanzu (Lite) | 2.3.1 | Bionic, Jammy |
| Python Buildpack for VMware Tanzu (Lite) | 2.5.1 | Bionic, Jammy |
| Go Buildpack for VMware Tanzu (Lite) | 2.2.1 | Bionic, Jammy |
| Web Servers Buildpack for VMware Tanzu (Lite) | 0.15.3 | Bionic, Jammy |
| Ruby Buildpack for VMware Tanzu (Lite) | 2.8.1 | Bionic, Jammy |

And the following components:

| Component | Version | Supported Stacks |
|-----------|---------|------------------|
| CNB Lifecycle | 0.16.0 | Bionic, Jammy |
| Base Stack of Ubuntu Jammy for VMware Tanzu | 0.1.58 | Jammy |

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

The `full` dependencies contain the following buildpacks in Tanzu Application Platform v1.7:

| Buildpack | Version | Supported Stacks |
|-----------|---------|------------------|
| Java Buildpack for VMware Tanzu | 9.11.0 | Bionic, Jammy |
| Java Native Image Buildpack for Tanzu | 7.9.0 | Bionic, Jammy |
| .NET Core Buildpack for VMware Tanzu | 2.8.1 | Bionic, Jammy |
| Node.js Buildpack for VMware Tanzu | 2.3.1 | Bionic, Jammy |
| Python Buildpack for VMware Tanzu | 2.5.1 | Bionic, Jammy |
| Ruby Buildpack for VMware Tanzu | 2.8.1 | Bionic, Jammy |
| Go Buildpack for VMware Tanzu | 2.2.1 | Bionic, Jammy |
| PHP Buildpack for VMware Tanzu | 2.6.1 | Bionic, Jammy |
| Web Servers Buildpack for VMware Tanzu | 0.15.3 | Bionic, Jammy |
| Procfile Buildpack for VMware Tanzu | 5.6.1 | Bionic, Jammy |

And the following components:

| Component | Version | Supported Stacks |
|-----------|---------|------------------|
| CNB Lifecycle | 0.16.0 | Bionic, Jammy |
| Tiny Stack of Ubuntu Jammy for VMware Tanzu | 0.1.61 | Jammy |
| Base Stack of Ubuntu Jammy for VMware Tanzu | 0.1.58 | Jammy |
| Full Stack of Ubuntu Jammy for VMware Tanzu | 0.1.107 | Jammy |

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

### Upgrading Buildpacks out-of-band of TAP 

Updating buildpack dependencies outside of upgrades to Tanzu Application Platform is possible, but VMware recommends upgrading TAP in order to consume new build dependencies. Should you encounter the need to upgrade buildpacks between TAP releases, follow these instructions:

1. Navigate to the the desired buildpack page. Selecting from the Tanzu Buildpacks documentation [landing page](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html) will redirect to the TanzuNet distribution page for a given language family buildpack.
2. Find the appropriate package in the artifact reference list. Select `lite` if you have installed TAP using `lite` TBS dependencies. This is the default set of dependencies installed. If you installed `full` dependencies, select the package artifact reference that is **not** identified as lite.
3. Click the icon in the right side of the artifact reference box to reveal the Tanzu Network image repository address and image tag and copy to clipboard.
4. Relocate buildpack image using imgpkg copy 
`imgpkg copy -b <PASTE TANZUNET IMAGE URL FROM PREVIOUS STEP> --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tbs-deps/<BUILDPACK LANGUAGE>`
  Where `$INSTALL_REGISTRY_HOSTNAME` and `$INSTALL_REPO` are the same ones from the [online profile installation docs](../install-online/profile.md#relocate-images)
5. Now that the package repositry that contains the new buildpack image has been relocated, the next step is add the package repository. `tanzu package repository add --url <REPO DESTINATION FROM PREVIOUS STEP> tbs-<BUILDPACK LANGUAGE> --namespace tap-install`
6. In order to install the package repositry, you must find the package name and version.
`tanzu package repository list --namespace tap-install`. Find the package repository name that follows the convention `<BUILDPACK LANGUAGE>.buildpacks.tanzu.vmware.com` or `<BUILDPACK LANGUAGE>-lite.buildpacks.tanzu.vmware.com` as well as its associated version. These are required for the following step.
7. The next step is to install the package repositry on the Cluster. `tanzu package install --package-name <PACKAGE NAME FROM PREVIOUS STEP> --verison <VERSION FROM PREVIOUS STEP> tbs-<BUILDPACK LANGUAGE NAME> --namespace tap-install`
8. The buildpack has been installed and images that use the buildpack you have upgraded will start to rebuild. When you install future versions of TAP that include higher buildpack versions, TBS will use the higher buildpack versions in builds.
   

