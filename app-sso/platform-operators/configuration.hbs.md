# Configure Application Single Sign-On

## TAP values

Most commonly, the AppSSO package installation is configured through TAP's meta package installation. The TAP package
has a `shared` top-level configuration key for sharing common configuration between the packages it installs.

AppSSO inherits the `shared.{ingress_domain, ingress_issuer, ca_cert_data, kubernetes_distribution}` configuration
values from Tanzu Application Platform. You can configure the AppSSO-specific parameters under `appsso`.
AppSSO-specific configuration has precedence over the shared values of Tanzu Application Platform.

For example:

```yaml
#! my-tap-values.yaml

shared:
# Shared configuration goes here.

appsso:
# AppSSO-specific configuration goes here.
```

## domain_name

The AppSSO package has one required configuration value, its `domain_name`. It is used for templating the issuer URI
for `AuthServer`. `domain_name` must be the shared ingress domain of your TAP package installation. If your TAP
installation is configured with `shared.ingress_domain`, then AppSSO will inherit the correct configuration.

>**Note** If omitted, `domain_name` is set to `shared.ingress_domain`.

## domain_template

You can customize how AppSSO template's issuerURIs with the `domain_template` configuration. This is a
Golang [text/template](https://pkg.go.dev/text/template). The default is `"\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"`.

The domain template will be applied with the given `domain_name` and the `AuthServer`'s name and namespace:

- `\{{.Domain}}` will evaluate to the configured `domain_name`
- `\{{.Name}}` will evaluate to `AuthServer.metadata.name`
- `\{{.Namespace}}` will evaluate to `AuthServer.metadata.namespace`

To be able to use a wild-card certificate, consider `"\{{.Name}}-\{{.Namespace}}.\{{.Domain}}"`.

It is strongly recommended to keep the name and namespace part of the template to avoid domain name collisions.

## default_authserver_clusterissuer

You can denote a `cert-manager.io/v1/ClusterIssuer` as a default issuer for `AuthServer.spec.tls.issuerRef` and omit `AuthServer.spec.tls`.
When the value of `AuthServer.spec.tls.issuerRef` is the empty string `""`, no default issuer is assumed and `AuthServer.spec.tls` is required.

If you configured `shared.ingress_issuer` and omitted `default_authserver_clusterissuer` while installing Tanzu Application Platform,
AppSSO uses the ingress issuer of Tanzu Application Platform and sets `default_authserver_clusterissuer` to `shared.ingress_issuer`.

## <a id="ca"></a>ca_cert_data

You can configure trust for custom CAs by providing their certificates as a PEM bundle to `ca_cert_data`. As a result, 
all `AuthServer`s trust your custom CAs.

This is useful if you have [identity providers](../service-operators/identity-providers.hbs.md) serving
certificates from a custom CA and [configuring AuthServer storage](../service-operators/storage.hbs.md).

Alternatively, you can [configure trust for a single AuthServer](../service-operators/ca-certs.hbs.md).

>**Note** AppSSO-specific `ca_cert_data` is concatenated with `shared.ca_cert_data`. The resulting PEM bundle contains both.

## kubernetes_distribution

This setting toggles behavior specific to Kubernetes distribution. Currently, the only supported values are `""`
and `openshift`.

AppSSO installs [_OpenShift_-specific RBAC and resources](openshift.md).

>**Note** If omitted, `kubernetes_distribution` is set to `shared.kubernetes_distribution`.

## Configuration schema

The entire available configuration schema for AppSSO is:

```yaml
#@schema/desc "Optional: Kubernetes platform distribution that this package is being installed on. Accepted values: ['','openshift']"
kubernetes_distribution: ""

#@schema/desc "Domain name for AuthServers"
domain_name: "example.com"

#@schema/desc "Optional: Golang template/text string for constructing AuthServer FQDNs"
domain_template: "\{{.Name}}.\{{.Namespace}}.\{{.Domain}}"

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

#@schema/desc "Optional: Schema-free extension point for internal, package-private configuration (Unsupported! Use at your own risk.)"
#@schema/type any=True
internal: { }
```
