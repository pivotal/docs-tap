# Migrate Tanzu Application Platform Profiles

This document describes how to migrate from one Tanzu Application Platform profile to another.

You can perform fresh install of Tanzu Application Platform 1.1 by following the instructions in [Installing Tanzu Application Platform](install-intro.md).

## <a id='prereqs'></a> Prerequisites

Before you migrate from one Tanzu Application Platform to another:

- For information about installing Tanzu Application Platform, see [Install your Tanzu Application Platform profile](install.md#install-profile)
- For information about installing or updating the Tanzu CLI and plug-ins, see [Install or update the Tanzu CLI and plug-ins](install-tanzu-cli.md#cli-and-plugin)
- For information on Tanzu Application Platform GUI considerations, see [Tanzu Application Platform GUI Considerations](tap-gui/upgrades.md#considerations)
- Verify all packages are reconciled by running `tanzu package installed list -A`
- Note the packages that are included in both the original profile as well as profile being migrated to. If the target profile includes additional packages, those will be added, and additional cluster resources may be needed. However, if the target profile **doesn't include** a particular component, that package will be removed as a result of the migration. If the addition or removal of the packages is of great concern, consider instead adding an additional cluster versus migrating.

## <a id="add-new-package-repo"></a> Add new package repository

Follow these steps to add the new package repository:

1. Add the 1.1.0 version of the Tanzu Application Platform package repository by running:

    ```
    tanzu package repository update tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:1.1.0  \
        --namespace tap-install
    ```

2. Verify you have added the new package repository by running:

    ```
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```
## <a id="edit-profile-values"></a> Edit the tap-values.yaml configuration file that was used during installation

During the Tanzu Application Platform installation, a configuration file was built that contains all the necessary configuration vaules related to the Tanzu Application Platform cluster. We will need to edit the `profile` key in this file (usually saved as `tap-values.yaml`) in order to change the desired profile:

```yaml
profile: PROFILE-NAME
```
Where:
- `PROFILE-NAME` Is the desired target profile. Review the documentation on profiles to determine the best fit.

## <a id="perform-migration"></a> Perform migration of Tanzu Application Platform profile

>**Note:** This step will execute the actual migration that will result in the addition or removal of components based on the selected profile. Consideration should be given to backup any data that may be lost as part of this operation.

To complete the Tanzu Application Platform profile migration, perform the following:

```
tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.1.0  --values-file tap-values.yaml -n tap-install
```


