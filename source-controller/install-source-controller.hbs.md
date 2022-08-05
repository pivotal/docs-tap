# Install Source Controller

This document describes how to install Source Controller
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Source Controller.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

## <a id='sc-prereqs'></a>Prerequisites

Before installing Source Controller:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cert-manager on the cluster. For more information, see [Install cert-manager](../cert-mgr-contour-fcd/install-cert-mgr.md#install-cert-mgr).

## <a id='sc-install'></a> Install

To install Source Controller:

1. List version information for the package by running:

    ```console
    tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.source.apps.tanzu.vmware.com...
      NAME                                     VERSION  RELEASED-AT
      controller.source.apps.tanzu.vmware.com  0.3.1    2022-01-23 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.3.2    2022-02-21 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.3.3    2022-03-03 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.4.1    2022-06-09 19:00:00 -0500 -05
    ```

2. (Optional) Gather values schema:

    ```console
    tanzu package available get controller.source.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```console
    tanzu package available get controller.source.apps.tanzu.vmware.com/0.4.1 --values-schema --namespace tap-install
    
    Retrieving package details for controller.source.apps.tanzu.vmware.com/0.4.1... 
    KEY               DEFAULT  TYPE    DESCRIPTION                                                                        
    aws_iam_role_arn           string  Optional: The AWS IAM Role ARN to attach to the source controller service account  
    ca_cert_data               string  Optional: PEM Encoded certificate data for image registries with private CA.
    ```

3. (Optional) There are two optional fields that can override Source Controller's default installation setting:

    - `ca_cert_data` Enables Source Controller to connect to image registries that use self-signed or private certificate authorities. If a certificate error `x509: certificate signed by unknown authority` occurs, this option can be used to trust additional certificate authorities.

    - `aws_iam_role_arn` Annotates Source Controller service with an AWS IAM role. This allows Source Controller to pull images from ECR.

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

    To add AWS IAM role ARN in Source Controller Servc, create a file named `source-controller-values.yaml` that includes the following:

    ```yaml
    aws_iam_role_arn: "eks.amazonaws.com/role-arn: arn:aws:iam::112233445566:role/source-controller-manager"

    ```

4. Install the package:

    ```console
    tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f VALUES-FILE
    ```

    Where:

      - `VERSION-NUMBER` is the version of the package listed in step 1 above.
      - `VALUES-FILE` is the path to the file created in step 3.

    For example:

    ```console
    tanzu package install source-controller -p controller.source.apps.tanzu.vmware.com -v 0.4.1  -n tap-install -f source-controller-values.yaml
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

    ```console
    tanzu package installed get source-controller -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get source-controller -n tap-install
   - Retrieving installation details for source-controller...
    NAME:                    source-controller
    PACKAGE-NAME:            controller.source.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.4.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`:

    ```console
    kubectl get pods -n source-system
    ```

    For example:

    ```console
    $ kubectl get pods -n source-system
    NAME                                        READY   STATUS    RESTARTS   AGE
    source-controller-manager-f68dc7bb6-4lrn6   1/1     Running   0          100s
    ```

    Verify that `STATUS` is `Running`.
