# TLS scenario guides for AppSSO

This topic tells you how to obtain a TLS certificate in different scenarios 
for Application Single Sign-On (commonly called AppSSO). 

## Overview

`AuthServer` is a piece of security infrastructure. It is imperative to configure TLS for it, 
so that its issuer URI's scheme is `https://`.

`AuthServer.spec.tls` accommodates different scenarios for obtaining a TLS certificate. 
Select the scenario that matches your case.

The recommended path is to install AppSSO with a [default issuer](#default-issuer). In that case,
you can omit `AuthServer.spec.tls` and a TLS certificate is obtained automatically.

## <a id='prereqs'></a>Prerequisites

Each of the scenarios requires that the AppSSO package is installed and configured. 
In particular, its `domain_name` must match the ingress domain of your cluster. 
The presented YAML resources assume `my-tap.example.com` as the ingress domain. 
Therefore, the AppSSO configuration values look as follows:

```yaml
#! AppSSO values
domain_name: "my-tap.example.com"
```

The default `domain_template: "\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"` 
works for most scenarios. 
If a scenario requires a bespoke `domain_template`, it contains the relevant instructions.

After applying each scenario, wait for your `AuthServer` to become ready and then test it by running:

```shell
kubectl wait --namespace login authserver/sso --for condition=Ready=True --timeout 500s
curl --location "$(kubectl get --namespace login authserver sso --output=jsonpath='{.status.issuerURI}')/.well-known/openid-configuration"
```

Alternatively, visit the `AuthServer` with your browser. 
You can obtain its issuer URI by running:

```shell
kubectl get --namespace login authserver sso --output=jsonpath='{.status.issuerURI}'
```

> **Caution** Before applying each scenario, you must configure your AppSSO correctly, and
> make sure that all certificates and DNS names comply with your setup.

## <a id='default-issuer'></a> Using a default issuer

VMware recommend using [a default issuer](../../reference//package-configuration.hbs.md#default_authserver_clusterissuer),  
because this approach separates the responsibilities of platform operators and service operators. 
In this case, the `Authserver.spec.tls` field is not required.

To verify whether `AppSSO` was installed with a default issuer, run:

```console
kctrl package installed get --namespace tap-install --package-install tap --values-file-output tap-values.yaml
```

If a `shared.ingress_issuer` appears in your `tap-values.yaml` file, you have a default issuer.

> **Important** Ensure [kctrl](https://carvel.dev/blog/kctrl-release-blog/) is installed.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
    sso.apps.tanzu.vmware.com/documentation: Uses the default issuer for TLS
spec:
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

## <a id='cluster-issuer'></a> Using a `ClusterIssuer`

A `ClusterIssuer` is a cluster-scoped API provided by [cert-manager](https://cert-manager.io) 
from which certificates can be obtained programmatically.

This scenario puts all resources into a single YAML file and uses [Let's Encrypt](https://letsencrypt.org/)'s production API. 
You might get the `ClusterIssuer` from your platform operators.

For more information, see [cert-manager documentation](https://cert-manager.io/docs/configuration/acme/).

> **Caution** [Let's Encrypt](https://letsencrypt.org/)'s production API
[rate limits](https://letsencrypt.org/docs/rate-limits/) apply.

```yaml
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
spec:
  acme:
    privateKeySecretRef:
      name: letsencrypt-production
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - http01:
          ingress:
            class: contour

---
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  #! --- TLS ---
  tls:
    issuerRef:
      name: letsencrypt-production
      kind: ClusterIssuer
  #! -----------
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

## <a id='issuer'></a> Using an `Issuer`

This scenario is identical to [Using a ClusterIssuer](#cluster-issuer), except that 
the Issuer is scoped to a namespace and must be located in the same namespace as the `AuthServer`.

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-production
  namespace: login
spec:
  acme:
    privateKeySecretRef:
      name: letsencrypt-production
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
      - http01:
          ingress:
            class: contour

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  #! --- TLS ---
  tls:
    issuerRef:
      name: letsencrypt-production
  #! -----------
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

## <a id='existing-certificate'></a> Using an existing `Certificate`

A `Certificate` is an API provided by [cert-manager](https://cert-manager.io) 
that is scoped to a namespace and represents a TLS certificate obtained from a `(Cluster)Issuer`. 
To create a `Certificate`, you must know the name and kind of your issuer.

These scenarios use [Let's Encrypt](https://letsencrypt.org/)'s production API and 
require that a `ClusterIssuer` by the name `letsencrypt-production` exists.
See [Using a `ClusterIssuer`](#cluster-issuer) for how to set up the issuer.

When using `Certificate`, its `.spec.dnsNames` must contain the FQDN of the templated issuer URI. 
The `domain_name` and `domain_template` of your AppSSO package installation must comply with your DNS name.

If you have an existing `Certificate` in the same `Namespace` where the `AuthServer` is installed, 
use the following AppSSO configuration values:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: sso
  namespace: login
spec:
  dnsNames:
    - "sso.login.my-tap.example.com"
  issuerRef:
    name: letsencrypt-production
    kind: ClusterIssuer
  secretName: sso-cert

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  #! --- TLS ---
  tls:
    certificateRef:
      name: sso
  #! -----------
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

[secretgen-controller](https://github.com/vmware-tanzu/carvel-secretgen-controller) 
allows you to export and import `Secrets` across namespaces. 
When your `Certificate` is located in another namespace, for example, it's
controlled by another team, you can import its `Secret` to other namespaces. 
If you have an existing `Certificate` in another `Namespace`, 
use the following AppSSO configuration values:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: tls

---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: sso
  namespace: tls
spec:
  dnsNames:
    - "sso.login.my-tap.example.com"
  issuerRef:
    name: letsencrypt-production
    kind: ClusterIssuer
  secretName: sso-cert

---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: sso-cert
  namespace: tls
spec:
  toNamespace: login

---
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretImport
metadata:
  name: sso-cert
  namespace: login
spec:
  fromNamespace: tls

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  #! --- TLS ---
  tls:
    secretRef:
      name: sso-cert
  #! -----------
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

> **Caution** Be cautious when using `SecretExport` and `SecretImport` to facilitate the transfer across namespaces.

## <a id='existing-tls-certificate'></a> Using an existing TLS certificate

If you have an existing TLS certificate and private key, for example, 
if your TLS certificate was created outside the cluster, you can apply it directly.

If you don't have a TLS certificate, there are numerous ways to obtain TLS certificates.
One of the simplest methods is to use a tool such as [mkcert](https://github.com/FiloSottile/mkcert), 
[step](https://smallstep.com/docs/step-cli) or [openssl](https://www.openssl.org/) in GitHub.

If you have an existing TLS certificate in the same `Namespace` where the AuthServer is installed, 
use the following AppSSO configuration values:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: my-cert
  namespace: login
stringData:
  #! --- ReplaceMe - certificate and private key for "sso.login.my-tap.example.com ---
  tls.crt: |
    -----BEGIN CERTIFICATE-----
    # redacted
    -----END CERTIFICATE-----
  tls.key: |
    -----BEGIN PRIVATE KEY-----
    # redacted
    -----END PRIVATE KEY-----
  #! ------------------------------------------------------------------------

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  #! --- TLS ---
  tls:
    secretRef:
      name: my-cert
  #! -----------
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)

```

> **Important** The TLS certificate `tls.crt` and its corresponding private key 
> `tls.key` must be stored in a secret with these keys.

If you have an existing TLS certificate in another `Namespace`, use the following 
AppSSO configuration values:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: tls

---
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: my-cert
  namespace: tls
stringData:
  #! --- ReplaceMe - certificate and private key for "sso.login.my-tap.example.com ---
  tls.crt: |
    -----BEGIN CERTIFICATE-----
    # redacted
    -----END CERTIFICATE-----
  tls.key: |
    -----BEGIN PRIVATE KEY-----
    # redacted
    -----END PRIVATE KEY-----
  #! ------------------------------------------------------------------------

---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: my-cert
  namespace: tls
spec:
  toNamespace: login

---
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretImport
metadata:
  name: my-cert
  namespace: login
spec:
  fromNamespace: tls

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  #! --- TLS ---
  tls:
    secretRef:
      name: my-cert
  #! -----------
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

> **Important** The TLS certificate `tls.crt` and its corresponding private key 
`tls.key` must be stored in a secret with these keys.

> Be cautious when using `SecretExport` and `SecretImport` to facilitate the transfer across namespaces.

## <a id='existing-wildcard-tls-certificate'></a> Using an existing wildcard TLS certificate

To use wildcard certificates for DNS names such as `*.my-tap.example.com`, 
you must edit the AppSSO's `domain_template` so that the templated issuer URIs for 
`AuthServer` match the wildcard. For example:

- `sso.login.my-tap.example.com` does not match the wildcard.
- `sso-login.my-tap.example.com` matches the wildcard.

The following AppSSO configuration values accommodates a wildcard certificate for `*.my-tap.example.com`:

```yaml
#! AppSSO values
domain_name: "my-tap.example.com"
domain_template: "\{{.Name}}-\{{.Namespace}}.\{{.Domain}}"
#!                         ^ note the dash
```

The following scenarios require TLS Secrets, but the same concept applies to `Certificate`.

> **Important** When using a `(Cluster)Issuer` for [Let's Encrypt](https://letsencrypt.org/), 
> you cannot request wildcard certificates when it uses the [http01 challenge solver](https://cert-manager.io/docs/reference/api-docs/#acme.cert-manager.io/v1.ACMEChallengeSolver).

If you have an existing wildcard TLS certificate in the same `Namespace` where the AuthServer is installed, 
use the following AppSSO configuration values:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: my-wildcard-cert
  namespace: login
stringData:
  #! --- ReplaceMe - certificate and private key for "*.my-tap.example.com ---
  tls.crt: |
    -----BEGIN CERTIFICATE-----
    # redacted
    -----END CERTIFICATE-----
  tls.key: |
    -----BEGIN PRIVATE KEY-----
    # redacted
    -----END PRIVATE KEY-----
  #! ------------------------------------------------------------------------

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  #! --- TLS ---
  tls:
    secretRef:
      name: my-wildcard-cert
  #! -----------
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)

```

> **Note** This scenario is similar to using an existing TLS certificate in the same namespace,
> except that the certificate is a wildcard.

If you have an existing wildcard TLS certificate in another `Namespace`, use the following AppSSO configuration values:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: tls

---
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: my-wildcard-cert
  namespace: login
stringData:
  #! --- Certificate and private key for "*.my-tap.example.com ---
  tls.crt: |
    -----BEGIN CERTIFICATE-----
    # redacted
    -----END CERTIFICATE-----
  tls.key: |
    -----BEGIN PRIVATE KEY-----
    # redacted
    -----END PRIVATE KEY-----
  #! -------------------------------------------------------------

---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: my-cert
  namespace: tls
spec:
  toNamespace: login

---
apiVersion: v1
kind: Namespace
metadata:
  name: login

---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretImport
metadata:
  name: my-cert
  namespace: login
spec:
  fromNamespace: tls

---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: sso
  namespace: login
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  #! --- TLS ---
  tls:
    secretRef:
      name: my-wildcard-cert
  #! -----------
  identityProviders:
    - name: test-users
      internalUnsafe:
        users:
          - username: user
            password: password
  tokenSignature:
    signAndVerifyKeyRef:
      name: signing-key

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: signing-key
  namespace: login
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)

```

> **Note** This scenario is similar to using an existing TLS certificate in another namespace,
> except that the certificate is a wildcard.
