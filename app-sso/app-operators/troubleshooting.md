# Troubleshooting

## `Workload` does not trust `AuthServer`

If your `ClientRegistration` selects and `AuthServer` which serves a certificate from a custom CA, then your `Workload`
will not trust it by default.

A `ca-certificates` service binding `Secret` allows to configure trust for custom CAs. [Your _Service
Operator_ can export such a resource for you](../service-operators/issuer-uri-and-tls.md#allow-workloads-to-trust-a-custom-ca-authserver)
.

Once they have exported a `ca-certificates` service binding `Secret`, we can import it and add another service claim to
the `Workload` to configure trust:

```yaml
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretImport
metadata:
  name: custom-ca-cert
  namespace: my-workloads
spec:
  fromNamespace: "<?>" # Your service operator can tell you which namespace to import from

---
apiVersion: carto.run/v1alpha1
kind: Workload
# ...
spec:
  serviceClaims:
    - name: authservers-ca-cert
      ref:
        apiVersion: v1
        kind: Secret
        name: custom-ca-cert
    # ...
```

> 👉 Learn more about [secretgen-controller and its APIs](https://github.com/vmware-tanzu/carvel-secretgen-controller).
