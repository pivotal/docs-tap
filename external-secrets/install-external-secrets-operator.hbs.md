# Install External Secrets Operator in Tanzu Application Platform

This topic tells you how to install the External Secrets Operator
from the Tanzu Application Platform (commonly known as TAP) package repository.

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
   NAME                                    VERSION        RELEASED-AT
   external-secrets.apps.tanzu.vmware.com  0.9.4+tanzu.2  2023-11-10 00:00:00 -0500 EST
   ```

1. (Optional) Create a YAML values file to specify optional configuration for the External Secrets Operator.
   In this release, there is only one setting: `kubernetes_distribution`, which you can set to
   `"openshift"` or `""`.

   - To run External Secrets Operator on an OpenShift cluster, set the `kubernetes_distribution` value
   to `openshift`. This setting removes some of the default security settings in External Secrets Operator
   so that OpenShift can replace the security settings with its own.

   - If you are running the External Secrets Operator on any other platform, leave `kubernetes_distribution`
   as an empty string or omit the value entirely.

1. Install the package by running:

   ```console
   tanzu package install external-secrets \
     --package external-secrets.apps.tanzu.vmware.com \
     --version VERSION-NUMBER \
     --values-file VALUES-FILE.yaml \ # The use of this file is optional
     --namespace tap-install
   ```

   Where:
   - `VERSION-NUMBER` is the package version you retrieved earlier.
   - (Optional) `VALUES-FILE` is the YAML file you created earlier containing the values used to configure
     External Secrets Operator.

   For example:

   ```console
   tanzu package install external-secrets \
   --package external-secrets.apps.tanzu.vmware.com \
   --version 0.6.1+tap.6 \
   --values-file external-secrets-values.yaml \
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

1. Verify the package installation by running:

   ```console
   tanzu package installed get external-secrets --namespace tap-install
   ```

   For example:

   ```console
   tanzu package installed get external-secrets -n tap-install

   NAME:                    external-secrets
   PACKAGE-NAME:            external-secrets.apps.tanzu.vmware.com
   PACKAGE-VERSION:         0.9.4+tanzu.2
   STATUS:                  Reconcile succeeded
   CONDITIONS:              [{ReconcileSucceeded True  }]
   USEFUL-ERROR-MESSAGE:
   ```
