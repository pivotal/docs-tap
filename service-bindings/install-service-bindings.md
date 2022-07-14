# Install Service Bindings

This document describes how to install Service Bindings
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Service Bindings.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

## <a id='prereqs'></a>Prerequisites

Before installing Service Bindings:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install-service-bindings'></a> Install Service Bindings

Use the following procedure to install Service Bindings:

1. List version information for the package by running:

    ```console
    tanzu package available list service-bindings.labs.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list service-bindings.labs.vmware.com --namespace tap-install
    - Retrieving package versions for service-bindings.labs.vmware.com...
      NAME                              VERSION  RELEASED-AT
      service-bindings.labs.vmware.com  0.5.0    2021-09-15T00:00:00Z
    ```

1. Install the package by running:

    ```console
    tanzu package install service-bindings -p service-bindings.labs.vmware.com -v 0.5.0 -n tap-install
    ```

    Example output:

    ```console
    / Installing package 'service-bindings.labs.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'service-bindings.labs.vmware.com'
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
    PACKAGE-NAME:            service-bindings.labs.vmware.com
    PACKAGE-VERSION:         0.5.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

1.  Run the following command:

    ```console
    kubectl get pods -n service-bindings
    ```

    For example:

    ```console
    $ kubectl get pods -n service-bindings
    NAME                       READY   STATUS    RESTARTS   AGE
    manager-6d85fffbcd-j4gvs   1/1     Running   0          22s
    ```

    Verify that `STATUS` is `Running`
