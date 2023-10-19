# Package values for AWS Services

This topic lists the keys and values that you can use to configure the behavior of the AWS Services package.

## <a id="globals"></a> Globals

The following table lists global configuration that applies across all services.

| KEY                                 | DEFAULT             | TYPE    | DESCRIPTION                                                                                                                             |
| ----------------------------------- | ------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| ca_cert_data                        | `""`                | string  | PEM-encoded certificate data for the AWS Providers to trust TLS connections with a custom CA                                        |
| globals.crossplane_system_namespace | `crossplane-system` | string  | The name of the namespace in which Crossplane and the providers are deployed to                                                         |
| globals.create_clusterroles         | `true`              | boolean | Specifies whether to create default ClusterRoles that grant `claim` permissions to all Tanzu Application Platform application operators |

## <a id="postgresql"></a> PostgreSQL

The following table lists configuration that applies to the `postgresql` service.

| KEY                                                   | DEFAULT               | TYPE    | DESCRIPTION                                                                                                                                                                                                                                                                            |
| ----------------------------------------------------- | --------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| postgresql.enabled                                    | `false`               | boolean | Enables the PostgreSQL service class                                                                                                                                                                                                                                                   |
| postgresql.infrastructure.security_groups             | _n/a_                 | array   | Security groups for your PostgreSQL databases to belong to                                                                                                                                                                                                                         |
| postgresql.infrastructure.subnet_group.name           | `""`                  | string  | <!-- needs description -->                                                                                                                                                                                                                                                             |
| postgresql.instance_configuration.engine_version      | `"13.7"`              | string  | The PostgreSQL version. For more information, see the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts.General.DBVersions).                                                                                         |
| postgresql.instance_configuration.instance_class      | `db.t3.micro`         | string  | The instance type of the RDS instance. For more information, see the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html).                                                                                                        |
| postgresql.instance_configuration.maintenance_window  | `Mon:00:00-Mon:03:00` | string  | The window to perform maintenance in. Syntax: `ddd:hh24:mi-ddd:hh24:mi`, for example, `Mon:00:00-Mon:03:00`. For more information, see the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html#Concepts.DBMaintenance). |
| postgresql.instance_configuration.publicly_accessible | `false`               | boolean | Controls whether your instances are publicly accessible                                                                                                                                                                                                                                |
| postgresql.instance_configuration.skip_final_snapshot | `false`               | boolean | Determines whether a final snapshot is created before the instance is deleted. If you specify true, no snapshot is created. If you specify false, a snapshot called final-snapshot-INSTANCE-NAME is created before the instance is deleted.                                            |
| postgresql.provider_config_ref.name                   | `default`             | string  | <!-- needs description -->                                                                                                                                                                                                                                                             |
| postgresql.region                                     | `us-east-1`           | string  | The AWS region to create databases in                                                                                                                                                                                                                                                  |
