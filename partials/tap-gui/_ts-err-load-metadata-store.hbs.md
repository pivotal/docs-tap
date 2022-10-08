### <a id='err-load-metadata-store'></a> An error occurred while loading data from the Metadata Store

#### Symptom

In the Supply Chain Choreographer plug-in, if you see an an error that reads *An error occurred while loading data from the Metadata Store*, there are some common causes. The screenshot below shows what the error looks like.

<!-- [Error loading metadata store](images/scc-error-loading-metadata-store.png) How do we use images in partials? They can't be relative links -->

#### Cause

The most common cause is missing configuration in `tap-values.yaml` that allows Tanzu Application Platform GUI to talk to Supply Chain Security Tools - Store.

#### Solution

See [Supply Chain Choreographer - Enable CVE scan results](../../tap-gui/plugins/scc-tap-gui.hbs.md#scan) for the necessary configuration to add to `tap-values.yaml`. After adding the configuration, update your TAP deployment or TAP GUI deployment with the new values.