# Use external PostgreSQL database for Supply Chain Security Tools - Store

For production deployments, it is recommended to use an external Postgres database rather the one packaged with the Tanzu Application Platform.  This will allow you to manage it via best practices and process that your organization have established.  This topic describes how you can configure your TAP deployment to use an external database.

## <a id='prereqExtrenalDB'></a>Prerequisites

- Gather the connection information for the external PostgreSQL database: 

   1. Database Instance Connect Endpoint
   2. (Optional if TLS is enabled and certificate is self signed) CA Certificate that signed the certificate
   3. Database Credentials
   4. Name of the datbase to use for AMR/MDS

- Connectivity to the Postgres datbase is avaiable from the AMR and MDS services
- If migrating from the internal to an external database, be sure to backup the data before proceeding

## Configuring AMR and MDS to use the external database

1. Update the TAP values for your deployment to include the following configurations:

   ```yaml
   metadata-store: 
     db_host: "<DB Instance Endpoint>"
     db_user: "<Master Username>"
     db_password: "<Master Password>"
     db_name: "<Database Name>"
     # SEE NOTE BELOW
     # Disable the internal database deployment
     deploy_internal_db: "false"
     db_port: "5432"
     db_max_open_conns: 10
     db_max_idle_conns: 100
     db_conn_max_lifetime: 60
     # If TLS is enabled on Postgres Instance
     db_sslmode: "verify-full"
     # If TLS Certificate is self-signed
     db_ca_certificate: |
       <Corresponding CA Certification>
       ...
       ...
       ...
   ```
   > **Note** If you initially deployed TAP with an internal datbase and are migrating to an external database, be aware setting `deploy_internal_db` to `false,`  will remove the internal instance of PostgreSQL.  Be sure to backup and migrate your data to the database prior to setting this value to false or it may result in data loss.

2. Apply the new configuration
   ```console
   tanzu package installed update tap -p tap.tanzu.vmware.com -v {{ vars.tap_version }}  --values-file tap-values.yaml -n tap-install
   ```
3. (Optional) If you are migrating from the internal database to an external database, the reconcilation above may fail.  In order for it to succeed, you must manually delete the secret that cert-manager created and cycle the AMR and MDS services so that the new secret can be picked up.
   ```console
   kubectl delete secret -n metadata-store postgres-db-tls-cert
   kubectl rollout restart -n metadata-store deployment metadata-store-app amr-graphql-app
   ```

## Validation

Verification was done using bitnami PostgreSQL. You can get more information from the [bitnami documentation](https://github.com/bitnami/charts/tree/main/bitnami/postgresql).