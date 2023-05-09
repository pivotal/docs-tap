# Install Tanzu Portal Builder

This topic tells you how to install Tanzu Portal Builder from the Tanzu Application Platform package
repository.

Follow the steps in this topic if you do not want to use a profile to install Tanzu Portal Builder.
For more information about profiles, see
[Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a> Prerequisites

Before installing Tanzu Portal Builder, complete all prerequisites to install
Tanzu Application Platform. For more information, see the Tanzu Application Platform
[prerequisites](../prerequisites.hbs.md).

## <a id='install'></a> Install Tanzu Portal Builder

To install Tanzu Portal Builder on a compliant Kubernetes cluster:

1. List version information for the package by running:

    ```console
    tanzu package available list tanzu-portal-builder.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list tanzu-portal-builder.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for tanzu-portal-builder.tanzu.vmware.com...
      NAME                      VERSION     RELEASED-AT
      tanzu-portal-builder.tanzu.vmware.com  1.0.1       2023-01-10T13:14:23Z
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get tanzu-portal-builder.tanzu.vmware.com/VERSION-NUMBER --values-schema \
    --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the number you discovered previously. For example, `1.0.1`.
    For more information about values schema options, see the individual product documentation.

1. Create `tanzu-portal-builder-values.yaml` and paste in the following code:

    ```yaml
    (code section to be added)
    ```

    Where:

    - (section to be added)

1. Install the package by running:

    ```console
    tanzu package install tanzu-portal-builder \
     --package-name tanzu-portal-builder.tanzu.vmware.com \
     --version VERSION -n tap-install \
     -f tanzu-portal-builder-values.yaml
    ```

    Where `VERSION` is the version that you want. For example, `1.0.1`.

    For example:

    ```console
    $ tanzu package install tanzu-portal-builder -package-name tanzu-portal-builder.tanzu.vmware.com --version 1.0.1 -n tap-install -f tanzu-portal-builder-values.yaml
    - Installing package 'tanzu-portal-builder.tanzu.vmware.com'
    | Getting package metadata for 'tanzu-portal-builder.tanzu.vmware.com'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'tanzu-portal-builder' in namespace 'tap-install'
    ```

1. Verify that the package installed by running:

    ```console
    tanzu package installed get tanzu-portal-builder -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get tanzu-portal-builder -n tap-install
    | Retrieving installation details for cc...
    NAME:                    tanzu-portal-builder
    PACKAGE-NAME:            tanzu-portal-builder.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

## <a id="next-steps"></a> Next steps

To start using Tanzu Portal Builder, proceed to
[Create your customized portal](create-custom-dev-portal.hbs.md).
