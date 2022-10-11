
# Setting up custom TLS settings in the Store

###  <a id="setting_up_tls_namespace_and_secretName"></a>Setting up custom ingres tls certificate

In the `tap-values.yaml` file, `namespace` and `secretName`  can be set as shown below:

---
```yaml
tls:
  namespace: "namespace"
  secretName: "secretName"
```
---
---
```
`namespace` : The targeted namespace for secret consumption by the HTTPProxy. 
`secretName` : The name of secret for consumption by the HTTPProxy.
```
---
  ##### Note: The certificate secret should be created before deploying the Store. By default Store will be setup with self signed certificate when ingres is enabled.

###  <a id="change_server_tls_ciphers"></a>Change server TLS Ciphers

###  <a id="setting_up_custom_ingres_tls_ciphers"></a>Setting up custom ingres tls ciphers

In the `tap-values.yaml` file, `tls.server.rfcCiphers` can be set as shown below:

tls:
  server:
    rfcCiphers:
      - TLS_AES_128_GCM_SHA256
      - TLS_AES_256_GCM_SHA384
      - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
      - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
      - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
      - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384

---
```
`tls.server.rfcCiphers` : List of cipher suites for the server. Values are from tls package constants (https://golang.org/pkg/crypto/tls/#pkg-constants). If omitted, the default Go cipher suites will be used. Default value is
```
---
      - TLS_AES_128_GCM_SHA256
      - TLS_AES_256_GCM_SHA384
      - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
      - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
      - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
      - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384


### Example Custom TLS settings

---
```yaml
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
---
#### <span style="color:red">Note: Store supports only `VersionTLS12`</span>.
