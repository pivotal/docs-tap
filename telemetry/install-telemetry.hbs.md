# Install Tap Telemetry independent from Tanzu Application Platform profiles

This document describes how to install Tap Telemetry
from the Tanzu Application Platform package repository.

>**Note:** VMware recommends installing Tap Telemetry by using Tanzu Application Platform Profiles.  See [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md) and [Installing the Tanzu Application Platform Package and Profiles](../install.hbs.md).  Use the following instructions if you do not want to use a profile to install the Tap Telemetry package.

## <a id='prereqs'></a>Prerequisites

Before installing Tap Telemetry:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).
- Install cert-manager on the cluster. For more information, see the [cert-manager documentation](https://cert-manager.io/next-docs/).
- See [Deployment Details and Configuration](deployment-details.hbs.md) to review what resources will be deployed.

## <a id='install'></a>Install

To install Tap Telemetry:

1. List version information for the package by running:

    ```console
    tanzu package available list tap-telemetry.tanzu.vmware.com --namespace tap-install
    ```

   For example:

    ```console
    $ tanzu package available list tap-telemetry.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for tap-telemetry.tanzu.vmware.com...
      NAME                         VERSION       RELEASED-AT
      tap-telemetry.tanzu.vmware.com  0.3.1
    ```

1. (Optional) List out all the available deployment configuration options:

    ```console
    tanzu package available get tap-telemetry.tanzu.vmware.com/VERSION --values-schema -n tap-install
    ```

   Where `VERSION` is the your package version number. For example, `0.3.1`.

   For example:

    ```console
    $ tanzu package available get tap-telemetry.tanzu.vmware.com/0.3.1 --values-schema -n tap-install
    | Retrieving package details for tap-telemetry.tanzu.vmware.com/0.3.1...
   KEY                                  DEFAULT  TYPE    DESCRIPTION
   kubernetes_distribution                       string  Kubernetes platform flavor where the tap-telemetry is being installed on. Accepted values are ['', 'openshift']
   customer_entitlement_account_number           string  Account number used to distinguish data by customer.
   installed_for_vmware_internal_use             string  Indication of if the deployment is for vmware internal user. Accepted values are ['true', 'false']
    ```

1. (Optional) Modify one of the deployment configurations by creating a configuration YAML with the
   custom configuration values you want. For example, if you want to provide your Customer Entitlement Number, then create a `tap-telemetry-values.yaml` and configure the
   `customer_entitlement_account_number` property.

    ```yaml
    ---
    customer_entitlement_account_number: "12345"
    ```

   See [Deployment details and configuration](deployment-details.hbs.md) for
   more information about configuration options.

1. Install the package by running:

    ```console
    tanzu package install tap-telmetry \
      --package-name tap-telemetry.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file tap-telemetry-values.yaml
    ```

   Where:

    * `--values-file` is an optional flag. Only use it to customize the deployment
      configuration.
    * `VERSION` is the package version number. For example, `0.3.1`.

   For example:

    ```console
    $ tanzu package install tap-telmetry \
      --package-name tap-telemetry.tanzu.vmware.com \
      --version 0.3.1 \
      --namespace tap-install \
      --values-file tap-telemetry-values.yaml

      Installing package 'tap-telemetry.tanzu.vmware.com'
      Getting package metadata for 'tap-telemetry.tanzu.vmware.com'
      Creating service account 'tap-telemetry-tap-install-sa'
      Creating cluster admin role 'tap-telemetry-tap-install-cluster-role'
      Creating cluster role binding 'tap-telemetry-tap-install-cluster-rolebinding'
      Creating secret 'tap-telemetry-tap-install-values'
      Creating package resource
      Waiting for 'PackageInstall' reconciliation for 'tap-telemetry'
      'PackageInstall' resource install status: Reconciling
      'PackageInstall' resource install status: ReconcileSucceeded
      'PackageInstall' resource successfully reconciled

    Added installed package 'tap-telemetry'
    ```
