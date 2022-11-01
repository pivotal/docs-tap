# Ingress support

Supply Chain Security Tools (SCST) - Store has ingress support by using Contour's HTTPProxy resources.
To enable ingress support, a Contour installation must be available in the cluster.

To change ingress configuration, edit your `tap-values.yaml` when you install a Tanzu Application Platform profile. Configure the `shared.ingress_domain` property and SCST - Store automatically uses that setting.

- edit your `tap-values.yaml` when you install a Tanzu Application 
Platform profile. Configure the `shared.ingress_domain` property and SCST - Store automatically uses
those settings.
- Customize SCST - Store's configuration under the `metadata_store` property. 
Under `metadata_store`, there are two values to configure the proxy: `ingress_enabled` and `ingress_domain`.

To override the default self-signed certificate, provide a custom certificate under the `tls` property.
To use a custom certificate, complete the `secretName` and `namespace` text boxes.

By default, a self-signed certificate is used.

This is an example of a `tap-values.yaml`:

```yaml
...
metadata_store:
  ingress_enabled: "true"
  ingress_domain: "example.com"
  app_service_type: "ClusterIP"  # Defaults to `LoadBalancer`. If ingress is enabled then this must be set to `ClusterIP`.
...
```

SCST - Store installation creates an HTTPProxy entry with host routing by using the qualified name `metadata-store.<ingress_domain>`, for example, `metadata-store.example.com`. The created route supports HTTPS communication using a certificate. By default, a self-signed certificate is used with the same subject `Alternative Name`. See [Custom certificate configuration](custom-cert.hbs.md) for information about how to configure custom certificates.

- if the `tls` section is configured, use the custom certificate.
- if the `tls` section is not provided, use the self-signed certificate with the same subject `Alternative Name`.

Access to SCST - Store depends 
on configuring Contour and DNS. Contour and DNS setup are not part of the SCST - Store installation.

To resolve `metadata-store.<ingress_domain>` with Envoy service's external IP address, make the DNS 
record available to clients.

This DNS example uses the not secure `-k` flag to skip TLS verification:

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

## <a id="tls"></a>Get the TLS CA certificate

To get SCST - Store's TLS CA certificate, use `kubectl get secret`. In this example, you save the certificate to the environment variable to a file.

```bash
kubectl get secret CERT-NAME -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > OUTPUT_FILE
```

Where

* `CERT-NAME` is the name of the certificate, this must be `ingress-cert` if no custom certificate is used.
* `OUTPUT_FILE` is the file you want to create to store the certificate

For example,

```bash
$ kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt
$ cat insight-ca.crt
```

## Additional Resources

* [Configure target endpoint and certificate](using-encryption-and-connection.hbs.md)