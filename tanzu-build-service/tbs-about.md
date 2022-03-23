# Tanzu Build Service

VMware Tanzu Build Service automates container creation, management, and governance at enterprise scale. Tanzu Build Service uses the open-source [Cloud Native Buildpacks](https://buildpacks.io/) project to turn application source code into container images. It executes reproducible builds aligned with modern container standards and keeps images up to date. For more information about Tanzu Build Service, see the [Tanzu Build Service Documentation](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

## <a id="dependencies"> Tanzu Build Service Dependencies

Tanzu Build Service requires dependencies (buildpacks and stacks) to build OCI images.

### <a id="dependencies-configuration"> Configuration

On non-airgapped clusters, dependencies are imported as a part of installation of a TAP profile or the TBS component.

When creating the values file during installation, include the following bolded keys (in addition to any other `buildservice` keys):

<pre>
...
kp_default_repository: REPOSITORY
kp_default_repository_username: REGISTRY-USERNAME
kp_default_repository_password: REGISTRY-PASSWORD
<b>tanzunet_username: TANZUNET-USERNAME
tanzunet_password: TANZUNET-PASSWORD
descriptor_name: DESCRIPTOR-NAME</b>
...
</pre>

Where:
- `TANZUNET-USERNAME` and `TANZUNET-PASSWORD` are the email address and password that you use to log in to VMware Tanzu Network.
- `DESCRIPTOR-NAME` is the name of the descriptor to import automatically. See more details [here](#dependencies-descriptors). Available options are:
    * `lite` (default if unset) has a smaller footprint that enables faster installations.
    * `full` optimized to speed up builds and includes dependencies for all supported workload types.

### <a id="dependencies-descriptors"> Descriptors

Tanzu Build Service descriptors are curated sets of dependencies (stacks and buildpacks) that are continuously released on [VMware Tanzu Network](https://network.pivotal.io/) to resolve all workload CRITICAL and HIGH CVEs.
Descriptors can be imported into TBS to update the entire cluster wholesale.

Different descriptors can apply to different use cases and you can configure which descriptor will be imported upon installation when installing TAP or the TBS component.

#### <a id="dependencies-descriptors-lite"> Lite Descriptor

The Tanzu Build Service `lite` descriptor is the default descriptor selected if none are configured.

It contains a smaller footprint to speed up installation time. However, it does not support all workload types – for example the `lite` descriptor does not contain the php buildpack.

The `lite` descriptor only contains the `base` [stack](https://docs.pivotal.io/tanzu-buildpacks/stacks.html). The `default` stack will be installed but is identical to the `base` stack.

A full table of differences between `full` and `lite` shown [here](#descriptors-table).

#### <a id="dependencies-descriptors-full"> Full Descriptor

The Tanzu Build Service `full` descriptor contains more dependencies which allows for more workload types.

It also includes all dependencies pre-packaged so builds don't need to download them from the internet which can speed up build times.

The `full` descriptor contains the following [stacks](https://docs.pivotal.io/tanzu-buildpacks/stacks.html) which support different use cases:
- `base`
- `default` (identical to `base`)
- `full`
- `tiny`

However, due to its larger-footprint, installations may take longer.

A full table of differences between `full` and `lite` shown [here](#descriptors-table).

#### <a id="dependencies-descriptors-compared"> Descriptors Compared

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

### <a id="dependencies-auto-updates"> Automatic Dependency Updates

Tanzu Build Service can be configured to update dependencies in the background as they are released so workloads can automatically be kept up-to-date.

When creating the values file during installation, include the following bolded key (in addition to any other `buildservice` keys):

<pre>
...
kp_default_repository: REPOSITORY
kp_default_repository_username: REGISTRY-USERNAME
kp_default_repository_password: REGISTRY-PASSWORD
tanzunet_username: TANZUNET-USERNAME
tanzunet_password: TANZUNET-PASSWORD
descriptor_name: DESCRIPTOR-NAME
<b>enable_automatic_dependency_updates: true</b>
...
</pre>
