# Migrate .NET core buildpack

<!-- do users do all these sections in order or do they choose the section for their use case -->

## Install specific .NET runtime and ASP.NET versions

| Feature                                                                           | TAS                | TAP                                |
| --------------------------------------------------------------------------------- | ------------------ | ---------------------------------- |
| Detects version from .csproj </br> <RuntimeFrameworkVersion> or <TargetFramework> | ✅                 | ✅                                 |
| Detects version from runtimeconfig.json </br> runtimeOptions.framework.version    | ✅                 | ✅                                 |
| Detects versions from .fsproj and .vbproj.                                        | ❌                 | ✅                                 |
| Override app-based version detection (see Migration from buildpack.yml to environment variable below)                                | Using builpack.yml | Using $BP_DOTNET_FRAMEWORK_VERSION |

### Migration from buildpack.yml to environment variable

TAS buildpacks allows user to specify a .NET Core SDK version using a `buildpack.yml`, for example:

```yaml
dotnet-core:
  sdk: 7.0.x
```

In TAP, users set the `$BP_DOTNET_FRAMEWORK_VERSION` environment variable to specify which version
of the .NET Core runtime should be installed. The buildpack will automatically install an SDK version
that is compatible with the selected .NET Core runtime version.
While TAS’s `buildpack.yml` supports providing version patterns like 7.x.x, the TAP buildpack requires
you to provide an exact version.

Here’s the spec section from a sample workload.yaml:

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

## Multiple projects in an app

| Feature                                                           | TAS                      | TAP                             |
| ----------------------------------------------------------------- | ------------------------ | ------------------------------- |
| Configure multiple projects in one app                            | Using a .deployment file | Using `$BP_DOTNET_PROJECT_PATH` |
| Projects referenced by the configured main project are also built | ✅                       | ✅                              |

### Migration from .deployment to environment variable

In TAS, users create a `.deployment` file in your app’s root folder to designate the main project’s path.

```
[config]
project = src/MyApp.Web/MyApp.Web.csproj
```

In TAP, you achieve this with `$BP_DOTNET_PROJECT_PATH` as the `spec` shown in this TAP workload example.
Unlike TAP <!-- TAS? -->, you don’t point to the project file but to the root of the project.

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

## Configure the publish command

| Feature                       | TAS              | TAP                            |
| ----------------------------- | ---------------- | ------------------------------ |
| Configure the publish command | ❌ Not supported | Using $BP_DOTNET_PUBLISH_FLAGS |

Here’s an example spec from a TAP workload:

```yaml
---
spec:
  build:
    env:
    - name: BP_DOTNET_PUBLISH_FLAGS
       value: "--verbosity=normal"
```

## Provide NuGet configurations

| Feature                                     | TAS              | TAP                                                         |
| ------------------------------------------- | ---------------- | ----------------------------------------------------------- |
| Provide a NuGet.Config with the app         | ✅               | ✅                                                          |
| Provide a NuGet.Config via service bindings | ❌ Not supported | Using a binding of type nugetconfig containing nuget.config |

In TAP, if your NuGet config contains credentials or other sensitive data, you can provide it to the
build without explicitly including the file in the application directory.

Create the service binding as a secret like this example:

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

Use the binding in the workload like this example:

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

For more details about service bindings, see TAP documentation https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/tanzu-build-service-tbs-workload-config.html
