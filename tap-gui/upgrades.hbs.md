# Upgrade Tanzu Developer Portal

This topic tells you how to upgrade Tanzu Developer Portal
(formerly called Tanzu Application Platform GUI) outside of a Tanzu Application Platform profile
installation. If you installed Tanzu Application Platform through a profile, see
[Upgrading Tanzu Application Platform](../upgrading.hbs.md) instead.

## <a id="considerations"></a> Considerations

As part of the upgrade, Tanzu Application Platform updates its container with the new version.

As a result, if you installed Tanzu Developer Portal without the support of a backing
[database](database.hbs.md), you lose your in-memory data for any manual component registrations
when the container restarts.
While the update is pulling the new pod from the registry, users might experience a short UI
interruption and might need to re-authenticate because the in-memory session data is rebuilt.

## <a id="upgrade-profile"></a> Upgrade within a Tanzu Application Platform profile

If you installed Tanzu Developer Portal as part of a Tanzu Application Platform profile,
see [Upgrading Tanzu Application Platform](../upgrading.hbs.md).

## <a id="upgrade-component"></a> Upgrade Tanzu Developer Portal individually

These steps only apply to installing Tanzu Developer Portal individually, not as part of a
Tanzu Application Platform profile.

To upgrade Tanzu Developer Portal outside of a Tanzu Application Platform profile:

1. Ensure that your repository has access to the new version of the package by running:

    ```console
    tanzu package available list tap-gui.tanzu.vmware.com -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available list tap-gui.tanzu.vmware.com -n tap-install
    - Retrieving package versions for tap-gui.tanzu.vmware.com...
      NAME                      VERSION  RELEASED-AT
      tap-gui.tanzu.vmware.com  1.0.1    2021-12-22 17:45:51 +0000 UTC
      tap-gui.tanzu.vmware.com  1.0.2    2022-01-25 01:57:19 +0000 UTC
    ```

2. Perform the package upgrade by using the targeted package update version. Run:

    ```console
    tanzu package installed update tap-gui -p tap-gui.tanzu.vmware.com -v VERSION  --values-file \
    TAP-GUI-VALUES.yaml -n tap-install
    ```

    Where:

    - `VERSION` is the target version of Tanzu Developer Portal that you want.
    - `TAP-GUI-VALUES` is the configuration values file that contains the configuration used when you
      installed Tanzu Developer Portal.

3. Verify that you upgraded your application by running:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```
