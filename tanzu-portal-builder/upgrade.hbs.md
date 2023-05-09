# Upgrade Tanzu Portal Builder

This topic describes how to upgrade Tanzu Portal Builder outside of a Tanzu Application Platform
profile installation. If you installed Tanzu Application Platform through a profile, see
[Upgrading Tanzu Application Platform](../upgrading.hbs.md) instead.

## <a id="considerations"></a> Considerations

[placeholder]

## <a id="upgrade-profile"></a> Upgrade within a Tanzu Application Platform profile

If you installed Tanzu Portal Builder as part of a Tanzu Application Platform profile,
see [Upgrading Tanzu Application Platform](../upgrading.hbs.md).

## <a id="upgrade-component"></a> Upgrade Tanzu Portal Builder outside a Tanzu Application Platform profile

These steps apply to upgrading Tanzu Portal Builder separately instead of as part of a
Tanzu Application Platform profile.

To upgrade Tanzu Portal Builder outside of a Tanzu Application Platform profile:

1. Ensure that your repository has access to the new version of the package by running:

    ```console
    tanzu package available list tanzu-portal-builder.tanzu.vmware.com -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available list tanzu-portal-builder.tanzu.vmware.com -n tap-install
    - Retrieving package versions for tanzu-portal-builder.tanzu.vmware.com...
      NAME                      VERSION  RELEASED-AT
      tanzu-portal-builder.tanzu.vmware.com  1.0.1    2023-12-22 17:45:51 +0000 UTC
      tanzu-portal-builder.tanzu.vmware.com  1.0.2    2024-01-25 01:57:19 +0000 UTC
    ```

2. Use the targeted package update version to perform the package upgrade by running:

    ```console
    tanzu package installed update tanzu-portal-builder -p tanzu-portal-builder.tanzu.vmware.com -v \
    VERSION  --values-file TANZU-PORTAL-BUILDER-VALUES.yaml -n tap-install
    ```

    Where:

    - `VERSION` is the target version of Tanzu Application Platform GUI that you want.
    - `TANZU-PORTAL-BUILDER-VALUES` is the name of the configuration values file that contains the
      configuration used when you installed Tanzu Portal Builder.

3. Verify that you upgraded your application by running:

    ```console
    tanzu package installed get tanzu-portal-builder -n tap-install
    ```
