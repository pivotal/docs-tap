# Stack Overflow in Tanzu Developer Portal

This topic tells you about the Stack Overflow front-end plug-in.

The Stack Overflow front-end plug-in provides Stack Overflow functions in Tanzu Developer Portal.
For more information, see the
[Backstage Stack Overflow documentation](https://github.com/backstage/backstage/tree/master/plugins/stack-overflow).

## <a id="add-and-configure"></a> Add and configure the plug-in

To add the plug-in to your customized Tanzu Developer Portal and configure the plug-in, see the
following sections.

### <a id="add-plug-in"></a> Add the plug-in

To add the plug-in to your customized Tanzu Developer Portal, add the front-end plug-in to your
`tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-stack-overflow'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version. For example, `^0.0.2`.

### <a id="configure-plug-in"></a> Configure the plug-in

To configure your Stack Overflow plug-in, update the `app_config` section of your `tap-values.yaml`
file. For example:

```yaml
tap_gui:
  # ... existing configuration
  app_config:
    # ... existing configuration
    stackoverflow:
      baseUrl: https://api.stackexchange.com/2.2 # alternative: your internal stack overflow instance
```
