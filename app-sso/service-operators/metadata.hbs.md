# Annotations and labels

An `AuthServer` is selectable by `ClientRegistration` through labels. The namespace an `AuthServer`
allows `ClientRegistrations` from is controlled with an annotation.

## Labels

`ClientRegistrations` select an `AuthServer` with `spec.authServerSelector`. Therefore, an `AuthServer`
must have a set of labels that uniquely identifies it amongst all `AuthServer`. A `ClientRegistration` must match only
one `AuthServer`. Registration fails if multiple or no `AuthServer` resources are matched.

For example:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  labels:
    env: dev
    ldap: True
    saml: True
# ...
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  labels:
    env: prod
    saml: True
# ...
```

## Allowing client namespaces

`AuthServer` optionally controls from which namespace (one of more) it allows 
`ClientRegistrations` with the annotation:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  annotations:
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "my-apps"
```

To allow `ClientRegistrations` only from a restricted set of namespaces, 
you must set this annotation. 
Its value is a comma-separated list of allowed `Namespaces`, 
for example, `"app-team-red,app-team-green"`. 
If the annotation is missing, the default value is `*`, 
denoting that all client namespaces are allowed.

VMware recommends explicitly restricting to only workload-related namespaces to 
narrow the scope of the `AuthServer` operation.

## Unsafe configuration

`AuthServer` enforces secure and production-ready configuration. 
However, sometimes it is required to opt-out those constraints, 
for example, when deploying `AuthServer` on an iterate cluster.

>**Caution** Allowing **unsafe** is not recommended for production.

### Unsafe identity provider

The `InternalUnsafe` identity provider cannot be used unless explicitly allowed by including the annotation
`sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider` as follows:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
spec:
  identityProviders:
    - name: static-users
      internalUnsafe:
      # ...
```

If the annotation is not present and an `InternalUnsafe` identity provider is configured the `AuthServer` will not
apply.

### Unsafe issuer URI

It's not possible to use a plain HTTP issuer URI, unless it's explicitly allowed by including the 
annotation `sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri` as follows:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: ""
spec:
  issuerURI: http://this.is.unsafe
```

If the annotation is not present and a plain HTTP issuer URI is configured, the `AuthServer` does not apply.
