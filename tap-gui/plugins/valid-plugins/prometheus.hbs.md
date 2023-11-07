# Prometheus in Tanzu Developer Portal

This topic tells you about the Prometheus front-end plug-in.

The Prometheus front-end plug-in displays Prometheus information in your Tanzu Developer Portal.
For more information, see the
[Prometheus plug-in documentation](https://github.com/RoadieHQ/roadie-backstage-plugins/tree/main/plugins/frontend/backstage-plugin-prometheus).

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
    - name: '@vmware-tanzu/tdp-plugin-prometheus'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version. For example, `^0.0.2`.

### <a id="configure-plug-in"></a> Configure the plug-in

To configure the Prometheus plug-in, update the `app_config` section of your `tap-values.yaml` file
to include a `proxy` entry and `prometheus` configuration. For example:

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

Where `PROMETHEUS-AUTH-TOKEN` is a valid token for your secure `prometheus` instance
