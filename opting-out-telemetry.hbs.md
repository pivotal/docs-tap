# Opt out of telemetry collection

This topic describes how to opt out of the VMware Customer Experience Improvement Program (CEIP).
By default, when you install Tanzu Application Platform, you are opted into telemetry collection.

If you opt out of telemetry collection, VMware cannot offer you proactive support and the other
benefits that accompany participation in the CEIP.

## <a id="turn-off"></a> Turn off telemetry collection

To turn off telemetry collection, follow the instructions below.
To deactivate Pendo telemetry collection, see
[Enable or deactivate the Pendo telemetry for the organization](#nbl-or-dsbl-pendo-for-org) later in
the topic.

> **Note** If you decide to opt in to Pendo telemetry collection, each user is given the option to
> opt in or opt out. For more information, see
> [Opt in or opt out of Pendo telemetry for Tanzu Application Platform GUI](tap-portal-telemetry.hbs.md).

kubectl
: To turn off telemetry collection on Tanzu Application Platform by using kubectl:

   1. Ensure your Kubernetes context is pointing to the cluster where Tanzu Application Platform is
      installed.

   2. Run:

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

   3. If you already have Tanzu Application Platform installed, restart the telemetry collector to
      pick up the change:

        ```console
        kubectl delete pods --namespace tap-telemetry --all
        ```

Tanzu CLI
: The Tanzu CLI provides a telemetry plug-in enabled by the Tanzu Framework v0.25.0, which has been
  included in Tanzu Application Platform since v1.3.

  To turn off telemetry collection on your Tanzu Application Platform by using the Tanzu CLI, run:

    ```console
    tanzu telemetry update --CEIP-opt-out
    ```

  To learn more about how to update the telemetry settings, run:

    ```console
    tanzu telemetry update --help
    ```

At this point, your Tanzu Application Platform deployment no longer emits telemetry, and you have
opted out of the CEIP.

### <a id="nbl-or-dsbl-pendo-for-org"></a> Enable or deactivate the Pendo telemetry for the organization

To enable Pendo telemetry for the organization, add the following parameters to your `tap-values.yaml`
file:

```yaml
tap_gui:
  app_config:
    pendoAnalytics:
      enabled: true
```

To deactivate the program for the entire organization, add the following parameters to your
`tap-values.yaml` file:

```yaml
tap_gui:
  app_config:
    pendoAnalytics:
      enabled: false
```
