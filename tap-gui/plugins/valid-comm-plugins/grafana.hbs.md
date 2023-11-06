# Grafana in Tanzu Developer Portal

This topic tells you about the Grafana validated front-end plug-in.

The Grafana front-end plug-in visualizes Grafana information in a component **Overview** tab.
For more information, see the
[Grafana plug-in documentation](https://github.com/K-Phoen/backstage-plugin-grafana).

## <a id="add-and-configure"></a> Add and configure the plug-in

To add the plug-in to your customized Tanzu Developer Portal and configure the plug-in, see the
following sections.

### <a id="add-plug-in"></a> Add the plug-in

To add the plug-in to your custom Tanzu Developer Portal, add the front-end plug-in to your
`tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-backstage-grafana'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version. For example, `^0.0.2`.

### <a id="configure-plug-in"></a> Configure the plug-in

To configure the plug-in, update the `app_config` section of your `tap-values.yaml` file to include
a `proxy` entry and `grafana` configuration. For example:

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
          Authorization: 'Bearer ${GRAFANA-TOKEN}'

    grafana:
      # Publicly accessible domain
      domain: https://test.grafana.net/
      # Is unified alerting enabled in Grafana?
      # See: https://grafana.com/blog/2021/06/14/the-new-unified-alerting-system-for-grafana-everything-you-need-to-know/
      # Optional. Default: false
      unifiedAlerting: true

```

Where `GRAFANA-TOKEN` is a valid token for your Grafana instance.

Add the annotations entry for Grafana to the catalog entity to display the Grafana alerts and
dashboard lists on the component **Overview** tab.

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