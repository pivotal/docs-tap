# Install Service Registry

This topic tells you how to install Service Registry from the Tanzu Application Platform
(commonly known as TAP) package repository.

## <a id='prereqs'></a> Prerequisites

Before installing Service Registry, you must:

- Fulfill all [prerequisites for installing Tanzu Application Platform](../prerequisites.hbs.md)
- [Install Cert Manager](../cert-manager/install.hbs.md)

## <a id='install'></a> Install

To install Service Registry on a compliant Kubernetes cluster:

1. List version information for the package by running:

   ```console
   tanzu package available list service-registry.spring.apps.tanzu.vmware.com --namespace tap-install
   ```

   For example:

   ```console
   $ tanzu package available list service-registry.spring.apps.tanzu.vmware.com --namespace tap-install
   NAME                                                VERSION  RELEASED-AT
   service-registry.spring.apps.tanzu.vmware.com       1.2.0    2023-09-12 19:00:00 -0500 EST
   ```

2. Install the package by running:

   ```console
   tanzu package install service-registry \
   --package service-registry.spring.apps.tanzu.vmware.com \
   --version VERSION -n tap-install
   ```

   Where `VERSION` is the version you want, such as `1.2.0`.

   For example:

   ```console
   $ tanzu package install service-registry \
   --package service-registry.spring.apps.tanzu.vmware.com \
   --version 1.2.0 -n tap-install

    / Installing package 'service-registry.spring.apps.tanzu.vmware.com'
    | Getting namespace 'eureka-system'
    | Getting package metadata for 'service-registry.spring.apps.tanzu.vmware.com'
    | Creating service account 'service-registry-sa'
    | Creating cluster admin role 'service-registry-cluster-role'
    | Creating cluster role binding 'service-registry-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling


    Added installed package 'service-registry' in namespace 'tap-install'
   ```

   > **Note** Because there are no customization options at this time, there is no need to include a
   > `--values-file` option.

3. Verify that you installed the package by running:

   ```console
   tanzu package installed get service-registry -n tap-install
   ```

   For example:

   ```console
   $ tanzu package installed get service-registry -n tap-install

   NAMESPACE:          tap-install
   NAME:               service-registry
   PACKAGE-NAME:       service-registry.spring.apps.tanzu.vmware.com
   PACKAGE-VERSION:    1.2.0
   STATUS:             Reconcile succeeded
   CONDITIONS:         - type: ReconcileSucceeded
      status: "True"
      reason: ""
      message: ""
   ```
