# Jira in Tanzu Developer Portal

This topic tells you about the Jira validated frontend plugin.

The Jira frontend plug-in visualizes your JIRA activity stream in a component **Overview** tab.
For more information, see the
[Jira plug-in documentation](https://github.com/RoadieHQ/roadie-backstage-plugins/tree/main/plugins/frontend/backstage-plugin-jira).

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
    - name: '@vmware-tanzu/tdp-plugin-backstage-jira'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version. For example, `^0.0.2`.

### <a id="configure-plug-in"></a> Configure the plug-in

To configure the Jira plug-in, update the `app_config` section of your `tap-values.yaml` file to
include a proxy entry. For example:

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
          # This is a workaround since Jira APIs reject browser origin requests.
          # Any dummy string without whitespace works.
          User-Agent: 'AnyRandomString'
```

Where:

- `JIRA-URL` is the url for your Jira instance.
- `JIRA-TOKEN` is a valid token for your Jira instance.

Add the `annotations` entry for Jira to the catalog entity to display the Jira project results on
the component overview tab.

#### Catalog

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: jira-overview-card
  annotations:
    jira/project-key: YOUR_PROJECT_KEY
```