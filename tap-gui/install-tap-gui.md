# Install Tanzu Application Platform GUI

This topic describes how to install Tanzu Application Platform GUI if you have not done so by
installing Tanzu Application Platform through a Full or View profile.

Use the instructions on this page if you do not want to use a profile to install packages.

For more information about profiles, see
[About Tanzu Application Platform components and profiles](../about-package-profiles.md).


## <a id='prereqs'></a> Prerequisites

Before installing Tanzu Application Platform GUI:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see the
Tanzu Application Platform [Prerequisites](../prerequisites.html).
- Create a Git repository for Tanzu Application Platform GUI software catalogs, with a token allowing read access.
Supported Git infrastructure includes:
  - GitHub
  - GitLab
  - Azure DevOps
- Install Tanzu Application Platform GUI Blank Catalog
  1. Go to the [Tanzu Application Platform section of VMware Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/).
  1. Under the list of available files to download, open the **tap-gui-catalogs-latest** folder.
  1. Extract Tanzu Application Platform GUI Blank Catalog to your Git repository. This serves as the configuration location for your organization's Catalog inside Tanzu Application Platform GUI.


### <a id='tap-gui-install-proc'></a> Procedure

To install Tanzu Application Platform GUI on a compliant Kubernetes cluster:

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
    tanzu package available get tap-gui.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the number you discovered previously. For example, `1.0.1`.

    For more information about values schema options, see the individual product documentation.

1. Create `tap-gui-values.yaml` and paste in the following code:

    ```yaml
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

    - `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress` service's External IP address.
    - `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file from either the included Blank catalog (provided as an additional download named "Blank Tanzu Application Platform GUI Catalog") or a Backstage-compliant catalog that you've already built and posted on the Git infrastructure specified in [Adding Tanzu Application Platform GUI integrations](integrations.html).

1. Install the package by running:

    ```console
    tanzu package install tap-gui \
     --package-name tap-gui.tanzu.vmware.com \
     --version VERSION -n tap-install \
     -f tap-gui-values.yaml
    ```

    Where `VERSION` is the desired version. For example, `1.0.1`.

    For example:

    ```console
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

1. To access Tanzu Application Platform GUI, use the service you exposed in the `service_type`
field in the values file.
