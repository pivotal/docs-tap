# Provision an AuthServer

This topic tells you how to provision an AuthServer for Application Single 
Sign-On (commonly called AppSSO). Use this topic to learn how to:

1. Set up your first authorization server in the `default` namespace.
2. Ensure it is running so that users can log in.

![Diagram of AppSSO's components, with AuthServer and Identity Providers highlighted](../../images/app-sso/authserver-tutorial.png)

## Prerequisites

You must install AppSSO on your Tanzu Application Platform cluster and ensure that 
your Tanzu Application Platform installation is correctly configured.

AppSSO is installed with the `run`, `iterate`, and `full` profiles, no extra steps required.

To verify AppSSO is installed on your cluster, run:

```shell
tanzu package installed list -A | grep "sso.apps.tanzu.vmware.com"
```

For more information about the AppSSO installation, 
see [Install AppSSO](../../tutorials/platform-operators/installation.md).

## Provision an AuthServer

Deploy your first Authorization Server along with an `RSAKey` key for signing tokens.

> **Caution** This `AuthServer` example uses an unsafe testing-only identity provider. Never use it in
production environments. For more information about identity providers, see [Identity providers](../../tutorials/service-operators/identity-providers.md).

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: my-authserver-example
  namespace: default
  labels:
    name: my-first-auth-server
    env: tutorial
  annotations:
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "default"
    sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: ""
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  replicas: 1
  tls:
    deactivated: true
  identityProviders:
    - name: "internal"
      internalUnsafe:
        users:
          - username: "user"
            password: "password"
            email: "user@example.com"
            emailVerified: true
            roles:
              - "user"
  tokenSignature:
    signAndVerifyKeyRef:
      name: "authserver-signing-key"

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: authserver-signing-key
  namespace: default
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

You can wait for the `AuthServer` to become ready with:

```shell
kubectl wait --for=condition=Ready authserver my-authserver-example
```

Alternatively, you can inspect your `AuthServer` like any other resource:

```shell
kubectl get authservers.sso.apps.tanzu.vmware.com --all-namespaces
```

and you should see:

```shell
NAMESPACE NAME                  REPLICAS ISSUER URI                                         CLIENTS STATUS
default   my-authserver-example 1        http://my-authserver-example.default.<your domain> 0       Ready
```

As you can see your `AuthServer` gets an issuer URI templated. This is its entrypoint. You can find an `AuthServer`'s
issuer URI in its status:

```shell
kubectl get authservers.sso.apps.tanzu.vmware.com my-authserver-example -o jsonpath='{.status.issuerURI}'
```

Open your `AuthServer`'s issuer URI in your browser. You should see a login page. Log in using username = `user` and
password = `password`.

You can review the standard OpenID information of your `AuthServer` by visiting 
`http://my-authserver-example.default.<your domain>/.well-known/openid-configuration`.

> **Important** If the issuer URIs domain is not yours, the AppSSO package installation must be updated. 
For more information, see [Install Application Single Sign-On](../../tutorials/platform-operators/installation.md).

## The AuthServer spec in detail

Here is a detailed explanation of the `AuthServer` you have applied in the above section. This is intended to give you
an overview of the different configuration values that were passed in. It is not intended to describe all the
ins-and-outs, but there are links to related docs in each section.

Feel free to skip ahead.

### Metadata

```yaml
metadata:
  labels:
    name: my-first-auth-server
    env: tutorial
  annotations:
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "default"
    sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: ""
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
```

The `metadata.labels` uniquely identify the AuthServer. They are used as selectors by `ClientRegistrations`, to declare
from which authorization server a specific client obtains tokens from.

The `sso.apps.tanzu.vmware.com/allow-client-namespaces` annotation restricts the namespaces in which you can create
`ClientRegistrations` targeting this authorization server. In this case, the authorization server only picks up
client registrations in the `default` namespace.

The `sso.apps.tanzu.vmware.com/allow-unsafe-...` annotations enable "development mode" features, useful for testing.
Those should not be used for production-grade authorization servers.

For more information about annotations and labels in `AuthServer` resource, see [Annotation and labels](../../tutorials/service-operators/metadata.md).

### TLS & issuer URI

```yaml
spec:
  tls:
    deactivated: true
```

The `tls` field configures whether and how to obtain a certificate for an `AuthServer` to secure its issuer URI. 
If you deactivate `tls`, the issuer URI uses plain HTTP.

> **Caution** Plain HTTP access is for development purposes only and must never be used in production. 
For more information about the production readiness with TLS, see [Issuer URI & TLS](../../tutorials/service-operators/issuer-uri-and-tls.md).

### Token Signature

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
# ...
spec:
  tokenSignature:
    signAndVerifyKeyRef:
      name: "authserver-signing-key"
---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: authserver-signing-key
  namespace: default
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)
```

The token signing key is the private RSA key used to sign ID Tokens,
using [JSON Web Signatures](https://datatracker.ietf.org/doc/html/rfc7515), and clients use the public key to verify the
provenance and integrity of the ID tokens. The public keys used for validating messages are published
as [JSON Web Keys](https://datatracker.ietf.org/doc/html/rfc7517) at `{.status.issuerURI}/oauth2/jwks`.

The `spec.tokenSignature.signAndVerifyKeyRef.name` references a secret containing PEM-encoded RSA keys, both `key.pem`
and `pub.pem`. In this specific example, we are
using [Secretgen-Controller](https://github.com/vmware-tanzu/carvel-secretgen-controller), a TAP dependency, to generate
the key for us.

Learn more about [Token Signatures](../../tutorials/service-operators/token-signature.md).

### Identity providers

```yaml
spec:
  identityProviders:
    - name: "internal"
      internalUnsafe:
        users:
          - username: "user"
            password: "password"
            email: "user@example.com"
            roles:
              - "user"
```

AppSSO's authorization server delegates login and user management to external identity providers (IDP), such as Google,
Azure Active Directory, Okta and so on. See diagram at the top of this topic for more information.

In this example, we use an `internalUnsafe` identity provider. As the name implies, it is _not_ an external IDP, but
rather a list of hardcoded user/passwords. As the name also implies, this is not considered safe for production. Here,
we declared a user with username = `user`, and password = `password`. For production setups,
consider using OpenID Connect IDPs instead.

The `email` and `roles` fields are optional for internal users. However, they will be useful when we want to use SSO
with a client application later in this guide.

> **Caution** VMware discourages using the `internalUnsafe` identity provider in production environments.

### <a id="config-storage"></a>Configuring storage

An `AuthServer` issues a Redis instance by default. It can be used for testing, prototyping and other non-production
purposes. No additional configuration is required.

To configure your own storage that is ready for production, see [Storage](../../tutorials/service-operators/storage.hbs.md).
