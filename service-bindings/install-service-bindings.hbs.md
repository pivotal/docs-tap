# Install Service Bindings

This topic tells you how to install Service Bindings
from the Tanzu Application Platform (commonly known as TAP) package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install
> Service Bindings.
> For more information about profiles, see
> [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing Service Bindings:

- Complete all prerequisites to install Tanzu Application Platform (commonly knows as TAP). For more information, see [Prerequisites](../prerequisites.md).

## <a id='install-service-bindings'></a> Install Service Bindings

Use the following procedure to install Service Bindings:

1. List version information for the package by running:

    ```console
    tanzu package available list servicebinding.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list servicebinding.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for servicebinding.tanzu.vmware.com...
      NAME                              VERSION  RELEASED-AT
      servicebinding.tanzu.vmware.com   0.10.3   2023-12-05T08:26:41Z
    ```

1. Install the package by running:

    ```console
    tanzu package install service-bindings -p servicebinding.tanzu.vmware.com  -v 0.10.3 -n tap-install
    ```

    Example output:

    ```console
    / Installing package 'servicebinding.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'servicebinding.tanzu.vmware.com'
    | Creating service account 'service-bindings-tap-install-sa'
    | Creating cluster admin role 'service-bindings-tap-install-cluster-role'
    | Creating cluster role binding 'service-bindings-tap-install-cluster-rolebinding'
    \ Creating package resource
    | Package install status: Reconciling

     Added installed package 'service-bindings' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```console
    tanzu package installed get service-bindings -n tap-install
    ```

    Example output:

    ```console
    - Retrieving installation details for service-bindings...
    NAME:                    service-bindings
    PACKAGE-NAME:            servicebinding.tanzu.vmware.com
    PACKAGE-VERSION:         0.10.3
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

1. Run the following command:

    ```console
    kubectl get pods -n service-bindings
    ```

    For example:

    ```console
    $ kubectl get pods -n service-bindings
    NAME                                                 READY   STATUS    RESTARTS   AGE
    servicebinding-controller-manager-7856497ddd-bmgv2   1/1     Running   0          5m59s
    ```

    Verify that `STATUS` is `Running`
