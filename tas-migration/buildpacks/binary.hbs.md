# Migrate from the Binary Cloud Foundry Buildpack to the Procfile Cloud Native Buildpack

This topic tells you how to migrate your binary app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

The capability provided by the Tanzu Application Service Binary buildpack is provided in Tanzu Application Platform by the Procfile buildpack.

In Tanzu Application Service, Procfile capability is built into the platform. For more information, see the
[Cloud Foundry documentation](https://docs.cloudfoundry.org/buildpacks/prod-server.html#procfile).
However, due to the nature of the Cloud Foundry API, a no-op/null buildpack was required,
and this null buildpack was named Binary buildpack.

A Procfile follows the same format in Tanzu Application Service and Tanzu Application Platform.
If your app contains an executable file or a preceding buildpack generates an executable file in the build process, you can use the Tanzu Application Platform Procfile buildpack to run your app in the same way as the
Tanzu Application Service Binary buildpack.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  source:
    git:
      ref:
        branch: master
      url: https://github.com/cloudfoundry/binary-buildpack
    subPath: fixtures/default_app
```
