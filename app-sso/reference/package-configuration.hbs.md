# Package configuration for Application Single Sign-On

In most cases, the Application Single Sign-on (commonly called AppSSO) package
installation is configured by using the meta package installation of Tanzu
Application Platform (commonly called TAP).
The Tanzu Application Platform package has a `shared` top-level configuration key
for sharing common configuration between the packages it installs.

Application Single Sign-on inherits the `shared.{ingress_domain, ingress_issuer, ca_cert_data,
kubernetes_distribution}` configuration values from Tanzu Application Platform.
You can override these values with Application Single Sign-On specific values under `appsso`.
Application Single Sign-On specific configuration has precedence over the shared
values of Tanzu Application Platform.

For example:

```yaml
#! my-tap-values.yaml

shared:
# Shared configuration goes here.

appsso:
# AppSSO-specific configuration goes here.
```

## <a id="values"></a>Configuration values

The package installation of `sso.apps.tanzu.vmware.com` has the following
configuration values:

### <a id="ca"></a> `ca_cert_data`

You can configure trust for custom CAs by providing their certificates as a PEM
bundle to `ca_cert_data`. As a result, all `AuthServer`s trust your custom CAs.

This is useful if you have [Identity
providers](../how-to-guides/service-operators/identity-providers.hbs.md) serving certificates
from a custom CA and [configuring AuthServer
storage](../how-to-guides/service-operators/storage.hbs.md).

Alternatively, you can [configure trust for a single
AuthServer](../how-to-guides/service-operators/ca-certs.hbs.md).

>**Note** Application Single Sign-on specific `ca_cert_data` is concatenated with
>`shared.ca_cert_data`. The resulting PEM bundle contains both.

### <a id="cluster-resource-namespace"></a> `cluster_resource_namespace`

This setting designates the target namespace when the cluster-scoped APIs
reconcile into namespace-scoped resources.

In particular, the cluster-scoped
[ClusterUnsafeTestLogin](./api/clusterunsafetestlogin.hbs.md) reconciles into
namespace-scoped resources such as an `AuthServer`. These resources
are placed in the `cluster_resource_namespace`.

The default value of `cluster_resource_namespace` is `appsso`.

>**Note** Updating the `cluster_resource_namespace` of an existing package
>installation delete or create namespace-scoped resources in the new
>namespace. This causes downtime for the impacted resources momentarily.

### <a id="authserver-clusterissuer"></a> `default_authserver_clusterissuer`

You can denote a `cert-manager.io/v1/ClusterIssuer` as a default issuer for
`AuthServer.spec.tls.issuerRef` and omit `AuthServer.spec.tls`. When the value
of `AuthServer.spec.tls.issuerRef` is the empty string `""`, no default issuer
is assumed and no `AuthServer.spec.tls` is required.

If you configured `shared.ingress_issuer` and omitted
`default_authserver_clusterissuer` while installing Tanzu Application Platform,
Application Single Sign-on uses the ingress issuer of Tanzu Application Platform
and sets `default_authserver_clusterissuer` to `shared.ingress_issuer`.

### <a id="workload-domain-template"></a> `default_workload_domain_template`

This is the default template from which
[WorkloadRegistration](./api/workloadregistration.hbs.md) renders redirect URIs.
It is used when `WorkloadRegistration.spec.workloadDomainTemplate` is omitted.

This is a golang [text/template](https://pkg.go.dev/text/template). The default
is `"\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"`.

The domain template is applied with the configured `workload_domain_name`
and the name and namespace specified in `WorkloadRegistration.spec.workloadRef`.
For more information, see [Redirect URI templating](./api/workloadregistration.hbs.md#redirect-uri-templating).

VMware recommends maintaining consistency between the values of `default_workload_domain_template` 
and [Cloud Native Runtimes](../../cloud-native-runtimes/about.hbs.md)'
`domain_template`. Both values share the same default configuration. 
However, for customization purposes, using the same value for both settings ensures 
that `Workloads` get the expected redirect URIs templated.

### <a id="domain-name"></a> `domain_name`

The Application Single Sign-on package has one required configuration value,
its `domain_name`. It templates the issuer URI for `AuthServer`. `domain_name` must be
the shared ingress domain of your Tanzu Application Platform package installation.
If your Tanzu Application Platform installation is configured with `shared.ingress_domain`,
Application Single Sign-on inherits the correct configuration.

If omitted, `domain_name` is set to `shared.ingress_domain`.

### <a id="domain-template"></a> `domain_template`

You can customize how Application Single Sign-on template's `issuerURIs` with
the `domain_template` configuration. This is a golang
[text/template](https://pkg.go.dev/text/template). The default value is
`"\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"`.

The domain template is applied with the given `domain_name` and the
`AuthServer`'s name and namespace:

- `\{{.Domain}}` evaluates to the configured `domain_name`
- `\{{.Name}}` evaluates to `AuthServer.metadata.name`
- `\{{.Namespace}}` evaluates to `AuthServer.metadata.namespace`

To use a wild-card certificate, consider `"\{{.Name}}-\{{.Namespace}}.\{{.Domain}}"`.

VMware recommends keeping the name and namespace sections of the template
to avoid domain name collisions.

### <a id="kubernetes-distribution"></a> `kubernetes_distribution`

This setting toggles behavior for specific Kubernetes distributions. Currently,
the only supported values are `""` and `openshift`.

It is processed in combination with `kubernetes_version`.

Application Single Sign-On installs OpenShift specific RBAC and resources.
For more information, see [Application Single Sign-On for OpenShift clusters](openshift.md).

If omitted, `kubernetes_distribution` is set to `shared.kubernetes_distribution`.

### <a id="kubernetes-version"></a> `kubernetes_version`

This setting toggles behavior for specific Kubernetes distributions. Currently,
the only supported values are `""` or semantic versions in the form of
`\d*\.\d*\.\d*`.

It is processed in combination with `kubernetes_distribution`.

Application Single Sign-On installs OpenShift specific RBAC and resources.
For more information, see [Application Single Sign-On for OpenShift clusters](openshift.md).

If omitted, `kubernetes_version` is set to `shared.kubernetes_version`.

### <a id="workload-domain-name"></a>`workload_domain_name`

This is used as the value for `\{{.Domain}}` in
[WorkloadRegistration](./api/workloadregistration.hbs.md)'s domain template.

`workload_domain_name` defaults to the value of `domain_name`.

In most cases, the value of `workload_domain_name` matches the value
of [Cloud Native Runtimes](../../cloud-native-runtimes/about.hbs.md)' `domain_name`.

### <a id="replicas"></a> `replicas`

The controller is run with this many replicas. The default value is `1`.

The controller uses leader election so that there is only a single
active replica at a time. Increasing this value does not improve the
controller's performance.

### <a id="resources"></a> `resources`

This is the value for the controller's
`Deployment.spec.template.spec.containers[0].resources`.

See [Configuration schema](#schema) for more information about its structure and
default values.

### <a id="resync-period"></a>`resync_period`

This is the duration after which the controller re-synchronizes all resources.
That means that every instance of a Application Single Sign-On API is reconciled at this point.

The default value is `2h`.

VMware does not recommend customizing this value in all practical scenarios.

## <a id="schema"></a> Configuration schema

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

#@schema/desc "Domain name for AuthServers."
domain_name: "example.com"

#@schema/desc "Optional: Golang template/text string for constructing AuthServer FQDNs."
domain_template: "\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"

#@schema/desc "Optional: A cert-manager.io/v1/ClusterIssuer for defaulting AuthServer TLS."
default_authserver_clusterissuer: ""

#@schema/desc "Optional: Domain name for Workloads. Defaults to the value of domain_name."
workload_domain_name: ""

#@schema/desc "Optional: Golang template/text string for defaulting Workload FQDNs templating."
default_workload_domain_template: "\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"

#@schema/desc "The namespace which children of cluster-scoped resources are located in."
cluster_resource_namespace: "appsso"

#@schema/desc "Optional: PEM-encoded certificate data for AuthServers to trust TLS connections with a custom CA."
ca_cert_data: ""

#@schema/desc "Optional: Interval at which the controller will re-synchronize applied resources."
resync_period: "2h"

#@schema/desc "Optional: Number of controller replicas to deploy."
replicas: 1

#@schema/desc "Optional: Resource requirements of the controller deployment."
resources:
  requests:
    #@schema/desc "CPU request of the controller."
    cpu: "20m"
    #@schema/desc "Memory request of the controller."
    memory: "100Mi"
  limits:
    #@schema/desc "CPU limit of the controller."
    cpu: "500m"
    #@schema/desc "Memory limit of the controller."
    memory: "500Mi"
```
