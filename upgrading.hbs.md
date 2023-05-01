# Upgrading Tanzu Application Platform

This document describes how to upgrade Tanzu Application Platform.

You can perform a fresh install of Tanzu Application Platform by following the instructions in [Installing Tanzu Application Platform](install-intro.md).

## <a id='prereqs'></a> Prerequisites

Before you upgrade Tanzu Application Platform:

- Verify that you meet all the [prerequisites](prerequisites.md) of the target Tanzu Application Platform version. If the target Tanzu Application Platform version does not support your existing Kubernetes version, VMware recommends upgrading to a supported version before proceeding with the upgrade.
- For information about installing your Tanzu Application Platform, see [Install your Tanzu Application Platform profile](install-online/profile.hbs.md#install-profile).
- For information about installing or updating the Tanzu CLI and plug-ins, see [Install or update the Tanzu CLI and plug-ins](install-tanzu-cli.hbs.md#cli-and-plugin).
- For information on Tanzu Application Platform GUI considerations, see [Tanzu Application Platform GUI Considerations](tap-gui/upgrades.md#considerations).
- Verify all packages are reconciled by running `tanzu package installed list -A`.
- To avoid the temporary warning state that is described in [Update the new package repository](#add-new-package-repo), upgrade to Cluster Essentials v{{ vars.url_version }}. See [Cluster Essentials documentation](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/GUID-deploy.html#upgrade) for more information about the upgrade procedures.

## <a id="add-new-package-repo"></a> Update the new package repository

Follow these steps to update the new package repository:

1. Relocate the latest version of Tanzu Application Platform images by following step 1 through step 4 in [Relocate images to a registry](install-online/profile.hbs.md#add-tap-package-repo).

    >**Note:** Make sure to update the `VERSION-NUMBER` to the target version of Tanzu Application Platform you are migrating to. For example, `{{ vars.tap_version }}`. 

1. Add the target version of the Tanzu Application Platform package repository:

    - If you are using Cluster Essentials 1.2 or above, run:

        ```console
        tanzu package repository add tanzu-tap-repository \
        --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tap-packages:${TAP_VERSION} \
        --namespace tap-install
        ```

    - If you are using Cluster Essentials 1.1 or 1.0, run:

        ```console
       tanzu package repository update tanzu-tap-repository \
        --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tap-packages:${TAP_VERSION} \
        --namespace tap-install
        ```

        >**Note:** If you are using Cluster Essentials 1.0 or 1.1, expect to see the installed Tanzu Application Platform packages in a temporary “Reconcile Failed” state, following a “Package not found” warning. These warnings will disappear after you upgrade the installed Tanzu Application Platform packages to version 1.2.0. 

1. Verify you have added the new package repository by running:

    ```console
    tanzu package repository get tanzu-tap-repository --namespace tap-install
    ```

## <a id="upgrade-tap"></a> Perform the upgrade of Tanzu Application Platform

### <a id="profile-based-instruct"></a> Upgrade instructions for Profile-based installation

For Tanzu Application Platform that is installed by profile, you can perform the upgrade by running:

>**Note:** Ensure you run the following command in the directory where the `tap-values.yaml` file resides.

```console
tanzu package installed update tap -p tap.tanzu.vmware.com -v VERSION  --values-file tap-values.yaml -n tap-install
```

Where `VERSION` is the target revision of Tanzu Application Platform you are migrating to.

>**Note:** When upgrading to Tanzu Application Platform v1.2, Tanzu Build Service image resources automatically
>run a build that fails due to a missing dependency.
>This error does not persist and any subsequent builds will resolve this error.
>You can safely wait for the next build of the workloads, which is triggered by new source code changes.
>If you do not want to wait for subsequent builds to run automatically,
>follow the instructions in the troubleshooting item
>[Builds fail after upgrading to Tanzu Application Platform v1.2](tanzu-build-service/troubleshooting.md#tbs-1-2-breaking-change).

### <a id="comp-specific-instruct"></a> Upgrade instructions for component-specific installation

For information about upgrading Tanzu Application Platform GUI, see [upgrading Tanzu Application Platform GUI](tap-gui/upgrades.html).
For information about upgrading Supply Chain Security Tools - Scan, see [Upgrading Supply Chain Security Tools - Scan](scst-scan/upgrading.md).

## <a id="verify"></a> Verify the upgrade

Verify the versions of packages after the upgrade by running:

```console
tanzu package installed list --namespace tap-install
```

Your output is similar, but probably not identical, to the following example output:

```console
- Retrieving installed packages...
  NAME                                PACKAGE-NAME                                         PACKAGE-VERSION  STATUS
  accelerator                         accelerator.apps.tanzu.vmware.com                    1.2.1            Reconcile succeeded  
  api-portal                          api-portal.tanzu.vmware.com                          1.0.21           Reconcile succeeded  
  appliveview                         backend.appliveview.tanzu.vmware.com                 1.2.0            Reconcile succeeded  
  appliveview-connector               connector.appliveview.tanzu.vmware.com               1.2.0            Reconcile succeeded  
  appliveview-conventions             conventions.appliveview.tanzu.vmware.com             1.2.0            Reconcile succeeded  
  appsso                              sso.apps.tanzu.vmware.com                            1.0.0            Reconcile succeeded  
  buildservice                        buildservice.tanzu.vmware.com                        1.6.0            Reconcile succeeded  
  cartographer                        cartographer.tanzu.vmware.com                        0.4.2            Reconcile succeeded  
  cert-manager                        cert-manager.tanzu.vmware.com                        1.5.3+tap.2      Reconcile succeeded  
  cnrs                                cnrs.tanzu.vmware.com                                1.3.0            Reconcile succeeded  
  contour                             contour.tanzu.vmware.com                             1.18.2+tap.2     Reconcile succeeded  
  conventions-controller              controller.conventions.apps.tanzu.vmware.com         0.7.0            Reconcile succeeded  
  developer-conventions               developer-conventions.tanzu.vmware.com               0.7.0            Reconcile succeeded  
  fluxcd-source-controller            fluxcd.source.controller.tanzu.vmware.com            0.16.4           Reconcile succeeded  
  grype                               grype.scanning.apps.tanzu.vmware.com                 1.2.2            Reconcile succeeded  
  image-policy-webhook                image-policy-webhook.signing.apps.tanzu.vmware.com   1.1.3            Reconcile succeeded  
  learningcenter                      learningcenter.tanzu.vmware.com                      0.2.1            Reconcile succeeded  
  learningcenter-workshops            workshops.learningcenter.tanzu.vmware.com            0.2.1            Reconcile succeeded  
  metadata-store                      metadata-store.apps.tanzu.vmware.com                 1.2.2            Reconcile succeeded  
  ootb-delivery-basic                 ootb-delivery-basic.tanzu.vmware.com                 0.8.0-build.4    Reconcile succeeded  
  ootb-supply-chain-testing-scanning  ootb-supply-chain-testing-scanning.tanzu.vmware.com  0.8.0-build.4    Reconcile succeeded  
  ootb-templates                      ootb-templates.tanzu.vmware.com                      0.8.0-build.4    Reconcile succeeded  
  policy-controller                   policy.apps.tanzu.vmware.com                         1.0.1            Reconcile succeeded  
  scanning                            scanning.apps.tanzu.vmware.com                       1.2.2            Reconcile succeeded  
  service-bindings                    service-bindings.labs.vmware.com                     0.7.2            Reconcile succeeded  
  services-toolkit                    services-toolkit.tanzu.vmware.com                    0.7.1            Reconcile succeeded  
  source-controller                   controller.source.apps.tanzu.vmware.com              0.4.1            Reconcile succeeded  
  spring-boot-conventions             spring-boot-conventions.tanzu.vmware.com             0.4.1            Reconcile succeeded  
  tap                                 tap.tanzu.vmware.com                                 1.2.0            Reconcile succeeded  
  tap-auth                            tap-auth.tanzu.vmware.com                            1.0.1            Reconcile succeeded  
  tap-gui                             tap-gui.tanzu.vmware.com                             1.2.3            Reconcile succeeded  
  tap-telemetry                       tap-telemetry.tanzu.vmware.com                       0.2.0            Reconcile succeeded  
  tekton-pipelines                    tekton.tanzu.vmware.com                              0.33.5           Reconcile succeeded  
```
