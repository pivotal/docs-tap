# CLI configuration

This topic explains how to configure the Insight CLI:

> **Note:** All [required setup](../scst-store/overview.md#required-set-up) must be completed in addition to configuring the CLI


## Set the target and certificate authority certificate

Set the target endpoint and CA certificate by running:

```
insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:PORT --ca-cert PATH
```
Where

- `PORT` is the target endpoint port
- `PATH` is the direct path to the CA certificate

For example:

```
$ insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 --ca-cert /tmp/ca.crt

Using config file: /Users/username/.insight/config.yaml
Setting endpoint in config to: https://metadata-store-app.metadata-store.svc.cluster.local:8443
```

## Check the connection

Check that your configuration is correct and you are able to make a connection.

```
insight health
```

For example:

```
$ insight health
{"message":"Successfully Reached Metadata Store!"}
```
