# Install API Validation and Scoring

This topic describes how to install API Validation and Scoring from the Tanzu  Application Platform package repository.

## Prerequisites

Before installing API Validation and Scoring, complete all prerequisites as mentioned below:

Step 1: Create a Tanzu Account ,

- [Tanzu Network](https://network.tanzu.vmware.com/) account to download API Validation and Scoring packages.

Step 2:  Provision required Kubernetes cluster v1.22, v1.23 , v1.24  or v1.25 on the below-mentioned  Kubernetes providers.

- Amazon Elastic Kubernetes Service

> **Note** The Installation of API scoring and validation package must be done on a new cluster without any existing Tanzu Application Platform installations.

Step 3 : [Install Tanzu CLI](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-install-tanzu-cli.html#cli-and-plugin).

Step 4 : [Install kapp](https://carvel.dev/kapp/docs/v0.54.0/install/).

Step 5: The Kubernetes CLI ,see [Install Tools](https://kubernetes.io/docs/tasks/tools) in the Kubernetes documentation.

## Resource requirements
To deploy API Validation and Scoring package , your cluster must have at least:
- 5 nodes
- 4 vCPUs available per node
- 16 GB of RAM available per node
- 100 GB of disk space available across all nodes

## Relocate images to a registry
VMware recommends relocating the images from VMware Tanzu Network registry to your own container image registry before attempting installation. If you don’t relocate the images, API Validation and Scoring depends on VMware Tanzu Network for continued operation, and VMware Tanzu Network offers no uptime guarantees. The option to skip relocation is documented for evaluation and proof-of-concept only.
To relocate images from the VMware Tanzu Network registry to your registry:

1. Install Docker if it is not already installed.
2. Log in to your image registry by running:
   ```console
   docker login MY-REGISTRY
   ```

   Where `MY-REGISTRY` is your own container registry.
3. Log in to the VMware Tanzu Network registry with your VMware Tanzu Network credentials by running:

   ```console
   docker login registry.tanzu.vmware.com
   ```
4. Set up environment variables for installation use by running:

   ```console
   export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
   export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
   export APIX_VERSION=VERSION-NUMBER
   export INSTALL_REPO=TARGET-REPOSITORY
   ```

   Where:
   * `MY-REGISTRY-USER` is the user with write access to `MY-REGISTRY`.
   * `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
   * `MY-REGISTRY` is your own container registry.
   * `VERSION-NUMBER` is your 'API Validation and Scoring' package version. For example, `0.2.4`.
   * `TARGET-REPOSITORY` is your target repository, a folder/repository on `MY-REGISTRY` that serves as the location for the installation files for API Validation and Scoring.
5. [Install the Carvel tool `imgpkg` CLI](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.3/cluster-essentials/GUID-deploy.html#optionally-install-clis-onto-your-path-6).
   To query for the available `imgpkg` CLI versions on VMWare Tanzu Network Registry, run:
   ```console
   imgpkg tag list -i registry.tanzu.vmware.com/tanzu-application-platform/apix | grep -v sha | sort -V
   ```
6. Relocate the images with the `imgpkg` CLI by running:
   ```console
   imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/apix:${APIX_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/apix
   ```

## Add the API Validation and Scoring package repository

Tanzu CLI packages are available on repositories. Adding the API Validation and Scoring package repository makes the packages available for installation.

[Relocate images to a registry](#relocate-images-to-a-registry) is strongly recommended but not required for installation. If you skip this step, you can use the following values to replace the corresponding variables:

* `INSTALL_REGISTRY_HOSTNAME` is `registry.tanzu.vmware.com`
* `INSTALL_REPO` is `tanzu-application-platform`
* `INSTALL_REGISTRY_USERNAME` and `INSTALL_REGISTRY_PASSSWORD` are the credentials to run `docker login registry.tanzu.vmware.com`
* `APIX_VERSION` is your 'API Validation and Scoring' package version. For example, `0.2.4`.

To add the API Validation and Scoring package repository to your cluster:

1. Create a namespace called `apix-install` for deploying API Validation and Scoring package by running:
   ```console
   kubectl create ns apix-install
   ```
   This namespace keeps the objects grouped together logically.

2. Add the API Validation and Scoring package repository to the cluster by running:
   ```console
   tanzu package repository add apix-repository \
   --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/apix:${APIX_VERSION} \
   --namespace apix-install
   ```
3. Verify the package installation by running:
   ```console
   tanzu package available list -n apix-install
   ```
   If the package has installed , you should be able to view a similar message :
   ```console
   NAME                         DISPLAY-NAME         SHORT_DESCRIPTION                  LATEST-VERSION
   apix.apps.tanxu.vmware.com   apix                 apix.apps.tanxu.vmware.com         0.2.4
   ```

4. Get the status of the API Validation and Scoring package repository, and ensure the status updates to Reconcile succeeded by running:
   ```console
      tanzu package repository get apix-repository --namespace apix-install
   ```
   For example:
   ```console
   NAME        PACKAGE NAME                  PACKAGE VERSION           DESCRIPTION             AGE
   apix        apix.apps.tanxu.vmware.com    0.2.4                     Reconcile succeeded     28m
   ```


## Install

To install the API Validation and Scoring package:

1. To overwrite the default values when installing the package, create apix-values.yaml  file:

   ```yaml
   apix:
      host: "HOST"          #optional
      backstage:
        host: "BACKSTAGE-HOST"
        port: "BACKSTAGE-PORT"
   ```

   Where
   - HOST is an optional but recommended hostname, you must allocate if you decide to use the API Validation and Scoring GUI. e.g., localhost
   - BACKSTAGE-HOST is TAP GUI or Backstage host that you want to point to, e.g., https://tap-gui.view-cluster.com
   - BACKSTAGE-PORT is a TAP GUI or Backstage port that you want to point to e.g., 443
   
2. Install the API Validation and Scoring package using the Tanzu CLI by running :
   ```console
   tanzu package install apix -n apix-install -p apix.apps.tanzu.vmware.com -v ${APIX_VERSION} -f apix-values.yaml
   ```

3. Verify that DESCRIPTION is `Reconcile succeeded`:
   ```console
   tanzu package installed get apix -n apix-install
   ```
   If your package has successfully reconciled, you should see a similar message as below

   ```console
   NAME        PACKAGE NAME                  PACKAGE VERSION           DESCRIPTION             AGE
   apix        apix.apps.tanxu.vmware.com    0.2.4                     Reconcile succeeded     28m
   ```

## Uninstall

Uninstall the API Validation and Scoring package , by running :
   ```console
   tanzu package installed delete apix -n apix-install
   ```
   For example,
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