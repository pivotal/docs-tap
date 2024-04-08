# Install Application Live View Connector as a Service

This topic tells you how to install Application Live View Connector as a service from the Tanzu Application Platform
(commonly known as TAP) package repository.

## <a id='connector-as-a-service-overview'></a>Security and access control overview

This section outlines advancements in the communication strategy between view and run clusters within the system. The primary objective is on minimizing bi-directional communication between view and run clusters. This approach involves replacing the current RSocket communication channel with a standard HTTPS-based request/response mechanism. This change enables the connector component in run clusters to offer a REST API instead of establishing an RSocket channel to the backend located in the view cluster. The backend will then interact with the exposed ALV connector service in the run cluster to retrieve actuator data for an application.

## <a id='prereqs'></a>Prerequisites

Before installing Application Live View:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see
[Prerequisites](../prerequisites.md).

- Install Cartographer Conventions, which is bundled with Supply Chain Choreographer as of v0.5.3.
  To install, see [Installing Supply Chain Choreographer](../scc/install-scc.md).
  For more information, see [Cartographer Conventions](../cartographer-conventions/about.md).

## <a id='install-alv-connector-as-a-service'></a> Install Application Live View connector

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
      connector.appliveview.tanzu.vmware.com  1.10.0         2024-05-03T00:00:00Z
    ```

1. Create the file `app-live-view-connector-values.yaml` using the following details:

    To enable the connector component to expose a REST API and facilitate communication with the backend, follow these steps:

    - Enable Connector Deployment mode: 
      Ensure that the connector is deployed as a regular deployment. To do this, set the `connector.deployment.enabled` key to `true` in your configuration. You can adjust the number of replicas according to your scalability requirements by setting the `connector.deployment.replicas` key to the desired value. 

      For more information about the deployment strategies, see
      [Connector deployment modes in Application Live View#](connector-deployment-modes.hbs.md).

    - Enable REST API: 
      Set the flag `connector.restApi.enabled` to `true` to activate the REST API feature. This configuration instructs the connector to expose the REST API endpoints for interaction with the backend.

    Copy the below YAML content into `app-live-view-connector-values.yaml` file:

      ```yaml
      appliveview_connector:
        connector:
          deployment:
            enabled: true
            replicas: 1
          restApi:
            enabled: true
        activateSensitiveOperations: false
        activateAppLiveViewSecureAccessControl: true
      ```

    Adjust the configuration settings as necessary to suit your specific preferences to enable/disable security(`activateAppLiveViewSecureAccessControl`) and sensitive operations(`activateSensitiveOperations`) on the cluster


1. If you want to customize the domain used to expose the rest Api of the connector, update the file `app-live-view-connector-values.yaml` using the following details:

    Profile install using shared ingress domain key
    If you are using a Tanzu Application Platform profile installation and the top-level key
    `shared.ingress_domain` is set in the `tap-values.yaml`, the Application Live View connector
    is configured to expose the rest Api on this ingress.

    To override the shared ingress for Application Live View coneector in an environment,
    use the following values:

    ```yaml
    appliveview_connector:
      connector:
          deployment:
            enabled: true
          restApi: 
            enabled: true
            url: connector.INGRESS-DOMAIN
    ```

    Where `INGRESS-DOMAIN` is the top-level domain the Application Live View
    connector exposes the rest Apis by using `tanzu-shared-ingress` for the backend in other
    cluster to reach the Application Live View connector.

1. Configure TLS in your `app-live-view-connector-values.yaml` file:

    Activate TLS with self-signed certificate
    : To enable TLS for Application Live View connector using a self-signed certificate:

      1. Create the `app-live-view-connector` namespace and the TLS secret for the domain.
         You must do this before installing the Tanzu Application Platform packages in the
         cluster so that the HTTPProxy is updated with the TLS secret. To create a
         TLS secret, run:

          ```console
          kubectl create -n app-live-view-connector secret tls SECRET-NAME --cert=CERT-FILE --key=KEY-FILE
          ```

          Where:

          - `SECRET-NAME` is the name you want for the TLS secret for the domain, for example, `appliveview-connector`.
          - `CERT-FILE` is a .crt file that contains the PEM encoded server certificate.
          - `KEY-FILE`  is a .key file that contains the PEM encoded server private key.

      1. Provide the following properties in your `app-live-view-connector-values.yaml`:

          ```yaml
          appliveview_connector:
            restApi:
              url: "CONNECTOR-URL"
              tls:
                namespace: "NAMESPACE"
                secretName: "SECRET-NAME"
          ```

          Where:

          - `CONNECTOR-URL` is the domain on which the connector exposes its REST API.
          - `NAMESPACE` is the targeted namespace of TLS secret for the domain.
          - `SECRET-NAME` is the name of TLS secret for the domain.

      1. Verify the HTTPProxy object with the TLS secret by running:

          ```console
          kubectl get httpproxy -A
          ```

          Expected output:

          ```console
          NAMESPACE                 NAME                        FQDN                                  TLS SECRET                          STATUS      STATUS DESCRIPTION
          app-live-view-connector   appliveview-connector       connector.172.175.234.14.nip.io       appliveview-connector-cert          valid       Valid HTTPProxy
          ```

    Activate TLS using ClusterIssuer
    : If you are using Tnazu profile installation with the `shared.ingress_domain` set, the TLS is then automatically enabled on Application Live View connector using the shared ClusterIssuer.
      The `appliveview-connector-cert` certificate is generated by default and its issuerRef points to the
      `.ingress_issuer` value.
      The `ingress_issuer` key consumes the value `shared.ingress_issuer` from `tap-values.yaml`
      by default if you don't specify the `ingress_issuer` in `tap-values.yaml`.

      The HTTPProxy object is created in the cluster and also
      appliveview-connector-cert` certificate is generated by default in the `app-live-view-connector` namespace.
      Here, the secretName `appliveview-connector-cert` stores this certificate.

      1. To verify the HTTPProxy object with the secret, run:

          ```console
          kubectl get httpproxy -A
          ```

          Expected output:

          ```console
          NAMESPACE                 NAME                        FQDN                                  TLS SECRET                          STATUS      STATUS DESCRIPTION
          app-live-view-connector   appliveview-connector       connector.172.175.234.14.nip.io       appliveview-connector-cert          valid       Valid HTTPProxy
          ```

1. (Optional) View additional changes you can make in your `app-live-view-connector-values.yaml` file
   by running:

    ```console
    tanzu package available get connector.appliveview.tanzu.vmware.com/VERSION-NUMBER \
      --values-schema \
      --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed earlier. For example, `1.9.0`.

    For example:

    ```console
    $ tanzu package available get connector.appliveview.tanzu.vmware.com/1.10.0 \
        --values-schema \
        --namespace tap-install

      KEY                                   DEFAULT             TYPE        DESCRIPTION
      backend.caCertData                      cert-in-pem-format  string    CA Cert Data for ingress domain
      backend.host                            <nil>               string    Domain to be used to reach the application live view backend. Prepend
                                                                            "appliveview" subdomain to the value if you are using shared ingress. For
                                                                            example: "example.com" would become "appliveview.example.com".
      backend.ingressEnabled                  false               boolean   Flag for the connector to connect to ingress on backend

      backend.port                            <nil>               number    Port to reach the application live view backend
      backend.sslDeactivated                  false               boolean   Flag for whether or not to deactivate ssl
      backend.sslDisabled                     false               boolean   The key sslDisabled has been deprecated in TAP 1.4.0 and will be removed in TAP
                                                                            1.X+Y.0 of TAP, please migrate to the key sslDeactivated
      connector.deployment.enabled            true                boolean   Flag for the connector to run in deployment mode
      connector.deployment.replicas             1                 number    Number of replicas of connector pods at any given time
      connector.restApi.enabled               false               boolean   Flag to switch to http connector 
      connector.restApi.url                                       string    This field specifies the URL on which the connector exposes its REST API
      connector.restApi.tls.namespace         <nil>               string    The targeted namespace for secret consumption by the HTTPProxy.
      connector.restApi.tls.secretName        <nil>               string    The name of secret for consumption by the HTTPProxy.
      connector.namespace_scoped.enabled      false               boolean   Flag for the connector to run in namespace scope
      connector.namespace_scoped.namespace    default             string    Namespace to deploy connector
      kubernetes_distribution                                     string    Kubernetes distribution that this package is being installed on. Accepted
                                                                            values: ['''',''openshift'']
      kubernetes_version                                          string    Optional: The Kubernetes Version. Valid values are '1.24.*', or ''

      activateAppLiveViewSecureAccessControl                      boolean   Optional: Configuration required to enable Secure Access Connection between App
                                                                            Live View components
      activateSensitiveOperations                                 boolean   Optional: Configuration to allow connector to execute sensitive operations on a
                                                                            running application
    ```

1. Install the Application Live View connector package by running:

    ```console
    tanzu package install appliveview-connector \
      --package connector.appliveview.tanzu.vmware.com \
      --version VERSION-NUMBER \
      --namespace tap-install \
      --values-file app-live-view-connector-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed earlier. For example, `1.10.0`.

    For example:

    ```console
    $ tanzu package install appliveview-connector \
        --package connector.appliveview.tanzu.vmware.com \
        --version 1.10.0 \
        --namespace tap-install \
        --values-file app-live-view-connector-values.yaml

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

    The connector is configured to connect to the central instance of the back end. The
    Application Live View connector component is deployed in
    `app-live-view-connector` namespace by default.

1. Verify the `Application Live View connector` package installation by running:

    ```console
    tanzu package installed get appliveview-connector -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get appliveview-connector -n tap-install

    | Retrieving installation details for appliveview-connector...
    NAME:                    appliveview-connector
    PACKAGE-NAME:            connector.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.10.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.


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
      backend.appliveview.tanzu.vmware.com  1.10.0         2024-05-03T00:00:00Z
    ```

1. From the `Run` clusters, discover the `CLUSTER-NAME`, `CONNECTOR-URL` and `CONNECTOR-CA-CERTIFICATE` values.

    The `CLUSTER-NAME` is the name of the run cluster or any cluster where the connector and application are deployed. This is a unique name of your choice. Make sure it matches with the `tap-gui` cluster config

    Fetch the `CONNECTOR-URL` on which the connector exposes its REST API. If you are using a Tanzu Application Platform profile installation with the top-level key
    `shared.ingress_domain` set, you can find the `CONNECTOR-URL` by listing the HTTPProxy object.
  
      ```console
      kubectl get httpproxy -A
      ```

      Expected output:

      ```console
      NAMESPACE                 NAME                        FQDN                                  TLS SECRET                          STATUS      STATUS DESCRIPTION
      app-live-view-connector   appliveview-connector       connector.172.175.234.14.nip.io       appliveview-connector-cert          valid       Valid HTTPProxy
      ```   
    
    Fetch the `CONNECTOR-CA-CERTIFICATE` data from the secret to enable TLS communication 
    
      ```console
      kubectl get secret appliveview-connector-cert -n app-live-view-connector -o yaml |  yq '.data."ca.crt"' | base64 -d
      ```

1. Create the file `app-live-view-backend-values.yaml` using the following information:

    With the connector as a service, the backend will query the exposed ALV connector service in the run cluster to retrieve actuator data for an application. To facilitate this, the backend requires knowledge of the connector configuration for the cluster.
    Copy the below YAML content into `app-live-view-backend-values.yaml` to provide the connector cluster configuration in the backend:

      ```yaml
      appliveview:
        clusters:
            - name: CLUSTER-NAME
              connectorUrl: CONNECTOR-URL
              caCertData: |-
                    CONNECTOR-CA-CERTIFICATE
      ```

    Where:

     - `CLUSTER-NAME` is the value you discovered earlier.  
     - `CONNECTOR-URL` is the value you discovered earlier.
     - `CONNECTOR-CA-CERTIFICATE` is the value you discovered earlier.

    You can configure multiple run clusters for the Application Live View backend

1. (Optional) View additional changes you can make in your `app-live-view-backend-values.yaml` file
   by running:

    ```console
    tanzu package available get backend.appliveview.tanzu.vmware.com/VERSION-NUMBER \
      --values-schema \
      --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed earlier. For example, `1.10.0`.

    For example:

    ```console
    $ tanzu package available get backend.appliveview.tanzu.vmware.com/1.10.0 \
        --values-schema \
        --namespace tap-install

      KEY                      DEFAULT          TYPE        DESCRIPTION
      tls.namespace            <nil>            string      The targeted namespace for secret consumption by the HTTPProxy.

      tls.secretName           <nil>            string      The name of secret for consumption by the HTTPProxy.

      ingressDomain            tap.example.com  string      Domain to be used by the HTTPProxy ingress object. The "appliveview"
                                                            subdomain will be prepended to the value provided. For example:
                                                            "example.com" would become "appliveview.example.com".
      ingressEnabled           false            boolean     Flag for whether or not to create an HTTPProxy for ingress.

      ingress_issuer                            string      Cluster issuer to be used in App Live View Backend.
      kubernetes_distribution                   string      Kubernetes distribution that this package is being installed on. Accepted
                                                            values: ['''',''openshift'']
      kubernetes_version                        string      Optional: The Kubernetes Version. Valid values are '1.24.*', or ''
      activateAppLiveViewSecureAccessControl    boolean     Optional: Configuration required to enable Secure Access Connection between App
                                                                      Live View components
      clusters[0].name                          string      Name of the cluster
      clusters[0].connectorUrl                  string      The url on which the connector exposes its rest API
      clusters[0].caCertData                    string      The caCert data for the exposed domain for tls communication
      server.tls.crt                            string      TLS cert file
      server.tls.enabled       false            boolean     Flag to enable tls on backend
      server.tls.key                            string      TLS key file
    ```

1. Install the Application Live View back end package by running:

    ```console
    tanzu package install appliveview \
      --package backend.appliveview.tanzu.vmware.com \
      --version VERSION-NUMBER \
      --namespace tap-install \
      --values-file app-live-view-backend-values.yaml
    ```

    Where `VERSION-NUMBER` is the version of the package listed earlier. For example, `1.10.0`.

    For example:

    ```console
    $ tanzu package install appliveview \
        --package backend.appliveview.tanzu.vmware.com \
        --version 1.9.0 \
        --namespace tap-install \
        --values-file app-live-view-backend-values.yaml

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

    The Application Live View back end component is deployed in `app-live-view`
    namespace by default.

1. Verify the Application Live View back end package installation by running:

    ```console
    tanzu package installed get appliveview -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get appliveview -n tap-install

    \ Retrieving installation details for appliveview...
    NAME:                    appliveview
    PACKAGE-NAME:            backend.appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         1.10.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.