# Custom certificate configuration for Supply Chain Security Tools - Store

This topic describes how you can configure the following certificates for Supply Chain Security Tools (SCST) - Store:

1. Default configuration
1. Custom certificate

## Default configuration

By default, SCST - Store creates a self-signed certificate and TLS communication is automatically enabled.

If [ingress support](ingress.hbs.md) is enabled, SCST - Store installation creates an HTTPProxy entry with host routing by using the qualified name `metadata-store.<ingress_domain>`. For example, `metadata-store.example.com`. The created route supports HTTPS communication using the self-signed certificate with the same subject `Alternative Name`.

## (Optional) Setting up custom ingress TLS certificate

(Optional) Users can configure TLS to use a custom certificate. To do that:

1. Place the certificates in the secret.
2. Edit the `tap-values.yaml` to use this secret.

### Place the certificates in secret

1. Create the certificate secret before deploying SCST - Store. 
2. Create a Kubernetes object with kind `Secret` and type `kubernetes.io/tls`.

### Update `tap-values.yaml`

1. In the `tap-values.yaml` file, you can configure the metadata store to use the `namespace` and `secretName` from the secret created in the last step.

```yaml
metadata_store:
  tls:
    namespace: "namespace"
    secretName: "secretName"
```

Where:

- `namespace` is the targeted namespace for secret consumption by the HTTPProxy. 
- `secretName` is the name of secret for consumption by the HTTPProxy.

## Additional resources

- [Ingress support](ingress.hbs.md)
- [TLS configuration](tls-configuration.hbs.md)