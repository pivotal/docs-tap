# Install Convention Service

This document describes how to install convention controller
from the Tanzu Application Platform package repository.
Convention controller is a primary component of Convention Service.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include convention controller.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

Convention Service allows app operators to enrich Pod Template Specs with operational knowledge
based on specific conventions they define. It includes the following components:

- Convention controller: Provides metadata to the convention server.
Implements update requests from the convention server.
- Convention server: Receives and evaluates metadata associated with a workload from convention
controller. Requests updates to the Pod Template Spec associated with that workload.
There can be one or more convention servers for a single convention controller instance.

In the following procedure, you install convention controller.
You install convention servers as part of separate installation procedures.
For example, you install an `app-live-view` convention server as part of the `app-live-view`
installation.

## <a id='prereqs'></a> Prerequisites

Before installing convention controller:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Installing the Tanzu CLI](../install-tanzu-cli.md).
- Install cert-manager on the cluster. See [Install Prerequisites](../install-components.md#install-prereqs).

## <a id='install'></a> Install

To install convention controller:

1. List version information for the package by running:

    ```
    tanzu package available list controller.conventions.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list controller.conventions.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.conventions.apps.tanzu.vmware.com...
      NAME                                          VERSION  RELEASED-AT
      controller.conventions.apps.tanzu.vmware.com  0.4.2    2021-09-16T00:00:00Z
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```
    tanzu package available get controller.conventions.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1.

    For example:

    ```
    $ tanzu package available get controller.conventions.apps.tanzu.vmware.com/0.4.2 --values-schema --namespace tap-install
    ```




1. Install the package by running:

    ```
    tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v 0.4.2 -n tap-install
    ```

    For example:

    ```
    tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v 0.4.2 -n tap-install
    / Installing package 'controller.conventions.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    - Getting package metadata for 'controller.conventions.apps.tanzu.vmware.com'
    | Creating service account 'convention-controller-tap-install-sa'
    | Creating cluster admin role 'convention-controller-tap-install-cluster-role'
    | Creating cluster role binding 'convention-controller-tap-install-cluster-rolebinding'
    \ Creating package resource
    | Package install status: Reconciling
    Added installed package 'convention-controller' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```
    tanzu package installed get convention-controller -n tap-install
    ```

    For example:

    ```
    tanzu package installed get convention-controller -n tap-install
    Retrieving installation details for convention-controller...
    NAME:                    convention-controller
    PACKAGE-NAME:            controller.conventions.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.4.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`:

    ```
    kubectl get pods -n conventions-system
    ```

    For example:

    ```
    $ kubectl get pods -n conventions-system
    NAME                                             READY   STATUS    RESTARTS   AGE
    conventions-controller-manager-596c65f75-j9dmn   1/1     Running   0          72s
    ```

    Verify that `STATUS` is `Running`.
