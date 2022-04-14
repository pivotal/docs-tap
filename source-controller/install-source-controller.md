# Install Source Controller

This document describes how to install Source Controller
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Source Controller.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

## <a id='sc-prereqs'></a>Prerequisites

Before installing Source Controller:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cert-manager on the cluster. See [Install Prerequisites](../install-components.md#install-prereqs).

## <a id='sc-install'></a> Install

To install Source Controller:

1. List version information for the package by running:

    ```
    tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.source.apps.tanzu.vmware.com...
      NAME                                     VERSION  RELEASED-AT
      controller.source.apps.tanzu.vmware.com  0.3.1    2022-01-23 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.3.2    2022-02-21 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.3.3    2022-03-03 19:00:00 -0500 -05
    ```

2. (Optional) Gather values schema:

    ```
    tanzu package available get controller.source.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```
    $ tanzu package available get controller.source.apps.tanzu.vmware.com/0.3.3 --values-schema --namespace tap-install
     Retrieving package details for controller.source.apps.tanzu.vmware.com/0.3.3...
     KEY           DEFAULT  TYPE    DESCRIPTION
     ca_cert_data           string  Optional: PEM Encoded certificate data for image registries with private CA.
    ```

3. (Optional) Enable Source Controller to connect to image registries that use self-signed or private certificate authorities.
If a certificate error `x509: certificate signed by unknown authority` occurs, this option can be used to trust additional certificate authorities. 

    To provide a custom certificate, create a file named `source-controller-values.yaml` that includes the PEM-encoded CA certificate data.
   
      For example:

      ```yaml
      ca_cert_data: |
          -----BEGIN CERTIFICATE-----
          MIICpTCCAYUCBgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIYg9x6gkCAggA
          ...
          9TlA7A4FFpQqbhAuAVH6KQ8WMZIrVxJSQ03c9lKVkI62wQ==
          -----END CERTIFICATE-----
      ```

4. Install the package:

    ```
    tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f VALUES-FILE
    ```

    Where:

      - `VERSION-NUMBER` is the version of the package listed in step 1 above.
      - `VALUES-FILE` is the path to the file created in step 3.

    For example:

    ```
    tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v 0.3.3  -n tap-install -f source-controller-values.yaml
    \ Installing package 'controller.source.apps.tanzu.vmware.com'
    | Getting package metadata for 'controller.source.apps.tanzu.vmware.com'
    | Creating service account 'source-controller-default-sa'
    | Creating cluster admin role 'source-controller-default-cluster-role'
    | Creating cluster role binding 'source-controller-default-cluster-rolebinding'
    | Creating secret 'source-controller-default-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'source-controller'
    - 'PackageInstall' resource install status: Reconciling



     Added installed package 'source-controller'
    ```

5. Verify the package installation by running:

    ```
    tanzu package installed get source-controller -n tap-install
    ```

    For example:

    ```
    tanzu package installed get source-controller -n tap-install
   - Retrieving installation details for source-controller...
    NAME:                    source-controller
    PACKAGE-NAME:            controller.source.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.3
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`:

    ```
    kubectl get pods -n source-system
    ```

    For example:

    ```
    $ kubectl get pods -n source-system
    NAME                                        READY   STATUS    RESTARTS   AGE
    source-controller-manager-f68dc7bb6-4lrn6   1/1     Running   0          100s
    ```

    Verify that `STATUS` is `Running`.
