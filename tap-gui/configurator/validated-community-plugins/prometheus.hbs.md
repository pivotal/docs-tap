# Prometheus in Tanzu Developer Portal

This topic tells you about the Prometheus validated frontend plugin.

The Prometheus frontend plug-in displays Prometheus information in your Tanzu Developer Portal. 
To learn more about the Snyk plug-ins visit the [Prometheus Plug-in documentation](https://github.com/RoadieHQ/roadie-backstage-plugins/tree/main/plugins/frontend/backstage-plugin-prometheus).

## <a id="add-plugin"></a> Adding the Prometheus Plug-in to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the Prometheus plug-in to your custom Tanzu Developer portal, add the frontend plugin to your `tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-prometheus'
      version: '^0.0.2'
    ...
```

In this example, we use version `^0.0.2` as it is the latest version at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

To configure the Prometheus plug-in, update the `app_config` section of your `tap-values.yaml` file to include a `proxy` entry and `prometheus` configiration like the following example:

```yaml
tap_gui:
  # ... existing configuration
  app_config:
    # ... existing configuration
    proxy:
      # ... existing configuration
      '/prometheus/api':
        # url to the api and path of your hosted prometheus instance
        target: http://localhost:9090/api/v1/
        changeOrigin: true
        secure: false
        headers:
          Authorization: AUTH-TOKEN

    # Defaults to /prometheus/api and can be omitted if proxy is configured for that url
    prometheus:
      proxyPath: /prometheus/api
      uiUrl: http://localhost:9090
```
Where:

* `PROMETHEUS-AUTH-TOKEN` is a valid token for your secure prometheus instance.
