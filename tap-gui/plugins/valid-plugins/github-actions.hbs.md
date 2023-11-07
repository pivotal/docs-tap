# GitHub Actions in Tanzu Developer Portal

This topic tells you about the GitHub Actions validated front-end plug-in.

The GitHub Actions front-end plug-in visualizes your GitHub Actions integrations.
For more information, see the
[GitHub Actions Backstage documentation](https://github.com/backstage/backstage/tree/master/plugins/github-actions).

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
    - name: '@vmware-tanzu/tdp-plugin-github-actions'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version. For example, `^0.0.2`.

### <a id="configure-plug-in"></a> Configure the plug-in

To configure the plug-in, update the `app_config` section of your `tap-values.yaml` file to include
a GitHub integration. For example:

```yaml
tap_gui:
  # ... existing configuration
  app_config:
    # ... existing configuration
    integrations:
      github:
        - host: 'GITHUB-HOST.com'
          apiBaseUrl: 'https://api.GITHUB-HOST.com'
```

Where `GITHUB-HOST` is your GitHub domain