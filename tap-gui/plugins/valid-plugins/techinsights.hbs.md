# TechInsights in Tanzu Developer Portal

This topic tells you about the TechInsights front-end and back-end plug-ins.

The TechInsights front-end plug-in visualizes entity checks defined by the back-end plug-in.
The TechInsights back-end plug-in performs entity checks and provides an API for the front-end plug-in.
For more information about the TechInsights plug-in, see the
[Backstage TechInsights documentation](https://github.com/backstage/backstage/tree/master/plugins/tech-insights).

## <a id="add-plug-in"></a> Add the plug-in

To add the plug-in to your customized Tanzu Developer Portal, add the front-end and back-end
plug-ins to your `tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-techinsights'
      version: 'VERSION'
    ...
backend:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-techinsights-backend'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version for each plug-in. For example, `^0.0.2`.