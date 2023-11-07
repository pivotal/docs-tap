# Snyk in Tanzu Developer Portal

This topic tells you about the Snyk front-end plug-in.

The Snyk front-end plug-in displays security vulnerabilities from [snyk.io](https://snyk.io/).

The plug-in shows an overview of the vulnerabilities found by Snyk on the **Overview** tab of an
entity. The plug-in also adds a tab to the entity view, which shows all details related to the scan.
For more information, see the
[Snyk Backstage documentation](https://github.com/snyk-tech-services/backstage-plugin-snyk).

## <a id="add-plug-in"></a> Add the plug-in

To add the plug-in to your customized Tanzu Developer Portal, add the front-end plug-in to your
`tdp-config.yaml` file:

```yaml
app:
  plugins:
    ...
    - name: '@vmware-tanzu/tdp-plugin-snyk'
      version: 'VERSION'
    ...
```

Where `VERSION` is the latest version. For example, `^0.0.2`.
