# AWS RDS Postgres configuration

## <a id='prereq'></a>Prerequisites

* AWS Account


### <a id='aws-rds'></a>AWS RDS

1. Create an Amazon RDS Postgres using the [Amazon RDS Getting Started Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.CreatingConnecting.PostgreSQL.html#CHAP_GettingStarted.Creating.PostgreSQL)

2. Once the database instance starts, retrieve the following information:

   1. DB Instance Endpoint
   1. Master Username
   1. Master Password
   1. Database Name

3. Create a security group to allow inbound connections from the cluster to the Postgres DB

4. Retrieve the corresponding CA Certificate that signed the Postgres TLS Certificate using the following [link](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html)

5. In the `metadata-store-values.yaml` fill the following settings:

   ```yaml
   db_host: "<DB Instance Endpoint>"
   db_user: "<Master Username>"
   db_password: "<Master Password>"
   db_name: "<Database Name>"
   db_port: "5432"
   db_sslmode: "verify-full"
   db_max_open_conns: 10
   db_max_idle_conns: 100
   db_conn_max_lifetime: 60
   db_ca_certificate: |
      <Corresponding CA Certification>
      ...
      ...
      ...
   deploy_internal_db: "false"
   ```

> **Note:** If `deploy_internal_db` is set to `false,` an instance of Postgres will not be deployed in the cluster.
