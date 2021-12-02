# Deployment details and configuration

## What is deployed

The installation creates the following in your Kubernetes cluster:

* 2 components — an API backend and a database. 
Each component includes:
    * service
    * deployment
    * replicaset
    * pod
* Persistent volume, and persistent volume claim.
* External IP (based on a deployment configuration set to use `LoadBalancer`).
* A Kubernetes secret to allow pulling Supply Chain Security Tools - Store images from a registry.
* A namespace called `metadata-store`.
* A service account with read-write privileges named `metadata-store-read-write-client`. It's bound to a ClusterRole named `metadata-store-read-write`.
* A ready-only ClusterRole named `metadata-store-ready-only` that isn't bound to a service account. See [Service Accounts](#service-accounts).

## <a id='configuration'></a> Deployment configuration
### Database configuration

The default database that ships with the deployment is meant to get users started with using the metadata store. The default database deployment is not meant support for many enterprise production requirements including scaling, redundancy, or failover. However, it is still a secure deployment.

#### Using AWS RDS Postgres database

Users can also configure the deployment to use their own RDS database instead of the default database. See [AWS RDS Postgres Configuration](use_aws_rds.md).

#### Custom database password

By default, a database password is generated automatically upon deployment. To configure a custom password, use the `db_password` property in the `scst-store-values.yaml` during deployment.

```yaml
db_password: "PASSWORD-0123"
```

If you're deploying with TAP profiles, in `tap-values.yaml`, put:

```yaml
metadata_store:
  db_password: "PASSWORD-0123"
```

Where `PASSWORD-0123` is the same password used between deployments.

> Note: there is a known issue related to changing database passwords [Known Issues - Persistent Volume Retains Data](known_issues.md#persistent-volume-retains-data).

### App service type

If your environment does not support `LoadBalancer`, and you want to use `NodePort`, configure the `app_service_type` property in your `scst-store-values.yaml`:

```yaml
app_service_type: "LoadBalancer"
```

### <a id='service-accounts'></a>Service accounts

By default, a service account with read-write privileges to the metadata store app is installed. This service account is a cluster-wide account that uses ClusterRole. If the service account and role are not desired, set the `add_default_rw_service_account` property to `"false"`. To create a custom service account, see [create service account](create_service_account_access_token.md).

The store will automatically create a read-only cluster role, which may be bound to a service account via `ClusterRoleBinding`. To create service accounts to bind to this cluster role, see [create service account](create_service_account_access_token.md). 

## Exporting certificates

Supply Chain Security Tools - Store creates [Secret Export](https://github.com/vmware-tanzu/carvel-secretgen-controller/blob/develop/docs/secret-export.md) for exporting certificates to `Supply Chain Security Tools - Scan` so that it can securely post scan results. These certificates are exported to the namespace where `Supply Chain Security Tools - Scan` is installed. 
