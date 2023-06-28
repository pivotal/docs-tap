# Connect to the PostgreSQL database

You can use a PostgreSQL database with Supply Chain Security Tools - Store.
To connect to the PostgreSQL database, you need the following values:

- database name
- user name
- password
- database host
- database port
- database CA certificate

Connect to the PostgreSQL database:

1. Obtain the database name, user name, password, and CA certificate. Run:

    ```console
    db_name=$(kubectl get secret postgres-db-secret -n metadata-store -o json | jq -r '.data.POSTGRES_DB' | base64 -d)
    db_username=$(kubectl get secret postgres-db-secret -n metadata-store -o json | jq -r '.data.POSTGRES_USER' | base64 -d)
    db_password=$(kubectl get secret postgres-db-secret -n metadata-store -o json | jq -r '.data.POSTGRES_PASSWORD' | base64 -d)

    db_ca_dir=$(mktemp -d -t ca-cert-XXXX)
    db_ca_path="$db_ca_dir/ca.crt"
    kubectl get secrets postgres-db-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > $db_ca_path
    ```

    If the password was auto-generated, the `password` command returns an empty string. Run:

    ```console
    db_password=$(kubectl get secret postgres-db-password -n metadata-store -o json | jq -r '.data.DB_PASSWORD' | base64 -d)
    ```

2. In a separate terminal, run:

    ```console
    kubectl port-forward service/metadata-store-db 5432:5432 -n metadata-store
    ```

3. Set the database host and port values on the first terminal:

    ```console
    db_host="localhost"
    db_port=5432
    ```

4. To port forward to a different local port number, use the following command template:

    ```console
    kubectl port-forward service/metadata-store-db <LOCAL_PORT>:5432 -n metadata-store
    ```

    Where `LOCAL-PORT` is the port number for the database you want to use.

You can now connect to the database and make queries. For example:

```console
psql "host=$db_host port=$db_port user=$db_username dbname=$db_name sslmode=verify-ca sslrootcert=$db_ca_path" -c "SELECT * FROM images"
```

You can use GUI clients such as [Postico](https://eggerapps.at/postico2/) or [DBeaver](https://dbeaver.io/) to interact with the database.
