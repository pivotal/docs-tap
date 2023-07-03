# Install Tanzu Developer Portal

This topic tells you how to install Tanzu Developer Portal (commonly called TAP GUI) from
the Tanzu Application Platform package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install
> Tanzu Developer Portal.
> For more information about profiles, see
> [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a> Prerequisites

Before installing Tanzu Developer Portal:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see the
  Tanzu Application Platform [Prerequisites](../prerequisites.hbs.md).
- Create a Git repository for Tanzu Developer Portal software catalogs, with a token allowing
  read access. Supported Git infrastructure includes:
  - GitHub
  - GitLab
  - Azure DevOps
- Install Tanzu Developer Portal Blank Catalog
  1. Go to the [Tanzu Application Platform section of VMware Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
  2. Under the list of available files to download, open the **tap-gui-catalogs-latest** folder.
  3. Extract Tanzu Developer Portal Blank Catalog to your Git repository.
     This serves as the configuration location for your organization's Catalog inside
     Tanzu Developer Portal.

### <a id='tap-gui-install-proc'></a> Procedure

To install Tanzu Developer Portal on a compliant Kubernetes cluster:

1. List version information for the package by running:

    ```console
    tanzu package available list tap-gui.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list tap-gui.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for tap-gui.tanzu.vmware.com...
      NAME                      VERSION     RELEASED-AT
      tap-gui.tanzu.vmware.com  1.0.1       2022-01-10T13:14:23Z
    ```

1. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get tap-gui.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace \
    tap-install
    ```

    Where `VERSION-NUMBER` is the number you discovered previously. For example, `1.0.1`.

    For more information about values schema options, see the individual product documentation.

1. Create `tap-gui-values.yaml` and paste in the following YAML:

    ```yaml
    ingressEnabled: true
    ingressDomain: "INGRESS-DOMAIN"
    app_config:
      catalog:
        locations:
          - type: url
            target: https://GIT-CATALOG-URL/catalog-info.yaml
    ```

    Where:

    - `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
      service's External IP address.
    - `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file.
      It is from either the included Blank catalog (provided as an additional download named
      **Blank Tanzu Developer Portal Catalog**) or a Backstage-compliant catalog that you've
      already built and posted on the Git infrastructure specified in
      [Adding Tanzu Developer Portal integrations](integrations.hbs.md).

1. Install the package by running:

    ```console
    tanzu package install tap-gui \
     --package-name tap-gui.tanzu.vmware.com \
     --version VERSION -n tap-install \
     -f tap-gui-values.yaml
    ```

    Where `VERSION` is the version that you want. For example, `1.0.1`.

    For example:

    ```console
    $ tanzu package install tap-gui -package-name tap-gui.tanzu.vmware.com --version 1.0.1 -n \
    tap-install -f tap-gui-values.yaml
    - Installing package 'tap-gui.tanzu.vmware.com'
    | Getting package metadata for 'tap-gui.tanzu.vmware.com'
    | Creating service account 'tap-gui-default-sa'
    | Creating cluster admin role 'tap-gui-default-cluster-role'
    | Creating cluster role binding 'tap-gui-default-cluster-rolebinding'
    | Creating secret 'tap-gui-default-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'tap-gui' in namespace 'tap-install'
    ```

1. Verify that the package installed by running:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get tap-gui -n tap-install
    | Retrieving installation details for cc...
    NAME:                    tap-gui
    PACKAGE-NAME:            tap-gui.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

1. To access Tanzu Developer Portal, use the service you exposed in the `service_type` field
   in the values file.
