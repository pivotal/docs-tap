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

2. Install the package:

   ```console
   tanzu package install external-secrets \
     --package external-secrets.apps.tanzu.vmware.com \
     --version VERSION-NUMBER \
     --values-file VALUES_FILE.YAML \
     --namespace tap-install
   ```

   Where `VERSION-NUMBER` is the version of the package listed in step 1 and
   `VALUES_FILE.YAML` is an *optional* YAML file containing values used to configure the
   External Secrets Operator.  See below for more information related to the
   configuration file.

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

   *OPTIONAL* The YAML values file specifies optional configuration for the
   External Secrets Operator.  At this time there is only one setting that can
   be used to configure the External Secrets Operator:

     kubernetes_distribution: "" or "openshift"

   If you want to run External Secrets Operator on an OpenShift cluster then you
   must set the `kubernetes_distribution` value to `openshift`.  Using this
   setting removes some of the default security settings in External Secrets
   Operator so that OpenShift can replace the security settings with its own.

   If you are running the External Secrets Operator on any other platforms than
   you can leave `kubernetes_distribution` as an empty string (i.e.: `""`) or
   omit the value entirely.

   The `kubernetes_distribution` setting is available as of release
   `0.9.4+tanzu.2` of the External Secrets Operator.

   It is a known issue that the External Secrets Operator releases prior to
   `0.9.4+tanzu.2` may not be able to run on OpenShift clusters.  If you are
   trying to run older releases of the External Secrets Operator on OpenShift
   clusters then you may see the following error status in any of the `ReplicaSet` resources:

      message: 'pods "external-secrets-6888645d7f-" is forbidden: unable to validate
      against any security context constraint: [provider "anyuid": Forbidden: not
      usable by user or serviceaccount, spec.containers[0].securityContext.runAsUser:
      Invalid value: 1000: must be in the ranges: [1001220000, 1001229999], provider
      "restricted": Forbidden: not usable by user or serviceaccount, provider "nonroot-v2":
      Forbidden: not usable by user or serviceaccount, provider "nonroot": Forbidden:
      not usable by user or serviceaccount, provider "hostmount-anyuid": Forbidden:
      not usable by user or serviceaccount, provider "machine-api-termination-handler":
      Forbidden: not usable by user or serviceaccount, provider "hostnetwork-v2":
      Forbidden: not usable by user or serviceaccount, provider "hostnetwork": Forbidden:
      not usable by user or serviceaccount, provider "hostaccess": Forbidden: not
      usable by user or serviceaccount, provider "node-exporter": Forbidden: not usable
      by user or serviceaccount, provider "privileged": Forbidden: not usable by user
      or serviceaccount]'

3. Verify the package installation by running:

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
