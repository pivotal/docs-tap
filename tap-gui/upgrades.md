# Upgrading Tanzu Application Platform GUI

This page will outline the necessary considerations to take into account when upgrading Tanzu Application Platform GUI.

## <a id="considerations"></a>Considerations
* As part of the upgrade process the Tanzu Application Platform's container will be updated with the new version. As such, if you have installed without the support of a backing <a id="./database.md>">database</a> upon restart of the container you will lose your in-memory data for any manual component registrations you performed.
* While the update is pulling the new pod from the registry, users may experience a short UI interuption as well as may need to re-authnticate as in-memory session data is rebuilt.
* You will need the values-file that you used when you installed Tanzu Application Platform GUI.


## <a id="upgrade-profile"></a> Upgrade via Profile

If you've installed Tanzu Application Platform GUI as part of a Tanzu Application Platform Profile, you should make sure to upgrade the entire profile rather than the steps for an individual component listed below.

## <a id="upgrade-component"></a> Upgrade Tanzu Application Platform GUI Individually

>**Note:** These steps are only for when you've installed Tanzu Application Platform GUI individually as opposed to part of a profile.

1. Make sure your repository has access to the new version of the package:
```bash
tanzu package available list tap-gui.tanzu.vmware.com -n tap-install
```

For example:
```
$ tanzu package available list tap-gui.tanzu.vmware.com -n tap-install
- Retrieving package versions for tap-gui.tanzu.vmware.com...
  NAME                      VERSION  RELEASED-AT
  tap-gui.tanzu.vmware.com  1.0.1    2021-12-22 17:45:51 +0000 UTC
  tap-gui.tanzu.vmware.com  1.0.2    2022-01-25 01:57:19 +0000 UTC
   ```
2. Perform the package upgrade using the above using your targetted package update version:
```
tanzu package installed update tap -p tap-gui.tanzu.vmware.com -v VERSION  --values-file TAP_GUI_VALUES.yaml -n tap-install
```
Where:
 - VERSION is the desired target version of Tanzu Application Platform GUI
 - TAP_GUI_VAULES.yaml is the configuration values file that contains the configuration used when you installed Tanzu Application Platform GUI initially

3. Check that your application has been successfully upgraded:
```
tanzu package installed get tap-gui -n tap-install
```