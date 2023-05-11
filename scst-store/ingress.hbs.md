# Ingress support for Supply Chain Security Tools - Store

This topic describes how to configure ingress for Supply Chain Security Tools (SCST) - Store.

## Ingress configuration

Supply Chain Security Tools (SCST) - Store has ingress support by using
Contour's HTTPProxy resources. To enable ingress support, a Contour installation
must be available in the cluster.

To change ingress configuration, edit your `tap-values.yaml` when you install a
Tanzu Application Platform profile. When you configure the `shared.ingress_domain`
property, SCST - Store automatically uses that setting.

Alternatively, you can customize SCST - Store's configuration under the
`metadata_store` property. Under `metadata_store`, there are two values to
configure the proxy:

- `ingress_enabled`
- `ingress_domain`

This is an example snippet in a `tap-values.yaml`:

```yaml
...
metadata_store:
  ingress_enabled: "true"
  ingress_domain: "example.com"
  app_service_type: "ClusterIP"  # Defaults to `LoadBalancer`. If ingress is enabled then this should be set to `ClusterIP`.
...
```

SCST - Store installation creates an HTTPProxy entry with host routing by using
the qualified name `metadata-store.<ingress_domain>`. For example,
`metadata-store.example.com`. The route supports HTTPS communication using a
certificate. By default, a self-signed certificate is used with the same subject
`alternative name`. See [Custom certificate configuration](custom-cert.hbs.md)
for information about how to configure custom certificates.

Contour and DNS setup are not part of SCST - Store installation. Access to SCST - Store using Contour depends on the correct configuration of these two
components.

Make the proper DNS record available to clients to resolve `metadata-store` and
set `ingress_domain` to Envoy service's external IP address.

DNS setup example:

```bash
$ kubectl describe svc envoy -n tanzu-system-ingress
> ...
  Type:                     LoadBalancer
  ...
  LoadBalancer Ingress:     100.2.3.4
  ...
  Port:                     https  443/TCP
  ...

$ nslookup metadata-store.example.com
> Server:    8.8.8.8
  Address:  8.8.8.8#53

  Non-authoritative answer:
  Name:  metadata-store.example.com
  Address: 100.2.3.4

$ curl https://metadata-store.example.com/api/health -k -v
> ...
  < HTTP/2 200
  ...
```

>**Note** The preceding `curl` example uses the not secure `-k` flag to skip
>TLS verification because the Store installs a self-signed certificate. The
>following section shows how to access the CA certificate to enable TLS
>verification for HTTP clients.

## <a id="tls"></a>Get the TLS CA certificate

To get SCST - Store's TLS CA certificate, use `kubectl get secret`. In this
example, you save the certificate for the environment variable to a file.

```console
kubectl get secret CERT-NAME -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > OUTPUT-FILE
```

Where:

- `CERT-NAME` is the name of the certificate. This must be `ingress-cert` if no
  custom certificate is used.
- `OUTPUT-FILE` is the file you want to create to store the certificate.

For example:

```bash
$ kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
$ cat insight-ca.crt
```

## Additional Resources

* [Custom certificate configuration](custom-cert.hbs.md)
* [TLS configuration](tls-configuration.hbs.md)
* [Configure target endpoint and certificate](using-encryption-and-connection.hbs.md)
