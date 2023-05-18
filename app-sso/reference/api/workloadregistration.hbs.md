# WorkloadRegistration

`WorkloadRegistration` represents the request for client credentials for an
[AuthServer](authserver.hbs.md). It is a portable, higher-level abstraction
over [ClientRegistration](clientregistration.hbs.md). It is namespaced and 
is identified by its short name `workloadreg`.

`WorkloadRegistration` templates redirect URIs and reconciles into a
[ClientRegistration](clientregistration.hbs.md).

`WorkloadRegistration` exposes most of the fields of
[ClientRegistration](clientregistration.hbs.md). The exceptions are
`spec.redirectPaths` (instead of `spec.redirectURIs`), `spec.workloadDomainTemplate` 
and `spec.workloadRef`.

By templating redirect URIs, a `WorkloadRegistration` is decoupled from a client
workload's specific FQDN. As a result, it is portable across environments.

`spec.workloadDomainTemplate` is a golang
[text/template](https://pkg.go.dev/text/template). It is optional with default value `\{{.Name}}.\{{.Namespace}}.\{{.Domain}}`. You can change the default value to the 
[package configuration](../package-configuration.hbs.md) value 
`default_workload_domain_template`.

The values for `\{{.Name}}` and `\{{.Namespace}}` are inherited from
`spec.workloadRef`. The field `spec.workloadRef` is not resolved to an actual
workload running on the cluster. It is a holder for template values which identify 
a workload.

The [package configuration](../package-configuration.hbs.md) value 
`workload_domain_name` defines the value for `\{{.Domain}}`.

Similar to `ClientRegistration`: 

- `WorkloadRegistration` is bindable. It implements the 
  [Service Bindings](https://servicebinding.io/spec/core/1.0.0/)
  `ProvisionedService`. The credentials are returned as a [Service
  Bindings](https://servicebinding.io/spec/core/1.0.0/) `Secret`.

- A `WorkloadRegistration` must uniquely identify an `AuthServer` by using 
  `spec.authServerSelector`. If it matches none, too many or a disallowed `AuthServer`, 
  it does not get credentials.

`WorkloadRegistration` aggregates the readiness of its child `ClientRegistration`.

> **Note** The term "workload" is meant to express the general notion of a
> workload. The overlap with Cartographer's `Workload` API is therefore both
> incidental and accidental, because that API too is not opinionated as to what
> specific resources consolidat a "workload".
>
> `WorkloadRegistration` represents the client registration of any "workload" 
> whose redirect URIs can be templated. It must not be a `Workload` or even be 
> running on a Kubernetes cluster.

## <a id="spec"></a> Specification

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: WorkloadRegistration
metadata:
  name: "" #! required
  namespace: "" #! required
  annotations:
    sso.apps.tanzu.vmware.com/template-unsafe-redirect-uris: "" #! optional
spec:
  workloadDomainTemplate: "" #! optional
  workloadRef:
    name: "" #! required
    namespace: "" #! required
  authServerSelector:
    matchLabels: {} #! required
  redirectPaths: #! optional
    - "" #! must be an absolute path
  scopes: #! optional
    - name: "" #! required
      description: "" #! optional
  authorizationGrantTypes: #! optional
    - "" #! must be one of "authorization_code", "client_credentials" or "refresh_token"
  clientAuthenticationMethod: "" #! optional, must be one of "client_secret_post", "client_secret_basic" or "none"
  requireUserConsent: false #! optional
status:
  authServerRef:
    apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
    issuerURI: ""
    kind: AuthServer
    name: ""
    namespace: ""
  binding:
    name: ""
  conditions:
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: ClientRegistrationReady
  - lastTransitionTime: ""
    message: ""
    reason: ""
    status: ""
    type: Ready
  observedGeneration: 0
  redirectURIs:
  - ""
  workloadDomainTemplate: ""
```

Alternatively, you can interactively discover the API with:

```shell
kubectl explain workloadreg
```

## <a id="examples"></a> Examples

This is a minimal example which selects an `AuthServer` that is uniquely
identified by the label `sso.apps.tanzu.vmware.com/env=dev`:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: WorkloadRegistration
metadata:
  name: sample-minimal
spec:
  workloadRef:
    name: test-workload-name
    namespace: test-workload-namespace
  authServerSelector:
    matchLabels:
      sso.apps.tanzu.vmware.com/env: dev
```

This is a full example which selects an `AuthServer` that is uniquely identified
by label `sso.apps.tanzu.vmware.com/env=dev`. It uses all possible client
configurations and sets a custom `workloadDomainTemplate` and an annotation.
The annotation causes safe and unsafe redirect URI templating.

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: WorkloadRegistration
metadata:
  name: sample-full
  annotations:
    sso.apps.tanzu.vmware.com/template-unsafe-redirect-uris: ""
spec:
  workloadDomainTemplate: "hi-i-live-in-\{{.Namespace}}-and-my-name-is-\{{.Name}}.sample.\{{.Domain}}"
  workloadRef:
    name: test-workload-name
    namespace: test-workload-namespace
  authServerSelector:
    matchLabels:
      name: authserver-sample
      sample: "true"
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
  requireUserConsent: true
```

## <a id="redirect-uri"></a>Redirect URI templating

Redirect URIs are templated as follows:

1. If `spec.redirectPaths` is empty, no further action is required.

1. Resolve the workload domain template by reading
   `spec.workloadDomainTemplate` or default it to
   `default_workload_domain_template` if omitted.

1. Resolve the values for `\{{.Name}}` and `\{{.Namespace}}` from `spec.workloadRef`.

1. Resolve the value for `\{{.Domain}}` from `workload_domain_name`.

1. For each entry in `spec.redirectPaths`, template a full redirect URI by
   joining the path with the rendered workload domain template. Use `https` as
   the scheme.

1. If the annotation `sso.apps.tanzu.vmware.com/template-unsafe-redirect-uris`
   is present, template an additional unsafe redirect URI for each entry in
   `spec.redirectPaths` by using `http` as the scheme.

For example, if you set `workload_domain_name` to `tap.example.com`, a hypothetical
`WorkloadRegistration` might look as follows:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: WorkloadRegistration
metadata:
  name: demo
  annotations:
    sso.apps.tanzu.vmware.com/template-unsafe-redirect-uris: ""
spec:
  workloadRef:
    name: my-workload
    namespace: my-ns
  redirectPaths:
    - /login/success
    - /login/error
  #! ...
status:
  redirectURIs:
    - https://my-workload.my-ns.tap.example.com/login/success
    - http://my-workload.my-ns.tap.example.com/login/success
    - https://my-workload.my-ns.tap.example.com/login/error
    - http://my-workload.my-ns.tap.example.com/login/error
  workloadDomainTemplate: '\{{.Name}}.\{{.Namespace}}.\{{.Domain}}'
  #! ...
```
