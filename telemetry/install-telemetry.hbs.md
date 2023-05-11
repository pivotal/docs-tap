# Install Tanzu Application Platform Telemetry

This topic tells you how to install Tanzu Application Platform Telemetry
from the Tanzu Application Platform (commonly known as TAP) package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install Telemetry. 
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing Tap Telemetry:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).
- Install cert-manager on the cluster. For more information, see the [cert-manager documentation](https://cert-manager.io/next-docs/).
- See [Deployment Details and Configuration](deployment-details.hbs.md) to review what resources will be deployed.

## <a id='install'></a>Install

To install Tanzu Application Platform Telemetry:

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

1. (Optional) List all the available deployment configuration options:

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

1. (Optional) Modify the deployment configurations by creating a configuration YAML with the desired custom configuration values.
For example, if you want to provide your Customer Entitlement Number, create a `tap-telemetry-values.yaml` and configure the `customer_entitlement_account_number` property:

    ```yaml
    ---
    customer_entitlement_account_number: "12345"
    ```

    See [Deployment details and configuration](deployment-details.hbs.md) for more information about the configuration options.

1. Install the package by running:

    ```console
    tanzu package install tap-telmetry \
      --package-name tap-telemetry.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file tap-telemetry-values.yaml
    ```

    Where:

    - `--values-file` is an optional flag. Only use it to customize the deployment
      configuration.
    - `VERSION` is the package version number. For example, `0.3.1`.

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
