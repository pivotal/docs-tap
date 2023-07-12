# Use external PostgreSQL database for Supply Chain Security Tools - Store

This topic describes how you can configure and use your external PostgreSQL database for Supply Chain Security Tools (SCST) - Store.

## <a id='prereqExtrenalDB'></a>Prerequisites

- Set up your external PostgreSQL database. After the database instance starts, retrieve the following information:

   1. Database Instance Endpoint
   2. Main User name
   3. Main Password
   4. Database Name

## Set up certificate and configuration

1. Create a security group to allow inbound connections from the cluster to the PostgreSQL database.

2. Retrieve the corresponding CA Certificate that signed the PostgreSQL TLS Certificate.

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

> **Note** If `deploy_internal_db` is set to `false,` an instance of PostgreSQL is not deployed in the cluster.

## Validation

Verification was done using bitnami PostgreSQL. You can get more information from the [bitnami documentation](https://github.com/bitnami/charts/tree/main/bitnami/postgresql).