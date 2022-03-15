# Migrate Tanzu Application Platform profiles

This document describes how to migrate from one Tanzu Application Platform profile to another.

You can install Tanzu Application Platform by following the instructions in [Installing Tanzu Application Platform](install-intro.md).

## <a id='prereqs'></a> Prerequisites

Before you migrate from one Tanzu Application Platform to another ensure you have done the following:

- Installed Tanzu Application Platform. See [Install your Tanzu Application Platform profile](install.md#install-profile)
- Installed or updated the Tanzu CLI and plug-ins. See [Install or update the Tanzu CLI and plug-ins](install-tanzu-cli.md#cli-and-plugin)
If you installed Tanzu Application Platform GUI verify the considerations. See [Tanzu Application Platform GUI Considerations](tap-gui/upgrades.md#considerations)
- Verify all packages are reconciled by running `tanzu package installed list -A`
- Note which packages are included in the original profile and the profile migrated to. If the profile you are migrating to includes additional packages, those will be added and additional cluster resources may be needed. If the profile migarted to doesn't include a component, the package is removed. If you do not want to add or remove a packages, consider adding an additional cluster instead of migrating.

## <a id="add-new-package-repo"></a> Add new package repository

Follow these steps to add the new package repository:

1. Add the latest version of the Tanzu Application Platform package repository by running:

    ```
    tanzu package repository update tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:TAP-VERSION  \
        --namespace tap-install
    ```

    Where `TAP-VERSION` is your Tanzu Application Platform version. For example, `1.1.0`.

2. Verify you have added the new package repository by running:

    ```
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```
## <a id="edit-profile-values"></a> Edit the tap-values.yaml configuration file that was used during installation

During the Tanzu Application Platform installation, a configuration file is built that contains the necessary configuration values related to the Tanzu Application Platform cluster. [See Installing the Tanzu Application Platform package and profiles](install.md#install-profile). To change the profile, edit the `profile` key in this file, usually saved as `tap-values.yaml` by running:

```yaml
profile: PROFILE-NAME
```
Where:
- `PROFILE-NAME` is the desired target profile. Review the documentation on profiles to determine the best fit.

## <a id="perform-migration"></a> Perform migration of Tanzu Application Platform profile

>**Note:** This step will execute the actual migration that will result in the addition or removal of components based on the selected profile. Consideration should be given to backup any data that may be lost as part of this operation.

To complete the Tanzu Application Platform profile migration, do the following:

```
tanzu package installed update tap -p tap.tanzu.vmware.com -v TAP-VERSION  --values-file tap-values.yaml -n tap-install
```

Where `TAP-VERSION` is your Tanzu Application Platform version. For example, `1.1.0`.
