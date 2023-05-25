# Package configuration for AppSSO

In most cases, the Application Single Sign-on (commonly called AppSSO) package 
installation is configured by using the meta package installation of Tanzu 
Application Platform (commonly called TAP). 
The Tanzu Application Platform package has a `shared` top-level configuration key 
for sharing common configuration between the packages it installs.

AppSSO inherits the `shared.{ingress_domain, ingress_issuer, ca_cert_data,
kubernetes_distribution}` configuration values from TAP. These values can be
overridden with AppSSO-specific values under `appsso`. AppSSO-specific
configuration has precedence over the shared values of TAP.

For example:

```yaml
#! my-tap-values.yaml

shared:
# Shared configuration goes here.

appsso:
# AppSSO-specific configuration goes here.
```

## Values

### <a id="ca"></a>ca_cert_data

You can configure trust for custom CAs by providing their certificates as a PEM
bundle to `ca_cert_data`. As a result, all `AuthServer`s trust your custom CAs.

This is useful if you have [identity
providers](../service-operators/identity-providers.hbs.md) serving certificates
from a custom CA and [configuring AuthServer
storage](../service-operators/storage.hbs.md).

Alternatively, you can [configure trust for a single
AuthServer](../service-operators/ca-certs.hbs.md).

>**Note** AppSSO-specific `ca_cert_data` is concatenated with
>`shared.ca_cert_data`. The resulting PEM bundle contains both.

### cluster_resource_namespace

This setting designates the target namespace for when cluster-scoped APIs
reconcile into namespace-scoped resources.

In particular, the cluster-scoped
[ClusterUnsafeTestLogin](./api/clusterunsafetestlogin.hbs.md) reconciles into
namespace-scoped resources; an `AuthServer` amongst others. These resources
will be placed in the `cluster_resource_namespace`.o

The default is `appsso`.

>**Note** Updating the `cluster_resource_namespace` of an existing package
>installation will delete-create namespace-scoped resources in the new
>namespace. This causes downtime of the impacted resources momentarily.

### default_authserver_clusterissuer

You can denote a `cert-manager.io/v1/ClusterIssuer` as a default issuer for
`AuthServer.spec.tls.issuerRef` and omit `AuthServer.spec.tls`. When the value
of `AuthServer.spec.tls.issuerRef` is the empty string `""`, no default issuer
is assumed and `AuthServer.spec.tls` is required.

If you configured `shared.ingress_issuer` and omitted
`default_authserver_clusterissuer` while installing Tanzu Application Platform,
AppSSO uses the ingress issuer of Tanzu Application Platform and sets
`default_authserver_clusterissuer` to `shared.ingress_issuer`.

### default_workload_domain_template

This is the default template from which
[WorkloadRegistration](./api/workloadregistration.hbs.md) render redirect URIs.
It is used when `WorkloadRegistration.spec.workloadDomainTemplate` is omitted.

This is a Golang [text/template](https://pkg.go.dev/text/template). The default
is `"\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"`.

The domain template will be applied with the configured `workload_domain_name`
as well as the name and namespace specified in
`WorkloadRegistration.spec.workloadRef`. Refer to [redirect URI
templating](./api/workloadregistration.hbs.md#redirect-uri-templating).

>**Note** Usually, you will want this to be same as
>[CNRs](../../cloud-native-runtimes/about.hbs.md)' `domain_template`.

### domain_name

The AppSSO package has one required configuration value, its `domain_name`. It
is used for templating the issuer URI for `AuthServer`. `domain_name` must be
the shared ingress domain of your TAP package installation. If your TAP
installation is configured with `shared.ingress_domain`, then AppSSO will
inherit the correct configuration.

>**Note** If omitted, `domain_name` is set to `shared.ingress_domain`.

### domain_template

You can customize how AppSSO template's issuerURIs with the `domain_template`
configuration. This is a Golang
[text/template](https://pkg.go.dev/text/template). The default is
`"\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"`.

The domain template will be applied with the given `domain_name` and the
`AuthServer`'s name and namespace:

- `\{{.Domain}}` will evaluate to the configured `domain_name`
- `\{{.Name}}` will evaluate to `AuthServer.metadata.name`
- `\{{.Namespace}}` will evaluate to `AuthServer.metadata.namespace`

To be able to use a wild-card certificate, consider
`"\{{.Name}}-\{{.Namespace}}.\{{.Domain}}"`.

It is strongly recommended to keep the name and namespace part of the template
to avoid domain name collisions.

### kubernetes_distribution

This setting toggles behavior for specific Kubernetes distributions. Currently,
the only supported values are `""` and `openshift`.

It is processed in combination with `kubernetes_version`.

AppSSO installs [_OpenShift_-specific RBAC and resources](openshift.md).

>**Note** If omitted, `kubernetes_distribution` is set to
>`shared.kubernetes_distribution`.

### kubernetes_version

This setting toggles behavior for specific Kubernetes distributions. Currently,
the only supported values are `""` and or semantic versions in the form of
`\d*\.\d*\.\d*`.

It is processed in combination with `kubernetes_distribution`.

AppSSO installs [_OpenShift_-specific RBAC and resources](openshift.md).

>**Note** If omitted, `kubernetes_version` is set to
>`shared.kubernetes_version`.

### workload_domain_name

This is used as the value for `\{{.Domain}}` in
[WorkloadRegistration](./api/workloadregistration.hbs.md)'s domain template.

`workload_domain_name` defaults to the value of `domain_name`.

>**Note** Usually, you will want this to be same as
>[CNRs](../../cloud-native-runtimes/about.hbs.md)' `domain_name`.

## Schema

The package installation of `sso.apps.tanzu.vmware.com` has the following
configuration schema:

<!---
Generated with:
```shell
cat ~/workspace/sso4k8s/carvel/config/values-schema.yml
```
--->

```yaml
---

#@schema/desc "Optional: Kubernetes platform distribution that this package is being installed on. Accepted values: ['','openshift']"
kubernetes_distribution: ""

#@schema/desc "Optional: Kubernetes platform version that this package is being installed on. Accepted format: ['x.x.x']"
kubernetes_version: ""

#@schema/desc "Domain name for AuthServers"
domain_name: "example.com"

#@schema/desc "Optional: Golang template/text string for constructing AuthServer FQDNs"
domain_template: "\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"

#@schema/desc "Optional: A cert-manager.io/v1/ClusterIssuer for defaulting AuthServer TLS"
default_authserver_clusterissuer: ""

#@schema/desc "Optional: Domain name for Workloads. Defaults to the value of domain_name"
workload_domain_name: ""

#@schema/desc "Optional: Golang template/text string for defaulting Workload FQDNs templating"
default_workload_domain_template: "\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"

#@schema/desc "The namespace which children of cluster-scoped resources are located in"
cluster_resource_namespace: "appsso"

#@schema/desc "Optional: PEM-encoded certificate data for AuthServers to trust TLS connections with a custom CA"
ca_cert_data: ""

#@schema/desc "Optional: Interval at which the controller will re-synchronize applied resources"
resync_period: "2h"

#@schema/desc "Optional: Number of controller replicas to deploy"
replicas: 1

#@schema/desc "Optional: Resource requirements the controller deployment"
resources:
  requests:
    #@schema/desc "CPU request of the controller"
    cpu: "20m"
    #@schema/desc "Memory request of the controller"
    memory: "100Mi"
  limits:
    #@schema/desc "CPU limit of the controller"
    cpu: "500m"
    #@schema/desc "Memory limit of the controller"
    memory: "500Mi"
```
