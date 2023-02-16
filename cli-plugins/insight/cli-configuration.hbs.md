# Configure the Tanzu Insight CLI plug-in

This topic explains how to configure the Tanzu Insight plug-in.

## <a id='set-tar-cert'></a>Set the target and certificate authority (CA) certificate

These instructions are for the recommended configuration where Ingress is enabled. For
instructions on non Ingress setups,
see [Configure target endpoint and certificate](../../scst-store/using-encrypted-connection.hbs.md#additional-resources).

{{> 'partials/insight-ingress-configuration' }}

## <a id='set-access-token'></a>Set the access token

{{> 'partials/insight-set-access-token' }}

## <a id='check-con'></a>Verify the connection

Verify that your configuration is correct and you can make a connection using `tanzu insight health`.

> **Important** The `tanzu insight health` command tests the configured endpoint and CA certificate.
> However, it does not test whether the access token is correct.
> For that, you must use the plug-in to [add](add-data.hbs.md) and [query](query-data.hbs.md) data.

For example:

```console
$ tanzu insight health
Success: Reached Metadata Store!
```
