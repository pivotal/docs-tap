# Plan ingress certificates inventory in Tanzu Application Platform

This topic tells you how to plan for TLS certificates in Tanzu Application Platform (commonly known as TAP).

The effective number of ingress endpoints can vary widely, depending on the
installation profile, excluded packages, and end-user-facing resources such as
`Workload`, and `AuthServer`. As a result, the number of TLS certificates is not
fixed but is a function of the platform's configuration and tenancy.

Ingress refers to any resource which facilitates
ingress, for example, core `Ingress` and Contour's `HTTPProxy`.

## <a id="wildcards"></a>Wildcards

You can use wildcard certificates but Tanzu Application Platform does not offer support.
Wildcard certificates require component-level configuration.

You can use a mixed approach for configuring TLS for components.
For example, use a shared ingress issuer, but override TLS configuration for select
components while using wildcard certificates for some.

When using wildcard certificates the approach differs between
components that have a fixed set of ingress endpoints and those that have
a variable set of ingress endpoints:

Components with ingress endpoints can have a
a fixed or variable number of ingress endpoints:

    - Components with a fixed set of ingress endpoints can receive a reference to
      the wildcard certificate's `Secret` and an ingress domain, for example, Tanzu Developer Portal.

    - Components with a variable set of ingress endpoints usually offer Kubernetes
      APIs that create ingress resources. These components allow
      configuration of domain templating so that wildcard certificates can be used,
      for example, Cloud Native Runtimes and Application Single Sign-On.

## Ingress support for components

Use the following table to help with the planning and accounting of TLS certificates.
For a full list of
components and the profiles supported for each component, see
[About Tanzu Application Platform components and profiles](../../../about-package-profiles.hbs.md#profiles-and-packages).

Package name | Ingress purpose | Supports ingress issuer | Supports wildcards | Number of ingress | SANs*|
---|---|---|---|---|---|
[api-portal.tanzu.vmware.com](../../../api-portal/about.hbs.md) | Serves the API portal | No | Yes | `1` | `api-portal.INGRESS-DOMAIN` |
[cnrs.tanzu.vmware.com](../../../cloud-native-runtimes/about.hbs.md) | Instances of Knative's `Service` have ingress | Yes | Yes | `Number of Services` | SANs depend on the component's `domain_template` |
[metadata-store.apps.tanzu.vmware.com](../../../scst-store/tls-configuration.hbs.md) | Serves the Supply Chain Security Tools store | Yes | Yes | `1` | `metadata-store.INGRESS-DOMAIN`  |
[spring-cloud-gateway.tanzu.vmware.com](../../../spring-cloud-gateway/about.hbs.md) |Instances of [SpringCloudGateway](../../../spring-cloud-gateway/about.hbs.md) have ingress | No | Yes | `Number of SpringCloudGateways` | See [Using an Ingress Resource](https://docs.vmware.com/en/VMware-Spring-Cloud-Gateway-for-Kubernetes/2.1/scg-k8s/GUID-guides-external-access.html) in the Spring Cloud Gateway documentation|
[sso.apps.tanzu.vmware.com](../../../app-sso/how-to-guides/service-operators/issuer-uri-and-tls.hbs.md) |Instances of [AuthServer](../../../app-sso/how-to-guides/service-operators/index.hbs.md) have ingress | Yes | Yes | `Number of AuthServers` | Depends on the component's `domain_template` |
[tap-gui.tanzu.vmware.com](../../../tap-gui/tls/overview.hbs.md) | Serves the platform-internal developer and service portal | Yes | Yes | `1` | `tap-gui.INGRESS-DOMAIN` |

*The SANs is configurable for components in the following two ways:

- Components that install a single ingress resource in the form of `COMPONENT.DOMAIN-NAME`, such as Tanzu Developer Portal
- Components that install an ingress resource per API instance that gets templated from a
  `domain_template` feeding `DOMAIN-NAME`, such as `cnrs.tanzu.vmware.com` and
  `sso.apps.tanzu.vmware.com`
