# Install Application Single Sign-On

This document describes how to install Application Single Sign-On (AppSSO) from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages. 
Both the run, iterate and full profiles include AppSSO. 
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

## <a id="installation"></a>Installation

1. Learn more about the AppSSO package:

    ```shell
    tanzu package available get sso.apps.tanzu.vmware.com --namespace tap-install
    ```

1. Install the AppSSO package:

    ```shell
    tanzu package install appsso \
     --namespace tap-install \
     --package-name sso.apps.tanzu.vmware.com \
     --version 1.0.0
    ```

1. Confirm the package has reconciled successfully:

    ```shell
    tanzu package installed get appsso --namespace tap-install
    ```

## <a id="see-also"></a>See also

- [AppSSO for Platform Operators documentation](https://docs.vmware.com/en/Application-Single-Sign-On-for-VMware-Tanzu/1.0/appsso/GUID-platform-operators-index.html).
