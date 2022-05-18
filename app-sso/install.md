# Install Application Single Sign-On

This document describes how to install Application Single Sign-On
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use the full profile to install packages.
>Application Single Sign-On is included in `run`, `iterate`, and `full` profiles.
>For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

To install Application Single Sign-On, see the following sections.

For general information about Application Single Sign-On, see [Application Single Sign-On for VMware Tanzu](app-sso/about.md).

## <a id='prereqs'></a>Prerequisites

Before installing Application Single Sign-On, ensure to install [Tanzu Application Platform v1.1.x](install-intro.md) on your preferred Kubernetes cluster with either of the following profiles: `run`, `iterate`, or `full`.

### <a id='install'></a>Install

To install Application Single Sign-On:

1. Add your [Tanzu Network](https://dev.registry.tanzu.vmware.com) registry credentials to the cluster:

    ```shell
    tanzu secret registry add appsso-registry \
     --username <YOUR-TANZU-NET-USERNAME> \
     --password <YOUR-TANZU-NET-PASSWORD> \
     --server dev.registry.tanzu.vmware.com \
     --export-to-all-namespaces
    ```

1. Install the AppSSO package repository:

    ```shell
    tanzu package repository add appsso-package-repository \
      --namespace tap-install \
      --url dev.registry.tanzu.vmware.com/sso-for-kubernetes/sso4k8s-carvel-package-repository:1.0.0-beta.1
    ```

    For previous versions,
    check the available package versions [here](https://dev.registry.tanzu.vmware.com/harbor/projects/169/repositories/sso4k8s-carvel-package-repository)

1. Learn more about the AppSSO package:

    ```shell
    tanzu package available get sso.apps.tanzu.vmware.com --namespace tap-install
    ```

1. Install the AppSSO package:

    ```shell
    tanzu package install appsso \
     --namespace tap-install \
     --package-name sso.apps.tanzu.vmware.com \
     --version 1.0.0-beta.1
    ```
