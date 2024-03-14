# Migrate to the .NET Core Cloud Native Buildpack

This topic tells you how to migrate your .NET Core app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

## <a id="versions"></a> Install specific .NET runtime and ASP.NET versions

The following table compares how Tanzu Application Service and Tanzu Application Platform deals with
installing specific versions.

| Feature                                                                                 | Tanzu Application Service | Tanzu Application Platform         |
| --------------------------------------------------------------------------------------- | ------------------------- | ---------------------------------- |
| Detects version from `.csproj` </br> `<RuntimeFrameworkVersion>` or `<TargetFramework>` | ✅                        | ✅                                 |
| Detects version from `runtimeconfig.json` </br> `runtimeOptions.framework.version`      | ✅                        | ✅                                 |
| Detects versions from `.fsproj` and `.vbproj.`                                          | ❌                        | ✅                                 |
| Override app-based version detection.                                                   | Use `builpack.yml`        | Use `$BP_DOTNET_FRAMEWORK_VERSION` |

### <a id="override-version-tas"></a> Tanzu Application Service: Override version detection

Tanzu Application Service buildpacks allows you to specify a .NET Core SDK version using a `buildpack.yml`.

Example `buildpack.yml`:

```yaml
dotnet-core:
  sdk: 7.0.x
```

### <a id="override-version-tap"></a> Tanzu Application Service: Override version detection

In Tanzu Application Platform, users set the `$BP_DOTNET_FRAMEWORK_VERSION` environment variable to specify which version
of the .NET Core runtime to install. The buildpack automatically installs an SDK version that is compatible
with the runtime version .NET Core runtime you selected.

The Tanzu Application Platform buildpack requires you to provide an exact version unlike in the
Tanzu Application Service `buildpack.yml` where you can provide version patterns such as `7.x.x`.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_DOTNET_FRAMEWORK_VERSION
       value: 7.0.10
  source:
    git:
      ref:
        branch: master
      url: https://github.com/cloudfoundry/dotnet-core-buildpack
    subPath: fixtures/source_apps/source-app-7
```

## <a id="multiple-projects"></a> Configure multiple projects in an app

The following table compares how Tanzu Application Service and Tanzu Application Platform handle
multiple projects in an app.

| Feature                                                           | Tanzu Application Service | Tanzu Application Platform    |
| ----------------------------------------------------------------- | ------------------------- | ----------------------------- |
| Configure multiple projects in one app                            | Use a `.deployment` file  | Use `$BP_DOTNET_PROJECT_PATH` |
| Projects referenced by the configured main project are also built | ✅                        | ✅                            |

### <a id="multiple-projects-tas"></a> Tanzu Application Service: Configure multiple projects

In Tanzu Application Service, users create a `.deployment` file in your app’s root folder to designate
the main project’s path.

For example:

```
[config]
project = src/MyApp.Web/MyApp.Web.csproj
```

### <a id="multiple-projects-tap"></a> Tanzu Application Platform: Configure multiple projects

In Tanzu Application Platform, you configure the main project’s path with `$BP_DOTNET_PROJECT_PATH`
as the `spec` shown in this Tanzu Application Platform workload example.
In Tanzu Application Platform, you point to the root of the project not the project file.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_DOTNET_PROJECT_PATH
       value: ./src/asp_web_app
  source:
    git:
      ref:
        branch: master
      url: https://github.com/cloudfoundry/dotnet-core-buildpack
    subPath: fixtures/source_apps/multiple_projects_msbuild
```

## <a id="config-publish-command"></a> Configure the publish command

The following table compares how you configure the publish command for Tanzu Application Service and
Tanzu Application Platform.

| Feature                       | Tanzu Application Service | Tanzu Application Platform     |
| ----------------------------- | ------------------------- | ------------------------------ |
| Configure the publish command | ❌ Not supported          | Use `$BP_DOTNET_PUBLISH_FLAGS` |

### <a id="config-publish-command"></a> Configure the publish command in Tanzu Application Platform

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_DOTNET_PUBLISH_FLAGS
       value: "--verbosity=normal"
```

## <a id="nuget-config"></a> Provide a NuGet configuration

The following table compares how you provide a NuGet configuration for Tanzu Application Service and
Tanzu Application Platform.

| Feature                                         | Tanzu Application Service | Tanzu Application Platform                                           |
| ----------------------------------------------- | ------------------------- | -------------------------------------------------------------------- |
| Provide a NuGet.Config with the app             | ✅                        | ✅                                                                   |
| Provide a NuGet.Config through service bindings | ❌ Not supported          | Use a binding of type `nugetconfig` that contains the `nuget.config` |

### <a id="nuget-config-secret"></a> Provide a NuGet configuration with sensitive data

In Tanzu Application Platform, if your NuGet config contains credentials or other sensitive data,
you can provide it to the build without explicitly including the file in the application directory.

To provide your NuGet config without including it in the directory:

1. Create the service binding as a secret. For example:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: nuget-config
      namespace: my-apps
    type: service.binding/nugetconfig
    stringData:
      type: nugetconfig
      nuget.config: |
        <?xml version="1.0" encoding="utf-8"?>
        <configuration>
          <packageSources>
            <clear />
            <add key="NuGet.org" value="https://api.nuget.org/v3/index.json" />
          </packageSources>
        </configuration>
    ```

1. Use the binding in the workload. For example:

    ```yaml
    ---
    kind: Workload
    apiVersion: carto.run/v1alpha1
    metadata:
    name: dotnet-app
    spec:
    # ...
      params:
      - name: buildServiceBindings
        value:
          - name: nuget-config
            kind: Secret
            apiVersion: v1
    ```

For more information about service bindings, see
[Configure Tanzu Build Service properties on a workload](../../tanzu-build-service/tbs-workload-config.hbs.md).
