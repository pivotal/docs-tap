# TLS configuration

This guide describes TLS configuration for Supply Chain Security Tools (SCST) - Store.

> **Note:** SCST - Store only supports TLS v1.2.

## Change server TLS ciphers

### Setting up custom ingress TLS ciphers

In the `tap-values.yaml` file, `tls.server.rfcCiphers` are set as shown in the following YAML:

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

`tls.server.rfcCiphers`: List of cipher suites for the server. Values are from the [Go TLS package constants](https://golang.org/pkg/crypto/tls/#pkg-constants). If omitted, the default Go cipher suites are used. Here are the default values.

- `TLS_<!--฿ Use dashes for spacing in placeholders, not underscores. ฿-->AES_128_GCM_SHA256`
- `TLS_<!--฿ Use dashes for spacing in placeholders, not underscores. ฿-->AES_256_GCM_SHA384`
- `TLS_<!--฿ Use dashes for spacing in placeholders, not underscores. ฿-->ECDHE_ECDSA_WITH_AES_128_GCM_SHA256`
- `TLS_<!--฿ Use dashes for spacing in placeholders, not underscores. ฿-->ECDHE_ECDSA_WITH_AES_256_GCM_SHA384`
- `TLS_<!--฿ Use dashes for spacing in placeholders, not underscores. ฿-->ECDHE_RSA_WITH_AES_128_GCM_SHA256`
- `TLS_<!--฿ Use dashes for spacing in placeholders, not underscores. ฿-->ECDHE_RSA_WITH_AES_256_GCM_SHA384`

### Example custom TLS settings

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

- [Custom certificate configuration](custom-cert.hbs.md)
- [Ingress support](ingress.hbs.md)