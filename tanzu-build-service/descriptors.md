---
title: Descriptors
owner: Build Service Team
---

This topic describes the descriptors that are available so you can choose
which option to configure depending on your use case.

## <a id="descriptors"> About descriptors

Tanzu Build Service descriptors are curated sets of dependencies, including stacks and buildpacks, that are
continuously released on VMware Tanzu Network to resolve all workload Critical and High CVEs.
Descriptors are imported into Tanzu Build Service to update the entire cluster.

There are two types of descriptor, `lite` and `full`, available on the
[Tanzu Network Build Service Dependencies](https://network.pivotal.io/products/tbs-dependencies/) page.
The different descriptors can apply to different use cases and workload types.
For the differences between the descriptors, see [Descriptor comparison](#descriptor-comparison).

You configure which descriptor is imported when installing Tanzu Build Service.

### <a id="lite-descriptor"> Lite descriptor

The Tanzu Build Service `lite` descriptor is the default descriptor selected if none is configured.

It contains a smaller footprint to speed up installation time. However, it does not support all
workload types. For example, the `lite` descriptor does not contain the PHP buildpack.

The `lite` descriptor only contains the `base` stack.
The `default` stack is installed, but is identical to the `base` stack.
For more information, see [Stacks](https://docs.pivotal.io/tanzu-buildpacks/stacks.html).

### <a id="full-descriptor"> Full descriptor

The Tanzu Build Service `full` descriptor contains more dependencies, which allows for more workload
types.

The dependencies are pre-packaged so builds don't have to download them from the Internet.
This can speed up build times.

The `full` descriptor contains the following stacks, which support different use cases:

- `base`
- `default` (identical to `base`)
- `full`
- `tiny`

For more information, see [Stacks](https://docs.pivotal.io/tanzu-buildpacks/stacks.html).
Due to the larger footprint of `full`, installations might take longer.

### <a id="descriptor-comparison"> Descriptor comparison

Both `lite` and `full` descriptors are suitable for production environments.

|  | lite | full |
|---| ---|---|
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
