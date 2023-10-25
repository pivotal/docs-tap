# Overview of Tanzu Buildpacks

Tanzu Buildpacks provide framework and runtime support for applications. Buildpacks typically examine your applications to determine what dependencies to download, install, and how to configure the apps to communicate with bound services.

Tanzu Buildpacks use open-source [Paketo Buildpacks](https://paketo.io/) to allow Tanzu Application Platform users to turn their application source code into container images. From Tanzu Application Platform v1.6, builders, stacks, and buildpacks are packaged separately from Tanzu Build Service, but are included in the same Tanzu Application Platform profiles as Tanzu Build Service. All buildpacks follow the package name format `*.buildpacks.tanzu.vmware.com`.

All information about how to install buildpacks and stacks in TAP can be found in the [Tanzu Build Service Dependencies documentation](../tanzu-build-service/install-tbs.md). There, you will find details about the buildpacks and stacks included in the `lite` and `full` profiles, and see what versions are available.

For more in-depth information about Tanzu Buildpacks features and components, see [Tanzu Buildpack Documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html).
