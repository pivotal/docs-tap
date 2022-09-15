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

## Common issues

### Misconfigured redirect uri
#### Problem:
When signing in, you see `Error: [invalid_request] OAuth 2.0 Parameter: redirect_uri`

#### Solution:
The `redirectUri` of this `ClientRegistration` should refer to the URI of the Workload being registered.
It does not refer to the URI of the AuthServer.

### Misconfigured Identity provider clientSecret
#### Problem:
- When attempting to sign in you see `client.samples.localhost.identity.team redirected you too many times.`, it is
possible that the client secret of an identity provider is misconfigured.
- If you have access to the authserver logs, check to see if there is an entry with the text
`"error":"[invalid_client] Client authentication failed: client_secret"`

#### Solution:
- Validate the secret referenced by the `clientSecretRef` for this particular identity provider in your `authserver.spec`

### Missing scopes
#### Problem:
When attempting to fetch data after signing in to your application via AppSSO, you see `[invalid_scope] OAuth 2.0 Parameter: scope`

#### Solution:
Add the required scopes into your `ClientRegistration` yaml under `spec.scopes`.

*Note* Changes to the secret do not propagate to the `ClientRegistration`. If you recreated the `Secret` that contains the
`clientSecret`, re-deploy the `ClientRegistration`.
