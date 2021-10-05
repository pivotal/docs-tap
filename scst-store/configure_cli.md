# Configuring the CLI

This topic explains how to configure the following before using the CLI:

1. Get the location of an access token.
1. Get the location of the Certificate Authority Cert.
1. Setting the Target and Certificate Authority Cert.

## Setting the Access Token with `METADATA_STORE_ACCESS_TOKEN`

To set the access token with `METADATA_STORE_ACCESS_TOKEN`:

## Certificate Authority Cert

For information about obtaining the CA certificate, see [Enabling an Encrypted Connection](enable_encrypted_connection).

## Setting the Target and Certificate Authority Cert

The target endpoint must be: `https://metadata-store-app.metadata-store.svc.cluster.local:<port>`.

To set the target endpoint and CA certificate: 

1. Use `insight config set-target` to point the CLI to the endpoint where to the CA certificate lives. Run:

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
