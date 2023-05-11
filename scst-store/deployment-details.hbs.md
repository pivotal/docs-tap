# Deployment details and configuration for Supply Chain Security Tools - Store

This topic describes how you can deploy and configure your Kubernetes cluster for Supply Chain Security Tools (SCST) - Store.

## <a id='what-deploy'></a>What is deployed

The installation creates the following in your Kubernetes cluster:

- Two components — an API back end and a database.
  Each component includes:
    - service
    - deployment
    - replicaset
    - Pod
- Persistent volume claim
- External IP address (based on a deployment configuration set to use `LoadBalancer`).
- A Kubernetes secret to allow pulling SCST - Store images from a registry.
- A namespace called `metadata-store`.
- A service account with read-write privileges named `metadata-store-read-write-client`, and a corresponding secret for the service account. It's bound to a ClusterRole named `metadata-store-read-write`.
- A read-only ClusterRole named `metadata-store-read-only` that isn't bound to a service account. See [Service Accounts](#service-accounts).
- (Optional) An HTTPProxy object for ingress support.

## <a id='configuration'></a> Deployment configuration

All configurations are nested inside of `metadata_store` in your tap values deployment YAML.

### Supported Network Configurations

The following connection methods are recommended based on Tanzu Application Platform setup:

- Single or multicluster with Contour = `Ingress`
- Single cluster without Contour and with `LoadBalancer` support = `LoadBalancer`
- Single cluster without Contour and without `LoadBalancer` = `NodePort`
- Multicluster without Contour = Not supported

For a production environment, VMware recommends that you install SCST - Store with ingress enabled.

By default, a database password is generated upon deployment. To configure a custom password, use the `db_password` property in the `metadata-store-values.yaml` during deployment.

Supported values include `LoadBalancer`, `ClusterIP`, `NodePort`. The
`app_service_type` is set to `LoadBalancer` by default. If your environment does
not support `LoadBalancer`, and you want to use `ClusterIP`, configure the
`app_service_type` property in your deployment YAML:

```yaml
app_service_type: "ClusterIP"
```

If you set the `ingress_enabled` to `"true"`, VMware recommends setting
the `app_service_type` property to `"ClusterIP"`.

### <a id='service-accounts'></a>Service accounts

SCST - Store's values file allows you to enable ingress support and to configure
a custom domain name to use Contour to provide external access to SCST - Store's
API. For example:

```yaml
ingress_enabled: "true"
ingress_domain: "example.com"
app_service_type: "ClusterIP" # recommended setting
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

Users can also configure the deployment to use any other PostgreSQL database.
See [Use external postgres database](use-external-database.hbs.md).

#### <a id='cust-data-pass'></a>Custom database password

By default, a database password is generated upon deployment. To configure a
custom password, use the `db_password` property in the deployment YAML.

```yaml
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
