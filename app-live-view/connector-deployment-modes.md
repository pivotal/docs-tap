# Connector Deployment Modes in Application Live View

This topic describes the different ways the connector can be deployed in Tanzu Application Platform.

## <a id='connector-as-daemonset'></a>Connector as DaemonSet

This is the default mode of Application Live View connector in Tanzu Application Platform. The connector deployed as a Kubernetes DaemonSet discovers applications across all the namespaces running in a worker node of a Kubernetes cluster.


## <a id='connector-as-deployment'></a>Connector as Regular Deployment

When the connector is running as a regular deployment, it will observe all the applications across all the namespaces in the cluster and register with the backend.

1. To run the connector as a regular deployment, change the default installation settings for Application Live View
   connector by running:

    ```console
    tanzu package available get connector.appliveview.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed. For example,
    `1.8.0`.

    For example:

    ```console
    $ tanzu package available get connector.appliveview.tanzu.vmware.com/1.8.0 --values-schema --namespace tap-install
      KEY                                   DEFAULT             TYPE        DESCRIPTION
      kubernetes_version                                        string      Optional: The Kubernetes Version. Valid values are '1.24.*', or ''.

      backend.sslDeactivated                false               boolean     Flag for whether to disable SSL.
      backend.caCertData                    cert-in-pem-format  string      CA Cert Data for ingress domain.
      backend.host                          <nil>               string      Domain used to reach the Application Live View back end. Prepend
                                                                            "appliveview" subdomain to the value if you use shared ingress. For
                                                                            example: "example.com" becomes "appliveview.example.com".
      backend.ingressEnabled                false               boolean     Flag for the connector to connect to ingress on back end.

      backend.port                          <nil>               number      Port to reach the Application Live View back end.
      connector.deployment.enabled          false               boolean     Flag for the connector to run in deployment mode
      connector.deployment.replicas           1                 number      Number of replicas of connector pods at any given time      
      connector.namespace_scoped.enabled    false               boolean     Flag for the connector to run in namespace scope.
      connector.namespace_scoped.namespace  default             string      Namespace to deploy connector.
      kubernetes_distribution                                   string      Kubernetes distribution that this package is being installed on. Accepted
                                                                            values: ['''',''openshift''].
      activateAppLiveViewSecureAccessControl                    boolean     Optional: Configuration required to enable Secure Access Connection between App Live View components.
      activateSensitiveOperations                               boolean     Optional: Configuration to allow connector to execute sensitive operations on a running application.
    ```

    For more information about values schema options, see the properties listed
    earlier.

1. Create `app-live-view-connector-values.yaml` with the following details:

    To override the deployment mode for connector, use the following
    values:

    ```yaml
    appliveview_connector:
      connector:
        deployment:
          enabled: true
          replicas: 1
    ```

    By default, the `connector.deployment.enabled` is set to `false`.

    The `connector.deployment.replicas` key is used to specify the number of replicas of connector pods running at any given time.


## <a id='connector-as-namespace-scoped'></a>Connector as Namespace Scoped

When the connector is deployed in namespace-scoped mode, it discovers applications within the namespace of a Kubernetes cluster.

1. To deploy the connector in namespace-scoped mode, use the below config values for connector in `app-live-view-connector-values.yaml`:

    ```yaml
    appliveview_connector:
      connector:
        namespace_scoped:
          enabled: true
          namespace: "NAMESPACE"
    ```

    Where:

    - `NAMESPACE` is used to specify the namespace to deploy the connector

