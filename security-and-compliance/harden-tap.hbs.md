# Harden Tanzu Application Platform

This topic provides you with installation and configuration guidance for Tanzu Application Platform
(commonly known as TAP) to meet the NIST 800-53
Security and Privacy Controls for Information Systems and Organizations.

## Objective

This is not a comprehensive security guide, but rather, an abbreviated Tanzu Application Platform readiness outline with considerations for hardening Tanzu Application Platform with [800-53](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf) controls as a guide.

Configuring your Tanzu Application Platform installation to this standard does not guarantee approval given there are
multiple organizational requirements and deviations that a platform team may make during
installation and configuration.

## Scope

The document will focus on the hardening on the Tanzu Application Platform.  This platform is
deployed to Kubernetes and as such, relies on the Kubernetes platform being hardened in a shared
responsibility model with the Tanzu Application Platform.  This guide will provide instruction on
Kubernetes based hardening configurations that are required for the Tanzu Application Platform,
however, it should not be viewed as a hardening guide for Kubernetes as well.

For hardening Kubernetes, refer to Kubernetes specific hardening guides such as:

- [NSA/CISA Kubernetes Hardening Guide](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF):
  Published in Aug 2022, this is a prescriptive document that covers many areas related to
  Kubernetes security.
- [NIST Kubernetes STIG Checklist](https://ncp.nist.gov/checklist/996): Published in April 2021,
  provides a prescriptive a list of technical requirements for securing a basic Kubernetes platform.
- [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes/): Widely used as a
  secure configuration guide, last updated in June 2021.

## Identity and Access Management

In order to provide an audit trail of what a user does in a system, it is important to configure the
Tanzu Application Platform so that the identity for a given user is known. When installing and
configuring the Tanzu Application Platform, there are several areas where user identity
configuration should be considered. Currently the Tanzu Application Platform has three different
areas where users have identities.

1. Tanzu Developer Portal (formerly named Tanzu Application Platform GUI)
2. Tanzu Developer Portal Authentication to Remote Clusters
3. The Kubernetes cluster that the Tanzu Application Platform components are installed on

It is recommended to use the same identity provider for each of these components so that a common
identity is shared across the entire Tanzu Application Platform. To facilitate this, components are
able to use common OIDC providers.  Below is the configuration for each component:

### Tanzu Developer Portal

The Tanzu Developer Portal is based on the Backstage open source project and has a variety
of OIDC providers that you are able to configure as an identity provider.

In order to configure authentication for the Tanzu Developer Portal, VMware suggests the
following:

1. Enable user authentication using one of the
   [supported providers](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/tap-gui-auth.html).
   Note that due to the limitations with the backstage authentication implementation, simply having
   authentication does [not guarantee full end-to-end security](https://backstage.io/docs/auth/#sign-in-configuration)
   as Backstage doesn’t currently support per-API authentication.
   VMware recommends implementing additional security either via an inbound proxy or via networking
   (firewall / VPN).
2. It is recommended to disable guest access via the tap_gui section in the tap-values.yaml.

   ```yaml
   tap_gui:
     app_config:
       auth:
         allowGuestAccess: false
   ```

### Tanzu Developer Portal to Remote Kubernetes Cluster Authentication

Several plugins within the Tanzu Developer Portal, such as the Runtime Resource Viewer,
Supply Chain Visualization, and Security Analysis GUI require authentication to remote Kubernetes
clusters to query Kubernetes resources.

To do so, the plugins must authenticate to the Kubernetes API on remote clusters.
This authentication can be configured in two ways: a shared Kubernetes service account that all users
will use to authenticate to remote clusters, and by setting up an authentication provider for the
remote cluster.  As best security practice, VMware recommends setting up a remote authentication
provider for the Kubernetes cluster.

For more information, see
[Update Tanzu Developer Portal to view resources on multiple clusters](../tap-gui/cluster-view-setup.hbs.md#update-tap-gui).

As best practice, the users on the Kubernetes clusters that are used for remote authentication
should be assigned to Kubernetes roles that limit access in a least privilege model.  More
information about Kubernetes roles provider out of box can be found in the next section.

### Kubernetes Cluster Authentication and Authorization

Although not a Tanzu Application Platform configuration, VMware recommends enabling authentication
to the Kubernetes clusters where the Tanzu Application Platform components are installed, using the
same identity provider that other components are using.

While there are many options on how to enable OIDC providers for authentication with the Kubernetes
API, VMware supports the [Pinniped project](https://pinniped.dev/) and has
[documented](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/authn-authz-integrating-identity.html)
the process of setting it up as part of the Tanzu Application Platform documentation.

By configuring this to use the same identify provider as the Tanzu Developer Portal, users
can have a common identity across the Kubernetes clusters and the Tanzu Developer Portal.
Because the Tanzu CLI is making Kubernetes API calls, this configuration will also be enabled for
the Tanzu CLI.

Using Pinniped will provide authentication for Kubernetes clusters but still requires the users to
be bound to Kubernetes roles.  To provide a starting point, the Tanzu Application Platform provides
six Kubernetes Roles as part of the installation that users can be bound to.  For more information
around the roles used for authorization, refer to the
[authentication and authorization documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/authn-authz-overview.html).

## Cryptographic Protections

Encryption of data is leveraged to prevent unauthorized access to data.  With the Tanzu Application
Platform, this protection focuses on the two primary states of data that should be encrypted:

1. Encryption of Data in Transit
2. Encryption of Data at Rest

### Encryption of Data in Transit

#### Internal Communication of Data in Transit Configuration

Communication between services that originate and terminate within the cluster is referred to as
internal communication. Tanzu Application Platform is in the process of enabling TLS on
internal communication for components.

If you require encrypted internal communication, there are three
remediating options:

1. Enable Tanzu Service Mesh, which provides mutual TLS between
components. For more information, see [Set up Tanzu Service Mesh](../integrations/tsm-tap-integration.hbs.md).
2. Configure Kubernetes to encrypt all communication with a Container Networking Interface (CNI)
that supports traffic encryption, for example, [Antrea](https://github.com/antrea-io/antrea/blob/main/docs/traffic-encryption.md).
3. Use the underlying network infrastructure running Kubernetes which has encryption on all network traffic.

#### External Communication of Data in Transit Configuration

Based upon OSS doc:
[https://projectcontour.io/docs/v1.22.1/configuration/#tls-configuration](https://projectcontour.io/docs/v1.22.1/configuration/#tls-configuration)

TLS enables encryption of communication from end-users to the cluster. Since Contour is the edge
gateway for all the traffic ingressing into the cluster, it is an easy spot to set up TLS and ensure
that all communications between users and the cluster are encrypted.

It also allows cluster owners to satisfy compliance requirements like NIST 800-53 Control
[SC-8](https://csf.tools/reference/nist-sp-800-53/r4/sc/sc-8/) where it is required to protect the
confidentiality of transmitted information.

Moreover, it may be required that certain cipher suites and/or TLS versions are used when encrypting
communications.[NIST 800-52r2](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-52r2.pdf)
requires all government-only applications shall use TLS 1.2 and should be configured to use TLS 1.3
as well.

##### Configuring TLS for Contour

In order to configure Contour to use TLS according to the NIST 800-52r2 requirements you need to
create a new section in your `tap-values.yaml` file like:

```yaml
...
contour:
  * existing stuff, probably already there if you're following tap docs
  envoy:
    service:
      type: LoadBalancer # This is set by default, but can be overridden by setting a different value.
  * new stuff
  contour:
    configFileContents:
      tls:
        minimum-protocol-version: "1.2"
        cipher-suites:
        - '[ECDHE-ECDSA-AES128-GCM-SHA256|ECDHE-ECDSA-CHACHA20-POLY1305]'
        - '[ECDHE-RSA-AES128-GCM-SHA256|ECDHE-RSA-CHACHA20-POLY1305]'
        - 'ECDHE-ECDSA-AES256-GCM-SHA384'
        - 'ECDHE-RSA-AES256-GCM-SHA384'
```

After adding this section, apply the tap-values file and that will change the configuration of TLS
to match the requirements.

For more settings in the Contour component, you can reference the
[open source documentation](https://projectcontour.io/docs/v1.22.1/configuration/#tls-configuration).

#### Ingress Certificates

For information about to configure TLS for a Tanzu Application Platform installation's ingress
endpoints, see [Ingress certificates](./tls-and-certificates/ingress/about.hbs.md).

### Encryption of Data At Rest

All data should be encrypted at rest. The Tanzu Application Platform runs on Kubernetes
and verifies the default storage class configured on the Kubernetes
cluster. If you require Encryption of Data at Rest (DARE), you must provide a Persistent Volume Provisioner that supports encryption to the Kubernetes infrastructure.

- Persistent Volume claim encryption
- Data at rest should be encrypted.

### Ports and Protocols

Ports are used in TCP and UDP protocols for identification of applications. While some applications
use common port numbers, such as 80 for HTTP, or 443 for HTTPS, some applications use dynamic
ports. An *open port* refers to a port on which a system is accepting communication. An open port does
not always mean that there is a security issue, but it can provide a pathway
for attackers listening on that port. To help understand the traffic flows
in Tanzu Application Platform, VMware provides a list of Tanzu Application Platform ports and protocols on request.

See the [TAP Architecture Overview](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap-reference-architecture/GUID-reference-designs-tap-architecture-planning.html).

## Networking

Ensure that workloads only expose internal-only routes.

All traffic should go through Contour and LoadBalancer without utilizing NodePort [services](https://kubernetes.io/docs/concepts/services-networking/service/).

Tanzu Application Platform is supported by [Tanzu Service Mesh](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/integrations-tsm-tap-integration.html).

You must configure proper [affinity rules](https://knative.dev/docs/serving/configuration/feature-flags/#kubernetes-node-affinity) on Knative deployed services.
For more information, see [Install Tanzu Application Platform in an air-gapped environment](../install-offline/profile.hbs.md).

## Key Management

Key management is the foundation of all data security. Data is encrypted and decrypted with encryption keys or secrets that must be safely stored to prevent the loss or compromise of infrastructure, systems, and applications. Tanzu Application Platform values are secrets and must be protected to ensure that the security and integrity of the platform is maintained.

- Tanzu Application Platform stores all sensitive values as [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- Encryption of secrets at rest are Kubernetes Distribution Dependent.
- If customers desire to store secrets in a Secret Management service (e.g. [Hashicorp Vault](https://www.vaultproject.io),
  [Google Secrets Manager](https://cloud.google.com/secret-manager), [Amazon Secrets Manager](https://aws.amazon.com/secrets-manager/),
  [Microsoft Azure Key Vault](https://azure.microsoft.com/en-us/products/key-vault/)) they can make
  use of the [External Secrets Operator](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/external-secrets-about-external-secrets-operator.html)
  to automate the lifecycle management (ALPHA).
- 800-53 [Section AC-23](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf)
  related to safeguarding of sensitive information from exploitation, for example, Tanzu Application Platform values.

## Logging

Log files provide an audit trail to monitor activity within infrastructure. Use log files to identify policy violations, unusual activity, and security incidents. It is vital that logs are captured and retained according to the policies set forth by your organization's security team or governing body. Tanzu Application Platform components run as pods on the Kubernetes infrastructure and all components output is captured as part of the pod logs.

All Tanzu Application Platform components follow
[Kubernetes Logging](https://kubernetes.io/docs/concepts/cluster-administration/logging/) best practices.
Log aggregation should be implemented following the best practices of the organization log retention
process.

- 800-53 Section [AU-4 Audit Log Storage Capacity](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf)

## Deployment Architecture

Tanzu Application Platform provides a
[reference architecture](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap-reference-architecture/GUID-reference-designs-tap-architecture-planning.html) that depicts separate components based on function. VMware recommends multiple Kubernetes clusters for the iterate, build, view, and run
functions. This separation enables Kubernetes administrators to manage each function independently
and therefore, protect the availability and performance of the platform during high usage periods,
for example, building or scanning.
