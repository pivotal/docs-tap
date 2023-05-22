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

Use the following table to help with planning and accounting of TLS certificates. For a full list of
components and the profiles supported for each component, see
[About Tanzu Application Platform components and profiles](../../../about-package-profiles.hbs.md#profiles-and-packages).

Package name | Ingress purpose | Supports ingress issuer | Supports wildcards | # of ingress | SANs*|
---|---|---|---|---|---|
[api-portal.tanzu.vmware.com](../../../api-portal/about.hbs.md) | Serves the API portal | ❌ | ❌ | `1` | `api-portal.<ingress-domain>` |
[cnrs.tanzu.vmware.com](../../../cloud-native-runtimes/about.hbs.md) | Instances of Knative's `Service` have ingress | ✅ | ✅ | `# of Services` | SANs depend on the component's `domain_template` |
[learningcenter.tanzu.vmware.com](../../../learning-center/install-learning-center.hbs.md) | Instances of [TrainingPortal](../../../learning-center/runtime-environment/training-portal.hbs.md) have ingress | ❌| ✅** | `# of TrainingPortal` | `<training-portal>.learningcenter.<ingress-domain>` |
[metadata-store.apps.tanzu.vmware.com](../../../scst-store/tls-configuration.hbs.md) | Serves the Supply Chain Security Tools store | ✅ | ✅ | `1` | `metadata-store.<ingress-domain>`  |
[spring-cloud-gateway.tanzu.vmware.com](../../../spring-cloud-gateway/about.hbs.md) |Instances of [SpringCloudGateway](../../../spring-cloud-gateway/about.hbs.md) have ingress | ❌ | ✅ | `# of SpringCloudGateway` | See [Using an Ingress Resource](https://docs.vmware.com/en/VMware-Spring-Cloud-Gateway-for-Kubernetes/2.0/scg-k8s/GUID-guides-external-access.html) in the Spring Cloud Gateway documentation|
[sso.apps.tanzu.vmware.com](../../../app-sso/service-operators/issuer-uri-and-tls.hbs.md) |Instances of [AuthServer](../../../app-sso/service-operators/index.hbs.md) have ingress | ✅ | ✅ | `# of AuthServer` | Depend on the component's `domain_template` |
[tap-gui.tanzu.vmware.com](../../../tap-gui/tls/overview.hbs.md) | Serves the platform-internal developer and service portal | ✅ | ✅ | `1` | `tap-gui.<ingress-domain>` |

*The SANs is configurable for components in the following two ways:

- components which install a single ingress resource in the form of <component>.<domain_name>, for example, TAP GUI
- components which install an ingress resource per API instance which gets templated from a `domain_template` feeding <domain_name>, for example `cnrs.tanzu.vmware.com` and `sso.apps.tanzu.vmware.com`

** Only supports wildcards
