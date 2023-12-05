
# Install Supply Chain Security Tools - Store

This topic describes how you can install Supply Chain Security Tools (SCST) - Store
independently from Tanzu Application Platform (commonly known as TAP) profiles.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Supply Chain Security Tools - Store. For more information about profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before installing SCST - Store from the Tanzu Application Platform package repository:

- Complete all prerequisites to install Tanzu Application Platform. For more
  information, see [Prerequisites](../prerequisites.md).
- Install cert-manager on the cluster. See [Install
  cert-manager](../cert-manager/install.md).
- See [Deployment Details and Configuration](deployment-details.md) to review
  what resources are deployed. For more information, see the
  [overview](overview.md).
- Create ClusterIssuer

    ```console
  kubectl apply -f - <<EOF
  apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: tap-ingress-selfsigned
      spec:
        selfSigned: {}
  EOF
    ```

## <a id='install'></a>Install

To install SCST - Store:

1. To use this deployment, the user must have set up the Kubernetes cluster to
   provision persistent volumes on demand. Ensure that a default storage class
   is available in your cluster. Verify whether default storage class is set in
   your cluster using `kubectl get storageClass`.

    ```console
    kubectl get storageClass
    ```

    For example:

    ```console
    $ kubectl get storageClass
    NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  7s
    ```

1. List version information for the package using `tanzu package available list`.

    ```console
    tanzu package available list metadata-store.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list metadata-store.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for metadata-store.apps.tanzu.vmware.com...
      NAME                         VERSION       RELEASED-AT
      metadata-store.apps.tanzu.vmware.com  1.0.2
    ```

1. (Optional) List all the available deployment configuration options.

    ```console
    tanzu package available get metadata-store.apps.tanzu.vmware.com/VERSION --values-schema -n tap-install
    ```

    Where `VERSION` is the your package version number.

    For example:

    ```console
    $ tanzu package available get metadata-store.apps.tanzu.vmware.com/1.0.2 --values-schema -n tap-install
    | Retrieving package details for metadata-store.apps.tanzu.vmware.com/1.0.2...
      KEY                             DEFAULT                                                                                                                                                                                                      TYPE     DESCRIPTION
      pg_limit_memory                 4Gi                                                                                                                                                                                                          string   Memory limit for postgres container in metadata-store-db deployment
      tls.namespace                                                                                                                                                                                                                                string   The targeted namespace for secret consumption by the HTTPProxy.
      add_default_rw_service_account  true                                                                                                                                                                                                         string   Adds a read-write service account which can be used to obtain access token to use metadata-store CLI
      api_host                        localhost                                                                                                                                                                                                    string   The internal hostname for the metadata api endpoint. This will be used by the kube-rbac-proxy sidecar.
      app_replicas                    1                                                                                                                                                                                                            integer  The number of replicas for the metadata-store-app
      ingress_domain                                                                                                                                                                                                                               string   Domain to be used by the HTTPProxy ingress object. The "metadata-store" subdomain will be prepended to the value provided. For example: "example.com" would become "metadata-store.example.com". Required if ingress_enabled is true.
      kube_rbac_proxy_limit_cpu       250m                                                                                                                                                                                                         string   CPU limit for kube-rbac-proxy container in the metadata-store-app deployment
      pg_limit_cpu                    2Gi                                                                                                                                                                                                          string   CPU limit for postgres container in metadata-store-db deployment
      tls.server.minTLSVersion        VersionTLS12                                                                                                                                                                                                 string   Minimum TLS version supported. Value must match version names from https://golang.org/pkg/crypto/tls/#pkg-constants. (default "VersionTLS12")
      db_host                         metadata-store-db                                                                                                                                                                                            string   The address to the postgres database host that the metadata-store app uses to connect. The default is set to metadata-store-db which is the postgres service name. Changing this does not change the postgres service name
      db_replicas                     1                                                                                                                                                                                                            integer  The number of replicas for the metadata-store-db
      pg_req_cpu                      1Gi                                                                                                                                                                                                          string   CPU request for postgres container in metadata-store-db deployment
      priority_class_name                                                                                                                                                                                                                          string   If specified, this value is the name of the desired PriorityClass for the metadata-store-db deployment
      tls.secretName                                                                                                                                                                                                                               string   The name of secret for consumption by the HTTPProxy.
      db_ca_certificate                                                                                                                                                                                                                            string   This should only be set in the case when 'deploy_internal_db' is 'false'. Set this to the trusted CA Certificate that signed the Postgres DB TLS Certificate
      db_password                                                                                                                                                                                                                                  string   The database user password. If no value is provided, a 32 character value will be generated.
      db_port                         5432                                                                                                                                                                                                         string   The database port to use. This is the port to use when connecting to the database pod.
      app_limit_cpu                   250m                                                                                                                                                                                                         string   CPU limit for metadata-store-app container
      auth_proxy_host                 0.0.0.0                                                                                                                                                                                                      string   The binding ip address of the kube-rbac-proxy sidecar
      db_max_open_conns               10                                                                                                                                                                                                           integer  Sets the maximum number of open database connections from the Metadata Store to the database.
      db_name                         metadata-store                                                                                                                                                                                               string   The name of the database to use.
      db_user                         metadata-store-user                                                                                                                                                                                          string   The database user to create and use for updating and querying. The metadata postgres section create this user. The metadata api server uses this username to connect to the database.
      kube_rbac_proxy_req_memory      128Mi                                                                                                                                                                                                        string   Memory request for kube-rbac-proxy container in the metadata-store-app deployment
      auth_proxy_port                 8443                                                                                                                                                                                                         integer  The external port address of the of the kube-rbac-proxy sidecar
      db_conn_max_lifetime            60                                                                                                                                                                                                           integer  Sets the maximum amount of time a database connection may be reused in seconds.
      ingress_enabled                 false                                                                                                                                                                                                        string   Contour is required to be installed to use this flag. When true, this creates an HTTPProxy object for the metadata-store. If false, then no ingress is configured.
      storage_class_name                                                                                                                                                                                                                           string   The storage class name of the persistent volume used by Postgres database for storing data. The default value will use the default class name defined on the cluster.
      api_port                        9443                                                                                                                                                                                                         integer  The internal port for the metadata app api endpoint. This will be used by the kube-rbac-proxy sidecar.
      app_service_type                LoadBalancer                                                                                                                                                                                                 string   The type of service to use for the metadata app service. This can be set to 'Nodeport', 'ClusterIP' or 'LoadBalancer'.
      db_sslmode                      verify-full                                                                                                                                                                                                  string   Determines the security connection between API server and Postgres database. This can be set to 'verify-ca' or 'verify-full'
      use_cert_manager                true                                                                                                                                                                                                         string   Cert manager is required to be installed to use this flag. When true, this creates certificates object to be signed by cert manager for the API server and Postgres database. If false, the certificate object have to be provided by the user.
      app_req_cpu                     100m                                                                                                                                                                                                         string   CPU request for metadata-store-app container
      database_request_storage        10Gi                                                                                                                                                                                                         string   The storage requested of the persistent volume used by Postgres database for storing data.
      deploy_internal_db              true                                                                                                                                                                                                         string   If set to 'true', a postgres deployment will be created. If set to 'false', db_host and db_port should point to an accessible postgres instance. Postgres connections require TLS, so the corresponding db_ca_certification must be provided
      kube_rbac_proxy_req_cpu         100m                                                                                                                                                                                                         string   CPU request for kube-rbac-proxy container in the metadata-store-app deployment
      ns_for_export_app_cert          scan-link-system                                                                                                                                                                                             string   The namespace where the "Supply Chain Security Tools for VMware Tanzu - Scan" component is installed in. Certain certificates will be exported to that namespace so that scan reports can be posted to the Metadata Store.
      pg_req_memory                   1Gi                                                                                                                                                                                                          string   Memory request for postgres container in metadata-store-db deployment
      app_limit_memory                512Mi                                                                                                                                                                                                        string   Memory limit for metadata-store-app container
      app_req_memory                  128Mi                                                                                                                                                                                                        string   Memory request for metadata-store-app container
      db_max_idle_conns               100                                                                                                                                                                                                          integer  Sets the maximum number of database connections from the Metadata Store in the idle connection pool.
      kube_rbac_proxy_limit_memory    512Mi                                                                                                                                                                                                        string   Memory limit for kube-rbac-proxy container in the metadata-store-app deployment
      kubernetes_distribution                                                                                                                                                                                                                      string   Kubernetes platform distribution where the metadata-store is being installed on. Accepted values: ["", "openshift"]
      log_level                       default                                                                                                                                                                                                      string   Sets the log level. This can be set to "minimum", "less", "default", "more", "debug" or "trace". "minimum" currently does not output logs. "less" outputs log configuration options only. "default" and "more" outputs API endpoint access information. "debug" and "trade" outputs extended API endpoint
                                                                                                                                                                                                                                                            access information(such as body payload) and other debug information.
      tls.server.rfcCiphers           [TLS_AES_128_GCM_SHA256 TLS_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384]  array    List of cipher suites for the server. Values are from tls package constants (https://golang.org/pkg/crypto/tls/#pkg-constants). If omitted, the default Go cipher suites will be used
      ingress_issuer                  tap-ingress-selfsigned                                                                                                                                                                                       string   tap-ingress-selfsigned is the default value when installed via any TAP profile. When installing only the metadata-store package, a ClusterIssuer needs to be installed and its name needs to be specified as this value.
    ```

1. (Optional) Edit one of the deployment configurations by creating a configuration YAML with the
custom configuration values you want. For example, if your environment does not support `LoadBalancer`,
and you want to use `ClusterIP`, then create a `metadata-store-values.yaml` and configure the
`app_service_type` property.

    ```yaml
    ---
    app_service_type: "ClusterIP"
    ```

    See [Deployment details and configuration](deployment-details.md#configuration) for
    more information about configuration options.

     For information about ingress and custom domain name support, see [Ingress support](ingress.hbs.md).

1. Install the package using `tanzu package install`.

    ```console
    tanzu package install metadata-store \
      --package metadata-store.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file metadata-store-values.yaml
    ```

    Where:

    - `--values-file` is an optional flag. Only use it to customize the deployment
    configuration.
    - `VERSION` is the package version number.

    For example:

    ```console
    $ tanzu package install metadata-store \
      --package metadata-store.apps.tanzu.vmware.com \
      --version 1.0.2 \
      --namespace tap-install \
      --values-file metadata-store-values.yaml

    - Installing package 'metadata-store.apps.tanzu.vmware.com'
    / Getting namespace 'tap-install'
    - Getting package metadata for 'metadata-store.apps.tanzu.vmware.com'
    / Creating service account 'metadata-store-tap-install-sa'
    / Creating cluster admin role 'metadata-store-tap-install-cluster-role'
    / Creating cluster role binding 'metadata-store-tap-install-cluster-rolebinding'
    / Creating secret 'metadata-store-tap-install-values'
    | Creating package resource
    - Package install status: Reconciling

    Added installed package 'metadata-store' in namespace 'tap-install'
    ```
