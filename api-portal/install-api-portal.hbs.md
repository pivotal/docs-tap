# Install API portal for VMware Tanzu

This topic tells you how to install and update Tanzu API portal for VMware Tanzu
from the Tanzu Application Platform (commonly known as TAP) package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install API portal.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing API portal:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install'></a> Install

To install the API portal package:

1. Confirm what versions of API portal are available to install by running:

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

2. (Optional) Gather values schema.

    ```console
    tanzu package available get api-portal.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed earlier.

    For example:

    ```console
    $ tanzu package available get api-portal.tanzu.vmware.com/1.0.3 --values-schema --namespace tap-install

    Retrieving package details for api-portal.tanzu.vmware.com/1.0.3...

    ```

3. (Optional) VMware recommends creating `api-portal-values.yaml`.

   To overwrite the default values when installing the package, create a `api-portal-values.yaml` file following the values schema.

4. Install API portal by running:

    ```console
    tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v $VERSION --values-file api-portal-values.yaml
    ```

    For example:

    ```console
    $ tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.3 --values-file api-portal-values.yaml

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

5. Verify the package installation by running:

    ```console
    tanzu package installed get api-portal -n tap-install
    ```

   Verify that `STATUS` is `Reconcile succeeded`:

    ```console
    kubectl get pods -n api-portal
    ```

## <a id='update-values'></a>Update the installation values for the `api-portal` package

To update the installation values for the `api-portal` package:

1. To overwrite the default values, create new values, or update the existing values, you need an
   `api-portal-values.yaml` file. If you do not already have an existing values file, you can extract the existing values by running:

    ```console
    tanzu package installed get api-portal -n tap-install -f api-portal-values.yaml
    ```

   For reference, you can view the schema of the package:

    ```console
    tanzu package available get apis.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

   Where `VERSION-NUMBER` is the version of the package listed in the earlier step.

   For example:

    ```console
    tanzu package available get api-portal.tanzu.vmware.com/1.2.5 --values-schema --namespace tap-install
   ```

2. Now, update the package using the Tanzu CLI:

    ```console
    tanzu package installed update api-auto-registration
    --package-name apis.apps.tanzu.vmware.com
    --namespace tap-install
    --version $VERSION
    --values-file api-portal-values.yaml
    ```

3. If you installed the API portal package as part of Tanzu Application Platform, you must update the `tap-values.yaml` and update the installation of Tanzu Application Platform.
See [Install your Tanzu Application Platform profile](../install-online/profile.hbs.md#install-profile).

3. If you installed the API portal package as part of Tanzu Application Platform, you must update the `tap-values.yaml` and update the TAP installation.
   See [Install your Tanzu Application Platform profile](../install-online/profile.hbs.md#install-profile).

>**Note** You can update API portal as part of upgrading Tanzu Application Platform. See [Upgrading Tanzu Application Platform](../upgrading.hbs.md).
