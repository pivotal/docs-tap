# Upgrading Tanzu Application Platform

This document describes how to upgrade Tanzu Application Platform from 1.0 or 1.0.1 to 1.0.2.

You can perform fresh install of Tanzu Application Platform 1.0.2 by following the instructions in [Installing Tanzu Application Platform](install-intro.md).

## <a id='prereqs'></a> Prerequisites

Before you upgrade Tanzu Application Platform:

- For information about installing your Tanzu Application Platform, see [Install your Tanzu Application Platform profile](install.md#install-profile)
- For information about installing or updating the Tanzu CLI and plug-ins, see [Install or update the Tanzu CLI and plug-ins](install-tanzu-cli.md#cli-and-plugin)
- For information on Tanzu Application Platform GUI considerations, see [Tanzu Application Platform GUI Considerations](tap-gui/upgrades.md#considerations)
- Verify all packages are reconciled by running `tanzu package installed list -A`

## <a id="add-new-package-repo"></a> Add new package repository

Follow these steps to add the new package repository:

1. Add the 1.0.2 version of the Tanzu Application Platform package repository by running:

    ```
    tanzu package repository update tanzu-tap-repository \
        --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:1.0.2  \
        --namespace tap-install
    ```

2. Verify you have added the new package repository by running:

    ```
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```

## <a id="upgrade-tap"></a> Perform upgrade of Tanzu Application Platform

### <a id="profile-based-instruct"></a> Upgrade instructions for Profile-based installation

For Tanzu Application Platform that is installed by profile, you can perform the upgrade by running:

>**Note:** Ensure you run the following command in the directory where the `tap-values.yaml` file resides.

```
tanzu package installed update tap -p tap.tanzu.vmware.com -v 1.0.2  --values-file tap-values.yaml -n tap-install
```

### <a id="comp-specific-instruct"></a> Upgrade instructions for component-specific installation

For information about upgrading Tanzu Application Platform GUI, see [upgrading Tanzu Application Platform GUI](tap-gui/upgrades.html).


## <a id="verify"></a> Verify the upgrade

Verify the versions of packages after the upgrade by running:

```
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
