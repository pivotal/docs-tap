# Install Tanzu Application Platform GUI

This document describes how to install Tanzu Application Platform GUI
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Tanzu Application Platform GUI.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

To install Tanzu Application Platform GUI, see the following sections.

## <a id='prereqs'></a>Prerequisites

Before installing Tekton:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Git repository for Tanzu Application Platform GUI's software catalogs, with a token allowing read access.
  Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Tanzu Application Platform GUI Blank Catalog from the Tanzu Application section of Tanzu Network
  - To install, navigate to [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/). Under the list of available files to download, there is a folder titled `tap-gui-catalogs-latest`. Inside that folder is a compressed archive titled `Tanzu Application Platform GUI Blank Catalog`. You must extract that catalog to the preceding Git repository of choice. This serves as the configuration location for your Organization's Catalog inside Tanzu Application Platform GUI.
- The Tanzu Application Platform GUI catalog allows for two approaches towards storing catalog information:
    - The default option uses an in-memory database and is suitable for test and development scenarios.
          The in-memory database reads the catalog data from Git URLs that you enter in the `tap-values.yml` file.
          This data is temporary, and any operations that cause the `server` Pod in the `tap-gui` namespace to be re-created
          also cause this data to be rebuilt from the Git location.
          This can cause issues when you manually register entities by using the UI because
          they only exist in the database and are lost when that in-memory database gets rebuilt.
    - For production use-cases, use a PostgreSQL database that exists outside the
          Tanzu Application Platform packaging.
          The PostgreSQL database stores all the catalog data persistently both from the Git locations
          and the UI manual entity registrations. For more information, see
          [Configuring the Tanzu Application Platform GUI database](database.md)

### <a id='tap-gui-install-proc'></a> Procedure

To install Tanzu Application Platform GUI:

1. List version information for the package by running:

    ```
    tanzu package available list tap-gui.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list tap-gui.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for tap-gui.tanzu.vmware.com...
      NAME                      VERSION     RELEASED-AT
      tap-gui.tanzu.vmware.com  1.0.1  2022-01-10T13:14:23Z
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```
    tanzu package available get tap-gui.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the number you discovered previously. For example, `1.0.1`.

    For more information about values schema options, see the individual product documentation.

1. Create `tap-gui-values.yaml` using the following example code, replacing all placeholders
with your relevant values. The meanings of some placeholders are explained in this example:

    ```
    service_type: ClusterIP
    ingressEnabled: "true"
    ingressDomain: "INGRESS-DOMAIN"
    app_config:
      app:
        baseUrl: http://tap-gui.INGRESS-DOMAIN
      catalog:
        locations:
          - type: url
            target: https://GIT-CATALOG-URL/catalog-info.yaml
      backend:
        baseUrl: http://tap-gui.INGRESS-DOMAIN
        cors:
          origin: http://tap-gui.INGRESS-DOMAIN
      ```

    Where:

    - `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's External IP address.
   - `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file from either the included Blank catalog (provided as an additional download named "Blank Tanzu Application Platform GUI Catalog") or a Backstage-compliant catalog that you've already built and posted on the Git infrastructure specified in the Integration section.

1. Install the package by running:

    ```
    tanzu package install tap-gui \
     --package-name tap-gui.tanzu.vmware.com \
     --version VERSION -n tap-install \
     -f tap-gui-values.yaml
    ```

    Where `VERSION` is the desired version. For example, `1.0.1`.

    For example:

    ```
    $ tanzu package install tap-gui -package-name tap-gui.tanzu.vmware.com --version 1.0.1 -n tap-install -f tap-gui-values.yaml
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

    ```
    tanzu package installed get tap-gui -n tap-install
    ```

    For example:

    ```
    $ tanzu package installed get tap-gui -n tap-install
    | Retrieving installation details for cc...
    NAME:                    tap-gui
    PACKAGE-NAME:            tap-gui.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

1. To access Tanzu Application Platform GUI, use the service you exposed in the `service_type`
field in the values file.
