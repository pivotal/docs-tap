# Configure Garbage collection for the Knative Revisions

This topic describes the current Garbage collection defaults for Knative Revisions and how they can be updated in TAP.

## Overview

Knative offers configuration for garbage collection. More information available [here](https://knative.dev/docs/serving/revisions/revision-admin-config-options/).

The current configuration set the following defaults to mark Knative revisions for garbage collection:

```
  * `retain-since-create-time: "48h"`: Any revision created with an age of 2 days is considered for garbage collection.
  * `retain-since-last-active-time: "15h"`: Revision that was last active at least 15 hours ago is considered for garbage collection.
  * `min-non-active-revisions: "2"`: The minimum number of inactive Revisions to retain.
  * `max-non-active-revisions: "5"`: The maximum number of inactive Revisions to retain.
```

## Follow the step below to update default values for Knative Garbage Collection

* Create an overlay with contents shown below:

```
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

* Update TAP values
```
package_overlays:
  - name: cnrs
    secrets:
      - name: cnr-overlay-gc-cm
```

* Update TAP Package
```
tanzu package installed update tap -p tap.tanzu.vmware.com --values-file tap-values.yml  -n tap-install
```

* Verify that the overlay was applied by running following commands:

```
kubectl get configmap config-gc --namespace knative-serving --output jsonpath="{.data.retain-since-create-time}"
kubectl get configmap config-gc --namespace knative-serving --output jsonpath="{.data.retain-since-last-active-time}"
kubectl get configmap config-gc --namespace knative-serving --output jsonpath="{.data.min-non-active-revisions}"
kubectl get configmap config-gc --namespace knative-serving --output jsonpath="{.data.max-non-active-revisions}"
```
