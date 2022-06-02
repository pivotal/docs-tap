# Install Convention Service

This document describes how to install convention controller
from the Tanzu Application Platform package repository.
Convention controller is a primary component of Convention Service.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include convention controller.
For more information about profiles, see [About Tanzu Application Platform package and profiles](../about-package-profiles.md).

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

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cert-manager on the cluster. See [Install Prerequisites](../install-components.md#install-prereqs).

## <a id='install'></a> Install

To install convention controller:

1. List version information for the package by running:

    ```console
    tanzu package available list controller.conventions.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list controller.conventions.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.conventions.apps.tanzu.vmware.com...
      NAME                                          VERSION  RELEASED-AT
      controller.conventions.apps.tanzu.vmware.com  0.6.3    2022-03-08T00:00:00Z
    ```

1. (Optional) Gather values schema:

    ```console
    tanzu package available get controller.conventions.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1.

    For example:

    ```console
    $ tanzu package available get controller.conventions.apps.tanzu.vmware.com/0.6.3 --values-schema --namespace tap-install

    KEY           DEFAULT  TYPE    DESCRIPTION                                                                   
    ca_cert_data           string  Optional: PEM Encoded certificate data for image registries with private CA.  
    ```

1. (Optional) Enable Convention Controller to connect to image registries that use self-signed or private certificate authorities.
If a certificate error `x509: certificate signed by unknown authority` occurs, this option can be used to trust additional certificate authorities.

    To provide custom cert, create a file named `convention-controller-values.yaml` that includes the PEM-encoded CA cert data.

    For example:

    ```yaml
    ca_cert_data: |
      -----BEGIN CERTIFICATE-----
      MIICpTCCAYUCBgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIYg9x6gkCAggA
      ...
      9TlA7A4FFpQqbhAuAVH6KQ8WMZIrVxJSQ03c9lKVkI62wQ==
      -----END CERTIFICATE-----
    ```

1. Install the package by running:

    ```console
    tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v VERSION-NUMBER -f VALUES-FILE -n tap-install
    ```
    Where:

      - `VERSION-NUMBER` is the version of the package listed in the earlier step.
      - `VALUES-FILE` is the path to the file created in the earlier step.

    For example:

    ```console
    tanzu package install convention-controller -p controller.conventions.apps.tanzu.vmware.com -v 0.6.3 -f VALUES-FILE convention-controller-values.yaml -n tap-install
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

    ```console
    tanzu package installed get conventions-controller -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get convention-controller -n tap-install
    Retrieving installation details for conventions-controller...
    NAME:                    conventions-controller
    PACKAGE-NAME:            controller.conventions.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.6.3
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`:

    ```console
    kubectl get pods -n conventions-system
    ```

    For example:

    ```console
    $ kubectl get pods -n conventions-system
    NAME                                             READY   STATUS    RESTARTS   AGE
    conventions-controller-manager-596c65f75-j9dmn   1/1     Running   0          72s
    ```

    Verify that `STATUS` is `Running`.
