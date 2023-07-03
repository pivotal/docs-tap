# Opt in or opt out of Pendo telemetry for Tanzu Developer Portal

<!-- This topic must be accessible from https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/tap-portal-telemetry.html. And possibly all the content needs to be in one place, exactly as below, because it's a legal disclosure about data collection. Be careful wrt to content strategy, in other words. -->

Tanzu Developer Portal (commonly called TAP GUI) uses Pendo.io to better understand the way
users interact with it to provide a better user experience for VMware customers and to
improve VMware products and services.

Pendo.io collects data based on your interaction with the software, such as clickstream data and page
loads, hashed user ID, and limited browser and device information.

By default, each instance of Tanzu Developer Portal is assigned to a random organization ID
to ensure that your sensitive information is not revealed.

However, you can choose to customize your organization ID and self-identify. Doing so allows VMware
to observe account-level telemetry, such as frequency of portal use, most popular function,
and so on.
All personally identifiable information remains anonymized in any case. The organization name is
hashed to prevent VMware from identifying you by the value.

To customize your organization ID, see
[Customize the Tanzu Developer Portal telemetry collection](tap-gui/customize/customize-telemetry.hbs.md).

To enable or deactivate Pendo telemetry for the organization, see
[Enable or deactivate the Pendo telemetry for the organization](opting-out-telemetry.hbs.md#nbl-or-dsbl-pendo-for-org).

> **Note** Pendo telemetry is separate from the VMware CEIP telemetry.
> There is a separate process for opting in or out of the VMware CEIP. For more information, see
> [Opt out of telemetry collection](opting-out-telemetry.hbs.md).

## <a id="opt-in-or-out"></a> Opt in or opt out of Pendo telemetry from Tanzu Developer Portal

After the Pendo telemetry is enabled for the organization, in accordance with VMware policy each user
is prompted to agree to participate in the program or decline.

  ![Screenshot of a Tanzu Developer Portal telemetry prompt.](tap-gui/images/tap-gui-telemetry-prompt.png)

Each individual's preference is stored in Tanzu Developer Portal and can be modified at any
time. To change your preferences, go to **Settings** > **Preferences**.

  ![Screenshot of the Preference tab in Tanzu Developer Portal Settings.](tap-gui/images/tap-gui-telemetry-preferences.png)

## <a id="delete-anon-data"></a> Request to delete your anonymized data

If you no longer want to participate in the program and you want VMware to delete all your anonymized
data, please send an email requesting deletion, with your hashed User ID, to
[tap-pendo@groups.vmware.com](mailto:tap-pendo@groups.vmware.com).

This enables VMware to identify your anonymized data and delete it in accordance with the applicable
regulations.

To find your hashed User ID, go to **Settings** > **Preferences** in Tanzu Developer Portal.