# Opt out of telemetry collection

This topic tells you how to opt out of the VMware Customer Experience Improvement Program (CEIP) and
out of Pendo telemetry on an organizational level.

There are two components for telemetry collection in Tanzu Application Platform
(commonly known as TAP) under the VMware Customer Experience Improvement Program (CEIP):

1. The standard CEIP telemetry collection
2. Pendo telemetry from Tanzu Developer Portal

Each telemetry component has its own opt-in and opt-out process.
The CEIP telemetry opt-out decision can be made at an organizational level, whereas the
decision regarding the Pendo telemetry is available both on an organizational level and at an
individual user level.

When you install Tanzu Application Platform, both standard CEIP and Pendo telemetry are turned on by
default. If you opt out of standard CEIP telemetry collection, VMware cannot offer you proactive support and
the other benefits that accompany participation in the CEIP.

## <a id="turn-off"></a> Turn off standard CEIP telemetry collection

To deactivate Pendo telemetry collection, see
[Enable or deactivate the Pendo telemetry for the organization](#nbl-or-dsbl-pendo-for-org) later in
the topic.

> **Note** If you decide to opt in to Pendo telemetry collection, each user is given the option to
> opt in or opt out. For more information, see
> [Opt in or opt out of Pendo telemetry for Tanzu Developer Portal](tap-portal-telemetry.hbs.md).

To turn off CEIP telemetry collection, follow these instructions:

kubectl
: To turn off telemetry collection on Tanzu Application Platform by using kubectl:

   1. Ensure that your Kubernetes context is pointing to the cluster where Tanzu Application Platform
      is installed.

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
      apply the change:

        ```console
        kubectl delete pods --namespace tap-telemetry --all
        ```

  Your Tanzu Application Platform deployment now no longer emits telemetry, and you have opted out of
  the CEIP.

Tanzu CLI
: The Tanzu CLI provides a telemetry plug-in enabled by the Tanzu Framework v0.25.0, which is
  included in Tanzu Application Platform v1.3 and later.

  To turn off telemetry collection on your Tanzu Application Platform by using the Tanzu CLI, run:

    ```console
    tanzu telemetry update --CEIP-opt-out
    ```

  To learn more about how to update the telemetry settings, run:

    ```console
    tanzu telemetry update --help
    ```

  Your Tanzu Application Platform deployment now no longer emits telemetry, and you have opted out of
  the CEIP.

### <a id="nbl-or-dsbl-pendo-for-org"></a> Turn off Pendo telemetry collection

To deactivate the program for the entire organization, add the following parameters to your
`tap-values.yaml` file:

```yaml
tap_gui:
  app_config:
    pendoAnalytics:
      enabled: false
```

To enable Pendo telemetry for the organization, add the following parameters to your `tap-values.yaml`
file:

```yaml
tap_gui:
  app_config:
    pendoAnalytics:
      enabled: true
```
