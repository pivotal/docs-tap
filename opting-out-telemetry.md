# Opting out of telemetry collection

This document describes how to opt out of the VMware Customer Experience Improvement Program (CEIP).
By default, when you install Tanzu Application Platform, you are opted into telemetry collection.
To turn off telemetry collection, you need to follow the instructions below.

>**Note:** If you opt out of telemetry collection, VMware cannot offer you proactive support
and the other benefits that accompany participation in the CEIP.

##<a id="turn-off"></a> Turn off telemetry collection

To turn off telemetry collection on your Tanzu Application Platform installation:

1. Run:

    ```
     <!-- The opening code fence needs the language or |```console|. The closing code fence needs a newline beneath it. Run Style Checker again after fixing all errors of this type; it might find more problems. -->kubectl apply < <<EOF
    apiVersion: v1
    kind: Namespace
    metadata:
      name: vmware-system-telemetry
    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      namespace: vmware-system-telemetry
      name: vmware-telemetry-cluster-ceip
    data:
      level: disabled
    EOF
    ```


Your Tanzu Application Platform deployment no longer emits telemetry, and you are opted out of the CEIP.
