# Package values for AWS Services

This topic lists the keys and values that you can use to configure the behavior of the AWS Services package.

## <a id="globals"></a> Globals

The following table lists global configuration that applies across all services.

| KEY                                                    | DEFAULT              | TYPE     | DESCRIPTION                                                                                                             |
|--------------------------------------------------------|----------------------|----------|-------------------------------------------------------------------------------------------------------------------------|
| ca_cert_data                                           | ""                   | string   | PEM-encoded certificate data for the AWS Provider(s) to trust TLS connections with a custom CA.                         |
| globals.crossplane_system_namespace                    | crossplane-system    | string   | The name of the namespace in which Crossplane and the Providers are deployed to.                                        |
| globals.create_clusterroles                            | true                 | boolean  | Specifies whether to create default ClusterRoles that grant `claim` permissions to all TAP Application Operators.       |

## <a id="postgresql"></a> PostgreSQL

The following table lists configuration that applies to the `postgresql` service.

| KEY                                                    | DEFAULT              | TYPE     | DESCRIPTION                                                                                                             |
|--------------------------------------------------------|----------------------|----------|-------------------------------------------------------------------------------------------------------------------------|
| postgresql.enabled                                     | false                | boolean  | Enable the PostgreSQL service class.                                                                                    |
| postgresql.infrastructure.security_groups              |                      | array    | The security groups your PostgreSQL databases will belong to.                                                           |
| postgresql.infrastructure.subnet_group.name            | ""                   | string   |                                                                                                                         |
| postgresql.instance_configuration.engine_version       | "13.7"               | string   | The PostgreSQL version. See https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts.General.DBVersions.|
| postgresql.instance_configuration.instance_class       | db.t3.micro          | string   | The instance type of the RDS instance. See https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html.|
| postgresql.instance_configuration.maintenance_window   | Mon:00:00-Mon:03:00  | string   | The window to perform maintenance in. Syntax: ddd:hh24:mi-ddd:hh24:mi. Eg: Mon:00:00-Mon:03:00. See https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html#Concepts.DBMaintenance.|
| postgresql.instance_configuration.publicly_accessible  | false                | boolean  | Control if your instances will be publicly accessible.                                                                  |
| postgresql.instance_configuration.skip_final_snapshot  | false                | boolean  | Determines whether a final snapshot is created before the instance is deleted. If true is specified, no snapshot is created. If false is specified, a snapshot called final-snapshot-<instance-name> is created before the instance is deleted.|
| postgresql.provider_config_ref.name                    | default              | string   |                                                                                                                         |
| postgresql.region                                      | us-east-1            | string   | The AWS region to create databases in.                                                                                  |
