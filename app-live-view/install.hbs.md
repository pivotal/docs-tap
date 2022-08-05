# Install Application Live View

This topic describes how to install Application Live View from the Tanzu Application Platform package repository.

Application Live View installs three packages for `full`, `light`, and `iterate` profiles:

- For the `view` profile, Application Live View installs Application Live View back-end package (`backend.appliveview.tanzu.vmware.com`). This installs the Application Live View back-end component with Tanzu Application Platform GUI in `app-live-view` namespace.

- For the `run` profile, Application Live View installs Application Live View connector package (`connector.appliveview.tanzu.vmware.com`). This installs the Application Live View connector component as DaemonSet in `app-live-view-connector` namespace.

- For the `build` profile, Application Live View installs Application Live View Conventions package (`conventions.appliveview.tanzu.vmware.com`). This installs the Application Live View Convention Service in `app-live-view-conventions` namespace.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).


## <a id='prereqs'></a>Prerequisites

Before installing Application Live View, complete all prerequisites to install Tanzu Application Platform.
For more information, see [Prerequisites](../prerequisites.md).

In addition, install Cartographer Conventions which is bundled with Supply Chain Choreographer as of the v0.4.0 release. To install, see [Installing Supply Chain Choreographer](../scc/install-scc.md). For more information, see [Cartographer Conventions](../cartographer-conventions/about.md). 

## <a id='install-app-live-view'></a> Install Application Live View

You can install Application Live View in single cluster or multicluster environment:

- `Single cluster`: All Application Live View components are deployed in a single cluster. The user can access Application Live View plug-in information of the applications across all the namespaces in the Kubernetes cluster. This is the default mode of Application Live View.

- `Multicluster`: In a multicluster environment, the Application Live View back-end component is installed only once in a single cluster and exposes a RSocket registration for the other clusters using Tanzu shared ingress. Each cluster continues to install the connector as a DaemonSet. The connectors are configured to connect to the central instance of the Application Live View back end.


## <a id='install-app-live-view-back-end'></a> Install Application Live View back end

To install Application Live View back end:

1. List version information for the package by running:

    ```console
    tanzu package available list backend.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list backend.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for backend.appliveview.tanzu.vmware.com...
      NAME                                  VERSION        RELEASED-AT           
      backend.appliveview.tanzu.vmware.com  1.2.0-build.2  2022-06-01T00:00:10Z
    ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get backend.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example, `1.2.0-build.2`.

    For example:

    ```console
    $ tanzu package available get backend.appliveview.tanzu.vmware.com/1.2.0-build.2 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the properties listed earlier.

1. Create `app-live-view-backend-values.yaml` with the following details:

    For a SINGLE-CLUSTER environment, the Application Live View back end is exposed through the Kubernetes cluster service.

    >**Note:** If it is a Tanzu Application Platform profile installation and top-level key `shared.ingress_domain` is set in the `tap-values.yml`, the back end is automatically exposed through the ingress. The following configurations are applied by default:

    ```yaml
    ingressEnabled: true
    ingress_domain: ${shared.ingress_domain}
    ```

    For a MULTI-CLUSTER environment, Tanzu Application Platform uses the `shared.ingress_domain` by default.
    You can override this setting with the following values:

    ```yaml
    ingressEnabled: true
    ingressDomain: ${INGRESS-DOMAIN}
    ```

    Where `INGRESS-DOMAIN` is the top level domain you use for the `tanzu-shared-ingress` service’s
    external IP address. The `appliveview` subdomain is prepended to the value provided.

    To configure TLS certificate delegation information for the domain, add the following values to
    `app-live-view-backend-values.yaml`:

    ```yaml
    tls:
        namespace: "NAMESPACE"
        secretName: "SECRET NAME"
    ```

    Where:

    - `NAMESPACE` is the targeted namespace of TLS secret for the domain.
    - `SECRET NAME` is the name of TLS secret for the domain.

    You can edit the values to suit your project needs or leave the default values as is.


1. Install the Application Live View back-end package by running:

    ```console
    tanzu package install appliveview -p backend.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-live-view-backend-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed.

    For example:

    ```console
    $ tanzu package install appliveview -p backend.appliveview.tanzu.vmware.com -v 1.2.0-build.2 -n tap-install -f app-live-view-backend-values.yaml
    - Installing package 'backend.appliveview.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'backend.appliveview.tanzu.vmware.com'
    | Creating service account 'appliveview-tap-install-sa'
    | Creating cluster admin role 'appliveview-tap-install-cluster-role'
    | Creating cluster role binding 'appliveview-tap-install-cluster-rolebinding'
    | Creating package resource
    | Package install status: Reconciling

    Added installed package 'appliveview' in namespace 'tap-install'
    ```

    >**Note:** The Application Live View back-end component is deployed in `app-live-view` namespace by default.

1. Verify the Application Live View back-end package installation by running:

    ```console
    tanzu package installed get appliveview -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview -n tap-install            
    \ Retrieving installation details for appliveview...
    NAME:                    appliveview
    PACKAGE-NAME:            backend.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.2.0-build.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

## <a id='install-alv-connector'></a> Install Application Live View connector

To install Application Live View connector:

1. List version information for the package by running:

    ```console
    tanzu package available list connector.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list connector.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for connector.appliveview.tanzu.vmware.com...
      NAME                                    VERSION        RELEASED-AT           
      connector.appliveview.tanzu.vmware.com  1.2.0-build.2  2022-06-01T00:00:10Z
    ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get connector.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example, `1.2.0-build.2`.

    For example:

    ```console
    $ tanzu package available get connector.appliveview.tanzu.vmware.com/1.2.0-build.2 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the properties listed earlier.

1. Create `app-live-view-connector-values.yaml` with the following details:

    For SINGLE-CLUSTER environment, the Application Live View connector connects to the `cluster-local` Application Live View back end to register the applications.

    >**Note:** If it is a Tanzu Application Platform profile installation and top-level key `shared.ingress_domain` is set in the `tap-values.yml`, the Application Live View connector and Application Live View back end are configured to communicate through ingress. The the Application Live View connector uses the `shared.ingress_domain` to reach the back end.

    When using `shared.ingress_domain`, unless you enable TLS in the appliveview (Application Live View back end), set:

    ```yaml
    backend:
        sslDisabled: false
    ```

    For a MULTI-CLUSTER environment, use the following values:

    ```yaml
    backend:
        sslDisabled: false
        host: appliveview.INGRESS-DOMAIN
    ```

    Where `INGRESS-DOMAIN` is the top level domain the Application Live View back end exposes by using `tanzu-shared-ingress` for the connectors in other clusters to reach the Application Live View back end. Prepend the `appliveview` subdomain to the provided value.

    >**Note:** The `backend.sslDisabled` is set to `false` by default. If TLS is not enabled for the `INGRESS-DOMAIN` in the Application Live View back end, set the `backend.sslDisabled` to `true`.

    >**Note:** If it is a Tanzu Application Platform profile installation and top-level key `shared.ingress_domain` is set in the `tap-values.yml`, the Application Live View connector is automatically configured to use the `shared.ingress_domain` to reach the Application Live View back end.    


    You can edit the values to suit your project needs or leave the default values as is.

    >**Note:** Using the HTTP proxy either on 80 or 443 based on SSL config exposes the back-end service running on port 7000. The connector connects to the back end on port 80/443 by default. Therefore, you are not required to explicitly configure the `port` field.


1. Install the Application Live View connector package by running:

    ```console
    tanzu package install appliveview-connector -p connector.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-live-view-connector-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example, `1.2.0-build.2`.

    For example:

    ```console
    $ tanzu package install appliveview-connector -p connector.appliveview.tanzu.vmware.com -v 1.2.0-build.2 -n tap-install -f app-live-view-connector-values.yaml
    | Installing package 'connector.appliveview.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'connector.appliveview.tanzu.vmware.com'
    | Creating service account 'appliveview-connector-tap-install-sa'
    | Creating cluster admin role 'appliveview-connector-tap-install-cluster-role'
    | Creating cluster role binding 'appliveview-connector-tap-install-cluster-rolebinding'
    - Creating package resource
    / Package install status: Reconciling

    Added installed package 'appliveview-connector' in namespace 'tap-install'
    ```

    >**Note:** Each cluster installs the connector as a DaemonSet. The connector is configured to connect to the central instance of the back end. The Application Live View connector component is deployed in `app-live-view-connector` namespace by default.

1. Verify the `Application Live View connector` package installation by running:

    ```console
    tanzu package installed get appliveview-connector -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview-connector -n tap-install                                                                              5s
    | Retrieving installation details for appliveview-connector...
    NAME:                    appliveview-connector
    PACKAGE-NAME:            connector.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.2.0-build.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

## <a id='install-alv-conventions'></a> Install Application Live View Conventions

To install Application Live View Conventions:

1. List version information for the package by running:

    ```console
    tanzu package available list conventions.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list conventions.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for conventions.appliveview.tanzu.vmware.com...
      NAME                                      VERSION        RELEASED-AT           
      conventions.appliveview.tanzu.vmware.com  1.2.0-build.2  2022-06-01T00:00:00Z
    ```

1. Install the Application Live View Conventions package by running:

    ```console
    tanzu package install appliveview-conventions -p conventions.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example, `1.2.0-build.2`.

    For example:

    ```console
    $ tanzu package install appliveview-conventions -p conventions.appliveview.tanzu.vmware.com -v 1.2.0-build.2 -n tap-install
    - Installing package 'conventions.appliveview.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'conventions.appliveview.tanzu.vmware.com'
    | Creating service account 'appliveview-conventions-tap-install-sa'
    | Creating cluster admin role 'appliveview-conventions-tap-install-cluster-role'
    | Creating cluster role binding 'appliveview-conventions-tap-install-cluster-rolebinding'
    - Creating package resource
    \ Package install status: Reconciling

    Added installed package 'appliveview-conventions' in namespace 'tap-install'
    ```

1. Verify the package install for Application Live View Conventions package by running:

    ```console
    tanzu package installed get appliveview-conventions -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview-conventions -n tap-install
    | Retrieving installation details for appliveview-conventions...
    NAME:                    appliveview-conventions
    PACKAGE-NAME:            conventions.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.2.0-build.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:

    ```

    Verify that `STATUS` is `Reconcile succeeded`.


The Application Live View UI plug-in is part of Tanzu Application Platform GUI.
To access the Application Live View UI,
see [Application Live View in Tanzu Application Platform GUI](../tap-gui/plugins/app-live-view.md).
