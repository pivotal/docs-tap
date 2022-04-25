# Tanzu Build Service

VMware Tanzu Build Service automates container creation, management, and governance at enterprise scale. Tanzu Build Service uses the open-source [Cloud Native Buildpacks](https://buildpacks.io/) project to turn application source code into container images. It executes reproducible builds aligned with modern container standards and keeps images up to date. For more information about Tanzu Build Service, see the [Tanzu Build Service Documentation](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

## <a id="dependencies"> Tanzu Build Service Dependencies

Tanzu Build Service requires dependencies in the form of
[Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html) and
[Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
to build OCI images.

### <a id="configuration"> Configuration

On non-air-gapped clusters, dependencies are imported as a part of installation of a
Tanzu Application Platform profile or the Tanzu Build Service component.

When creating the values file during installation, include the `tanzunet_username`, `tanzunet_password`,
and `descriptor_name` key-value pairs, in addition to any other `buildservice` key-value pairs, as
in this example:

<code>
...
kp_default_repository: REPOSITORY
kp_default_repository_username: REGISTRY-USERNAME
kp_default_repository_password: REGISTRY-PASSWORD
tanzunet_username: TANZUNET-USERNAME
tanzunet_password: TANZUNET-PASSWORD
descriptor_name: DESCRIPTOR-NAME
...
</code>

Where:

- `TANZUNET-USERNAME` and `TANZUNET-PASSWORD` are the email address and password that you use to log in to VMware Tanzu Network.
- `DESCRIPTOR-NAME` is the name of the descriptor to import automatically. For more information, see [Descriptors](#descriptors). Available options are:
    * `lite` is the default if not set. It has a smaller footprint, which enables faster installations.
    * `full` is optimized to speed up builds and includes dependencies for all supported workload types.

### <a id="descriptors"> Descriptors

Tanzu Build Service descriptors are curated sets of dependencies (stacks and buildpacks) that are
continuously released on [VMware Tanzu Network](https://network.pivotal.io/) to resolve all workload
CRITICAL and HIGH CVEs.
Descriptors can be imported into Tanzu Build Service to update the entire cluster wholesale.

Different descriptors can apply to different use cases and you can configure which descriptor is
imported after installation when installing Tanzu Application Platform or the Tanzu Build Service
component.

#### <a id="lite-descriptor"> Lite Descriptor

The Tanzu Build Service `lite` descriptor is the default descriptor selected if none is configured.

It contains a smaller footprint to speed up installation time. However, it does not support all
workload types. For example, the `lite` descriptor does not contain the PHP buildpack.

The `lite` descriptor only contains the `base` stack.
The `default` stack is installed but is identical to the `base` stack.
For more information, see [Stacks](https://docs.pivotal.io/tanzu-buildpacks/stacks.html).
For differences between the descriptors, see [Descriptor Comparison](#descriptor-comparison).

#### <a id="full-descriptor"> Full Descriptor

The Tanzu Build Service `full` descriptor contains more dependencies, which allows for more workload
types.

The dependencies are pre-packaged so builds don't need to download them from the internet.
This can speed up build times.

The `full` descriptor contains the following stacks, which support different use cases:

- `base`
- `default` (identical to `base`)
- `full`
- `tiny`

For more information, see [Stacks](https://docs.pivotal.io/tanzu-buildpacks/stacks.html).
Due to the larger footprint of `full`, installations might take longer.

#### <a id="descriptor-comparison"> Descriptor Comparison

Both `lite` and `full` descriptors are suitable for production environments.

|  | lite | full |
|---|---|---|
| Faster installation time | Yes | No |
| Dependencies pre-packaged | No | Yes |
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

### <a id="auto-updates"> Automatic Dependency Updates

You can configure Tanzu Build Service to update dependencies in the background as they are released.
This enables workloads to keep up to date automatically.

When creating the values file during installation, include the key-value pair
`enable_automatic_dependency_updates: true`, in addition to any other `buildservice` keys, as in this
example:

```
...
kp_default_repository: REPOSITORY
kp_default_repository_username: REGISTRY-USERNAME
kp_default_repository_password: REGISTRY-PASSWORD
tanzunet_username: TANZUNET-USERNAME
tanzunet_password: TANZUNET-PASSWORD
descriptor_name: DESCRIPTOR-NAME
enable_automatic_dependency_updates: true
...
```

### <a id="manual-updates"> Manual Control of Dependency Updates

Sometimes you might not want Tanzu Build Service to automatically update dependencies in the
background.

In this case, you can manually manage and update your dependencies individually or automate the
updating configuration yourself in a CI/CD context.

The Tanzu Build Service package in Tanzu Application Platform behaves identically to the standalone
Tanzu Build Service product described in the
[Tanzu Build Service documentation](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

For updating dependencies manually, see [Updating Build Service Dependencies](https://docs.vmware.com/en/Tanzu-Build-Service/1.6/vmware-tanzu-build-service/GUID-updating-deps.html#bulk-update).
