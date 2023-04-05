# Package values

This topic lists the keys and values that you can use to configure the behavior of the Bitnami Services Package.
You can apply configuration globally to all services using the `globals` key, or on a per-service basis
using the `mysql`, `postgresql`, `rabbitmq` and `redis` keys.

If you are applying configuration to Tanzu Application Platform through the use of profiles and the `tap-values.yaml`,
all configuration must exist under the `bitnami_services` top-level key.

For example:

```yaml
bitnami_services:
  globals:
    helm_chart:
      # If you choose to use a custom Helm Chart repo, it's possible you'll also need to configure specific versions
      # for each Chart as well, see example configuration below for postgresql.
      repo: https://charts.mycompany.example.com
  mysql:
    enabled: false
  postgresql:
    helm_chart:
      version: 12.2.6
    instance_class:
      name: company-redis
      description: My company postgres
  rabbitmq:
    instance_class:
      name: company-redis
      description: My company rabbit
  redis:
    instance_class:
      name: company-redis
      description: My company redis
```

## <a id="globals"></a> Globals

The following table lists configuration that applies to all services.

|KEY                                                        |DEFAULT                             |TYPE     |DESCRIPTION|
|-----------------------------------------------------------|------------------------------------|---------|-----------|
|globals.create_clusterroles                                |true                                |boolean  |Optional: Specifies whether to create default ClusterRoles that grant `claim` permissions to all TAP Application Operators.|
|globals.helm_chart.chart_pull_secret_ref.name              |""                                  |string   |Name of the pull secret. Can be overridden by individual services.|
|globals.helm_chart.chart_pull_secret_ref.namespace         |""                                  |string   |Namespace of the pull secret. Can be overridden by individual services.|
|globals.helm_chart.container_pull_secret_ref.name          |""                                  |string   |Name of the secret. Can be overridden by individual services.|
|globals.helm_chart.container_pull_secret_ref.namespace     |""                                  |string   |Namespace of the secret. Can be overridden by individual services.|
|globals.helm_chart.repo                                    |https://charts.bitnami.com/bitnami  |string   |Optional: Repository hosting the Helm charts used to provision the instances of all services. Can be overridden by individual |services.|
|globals.shared_namespace                                   |""                                  |string   |Optional: Name of the namespace that is shared by all provisioned instances of all services. By default, each instance will be |provisioned in its own dedicated namespace. Can be overridden by individual services.|

## <a id="mysql"></a>MySQL

The following table lists configuration that applies to the `mysql` service.

|KEY                                                        |DEFAULT                             |TYPE     |DESCRIPTION|
|-----------------------------------------------------------|------------------------------------|---------|-----------|
|mysql.defaults.storage_size_gb                             |1                                   |integer  |Optional: The amount of storage to give each MySQL instance by default, in Gigabytes|
|mysql.enabled                                              |true                                |boolean  |Optional: Provide developers an offering for unmanaged MySQL instances|
|mysql.helm_chart.repo                                      |""                                  |string   |Optional: Repository hosting the Helm chart used to provision MySQL instances|
|mysql.helm_chart.version                                   |9.5.0                               |string   |Optional: Version of the Helm chart used to provision MySQL instances|
|mysql.helm_chart.chart_pull_secret_ref.name                |""                                  |string   |Name of the pull secret.|
|mysql.helm_chart.chart_pull_secret_ref.namespace           |""                                  |string   |Namespace of the pull secret.|
|mysql.helm_chart.container_pull_secret_ref.name            |""                                  |string   |Name of the secret. Can be overridden by individual services.|
|mysql.helm_chart.container_pull_secret_ref.namespace       |""                                  |string   |Namespace of the secret. Can be overridden by individual services.|
|mysql.instance_class.description                           |MySQL by Bitnami                    |string   |Optional: Description of the ClusterInstanceClass that is used by Developers to provision and claim MySQL instances|
|mysql.instance_class.name                                  |mysql-unmanaged                     |string   |Optional: Name of the ClusterInstanceClass that is used by Developers to provision and claim MySQL instances|
|mysql.shared_namespace                                     |""                                  |string   |Optional: Name of the namespace that is shared by all provisioned MySQL instances. By default, each instance will be provisioned in |its own dedicated namespace.|

## <a id="postgresql"></a> PostgreSQL

The following table lists configuration that applies to the `postgresql` service.

|KEY                                                        |DEFAULT                             |TYPE     |DESCRIPTION|
|-----------------------------------------------------------|------------------------------------|---------|-----------|
|postgresql.enabled                                         |true                                |boolean  |Optional: Provide developers an offering for unmanaged PostgreSQL instances|
|postgresql.helm_chart.chart_pull_secret_ref.name           |""                                  |string   |Name of the pull secret.|
|postgresql.helm_chart.chart_pull_secret_ref.namespace      |""                                  |string   |Namespace of the pull secret.|
|postgresql.helm_chart.container_pull_secret_ref.name       |""                                  |string   |Name of the secret. Can be overridden by individual services.|
|postgresql.helm_chart.container_pull_secret_ref.namespace  |""                                  |string   |Namespace of the secret. Can be overridden by individual services.|
|postgresql.helm_chart.repo                                 |""                                  |string   |Optional: Repository hosting the Helm chart used to provision PostgreSQL instances|
|postgresql.helm_chart.version                              |12.2.0                              |string   |Optional: Version of the Helm chart used to provision PostgreSQL instances|
|postgresql.instance_class.description                      |PostgreSQL by Bitnami               |string   |Optional: Description of the ClusterInstanceClass that is used by Developers to provision and claim PostgreSQL instances|
|postgresql.instance_class.name                             |postgresql-unmanaged                |string   |Optional: Name of the ClusterInstanceClass that is used by Developers to provision and claim PostgreSQL instances|
|postgresql.shared_namespace                                |""                                  |string   |Optional: Name of the namespace that is shared by all provisioned PostgreSQL instances. By default, each instance will be provisioned |in its own dedicated namespace.|
|postgresql.defaults.storage_size_gb                        |1                                   |integer  |Optional: The amount of storage to give each PostgreSQL instance by default, in Gigabytes|

## <a id="rabbitmq"></a> RabbitMQ

The following table lists configuration that applies to the `rabbitmq` service.

|KEY                                                        |DEFAULT                             |TYPE     |DESCRIPTION|
|-----------------------------------------------------------|------------------------------------|---------|-----------|
|rabbitmq.enabled                                           |true                                |boolean  |Optional: Provide developers an offering for unmanaged RabbitMQ instances|
|rabbitmq.helm_chart.container_pull_secret_ref.name         |""                                  |string   |Name of the secret. Can be overridden by individual services.|
|rabbitmq.helm_chart.container_pull_secret_ref.namespace    |""                                  |string   |Namespace of the secret. Can be overridden by individual services.|
|rabbitmq.helm_chart.repo                                   |""                                  |string   |Optional: Repository hosting the Helm chart used to provision RabbitMQ instances|
|rabbitmq.helm_chart.version                                |11.10.0                             |string   |Optional: Version of the Helm chart used to provision RabbitMQ instances|
|rabbitmq.helm_chart.chart_pull_secret_ref.name             |""                                  |string   |Name of the pull secret.|
|rabbitmq.helm_chart.chart_pull_secret_ref.namespace        |""                                  |string   |Namespace of the pull secret.|
|rabbitmq.instance_class.description                        |RabbitMQ by Bitnami                 |string   |Optional: Description of the ClusterInstanceClass that is used by Developers to provision and claim RabbitMQ instances|
|rabbitmq.instance_class.name                               |rabbitmq-unmanaged                  |string   |Optional: Name of the ClusterInstanceClass that is used by Developers to provision and claim RabbitMQ instances|
|rabbitmq.shared_namespace                                  |""                                  |string   |Optional: Name of the namespace that is shared by all provisioned RabbitMQ instances. By default, each instance will be provisioned |in its own dedicated namespace.|
|rabbitmq.defaults.replica_count                            |1                                   |integer  |Optional: The number of replicas to create for each RabbitMQ instance by default|
|rabbitmq.defaults.storage_size_gb                          |1                                   |integer  |Optional: The amount of storage to give each RabbitMQ instance by default, in Gigabytes|

## <a id="redis"></a>Redis

The following table lists configuration that applies to the `redis` service.

|KEY                                                        |DEFAULT                             |TYPE     |DESCRIPTION|
|-----------------------------------------------------------|------------------------------------|---------|-----------|
|redis.instance_class.description                           |Redis by Bitnami                    |string   |Optional: Description of the ClusterInstanceClass that is used by Developers to provision and claim Redis instances|
|redis.instance_class.name                                  |redis-unmanaged                     |string   |Optional: Name of the ClusterInstanceClass that is used by Developers to provision and claim Redis instances|
|redis.shared_namespace                                     |""                                  |string   |Optional: Name of the namespace that is shared by all provisioned Redis instances. By default, each instance will be provisioned in |its own dedicated namespace.|
|redis.defaults.storage_size_gb                             |1                                   |integer  |Optional: The amount of storage to give each Redis instance by default, in Gigabytes|
|redis.enabled                                              |true                                |boolean  |Optional: Provide developers an offering for unmanaged Redis instances|
|redis.helm_chart.chart_pull_secret_ref.name                |""                                  |string   |Name of the pull secret.|
|redis.helm_chart.chart_pull_secret_ref.namespace           |""                                  |string   |Namespace of the pull secret.|
|redis.helm_chart.container_pull_secret_ref.name            |""                                  |string   |Name of the secret. Can be overridden by individual services.|
|redis.helm_chart.container_pull_secret_ref.namespace       |""                                  |string   |Namespace of the secret. Can be overridden by individual services.|
|redis.helm_chart.repo                                      |""                                  |string   |Optional: Repository hosting the Helm chart used to provision Redis instances|
|redis.helm_chart.version                                   |17.8.0                              |string   |Optional: Version of the Helm chart used to provision Redis instances|
