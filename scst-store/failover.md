# Failover, redundancy, and backups

### API Server

By default the API server only has 1 replica. 
If the pod crashes, the single instance should restart by normal kubernetes behaviour, but there will be downtime.
If the user is upgrading, some downtime is expected as well.

Users have the option to configure the number of replicas using the `app_replicas` field in the `scst-store-values.yaml` file.

### Database

By default, the database only has 1 replica, and would restart with some downtime if it were to crash.

Although the field `db_replicas` exists and is configurable by the user in the `scst-store-values.yaml` file, it is experimental and is not recommended to be used.
For production please use AWS RDS. See instructions [here](use_aws_rds.md).

Initial investigation has been done to use `Velero` as the backup method for the default database that comes with the deployment.
Read more about using `Velero` as back up [here](backups.md).

