# Install Application Single Sign-On

This topic tells you how to install Application Single Sign-On (commonly called AppSSO) 
from the Tanzu Application Platform package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install Application Single Sign-On.
For more information about profiles, see [Components and installation profiles](../../about-package-profiles.hbs.md).

## What's inside

The AppSSO package will install the following resources:

* The `appsso` Namespace with a Deployment of the AppSSO controller and Services for Webhooks
* A `ServiceAccount` with RBAC outlined in detail [here](./rbac.md)
* [AuthServer and ClientRegistration CRDs](../crds/index.md)

## Prerequisites

Before installing AppSSO, please ensure you have Tanzu Application Platform installed on your Kubernetes cluster.

## Installation

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
