# Install Application Single Sign-On

This topic tells you how to install Application Single Sign-On for VMware Tanzu 
(commonly called AppSSO) from the Tanzu Application Platform (commonly called TAP) 
package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install Application Single Sign-On.
For more information about profiles, see [Components and installation profiles](../../../about-package-profiles.hbs.md).

## <a id="whats-inside"></a> What's inside

The AppSSO package installs the following resources:

- The `appsso` namespace with a deployment of the AppSSO controller and services for webhooks.
- [RBAC](../../reference/rbac.hbs.md)
- [APIs](../../reference/api/index.hbs.md)

## <a id="prereqs"></a> Prerequisites

Before installing Application Single Sign-On, ensure that you have Tanzu Application Platform
installed on your Kubernetes cluster.

The `sso.apps.tanzu.vmware.com` package has these dependencies:

- `cert-manager.tanzu.vmware.com`: Required at installation time and runtime.
  For more information see, [Install cert-manager](../../../cert-manager/install.hbs.md).

- `crossplane.tanzu.vmware.com`: Required at installation time and runtime.
  For more information see, [Install Crossplane](../../../crossplane/install-crossplane.hbs.md).

- `service-bindings.tanzu.vmware.com`: Required at runtime.
  For more information see, [Install Service Bindings](../../../service-bindings/install-service-bindings.hbs.md).

> **Important** Installation time dependencies must be present on the cluster at the time the
> Application Single Sign-On package is being applied.
>
> Runtime dependencies don't have to be present when the Application Single Sign-On package is
> being applied, but they are required eventually for it to function fully.

## <a id="install"></a> Install Application Single Sign-On for VMware Tanzu

1. Learn more about the AppSSO package by running:

   ```console
   tanzu package available get sso.apps.tanzu.vmware.com --namespace tap-install
   ```

1. Install the AppSSO package by running:

   ```console
   tanzu package install appsso \
     --namespace tap-install \
     --package sso.apps.tanzu.vmware.com \
     --version {{ vars.app-sso.version }}
   ```

1. Confirm the package has reconciled by running:

   ```console
   tanzu package installed get appsso --namespace tap-install
   ```

## <a id="see-also"></a> See also

- To configure the Application Single Sign-On package to meet your needs, see
[Package configuration for Application Single Sign-On](../../reference/package-configuration.hbs.md).

- To upgrade to a later version of the package, see [Upgrade Application Single Sign-On](upgrades.hbs.md).

- When deployed on an OpenShift cluster, additional OpenShift-specific resources are installed.
For more information, see [Application Single Sign-On for OpenShift clusters](../../reference/openshift.hbs.md).
