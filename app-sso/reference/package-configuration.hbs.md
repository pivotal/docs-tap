# Package configuration

Most commonly, the AppSSO package installation is configured through TAP's meta
package installation. The TAP package has a `shared` top-level configuration
key for sharing common configuration between the packages it installs.

AppSSO inherits the `shared.{ingress_domain, ingress_issuer, ca_cert_data,
kubernetes_distribution}` configuration values from Tanzu Application Platform.
You can configure the AppSSO-specific parameters under `appsso`.
AppSSO-specific configuration has precedence over the shared values of Tanzu
Application Platform.

For example:

```yaml
#! my-tap-values.yaml

shared:
# Shared configuration goes here.

appsso:
# AppSSO-specific configuration goes here.
```

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
