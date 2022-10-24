# Custom certificate and TLS configuration

This guide describes certificate and TLS configuration for Supply Chain Security Tools (SCST) - Store.

1. Default configuration
1. Custom certificate
1. TLS configuration

**Note**: SCST - Store supports only TLS 1.2.

## Default configuration

By default SCST - Store creates a self-signed certificate. And TLS communication is automatically enabled.

If [ingress support](ingress.hbs.md) is enabled, SCST - Store installation creates an HTTPProxy entry with host routing by using the qualified name `metadata-store.<ingress_domain>`, for example `metadata-store.example.com`. The created route supports HTTPS communication using the self-signed certificate with the same subject *Alternative Name*.

## (Optional) Setting up custom ingress TLS certificate

Optionally, users can configure TLS to use a custom certificate. In order to do that, follow these steps:

1. Place the certificates in secret
1. Modify the `tap-values.yaml` to use this secret

### Place the certificates in secret

The certificate secret should be created before deploying Supply Chain Security Tools - Store. Create a Kubernetes object with kind `Secret` and type `kubernetes.io/tls`.

### Update `tap-values.yaml`

In the `tap-values.yaml` file, you can configure the metadata store to use the `namespace` and `secretName` from the secret created in the last step.

```yaml
metadata_store:
  tls:
    namespace: "namespace"
    secretName: "secretName"
```

* `namespace`: The targeted namespace for secret consumption by the HTTPProxy. 
* `secretName`: The name of secret for consumption by the HTTPProxy.

## Change server TLS Ciphers

### Setting up custom ingress TLS ciphers

In the `tap-values.yaml` file, `tls.server.rfcCiphers` can be set as shown below:

```yaml
metadata_store:
  tls:
    server:
      rfcCiphers:
        - TLS_AES_128_GCM_SHA256
        - TLS_AES_256_GCM_SHA384
        - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
```

`tls.server.rfcCiphers`: List of cipher suites for the server. Values are from the [Go TLS package constants](https://golang.org/pkg/crypto/tls/#pkg-constants). If omitted, the default Go cipher suites will be used. Here are the default values.

- `TLS_AES_128_GCM_SHA256`
- `TLS_AES_256_GCM_SHA384`
- `TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`
- `TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`
- `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`
- `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`


### Example Custom TLS settings

Here's the complete example of TLS configuration.

```yaml
metadata_store:
  tls:
    namespace: "namespace"
    secretName: "secretName"
    server:
      rfcCiphers:
        - TLS_AES_128_GCM_SHA256
        - TLS_AES_256_GCM_SHA384
        - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
```

## Additional resources

* [Ingress support](ingress.hbs.md)