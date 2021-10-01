# Configuring the CLI

Before using CLI commands, you need to follow these steps:

1. Get location of an access token
1. Get location of the Certificate Authority Cert
1. Setting the Target and Certificate Authority Cert

## Setting the Access Token with `METADATA_STORE_ACCESS_TOKEN`

To set the access token with `METADATA_STORE_ACCESS_TOKEN`:

## Certificate Authority Cert

See [Enabling an Encrypted Connection](enable_encrypted_connection) for how to obtain the CA certificate

## Setting the Target and Certificate Authority Cert

The target endpoint must be  — must be `https://metadata-store-app.metadata-store.svc.cluster.local:<port>`.

To set the target and certificate authority cert: 

1. Use `insight config set-target` to point the CLI to the endpoint where to the CA certificate lives:

    ```sh
    $ insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 [--ca-cert <path to CA certificate file>]
    ```

    For example, if your CA certificate file is located at `/tmp/ca.crt` use the following code sample:

    ```sh
    $ insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 --ca-cert /tmp/ca.crt

    Using config file: /Users/username/.insight/config.yaml
    Setting endpoint in config to: https://metadata-store-app.metadata-store.svc.cluster.local:8443

    $ insight image get --digest example-digest
    Error: {"message":"Image not found"}
    ...
    ```
