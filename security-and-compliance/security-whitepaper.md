# Security Overview Whitepaper

Tanzu Application Platform enables a consistent experience that is Kubernetes-native
across any cloud. The security controls can therefore also be consistently
applied across environments by using several pre-packaged components in Tanzu Application Platform that
assist in achieving greater security for Tanzu Kubernetes clusters and its underlying
environment. Shared responsibility model also applies for securing environments
that run Tanzu Application Platform provisioned clusters for all layers in the cloud native stack:
*Code*, *Container*, *Cluster*, and *Cloud*.

This document is an attempt to share the current state of the art of Tanzu Application Platform
security. With every release, we remain committed to improving Tanzu Application Platform security with
a focus on making security intrinsically part of the product while maintaining a
frictionless developer experience. All the recommendations in this document
should be taken into consideration based on the security posture and risk
appetite of the organization.

## <a id="intro"></a> Introduction

This document provides an overview of the security in and around VMware Tanzu
Kubernetes Grid. It briefly describes how VMware approaches security for Tanzu
Kubernetes Grid, the security controls available for use built into the product,
and best practices to implement complementary security controls that protect the
environments in which Tanzu Application Platform clusters are deployed.

## <a id="scope"></a> Scope

This document pertains only to the Tanzu Application Platform multi-cloud offering. Its
official product documentation and differences with other offerings are
described [here](https://tanzu.vmware.com/tanzu).

For security guidance on:

1. **Tanzu Application Platform Integrated Edition**: please refer to its
   [official](https://docs.pivotal.io/tkgi/security.html)
   documentation.

1. **vSphere with Tanzu**: please refer to its
   [official](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-A60A132D-F993-427C-B6BA-D7F60C87FD02.html)
   documentation.

1. **Tanzu Mission Control**: please refer to this
   [whitepaper](https://tanzu.vmware.com/content/white-papers/tanzu-mission-control-security-measures).

### <a id="goals"></a> Goals

Understand, manage, and secure a Tanzu Application Platform environment with available
tools, configurations, and settings based on a customer’s risk posture.

### <a id="non-goals"></a> Non-goals

- All other Tanzu Products apart from Tanzu Application Platform are out of scope. A
  full list of products under the Tanzu umbrella can be found
  here: [VMware Tanzu Products](https://tanzu.vmware.com/products).

- Details on VMware’s policies and practices for secure software development can
  be found in this
  [whitepaper](https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/whitepaper/vmware-product-security-white-paper.pdf).

For a quick introduction on the architecture and key concepts of Tanzu
Kubernetes Grid, please refer
to [Tanzu Application Platform Concepts](../tkg-concepts.md)
documentation.

## <a id="code"></a> Code

Tanzu Application Platform runs code written by application developers, deployed as
Kubernetes pods. Tanzu Application Platform is made up of
[different components](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.3.1/rn/VMware-Tanzu-Kubernetes-Grid-131-Release-Notes.html#component-versions), many of which are open source and some proprietary to VMware. If the code of
all of these applications and components is secure, it improves the security
posture of the environment running Tanzu Application Platform provisioned clusters.

Tanzu Application Platform is developed in compliance with
the [VMware Security Development Lifecycle Process](https://www.vmware.com/content/dam/digitalmarketing/vmware/en/pdf/whitepaper/vmware-product-security-white-paper.pdf). Specifically, the following best practices are implemented to ensure Tanzu Application Platform
product security:

- Revise threat model for every major design change in the product.

- Work on high priority fixes for the findings coming out of the threat
  modelling exercise.

- Automated builds for all core Tanzu Application Platform components to compile them from source code.

- Participate in upstream for security fixes, release management, and triage of
  vulnerabilities.

- For VMware proprietary code before merging to `main` branch:

  - Implement peer code reviews to ensure second pair of eyes.

  - Execute automated static code scanning using tools like `golint`, `gosec`, `govet`.

- Sign binaries like `kubectl` or `tanzu-cli` with VMware signing keys.

To secure code of the containerized apps running on Tanzu Application Platform, the following resources
can serve as a helpful reference:

- [DevSecOps: Integrating security with software development](https://tanzu.vmware.com/devsecops)

- [Securely Managing Manifests as Code](https://tanzu.vmware.com/developer/guides/kubernetes/packaging/)

## <a id="containers"></a> Containers

Containers are instantiated as Linux namespace isolated processes, using
pre-packaged images that are essentially tarballs of all the runtime
dependencies and app binary to run the *containerized* application. Tanzu
Kubernetes Grid runs these containers as part of Kubernetes pods. Many Tanzu Application Platform
components are also packaged as container images and are configured to run as
pods (sometimes as Kubernetes daemonsets or static pods). The following best
practices are implemented to secure containers of Tanzu Application Platform components:

- Scan all container images with vulnerability scanner for Common Vulnerability and Exposures (CVEs) during
  `push` to the staging container registry.

- Limit `push` access to external-facing container registry to the Tanzu Application Platform release
  team following the principle of least privilege.

- Use a centrally (LDAP) managed service, or robot account, that automates `push` of
  container images from staging to production after release criteria and
  appropriate testing is complete.

- Perform an internal impact assessment documenting any critical unfixed
  vulnerabilities in the container images.

- Fix vulnerabilities with major product impact<sup>
  \[[1](https://kb.vmware.com/s/article/83781)\]\[[2](https://kb.vmware.com/s/article/83761)\]</sup>
  without waiting for the next minor release.

- Regularly update Tanzu Application Platform components to newer base images in order to obtain fixes
  for newly identified vulnerabilities.

- Prefer and drive the move towards minimal images for all Tanzu Application Platform components, when
  possible, and limit base image distributions to a small number, to reduce the
  patching surface area for all images.

To build, run, and consume container images securely in general, the following
resources are a useful guide:

- [Best Practices for Securing and Hardening Container
  Images](https://tanzu.vmware.com/developer/guides/containers/security-best-practices/)

- [Deploy Harbor into a Workload or a Shared Services Cluster](../packages/harbor-registry.md)

### <a id="node-images"></a> OS Updates and Node Image Versions

VMware packages versioned base machine OS images in Tanzu Kubernetes releases (TKrs), along with compatible versions of Kubernetes and supporting components.
Tanzu Application Platform then uses these packaged OS, Kubernetes, and component versions to create cluster and control plane nodes.
See [Tanzu Kubernetes Releases](../tkr.md) for more information.

Each published TKr uses the latest stable and generally-available update of the OS version that it packages, containing all current CVE and USN fixes, as of the day that the image is built.
VMware rebuilds these node images⸺vSphere OVAs, AWS AMIs, and Azure VM images⸺with each release of Tanzu Application Platform, and possibly more frequently.
The image files are signed by VMware and have filenames that contain a unique hashcode identifier.

When a critical or high-priority CVE is reported, VMware collaborates on a fix, and when the fix is published, rebuilds all affected node images, and container base images, to include the update.

## <a id="fips"></a> FIPS-Capable Version

You can install and run a FIPS-capable version of Tanzu Application Platform v1.5.3, in which core components use cryptographic primitives provided by a FIPS-compliant library based on the [BoringCrypto](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/2964) / Boring SSL module.
These core components include components of Kubernetes, [Containerd and CRI](https://github.com/containerd/containerd), [CNI plugins](https://www.cni.dev/docs/), [CoreDNS](https://coredns.io/), and [etcd](https://etcd.io/).

For how to install FIPS-capable Tanzu Application Platform, see the [FIPS-Capable Version](../mgmt-clusters/prepare-deployment.md#fips) section of _Prepare to Deploy Management Clusters_.

## <a id="clusters"></a> Clusters

A Kubernetes cluster is made up of several components that act as a control
plane of the cluster and a set of supporting components and worker nodes that
actually help run deployed workloads. There are two types of clusters in the
Tanzu Application Platform setup: management cluster and Tanzu Kubernetes (workload) cluster. The Tanzu Application Platform
management cluster hosts all the Tanzu Application Platform components used to manage workload
clusters. Workload clusters that are spun up by Tanzu Application Platform admins are then used to
actually run the containerized applications. Cluster security is a shared
responsibility between Tanzu Application Platform cluster admins, developers, and operators who run apps
on Tanzu Application Platform provisioned clusters. This section enumerates the components included
with Tanzu Application Platform by default that can help implement secure best practices for both
management and workload clusters.

### <a id="iam"></a> Identity and Access Management

Tanzu Application Platform has a [Pinniped](../iam/about-iam.md) package that enables secure access to Kubernetes clusters. Tanzu Application Platform
operators are still responsible for granting access to cluster resources to
other users of Kubernetes through
built-in [role-based access control](https://kubernetes.io/docs/reference/access-authn-authz/rbac/). Recommended best practices for managing identities in Tanzu Application Platform provisioned clusters
are as follows:

- Limit access to cluster resources
  following [least privilege](https://csrc.nist.gov/glossary/term/least_privilege)
  principle.

- Limit access to management clusters to the appropriate set of users. For example, provide access only to users who are responsible for managing infrastructure
  and cloud resources but not to application developers. This is especially
  important because access to the management cluster inherently provides access
  to all workload clusters.

- Limit cluster admin access for workload clusters to the appropriate set of
  users. For example, users who are responsible for managing infrastructure and platform
  resources in your organization but not to application developers.

- With Pinniped, connect to a
  centralized [identity provider](https://csrc.nist.gov/glossary/term/identity_provider)
  to manage user identities allowed to access cluster resources instead of
  relying on admin generated `kubeconfig` files.

### <a id="multi-tenancy"></a> Multi-Tenancy

One of the core benefits of Tanzu Application Platform is the ability to manage the complete lifecycle
of multiple clusters through a single management plane. This is important,
because from a multi-tenancy point of view, the highest form of isolation
between untrusted workloads is possible when they run in separate Kubernetes
clusters. These are some of the defaults configured to support multi-tenant
workloads in Tanzu Application Platform:

- Nodes are not shared between clusters.

- Nodes are configured to host only container workloads.

- The management plane runs in its own dedicated cluster to enable separation of
  concerns with workload clusters.

- Kubernetes management components such as `api-server`, `scheduler`,
  `controller-manager`, etc., run on dedicated nodes. Additionally, consider
  applying an audit rule to detect deployment of any workload pods to control
  plane nodes.

- Application pod scheduling on dedicated nodes for management components (mentioned above) is disabled through node taints and affinity rules.

To improve security in an AWS multi-tenant environment, deploy the workload clusters to an AWS account that is different from the one used to deploy the management cluster. To deploy workload clusters across multiple AWS accounts, see [Clusters on Different AWS Accounts](../tanzu-k8s-clusters/aws.md#multi-tenancy).

For more in depth information on the design considerations when deploying
multi-tenant environments, see [Workload Tenancy](https://tanzu.vmware.com/developer/guides/kubernetes/workload-tenancy/).

### <a id="isolation"></a> Workload Isolation

Workload Isolation requirements are unique for each customer. Therefore, to
reasonably isolate workloads from each other with acceptable risk tolerance
requires additional effort in line with the shared responsibility model. This
includes limiting the number of containers that need to run with higher
privileges to a handful of namespaces and implementing defense in depth
mechanisms such as AppArmor and SELinux at runtime, pod, and node level. These
configurations can be centrally enforced on pods
through [Pod Security Policies](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
with an eye on migration to its
replacement: [Pod Security Admission Control](https://kubernetes.io/docs/tasks/configure-pod-container/migrate-from-psp/).

For advanced use cases and custom policy management, in general the following
resources serve as a good starting point:
[OPA](https://tanzu.vmware.com/developer/guides/kubernetes/platform-security-opa/),
[Admission Control](https://tanzu.vmware.com/developer/guides/kubernetes/platform-security-admission-control/),
and [Pod Security Standards](https://tanzu.vmware.com/developer/guides/kubernetes/platform-security/#pod-security-policies-psphttpskubernetesiodocsconceptspolicypod-security-policy)

### <a id="internal-comms"></a> Protecting Inter-Service Communication

One of the fundamental aspects of a microservices architecture is building
services that do one thing only. This enables separation of concerns and allows
teams to move faster. However, this also increases the need to communicate with
several different microservices that are often running in the same cluster in
their own pods. Therefore, the following best practices should be considered for
securing these communications at runtime:

- **Least privilege network policies**: Antrea is the default CNI plugin that is
  enabled in Tanzu Application Platform. To learn more about how to use it to implement network
  policies that can be applied depending on the risk posture, refer to the
  official docs for
  [Antrea](https://antrea.io/docs). To use a different CNI plugin of choice,
  follow this
  guide: [Customize Tanzu Kubernetes Cluster Networking](../tanzu-k8s-clusters/networking.md)

- **Mutual TLS by default**: Implementing this is a responsibility of the
  customers of Tanzu Application Platform. This can be implemented as part of application manifest or
  by using a [service mesh](https://tanzu.vmware.com/service-mesh) that enables
  a sidecar container to handle TLS communication for the app container.

- **Protect Secrets**: There are several different options to choose from when
  managing secrets in a Kubernetes cluster. For a quick run-down of
  options, see [Secrets Management](https://tanzu.vmware.com/developer/guides/kubernetes/platform-security-secret-management/).

### <a id="observability"></a> Auditing, Logging, and Monitoring

To ensure observability and repudiation of cluster resources including
application pods, it is important to enable auditing and monitoring of Tanzu Application Platform
provisioned clusters. Tanzu Application Platform is packaged with a set of extensions that allow
administrators to enable this natively. The following guides explain this in
depth:

1. [API server and System audit logging](../troubleshooting-tkg/audit-logging.md):
   How to enable API server audit logging as well system level (node)
   auditing to prevent repudiation of cluster usage. Tanzu Application Platform includes a default
   policy for API server auditing. It is recommended to set an appropriate
   policy for node level audit daemon to ensure tampering of container runtime
   binaries and configuration can be detected.

1. [Log Forwarding with Fluent Bit](../packages/logging-fluentbit.md):
   How to enable centralized log collection that can prevent loss of repudiation
   due to local tampering of logs.

1. [Monitoring with Prometheus and Grafana](../packages/grafana.md):
   How to enable observability of cluster and system metrics for alerting and
   visualization that can detect sudden spikes in resource consumption due to
   denial of service attacks.

Depending on the relevant threat outlined, any or all of the above controls can
be applied to a Tanzu Application Platform cluster.

## <a id="providers"></a> Cloud Providers

Cloud providers act as an underlay resource for all the Tanzu Application Platform provisioned
Kubernetes Clusters, regardless of whether it is an on-premises (e.g. vSphere)
or a public cloud (e.g. AWS, Azure, or Google Cloud) deployment. Securing the
underlying infrastructure is generally a shared responsibility between customers
of Tanzu Application Platform and the cloud providers. These are some recommendations to improve
security of the cloud underlying the Tanzu Application Platform provisioned clusters:

- Rotate or update your cloud credentials regularly using this guide
  (vSphere
  only): [Tanzu Cluster Secrets](../cluster-lifecycle/secrets.md)
  (If automating rotation, please consider testing it in non-production
  environments to observe and plan for any disruption it may cause).

- Apply least privileged permissions for cloud credentials as described in the
  documentation for
  [AWS](../mgmt-clusters/aws.md),
  [Azure](../mgmt-clusters/azure.md), and
  [vSphere](../mgmt-clusters/vsphere.md)
  providers. Whenever possible, run management and workload clusters in separate (VPCs) and firewall zones. This is the default setting for
  Tanzu Application Platform provisioned clusters.

- SSH node access, especially to control plane nodes, should be restricted to a
  small set of users who play the role of infrastructure admin.

- SSH access should be rarely used, mainly as
  a [break glass procedure](../troubleshooting-tkg/tips.md)
  such as loss of management cluster credentials.

- Validate that cluster resources are not accessible to unauthenticated users on the
  internet. Customers with low risk tolerance should deploy clusters without
  exposing API server port to the internet with appropriate load balancer
  configuration.

- Isolate Tanzu Application Platform environment (management and workload clusters) in dedicated VPCs, or behind a firewall from other non-Tanzu cloud workloads, to limit lateral
  movement and to reduce the attack surface area in case of a compromised
  cluster.

- Apply, test, and validate disaster recovery scenarios for redundancy and
  multi-region availability across clusters.

- Implement a plan to recover from loss of data caused by data corruption,
  ransomware attacks, or natural catastrophes that result in physical hardware
  damage.

- Consider using native backup and restore of cluster resources with
  [Velero](../cluster-lifecycle/backup-restore-mgmt-cluster.md)
  to help in disaster recovery planning and data loss recovery scenarios.

These recommendations are in addition to the general guidance on security for
any cloud provider. For general guidance on cloud security, please refer to the
relevant cloud provider’s official security documentation.

In conclusion, this document provides a broad picture about the current state
of the art and recommended security controls that can be applied to Tanzu
Kubernetes Grid. We are committed to shipping more intrinsically secure Tanzu Application Platform with
every release keeping in mind the desire to have a frictionless developer
experience.

If you have feedback on the document or have any feature requests related to
security, please contact your VMware representative.

## <a id="references"></a> References

### <a id="upstream"></a> Upstream Community Led Resources

These are some upstream (CNCF/Kubernetes) community-driven security-centric
resources:

- [Kubernetes SIG Security 2020 Annual Report](https://github.com/kubernetes/community/blob/master/sig-security/annual-report-2020.md):
   Update in progress for 2021.

- [Cloud native security whitepaper (2020)](https://github.com/cncf/sig-security/blob/master/security-whitepaper/CNCF_cloud-native-security-whitepaper-Nov2020.pdf):
   Update in progress for 2021.

- [Cloud Native Security for your Clusters:](https://kubernetes.io/blog/2020/11/18/cloud-native-security-for-your-clusters/)
   Kubernetes specific take on (2).

- [OWASP CheatSheet for Kubernetes Security](https://cheatsheetseries.owasp.org/cheatsheets/Kubernetes_Security_Cheat_Sheet.html)

- [4 Cs model for Kubernetes Security](https://kubernetes.io/docs/concepts/security/overview/):
   This page borrows its high level structure from here.

### <a id="standards"></a> Third Party Standards and Guidelines

Following are a list of documents published in no particular order of preference
from government and standards bodies:

- [Cybersecurity Technical Report- Kubernetes Hardening Guidance](https://media.defense.gov/2021/Aug/03/2002820425/-1/-1/1/CTR_KUBERNETES%20HARDENING%20GUIDANCE.PDF):
   Published in Aug 2021, this is a prescriptive document that covers many areas
   related to Kubernetes security.

- [NIST Application Container Security Guide](https://www.nist.gov/publications/application-container-security-guide):
   Published in 2017.

- [NIST Kubernetes STIG Checklist](https://ncp.nist.gov/checklist/996):
   Published in April 2021, provides a prescriptive a list of technical
   requirements for securing a basic Kubernetes platform.

- [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes/):
   Widely used as a secure configuration guide, last updated in June 2021.

- [Container Platform Security Requirements Guide](https://public.cyber.mil/announcement/stig-update-disa-has-released-the-container-platform-srg/):
   U.S. Department of Defense published this guide to secure a basic Kubernetes
   platform in Dec 2020.

- [AWS well-architected- Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html):
   High level document that describes designing cloud architectures with
   security in mind for AWS.

- [Azure well-architected- Security Pillar](https://docs.microsoft.com/en-us/azure/architecture/framework/security/overview):
   High level document that describes designing cloud architectures with
   security in mind for Azure.

- [Google Architecture Framework- Security, privacy, and compliance](https://cloud.google.com/architecture/framework/security-privacy-compliance):
   High level document that describes designing cloud architectures with
   security in mind for Google Cloud.

- [Hardening and Compliance for vSphere](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.security.doc/GUID-E95FDFD1-7408-422D-B6A1-B0B051873D8C.html):
   High level overview of security and compliance that require attention to help
   plan security and compliance strategy.
