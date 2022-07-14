# Install Supply Chain Security Tools - Store independent from Tanzu Application Platform profiles

This document describes how to install Supply Chain Security Tools - Store
from the Tanzu Application Platform package repository.

>**Note:** VMware recommends installing Supply Chain Security Tools - Store by using Tanzu Application Platform Profiles.  See [About Tanzu Application Platform components and profiles](../about-package-profiles.md) and [Installing the Tanzu Application Platform Package and Profiles](../install.md).  Use the following instructions if you do not want to use a profile to install the Supply Chain Security Tools - Store package.

## <a id='prereqs'></a>Prerequisites

Before installing Supply Chain Security Tools - Store:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cert-manager on the cluster. For more information, see [Install cert-manager](../cert-mgr-contour-fcd/install-cert-mgr.md#install-cert-mgr).
- See [Deployment Details and Configuration](deployment-details.md) to review what resources will be deployed. For more information, see the [overview](overview.md).

## <a id='install'></a>Install

To install Supply Chain Security Tools - Store:

1. The deployment assumes the user has set up the Kubernetes cluster to provision persistent volumes on demand. Make sure a default storage class is available in your cluster. Check whether default storage class is set in your cluster by running:

    ```console
    kubectl get storageClass
    ```

    For example:

    ```console
    $ kubectl get storageClass
    NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
    standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  7s
    ```

1. List version information for the package by running:

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

1. (Optional) List out all the available deployment configuration options:

    ```console
    tanzu package available get metadata-store.apps.tanzu.vmware.com/VERSION --values-schema -n tap-install
    ```

    Where `VERSION` is the your package version number. For example, `1.0.2`.

    For example:

    ```console
    $ tanzu package available get metadata-store.apps.tanzu.vmware.com/1.0.2 --values-schema -n tap-install
    | Retrieving package details for metadata-store.apps.tanzu.vmware.com/1.0.2...
      KEY                               DEFAULT              TYPE     DESCRIPTION
      app_service_type                  LoadBalancer         string   The type of service to use for the metadata app service. This can be set to 'Nodeport', 'ClusterIP' or 'LoadBalancer'.
      auth_proxy_host                   0.0.0.0              string   The binding ip address of the kube-rbac-proxy sidecar
      db_host                           metadata-store-db    string   The address to the postgres database host that the metdata-store app uses to connect. The default is set to metadata-store-db which is the postgres service name. Changing this does not change the postgres service name
      db_replicas                       1                    integer  The number of replicas for the metadata-store-db
      db_sslmode                        verify-full          string   Determines the security connection between API server and Postgres database. This can be set to 'verify-ca' or 'verify-full'
      pg_limit_memory                   4Gi                  string   Memory limit for postgres container in metadata-store-db deployment
      app_req_cpu                       100m                 string   CPU request for metadata-store-app container
      app_limit_memory                  512Mi                string   Memory limit for metadata-store-app container
      app_req_memory                    128Mi                string   Memory request for metadata-store-app container
      auth_proxy_port                   8443                 integer  The external port address of the of the kube-rbac-proxy sidecar
      db_name                           metadata-store       string   The name of the database to use.
      db_port                           5432                 string   The database port to use. This is the port to use when connecting to the database pod.
      api_port                          9443                 integer  The internal port for the metadata app api endpoint. This will be used by the kube-rbac-proxy sidecar.
      app_limit_cpu                     250m                 string   CPU limit for metadata-store-app container
      app_replicas                      1                    integer  The number of replicas for the metadata-store-app
      db_user                           metadata-store-user  string   The database user to create and use for updating and querying. The metadata postgres section create this user. The metadata api server uses this username to connect to the database.
      pg_req_memory                     1Gi                  string   Memory request for postgres container in metadata-store-db deployment
      priority_class_name                                    string   If specified, this value is the name of the desired PriorityClass for the metadata-store-db deployment
      use_cert_manager                  true                 string   Cert manager is required to be installed to use this flag. When true, this creates certificates object to be signed by cert manager for the API server and Postgres database. If false, the certificate object have to be provided by the user.
      api_host                          localhost            string   The internal hostname for the metadata api endpoint. This will be used by the kube-rbac-proxy sidecar.
      db_password                       <auto-generated>     string   The database user password. If not specified, the password will be auto-generated.
      storage_class_name                                     string   The storage class name of the persistent volume used by Postgres database for storing data. The default value will use the default class name defined on the cluster.
      database_request_storage          10Gi                 string   The storage requested of the persistent volume used by Postgres database for storing data.
      add_default_rw_service_account    true                 string   Adds a read-write service account which can be used to obtain access token to use metadata-store CLI
      log_level                         default              string   Sets the log level. This can be set to "minimum", "less", "default", "more", "debug" or "trace". "minimum" currently does not output logs. "less" outputs log configuration options only. "default" and "more" outputs API endpoint access information. "debug" and "trace" outputs extended API endpoint access information(such as body payload) and other debug information.
    ```

1. (Optional) Modify one of the deployment configurations by creating a configuration YAML with the
custom configuration values you want. For example, if your environment does not support `LoadBalancer`,
and you want to use `ClusterIP`, then create a `metadata-store-values.yaml` and configure the
`app_service_type` property.

    ```yaml
    ---
    app_service_type: "ClusterIP"
    ```

    See [Deployment details and configuration](deployment-details.md#configuration) for
    more information about configuration options.

    See [Ingress and multicluster support](ingress-multicluster.md) for more information about ingress and custom domain name support.

1. Install the package by running:

    ```console
    tanzu package install metadata-store \
      --package-name metadata-store.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file metadata-store-values.yaml
    ```

    Where:

    * `--values-file` is an optional flag. Only use it to customize the deployment
    configuration.
    * `VERSION` is the package version number. For example, `1.0.2`.

    For example:

    ```console
    $ tanzu package install metadata-store \
      --package-name metadata-store.apps.tanzu.vmware.com \
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
