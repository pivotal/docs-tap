# Home in Tanzu Developer Portal

This topic tells you about the Home front-end plug-in.

The Home front-end plug-in makes it possible to create a custom home page for your
Tanzu Developer Portal to conveniently surface important information. For more information, see the
[Home plug-in documentation](https://github.com/backstage/backstage/tree/master/plugins/home).

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
    - name: '@vmware-tanzu/tdp-plugin-home'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version. For example, `^0.0.2`.

### <a id="configure-plug-in"></a> Configure the plug-in

To configure the plug-in, update the `app_config` section of your `tap-values.yaml` file. All of the
values are optional. For example:

```yaml
tap_gui:
  # ... existing configuration
  app_config:
    # ... existing configuration
    customize:
      # ... existing configuration
      features:
        # ... existing configuration
        home:
          # Activate or deactivate the plugin? Default: true
          enabled: true
          # Show or hide the sidebar entry. Default: true
          showInSidebar: true
          # base64 encoded SVG image.
          logo: 'BASE64-ENCODED-LOGO-STRING'
          welcomeMessage: string
          quickLinks:
            url: string
            label: string
            # base64 encoded SVG image.
            icon: 'BASE64-ENCODED-ICON-STRING'

```

Where `BASE64-ENCODED-LOGO-STRING` and `BASE64-ENCODED-ICON-STRING` are Base64-encoded SVG files.