# Overview of Tanzu Buildpacks

This topic describes how to use Tanzu Buildpacks in Tanzu Application Platform (commonly known as TAP).

Tanzu Buildpacks provide framework and runtime support for applications. Buildpacks
examine your applications to determine what dependencies to download, install, and how to configure
the applications to communicate with bound services.

Tanzu Buildpacks use open-source [Paketo Buildpacks](https://paketo.io/) to allow Tanzu Application Platform users to turn their application source code into container images.

In Tanzu Application Platform v1.6 and later, builders, stacks, and buildpacks are packaged
separately from Tanzu Build Service. They are included in the Full, Iterate, and Build installation profiles. All buildpacks follow the package name format `*.buildpacks.tanzu.vmware.com`.

For information about how to install buildpacks and stacks and the versions available in the `lite` and `full` profiles, see [About lite and full dependencies](../tanzu-build-service/dependencies.hbs.md#about-lite-and-full-dependencies).

For information about how to configure Tanzu Buildpacks features and components, see [Tanzu Buildpack Documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html).
