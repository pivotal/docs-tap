# Join or leave the Customer Experience Improvement Programs for Tanzu Application Platform

<!-- This topic must be accessible from https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/tap-portal-telemetry.html -->

Tanzu Application Platform participates in the VMware original Customer Experience Improvement Program
(CEIP) and the Pendo Customer Experience Program (Pendo CEIP) for supported services.

You can separately join or leave the VMware original Customer Experience Improvement Program (CEIP)
and the Pendo Customer Experience Program (Pendo CEIP). Each program collects slightly different
types of customer interaction data.

Pendo CEIP is an integrated third-party tool that collects user activities and provides analytics to
Tanzu Application Platform product development.
The Pendo CEIP collects workflow data based on your interaction with the user interface.
This information helps VMware designers and engineers develop data-driven improvements to the usability
of products and services.

## <a id="join-or-leave-pendo"></a> Join or leave the Pendo CEIP

See the following procedures for joining or leaving the Pendo CEIP.

### <a id="nbl-or-dsbl-pendo-for-org"></a> Enable or deactivate the Pendo CEIP for the organization

To enable the program for the organization, add the following parameters to your `tap-values.yaml`
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

### <a id="opt-in-or-out"></a> Opt in or opt out of the Pendo CEIP from Tanzu Application Platform GUI

After the Pendo CEIP is enabled for the organization, in accordance with VMware policy each user is
prompted to agree to participate in the program or decline.

  ![Screenshot of a Tanzu Application Platform GUI telemetry prompt.](tap-gui/images/tap-gui-telemetry-prompt.png)

Each individual's preference is stored in Tanzu Application Platform GUI and can be modified at any
time. To change your preferences, go to **Settings** > **Preferences**.

  ![Screenshot of the Preference tab in Tanzu Application Platform GUI Settings.](tap-gui/images/tap-gui-telemetry-preferences.png)

### <a id="delete-anon-data"></a> Request to delete your anonymized data

If you no longer want to participate in the program and you want VMware to delete all your anonymized
data, please send an email requesting deletion, with your hashed User ID, to [tap-pendo@groups.vmware.com](mailto:tap-pendo@groups.vmware.com).

This enables VMware to identify your anonymized data and delete it in accordance with the applicable
regulations.

To find your hashed User ID, go to **Settings** > **Preferences** in Tanzu Application Platform GUI.
