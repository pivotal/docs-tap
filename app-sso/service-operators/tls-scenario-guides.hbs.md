# TLS scenario guides

`AuthServer` is a piece of security infrastructure. It is imperative to configure TLS for it, so that its _issuer
URI_'s scheme is `https://`.

`AuthServer.spec.tls` accommodates different scenarios for how to obtain a TLS certificate. Pick the scenario that
matches your case.

> **Note** The recommended path is to install AppSSO with a [default issuer](#default-issuer). In that case,
you can omit `AuthServer.spec.tls` entirely and a TLS certificate is obtained automatically.

<!-- TOC -->

* [Prerequisites](#prereqs)
* [I have a default issuer _(recommended)_](#default-issuer)
* [I have a `ClusterIssuer`](#cluster-issuer)
* [I have an `Issuer`](#issuer)
* [I have an existing `Certificate`](#existing-certificate)
    * [… in the same `Namespace`](#existing-certificate-same-ns)
    * [… in another `Namespace`](#existing-certificate-diff-ns)
* [I have an existing TLS certificate](#existing-tls-certificate)
    * [… in the same `Namespace`](#existing-tls-certificate-same-ns)
    * [… in another `Namespace`](#existing-tls-certificate-diff-ns)
* [I have an existing wild-card TLS certificate / `Certificate`](#existing-wildcard-tls-certificate)
    * [… in the same `Namespace`](#existing-wildcard-tls-certificate-same-ns)
    * [… in another `Namespace`](#existing-wildcard-tls-certificate-diff-ns)

<!-- TOC -->

## <a id='prereqs'></a>Prerequisites

Each of the scenarios assumes that the _AppSSO_ package is installed and configured. In particular, its `domain_name`
must match the ingress domain of your cluster. The presented YAML resources assume `my-tap.example.com` as the ingress
domain. Therefore, the _AppSSO_ configuration values look as follows:

```yaml
#! AppSSO values
domain_name: "my-tap.example.com"
```

The default `domain_template: "\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"` works for almost all scenarios. If a scenario
requires a bespoke `domain_template` it contains the relevant instructions.

After applying each scenario, wait for your `AuthServer` to become ready and then test it like so:

```shell
kubectl wait --namespace login authserver/sso --for condition=Ready=True --timeout 500s
curl --location "$(kubectl get --namespace login authserver sso --output=jsonpath='{.status.issuerURI}')/.well-known/openid-configuration"
```

Alternatively, visit the `AuthServer` with your browser. You can obtain its issuer URI with:

```shell
kubectl get --namespace login authserver sso --output=jsonpath='{.status.issuerURI}'
```

> **Caution** Before applying each scenario make sure that your _AppSSO_ package installation is configured correctly, and
that all certificates and DNS names comply with your setup.

## <a id='default-issuer'></a> I have a default issuer _(recommended)_

> Using [a default issuer](../platform-operators/configuration.md#default_authserver_clusterissuer) is the recommended
approach. It appeals best to the split the responsibilities of _platform operators_ and _service operators_.
> In this case, the `Authserver.spec.tls` field can be omitted entirely.

If you need to verify whether `AppSSO` was installed with a default issuer, you can run
`kctrl package installed get --namespace tap-install --package-install tap --values-file-output tap-values.yaml`.
Then check your `tap-values.yaml` file. If there is a `shared.ingress_issuer`, you have a default issuer.
> Prerequisite: Ensure [kctrl](https://carvel.dev/blog/kctrl-release-blog/) is installed.

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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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

## <a id='cluster-issuer'></a> I have a `ClusterIssuer`

A `ClusterIssuer` is a cluster-scoped API provided by [cert-manager](https://cert-manager.io) from which certificates
can be obtained programmatically.

For purposes of completeness and simplicity, this scenario puts all resources into a single YAML file and
uses [Let's Encrypt](https://letsencrypt.org/)'s production API. It is likely, however, that the `ClusterIssuer` is
provided to you by your _platform operators_.

> **Note** Learn more about [Let's Encrypt with Cert Manager](https://cert-manager.io/docs/configuration/acme/)

> **Caution** Caveat: [Let's Encrypt](https://letsencrypt.org/)'s production API
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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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

## <a id='issuer'></a> I have an `Issuer`

This scenario is almost exactly the same as with a `ClusterIssuer`, but `Issuer` is Namespace-scoped and needs to be
collocated with the `AuthServer`.

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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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

## <a id='existing-certificate'></a> I have an existing `Certificate`

A `Certificate` is a Namespace-scoped API provided by [cert-manager](https://cert-manager.io) which represents a TLS
certificate obtained from a `(Cluster)Issuer`. To create `Certificate`, you need to know the name and kind of your
issuer.

These scenarios use [Let's Encrypt](https://letsencrypt.org/)'s production API and assume that a
`ClusterIssuer` by the name `letsencrypt-production` exists.
See [the `ClusterIssuer` scenario](#cluster-issuer) for how to set the issuer up.

When using `Certificate`, its `.spec.dnsNames` must contain the FQDN of the templated issuer URI. Make sure that your
AppSSO package installation's `domain_name` and `domain_template` are compatible with your DNS name.

### <a id='existing-certificate-same-ns'></a> … in the same `Namespace` as I want to install the AuthServer

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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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

### <a id='existing-certificate-diff-ns'></a> … in another `Namespace`

Thanks to [secretgen-controller](https://github.com/vmware-tanzu/carvel-secretgen-controller) we can export and
import `Secrets` across namespaces. When our `Certificate` is located in another namespace - because maybe it's
controlled by another team - then its `Secret` can be offered to other namespaces for import.

Pay attention to the use of `SecretExport` and `SecretImport` to facilitate the transfer across namespaces.

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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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

## <a id='existing-tls-certificate'></a> I have an existing TLS certificate

If you have an existing TLS certificate and private key, you can apply it directly.
For example, if your TLS certificate was created outside the cluster.

> **Note** If you don't have a TLS certificate, but you would like to try this, there is an almost endless array of
possibilities for obtaining TLS certificates. The easiest way is to use a tool
like [mkcert](https://github.com/FiloSottile/mkcert), [step](https://smallstep.com/docs/step-cli)
or [openssl](https://www.openssl.org/).

### <a id='existing-tls-certificate-same-ns'></a> … in the same `Namespace` as I want to install the AuthServer

> **Note** The TLS certificate `tls.crt` and its corresponding private key `tls.key` _must_ be stored in a secret with
these keys.

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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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

### <a id='existing-tls-certificate-diff-ns'></a> … in another `Namespace`

> **Note** The TLS certificate `tls.crt` and its corresponding private key `tls.key` _must_ be stored in a secret with
these keys.

Pay attention to the use of `SecretExport` and `SecretImport` to facilitate the transfer across namespaces.

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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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

## <a id='existing-wildcard-tls-certificate'></a> I have an existing wild-card TLS certificate / `Certificate`

To use wild-card certificates for DNS names like `*.my-tap.example.com`, _AppSSO_'s `domain_template` needs to be
adjusted so that templated issuer URIs for `AuthServer` match the wild-card. For example:

* `sso.login.my-tap.example.com` does not match the wild-card
* `sso-login.my-tap.example.com` does matches the wild-card

The following _AppSSO_ configuration values would accommodate a wild-card certificate for `*.my-tap.example.com`:

```yaml
#! AppSSO values
domain_name: "my-tap.example.com"
domain_template: "\{{.Name}}-\{{.Namespace}}.\{{.Domain}}"
#!                         ^ note the dash
```

The following scenarios assume use of TLS Secrets, but the same concept carries over to `Certificate`.

> **Important** Caveat: When using a `(Cluster)Issuer` for [Let's Encrypt](https://letsencrypt.org/), you cannot request wild-card
certificates when it uses
the [`http01` challenge solver](https://cert-manager.io/docs/reference/api-docs/#acme.cert-manager.io/v1.ACMEChallengeSolver)

### <a id='existing-wildcard-tls-certificate-same-ns'></a> … in the same `Namespace` as I want to install the AuthServer

This scenario is exactly the same as
when [you have an existing TLS certificate in the same namespace](#existing-tls-certificate),
but the certificate is a wild-card.

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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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

### <a id='existing-wildcard-tls-certificate-diff-ns'></a> … in another `Namespace`

This scenario is exactly the same as
when [you have an existing TLS certificate in the another namespace](#existing-tls-certificate),
but the certificate is a wild-card.

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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
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
