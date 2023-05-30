# Troubleshoot Application Single Sign-on

This topic tells you how to troubleshoot Application Single Sign-On (commonly called AppSSO).

## Why is my AuthServer not working?

Generally, `AuthServer.status` is designed to provide you with helpful feedback to debug a faulty `AuthServer`.

## Find all AuthServer-related Kubernetes resources

Identify all `AuthServer` components with Kubernetes common labels. For more information, see [Kubernetes documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels).

Query all related `AuthServer` subresources by using `app.kubernetes.io/part-of` label. For example:

```yaml
kubectl get all,ingress,service -A -l app.kubernetes.io/part-of=<authserver-name>
```

## Logs of all AuthServers

With [stern](https://github.com/stern/stern) you can tail the logs of all AppSSO managed `Pods` inside your cluster
with:

```shell
stern --all-namespaces --selector=app.kubernetes.io/managed-by=sso.apps.tanzu.vmware.com
```

## Change propagation

When applying changes to an `AuthServer`, keep in mind that changes to issuer URI, IDP, server and logging configuration
take a moment to be effective as the operator will roll out the authorization server `Deployment`.

## My Service is not selecting the authorization server's Deployment

If you are deploying your `Service` with [kapp](https://carvel.dev/kapp/docs/latest/) make sure to set the
annotation `kapp.k14s.io/disable-default-label-scoping-rules: ""` to avoid that kapp amends `Service.spec.selector`.

## Redirect URIs are redirecting to http instead of https with a non-internal identity provider

Follow [this workaround](known-issues/index.md#cidr-ranges), adding IP ranges for the `AuthServer` to trust.

## Misconfigured `clientSecret`

### Problem:

When attempting to sign in, you see `This commonly happens due to an incorrect [client_secret].` It might be because the client secret of an identity provider is misconfigured.

### Solution:

Validate the `spec.OpenId.clientSecretRef`.

## <a id="sub-claim"></a>Misconfigured `sub` claim

### Problem:

The `sub` claim in `id_token`s and `access_token`s follow the `<providerId>_<userId>` pattern.
The previous `<providerId>/<userId>` pattern might cause bugs in URLs without proper URL-encoding in client applications.

### Solution:

If your client application has stored `sub` claims,
you must update them to match the new pattern `<providerId>_<userId>`.

## `Workload` does not trust `AuthServer`

If your `ClientRegistration` selects and `AuthServer` which serves a certificate from a custom CA, then your `Workload`
will not trust it by default.

A `ca-certificates` service binding `Secret` allows to configure trust for custom CAs. [Your _Service
Operator_ can export such a resource for you](service-operators/issuer-uri-and-tls.md#allow-workloads-to-trust-a-custom-ca-authserver)
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

## Misconfigured redirect URI

### Problem:
You see `Error: [invalid_request] OAuth 2.0 Parameter: redirect_uri` when signing in.

### Solution:
The `redirectUri` of this `ClientRegistration` must refer to the URI of the registered Workload.
It does not refer to the URI of the AuthServer.

## Misconfigured identity provider clientSecret

### Problem:
- When attempting to sign in, you see `client.samples.localhost.identity.team redirected you too many times.` It might be because the client secret of an identity provider is misconfigured.
- If you have access to the authserver logs, verify if there is an entry with the text
`"error":"[invalid_client] Client authentication failed: client_secret"`.

### Solution:
- Validate the secret referenced by the `clientSecretRef` for this particular identity provider in your `authserver.spec`.

## Missing scopes

### Problem:
When attempting to fetch data after signing in to your application by using AppSSO, you see `[invalid_scope] OAuth 2.0 Parameter: scope`.

### Solution:
Add the required scopes into your `ClientRegistration` yaml under `spec.scopes`.

>**Note** Changes to the secret do not propagate to the `ClientRegistration`. If you recreated the `Secret` that contains the
`clientSecret`, re-deploy the `ClientRegistration`.
