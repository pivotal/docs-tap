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

Follow these steps to update to the new package repository:

1. Relocate the latest version of TAP images which you want to update with the Carvel tool imgpkg by following the steps provided in [document](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-install.html#relocate-images-to-a-registry-0) from Step 1 - Step 4.

    ```console
    tanzu package repository update tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:VERSION  \
        --namespace tap-install
    ```
   Where `VERSION` is the target revision of Tanzu Application Platform you are migrating to.
```Note: Make sure to Update the export TAP_VERSION=VERSION-NUMBER which you want to update to```

2. Add the target version of the Tanzu Application Platform package repository by running:

    - If Cluster Essentials 1.2 and above installed:

        ```console
        tanzu package repository add tanzu-tap-repository \
        --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tap-packages:$TAP_VERSION \
        --namespace tap-install
        ```

        Where `VERSION` is the target revision of Tanzu Application Platform you are migrating to.

    - If Cluster Essentials 1.1 and 1.0 installed:

        ```console
       tanzu package repository update tanzu-tap-repository \
        --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tap-packages:$TAP_VERSION \
        --namespace tap-install
        ```

       Where $TAP_VERSION is the target revision of Tanzu Application Platform you are updating to.For example, 1.3.0

        >**Note:** If you are using Cluster Essentials 1.0 or 1.1, expect to see the installed Tanzu Application Platform packages in a temporary “Reconcile Failed” state, following a “Package not found” warning. These warnings will disappear after you upgrade the installed Tanzu Application Platform packages to version 1.2.0.

2. Verify you have added the new package repository by running:

    ```console
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```

## <a id="upgrade-tap"></a> Perform upgrade of Tanzu Application Platform

### <a id="profile-based-instruct"></a> Upgrade instructions for Profile-based installation

>**Important:** Before performing the upgrade, ensure `descriptor_name` is either unset or set to `full`, or `lite` in the [tap-values.yaml](install.md#full-profile).

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

Your output is similar, but probably not identical, to the following example output:

```console
- Retrieving installed packages...
  NAME                      PACKAGE-NAME                                        PACKAGE-VERSION  STATUS
  accelerator               accelerator.apps.tanzu.vmware.com                   1.0.2            Reconcile succeeded
  api-portal                api-portal.tanzu.vmware.com                         1.0.9            Reconcile succeeded
  appliveview               run.appliveview.tanzu.vmware.com                    1.0.2            Reconcile succeeded
  appliveview-conventions   build.appliveview.tanzu.vmware.com                  1.0.2            Reconcile succeeded
  buildservice              buildservice.tanzu.vmware.com                       1.4.3            Reconcile succeeded
  cartographer              cartographer.tanzu.vmware.com                       0.2.2            Reconcile succeeded
  cert-manager              cert-manager.tanzu.vmware.com                       1.5.3+tap.1      Reconcile succeeded
  cnrs                      cnrs.tanzu.vmware.com                               1.1.1            Reconcile succeeded
  contour                   contour.tanzu.vmware.com                            1.18.2+tap.1     Reconcile succeeded
  conventions-controller    controller.conventions.apps.tanzu.vmware.com        0.5.1            Reconcile succeeded
  developer-conventions     developer-conventions.tanzu.vmware.com              0.5.0            Reconcile succeeded
  fluxcd-source-controller  fluxcd.source.controller.tanzu.vmware.com           0.16.3           Reconcile succeeded
  grype                     grype.scanning.apps.tanzu.vmware.com                1.0.1            Reconcile succeeded
  image-policy-webhook      image-policy-webhook.signing.apps.tanzu.vmware.com  1.0.2            Reconcile succeeded
  learningcenter            learningcenter.tanzu.vmware.com                     0.1.1            Reconcile succeeded
  learningcenter-workshops  workshops.learningcenter.tanzu.vmware.com           0.1.1            Reconcile succeeded
  metadata-store            metadata-store.apps.tanzu.vmware.com                1.0.2            Reconcile succeeded
  ootb-delivery-basic       ootb-delivery-basic.tanzu.vmware.com                0.6.1            Reconcile succeeded
  ootb-supply-chain-basic   ootb-supply-chain-basic.tanzu.vmware.com            0.6.1            Reconcile succeeded
  ootb-templates            ootb-templates.tanzu.vmware.com                     0.6.1            Reconcile succeeded
  scanning                  scanning.apps.tanzu.vmware.com                      1.0.1            Reconcile succeeded
  service-bindings          service-bindings.labs.vmware.com                    0.6.1            Reconcile succeeded
  services-toolkit          services-toolkit.tanzu.vmware.com                   0.5.1            Reconcile succeeded
  source-controller         controller.source.apps.tanzu.vmware.com             0.2.1            Reconcile succeeded
  spring-boot-conventions   spring-boot-conventions.tanzu.vmware.com            0.3.0            Reconcile succeeded
  tap                       tap.tanzu.vmware.com                                1.0.2            Reconcile succeeded
  tap-gui                   tap-gui.tanzu.vmware.com                            1.0.2            Reconcile succeeded
  tap-telemetry             tap-telemetry.tanzu.vmware.com                      0.1.4            Reconcile succeeded
  tekton-pipelines          tekton.tanzu.vmware.com                             0.30.1           Reconcile succeeded
```
