# Install Application Live View

This topic describes how to install Application Live View from the Tanzu Application Platform package
repository.

Application Live View installs three packages for `full`, `light`, and `iterate` profiles:

- For the `view` profile, Application Live View installs Application Live View Backend package (`backend.appliveview.tanzu.vmware.com`). This installs the Application Live View Backend component with Tanzu Application Platform GUI in `app-live-view` namespace.

- For the `run` profile, Application Live View installs Application Live View Connector package (`connector.appliveview.tanzu.vmware.com`). This installs the Application Live View Connector component as DaemonSet in `app-live-view-connector` namespace.

- For the `build` profile, Application Live View installs Application Live View Conventions package (`conventions.appliveview.tanzu.vmware.com`). This installs the Application Live View Convention Service in `app-live-view-conventions` namespace.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../../install.html).


## <a id='prereqs'></a>Prerequisites

Before installing Application Live View, complete all prerequisites to install Tanzu Application Platform.
For more information, see [Prerequisites](../../prerequisites.html).


## <a id='install-app-live-view'></a> Install Application Live View

You can install Application Live View in single cluster or multicluster environment:

- `Single cluster`: All Application Live View components are deployed in a single cluster. The user can access Application Live View plug-in information of the applications across all the namespaces in the Kubernetes cluster. This is the default mode of Application Live View.

- `Multicluster`: In a multicluster environment, the Application Live View Backend component is installed only once in a single cluster and exposes a RSocket registration for the other clusters using Tanzu shared ingress. Each cluster continues to install the connector as a DaemonSet. The connectors are configured to connect to the central instance of the Application Live View Backend.


## <a id='install-app-live-view-backend'></a> Install Application Live View Backend

To install Application Live View Backend:

1. List version information for the package by running:

    ```console
    tanzu package available list backend.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list backend.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for backend.appliveview.tanzu.vmware.com...
      NAME                                  VERSION        RELEASED-AT           
      backend.appliveview.tanzu.vmware.com  1.1.1          2022-04-22T00:00:10Z
    ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get backend.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example, `1.1.1`.

    For example:

    ```console
    $ tanzu package available get backend.appliveview.tanzu.vmware.com/1.1.1 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the properties listed earlier.

1. Create `app-live-view-backend-values.yaml` with the following details:

    For single cluster environment, use the following values:

    ```yaml
    ingressEnabled: "false"
    ```

    For a multicluster environment, use the following values:

    ```yaml
    ingressEnabled: "true"
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


1. Install the Application Live View Backend package by running:

    ```console
    tanzu package install appliveview -p backend.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-live-view-backend-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed.

    For example:

    ```console
    $ tanzu package install appliveview -p backend.appliveview.tanzu.vmware.com -v 1.1.1 -n tap-install -f app-live-view-backend-values.yaml
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

    >**Note:** The Application Live View Backend component is deployed in `app-live-view` namespace by default.

1. Verify the Application Live View Backend package installation by running:

    ```console
    tanzu package installed get appliveview -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview -n tap-install            
    \ Retrieving installation details for appliveview...
    NAME:                    appliveview
    PACKAGE-NAME:            backend.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.1.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.


## <a id='install-app-live-view-connector'></a> Install Application Live View Connector

To install Application Live View Connector:

1. List version information for the package by running:

    ```console
    tanzu package available list connector.appliveview.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list connector.appliveview.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for connector.appliveview.tanzu.vmware.com...
      NAME                                    VERSION        RELEASED-AT           
      connector.appliveview.tanzu.vmware.com  1.1.1          2022-04-22T00:00:10Z
    ```

1. (Optional) Change the default installation settings by running:

    ```console
    tanzu package available get connector.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example, `1.1.1`.

    For example:

    ```console
    $ tanzu package available get connector.appliveview.tanzu.vmware.com/1.1.1 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the properties listed earlier.


1. Create `app-live-view-connector-values.yaml` with the following details:

    For single cluster environment, use the following values:

    ```yaml
    backend:
        sslDisabled: "true"
    ```

    >**Note:** The Application Live View Connector connects to the `cluster-local` back end to register the applications.

    For a multicluster environment, use the following values:

    ```yaml
    backend:
        sslDisabled: "false"
        host: appliveview.INGRESS-DOMAIN
    ```

    Where `INGRESS-DOMAIN` is the top level domain the Application Live View Backend exposes by using `tanzu-shared-ingress` for the Connectors in other clusters to reach the back end. Prepend the `appliveview` subdomain to the provided value.

    The `sslDisabled` boolean flag is treated as a string in Kubernetes YAML.
    Therefore it must be specified in `double-quotes` for the configuration to be picked up.

    You can edit the values to suit your project needs or leave the default values as is.

    >**Note:** Using the HTTP proxy either on 80 or 443 based on SSL config exposes the Backend service running on port 7000. The connector connects to the Backend on port 80/443 by default. Therefore, you are not required to explicitly configure the `port` field.


1. Install the Application Live View Connector package by running:

    ```console
    tanzu package install appliveview-connector -p connector.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-live-view-connector-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example, `1.1.1`.

    For example:

    ```console
    $ tanzu package install appliveview-connector -p connector.appliveview.tanzu.vmware.com -v 1.1.1 -n tap-install -f app-live-view-connector-values.yaml
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

    >**Note:** Each cluster installs the connector as a DaemonSet. The connector is configured to connect to the central instance of the Backend. The Application Live View Connector component is deployed in `app-live-view-connector` namespace by default.

1. Verify the `Application Live View Connector` package installation by running:

    ```console
    tanzu package installed get appliveview-connector -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview-connector -n tap-install                                                                              5s
    | Retrieving installation details for appliveview-connector...
    NAME:                    appliveview-connector
    PACKAGE-NAME:            connector.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.1.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`


## <a id='install-app-live-view-conventions'></a> Install Application Live View Conventions

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
      conventions.appliveview.tanzu.vmware.com  1.1.1          2022-04-22T00:00:00Z
    ```

1. Install the Application Live View Conventions package by running:

    ```console
    tanzu package install appliveview-conventions -p conventions.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example, `1.1.1`.

    For example:

    ```console
    $ tanzu package install appliveview-conventions -p conventions.appliveview.tanzu.vmware.com -v 1.1.1 -n tap-install
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
    PACKAGE-VERSION:         1.1.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:

    ```

    Verify that `STATUS` is `Reconcile succeeded`


For more information about Application Live View,
see the [Application Live View documentation](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.2/docs/GUID-index.html).

The Application Live View UI plug-in is part of Tanzu Application Platform GUI.
To access the Application Live View UI,
see [Application Live View in Tanzu Application Platform GUI](app-live-view.html).
