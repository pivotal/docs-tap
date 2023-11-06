# GitHub Actions in Tanzu Developer Portal

This topic tells you about the GitHub Actions validated frontend plugin.

The GitHub Actions frontend plug-in visualizes your GitHub Actions integrations.
To learn more about the GitHub Actions plug-ins visit the [GitHub Actions Backstage documentation](https://github.com/backstage/backstage/tree/master/plugins/github-actions).

## <a id="add-plugin"></a> Adding the GitHub Actions Plug-in to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the GitHub Actions plug-in to your custom Tanzu Developer portal, add the frontend plugin to your `tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-github-actions'
      version: '^0.0.2'
    ...
```

In this example, we use version `^0.0.2` as it is the latest version at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

To configure the GitHub Actions plug-in, update the `app_config` section of your `tap-values.yaml` file to include a gitHub integration like the following example:

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
Where:

* `GITHUB-HOST` is the domain of your github.