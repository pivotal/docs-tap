# Failover, redundancy, and backups for Supply Chain Security Tools - Store

This topic describes how you can configure and use failover, redundancy, and backups for
Supply Chain Security Tools (SCST) - Store.

## <a id="API-Server"></a> API Server

By default the API server has 1 replica.
If the pod fails, the single instance restarts by normal Kubernetes behavior, but there is downtime.
If you upgrade, some downtime is possible.

You can configure the number of replicas by using the `app_replicas` text box in the
`scst-store-values.yaml` file.

## <a id="database"></a> Database

By default, the database has one replica, and restarts with some downtime if it fails.

> **Caution** Although you can configure `db_replicas` in `scst-store-values.yaml`, this is
> discouraged because `db_replicas` is still experimental. The default internal database is not for
> production use. For production deployments, use an external database.

- [Use external postgres database](use-external-database.hbs.md)
- [AWS RDS postgres configuration](use-aws-rds.hbs.md)

For the default PostgreSQL database deployment, with `deploy_internal_db` set to `true`, you can use
`Velero` as the backup method. For information about using `Velero` as the backup method, see
[Backups](backups.hbs.md).
