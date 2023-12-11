# SonarQube in Tanzu Developer Portal

This topic tells you about the SonarQube validated front-end and back-end plug-ins.

The SonarQube front-end plug-in displays static analysis code quality statistics.
For more information, see the
[SonarQube Backstage documentation](https://github.com/backstage/backstage/blob/master/plugins/sonarqube).

## <a id="add-and-configure"></a> Add and configure the plug-in

To add the plug-in to your customized Tanzu Developer Portal and configure the plug-in, see the
following sections.

### <a id="add-plug-in"></a> Add the plug-in

To add the plug-in to your customized Tanzu Developer Portal, add the front-end and back-end
plug-ins to your `tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-backstage-sonarqube'
      version: 'VERSION'
    ...
backend:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-backstage-sonarqube-backend'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version for each plug-in. For example, `^0.0.2` and `^0.0.3`.

### <a id="configure-plug-in"></a> Configure the plug-in

To connect your SonarQube plug-in to a running instance, update the `app_config` section of your
`tap-values.yaml` file. For example:

```yaml
tap_gui:
  # ... existing configuration
  app_config:
    # ... existing configuration
    sonarqube:
      baseUrl: 'SONARQUBE-URL'
      apiKey: 'SONARQUBE-API-KEY'
```

Where:

- `SONARQUBE-URL` is the URL of your SonarQube instance
- `SONARQUBE-API-KEY` is a valid API key for connecting to the SonarQube instance

Add the `annotations` entry for SonarQube to the catalog entity to display the SonarQube project
results on the component overview tab.

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: backstage
  annotations:
    sonarqube.org/project-key: YOUR_INSTANCE_NAME/YOUR_PROJECT_KEY
```

For a more detailed explanation of SonarQube configuration, see
[SonarQube Backstage documentation](https://github.com/backstage/backstage/blob/master/plugins/sonarqube-backend/README.md).