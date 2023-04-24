# Install Application Configuration Service for VMware Tanzu

This topic tells you how to install Application Configuration Service for VMware Tanzu
(commonly known as App Config Service) from the Tanzu Application Platform package repository.

## <a id='prereqs'></a>Prerequisites

Before installing Application Configuration Service, complete all prerequisites to install
Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).

## <a id='install'></a> Install

To install Application Configuration Service on a compliant Kubernetes cluster:

1. List version information for the package by running:

   ```console
   tanzu package available list application-configuration-service.tanzu.vmware.com --namespace tap-install
   ```

   For example:

   ```console
   $ tanzu package available list application-configuration-service.tanzu.vmware.com --namespace tap-install
   - Retrieving package versions for application-configuration-service.tanzu.vmware.com...
   NAME                                                VERSION  RELEASED-AT
   application-configuration-service.tanzu.vmware.com  2.0.0    2023-03-08 19:00:00 -0500 EST
   ```

2. (Optional) Make changes to the default installation settings by running:

   ```console
   tanzu package available get application-configuration-service.tanzu.vmware.com/VERSION-NUMBER \
   --values-schema --namespace tap-install
   ```

   Where `VERSION-NUMBER` is the number you discovered previously. For example, `2.0.0`.

3. Install the package by running:

   ```console
   tanzu package install application-configuration-service \
   --package-name application-configuration-service.tanzu.vmware.com \
   --version VERSION -n tap-install \
   --values-file values.yaml
   ```

   Where `VERSION` is the version you want, such as `2.0.0`.
   Using a `values.yaml` file is optional.

   For example:

   ```console
   $ tanzu package install application-configuration-service \
   --package-name application-configuration-service.tanzu.vmware.com \
   --version 2.0.0 -n tap-install

   Installing package 'application-configuration-service.tanzu.vmware.com'
   Getting package metadata for 'application-configuration-service.tanzu.vmware.com'
   Creating service account 'application-configuration-service-tap-install-sa'
   Creating cluster admin role 'application-configuration-service-tap-install-cluster-role'
   Creating cluster role binding 'application-configuration-service-tap-install-cluster-rolebinding'
   Creating package resource
   Waiting for 'PackageInstall' reconciliation for 'application-configuration-service'
   'PackageInstall' resource install status: Reconciling
   'PackageInstall' resource install status: ReconcileSucceeded

   Added installed package 'application-configuration-service'
   ```

4. Verify that you installed the package by running:

   ```console
   tanzu package installed get application-configuration-service -n tap-install
   ```

   For example:

   ```console
   $ tanzu package installed get application-configuration-service -n tap-install

   NAME:                    application-configuration-service
   PACKAGE-NAME:            application-configuration-service.tanzu.vmware.com
   PACKAGE-VERSION:         2.0.0
   STATUS:                  Reconcile succeeded
   CONDITIONS:              [{ReconcileSucceeded True  }]
   USEFUL-ERROR-MESSAGE:
   ```