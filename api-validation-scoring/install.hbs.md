# Install API Validation and Scoring

This topic tells you how to install API Validation and Scoring from the Tanzu Application Platform (commonly known as TAP) package repository.

## <a id='prerequisites'></a>Prerequisites

Before installing API Validation and Scoring, complete the following prerequisites:

1. Create a [Tanzu Network](https://network.tanzu.vmware.com/) account to download Tanzu Application Platform packages.
1. Provision Kubernetes cluster v1.22, v1.23 or v1.24 on Amazon Elastic Kubernetes Service.

    > **Note** The Installation of API scoring and validation package must be done on a new cluster without any existing Tanzu Application Platform installations.

1. [Install Tanzu CLI](../install-tanzu-cli.hbs.md#cli-and-plugin).
1. [Install kapp](https://carvel.dev/kapp/docs/v0.54.0/install/).
1. Install Kubernetes CLI. For more information, see [Install Tools](https://kubernetes.io/docs/tasks/tools) in the Kubernetes documentation.
1. [Deploy Cluster Essentials](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html)

## <a id='resource-requirements'></a>Resource requirements

To deploy API Validation and Scoring package, your cluster must have at least:

- 5 nodes.
- 4 vCPUs available per node.
- 16 GB of RAM available per node.
- 100 GB of disk space available across all nodes.

## <a id='relocate-images'></a>Relocate images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to your own container image registry before attempting installation.
API Validation and Scoring depends on VMware Tanzu Network for continued operation.
If you don’t relocate the images, VMware Tanzu Network offers no uptime guarantees.
The option to skip relocation is documented for evaluation and proof-of-concept only.

To relocate images from the VMware Tanzu Network registry to your registry:

1. Install Docker if it is not already installed.

1. Log in to your image registry by running:

    ```console
    docker login MY-REGISTRY
    ```

   Where `MY-REGISTRY` is your own container registry.

1. Log in to the VMware Tanzu Network registry with your VMware Tanzu Network credentials by running:

    ```console
    docker login registry.tanzu.vmware.com
    ```

1. Set up environment variables for installation use by running:

    ```console
    export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
    export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
    export APIX_VERSION=VERSION-NUMBER
    export INSTALL_REPO=TARGET-REPOSITORY
    ```

    Where:

    * `MY-REGISTRY-USER` is the user with write access to `MY-REGISTRY`
    * `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`
    * `MY-REGISTRY` is your own container registry.
    * `VERSION-NUMBER` is your API Validation and Scoring package version. For example, `0.2.5`
    * `TARGET-REPOSITORY` is your target repository, a folder/repository on `MY-REGISTRY` that serves as the location for the installation files for API Validation and Scoring.

1. [Install the Carvel tool imgpkg CLI](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path).

    To query for the available `imgpkg` CLI versions on VMWare Tanzu Network Registry, run:

    ```console
    imgpkg tag list -i registry.tanzu.vmware.com/tanzu-application-platform/apix | grep -v sha | sort -V
    ```

1. Relocate the images with the `imgpkg` CLI by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/apix:${APIX_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/apix
    ```

## <a id='add-package-repo'></a>Add the API Validation and Scoring package repository

Tanzu CLI packages are available on repositories. Adding the API Validation and Scoring package repository makes the packages available for installation.

[Relocate images to a registry](#relocate-images-to-a-registry) is strongly recommended but not required for installation. If you skip this step, you can use the following values to replace the corresponding variables:

* `INSTALL_REGISTRY_HOSTNAME` is `registry.tanzu.vmware.com`
* `INSTALL_REPO` is `tanzu-application-platform`
* `INSTALL_REGISTRY_USERNAME` and `INSTALL_REGISTRY_PASSWORD` are the credentials to run `docker login registry.tanzu.vmware.com`
* `APIX_VERSION` is your API Validation and Scoring package version. For example, `0.2.5`

To add the API Validation and Scoring package repository to your cluster:

1. Create a namespace called `apix-install` for deploying API Validation and Scoring package by running:

    ```console
    kubectl create ns apix-install
    ```

    This namespace keeps the objects grouped together logically.

1. Create a secret for adding the API Validation and Scoring package repository:

    ```console
    tanzu secret registry add tap-registry --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} --server ${INSTALL_REGISTRY_HOSTNAME} --export-to-all-namespaces --yes --namespace apix-install
    ```

1. Add the API Validation and Scoring package repository to the cluster by running:

    ```console
    tanzu package repository add apix-repository \
    --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/apix:${APIX_VERSION} \
    --namespace apix-install
    ```

1. Verify the package installation by running:

    ```console
    tanzu package available list -n apix-install
    ```

    If the package installed, expect to see the output that resembles the following:

    ```console
    NAME                         DISPLAY-NAME     SHORT_DESCRIPTION               LATEST-VERSION
    apix.apps.tanzu.vmware.com   apix             apix.apps.tanzu.vmware.com      0.2.5
    ```

1. Get the status of the API Validation and Scoring package repository by running:

    ```console
    tanzu package repository get apix-repository --namespace apix-install
    ```

    For example:

    ```console
    ~ %    tanzu package repository get apix-repository --namespace apix-install
    NAME:          apix-repository
    VERSION:       796582
    REPOSITORY:    projects.registry.vmware.com/mazinger/apix
    TAG:           0.2.5
    STATUS:        Reconcile succeeded
    REASON:
    ```

    Verify the `STATUS` is `Reconcile succeeded`

## <a id='install'></a>Install

Follow these steps to install the API Validation and Scoring package:

1. To overwrite the default values when installing the package, create the `apix-values.yaml` file:

    ```yaml
    apix:
     host: "HOST"
     backstage:
      host: "BACKSTAGE-HOST"
      port: "BACKSTAGE-PORT"
    ```

    Where:

    - `HOST` is the hostname of the API Validation and Scoring GUI. It can be left empty `""` to use the default value.
    - `BACKSTAGE-HOST` is the Tanzu Application Platform GUI or Backstage host that you want to point to. For example, `https://tap-gui.view-cluster.com`
    - `BACKSTAGE-PORT` is the Tanzu Application Platform GUI or Backstage port that you want to point to. For example, `443`

1. Install the API Validation and Scoring package using the Tanzu CLI by running:

    ```console
    tanzu package install apix -n apix-install -p apix.apps.tanzu.vmware.com -v ${APIX_VERSION} -f apix-values.yaml
    ```

1. Verify that STATUS is `Reconcile succeeded` by running:

    ```console
    tanzu package installed get apix -n apix-install
    ```

    If your package successfully reconciled, expect to see the output that resembles the following::

    ```console
    NAME:                    apix
    PACKAGE-NAME:            apix.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.2.5
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

## <a id='uninstall'></a>Uninstall

Uninstall the API Validation and Scoring package by running:

```console
tanzu package installed delete apix -n apix-install
```

For example:

```console
% tanzu package installed delete apix -n apix-install
Deleting installed package 'apix' in namespace 'apix-install'. Are you sure? [y/N]: y
Uninstalling package 'apix' from namespace 'apix-install'
Getting package install for 'apix'
Deleting package install 'apix' from namespace 'apix-install'
'PackageInstall' resource deletion status: Deleting
Deleting admin role 'apix-apix-install-cluster-role'
Deleting role binding 'apix-apix-install-cluster-rolebinding'
Deleting secret 'apix-apix-install-values'
Deleting service account 'apix-apix-install-sa'
Uninstalled package 'apix' from namespace 'apix-install'
```
