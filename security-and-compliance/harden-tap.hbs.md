# Harden Tanzu Application Platform

This topic provides you with VMware recommendations on how to install and configure Tanzu Application Platform (commonly known as TAP) so that it to complies with [NIST Publication 800-53](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf).

Configuring your Tanzu Application Platform installation to this standard does not ensure approval as there are multiple organizational requirements and deviations that a platform team can make during installation and configuration.

Tanzu Application Platform is deployed on Kubernetes and relies on the Kubernetes platform being hardened in a shared responsibility model. For information about hardening Kubernetes, see:

- [NSA/CISA Cybersecurity Technical Report](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF)
- [NIST Kubernetes STIG Checklist](https://ncp.nist.gov/checklist/996)
- [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes/)

## <a id="iam"></a> Identity and access management

To provide an audit trail of what a user does in a system, it is important to configure Tanzu Application Platform so that the identity of a user is known. When installing and
configuring Tanzu Application Platform, there are several areas where user identity
configuration must be considered. Tanzu Application Platform has three different
areas where users have identities.

1. Tanzu Developer Portal
2. Tanzu Developer Portal authentication to remote clusters
3. The Kubernetes cluster where Tanzu Application Platform components are installed

VMware recommends using the same identity provider for each of these so that a common
identity is shared across Tanzu Application Platform. To facilitate this, components can
use common OIDC providers.

### <a id="tdp"></a> Tanzu Developer Portal

Tanzu Developer Portal is based on the Backstage open source project and has a variety
of OIDC providers that you can configure as an identity provider.

To configure authentication for the Tanzu Developer Portal, VMware recommends the
following:

1. Enable user authentication using one of the supported providers. For more information, see [Set up authentication for Tanzu Developer Portal](../tap-gui/auth.hbs.md).

  >**Note** Due to the limitations of the Backstage authentication implementation, enabling
  authentication does not ensure full end-to-end security as Backstage doesn’t currently support per-API authentication. VMware recommends implementing additional security either using an inbound proxy or by leveraging networking using a firewall or VPN. For more information, see [Authentication in Backstage](https://backstage.io/docs/auth/#sign-in-configuration).
1. Disable guest access in the `tap_gui` section in the `tap-values.yaml` file:

   ```yaml
   tap_gui:
     app_config:
       auth:
         allowGuestAccess: false
   ```

### <a id="tdp-remote-cluster"></a> Tanzu Developer Portal authentication to remote clusters

Several plug-ins within the Tanzu Developer Portal, such as the Runtime Resource Viewer,
Supply Chain Visualization, and Security Analysis GUI require authentication to remote Kubernetes
clusters to query Kubernetes resources.

To do so, the plug-ins must authenticate to the Kubernetes API on remote clusters.
Configure authentication in two ways: a shared Kubernetes service account that all users
use to authenticate to remote clusters, and by setting up an authentication provider for the
remote cluster.  As best security practice, VMware recommends setting up a remote authentication
provider for the Kubernetes cluster.

For more information, see
[Update Tanzu Developer Portal to view resources on multiple clusters](../tap-gui/cluster-view-setup.hbs.md#update-tap-gui).

As best practice, the users on the Kubernetes clusters that are used for remote authentication
must be assigned to Kubernetes roles that limit access in a least privilege model.

### <a id="cluster-auth"></a> The Kubernetes cluster

VMware recommends enabling authentication
to the Kubernetes clusters where the Tanzu Application Platform components are installed, using the same identity provider that other components are using.

While there are many options on how to enable OIDC providers for authentication with the Kubernetes
API, VMware supports the [Pinniped project](https://pinniped.dev/). For information on using Pinniped in Tanzu Application Platform, see
[Set up authentication for your Tanzu Application Platform deployment](../authn-authz/integrating-identity.hbs.md) and [Install Pinniped on Tanzu Application Platform](../authn-authz/pinniped-install-guide.hbs.md).

By configuring this to use the same identify provider as the Tanzu Developer Portal, users
can have a common identity across the Kubernetes clusters and the Tanzu Developer Portal.
Because the Tanzu CLI is making Kubernetes API calls, this configuration is also enabled for
the Tanzu CLI.

Using Pinniped provides authentication for Kubernetes clusters but still requires the users to
be bound to Kubernetes roles.  To provide a starting point, the Tanzu Application Platform provides
six Kubernetes Roles as part of the installation that users can be bound to. For more information
about the roles used for authorization, see
[Default roles for Tanzu Application Platform](../authn-authz/overview.hbs.md).

#### <a id="amr"></a> Artifact Metadata Repository (AMR) Observer, CloudEvent Handler, and GraphQL

AMR Observer deploys on Full, Build and Run Tanzu Application Platform profiles.

AMR CloudEvent Handler and GraphQL deploy on Full and View Tanzu Application Platform profiles.

AMR Observer, AMR CloudEvent Handler, and GraphQL create Kubernetes service accounts, cluster roles,
cluster role bindings, and secrets required for communication between these components internally and
externally between Kubernetes clusters.
For more information, see [Kubernetes service account automatic configuration](../scst-store/amr/auth-k8s-sa-autoconfiguration.hbs.md).

Deactivate the automatic configuration for each of these components for the
respective profiles and manually create them as known resources.

To deactivate AMR Observer automatic configuration, update the `tap-values.yaml` as follows:

```yaml
amr:
  observer:
    auth:
      kubernetes_service_accounts:
        autoconfigure: false
```

To deactivate AMR CloudEvent Handler and GraphQL automatic configuration, update the `tap-values.yaml`
as follows:

```yaml
amr:
  cloudevent_handler:
    auth:
      kubernetes_service_accounts:
        autoconfigure: false

  graphql:
    auth:
      kubernetes_service_accounts:
        autoconfigure: false
```

For best practice, users on the Kubernetes clusters must create resources with Kubernetes roles
that limit access in a least privilege model.
For more information, see [User-defined Kubernetes Service Account Configuration](../scst-store/amr/auth-k8s-sa-user-defined.hbs.md).

## <a id="protection"></a> Encryption

Encryption of data prevents unauthorized access to data. In Tanzu Application
Platform, there are two states where data should be encrypted:

1. Encryption of data in transit
2. Encryption of data at rest

### <a id="encryption-in-transit"></a> Encryption of data in transit

This section describes how to encryption of internal communication between services that originate
within the cluster and data at rest, and how to secure exposed ingress endpoints.

#### <a id="internal-comms"></a> Internal Communication of data in transit configuration

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

#### <a id="external-comms"></a> External communication of data in transit configuration

TLS enables encryption of communication from end-users to the cluster. Because Contour is the edge
gateway for all the traffic ingressing into the cluster, it is suitable to set up TLS and ensure
that all communications between users and the cluster are encrypted.

It also allows cluster owners to satisfy compliance requirements such as
[NIST 800-53 ControlSC-8](https://csf.tools/reference/nist-sp-800-53/r4/sc/sc-8/) to protect the
confidentiality of transmitted information.

It might be required that certain cipher suites or TLS versions are used when encrypting
communications. [NIST 800-53](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf)
requires that all government-only applications use TLS v1.2 and they also must be configured to use
TLS v1.3.

##### <a id="config-tls"></a> Configuring TLS for Contour

To configure Contour to use TLS, create a new section in `tap-values.yaml`:

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

After adding this section, apply the `tap-values.yaml` file that will change the configuration of
TLS to match the requirements.

For more information, see [TLS Configuration](https://projectcontour.io/docs/v1.22.1/configuration/#tls-configuration) in the Contour documentation.

#### <a id="ingress-certs"></a> Ingress Certificates

For information about how to configure TLS for a Tanzu Application Platform installation's ingress
endpoints, see [Secure exposed ingress endpoints in Tanzu Application Platform](./issuer.hbs.md).

### <a id="encryption-at-rest"></a> Encryption of Data At Rest

All data must be encrypted at rest. The Tanzu Application Platform runs on Kubernetes
and verifies the default storage class configured on the Kubernetes
cluster. If you require Encryption of Data at Rest (DARE), you must provide a PersistentVolume
Provisioner that supports encryption to the Kubernetes infrastructure.

## <a id="ports-protocols"></a> Ports and protocols

Ports are used in TCP and UDP protocols for identification of applications. While some applications
use common port numbers, such as 80 for HTTP, or 443 for HTTPS, some applications use dynamic
ports. An open port refers to a port on which a system is accepting communication. An open port does
not always mean that there is a security issue, but it can provide a pathway
for attackers listening on that port. To help understand the traffic flows
in Tanzu Application Platform, VMware provides a list of Tanzu Application Platform ports and
protocols on request. For more information, see the [TAP Architecture Overview](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap-reference-architecture/GUID-reference-designs-tap-architecture-planning.html).

## <a id="networking"></a> Networking

Ensure that workloads only expose internal-only routes.

All traffic must go through Contour and LoadBalancer without using NodePort [services](https://kubernetes.io/docs/concepts/services-networking/service/).

Tanzu Application Platform is supported by [Tanzu Service Mesh](../integrations/tsm-tap-integration.hbs.md).

You must configure proper [affinity rules](https://knative.dev/docs/serving/configuration/feature-flags/#kubernetes-node-affinity) on Knative deployed services.
For more information, see [Install Tanzu Application Platform in an air-gapped environment](../install-offline/profile.hbs.md).

## <a id="key-management"></a> Key management

Key management is the foundation of all data security. Data is encrypted and decrypted with
encryption keys or secrets that must be safely stored to prevent the loss or compromise of
infrastructure, systems, and applications. Tanzu Application Platform values are secrets
and must be protected to ensure that the security and integrity of the platform is maintained.

Tanzu Application Platform stores all sensitive values as [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).

Encryption of secrets at rest are Kubernetes distribution dependent.

Use [External Secrets Operator](../external-secrets/about-external-secrets-operator.hbs.md)
to automate the lifecycle management of Secrets stored in a Secret management service, such as, [Hashicorp Vault](https://www.vaultproject.io), [Google Secrets Manager](https://cloud.google.com/secret-manager), [Amazon Secrets Manager](https://aws.amazon.com/secrets-manager/), or [Microsoft Azure Key Vault](https://azure.microsoft.com/en-us/products/key-vault/) use.

For more information related to safeguarding sensitive information from exploitation, such as, Tanzu Application Platform values, see the [AC-23](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf) section in the SP 800-53 publication.

## <a id="logging"></a> Logging

Log files provide an audit trail to monitor activity within infrastructure. Use log files to
identify policy violations, unusual activity, and security incidents. It is important that logs are
captured and retained according to the policies set forth by your organization's security team or governing body. Tanzu Application Platform components run as pods on the Kubernetes infrastructure
and all components output is captured as part of the pod logs.

All Tanzu Application Platform components follow
[Kubernetes logging](https://kubernetes.io/docs/concepts/cluster-administration/logging/) best practices.
Log aggregation must be implemented following the best practices of the organization log retention
process. For more information, see the [AU-4 Audit Log Storage Capacity](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf) section in the SP 800-53 publication.

## <a id="architecture"></a> Deployment architecture

Tanzu Application Platform provides a
[reference architecture](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap-reference-architecture/GUID-reference-designs-tap-architecture-planning.html) that depicts separate components based on function. VMware recommends multiple Kubernetes clusters for the iterate, build, view, and run functions. This separation enables Kubernetes administrators to manage each function independently
and therefore, protect the availability and performance of the platform during high usage periods,
for example, building or scanning.
