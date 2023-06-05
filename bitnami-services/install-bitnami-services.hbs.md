# Install Bitnami Services

This topic tells you how to install Bitnami Services from the Tanzu Application Platform
(commonly known as TAP) package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install
> Bitnami Services.
> For more information about profiles, see
> [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing Bitnami Services:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).
- Install Crossplane, see [Install Crossplane](../crossplane/install-crossplane.hbs.md).
- Install Services Toolkit, see [Install Services Toolkit](../services-toolkit/install-services-toolkit.hbs.md).

## <a id='install-bitnami-services'></a> Install Bitnami Services

To install Bitnami Services:

1. See what versions of Bitnami Services are available to install by running:

    ```console
    tanzu package available list -n tap-install bitnami.services.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list -n tap-install bitnami.services.tanzu.vmware.com
      NAME                               VERSION           RELEASED-AT
      bitnami.services.tanzu.vmware.com  0.1.0             2023-03-10 14:35:15 +0000 UTC
    ```

1. Install Bitnami Services by running:

    ```console
    tanzu package install bitnami-services -n tap-install -p bitnami.services.tanzu.vmware.com -v VERSION-NUMBER
    ```

    Where `VERSION-NUMBER` is the Bitnami Services version you want to install. For example, `0.1.0`.

1. Verify that the package installed by running:

    ```console
    tanzu package installed get bitnami-services -n tap-install
    ```

    In the output, confirm that the `STATUS` value is `Reconcile succeeded`.

    For example:

    ```console
    $ tanzu package installed get bitnami-services -n tap-install
    NAMESPACE:          tap-install
    NAME:               bitnami-services
    PACKAGE-NAME:       bitnami.services.tanzu.vmware.com
    PACKAGE-VERSION:    0.1.0
    STATUS:             Reconcile succeeded
    CONDITIONS:         - type: ReconcileSucceeded
      status: "True"
      reason: ""
      message: ""
    ```
