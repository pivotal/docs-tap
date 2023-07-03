### <a id='err-load-metadata-store'></a> An error occurred while loading data from the Metadata Store

#### Symptom

In the Supply Chain Choreographer plug-in, you see the error message
`An error occurred while loading data from the Metadata Store`.

![Screenshot of Tanzu Developer Portal displaying the error message about loading data from the metadata store.](/docs-tap/images/scc-error-loading-metadata-store.png)

#### Cause

There are multiple potential causes. The most common cause is `tap-values.yaml` missing the
configuration that enables Tanzu Developer Portal to communicate with
Supply Chain Security Tools - Store.

#### Solution

See
[Supply Chain Choreographer - Enable CVE scan results](/docs-tap/tap-gui/plugins/scc-tap-gui.hbs.md#scan)
for the necessary configuration to add to `tap-values.yaml`.
After adding the configuration, update your Tanzu Application Platform deployment or
Tanzu Developer Portal deployment with the new values.
