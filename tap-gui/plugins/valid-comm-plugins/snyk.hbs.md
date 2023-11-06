# Snyk in Tanzu Developer Portal

This topic tells you about the Snyk validated frontend plugin.

The Snyk frontend plug-in displays security vulnerabilities from [snyk.io](https://snyk.io/). The plug-in shows an overview of the vulnerabilities found by Snyk on the Overview tab of an entity, and adds a tab to the entity view showing all details related to the scan.
To learn more about the Snyk plug-ins visit the [Snyk Backstage documentation](https://github.com/snyk-tech-services/backstage-plugin-snyk).

## <a id="add-plugin"></a> Adding the Snyk Plug-in to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the Snyk plug-in to your custom Tanzu Developer portal, add the frontend plugin to your `tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-snyk'
      version: '^0.0.2'
    ...
```

In this example, we use version `^0.0.2` as it is the latest version at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

There is no runtime configuration required for the Synk frontend plug-in.