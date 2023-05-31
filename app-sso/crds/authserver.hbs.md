# AuthServer API for AppSSO

In Application Single Sign-On (commonly called AppSSO), `AuthServer` represents 
the request for an OIDC authorization server. It causes the deployment of an 
authorization server backed by Redis over mTLS.

An `AuthServer` should have labels which allow to uniquely match it amongst others. `ClientRegistration` selects an
`AuthServer` by label selector and needs a unique match to be successful.

To allow `ClientRegistrations` from all or a restricted set of Namespaces, the
annotation `sso.apps.tanzu.vmware.com/allow-client-namespaces` must be set. Its value is a comma-separated list of
allowed Namespaces, e.g. `"app-team-red,app-team-green"`, or `"*"` if it should allow clients from all namespaces. If
the annotation is missing, no clients are allowed.

The issuer URI, which is the point of entry for clients and end-users, is constructed through the package's `domain_template`.
You can view the issuer URI by running
`kubectl get authserver -n authservers`.

See [Issuer URI & TLS](../service-operators/issuer-uri-and-tls.md) for more information.

>**Note** You must configure the issuer URI through `spec.tls` instead of `spec.issuerURI`, which is deprecated.

Token signature keys are configured through `spec.tokenSignature`. If no keys are configured, no tokens can be minted.

Identity providers are configured under `spec.identityProviders`. If there are none, end-users won't be able to log in.

The deployment can be further customized by configuring replicas, resources, http server and logging properties.

An `AuthServer` reconciles into the following resources in its namespace:

```text
AuthServer/my-authserver
├─Certificate/my-authserver-redis-client
├─Certificate/my-authserver-redis-server
├─Certificate/my-authserver-root
├─ConfigMap/my-authserver-ca-cert
├─Deployment/my-authserver-auth-server
├─Deployment/my-authserver-redis
├─Issuer/my-authserver-bootstrap
├─Issuer/my-authserver-root
├─Role/my-authserver-auth-server
├─RoleBinding/my-authserver-auth-server
├─Secret/my-authserver-auth-server-clients
├─Secret/my-authserver-auth-server-keys
├─Secret/my-authserver-auth-server-properties
├─Secret/my-authserver-redis-client-cert-keystore-password
├─Secret/my-authserver-registry-credentials
├─Service/my-authserver-redis
└─ServiceAccount/my-authserver-auth-server
```

## Spec

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: ""
  namespace: ""
  labels: { } # required, must uniquely identify this AuthServer
  annotations:
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "" # required, must be "*" or a comma-separated list of allowed client namespaces
    sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: "" # optional
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: "" # optional
spec:
  # .tls and .issuerURI are mutually exclusive
  tls:
    # must be one and only one of issuerRef, certificateRef or secretRef, unless disabled
    issuerRef:
      name: ""
      kind: ""
      group: cert-manager.io
    certificateRef:
      name: ""
    secretRef:
      name: ""
    disabled: false # If true, requires annotation `sso.apps.tanzu.vmware.com/allow-unsafe-issuer-uri: ""`
  issuerURI: "" # DEPRECATED and marked for removal. Use .tls instead.
  tokenSignature: # optional
    signAndVerifyKeyRef:
      name: ""
    extraVerifyKeyRefs:
      - name: ""
  identityProviders: # optional
    # each must be one and only one of internalUnsafe, ldap, openID or saml
    - name: "" # must be unique
      internalUnsafe: # requires annotation `sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""`
        users:
          - username: ""
            password: ""
            givenName: ""
            familyName: ""
            email: ""
            emailVerified: false
            roles:
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
        group:
          searchFilter: ""
          searchBase: ""
          searchSubTree: false
          searchDepth: 0
          roleAttribute: ""
    - name: "" # must be unique
      openID:
        issuerURI: ""
        clientID: ""
        clientSecretRef:
          name: ""
        scopes:
          - ""
    - name: "" # must be unique
      saml:
        metadataURI: ""
        claimMappings: { }
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
      LastParentGenerationWithRestart: 0 # DEPRECATED and marked for removal.
      configHash: ""
      image: ""
      replicas: 0
    redis:
      image: ""
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

`.status.tokenSignatureKeyCount` is the number of currently configured token signature keys.

`.status.clientRegistrationCount` is the number of currently registered clients.

`.status.deployments.authServer` describes the current authorization server deployment by listing the running image,
its replicas, the hash of the current configuration and the generation which has last resulted in a restart.

`.status.deployments.redis` describes the current Redis deployment by listing its running image.

`.status.conditions` documents each step in the reconciliation:

- `Valid`: Is the spec valid?
- `ImagePullSecretApplied`: Has the image pull secret been applied?
- `SignAndVerifyKeyResolved`: Has the single sign-and-verify key been resolved?
- `ExtraVerifyKeysResolved`: Have the single extra verify keys been resolved?
- `IdentityProvidersResolved`: Has all identity provider configuration been resolved?
- `ConfigResolved`: Has the complete configuration for the authorization server been resolved?
- `AuthServerConfigured`: Has the complete configuration for the authorization server been applied?
- `IssuerURIReady`: Is the authorization server yet responding to `{spec.issuerURI}/.well-known/openid-configuration`?
- `Ready`: whether all the previous conditions are "True"

The super condition `Ready` denotes a fully successful reconciliation of a given `ClientRegistration`.

If everything goes well you will see something like this:

```yaml
issuerURI: "https://..."
observedGeneration: 1
tokenSignatureKeyCount: 0
clientRegistrationCount: 0
deployments:
  authServer:
    LastParentGenerationWithRestart: 1
    configHash: "11216479096262796218"
    image: "..."
    replicas: 1
  redis:
    image: "..."
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
    sso.apps.tanzu.vmware.com/allow-client-namespaces: "*"
    sso.apps.tanzu.vmware.com/allow-unsafe-identity-provider: ""
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
  identityProviders:
    - name: internal
      internalUnsafe:
        users:
          - username: user
            password: password
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
        claimMappings:
          roles: my_custom_okta_roles_claim

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
