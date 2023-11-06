# Jira in Tanzu Developer Portal

This topic tells you about the Jira validated frontend plugin.

The Jira frontend plug-in visualizes your JIRA activity stream in a Component's overview tab.
To learn more about the Jira plug-ins visit the [Jira Plug-in documentation](https://github.com/RoadieHQ/roadie-backstage-plugins/tree/main/plugins/frontend/backstage-plugin-jira).

## <a id="add-plugin"></a> Adding the Jira Plug-in to a Custom Tanzu Developer Portal

### <a id="buildtime-config"></a> Buildtime Configuration

To add the Jira plug-in to your custom Tanzu Developer portal, add the frontend plugin to your `tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-backstage-jira'
      version: '^0.0.2'
    ...
```

In this example, we use version `^0.0.2` as it is the latest version at the time of writing.

### <a id="runtime-config"></a> Runtime Configuration

To configure the Jira plug-in, update the `app_config` section of your `tap-values.yaml` file to include a proxy entry like the following example:

```yaml
tap_gui:
  # ... existing configuration
  app_config:
    # ... existing configuration
    proxy:
      # ... existing configuration
      '/jira/api':
        target: JIRA-URL
        headers:
          Authorization:
            $env: JIRA-TOKEN
          Accept: 'application/json'
          Content-Type: 'application/json'
          X-Atlassian-Token: 'no-check'
          # This is a workaround since Jira APIs reject browser origin requests. Any dummy string without whitespace works.
          User-Agent: 'AnyRandomString'
```
Where:

* `JIRA-URL` is the url for your Jira instance.
* `JIRA-TOKEN` is a valid token for your Jira instance.

Add the `annotations` entry for Jira to the catalog entity to display the jira project results on the component overview tab.

##### Catalog

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: jira-overview-card
  annotations:
    jira/project-key: YOUR_PROJECT_KEY
```