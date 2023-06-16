# Enable Steeltoe apps for Application Live View

This topic for developers tells you how to extend .NET Core Apps to Steeltoe apps and enable
Application Live View on Steeltoe workloads within Tanzu Application Platform (commonly known as TAP).

Application Live View supports Steeltoe .NET apps with .NET core runtime version `v6.0.8`.

## <a id="extend-net-apps-steeltoe"></a>Extend .NET Core Apps to Steeltoe Apps

A .NET Core application can be extended to a Steeltoe application by adding independent NuGet packages.

To enable the Actuators on a .NET Core App:

1. Add a PackageReference to your `.csproj` file:

    ```xml
    <PackageReference Include="Steeltoe.Management.EndpointCore" Version="$(SteeltoeVersion)" />
    ```

    >**Note** The PackageReference is expected to change to `Steeltoe.Management.Endpoint` from version Steeltoe 4.0 onwards.

2. Call the extension `AddAllActuators` in your `Program.cs` file:

    ```csharp
    builder.WebHost.AddAllActuators();
    ```

3. (Optional) You can add app-specific configurations, such as the following.

    To expose all management actuator endpoints except `env` endpoint, add the following configuration to your `appsettings.json` file:

    ```json
    {
      "Management": {
        "Endpoints": {
          "Actuator":{
            "Exposure": {
              "Include": [ "*" ],
              "Exclude": [ "env" ]
            }
          }
        }
      }
    }
    ```

    To enable logging, add the following configuration to your `appsettings.json` file:

    ```json
    {
      "Logging": {
        "LogLevel": {
          "Default": "Information",
          "Microsoft": "Warning",
          "Steeltoe": "Warning",
          "Sample": "Information"
        }
      }
    }
    ```

    To enable heapdump, add the following configuration to your `appsettings.json` file:

    ```json
    {
      "Management": {
        "Endpoints": {
          "HeapDump": {
            "HeapDumpType": "Normal"
          }
        }
      }
    }
    ```

## <a id="enable-app-live-view-steeltoe"></a>Enable Application Live View on Steeltoe Tanzu Application Platform workload

You can enable Application Live View to interact with a Steeltoe app within Tanzu Application Platform.

To enable Application Live View on the Steeltoe Tanzu Application Platform workload, the Application Live View Convention Service automatically applies labels on the workload, such as `tanzu.app.live.view.application.flavours: steeltoe` and `tanzu.app.live.view: true`, based on the Steeltoe image metadata.

Here's an example of creating a workload for a Steeltoe Application:

```console
tanzu apps workload create steeltoe-app --type web --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path weatherforecast-steeltoe --git-branch main --annotation autoscaling.knative.dev/min-scale=1 --yes --label app.kubernetes.io/part-of=sample-app
```

If your application image is NOT built with Tanzu Build Service, to enable Application Live View on Steeltoe Tanzu Application Platform workload, use the following command. For example:

```console
tanzu apps workload create steeltoe-app --type web --app steeltoe-app --image IMAGE-NAME --annotation autoscaling.knative.dev/min-scale=1 --yes --label tanzu.app.live.view=true --label tanzu.app.live.view.application.name=steeltoe-app --label tanzu.app.live.view.application.flavours=steeltoe
```

Where `IMAGE-NAME` is the name of your application image.

>**Note** Thread metrics is available in SteeltoeVersion `3.2.*`. To enable the Threads page in the Application Live View UI, add the following configuration to your `.csproj` file:

```xml
<PropertyGroup>
    <SteeltoeVersion>3.2.*</SteeltoeVersion>
</PropertyGroup>
```
