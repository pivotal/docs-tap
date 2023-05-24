# Install default roles independently for your Tanzu Application Platform

This topic tells you how to install default roles for Tanzu Application Platform
(commonly known as TAP) without deploying a TAP profile.

>**Note** Follow the steps in this topic if you do not want to use a profile to install default roles.
For more information about profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing default roles, complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install'></a>Install

To install default roles:

1. List version information for the package by running:

    ```console
    tanzu package available list tap-auth.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list tap-auth.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for tap-auth.tanzu.vmware.com...
      NAME                         VERSION       RELEASED-AT
      tap-auth.tanzu.vmware.com    1.0.1
    ```

1. Install the package by running:

    ```console
    tanzu package install tap-auth \
      --package-name tap-auth.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install
    ```

    Where:

    - `VERSION` is the package version number. For example, `1.0.1`.

    For example:

    ```console
    $ tanzu package install tap-auth \
      --package-name tap-auth.tanzu.vmware.com \
      --version 1.0.1 \
      --namespace tap-install
    ```
