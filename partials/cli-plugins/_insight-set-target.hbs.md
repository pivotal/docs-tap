{{#if ingress}}
To get the certificate, run:

```bash
kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```
{{else}}

Because you deployed SCST - Store without using Ingress,
you must use the Certificate resource `app-tls-cert` for HTTPS communication.
To get the CA Certificate:

```bash
kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
```
{{/if}}

Set the target by running:
{{#if ingress}}
```bash
tanzu insight config set-target https://$METADATA-STORE-DOMAIN --ca-cert insight-ca.crt
```
{{else}}
```bash
tanzu insight config set-target https://$METADATA-STORE-DOMAIN:$METADATA-STORE-PORT --ca-cert insight-ca.crt
```
{{/if}}

> **Important** The `tanzu insight config set-target` does not initiate a test connection.
> Use `tanzu insight health` to test connecting using the configured endpoint and CA certificate.
> Neither commands test whether the access token is correct.
> You must use the plug-in to [add](add-data.hbs.md) and [query](query-data.hbs.md) data.
