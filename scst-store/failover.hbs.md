# Failover, redundancy, and backups

###  <a id="API-Server"></a>API Server

By default the API server only has 1 replica.
If the POD fails, the single instance restarts by normal Kubernetes behavior, but there is downtime.
If the user is upgrading, some downtime is expected in most cases as well.

Users have the option to configure the number of replicas using the `app_replicas` field in the `scst-store-values.yaml` file.

###  <a id="database"></a>Database

By default, the database  has 1 replica, and  restarts with some downtime if it were to fail.

Although the field `db_replicas` exists and is configurable by the user in the `scst-store-values.yaml` file, VMware discourages using it. The default internal database is not intended to be used in production.
For production use AWS RDS. See instructions [here](use-aws-rds.md).

For the default postgres database deployment (set by default or by setting `deploy_internal_db` to true), `Velero` may be used as the backup method.
Read more about using `Velero` as back up [here](backups.md).
