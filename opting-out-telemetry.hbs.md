# Opt out of telemetry collection

This topic describes how to opt out of the VMware Customer Experience Improvement Program (CEIP).
By default, when you install Tanzu Application Platform, you are opted into telemetry collection.

>**Note** If you opt out of telemetry collection, VMware cannot offer you proactive support
and the other benefits that accompany participation in the CEIP.

Follow these steps to turn off telemetry collection:

kubectl
: To turn off telemetry collection on your Tanzu Application Platform by using kubectl:

    1. Ensure your Kubernetes context is pointing to the cluster where Tanzu Application Platform is installed.

    2. Run the following `kubectl` command:

        ```console
        kubectl apply -f - <<EOF
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

    3. If you already have Tanzu Application Platform installed, restart the telemetry collector to pick up the change:

        ```console
        kubectl delete pods --namespace tap-telemetry --all
        ```

Tanzu CLI
: The Tanzu CLI provides a telemetry plugin enabled by the Tanzu Framework v0.25.0, which has been included in Tanzu Application Platform since v1.3. 

    To turn off telemetry collection on your Tanzu Application Platform by using the Tanzu CLI:

    ```console
    $ tanzu telemetry update --CEIP-opt-out
    *no output*
    ```

    To learn more about how to update the telemetry settings:

    ```concole
    $ tanzu telemetry update --help
    Update tanzu telemetry settings

    Usage:
      tanzu telemetry update [flags]

    Examples:

        # opt into ceip
        tanzu telemetry update --CEIP-opt-in
        # opt out of ceip
        tanzu telemetry update --CEIP-opt-out
        # update shared configuration settings
        tanzu telemetry update --env-is-prod "true" --entitlement-account-number "1234" --csp-org-id "XXXX"


    Flags:
          --CEIP-opt-in                         opt into VMware's CEIP program
          --CEIP-opt-out                        opt out of VMware's CEIP program
          --csp-org-id string                   Accepts a string and sets a cluster-wide CSP
                                                                                org ID. Empty string is equivalent to
                                                                                unsetting this value.
          --entitlement-account-number string   Accepts a string and sets a cluster-wide
                                                                                entitlement account number. Empty string is
                                                                                equivalent to unsetting this value
          --env-is-prod string                  Accepts a boolean and sets a cluster-wide
                                                                                value denoting whether the target is a
                                                                                production cluster or not.
      -h, --help                                help for update
    ```

At this point, your Tanzu Application Platform deployment no longer emits telemetry, and you are opted out of the CEIP.
