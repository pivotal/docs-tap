{{#if ingress}}
To get the certificate, run:

```console
kubectl get secret tap-ingress-selfsigned-root-ca -n cert-manager -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```

{{else}}

Because you deployed Supply Chain Security Tools (SCST) - Store without using Ingress,
you must use the Certificate resource `app-tls-cert` for HTTPS communication.

To get the CA Certificate:

```console
kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```

{{/if}}

Set the target by running:

{{#if ingress}}

```console
tanzu insight config set-target https://$METADATA_STORE_DOMAIN --ca-cert insight-ca.crt
```

{{else}}

```console
tanzu insight config set-target https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT --ca-cert insight-ca.crt
```

{{/if}}

> **Important** The `tanzu insight config set-target` does not initiate a test connection.
> Use `tanzu insight health` to test connecting using the configured endpoint and CA certificate.
> Neither commands test whether the access token is correct.
> For that you must use the plug-in to [add data](/docs-tap/cli-plugins/insight/add-data.hbs.md)
> and [query data](/docs-tap/cli-plugins/insight/query-data.hbs.md).
