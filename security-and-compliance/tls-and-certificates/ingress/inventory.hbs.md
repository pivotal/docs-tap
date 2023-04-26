# Ingress certificates inventory

The effective number of ingress endpoints can vary widely, depending on the
installation profile, excluded packages and end-user facing resources, for example,
`Workload`, and `AuthServer`. As a result, the number of TLS certificates is not
fixed but a function of the platform's configuration and tenancy.

Tanzu Application Platform's components can be categorized into those which don't have ingress
endpoints and those which do. The latter further break down into those which
have a fixed number of ingress endpoints and those which offer Kubernetes APIs
with ingress.

>**Note** The lowercase "ingress" refers to any resource which facilitates
>ingress, for example, core `Ingress` and Contour's `HTTPProxy`.

Use the following table component's respective ingress
to help with planning and accounting of TLS certificates:

Package name | Profiles | Has ingress | Ingress purpose | Supports ingress issuer | Supports wildcards | # of ingress | SANs | TLS Documentation
---|---|---|---|---|---|---|---|---|
accelerator.apps.tanzu.vmware.com | full, light, view | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
api-portal.tanzu.vmware.com | full, view | ✅ | Serves the API portal | |  | `1` | `api-portal.<ingress-domain>` (configurable) | [docs](../../../api-portal/about.hbs.md)
apis.apps.tanzu.vmware.com | iterate, run, full | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
apiserver.appliveview.tanzu.vmware.com | full, light, iterate, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
app-scanning.apps.tanzu.vmware.com  | n/a | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
application-configuration-service.tanzu.vmware.com | n/a | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
backend.appliveview.tanzu.vmware.com | full, light, view | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
bitnami.services.tanzu.vmware.com | full, iterate, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
buildservice.tanzu.vmware.com | full, light, iterate, build, buildservice | ❌  | n/a | n/a | n/a | n/a | n/a | n/a |
carbonblack.scanning.apps.tanzu.vmware.com | ❌ | n/a |n/a |n/a |n/a | n/a | n/a |n /a |
cartographer.tanzu.vmware.com | full, light, iterate, build, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
cert-manager.tanzu.vmware.com | full, light, iterate, build, run, view | ❌ | n/a | n/a | n/a | n/a | n/a |n/a |
cnrs.tanzu.vmware.com | full, light, iterate, run | ✅ | Instances of Knative's `Service` have ingress | ✅ | ✅ | `# of Services` | SANs depend on the component's `domain_template` (configurable) | [docs](../../../cloud-native-runtimes/about.hbs.md)
connector.appliveview.tanzu.vmware.com | full, light, iterate, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
contour.tanzu.vmware.com | full, light, iterate, build, run, view | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
controller.source.apps.tanzu.vmware.com | full, light, iterate, build, run, view | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
conventions.appliveview.tanzu.vmware.com | full, light, iterate, build | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
crossplane.tanzu.vmware.com | full, iterate, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
developer-conventions.tanzu.vmware.com | full, light, iterate | ❌ | n/a|n/a |n/a |n/a |n/a |n/a |
eventing.tanzu.vmware.com | full, light, iterate, run | ❌ |n/a |n/a |n/a |n/a |n/a |n/a |
external-secrets.apps.tanzu.vmware.com | | ❌ |n/a |n/a |n/a |n/a |n/a |n/a |
fluxcd.source.controller.tanzu.vmware.com | full, light, iterate, build, run, view | ❌ |n/a |n/a |n/a |n/a |n/a |n/a |
grype.scanning.apps.tanzu.vmware.com | full, build | ❌ |n/a |n/a |n/a |n/a |n/a |n/a |
learningcenter.tanzu.vmware.com | full, view | ✅ | Instances [TrainingPortal](../../../learning-center/runtime-environment/training-portal.hbs.md) have ingress | | ✅ (**only** supports wildcards) | `# of TrainingPortal` | `<training-portal>.learningcenter.<ingress-domain>` (configurable) | [docs](../../../learning-center/install-learning-center.hbs.md) |
metadata-store.apps.tanzu.vmware.com | full, view | ✅ | Serves the Supply Chain Security Tools store | ✅ | ✅ | `1` | `metadata-store.<ingress-domain>` (configurable) | [docs](../../../scst-store/tls-configuration.hbs.md)
namespace-provisioner.apps.tanzu.vmware.com | full, light, iterate, build, run | ❌ |n/a |n/a |n/a |n/a |n/a |n/a |
ootb-delivery-basic.tanzu.vmware.com | full, light, iterate, run | ❌ |n/a |n/a |n/a |n/a |n/a |n/a |
ootb-supply-chain-basic.tanzu.vmware.com | full, light, iterate, run | ❌ |n/a |n/a |n/a |n/a |n/a |n/a |
ootb-supply-chain-testing-scanning.tanzu.vmware.com | full, light, iterate, run | ❌ |n/a |n/a |n/a |n/a |n/a |n/a |
ootb-supply-chain-testing.tanzu.vmware.com | full, light, iterate, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
ootb-templates.tanzu.vmware.com | full, light, iterate, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
policy.apps.tanzu.vmware.com | full, iterate, run | ❌ |  n/a| n/a| n/a | n/a | n/a | n/a |
scanning.apps.tanzu.vmware.com | full, build | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
service-bindings.labs.vmware.com | full, light, iterate, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
services-toolkit.tanzu.vmware.com | full, light, iterate, run | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
snyk.scanning.apps.tanzu.vmware.com | ❌ | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
spring-boot-conventions.tanzu.vmware.com | full, light, iterate, build | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
spring-cloud-gateway.tanzu.vmware.com | | ✅ | Instances of [SpringCloudGateway](../../../spring-cloud-gateway/about.hbs.md) have ingress | | ✅ | `# of SpringCloudGateway` | configurable | [docs](../../../spring-cloud-gateway/about.hbs.md) |
sso.apps.tanzu.vmware.com | iterate, run, full | ✅ | Instances of [AuthServer](../../../app-sso/service-operators/index.hbs.md) have ingress | ✅ | ✅ | `# of AuthServer` | SANs depend on the component's `domain_template` | [docs](../../../app-sso/service-operators/issuer-uri-and-tls.hbs.md)
tap-auth.tanzu.vmware.com | full, light, iterate, build, run | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
tap-gui.tanzu.vmware.com | full, light, view | ✅ | Serves the platform-internal developer and service portal | ✅ | ✅ | `1` | `tap-gui.<ingress-domain>` (configurable) | [docs](../../../tap-gui/tls/overview.hbs.md)
tap-telemetry.tanzu.vmware.com | full, light, iterate, build, run, view, buildservice | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
tekton.tanzu.vmware.com | full, light, iterate, build | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
workshops.learningcenter.tanzu.vmware.com | full, view | ❌ | n/a | n/a | n/a | n/a | n/a | n/a |
