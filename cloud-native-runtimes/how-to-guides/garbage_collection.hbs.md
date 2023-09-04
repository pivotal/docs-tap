# Configure Garbage collection for the Knative revisions

This topic tells you about current Garbage collection defaults for Knative Revisions and you can update them in Tanzu Application Platform.

## <a id='overview'></a> Overview

You can configure garbage collection with Knative. For more information, see the [Knative documentation](https://knative.dev/docs/serving/revisions/revision-admin-config-options/).

The current configuration sets the following defaults to mark Knative revisions for garbage collection:

```console
  * `retain-since-create-time: "48h"`: Any revision created with an age of 2 days is considered for garbage collection.
  * `retain-since-last-active-time: "15h"`: Revision that was last active at least 15 hours ago is considered for garbage collection.
  * `min-non-active-revisions: "2"`: The minimum number of inactive Revisions to retain.
  * `max-non-active-revisions: "5"`: The maximum number of inactive Revisions to retain.
```

## <a id='overview'></a> Update default values for Knative Garbage Collection

To update default values for Knative Garbage Collection:

1. Create an overlay with the following contents:

  ```console
  apiVersion: v1
  kind: Secret
  metadata:
    name: cnr-overlay-gc-cm
    namespace: tap-install #! namespace where tap is installed
  stringData:
    overlay-gc-cm.yaml: |
      #@ load("@ytt:overlay", "overlay")
      #@overlay/match by=overlay.subset({"kind":"ConfigMap","metadata":{"name":"config-gc"}})
      ---
      data:
        #@overlay/match missing_ok=True
        retain-since-create-time: "48h"
        #@overlay/match missing_ok=True
        retain-since-last-active-time: "15h"
        #@overlay/match missing_ok=True
        min-non-active-revisions: "2"
        #@overlay/match missing_ok=True
        max-non-active-revisions: "5"
  ```

1. Update Tanzu Application Platform values.

  ```console
  package_overlays:
    - name: cnrs
      secrets:
        - name: cnr-overlay-gc-cm
  ```

1. Update Tanzu Application Platform Package.

  ```console
  tanzu package installed update tap -p tap.tanzu.vmware.com --values-file tap-values.YAML  -n tap-install
  ```

1. Verify that the overlay was applied by running following commands:

  ```console
  kubectl get configmap config-gc --namespace knative-serving --output jsonpath="{.data.retain-since-create-time}"
  kubectl get configmap config-gc --namespace knative-serving --output jsonpath="{.data.retain-since-last-active-time}"
  kubectl get configmap config-gc --namespace knative-serving --output jsonpath="{.data.min-non-active-revisions}"
  kubectl get configmap config-gc --namespace knative-serving --output jsonpath="{.data.max-non-active-revisions}"
  ```
