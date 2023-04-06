# <a id="ingress-issuer"></a> Shared ingress issuer

Tanzu Application Platform's shared ingress issuer is an on-platform
representation of a _certificate authority_. It is an easy way to set up TLS
for the entire platform. All participating components will get their ingress
certificates issued by it.

This is the recommended best practice for issuing ingress certificates on Tanzu
Application Platform. Learn about its [prerequisites](#prerequisites).

The ingress issuer is designated by the single TAP configuration value
`shared.ingress_issuer`. It refers to a `cert-manager.io/v1/ClusterIssuer`.

By default, a self-signed issuer is used. It's called `tap-ingress-selfsigned`
and has [limitations](#limitations-self-signed).

It is recommended to [replace](#replace) the default with your own issuer.

[Component-level configuration of TLS](#override) takes precedence and can be
mixed with the ingress issuer.

It is possible to [deactivate](#deactivate) the ingress issuer.

## <a id="prerequisites"></a>Prerequisites

To be able to use TAP's ingress issuer your _certificate authority_ needs to be
representable by a cert-manager `ClusterIssuer`. In particular you need one of
the following:

* You have your own CA certificate **or**
* Your CA is an ACME, Venafi, or Vault-based issuer like _LetsEncrypt_ **or**
* Your CA can be represented by an
  [external](https://cert-manager.io/docs/configuration/external/) cert-manager
  `ClusterIssuer`.

If none of the above are given, then you cannot use the issuer ingress, but you can
still [configure TLS for components](./inventory.hbs.md).

## <a id="prerequisites"></a>Default

By default, Tanzu Application Platform installs and uses a self-signed CA as
its ingress issuer for all components.

This default ingress issuer is a self-signed `cert-manager.io/v1/ClusterIssuer`
and is provided by Tanzu Application Platform's [cert-manager
package](../../../cert-manager/about.hbs.md). Its default name is
`tap-ingress-selfsigned`.

The default ingress issuer is appropriate for testing and evaluation, but it is
strongly recommended to replace it with your own issuer.

>**Important** If `cert-manager.tanzu.vmware.com` is excluded from the
>installation, then `tap-ingress-selfsigned` will not be installed either. In
>this case make sure to bring your own ingress issuer.

### <a id="limitations-self-signed"></a>Limitations of the default, self-signed issuer

The default ingress issuer represents a self-signed _certificate authority_.
This is unproblematic as fas as security is concerned. However, such an issuer
is not included in any trust chain configured.

That means that nothing trusts the default ingress issuer implicitly, not even
TAP's components. While the issued certificates are valid in principal, they
will be rejected by, say, your browser. Furthermore, some interactions between
TAP components are not functional out-of-the-box.

### <a id="trust-self-signed"></a>Trusting the default, self-signed issuer

You can trust the default ingress issuer by including
`tap-ingress-selfsigned`'s certificate in TAP's trusted CA certificates as well
as your device's certificate chain.

> **Caution** This approach is discouraged! Instead, replace the default ingress issuer.

1. Obtain `tap-ingress-selfsigned`'s PEM-encoded certificate

  ```shell
  kubectl get secret \
    tap-ingress-selfsigned-root-ca \
    --namespace cert-manager \
    --output go-template='\{{ index .data "tls.crt" | base64decode }}'
  ```

1. Add the certificate to [custom CA
   certificates](../custom-ca-certificates.hbs.md) by appending it to
   `shared.ca_cert_data` and applying TAP's installation values

1. Add the certificate to your device's trust chain _(this depends on your
   operating system and privileges)_

## <a id="replace"></a>Replacing the default ingress issuer

Tanzu Application Platform's default ingress issuer can be replaced by any
other [cert-manager-compliant
`ClusterIssuer`](https://cert-manager.io/docs/configuration/).

To replace the default ingress issuer:

1. Create your `ClusterIssuer`

  <!-- These are tabs. See:
  https://confluence.eng.vmware.com/pages/viewpage.action?spaceKey=CSOT&title=Using+DocWorks+Markdown#UsingDocWorksMarkdown-UsingTabs
  -->

  : Custom CA

    > **Important** You need your own CA's certificate and private key for
    > this.

    Create a `Secret+ClusterIssuer` which represent your CA on the platform:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    type: kubernetes.io/tls
    metadata:
      name: my-company-ca
      namespace: cert-manager
    stringData:
      tls.crt: #! your CA's PEM-encoded certificate
      tls.key: #! your CA's PEM-encoded private key

    ---
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: my-company
    spec:
      ca:
        secretName: my-company-ca
    ```

  : LetsEncrypt production

    Create a `ClusterIssuer` for [Let's Encrypts](https://letsencrypt.org)
    production API:

    ```yaml
    ---
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-production
    spec:
      acme:
        email: certificate-notices@my-company.com
        privateKeySecretRef:
          name: letsencrypt-production
        server: https://acme-v02.api.letsencrypt.org/directory
        solvers:
          - http01:
              ingress:
                class: contour
    ```

    > **Important**
    > * Public CAs - like LetsEncrypt - record signed certificates in
    >   publicly-available certificate logs for the purpose of [certificate
    >   transparency](https://certificate.transparency.dev/). Make sure you are
    >   okay with this before using LetsEncrypt!
    > * LetsEncrypt's production API has [rate
    >   limits](https://letsencrypt.org/docs/rate-limits/).
    > * LetsEncrypt requires your `shared.ingress_domain` to be accessible from
    >   the internet.
    > * Depending on your setup you will need to adjust
    >   [.spec.acme.solvers](https://cert-manager.io/docs/configuration/acme/#solving-challenges)
    > * Replace `.spec.acme.email` with the email which should receive notices
    >   for certificates from LetsEncrypt.

  : LetsEncrypt staging

    Create a `ClusterIssuer` for [Let's Encrypts](https://letsencrypt.org)
    staging API:

    ```yaml
    ---
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-staging
    spec:
      acme:
        email: certificate-notices@my-company.com
        privateKeySecretRef:
          name: letsencrypt-production
        server: https://acme-staging-v02.api.letsencrypt.org/directory
        solvers:
          - http01:
              ingress:
                class: contour
    ```

    > **Important**
    > * Public CAs - like LetsEncrypt - record signed certificates in
    >   publicly-available certificate logs for the purpose of [certificate
    >   transparency](https://certificate.transparency.dev/). Make sure you are
    >   okay with this before using LetsEncrypt!
    > * LetsEncrypt's staging API is not a publicly-trusted CA. You will have
    >   to add its certificate to your devices trust chain and [TAP's custom CA
    >   certificates](../custom-ca-certificates.hbs.md).
    > * LetsEncrypt requires your `shared.ingress_domain` to be accessible from
    >   the internet.
    > * Depending on your setup you will need to adjust
    >   [.spec.acme.solvers](https://cert-manager.io/docs/configuration/acme/#solving-challenges).
    > * Replace `.spec.acme.email` with the email which should receive notices
    >   for certificates from LetsEncrypt.

  : Other

    You can use any other cert-manager-supported `ClusterIssuer` as an ingress
    issuer for TAP.

    Cert-manager supports a host of in-tree and out-of-tree issuers.

    Refer to cert-manager's [documentaion of
    issuers](https://cert-manager.io/docs/configuration/).

1. Set `shared.ingress_issuer` to the name of your issuer

  : Custom CA

    ```yaml
    #! my-tap-values.yaml
    #! ...
    shared:
      ingress_issuer: my-company-ca
    #! ...
    ```

  : LetsEncrypt production

    ```yaml
    #! my-tap-values.yaml
    #! ...
    shared:
      ingress_issuer: letsencrypt-production
    #! ...
    ```

  : LetsEncrypt staging

    ```yaml
    #! my-tap-values.yaml
    #! ...
    shared:
      ingress_issuer: letsencrypt-staging
    #! ...
    ```

  : Other

    ```yaml
    #! my-tap-values.yaml
    #! ...
    shared:
      ingress_issuer: my-company-ca
    #! ...
    ```

1. Apply TAP's installation values

Once the configuration is applied, components eventually obtain certificates
from the new issuer and will serve them.

>**Note** There are many ways and tools to assert that new certificates are
>issued and served. It is best to connect to one of the ingress endpoints and
>inspect the certificate it serves.
>
>The `openssl` command-line utility is readily available on virtually every
>operating system. The following command retrieves the certificate from an
>ingress endpoint and shows its text representation:
>
>```shell
># replace tap.example.com with your TAP installation's ingress domain
>openssl s_client -showcerts -servername tap-gui.tap.example.com -connect tap-gui.tap.example.com:443 <<< Q | openssl x509 -text -noout
>```
>
>Alternatively, use a browser, navigate to the ingress endpoint and click the
>lock icon in the navigation bar to inspect the certificate.

## <a id="deactivate"></a>Deactivating TLS for ingress

Even though it is discouraged, you can deactivate the ingress issuer by setting
`shared.ingress_issuer: ""`. As a result, components consider TLS for ingress
to be deactivated.

## <a id="override"></a>Overriding TLS for components

You can override TLS settings for each component. In your TAP values file a
component's configuration takes precedence over `shared` values. See
[components](../../../components.hbs.md) to understand which components have ingress
and how to configure them.

>**Note** The approaches can be mixed; use a shared ingress issuer, but
>override TLS configuration for select components.

