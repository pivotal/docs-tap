# Failover, redundancy, and backups

### API Server

By default the API server only has 1 replica. 
If the pod crashes, the single instance should restart by normal kubernetes behaviour, but there will be downtime.
If the user is upgrading, some downtime is expected as well.

Users have the option to configure the number of replicas using the `app_replicas` field in the `scst-store-values.yaml` file.

### Database

By default, the database only has 1 replica, and would restart with some downtime if it were to crash.

Although the field `db_replicas` exists and is configurable by the user in the `scst-store-values.yaml` file, we do not recommend using it. The default internal db should not be used in production.
For production please use AWS RDS. See instructions [here](use_aws_rds.md).

For the default postgres database deployment (set by default or by setting `deploy_internal_db` to true), `Velero` can be used as the backup method.
Read more about using `Velero` as back up [here](backups.md).

