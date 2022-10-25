### <a id='err-load-metadata-store'></a> An error occurred while loading data from the Metadata Store

#### Symptom

In the Supply Chain Choreographer plug-in, you see the error message
`An error occurred while loading data from the Metadata Store`.

[Error loading metadata store](https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/Images/images-scc-error-loading-metadata-store.png)

#### Cause

There are multiple potential causes. The most common cause is `tap-values.yaml` missing the
configuration that enables Tanzu Application Platform GUI to communicate with
Supply Chain Security Tools - Store.

#### Solution

See
[Supply Chain Choreographer - Enable CVE scan results](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/GUID-tap-gui-plugins-scc-tap-gui.html#scan)
for the necessary configuration to add to `tap-values.yaml`.
After adding the configuration, update your Tanzu Application Platform deployment or
Tanzu Application Platform GUI deployment with the new values.
