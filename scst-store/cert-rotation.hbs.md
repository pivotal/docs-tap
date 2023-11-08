# Certificate rotation for Supply Chain Security Tools - Store

This topic describes how you can rotate TLS certificates for Supply Chain Security Tools (SCST) - Store.

## Certificates

By default, the `use_cert_manager` setting is set to `"true"`. When the setting
`use_cert_manager` is `"true"` the Store uses `cert-manager` to generate a CA
certificate, an API certificate, and a database Certificate.

To see these certificates:

```console
$ kubectl get certificate -n metadata-store
NAME                    READY   SECRET                  AGE
app-tls-ca-cert         True    app-tls-ca-cert         38d
app-tls-cert            True    app-tls-cert            38d
postgres-db-tls-cert    True    postgres-db-tls-cert    38d
```

The earlier certificates are automatically rotated by `cert-manager`.

The Store can run these certificates automatically once `cert-manager` rotates them.

If the environment is a [multi-cluster](multicluster-setup.hbs.md) setup, the
operator must manually copy over the new CA certificate to the build cluster.

## Certificate duration setting
 
In the `tap-values.yaml` file, `api_cert_duration`, `api_cert_renew_before`,
`ca_cert_duration`, and `ca_cert_renew_before`  are configurable as shown in the
following YAML:

```yaml
metadata_store:
  ca_cert_duration: CA-DURATION
  ca_cert_renew_before: CA-RENEW
  api_cert_duration: API-DURATION
  api_cert_renew_before: API-RENEW
```

Where: 

- `CA-DURATION` is the duration that the ca certificate is valid for. Must be
  given in `h`, `m`, or `s`. Default value is 8760h.
- `CA-RENEW` is how long before the expiry of the ca certificate is renewed.
  Must be given in `h`, `m`, or `s`. Default value is 1h.
- `API-DURATION` is the duration that the API certificate is valid for. Must be
  given in `h`, `m`, or `s`. Default value is 2160h.
- `API-RENEW` is how long before the expiry of the API certificate is renewed.
  Must be given in h, m, or s. Default value is 24h.

>**Important** The `*_cert_duration` and the corresponding `*_renew_before`
settings must not be close. For more information, see the [cert-manager
documentation](https://cert-manager.io/docs/usage/certificate/#renewal). This
can lead to a renewal loop. The `*_cert_duration` must be greater than the
corresponding `*_renew_before`. The earlier settings only take effect when
`use_cert_manager` is `"true"`. If the `use_cert_manager` is not set, it
defaults to `"true"`.