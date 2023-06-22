# Deployment details and configuration for Supply Chain Security Tools - Store

This topic describes how you can deploy and configure your Kubernetes cluster for Supply Chain Security Tools (SCST) - Store.

## <a id='what-deploy'></a>What is deployed

The installation creates the following in your Kubernetes cluster:

- Four components:
    - metadata-store API backend 
    - database
    - AMR API backend (If AMR is deployed, see [Deploying AMR](#amr))
    - AMR CloudEvent Handler (If AMR is deployed, see [Deploying AMR](#amr))
- Services for each of the four components, named:
    - `metadata-store-app`
    - `metadata-store-db`
    - `amr-persister` (If AMR is deployed, see [Deploying AMR](#amr))
    - `artifact-metadata-repository-app` (If AMR is deployed, see [Deploying AMR](#amr))
- A namespace called `metadata-store`.
- Persistent volume claim `postgres-db-pv-claim` in the `metadata-store` namespace.
- A Kubernetes secret in the namespace tap is installed to allow pulling SCST - Store images from a registry.
- Two ClusterRoles:
    - `metadata-store-read-write-client` is bound to a service account by default, giving the service account read and write privileges
    - `metadata-store-read-only` isn't bound to any service accounts, but is available for the user to bound it if needed. See [Service Accounts](#service-accounts).
- (Optional) An HTTPProxy object for ingress support.

## <a id='configuration'></a> Deployment configuration

All configurations are nested inside of `metadata_store` in your tap values deployment YAML. For AMR specific configurations, they are nested under `amr` inside of the `metadata_store` section.

### Supported Network Configurations

The following connection methods are recommended based on Tanzu Application Platform setup:

- Single or multicluster with Contour = `Ingress`
- Single cluster without Contour and with `LoadBalancer` support = `LoadBalancer`
- Single cluster without Contour and without `LoadBalancer` = `NodePort`
- Multicluster without Contour = Not supported

For a production environment, VMware recommends that you install SCST - Store with ingress enabled.

#### <a id='amr'></a>Deploying AMR
>**Note** The AMR is an alpha feature and should not be used in production.

By default, AMR is not deployed with the Store. There is an `amr` section inside `metadata-store`. The `deploy` property under `amr` must be set to `true` to deploy AMR.

```yaml
metadata_store:
  amr:
    deploy: true
```

>**Note** The `deploy` property expects a Boolean value of `true` or `false`, not a string value.

#### <a id='appserv-type'></a>App service type
This configuration is available under two places:
- `metadata_store` for configuring the app service type of the metadata store
- `amr` within the `metadata_store` section, for configuring the app service type of the AMR

Supported values include `LoadBalancer`, `ClusterIP`, `NodePort`. The
`app_service_type` is set to `LoadBalancer` by default. If your environment does
not support `LoadBalancer`, configure the
`app_service_type` property to use `ClusterIP` in your deployment YAML:

For the metadata-store:
```yaml
metadata_store:
  app_service_type: "ClusterIP"
```
For AMR:
```yaml
metadata_store:
  amr:
    deploy: true
    app_service_type: "ClusterIP"
```
If you set the `ingress_enabled` to `"true"`, VMware recommends setting
the `app_service_type` property to `"ClusterIP"`. 

>**Note** The `app_service_type` is set to `ClusterIP` by default when shared ingress is enabled

#### <a id='ingress'></a>Ingress support

SCST - Store's values file allows you to enable ingress support and to configure
a custom domain name to use Contour to provide external access to SCST - Store's
API. These ingress configurations are shared for the metadata store and AMR, enabling ingress for store will enable it for both. 
For example:

```yaml
metadata_store: 
  ingress_enabled: "true"
  ingress_domain: "example.com"
  app_service_type: "ClusterIP" # recommended setting when ingress is enabled
```

An HTTPProxy object is installed with `metadata-store.example.com` as the
fully qualified domain name. See [Ingress](ingress.hbs.md).

>**Note** The `ingress_enabled` property expects a string value of `"true"` or `"false"`, not a Boolean value.

### <a id="db-config"></a> Database configuration

The default database included with the deployment is meant to get users started
using the metadata store. The default database deployment does not support many
enterprise production requirements, including scaling, redundancy, or failover.
However, it is a secure deployment.

#### <a id='awsrds-postresdata'></a>Using AWS RDS PostgreSQL database

Users can also configure the deployment to use their own RDS database instead of
the default. See [AWS RDS Postgres Configuration](use-aws-rds.hbs.md).

#### Using external PostgreSQL database

Users can configure the deployment to use any other PostgreSQL database.
See [Use external postgres database](use-external-database.hbs.md).

#### <a id='cust-data-pass'></a>Custom database password

By default, a database password is generated upon deployment. To configure a
custom password, use the `db_password` property in the deployment YAML. 
The `db_password` property is available in two place, one under `metadata_store` and one under `amr` inside `metadata_store`.

To configure a custom database password for the store:
```yaml
metadata_store:
  db_password: "PASSWORD-0123"
```
To configure a custom database password for AMR:
```yaml
metadata_store:
  amr:
    deploy: true
    db_password: "PASSWORD-0123"
```

Where `PASSWORD-0123` is the same password used between deployments.

>**Important** There is a known issue related to changing database passwords [Persistent Volume Retains Data](../release-notes.md#store-persistent-volume-retains-data).

### <a id='service-accounts'></a>Service accounts

By default, a service account with read-write privileges to the metadata store app is installed.
This service account is a cluster-wide account that uses ClusterRole.
If you don't want the service account and role, set the `add_default_rw_service_account` property to `"false"`.
To create a custom service account, see [Create Service Account](create-service-account.hbs.md).

The store creates a read-only cluster role, which is bound to a service account
by using `ClusterRoleBinding`. To create service accounts to bind to this
cluster role, see [Create Service Account](create-service-account.hbs.md).

## <a id='export-cert'></a>Exporting certificates

SCST - Store creates a [Secret
Export](https://github.com/vmware-tanzu/carvel-secretgen-controller/blob/develop/docs/secret-export.md)
for exporting certificates to `Supply Chain Security Tools - Scan` to securely
post scan results. These certificates are exported to the namespace where
`Supply Chain Security Tools - Scan` is installed.
