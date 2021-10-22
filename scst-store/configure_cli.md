# Configuring the CLI

This topic explains how to configure the following before using the CLI:

1. Setting the Access Token.
1. Get the location of the Certificate Authority Cert.
1. Setting the Target and Certificate Authority Cert.

## Setting the Access Token

See [instructions on setting the access token](create_service_account_access_token.md#set-access-token).

## Get the location of the Certificate Authority Cert

For information about obtaining the CA certificate, see [Enabling an Encrypted Connection](enable_encrypted_connection.md).

## Setting the Target and Certificate Authority Cert

The target endpoint must be: `https://metadata-store-app.metadata-store.svc.cluster.local:<port>`.

To set the target endpoint and CA certificate: 

Use `insight config set-target` to point the CLI to the endpoint where to the CA certificate lives. Replace `/tmp/ca.crt` with where you want to put the CA cert:

```sh
insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 --ca-cert /tmp/ca.crt
```

For example:

```sh
$ insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 --ca-cert /tmp/ca.crt

Using config file: /Users/username/.insight/config.yaml
Setting endpoint in config to: https://metadata-store-app.metadata-store.svc.cluster.local:8443
```

## Check the Connection

Now check that you configuration is correct and you're able to make a connection.

```sh
insight health
```

For example:

```sh
$ insight health
{"message":"Successfully Reached Metadata Store!"}
```
