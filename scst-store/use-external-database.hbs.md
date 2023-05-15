# Use External PostgreSQL database for Supply Chain Security Tools - Store

This topic describes how you can configure and use your External PostgreSQL database for Supply Chain Security Tools (SCST) - Store.

## <a id='prereqExtrenalDB'></a>Prerequisites

* Setup your external postgres database. Once the database instance starts, retrieve the following information:

   1. DB Instance Endpoint
   1. Master Username
   1. Master Password
   1. Database Name

## Setup certificate and configuration

1. Create a security group to allow inbound connections from the cluster to the Postgres DB

2. Retrieve the corresponding CA Certificate that signed the Postgres TLS Certificate.

3. In the `metadata-store-values.yaml` fill the following settings:

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

> **Note** If `deploy_internal_db` is set to `false,` an instance of Postgres will not be deployed in the cluster.

## Validation

Verification was done using bitnami postgres. You can get more information from the [bitnami documentation](https://github.com/bitnami/charts/tree/main/bitnami/postgresql).