---
title: Automatic Dependency Updates
owner: Build Service Team
---

## <a id="auto-updates"></a> Automatic Dependency Updates (Deprecated)

The automatic updates feature is in the process of being deprecated. The recommended way to patch dependencies is by upgrading or patching TAP.

### <a id="auto-updates-config"></a> Automatic Dependency Updates Config

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

### <a id="descriptors"></a> About descriptors

Tanzu Build Service descriptors are curated sets of dependencies, including stacks and buildpacks, that are
continuously released on VMware Tanzu Network to resolve all workload Critical and High CVEs. 

Descriptors are only used if TAP is configured for automatic dependency updates. Descriptors are imported into Tanzu Build Service to update the entire cluster.

There are two types of descriptor, `lite` and `full`, available on the
[Tanzu Network Build Service Dependencies](https://network.pivotal.io/products/tbs-dependencies/) page.
The different descriptors can apply to different use cases and workload types.
For the differences between the descriptors, see [Lite vs Full Dependencies](dependencies.html#lite-vs-full).
