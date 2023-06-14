# AuthServer API for AppSSO

In Application Single Sign-On (commonly called AppSSO), `AuthServer` represents 
the request for an OIDC authorization server. It causes the deployment of an authorization
server backed by Redis over mutual TLS if no storage is defined.

An `AuthServer` should have labels which allow to uniquely match it amongst others. `ClientRegistration` selects an
`AuthServer` by label selector and needs a unique match to be successful.

To allow `ClientRegistrations` only from a restricted set of `Namespaces`, you must set the annotation 
`sso.apps.tanzu.vmware.com/allow-client-namespaces`. Its value is a comma-separated list of
allowed `Namespaces`, for example, `"app-team-red,app-team-green"`. If the annotation is missing, the default value is `*`, 
denoting that all client namespaces are allowed.

The issuer URI, which is the point of entry for clients and end-users, is constructed through the package's `domain_template`.
You can view the issuer URI by running `kubectl get authserver -n authservers`.

See [Issuer URI & TLS](../../tutorials/service-operators/issuer-uri-and-tls.md) for more information.

Token signature keys are configured by using `spec.tokenSignature`. This is a required field. See
[Token signatures](../../tutorials/service-operators/token-signature.md) for more context.

You can configure identity providers under `spec.identityProviders`. If there is none, end-users can not log in. 
For more information about configuring identity providers, see [Identity providers](../../tutorials/service-operators/identity-providers.hbs.md).

The deployment can be further customized by configuring replicas, resources, http server and logging properties.

## Spec

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: ""
  namespace: ""
  labels: { } # required, must uniquely identify this AuthServer
  annotations:
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "" # optional, a comma-separated list of allowed client namespaces
    sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: "" # optional
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: "" # optional
    sso.apps.tanzu.vmware.com/allow-unsafe-cors: "" # optional
spec:
  # .tls is optional if a default issuer is set
  tls:
    # must be one and only one of issuerRef, certificateRef or secretRef, unless deactivated
    issuerRef:
      name: ""
      kind: ""
      group: cert-manager.io
    certificateRef:
      name: ""
    secretRef:
      name: ""
    deactivated: false # If true, requires annotation `sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: ""`.
  cors:
    allowOrigins: # optional, cannot be combined with 'allowAllOrigins'.
      - ""
    allowAllOrigins: false # optional
                           # If true, requires annotation `sso.apps.tanzu.vmware.com/allow-unsafe-cors: ""`.
                           # Cannot be combined with 'allowOrigins'.
  token:             # optional
    accessToken:     # optional
      expiry: "12h"  # optional, default expiry is 12 hours
    refreshToken:    # optional
      expiry: "720h" # optional, default expiry is 720 hours (30 days)
    idToken:         # optional
      expiry: "12h"  # optional, default expiry is 12 hours
  tokenSignature: # required
    signAndVerifyKeyRef:
      name: ""
    extraVerifyKeyRefs:
      - name: ""
  storage: # optional
    redis: # required if 'storage' is defined
      serviceRef: # reference to a provisioned service within the same namespace as this AuthServer. Currently supports Secret reference only.
        apiVersion: "v1"
        kind: "Secret"
        name: ""
  caCerts: # optional
    - secretRef: # reference to Secret resource within the same namespace as this AuthServer.
        name: ""
  identityProviders: # optional
    # each must be one and only one of internalUnsafe, ldap, openID or saml
    - name: "" # must be unique
      internalUnsafe: # requires annotation `sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""`
        users:
          - username: ""
            password: ""
            claims: # optional
              custom_claim: ""
              another_custom_claim: ""
            roles:
              - ""
        accessToken: # optional
          scope:
            defaults: # optional
            - ""
            rolesToScopes: # optional
              - fromRole: ""
                toScopes:
                  - ""
    - name: "" # must be unique
      ldap:
        server:
          scheme: ""
          host: ""
          port: 0
          base: ""
        bind:
          dn: ""
          passwordRef:
            name: ldap-password
        user:
          searchFilter: ""
          searchBase: ""
        roles: # optional
          fromUpstream:
            attribute: "" # required
            search:
              filter: ""
              base: ""
              subTree: false
              depth: 0
          filterBy: # optional
            - exactMatch: ""
            - regex: "" # must be valid regular expression
        idToken: # optional
          claims:
            - fromUpstream: ""
              toClaim: ""
        accessToken: # optional
          scope:
            defaults: # optional
            - ""
            rolesToScopes: # optional
              - fromRole: ""
                toScopes:
                - ""
        group:    # deprecated, use 'ldap.roles.fromUpstream' instead.
          search: # deprecated, use 'ldap.roles.fromUpstream.search' instead.
            filter: ""
            base: ""
            subTree: false
            depth: 0
          roleAttribute: "" # deprecated, use 'ldap.roles.fromUpstream.attribute' instead.
    - name: "" # must be unique
      openID:
        issuerURI: ""
        clientID: ""
        clientSecretRef:
          name: ""
        scopes:
          - ""
        roles: # optional
          fromUpstream:
            claim: "" # required
          filterBy: # optional
            - exactMatch: ""
            - regex: "" # must be valid regular expression
        idToken: # optional
          claims:
            - fromUpstream: ""
              toClaim: ""
        accessToken: # optional
          scope:
            defaults: # optional
            - ""
            rolesToScopes: # optional
              - fromRole: ""
                toScopes:
                - ""
    - name: "" # must be unique
      saml:
        metadataURI: ""
        roles: # optional
          fromUpstream:
            attribute: "" # required
          filterBy: # optional
            - exactMatch: ""
            - regex: "" # must be valid regular expressions
        idToken: # optional
          claims:
            - fromUpstream: ""
              toClaim: ""
        accessToken: # optional
          scope:
            defaults: # optional
              - ""
            rolesToScopes: # optional
              - fromRole: ""
                toScopes:
                  - ""
  replicas: 1 # optional, default 2
  logging: "" # optional, must be valid YAML
  server: "" # optional, must be valid YAML
  resources: # optional, default {requests: {cpu: "256m", memory: "300Mi"}, limits: {cpu: "2", memory: "768Mi"}}
    requests:
      cpu: ""
      mem: ""
    limits:
      cpu: ""
      mem: ""
  redisResources: # optional, default {requests: {cpu: "50m", memory: "100Mi"}, limits: {cpu: "100m", memory: "256Mi"}}
    requests:
      cpu: ""
      mem: ""
    limits:
      cpu: ""
      mem: ""
status:
  observedGeneration: 0
  issuerURI: ""
  clientRegistrationCount: 1
  tokenSignatureKeyCount: 0
  deployments:
    authServer:
      configHash: ""
      image: ""
      replicas: 0
    redis: # left empty if storage is configured by the service operator
      image: ""
  storage:
    redis:
      host: "" # the hostname of the configured Redis
      port: "" # the port of the configured Redis
  tls:
    deactivated: false
    issuerRef:
      name: ""
      kind: ""
      group: cert-manager.io
  conditions:
    - lastTransitionTime:
      message: ""
      reason: ""
      status: "True" # or "False"
      type: ""
```

Alternatively, you can interactively discover the spec with:

```shell
kubectl explain authservers.sso.apps.tanzu.vmware.com
```

## Status & conditions

The `.status` subresource helps you to learn the `AuthServer`'s readiness, resulting deployments, attached clients and
to troubleshoot issues.

`.status.issuerURI` is the templated issuer URI. This is the entry point for any traffic.

`.status.tls` is the actual TLS configuration.

`.status.tokenSignatureKeyCount` is the number of currently configured token signature keys.

`.status.clientRegistrationCount` is the number of currently registered clients.

`.status.deployments.authServer` describes the current authorization server deployment by listing the running image,
its replicas, the hash of the current configuration and the generation which has last resulted in a restart.

`.status.deployments.redis` describes the current provided Redis deployment by listing its running image. This field is
nil if storage is defined explicitly by using `.spec.storage`.

`.status.storage.redis` describes the configured Redis storage such as host name and port number.

`.status.conditions` documents each step in the reconciliation:

- `Valid`: Is the spec valid?
- `ImagePullSecretApplied`: Has the image pull secret been applied?
- `SignAndVerifyKeyResolved`: Has the single sign-and-verify key been resolved?
- `ExtraVerifyKeysResolved`: Have the single extra verify keys been resolved?
- `IdentityProvidersResolved`: Has all identity provider configuration been resolved?
- `ConfigResolved`: Has the complete configuration for the authorization server been resolved?
- `AuthServerConfigured`: Has the complete configuration for the authorization server been applied?
- `IssuerURIReady`: Is the authorization server yet responding to `{.status.issuerURI}/.well-known/openid-configuration`?
- `Ready`: whether all the previous conditions are "True"

The super condition `Ready` denotes a fully successful reconciliation of a given `ClientRegistration`.

If everything goes well you will see something like this:

```yaml
issuerURI: "https://..."
observedGeneration: 1
tokenSignatureKeyCount: 0
clientRegistrationCount: 0
caCerts:
  - cert:
      subject: ""
    source:
      secretEntry: ""
deployments:
  authServer:
    LastParentGenerationWithRestart: 1
    configHash: "11216479096262796218"
    image: "..."
    replicas: 1
  redis: # leave empty if external storage is defined
    image: "..."
storage:
  redis:
   host: "" # the host name of the configured Redis
   port: "" # the port of the configured Redis
tls:
  deactivated: false
  # One of issuerRef, certificateRef or secretRef is set if TLS is enabled 
  issuerRef:
    name: ""
    kind: ""
    group: ""
  certificateRef:
    name: ""
  secretRef:
    name: ""
conditions:
  - lastTransitionTime: "2022-08-24T09:58:10Z"
    message: ""
    reason: KeysConfigSecretUpdated
    status: "True"
    type: AuthServerConfigured
  - lastTransitionTime: "2022-08-24T09:58:10Z"
    message: ""
    reason: Resolved
    status: "True"
    type: ConfigResolved
  - lastTransitionTime: "2022-08-24T09:58:10Z"
    message: ""
    reason: ExtraVerifyKeysResolved
    status: "True"
    type: ExtraVerifyKeysResolved
  - lastTransitionTime: "2022-08-24T09:58:10Z"
    message: ""
    reason: Resolved
    status: "True"
    type: IdentityProvidersResolved
  - lastTransitionTime: "2022-08-24T09:58:10Z"
    message: ""
    reason: ImagePullSecretApplied
    status: "True"
    type: ImagePullSecretApplied
  - lastTransitionTime: "2022-08-24T09:58:28Z"
    message: ""
    reason: Ready
    status: "True"
    type: IssuerURIReady
  - lastTransitionTime: "2022-08-24T09:58:28Z"
    message: ""
    reason: Ready
    status: "True"
    type: Ready
  - lastTransitionTime: "2022-08-24T09:58:10Z"
    message: ""
    reason: SignAndVerifyKeyResolved
    status: "True"
    type: SignAndVerifyKeyResolved
  - lastTransitionTime: "2022-08-24T09:58:10Z"
    message: ""
    reason: Valid
    status: "True"
    type: Valid
```

## RBAC

The `ServiceAccount` of the authorization server has a `Role` with the following permissions:

```yaml
- apiGroups:
    - ""
  resources:
    - secrets
  verbs:
    - get
    - list
    - watch
  resourceNames:
    - { name }-auth-server-keys
    - { name }-auth-server-clients
```

## Example

This example requests an authorization server with two token signature keys and two identity providers.

>**Note** The label used for matching to ClientRegistrations must be unique across namespaces.

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: authserver-sample
  namespace: default
  labels:
    identifier: authserver-identifier
    sample: "true"
  annotations:
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
    sso.apps.tanzu.vmware.com/allow-unsafe-cors: ""
spec:
  replicas: 1
  tls:
    issuerRef:
      name: my-cluster-issuer
      kind: ClusterIssuer
  tokenSignature:
    signAndVerifyKeyRef:
      name: sample-token-signing-key
    extraVerifyKeyRefs:
      - name: sample-token-verification-key
  cors:
    allowAllOrigins: true
  identityProviders:
    - name: internal
      internalUnsafe:
        users:
          - username: user
            password: password
            claims:
              alt_address: "123 Alternate Street"
            roles:
              - message.write
    - name: okta
      openID:
        issuerURI: https://dev-xxxxxx.okta.com
        clientID: xxxxxxxxxxxxx
        clientSecretRef:
          name: okta-client-secret
        authorizationUri: https://dev-xxxxxx.okta.com/oauth2/v1/authorize
        tokenUri: https://dev-xxxxxx.okta.com/oauth2/v1/token
        jwksUri: https://dev-xxxxxx.okta.com/oauth2/v1/keys
        scopes:
          - openid
        roles:
          fromUpstream:
            claim: my_custom_okta_roles_claim
        idToken:
          claims:
            - fromUpstream: "alternate_address"
              toClaim: "alt_address"
        accessToken:
          scope:
            defaults:
              - "developer.read"
              - "developer.write"
            rolesToScopes:
              - fromRole: "finance"
                toScopes:
                  - "finance.read"
                  - "finance.write"

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: sample-token-signing-key
  namespace: default
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)

---
apiVersion: secretgen.k14s.io/v1alpha1
kind: RSAKey
metadata:
  name: sample-token-verification-key
  namespace: default
spec:
  secretTemplate:
    type: Opaque
    stringData:
      key.pem: $(privateKey)
      pub.pem: $(publicKey)

---
apiVersion: v1
kind: Secret
metadata:
  name: okta-client-secret
  namespace: default
stringData:
  clientSecret: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
