# SonarQube in Tanzu Developer Portal

This topic tells you about the SonarQube validated frontend and backend plugins.

The SonarQube frontend plug-in displays static analysis code quality statistics.
To learn more about the SonarQube plug-ins visit the [SonarQube Backstage documentation](https://github.com/backstage/backstage/blob/master/plugins/sonarqube).

## <a id="add-plugin"></a> Adding the SonarQube Plug-ins to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the SonarQube plug-ins to your custom Tanzu Developer portal, add the frontend and backend plugins to your `tdp-config.yaml` file:

  ```yaml
  app:
    plugins:
      ...
      - name: '@vmware-tanzu/tdp-plugin-backstage-sonarqube'
        version: '^0.0.2'
      ...
  backend:
    plugins:
      ...
      - name: '@vmware-tanzu/tdp-plugin-backstage-sonarqube-backend'
        version: '^0.0.3'
      ...
  ```

In this example, we use versions `^0.0.2` and `^0.0.3` as they are the latest versions at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

To connect your Stack Overflow plug-in to a running instance, update the `app_config` section of your `tap-values.yaml` file like the following example:

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

* `SONARQUBE-URL` is the url of your SonarQube instance.
* `SONARQUBE-API-KEY` is a valid api key for connecting to the SonarQube instance.


Add the `annotations` entry for sonarqube to the catalog entity to display the sonarqube project results on the component overview tab.

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: backstage
  annotations:
    sonarqube.org/project-key: YOUR_INSTANCE_NAME/YOUR_PROJECT_KEY
```

More detailed explanation for Sonarqube configuration is available [here](https://github.com/backstage/backstage/blob/master/plugins/sonarqube-backend/README.md).