# Upgrade your Tanzu Application Platform by using GitOps

This document tells you how to upgrade your Tanzu Application Platform
(commonly known as TAP) by using GitOps.

>**Caution** Tanzu Application Platform (GitOps) is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

You can perform a fresh install of Tanzu Application Platform by following the
instructions in [Installing Tanzu Application Platform](intro.hbs.md).

## <a id='prereqs'></a> Prerequisites

Before you upgrade your Tanzu Application Platform:

- Verify that you meet all the [prerequisites](../prerequisites.hbs.md) of the target Tanzu Application Platform version. If the target Tanzu Application Platform version does not support your existing Kubernetes version, VMware recommends upgrading to a supported version before proceeding with the upgrade.
- For information about installing your Tanzu Application Platform, see [Install Tanzu Application Platform through Gitops with Secrets OPerationS (SOPS)](sops.hbs.md) or [Install Tanzu Application Platform through GitOps with External Secrets Operator (ESO)](eso.hbs.md).
- For information about Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)
  considerations, see [Tanzu Developer Portal Considerations](../tap-gui/upgrades.hbs.md#considerations).
- Verify all packages are reconciled by running `kubectl get packageinstall --namespace tap-install`.

## <a id="relocate-images"></a> Relocate Tanzu Application Platform images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to your own container image registry before attempting installation. If you don't relocate the images, Tanzu Application Platform depends on
VMware Tanzu Network for continued operation, and VMware Tanzu Network offers no uptime guarantees.
The option to skip relocation is documented for evaluation and proof-of-concept only.

The supported registries are Harbor, Azure Container Registry, Google Container Registry,
and Quay.io.
See the following the documentation for instructions on setting up a registry:

- [Harbor documentation](https://goharbor.io/docs/2.5.0/)
- [Google Container Registry documentation](https://cloud.google.com/container-registry/docs)
- [Quay.io documentation](https://docs.projectquay.io/welcome.html)

To relocate images from the VMware Tanzu Network registry to your registry:

1. Set up environment variables for installation use by running:

    ```console
    export IMGPKG_REGISTRY_HOSTNAME_0=registry.tanzu.vmware.com
    export IMGPKG_REGISTRY_USERNAME_0=MY-TANZUNET-USERNAME
    export IMGPKG_REGISTRY_PASSWORD_0=MY-TANZUNET-PASSWORD
    export IMGPKG_REGISTRY_HOSTNAME_1=MY-REGISTRY
    export IMGPKG_REGISTRY_USERNAME_1=MY-REGISTRY-USER
    export IMGPKG_REGISTRY_PASSWORD_1=MY-REGISTRY-PASSWORD
    export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
    export INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD
    export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
    export TAP_VERSION=VERSION-NUMBER
    export INSTALL_REPO=TARGET-REPOSITORY
    ```

    Where:

    - `MY-REGISTRY-USER` is the user with write access to `MY-REGISTRY`.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    - `MY-REGISTRY` is your own container registry.
    - `MY-TANZUNET-USERNAME` is the user with access to the images in the VMware Tanzu Network registry `registry.tanzu.vmware.com`.
    - `MY-TANZUNET-PASSWORD` is the password for `MY-TANZUNET-USERNAME`.
    - `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.
    - `TARGET-REPOSITORY` is your target repository, a folder or repository on `MY-REGISTRY` that serves as the location for the installation files of Tanzu Application Platform.

    VMware recommends using a JSON key file to authenticate with Google Container Registry.
    In this case, the value of `INSTALL_REGISTRY_USERNAME` is `_json_key` and
    the value of `INSTALL_REGISTRY_PASSWORD` is the content of the JSON key file.
    For more information about how to generate the JSON key file,
    see [Google Container Registry documentation](https://cloud.google.com/container-registry/docs/advanced-authentication).

1. [Install the Carvel tool `imgpkg` CLI](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path).

    To query for the available versions of Tanzu Application Platform on VMWare Tanzu Network Registry, run:

    ```console
    imgpkg tag list -i registry.tanzu.vmware.com/tanzu-application-platform/tap-packages | sort -V
    ```

1. Relocate the images with the `imgpkg` CLI by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages
    ```

## <a id='patch-upgrade'></a> Upgrading a patch version

>**Caution** Tanzu Application Platform (GitOps) does not provide a separate artifact for each patch version within a minor line. For example, Tanzu Application Platform v1.6.x only contains the v1.6.1 GitOps artifact. 

Follow these steps to upgrade to the latest patch:

1. [Download and unpack the latest version of Tanzu GitOps RI](sops.hbs.md#download-tanzu-gitops-ri).

1. Update the Tanzu Application Platform version in `GIT-REPO-ROOT/clusters/CLUSTER-NAME/cluster-config/values/tap-install-values.yaml`:

    ```yaml
    tap_install:
        ...
        version:
            package_repo_bundle_tag: "{{ vars.tap_version }}"
            package_version: "{{ vars.tap_version }}"
    ```

    Where:

    - `package_repo_bundle_tag` is the version of Tanzu Application Platform you want to upgrade to.
    - `package_version` is the version of Tanzu Application Platform you want to upgrade to. This version must match `package_repo_bundle_tag`.

1. Commit the upgrade configurations:

    ```console
    git add . && git commit -m "Upgrade TAP to version 1.6.1"
    git push
    ```

## <a id="upgrading-sops"></a> Upgrade the existing SOPs based installation

In previous versions of Tanzu GitOps RI, sensitive values were provided to Tanzu Sync by using the command line and environment variables. This is replaced by a SOPs encrypted file that is committed to the repository.

Follow these steps to upgrade the existing SOPs based installation:

1. [Download and unpack the new version of Tanzu GitOps RI](sops.hbs.md#download-tanzu-gitops-ri).

1. Overwrite the configuration for TAP installation and Tanzu Sync from the catalog:

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh CLUSTER-NAME sops
    ```

    Where:

    - `CLUSTER-NAME` the name of your cluster you want to upgrade.
    - `sops` selects the Secrets OPerationS-based secrets management variant. Changing between SOPs and any other secret management variant is not supported!

    Example:

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh full-tap-cluster sops
    Created cluster configuration in ./clusters/full-tap-cluster.
    ...
    ```

1. [Prepare sensitive Tanzu Sync values](sops.hbs.md#prep-sensitive-tanzu-sync-values).

## <a id="upgrading-eso"></a> Upgrade the existing ESO based installation

Follow these steps to upgrade the existing ESO based installation with secrets managed externally in AWS Secrets Manager:

1. [Download and unpack the new version of Tanzu GitOps RI](eso/aws-secrets-manager.hbs.md#download-tanzu-gitops-ri).

1. Overwrite the configuration for Tanzu Application Platform installation and Tanzu Sync from the catalog:

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh CLUSTER-NAME aws-secrets-manager
    ```

    Where:

    - `CLUSTER-NAME` the name of your cluster you want to upgrade.
    - `aws-secrets-manager` selects the AWS Secrets Manager external Secret Store.

    Example:

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh full-tap-cluster aws-secrets-manager
    Created cluster configuration in ./clusters/full-tap-cluster.
    ...
    ```

1. [Generate the default configuration](eso/aws-secrets-manager.hbs.md#generate-default-configuration).

## <a id="verify"></a> Verify the upgrade

Verify the versions of packages after the upgrade by running:

```console
kubectl get packageinstall --namespace tap-install
```

Your output is similar, but probably not identical, to the following example output:

```console
- Retrieving installed packages...
  NAME                                PACKAGE-NAME                                         PACKAGE-VERSION  DESCRIPTION
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
  tap                                 tap.tanzu.vmware.com                                 1.6.1            Reconcile succeeded
  tap-auth                            tap-auth.tanzu.vmware.com                            1.1.0            Reconcile succeeded
  tap-gui                             tap-gui.tanzu.vmware.com                             1.3.0            Reconcile succeeded
  tap-telemetry                       tap-telemetry.tanzu.vmware.com                       0.3.1            Reconcile succeeded
  tekton-pipelines                    tekton.tanzu.vmware.com                              0.39.0+tap.2     Reconcile succeeded
```
