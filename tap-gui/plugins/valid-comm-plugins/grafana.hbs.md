# Grafana in Tanzu Developer Portal

This topic tells you about the Grafana validated frontend plugin.

The Grafana frontend plug-in visualises Grafana information in a Component's overview tab.
To learn more about the Grafana plug-ins visit the [Grafana Plug-in documentation](https://github.com/K-Phoen/backstage-plugin-grafana).

## <a id="add-plugin"></a> Adding the Grafana Plug-in to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the Grafana plug-in to your custom Tanzu Developer portal, add the frontend plugin to your `tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-backstage-grafana'
      version: '^0.0.2'
    ...
```

In this example, we use version `^0.0.2` as it is the latest version at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

To configure the Github Actions plug-in, update the `app_config` section of your `tap-values.yaml` file to include a `proxy` entry and `grafana` configiration like the following example:

```yaml
tap_gui:
  # ... existing configuration
  app_config:
    # ... existing configuration
    proxy:
      # ... existing configuration
      '/grafana/api':
        # May be a public or an internal DNS
        target: https://test.grafana.net/
        headers:
          Authorization: 'Bearer ${GRAFANA_TOKEN}'

    grafana:
      # Publicly accessible domain
      domain: https://test.grafana.net/
      # Is unified alerting enabled in Grafana?
      # See: https://grafana.com/blog/2021/06/14/the-new-unified-alerting-system-for-grafana-everything-you-need-to-know/
      # Optional. Default: false
      unifiedAlerting: true

```
Where:

* `GRAFANA_TOKEN` is a valid token for your Grafana instance.

Add the annotations entry for Grafana to the catalog entity to display the grafana alerts and dashboard lists on the component overview tab.

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: grafana-example
  description: An example for Grafana integration.
  annotations:
    grafana/dashboard-selector: 'general'
    grafana/alert-label-selector: 'type=http-requests'
```