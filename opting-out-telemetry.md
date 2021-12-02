# Opting out of telemetry collection

This document describes how to opt out of VMware's Customer Experience Improvement Program (CEIP).
By default, when you install Tanzu Application Platform, you are opted into telemetry collection. 
To turn off telemetry collection, you need to follow these instructions.

## Turn off telemetry collection

To turn off telemetry collection on your Tanzu Application Platform installation:

1. Run the following command: 

    ```
    kubectl apply < <<EOF
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


Your TAP deployment no longer emits telemetry and you are opted out of the CEIP.
Please note that opting out of telemetry collection will mean that VMware cannot offer you proactive support or any other benefits that accompany participation in the CEIP.
