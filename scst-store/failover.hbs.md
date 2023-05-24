# Failover, redundancy, and backups for Supply Chain Security Tools - Store

This topic describes how you can configure and use failover, redundancy, and backups for Supply Chain Security Tools (SCST) - Store.

## <a id="API-Server"></a>API Server

By default the API server has 1 replica.
If the pod fails, the single instance restarts by normal Kubernetes behavior, but there is downtime.
If the user is upgrading, some downtime is expected.

Users have the option to configure the number of replicas using the `app_replicas` text box in the `scst-store-values.yaml` file.

##  <a id="database"></a>Database

By default, the database has 1 replica, and restarts with some downtime if it fails. Although the text box `db_replicas` exists and is configurable by the user in the `scst-store-values.yaml` file, VMware discourages users from configuring `db_replicas` because it is experimental.

The default internal database is not for use in production. For production deployments, VMware reccomends using an external database.

- [Use external postgres database](use-external-database.hbs.md)
- [AWS RDS postgres configuration](use-aws-rds.hbs.md)

For the default PostgreSQL database deployment, with `deploy_internal_db` set to true, `Velero` can be used as the backup method.
For information about using `Velero` as back up, see [Backups](backups.hbs.md).
