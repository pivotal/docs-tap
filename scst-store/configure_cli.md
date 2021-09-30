# Configuring the CLI

Before using CLI commands, configure the following:
1. The location of an access token.
1. Target endpoint — must be `https://metadata-store-app.metadata-store.svc.cluster.local:<port>`.
1. The location of the Certificate Authority Cert.

## Setting the Access Token with `METADATA_STORE_ACCESS_TOKEN`

To set the access token with `METADATA_STORE_ACCESS_TOKEN`:

1. Create a service account, if you don't already have one. See [Creating Service Accounts and Access Tokens](create_service_account_access_token.md).

1. Set the `METADATA_STORE_ACCESS_TOKEN` environment variable, or use the `--access-token` flag. VMware does not recommended using the `--access-token` flag, as the token will appear in your shell history. VMware recommends using `METADATA_STORE_ACCESS_TOKEN`.

1. Run the following command to retrieve the access token from Kubernetes and store it in `METADATA_STORE_ACCESS_TOKEN`:

    ```sh
    $ export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
    ```

1.  Replace `metadata-store-read-write-client` with name of the service account you plan to use.

## Setting the Target and Certificate Authority Cert

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
