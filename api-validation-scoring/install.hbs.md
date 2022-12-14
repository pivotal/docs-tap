# Install API Validation and Scoring

This topic describes how to install API Validation and Scoring from the Tanzu  Application Platform package repository.

## Prerequisites

Before installing API Validation and Scoring, complete all prerequisites as mentioned below:

Step 1: Create a Tanzu Account ,

- [Tanzu Network](https://network.tanzu.vmware.com/) account to download Tanzu Application Platform packages.

Step 2:  Provision required Kubernetes cluster v1.22, v1.23 , v1.24  or v1.25 on the below mentioned  Kubernetes providers.

- Amazon Elastic Kubernetes Service

> **Note** The Installation of API scoring and validation package must be done on a new cluster without any existing Tanzu Application Platform installations.

Step 3 : [Install Tanzu CLI](../install-tanzu-cli.hbs.md#cli-and-plugin).

Step 4 : [Install kapp](https://carvel.dev/kapp/docs/v0.54.0/install/).

Step 5: The Kubernetes CLI ,see [Install Tools](https://kubernetes.io/docs/tasks/tools) in the Kubernetes documentation.

Step 6: Set the Tanzu network account for installation by running the following:

**Environment variables**

```console
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
export INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD
```

Where:
- `MY-REGISTRY-USER` is the user with write access to registry.tanzu.vmware.com.
- `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.

## Resource requirements
To deploy API Validation and Scoring package , your cluster must have at least:

- 5 nodes
- 4 vCPUs available per node
- 16 GB of RAM available per node
- *100 GB of disk space available per node

## Install

To install the API Validation and Scoring package:

1. Create a namespace called apix-install for deploying API Validation and Scoring package by running:
   **Create Namespace**
   ```console
   kubectl create ns apix-install
   ```
   This namespace keeps the objects grouped together logically.

2. Add the Tanzu package repository by running:
   **Add Tanzu Repo**
   ```console
   tanzu package repository add apix-repo --url dev.registry.tanzu.vmware.com/apix/apix:0.2.4 --namespace apix-install
   ```

3. Get the status of the API Validation and Scoring package repository, and ensure the status updates to Reconcile succeeded by running:
   ```console
   tanzu package repository get apix-repo --namespace apix-install
   ```
   For example:
   ```
   NAME        PACKAGE NAME                  PACKAGE VERSION           DESCRIPTION             AGE
   apix        apix.apps.tanxu.vmware.com    0.2.4                     Reconcile succeeded     28m
   ```

4. To overwrite the default values when installing the package, create a apix-values.yaml  file:
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

5. Install the API Validation and Scoring package using the Tanzu CLI by running :
   ```console
   tanzu package install apix -n apix-install -p PACKAGE-NAME -v PACKAGE-VERSION -f apix-values.yaml
   ```
   Where, 
   - PACKAGE-NAME is the name of the API Validation and scoring TAP package
   - PACKAGE-VERSION is the version number of the API Validation and scoring TAP package

   For example:
   ```console
   tanzu package install apix -n apix-install -p apix.apps.tanzu.vmware.com -v 0.2.4 -f apix-values.yaml
   ```

6. Verify the package installation by running:
   ```console
   tanzu package available list -n apix-install
   ```
   If the package has installed , you should be able to view a similar message :
   ```console
   NAME                         DISPLAY-NAME         SHORT_DESCRIPTION                  LATEST-VERSION
   apix.apps.tanxu.vmware.com   apix                 apix.apps.tanxu.vmware.com         0.2.4
   ```

7. Verify that DESCRIPTION is `Reconcile succeeded`:

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
kubectl delete pkgi apix -n apix-install
kubectl delete packagerepository apix-repo -n apix-install
 
kubectl delete namespace apix-install
kubectl delete namespace kapp-controller
kubectl delete namespace kapp-controller-packaging-global
```
