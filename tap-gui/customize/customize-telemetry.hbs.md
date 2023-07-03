# Customize the Tanzu Developer Portal telemetry collection

This section tells you how to customize telemetry collection for the Tanzu Developer Portal
(formerly named Tanzu Application Platform GUI) portal.

## <a id="telemetry-customizing"></a> Customize organization ID

By default, each instance of Tanzu Developer Portal is assigned to a random organization ID
to ensure that your sensitive information is not revealed.

However, you can choose to customize your organization ID and self-identify. Doing so allows VMware
to observe account-level telemetry, such as frequency of portal use, most popular function,
and so on.
All personally identifiable information remains anonymized in any case. The organization name is
hashed to prevent VMware from identifying you by the value.

To customize:

1. Provide additional configuration parameters to the `app_config` section of `tap-values.yaml`:

   ```yaml
   tap_gui:
     app_config:
       pendoAnalytics:
         organizationId: 'ORGANIZATION-NAME'
   ```

   Where `ORGANIZATION-NAME` is the name of your organization or the name of the
   Tanzu Developer Portal instance of your choice. `ORGANIZATION-NAME` must be unique and
   static across an instance of Tanzu Developer Portal so that your organization name remains
   the same across refreshes of the Tanzu Application Platform database.

2. Reinstall your Tanzu Developer Portal package by following the steps in
   [Upgrade Tanzu Application Platform](../../upgrading.hbs.md).

After the updated values configuration file is applied in Tanzu Developer Portal, your
organization ID is updated.
