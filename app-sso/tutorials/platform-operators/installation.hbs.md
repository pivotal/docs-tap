# Install Application Single Sign-On

This topic tells you how to install Application Single Sign-On for VMware Tanzu (commonly called AppSSO)
from the Tanzu Application Platform package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install Application Single Sign-On.
For more information about profiles, see [Components and installation profiles](../../../about-package-profiles.hbs.md).

## <a id="whats-inside"></a> What's inside

The AppSSO package installs the following resources:

- The `appsso` namespace with a deployment of the AppSSO controller and services for webhooks.
- [RBAC](../../reference/rbac.hbs.md)
- [APIs](../../reference/api/index.hbs.md)

## <a id="prereqs"></a> Prerequisites

Before installing AppSSO, please ensure you have Tanzu Application Platform
installed on your Kubernetes cluster.

In particular, the `sso.apps.tanzu.vmware.com` package has these dependencies:

* `cert-manager.tanzu.vmware.com` (installation-time and runtime)
* `crossplane.tanzu.vmware.com` (installation-time and runtime)
* `service-bindings.tanzu.vmware.com` (runtime)

> **Note**
> - Installation-time dependencies are expected to present on the cluster at
>   the moment the AppSSO package is being applied.
> - Runtime dependencies don't have to be present at the moment the AppSSO
>   package is being applied, but they are required eventually and needed to
>   function fully.

## <a id="install"></a> Installation

1. Learn more about the AppSSO package:

   ```shell
   tanzu package available get sso.apps.tanzu.vmware.com --namespace tap-install
   ```

1. Install the AppSSO package:

   ```shell
   tanzu package install appsso \
     --namespace tap-install \
     --package-name sso.apps.tanzu.vmware.com \
     --version {{ vars.app-sso.version }}
   ```

1. Confirm the package has reconciled successfully:

   ```shell
   tanzu package installed get appsso --namespace tap-install
   ```

## <a id="configure"></a> Configuration

For the AppSSO package to meet your needs, refer to the [package configuration
reference](../../reference/package-configuration.hbs.md).

## <a id="upgrade"></a> Upgrading Application Single Sign-On for VMware Tanzu

To successfully upgrade to a newer version of the package, refer to the
[upgrades reference](../../reference/upgrades.hbs.md).

## <a id="openshift"></a> About installing on OpenShift

When deployed on an OpenShift cluster, additional OpenShift-specific resources are installed.
For more information, see [Application Single Sign-On for OpenShift clusters](../../reference/openshift.hbs.md).
