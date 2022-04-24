# Configure the CLI

This topic explains how to configure the `insight` CLI:

> **Note:** All [required set up](../scst-store/overview.md#required-set-up) must be completed in addition to configuring the CLI


## Set the Target and Certificate Authority Cert

Set the target endpoint and CA certificate by running: 

```sh
insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:PORT --ca-cert PATH
```
Where

- `PORT` is the target endpoint port
- `PATH` is direct path to the CA certificate

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
