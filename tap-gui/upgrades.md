# Upgrade Tanzu Application Platform GUI

This page outlines the necessary considerations to take into account when upgrading
Tanzu Application Platform GUI.


## <a id="considerations"></a> Considerations

As part the upgrade, the Tanzu Application Platform updates its container with the new version.

As a result, if you have installed Tanzu Application Platform GUI without the support of a backing
[database](database.html), you lose your in-memory data for any manual component registrations
when the container restarts.

While the update is pulling the new pod from the registry, users might experience a short UI
interruption and might need to re-authenticate because in-memory session data is rebuilt.

You need the values file that you used when installing Tanzu Application Platform GUI.


## <a id="upgrade-profile"></a> Upgrade by using a Profile

If you've installed Tanzu Application Platform GUI as part of a Tanzu Application Platform Profile,
you must upgrade the entire profile rather than follow these steps for an individual component.


## <a id="upgrade-component"></a> Upgrade Tanzu Application Platform GUI individually

To upgrade only the Upgrade Tanzu Application Platform GUI:

> **Note:** These steps only apply to installing Tanzu Application Platform GUI individually as
opposed to part of a profile.

1. Ensure your repository has access to the new version of the package by running:

    ```bash
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
    tanzu package installed update tap-gui -p tap-gui.tanzu.vmware.com -v VERSION  --values-file TAP-GUI-VALUES.yaml -n tap-install
    ```

    Where:

    - `VERSION` is the desired target version of Tanzu Application Platform GUI.
    - `TAP-GUI-VALUES` is the configuration values file that contains the configuration used when you installed Tanzu Application Platform GUI.

3. Verify your application was successfully upgraded:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```
