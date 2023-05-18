# ClusterWorkloadRegistrationClass

`ClusterWorkloadRegistrationClass` represents the request to expose an
`AuthServer` as a claimable service offering. It is cluster-scoped. Its short
name is `cwrc`.

It receives a free-form description which explains the offering to those which
discover it with the `tanzu` CLI. It also receives a "base"
`WorkloadRegistration` stanza.

It reconciles into a _Crossplane_ `Composition` and a _Services Toolkit_
`ClusterInstanceClass`.

The `Composition` defines how to create a `WorkloadRegistration` for an
`AuthServer`. The `Composition` is for the composite resource
`XWorkloadRegistration`. It relies on Crossplane's _provider-kubernetes_.

The `ClusterInstanceClass` is applied with its description and a selector for
the `Composition`. Instances of this class are claimed via _Services Toolkit_'s
`ClassClaim`. See [claims](#claims).

The available parameters of the `ClusterInstanceClass` are those of
`XWorkloadRegistration`. Refer to the [XWorkloadRegistration's API
reference](./xworkloadregistration.hbs.md) for details on its fields.

The base `WorkloadRegistration` stanza is the blueprint for claims to this
class. It is the base `Object` for the `Composition`. This base gets patched
with the parameters from claims. Setting fields on the base will set the fields
on all claimed `WorkloadRegistration`. This is how they can match a certain
`AuthServer`, or have labels and annotations.

The base is a partial projection of `WorkloadRegistration`'s spec. It is
limited to the fields `metadata.labels`, `metadata.annotations`,
`spec.workloadDomainTemplate` and `spec.authServerSelector`. Refer to the
[WorkloadRegistration's API reference](./workloadregistration.hbs.md) for
details on its fields.

Once created the offering can be discovered with the `tanzu` CLI:

```
❯ tanzu services classes list
  NAME     DESCRIPTION
  <name>   <description>
```

The service's parameters can also be discovered with the `tanzu` CLI:

```
❯ tanzu services classes get <name>
NAME:           <name>
DESCRIPTION:    <description>
READY:          true

PARAMETERS:
  KEY                         DESCRIPTION  TYPE     DEFAULT               REQUIRED
  authorizationGrantTypes     [...]        array    [authorization_code]  false
  clientAuthenticationMethod  [...]        string   client_secret_basic   false
  redirectPaths               [...]        array    <nil>                 false
  requireUserConsent          [...]        boolean  true                  false
  scopes                      [...]        array    [map[...]]            false
  workloadRef.name            [...]        string   <nil>                 true
```

`ClusterWorkloadRegistrationClass` aggregates the readiness of its children.

It will not become ready until its base's `authServerSelector` uniquely selects
an `AuthServer`. When an `AuthServer` is matched its reference is written to
the status.

The `Composition` label selector is written to the status.

## Spec

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterWorkloadRegistrationClass
metadata:
  name: "" #! required
spec:
  description:
    short: "" #! required
  base:
    metadata:
      labels: {} #! optional
      annotations: {} #! optional
    spec:
      workloadDomainTemplate: "" #! optional
      authServerSelector:
        matchLabels: {} #! required
status:
  authServerRef:
    apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
    issuerURI: ""
    kind: AuthServer
    name: ""
    namespace: ""
  compositionSelector:
    matchLabels: {}
  conditions:
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: AuthServerResolved
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: ClusterInstanceClassReady
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: CompositionApplied
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: Ready
  observedGeneration: 1
```

Alternatively, you can interactively discover the API with:

```shell
kubectl explain cwrc
```

## Examples

This is a minimal example which selects an `AuthServer` which is uniquely
identified by the label `sso.apps.tanzu.vmware.com/env=dev`:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterWorkloadRegistrationClass
metadata:
  name: sample-minimal
spec:
  description:
    short: Single sign-on
  base: 
    spec:
      authServerSelector:
        matchLabels:
          sso.apps.tanzu.vmware.com/env: dev
```

This is full example which selects an `AuthServer` which is uniquely identified
by label `sso.apps.tanzu.vmware.com/env=dev`. It sets a custom
`workloadDomainTemplate` on the base, as well as a label and an annotation. The
annotation will result in safe and unsafe redirect URI templating.

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterWorkloadRegistrationClass
metadata:
  name: sample-full
spec:
  description:
    short: Single sign-on
  base: 
    metadata:
      labels:
        app.kubernetes.io/part-of: service-claims
      annotations:
        sso.apps.tanzu.vmware.com/template-unsafe-redirect-uris: ""
    spec:
      workloadDomainTemplate: "\{{.Namespace}}-\{{.Name}}.apps.\{{.Domain}}"
      authServerSelector:
        matchLabels:
          sso.apps.tanzu.vmware.com/env: staging
```

## Claims

Instances of this class are claimed via _Services Toolkit_'s `ClassClaim`.

The class is identified by name and the client registration's configuration is
set as its parameters. The "spec" of parameters is the spec of
[XWorkloadRegistration](./xworkloadregistration.hbs.md).

For details on the `ClassClaim` API see [its
reference](../../../services-toolkit/reference/api/clusterinstanceclass-and-classclaim.hbs.md).

> **Note** The propagation time of client credentials to the `ClassClaim` can be up to `120s`.

### Spec

This is the spec of a `ClassClaim` for a `ClusterWorkloadRegistrationClass`. It
is not the spec of the `ClassClaim` API as such.

```yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  name: "" #! required
  namespace: #! required
spec:
  classRef:
    name: "" #! required
  parameters:
    workloadRef:
      name: "" #! required
    redirectPaths: #! optional
      - "" #! must be an absolute path
    scopes: #! optional
      - name: "" #! required
        description: "" #! optional
    authorizationGrantTypes: #! optional
      - "" #! must be one of "authorization_code", "client_credentials" or "refresh_token"
    clientAuthenticationMethod: "" #! optional, must be one of "client_secret_post", "client_secret_basic" or "none"
    requireUserConsent: false #! optional
```

### Examples

Assuming there is a claimable AppSSO service offering, say:

```
❯ tanzu services classes list
  NAME               DESCRIPTION
  demo               Single Sign-On Demo
```

This is a minimal example claim for the AppSSO service offering `demo`:

```yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  name: sample-minimal
spec:
  classRef:
    name: demo
  parameters:
    workloadRef:
      name: sample-workload
    redirectPaths:
      - /redirect/uri/1
      - /redirect/uri/2
```

This is a fully-configured example claim for the AppSSO service offering
`demo`:

```yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  name: sample-full
spec:
  classRef:
    name: demo
  parameters:
    workloadRef:
      name: sample-workload
    redirectPaths:
      - /redirect/uri/1
      - /redirect/uri/2
    scopes:
      - name: openid
      - name: email
      - name: profile
      - name: roles
      - name: coffee.make
        description: bestows the ultimate power
    authorizationGrantTypes:
      - client_credentials
      - authorization_code
      - refresh_token
    clientAuthenticationMethod: client_secret_basic
    requireUserConsent: false
```

### Updates

`ClassClaim` performs a point-in-time look-up (see
[here](../../../services-toolkit/concepts/class-claim-vs-resource-claim.hbs.md)).
Therefore, updates to an existing `ClassClaim.spec.parameters` have no effect.

If you are creating your `ClassClaim` with _kapp_, you can configure it to
replace the resource instead of updating it when it changed:

```yaml
---
apiVersion: kapp.k14s.io/v1alpha1
kind: Config
rebaseRules:
  - resourceMatchers:
      - apiVersionKindMatcher:
          { apiVersion: services.apps.tanzu.vmware.com/v1alpha1, kind: ClassClaim }
    path: [metadata, annotations, "classclaims.services.apps.tanzu.vmware.com/xrd-name"]
    type: copy
    sources: [new, existing]

---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  annotations:
    kapp.k14s.io/update-strategy: always-replace
#! ...
```
