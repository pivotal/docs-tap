# Issuer URI and TLS for AppSSO

This topic tells you how to configure the issuer URI and TLS for 
Application Single Sign-On (commonly called AppSSO). 

## Overview

An `AuthServer` entry point for its clients and their end-users is called _issuer URI_. AppSSO will template the issuer URI and create a TLS-enabled `Ingress` for it. For this purpose, your platform operator configures the domain name and template. Once you created and `AuthServer` you can find the actual URL in `.status.issuerURI`.

You can configure whether and how to obtain a TLS certificate for the issuer URI by using `.spec.tls`. Unless TLS is deactivated, HTTPS is enforced. For example, requests for `http://` are redirected to `https://`. You can observe the TLS configuration in `.status.tls`.

If AppSSO is installed with [a default issuer](../../reference//package-configuration.hbs.md#default_authserver_clusterissuer), 
you can omit `AuthServer.spec.tls` and a TLS certificate is obtained automatically. This is the recommended approach for TLS.

For example:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: login
  namespace: services
  # ...
spec:
# ...
status:
  issuerURI: https://login.services.example.com
  tls:
    issuerRef:
      name: my-default-issuer
      kind: ClusterIssuer
      group: cert-manager.io
  # ...
```

This `AuthServer` is reachable at its templated issuer URI `https://login.services.example.com` 
and serves a TLS certificate obtained from `my-default-issuer`.

Learn how to configure TLS for your `AuthServer`:

- [Issuer URI and TLS for AppSSO](#issuer-uri-and-tls-for-appsso)
  - [Overview](#overview)
  - [Configure TLS by using a (Cluster)Issuer](#configure-tls-by-using-a-clusterissuer)
  - [Configure TLS by using a Certificate](#configure-tls-by-using-a-certificate)
  - [Configure TLS by using a Secret](#configure-tls-by-using-a-secret)
  - [Deactivate TLS (unsafe)](#deactivate-tls-unsafe)
  - [ Allow `Workloads` to trust a custom CA `AuthServer`](#-allow-workloads-to-trust-a-custom-ca-authserver)

There are many use-cases that pertain to TLS use. To find out which scenario applies to you and how to configure it, see
[TLS scenario guides](tls-scenario-guides.hbs.md).

If your `AuthServer` obtains a certificate from a custom CA, you can enable App Operators to trust it. 
See [Allow Workloads to trust a custom CA AuthServer](#trust-custom-ca) for more information.

## Configure TLS by using a (Cluster)Issuer

You can obtain a TLS certificate for your `AuthServer` by referencing a `cert-manager.io/v1/Issuer`
or `cert-manager.io/v1/ClusterIssuer`. This enables AppSSO to retrieve a `cert-manager.io/v1/Certificate` 
from the issuer and apply it to the `Ingress` configuration.

The composition of an `AuthServer` and a self-signed `Issuer` looks as follows:

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

For more information about cert-manager and its APIs. see [cert-manager documentation](https://cert-manager.io/).

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

For more information about cert-manager and its APIs. see [cert-manager documentation](https://cert-manager.io/).

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

## Deactivate TLS (unsafe)

If you deactivate TLS autoconfiguration, `AuthServer` only works over plain HTTP. You must deactivate TLS with
the `sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: ""` annotation.

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
    deactivated: true
```

>**Caution** Deactivating TLS is unsafe and not recommended for production.

## <a id="trust-custom-ca"></a> Allow `Workloads` to trust a custom CA `AuthServer`

If your `AuthServer` obtains a certificate from a custom CA, its consumers do not trust it by default. You can
enable App Operators' `Workloads` to trust your `AuthServer` by exporting a `ca-certificates` service
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
not contain the CA's private key and is generally safe to share.

However, be careful, this example exports to all namespace on the cluster. If this does not comply with your policies,
then adjust the target namespaces if required.

For more information about secretgen-controller and its APIs, see [secretgen-controller documentation](https://github.com/vmware-tanzu/carvel-secretgen-controller) in GitHub.
