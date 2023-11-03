# Homepage in Tanzu Developer Portal

This topic tells you about the Homepage validated frontend plugin.

The Homepage frontend plug-in makes it possible to create a custom home page for your Tanzu Developer Portal to conveniently surface important information.
To learn more about the Homepage plug-ins visit the [Homepage Backstage documentation](https://github.com/backstage/backstage/tree/master/plugins/home).

## <a id="add-plugin"></a> Adding the Homepage Plug-in to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the Homepage plug-in to your custom Tanzu Developer portal, add the frontend plugin to your `tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-home'
      version: '^0.0.2'
    ...
```

In this example, we use version `^0.0.2` as it is the latest version at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

To customize your Homepage, update the `app_config` section of your `tap-values.yaml` file like the following example:

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

Where:

* all of the values are optional
* `BASE64-ENCODED-LOGO-STRING` and 'BASE64-ENCODED-ICON-STRING' are base64 encoded svgs