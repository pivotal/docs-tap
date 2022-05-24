# Customizing branding

This topic describes how to customize the branding within the Tanzu Application Platform GUI portal.


## <a id="overview"></a> Overview

You can customize the logo and the name displayed in the top banner in the
Tanzu Application Platform GUI portal.  
By default, the portal displays the VMware Tanzu logo and **Tanzu Application Platform** as the name.

![Screenshot displaying the default VMware Tanzu branding within the Tanzu Application Platform GUI portal](../images/standard-branding.png)


## <a id="customizing"></a> Customize Branding

To customize the branding in your portal:

1. Provide additional configuration parameters in your configuration values file.
If you installed Tanzu Application Platform GUI as part of a Tanzu Application Platform profile,
the file is `tap-values-file.yaml`.
If you installed Tanzu Application Platform GUI separately, the file is `tap-gui-values.yaml`.
Here is an example configuration snippet for `tap-values.yaml`:

    ```yaml
    tap_gui:
      app_config:
        customize:
          custom_logo: 'BASE-64-IMAGE'
          custom_name: 'PORTAL-NAME'
    ```

    Where:

    - `BASE-64-IMAGE` is the image encoded in base64. VMware recommends a 512-pixel by 512-pixel PNG image with a transparent background.
    - `PORTAL-NAME` is the name of your portal.

1. Reinstall your Tanzu Application Platform GUI package by following steps in
[Upgrading Tanzu Application Platform](../../upgrading.html).

After the updated values configuration file is applied in Tanzu Application Platform GUI,
you see the customized version of your portal.

If there is an error in `BASE-64-IMAGE` or `PORTAL-NAME`, Tanzu Application Platform GUI reverts to
the original branding template.

![Screenshot displaying the custom branding within the Tanzu Application Platform GUI portal](../images/customized-branding.png)
