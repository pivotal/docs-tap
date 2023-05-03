# Customize the Tanzu Application Platform GUI telemetry collection

This section describes how to customize telemetry collection for the Tanzu Application Platform GUI portal.

## <a id="telemetry-customizing"></a> Customize organization ID

By default, each instance of Tanzu Application Platform GUI is assigned to a random organization ID to ensure that your sensitive information is not revealed. 

However, you may choose to customize your organization ID and self-identify. That would allow VMware to observe account-level telemetry (please note that all personally-identifyable information would remain anonymized in any case): frequency of portal usage, most popular functionality, etc. 

To make these customizations:

1. Provide additional configuration parameters to the `app_config` section of `tap-values.yaml`:

    ```yaml
    tap_gui:
      app_config:
        pendo_org_id: 'ORGANIZATION-NAME'
    ```

    Where:
    - `ORGANIZATION-NAME` is the name of your organization or the name of the Tanzu Application Platform GUI instance of your choice.

2. Reinstall your Tanzu Application Platform GUI package by following steps in
[Upgrading Tanzu Application Platform](../../upgrading.hbs.md).

After the updated values configuration file is applied in Tanzu Application Platform GUI, your organization ID shall be updated.