# Configure the Tanzu Insight CLI plug-in

This topic explains how to configure the Tanzu Insight plug-in.

## <a id='set-tar-cert'></a>Set the target and certificate authority (CA) certificate

**Note** These instructions are for the recommended configuration where ingress is enabled. For
instructions on non-ingress setups,
see [Configure target endpoint and certificate](../../scst-store/using-encrypted-connection.hbs.md#additional-resources)
for more details.

```console
tanzu insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:PORT --ca-cert PATH
```

Where

- `PORT` is the target endpoint port
- `PATH` is the direct path to the CA certificate

For example:

```console
$ tanzu insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 --ca-cert /tmp/ca.crt

ℹ  Using config file: /Users/username/.config/tanzu/insight/config.yaml
ℹ  Setting trustedcacert in config
ℹ  Setting endpoint in config to: https://metadata-store-app.metadata-store.svc.cluster.local:8443
✔  Success: Set Metadata Store endpoint
```

## <a id='check-con'></a>Verify the connection

Verify that your configuration is correct and you can make a connection using `tanzu insight health`.

> **Important** The `tanzu insight health` command tests the configured endpoint and CA certificate.
> However, it does not test whether the access token is correct.
> For that you must use the plug-in to [add](add-data.hbs.md) and [query](query-data.hbs.md) data.

For example:

```console
$ tanzu insight health
Success: Reached Metadata Store!
```
