# Securing your web workloads in Cloud Native Runtimes

This topic give you an overview of securing HTTP connections using TLS
certificates in Cloud Native Runtimes, commonly known as CNR, for VMware Tanzu Application Platform and
helps you configure TLS (Transport Layer Security).

## <a id="prereqs"></a> Prerequisites

Ensure that you have the Tanzu Application Platform, Cloud Native Runtimes for VMware Tanzu, Contour, and
cert-manager installed.

## <a id="overview"></a> Overview of Cloud Native Runtimes TLS configurations

This section describes default configuration, custom configuration, obtaining, and renewing TLS certificates with Cloud Native Runtimes.

### <a id="default-config"></a> Default TLS configuration in Cloud Native Runtimes

When installing Tanzu Application Platform by using [profiles](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/about-package-profiles.html#installation-profiles-in-tanzu-application-platform-v16-1),
the [cert-manager package](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/cert-manager-about.html)
is utilized to facilitate the acquisition, management, and renewal of TLS certificates.

Cloud Native Runtimes automatically acquire TLS certificates for workloads through the shared ingress issuer
integrated into the Tanzu Application Platform.
The `shared.ingress_issuer` configuration value
in Tanzu Application Platform specifies the ingress issuer and it refers to a `cert-manager.io/v1/ClusterIssuer`.

By default, the ingress issuer is self-signed and has limits. For more information about
the shared ingress issuer, see the following Tanzu Application Platform documentation:

- [Ingress certificates](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/security-and-compliance-tls-and-certificates-ingress-about.html)
- [Shared ingress issuer](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/security-and-compliance-tls-and-certificates-ingress-issuer.html)

The following TLS features are in Cloud Native Runtimes by default:

- **Auto-TLS**

  Cloud Native Runtimes has the Auto-TLS feature enabled by default. It uses the cert-manager package to automate the process
  of certificate issuance and management. Auto-TLS takes care of requesting, renewing, and configuring TLS certificates
  for each domain that you configure in your Cloud Native Runtimes settings.

- **Automatic HTTPS Redirection**

  By default, Cloud Native Runtimes automatically redirects HTTP traffic to HTTPS for secured services.
  This ensures that all communication with your applications is encrypted and providing a secure experience for your users.

- **One certificate per hostname**

  Cloud Native Runtimes issues a unique certificate for each host name associated with a Knative Service.

### <a id="custom-config"></a> Custom TLS configuration in Cloud Native Runtimes

While the default ingress issuer is suitable for testing and evaluation purposes, VMware recommends replacing it
with your own issuer for production environments.

There are a few ways to customize TLS configuration in Cloud Native Runtimes:

#### <a id="replace-shared-issuer"></a> Replace the shared ingress issuer at the Tanzu Application Platform’s level

You have the flexibility to replace Tanzu Application Platform's default ingress issuer with any other `certificate authority`
that is [compliant with cert-manager ClusterIssuer](https://cert-manager.io/docs/configuration/). For information about how to replace the default ingress issuer, see
[Replacing the default ingress issuer](../../../security-and-compliance/tls-and-certificates/ingress/issuer.hbs.md).

Cloud Native Runtimes uses the issuer specified by `shared.ingress_issuer` configuration value to issue certificates
for your workload automatically.

#### <a id="custom-issuer"></a> Designate another ingress issuer for your workloads in Cloud Native Runtimes only

You can have a shared ingress issuer at the Tanzu Application Platform’s level and designate another issuer 
used by Cloud Native Runtimes to issue TLS certificates for your workloads. This allows you to customize TLS settings for
Cloud Native Runtimes while maintaining a global configuration for other components.

You can designate an ingress issuer for Cloud Native Runtimes by specifying `cnrs.ingress_issuer` configuration value.
The ingress/TLS configuration for Cloud Native Runtimes takes precedence over the shared ingress issuer.

For information about designating another ingress issuer for your workloads, see [Configure Cloud Native Runtimes to use a custom Issuer or ClusterIssuer](./tls-guides-letsencrypt-http01.hbs.md) for details.

#### <a id="replace-shared-issuer"></a> Provide an existing TLS certificate for your workloads in Cloud Native Runtimes

If you manually generated a TLS certificate and want to provide it to Cloud Native Runtimes instead of using an ingress issuer, 
you can follow the instructions in [Use your existing TLS Certificate for Cloud Native Runtimes](../knative-default-tls.hbs.md).

### <a id="more-custom-tls"></a> Resources on custom TLS configuration for Cloud Native Runtimes

The following resources are helipful for custom TLS configuration for Cloud Native Runtimes:

- [Configure Cloud Native Runtimes to use a custom Issuer or ClusterIssuer](./tls-guides-letsencrypt-http01.hbs.md)
- [Use wildcard certificates with Cloud Native Runtimes](./tls-guides-wildcard-cert.hbs.md)
- [Use your existing TLS Certificate for Cloud Native Runtimes](../knative-default-tls.hbs.md)
- [Deactivate HTTP-to-HTTPS redirection](./tls-guides-deactivate-redirection.hbs.md)
- [Opt out from any ingress issuer and deactivate automatic TLS feature](./tls-guides-deactivate-autotls.hbs.md)
