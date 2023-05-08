# Upgrade your Tanzu Application Platform

This document tells you how to upgrade your Tanzu Application Platform (commonly known as TAP).

You can perform a fresh install of Tanzu Application Platform by following the instructions in [Installing Tanzu Application Platform](install-intro.md).

## <a id='prereqs'></a> Prerequisites

Before you upgrade Tanzu Application Platform:

- Verify that you meet all the [prerequisites](prerequisites.md) of the target Tanzu Application Platform version. If the target Tanzu Application Platform version does not support your existing Kubernetes version, VMware recommends upgrading to a supported version before proceeding with the upgrade.
- For information about installing your Tanzu Application Platform, see [Install your Tanzu Application Platform profile](install-online/profile.hbs.md#install-profile).
- Ensure that Tanzu CLI is updated to the version recommended by the target Tanzu Application Platform version. For information about installing or updating the Tanzu CLI and plug-ins, see [Install or update the Tanzu CLI and plug-ins](install-tanzu-cli.hbs.md#cli-and-plugin).
- For information about Tanzu Application Platform GUI considerations, see [Tanzu Application Platform GUI Considerations](tap-gui/upgrades.md#considerations).
- Verify all packages are reconciled by running `tanzu package installed list -A`.
- To avoid the temporary warning state that is described in [Update the new package repository](#add-new-package-repo), upgrade to Cluster Essentials v{{ vars.url_version }}. See [Cluster Essentials documentation](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#upgrade) for more information about the upgrade procedures.

## <a id="add-new-package-repo"></a> Update the new package repository

Follow these steps to update the new package repository:

1. Relocate the latest version of Tanzu Application Platform images by following step 1 through step 6 in [Relocate images to a registry](install-online/profile.hbs.md#add-tap-package-repo).

    >**Important** Make sure to update the `TAP_VERSION` to the target version of Tanzu Application Platform you are migrating to. For example, `{{ vars.tap_version }}`.

1. Add the target version of the Tanzu Application Platform package repository by running:

    Cluster Essentials 1.2 or above
    :
    ```console
    tanzu package repository add tanzu-tap-repository \
    --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages:$TAP_VERSION \
    --namespace tap-install
    ```

    Cluster Essentials 1.1 or 1.0
    :
    ```console
    tanzu package repository update tanzu-tap-repository \
    --url ${INSTALL_REGISTRY_HOSTNAME}/TARGET-REPOSITORY/tap-packages:${TAP_VERSION} \
    --namespace tap-install
    ```
    Expect to see the installed Tanzu Application Platform packages in a temporary “Reconcile Failed” state, following a “Package not found” warning. These warnings will disappear after you upgrade the installed Tanzu Application Platform packages to version 1.2.0.

1. Verify you have added the new package repository by running:

    ```console
    tanzu package repository get TAP-REPO-NAME --namespace tap-install
    ```

    Where `TAP-REPO-NAME` is the package repository name. It must match with either `NEW-TANZU-TAP-REPOSITORY` or `tanzu-tap-repository` in the previous step.

## <a id="upgrade-tap"></a> Perform the upgrade of Tanzu Application Platform

The following sections describe how to upgrade in different scenarios.

### <a id="profile-based-instruct"></a> Upgrade instructions for Profile-based installation

The following changes affect the upgrade procedures:

- **Keyless support deactivated by default**

    In Tanzu Application Platform v1.4.0, keyless support is deactivated by default. For more information, see [Install Supply Chain Security Tools - Policy Controller](scst-policy/install-scst-policy.hbs.md).

    To support the keyless authorities in `ClusterImagePolicy`, Policy Controller no longer initializes TUF by default. To continue using keyless authorities, you must set the `policy.tuf_enabled` field to `true` in the `tap-values.yaml` file during the upgrade process.

    By default, the public official Sigstore "The Update Framework (TUF) server" is used. You can use an alternative Sigstore Stack by setting `policy.tuf_mirror` and `policy.tuf_root`.

- **Image Policy Webhook no longer in use**

    Tanzu Application Platform v1.4.0 removes Image Policy Webhook. If you use Image Policy Webhook in the previous version of Tanzu Application Platform, you must migrate the `ClusterImagePolicy` resource
    from Image Policy Webhook to Policy Controller. For more information, see [Migration From Supply Chain Security Tools - Sign](scst-policy/migration.hbs.md).

- **CVE results require a read-write service account**

    Tanzu Application Platform v1.3.0 uses a read-only service account. In Tanzu Application Platform v1.4.0, enabling CVE results for the Supply Chain Choreographer and Security Analysis GUI plug-ins requires a read-write service account. For more information, see [Enable CVE scan results](tap-gui/plugins/scc-tap-gui.hbs.md#scan).

If you installed Tanzu Application Platform by using a profile, you can perform the upgrade by running the following command in the directory where the `tap-values.yaml` file resides:

```console
tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION}  --values-file tap-values.yaml -n tap-install
```

When upgrading to Tanzu Application Platform v1.2, Tanzu Build Service image resources automatically run a build that fails due to a missing dependency.
This error does not persist and any subsequent builds resolve this error.
You can wait for the next build of the workloads that new source code changes trigger.
If you do not want to wait for subsequent builds to run automatically, follow the instructions in
[Builds fail after upgrading to Tanzu Application Platform v1.2](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-tanzu-build-service-troubleshooting.html#builds-fail-after-upgrading-to-tanzu-application-platform).

### <a id="full-profile-upgrade-tbs-deps"></a> Upgrade the full dependencies package

If you installed the [full dependencies package](install-online/profile.hbs.md#tap-install-full-deps),
you can upgrade the package by following these steps:

1. After upgrading Tanzu Application Platform, retrieve the latest version of the
   Tanzu Build Service package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

1. Relocate the Tanzu Build Service `full` dependencies package repository by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:VERSION \
    --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tbs-full-deps
    ```

    Where `VERSION` is the version of the Tanzu Build Service package you retrieved in the previous step.

1. Update the Tanzu Build Service  `full` dependencies package repository by running:

    ```console
    tanzu package repository add tbs-full-deps-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tbs-full-deps:VERSION \
      --namespace tap-install
    ```

1. Update the `full` dependencies package by running:

    ```console
    tanzu package installed update full-tbs-deps -p full-tbs-deps.tanzu.vmware.com -v VERSION -n tap-install
    ```

### <a id="upgrade-order"></a> Multicluster upgrade order

Upgrading a [multicluster deployment](multicluster/installing-multicluster.hbs.md) requires updating multiple clusters with different profiles.
If upgrades are not performed at the exact same time, different clusters have different versions of profiles installed temporarily.
This might cause a temporary API mismatch that leads to errors.
Those errors eventually disappear when the versions are consistent across all clusters.

To reduce the likelihood of temporary failures, follow these steps to upgrade your multicluster deployment:

1. Upgrade the view-profile cluster.
1. Upgrade the remaining clusters in any order.

### <a id="comp-specific-instruct"></a> Upgrade instructions for component-specific installation

For information about upgrading Tanzu Application Platform GUI, see [Upgrade Tanzu Application Platform GUI](tap-gui/upgrades.html).
For information about upgrading Supply Chain Security Tools - Scan, see [Upgrade Supply Chain Security Tools - Scan](scst-scan/upgrading.md).

## <a id="verify"></a> Verify the upgrade

Verify the versions of packages after the upgrade by running:

```console
tanzu package installed list --namespace tap-install
```

Your output is similar, but probably not identical, to the following example output:

```console
- Retrieving installed packages...
  NAME                                PACKAGE-NAME                                         PACKAGE-VERSION  STATUS
  accelerator                         accelerator.apps.tanzu.vmware.com                    1.3.0            Reconcile succeeded
  api-auto-registration               apis.apps.tanzu.vmware.com                           0.1.1            Reconcile succeeded
  api-portal                          api-portal.tanzu.vmware.com                          1.2.2            Reconcile succeeded
  appliveview                         backend.appliveview.tanzu.vmware.com                 1.3.0            Reconcile succeeded
  appliveview-connector               connector.appliveview.tanzu.vmware.com               1.3.0            Reconcile succeeded
  appliveview-conventions             conventions.appliveview.tanzu.vmware.com             1.3.0            Reconcile succeeded
  appsso                              sso.apps.tanzu.vmware.com                            2.0.0            Reconcile succeeded
  buildservice                        buildservice.tanzu.vmware.com                        1.7.1            Reconcile succeeded
  cartographer                        cartographer.tanzu.vmware.com                        0.5.3            Reconcile succeeded
  cert-manager                        cert-manager.tanzu.vmware.com                        1.7.2+tap.1      Reconcile succeeded
  cnrs                                cnrs.tanzu.vmware.com                                2.0.1            Reconcile succeeded
  contour                             contour.tanzu.vmware.com                             1.22.0+tap.3     Reconcile succeeded
  conventions-controller              controller.conventions.apps.tanzu.vmware.com         0.7.1            Reconcile succeeded
  developer-conventions               developer-conventions.tanzu.vmware.com               0.8.0            Reconcile succeeded
  eventing                            eventing.tanzu.vmware.com                            2.0.1            Reconcile succeeded
  fluxcd-source-controller            fluxcd.source.controller.tanzu.vmware.com            0.27.0+tap.1     Reconcile succeeded
  grype                               grype.scanning.apps.tanzu.vmware.com                 1.3.0            Reconcile succeeded
  image-policy-webhook                image-policy-webhook.signing.apps.tanzu.vmware.com   1.1.7            Reconcile succeeded
  learningcenter                      learningcenter.tanzu.vmware.com                      0.2.3            Reconcile succeeded
  learningcenter-workshops            workshops.learningcenter.tanzu.vmware.com            0.2.2            Reconcile succeeded
  metadata-store                      metadata-store.apps.tanzu.vmware.com                 1.3.3            Reconcile succeeded
  ootb-delivery-basic                 ootb-delivery-basic.tanzu.vmware.com                 0.10.2           Reconcile succeeded
  ootb-supply-chain-testing-scanning  ootb-supply-chain-testing-scanning.tanzu.vmware.com  0.10.2           Reconcile succeeded
  ootb-templates                      ootb-templates.tanzu.vmware.com                      0.10.2           Reconcile succeeded
  policy-controller                   policy.apps.tanzu.vmware.com                         1.1.1            Reconcile succeeded
  scanning                            scanning.apps.tanzu.vmware.com                       1.3.0            Reconcile succeeded
  service-bindings                    service-bindings.labs.vmware.com                     0.8.0            Reconcile succeeded
  services-toolkit                    services-toolkit.tanzu.vmware.com                    0.8.0            Reconcile succeeded
  source-controller                   controller.source.apps.tanzu.vmware.com              0.5.0            Reconcile succeeded
  spring-boot-conventions             spring-boot-conventions.tanzu.vmware.com             0.5.0            Reconcile succeeded
  tap                                 tap.tanzu.vmware.com                                 1.3.0            Reconcile succeeded
  tap-auth                            tap-auth.tanzu.vmware.com                            1.1.0            Reconcile succeeded
  tap-gui                             tap-gui.tanzu.vmware.com                             1.3.0            Reconcile succeeded
  tap-telemetry                       tap-telemetry.tanzu.vmware.com                       0.3.1            Reconcile succeeded
  tekton-pipelines                    tekton.tanzu.vmware.com                              0.39.0+tap.2     Reconcile succeeded
```
