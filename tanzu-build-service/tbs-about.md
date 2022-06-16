# Tanzu Build Service

VMware Tanzu Build Service automates container creation, management, and governance at enterprise scale.
Tanzu Build Service uses the open-source [Cloud Native Buildpacks](https://buildpacks.io/)
project to turn application source code into container images.
It executes reproducible builds aligned with modern container standards and keeps images up to date.
For more information about Tanzu Build Service, see the
[Tanzu Build Service Documentation](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

## <a id="dependencies"></a> Tanzu Build Service Dependencies

Tanzu Build Service requires dependencies in the form of
[Buildpacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html) and
[Stacks](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-stacks.html)
to build OCI images.

This topic describes how Tanzu Build Service uses and installs dependencies.

## <a id="tap-install-full-deps"></a> Installing TAP with Full Dependencies

By default, TAP is installed with `lite` dependencies. See [here](#descriptors) for a comparison of lite vs full dependencies.

Full dependencies must be installed separately from TAP. Follow these steps:

1. Follow the standard TAP profile instructions and when configuring the `tap-values.yaml`, use the following `buildservice` settings:

```yaml
buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
  kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
  exclude_dependencies: true
```

2. Get the latest version of the buildservice package:

```console
tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
```

3. Relocate the TBS full dependencies package repository using the version from the previous step. This should be a similar command to the one used during TAP install:

```console
imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:${VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps
```

4. Add the TBS full dependencies package repository using the same version used in the previous step:

```console
tanzu package repository add tbs-full-deps-repository \
  --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tbs-full-deps:${VERSION} \
  --namespace tap-install
```

5. Install the Full Dependencies package (no `values.yaml` needed):

```console
tanzu package install full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v $VERSION -n tap-install
```

### <a id="descriptors"></a> Descriptors

Tanzu Build Service descriptors are curated sets of dependencies, including stacks and buildpacks, that are
continuously released on [VMware Tanzu Network](https://network.pivotal.io/products/tbs-dependencies/)
to resolve all workload Critical and High CVEs. Descriptors are only used if TAP is configured for automatic dependency updates.
Descriptors are imported into Tanzu Build Service to update the entire cluster.

There are two types of descriptor, `lite` and `full`.
The different descriptors can apply to different use cases and workload types.
You can configure which descriptor is imported after installation when installing
Tanzu Application Platform or the Tanzu Build Service component.

For more information, see [Descriptors](descriptors.html).

### <a id="auto-updates"></a> Automatic Dependency Updates

You can configure Tanzu Build Service to update dependencies in the background as they are released.
This enables workloads to keep up to date automatically.

When creating the values file during installation, include the key-value pair
`enable_automatic_dependency_updates: true`, in addition to any other `buildservice` keys, as in this
example:

```yaml
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

### <a id="manual-updates"></a> Manual Control of Dependency Updates

Sometimes you might not want Tanzu Build Service to automatically update dependencies in the
background.

In this case, you can manually manage and update your dependencies individually or automate the
updating configuration yourself in a CI/CD context.

The Tanzu Build Service package in Tanzu Application Platform behaves identically to the standalone
Tanzu Build Service product described in the
[Tanzu Build Service documentation](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

For updating dependencies manually, see [Updating Build Service Dependencies](https://docs.vmware.com/en/Tanzu-Build-Service/1.6/vmware-tanzu-build-service/GUID-updating-deps.html#bulk-update).
