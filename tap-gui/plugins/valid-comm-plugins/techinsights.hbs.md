# TechInsights in Tanzu Developer Portal

This topic tells you about the TechInsights validated frontend and backend plugins.

The TechInsights frontend plug-in visualizes entity checks defined by the backend plug-in. 
The TechInsights backend plug-in performs entity checks and provides an API for the fronend plug-in.
To learn more about the TechInsights plug-ins visit the [TechInsights Backstage documentation](https://github.com/backstage/backstage/tree/master/plugins/tech-insights).

## <a id="add-plugin"></a> Adding the TechInsights Plug-in to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the TechInsights plug-ins to your custom Tanzu Developer portal, add the frontend and backend plugins to your `tdp-config.yaml` file:

  ```yaml
  app:
    plugins:
      ...
      - name: '@vmware-tanzu/tdp-plugin-techinsights'
        version: '^0.0.2'
      ...
  backend:
    plugins:
      ...
      - name: '@vmware-tanzu/tdp-plugin-techinsights-backend'
        version: '^0.0.2'
      ...
  ```

In this example, we use version `^0.0.2` as it is the latest version at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

There is no runtime configuration required for the TechInsights plug-ins.