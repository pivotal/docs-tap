# Enabling Steeltoe apps for Application Live View

This topic describes how to configure a Steeltoe app to be observed by
Application Live View within Tanzu Application Platform.


## Enable Steeltoe apps

You can enable Application Live View to interact with a Steeltoe app within Tanzu Application Platform.

To expose management actuator endpoints, add following configuration to your `appsettings.json` file:

```json
{
  "Management": {
    "Endpoints": {
      "Actuator":{
        "Exposure": {
          "Include": [ "*" ]
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

The thread metrics is available in SteeltoeVersion `3.2.0-rc1`. Therefore, to enable Threads page in Application Live View UI, add the following configuration to your `.csproj` file:

```xml
<PropertyGroup>
    <SteeltoeVersion>3.2.0-rc1</SteeltoeVersion>
</PropertyGroup>
```

To enable Application Live View on the Steeltoe TAP workload, you must manually add the label `tanzu.app.live.view.application.flavours: steeltoe` on your workload yaml:

```
metadata:
    labels:
        tanzu.app.live.view.application.flavours: steeltoe
```
