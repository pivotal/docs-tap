# Upgrading Tanzu Application Platform

This document describes how to upgrade Tanzu Application Platform.

You can perform fresh install of Tanzu Application Platform by following the instructions in [Installing Tanzu Application Platform](install-intro.md).

## <a id='prereqs'></a> Prerequisites

Before you upgrade Tanzu Application Platform:

- Verify that you meet all the [prerequisites](prerequisites.md) of the target Tanzu Application Platform version. If the target Tanzu Application Platform version does not support your existing Kubernetes version, VMware recommends upgrading to a supported version before proceeding with the upgrade.
- For information about installing your Tanzu Application Platform, see [Install your Tanzu Application Platform profile](install.md#install-profile)
- For information about installing or updating the Tanzu CLI and plug-ins, see [Install or update the Tanzu CLI and plug-ins](install-tanzu-cli.md#cli-and-plugin)
- For information on Tanzu Application Platform GUI considerations, see [Tanzu Application Platform GUI Considerations](tap-gui/upgrades.md#considerations)
- Verify all packages are reconciled by running `tanzu package installed list -A`

## <a id="add-new-package-repo"></a> Add new package repository

Follow these steps to add the new package repository:

1. Add the target version of the Tanzu Application Platform package repository by running:

    ```console
    tanzu package repository update tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:VERSION  \
        --namespace tap-install
    ```
   Where `VERSION` is the target revision of Tanzu Application Platform you are migrating to.

2. Verify you have added the new package repository by running:

    ```console
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```

## <a id="upgrade-tap"></a> Perform upgrade of Tanzu Application Platform

### <a id="profile-based-instruct"></a> Upgrade instructions for Profile-based installation

>**Important:** Before performing the upgrade, ensure `descriptor_name` is either unset or set to `full`, or `lite` in the [`tap-values.yaml`](install.md#full-profile).

For Tanzu Application Platform that is installed by profile, you can perform the upgrade by running:

>**Note:** Ensure you run the following command in the directory where the `tap-values.yaml` file resides.

```console
tanzu package installed update tap -p tap.tanzu.vmware.com -v VERSION  --values-file tap-values.yaml -n tap-install
```

   Where `VERSION` is the target revision of Tanzu Application Platform you are migrating to.

### <a id="comp-specific-instruct"></a> Upgrade instructions for component-specific installation

For information about upgrading Tanzu Application Platform GUI, see [upgrading Tanzu Application Platform GUI](tap-gui/upgrades.html).

## <a id="verify"></a> Verify the upgrade

Verify the versions of packages after the upgrade by running:

```console
tanzu package installed list --namespace tap-install
```
