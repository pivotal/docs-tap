# Connecting to the Postgres Database

To connect to the Postgres Database, you will need the following values:
* database name
* username
* password
* database host
* database port
* database CA certificate

1. To obtain the database name, username, password, and CA cert, run the following commands:
    ```shell
    db_name=$(kubectl get secret postgres-db-secret -n metadata-store -o json | jq -r '.data.POSTGRES_DB' | base64 -d)
    db_username=$(kubectl get secret postgres-db-secret -n metadata-store -o json | jq -r '.data.POSTGRES_USER' | base64 -d)
    db_password=$(kubectl get secret postgres-db-secret -n metadata-store -o json | jq -r '.data.POSTGRES_PASSWORD' | base64 -d)
   
    db_ca_dir=$(mktemp -d -t ca-cert-XXXX)
    db_ca_path="$db_ca_dir/ca.crt"
    kubectl get secrets postgres-db-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > $db_ca_path
    ```
    If the password was auto-generated, the above `password` command will return an empty string. Instead, run the following command:
    ```shell
    db_password=$(kubectl get secret postgres-db-password -n metadata-store -o json | jq -r '.data.DB_PASSWORD' | base64 -d)
    ```
1. In a separate terminal, run the following command:

    ```shell
    kubectl port-forward service/metadata-store-db 5432:5432 -n metadata-store
    ```

    Set the database host and port values on the first terminal with the following:
    
    ```shell
    db_host="localhost"
    db_port=5432
    ```
    
    To port forward to a different local port number, use the following command template:
    
    ```shell
    kubectl port-forward service/metadata-store-db <LOCAL_PORT>:5432 -n metadata-store
    ```

With this setup, you can now connect to the database and make queries like the following example:
```shell
psql "host=$db_host port=$db_port user=$db_username dbname=$db_name sslmode=verify-ca sslrootcert=$db_ca_path" -c "SELECT * FROM images"
```
You could also use GUI clients such as [Postico](https://eggerapps.at/postico2/) or [DBeaver](https://dbeaver.io/) to interact with the database.
