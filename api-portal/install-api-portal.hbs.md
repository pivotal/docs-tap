# Install Tanzu API portal

This topic tells you how to install Tanzu API portal for VMware Tanzu
from the Tanzu Application Platform (commonly known as TAP) package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install API portal.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing Tanzu API portal:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install'></a> Install

To install Tanzu API portal:

1. Check what versions of API portal are available to install by running:

    ```console
    tanzu package available list -n tap-install api-portal.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list api-portal.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for api-portal.tanzu.vmware.com...
      NAME                         VERSION  RELEASED-AT
      api-portal.tanzu.vmware.com  1.0.3    2021-10-13T00:00:00Z
    ```

2. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get api-portal.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1.

    For example:

    ```console
    $ tanzu package available get api-portal.tanzu.vmware.com/1.0.3 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the individual product documentation.

3. Install API portal by running:

    ```console
    tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.3
    ```

    For example:

    ```console
    $ tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.3

    / Installing package 'api-portal.tanzu.vmware.com'
    | Getting namespace 'api-portal'
    | Getting package metadata for 'api-portal.tanzu.vmware.com'
    | Creating service account 'api-portal-api-portal-sa'
    | Creating cluster admin role 'api-portal-api-portal-cluster-role'
    | Creating cluster role binding 'api-portal-api-portal-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling


    Added installed package 'api-portal' in namespace 'tap-install'
    ```
