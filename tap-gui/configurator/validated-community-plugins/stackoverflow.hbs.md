# Stack Overflow in Tanzu Developer Portal

This topic tells you about the Stack Overflow validated frontend plugin.

The Stack Overflow frontend plug-in provides Stack Overflow functionality in your Tanzu Developer Portal.
To learn more about the Stack Overflow plug-ins visit the [Stack Overflow Backstage documentation](https://github.com/backstage/backstage/tree/master/plugins/stack-overflow).

## <a id="add-plugin"></a> Adding the Stack Overflow Plug-in to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the Stackoverflow plug-in to your custom Tanzu Developer portal, add the frontend plugin to your `tdp-config.yaml` file:

  ```yaml
  app:
    plugins:
      ...
      - name: '@vmware-tanzu/tdp-plugin-stack-overflow'
        version: '^0.0.2'
      ...
  ```

In this example, we use version `^0.0.2` as it is the latest version at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

To configure your Stack Overflow plug-in, update the `app_config` section of your `tap-values.yaml` file like the following example:

```yaml
tap_gui:
  # ... existing configuration
  app_config:
    # ... existing configuration
    stackoverflow:
      baseUrl: https://api.stackexchange.com/2.2 # alternative: your internal stack overflow instance
```
