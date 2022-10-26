# Setting up custom TLS configuration

Supply Chain Security Tools - Store supports only TLS 1.2.

> **Note:** SCST - Store only supports TLS v1.2.

## (Optional) Setting up custom ingress TLS certificate

Optionally, users can configure TLS to use a custom certificate. In order to do that, follow these steps:

1. Place the certificates in secret
1. Modify the `tap-values.yaml` to use this secret

## Place the certificates in secret

The certificate secret should be created before deploying Supply Chain Security Tools - Store. Create a Kubernetes object with kind `Secret` and type `kubernetes.io/tls`.

## Update `tap-values.yaml`

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

## Example Custom TLS settings

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

- [Ingress support](ingress.hbs.md)
