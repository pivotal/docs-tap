# Improved Security And Access Control in Application Live View

This topic describes how to enable improved security and access control in
Application Live View in the Tanzu Application Platform.

For more information on Appliction Live View packages, see [Install Application Live View](./install.hbs.md).

The improved security and access control is introduced in order to secure the REST API exposed by the Application Live View back-end. There is one instance of Application Live View back-end installed per `view` profile. Multiple users access this back-end API to fetch actuator data for different applications. All the REST API calls to the back-end are secured. A token needs to be passed to the Application Live View back-end on each call to REST API to fetch actuator data. This token is obtained from Application Live View Apiserver. The Application Live View Apiserver generates a unique token upon access validation of a user to a given pod. The Application Live View back-end passes this token to the Application Live View connector when requesting the actuator data. The Application Live View connector verifies this token by calling the Application Live View Apiserver and proxies the actuator data only if the token is valid. 

The Application Live View UI plug-in part of The Tanzu Application Platform GUI uses the above approach to securely query for the actuator data for a pod. It requests for a token from Application Live View Apiserver and passes it to the subsequent calls to the back-end. This ensures that actuator data from the running application is fetched only if the user is authorized to see the live information for the pod.

The Application Live View UI plug-in relies on Tanzu Application Platform GUI authentication and authroization to access the Application Live View Apiserver and fetch the application live view tokens.

The Tanzu Application Platform GUI controls the access to kubernetes resources based on user roles and permissions for each of the remote clusters. For more information on this, see [View runtime resources on authorization-enabled clusters](../tap-gui/tap-gui-rbac/view-resources-rbac.hbs.md).

For more information about how to set up unrestricted remote cluster visibility, see [Viewing resources on multiple clusters in Tanzu Application Platform GUI](../tap-gui/cluster-view-setup.hbs.md).


## <a id='prereqs'></a>Prerequisites

1. The Application Live View Apiserver package
(`apiserver.appliveview.tanzu.vmware.com`) package should be installed in Tanzu
Application Platform. For more information, see [Install Application Live View
Apiserver](./install.hbs.md).

1. The users are assigned necessary roles and permissions for the Kubernetes clusters. For more information on managing role based access control, see [Assign roles and permissions on Kubernetes clusters](../tap-gui/tap-gui-rbac/assigning-kubernetes-roles.hbs.md)

For example, If you are using Service Account to view resources on a cluster in Tanzu
Application Platform GUI, make sure the `ClusterRole` has rules to access and
request tokens from the Application Live View Apiserver.

```yaml
- apiGroups: ['appliveview.apps.tanzu.vmware.com']
  resources:
  - resourceinspectiongrants
  verbs: ['get', 'watch', 'list', 'create']
```

For more information, see [Set up a Service Account to view resources on a
cluster](../tap-gui/cluster-view-setup.hbs.md).

>**Note** With the Service Account approach to view resources on a cluster,
>every user with the Service Account Token with access to view the pods will be
>able to see the live information in Application Live View.


## <a id='improved-security'></a> Improved Security

The improved security feature is enabled by default for Application Live View.

In a Tanzu Application Platform profile install, the Application Live View
connector (`connector.appliveview.tanzu.vmware.com`) and the Tanzu Application
Platform GUI (`tap-gui.tanzu.vmware.com`) are automatically configured to enable
the secure communication between the Application Live View components.

This feature can be controlled by setting the top-level key
`shared.activateAppLiveViewSecureAccessControl` in the `tap-values.yml`.

For example:

```yaml
shared:
    activateAppLiveViewSecureAccessControl: true
```

If you want to override the security feature at the individual component level,
follow the below steps:

## <a id='app-live-view-connector'></a> Configure Security for Application Live View Connector

1. (Optional) Change the default installation settings for Application Live View
   connector by running:

    ```console
    tanzu package available get connector.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.0-build.5`.

    For example:

    ```console
    $ tanzu package available get connector.appliveview.tanzu.vmware.com/1.5.0-build.5 --values-schema --namespace tap-install
      KEY                                   DEFAULT             TYPE        DESCRIPTION
      kubernetes_version                                        string      Optional: The Kubernetes Version. Valid values are '1.24.*', or ''.

      backend.sslDeactivated                   false               boolean     Flag for whether to disable SSL.
      backend.caCertData                    cert-in-pem-format  string      CA Cert Data for ingress domain.
      backend.host                          <nil>               string      Domain to be used to reach the Application Live View back end. Prepend
                                                                            "appliveview" subdomain to the value if you are using shared ingress. For
                                                                            example: "example.com" becomes "appliveview.example.com".
      backend.ingressEnabled                false               boolean     Flag for the connector to connect to ingress on back end.

      backend.port                          <nil>               number      Port to reach the Application Live View back end.
      connector.namespace_scoped.enabled    false               boolean     Flag for the connector to run in namespace scope.
      connector.namespace_scoped.namespace  default             string      Namespace to deploy connector.
      kubernetes_distribution                                   string      Kubernetes distribution that this package is being installed on. Accepted
                                                                            values: ['''',''openshift''].
      activateAppLiveViewSecureAccessControl                    boolean     Optional: Configuration required to enable Secure Access Connection between App Live View components
      activateSensitiveOperations                               boolean     Optional: Configuration to allow connector to execute sensitive operations on a running application
    ```

    For more information about values schema options, see the properties listed
    earlier.


2. Create `app-live-view-connector-values.yaml` with the following details:

    If you want to override the default security settings for connector, use the
    following values:

     ```yaml
    activateAppLiveViewSecureAccessControl: false
    ```

    By default, activateAppLiveViewSecureAccessControl is set to `true`.

    The `activateSensitiveOperations` key enables/disables the execution of
    sensitive operations such as editing environment variables, download heap
    dump data, changing log levels for the applications in the cluster. It is
    set to `false` by default.

    To enable the sensitive operations, set the `activateSensitiveOperations` to
    `true`.

     ```yaml
    activateSensitiveOperations: true
    ```

3. Install the Application Live View connector package by running:

    ```console
    tanzu package install appliveview-connector -p connector.appliveview.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-live-view-connector-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.5.0-build.5`.

    For example:

    ```console
    $ tanzu package install appliveview-connector -p connector.appliveview.tanzu.vmware.com -v 1.5.0-build.5 -n tap-install -f app-live-view-connector-values.yaml
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

4. Verify the `Application Live View connector` package installation by running:

    ```console
    tanzu package installed get appliveview-connector -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get appliveview-connector -n tap-install                                                                              5s
    | Retrieving installation details for appliveview-connector...
    NAME:                    appliveview-connector
    PACKAGE-NAME:            connector.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.5.0-build.5
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

## <a id='app-live-view-ui-plugin'></a> Configure Security for Application Live View UI plug-in

The Application Live View UI plug-in is part of Tanzu Application Platform GUI.
To override the default security settings for the Application Live View UI
plug-in, follow the below steps:

1. (Optional) Make changes to the default installation settings by running:

    ```console
    tanzu package available get tap-gui.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the number you discovered previously. For example,
    `1.4.6`.

    For more information about values schema options, see the individual product
    documentation.

1. Create `tap-gui-values.yaml` and paste in the following code:

    ```yaml
    service_type: ClusterIP
    ingressEnabled: true
    ingressDomain: "INGRESS-DOMAIN"
    app_config:
      catalog:
        locations:
          - type: url
            target: https://GIT-CATALOG-URL/catalog-info.yaml
      appLiveView:
        activateAppLiveViewSecureAccessControl: false
    ```

    Where:

    - `INGRESS-DOMAIN` is the subdomain for the host name that you point at the
      `tanzu-shared-ingress` service's External IP address.
    - `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog
      definition file from either the included Blank catalog (provided as an
      additional download named "Blank Tanzu Application Platform GUI Catalog")
      or a Backstage-compliant catalog that you've already built and posted on
      the Git infrastructure specified in [Add Tanzu Application Platform GUI
      integrations](../tap-gui/integrations.hbs.md).

2. Install the package by running:

    ```console
    tanzu package install tap-gui \
     --package-name tap-gui.tanzu.vmware.com \
     --version VERSION -n tap-install \
     -f tap-gui-values.yaml
    ```

    Where `VERSION` is the desired version. For example, `1.4.6`.

    For example:

    ```console
    $ tanzu package install tap-gui -package-name tap-gui.tanzu.vmware.com --version 1.4.6 -n tap-install -f tap-gui-values.yaml
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

3. Verify that the package installed by running:

    ```console
    tanzu package installed get tap-gui -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get tap-gui -n tap-install
    | Retrieving installation details for cc...
    NAME:                    tap-gui
    PACKAGE-NAME:            tap-gui.tanzu.vmware.com
    PACKAGE-VERSION:         1.4.6
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

4. To access Tanzu Application Platform GUI, use the service you exposed in the
`service_type` field in the values file.
