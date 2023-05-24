# Install External Secrets Operator

This topic tells you how to install the External Secrets Operator
from the Tanzu Application Platform package repository.

> **Important** External Secrets Operator is not included or installed with any
> Tanzu Application Platform profile.

## <a id='eso-prereqs'></a> Prerequisites

Before installing External Secrets Operator:

- Complete all prerequisites to install the Tanzu Application Platform.
For more information, see [Prerequisites](../prerequisites.md).

## <a id='eso-install'></a> Install

To install External Secrets Operator:

1. List version information for the package by running:

   ```console
   tanzu package available list external-secrets.apps.tanzu.vmware.com -n tap-install
   ```

   For example:

   ```console
   NAME                                    VERSION      RELEASED-AT
   external-secrets.apps.tanzu.vmware.com  0.6.1+tap.6  2023-03-08 14:00:00 -0500 EST
   ```

2. Install the package:

   ```console
   tanzu package install external-secrets \
     --package-name external-secrets.apps.tanzu.vmware.com \
     --version VERSION-NUMBER \
     --namespace tap-install
   ```

   Where `VERSION-NUMBER` is the version of the package listed in step 1.

   For example:

   ```console
   tanzu package install external-secrets \
   --package-name external-secrets.apps.tanzu.vmware.com
   --version 0.6.1+tap.6
   --namespace tap-install

   \ Installing package 'external-secrets.apps.tanzu.vmware.com'
   | Getting package metadata for 'external-secrets.apps.tanzu.vmware.com'
   | Creating service account 'external-secrets-tap-install-sa'
   / Creating cluster admin role 'external-secrets-tap-install-cluster-role'
   | Creating cluster role binding 'external-secrets-tap-install-cluster-rolebindin
   / Creating cluster role binding 'external-secrets-tap-install-cluster-rolebindin
   \ Creating cluster role binding 'external-secrets-tap-install-cluster-rolebindin
   | Creating cluster role binding 'external-secrets-tap-install-cluster-rolebinding'
   \ Creating package resource
   Waiting for 'PackageInstall' reconciliation for 'external-secrets'
   'PackageInstall' resource install status: Reconciling
   'PackageInstall' resource install status: ReconcileSucceeded

   Added installed package 'external-secrets'
   ```

3. Verify the package installation by running:

   ```console
   tanzu package installed get external-secrets \
   --namespace tap-install
   ```

   For example:

   ```console
   tanzu package installed get external-secrets -n tap-install

   NAME:                    external-secrets
   PACKAGE-NAME:            external-secrets.apps.tanzu.vmware.com
   PACKAGE-VERSION:         0.6.1+tap.6
   STATUS:                  Reconcile succeeded
   CONDITIONS:              [{ReconcileSucceeded True  }]
   USEFUL-ERROR-MESSAGE:
   ```
