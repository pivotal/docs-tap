# Issuer URI and TLS for AppSSO

This topic tells you how to configure the issuer URI and TLS for 
Application Single Sign-On (commonly called AppSSO). 

You can configure how and if to obtain a TLS certificate for the issuer URI via `.spec.tls`. Unless TLS is disabled
HTTPS is enforced, i.e. requests for `http://` will be redirected to `https://`.

For example:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: login
  namespace: services
  # ...
spec:
  tls:
    issuerRef:
      name: my-issuer
  # ...
status:
  issuerURI: https://login.services.example.com
  # ...
```

This `AuthServer` will be reachable at its templated issuer URI `https://login.services.example.com` and serve a TLS
certificate obtained from _my-issuer_.

Learn how to configure TLS for your `AuthServer`:

- [Configure TLS by using a (Cluster)Issuer](#configure-tls-by-using-a-clusterissuer)
- [Configure TLS by using a Certificate](#configure-tls-by-using-a-certificate)
- [Configure TLS by using a Secret](#configure-tls-by-using-a-secret)
- [Disable TLS](#disable-tls-unsafe)

> ℹ️ If your `AuthServer` obtains a certificate from a custom CA, then [help _App
> Operators_ to trust it](#allow-workloads-to-trust-a-custom-ca-authserver).
>
> ⚠️ The existing `.spec.issuerURI` is deprecated and is marked for deletion in the next release! The release notes
> contain a [migration guide](../../release-notes.md#app-sso-features)

## Configure TLS by using a (Cluster)Issuer

You can obtain a TLS certificate for your `AuthServer` by referencing a `cert-manager.io/v1/Issuer`
or `cert-manager.io/v1/ClusterIssuer`. The AppSSO will then an `cert-manager.io/v1/Certificate` from that issuer and
configure `Ingress` with it.

The composition of an `AuthServer` and a _self-signed_ `Issuer` looks as follows:

```yaml
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: my-selfsigned-issuer
  namespace: services
spec:
  selfSigned: { }

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: login
  namespace: services
  # ...
spec:
  tls:
    issuerRef:
      name: my-selfsigned-issuer
      # 'kind: Issuer' can be omitted. It is the default. 
```

The composition of an `AuthServer` and a _self-signed_ `ClusterIssuer` for looks as follows:

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: my-selfsigned-cluster-issuer
spec:
  selfSigned: { }

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: login
  namespace: services
  # ...
spec:
  tls:
    issuerRef:
      name: my-selfsigned-cluster-issuer
      kind: ClusterIssuer
```

Confirm that your `AuthServer` serves a TLS certificate from the specified issuer by visiting its `{.status.issuerURI}`.

> 👉 Learn more about [cert-manager and its APIs](https://cert-manager.io/).

## Configure TLS by using a Certificate

In order to configure TLS for your `AuthServer` using a `cert-manager.io/v1/Certificate` you must know what its
templated issuer URI will be. You can infer it from the AppSSO package's domain template.

The composition of an `AuthServer` and a `Certificate` looks as follows:

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: login
  namespace: services
spec:
  dnsNames:
    - login.services.example.com
  issuerRef:
    name: my-cluster-issuer
    kind: ClusterIssuer
  secretName: login-cert

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: login
  namespace: services
  # ...
spec:
  tls:
    certificateRef:
      name: login
```

Confirm that your `AuthServer` serves the specified Certificate by visiting its `{.status.issuerURI}`.

> 👉 Learn more about [cert-manager and its APIs](https://cert-manager.io/).

## Configure TLS by using a Secret

If you don't want to use cert-manager.io's APIs or you have a raw TLS certificate in a TLS `Secret`, you can compose
it with your `AuthServer` by referencing it. The certificate must be for the issuer URI that will be templated for
the `AuthServer`. You can infer it from the AppSSO package's domain template.

The composition of an `AuthServer` and TLS `Secret` looks as follows:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-tls-cert
  namespace: services
type: kubernetes.io/tls
data:
  tls.key: # ...
  tls.crt: # ...

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: login
  namespace: services
  # ...
spec:
  tls:
    secretRef:
      name: my-tls-cert
```

## Disable TLS (unsafe)

You can disable TLS autoconfiguration. Keep in mind that your `AuthServer` will then only work over plain HTTP. TLS
can only be disabled in the presence of the `sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: ""` annotation.

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: login
  namespace: services
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: ""
  # ...
spec:
  tls:
    disabled: true
```

> ⚠️ Disabling TLS is unsafe and strongly discouraged for production!

## Allow `Workloads` to trust a custom CA `AuthServer`

If your `AuthServer` obtains a certificate from a custom CA, then its consumers won't trust it by default. You can
help _App Operators_ in letting their `Workloads` trust your `AuthServer` by exporting a `ca-certificates` service
binding `Secret` to their `Namespace`.

A composition of `SecretTemplate` and `SecretExport` are a way to achieve this. If your custom CA's TLS `Secret` is
present in the namespace `my-certs`, then you can provide a `ca-certificates` service binding `Secret` like so:

```yaml
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretTemplate
metadata:
  name: ca-cert
  namespace: my-certs
spec:
  inputResources:
    - name: my-custom-ca
      ref:
        apiVersion: v1
        kind: Secret
        name: my-custom-ca
  template:
    data:
      ca.crt: $(.my-custom-ca.data.tls\.crt)
    stringData:
      type: ca-certificates

---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: ca-cert
  namespace: my-certs
spec:
  toNamespace: "*"
```

This templates a `ca-certificates` service binding `Secret` which `Workload` can claim to trust the custom CA. It does
not contain the CA's private and is generally safe to share.

However, be careful, this example exports to all namespace on the cluster. If this does not comply with your policies,
then adjust the target namespaces if required.

> 👉 Learn more about [secretgen-controller and its APIs](https://github.com/vmware-tanzu/carvel-secretgen-controller).
