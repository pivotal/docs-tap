# Supply Chain Security Tools - Scan 2.0 (beta)

This topic gives you an overview of Supply Chain Security Tools (SCST) - Scan
2.0. SCST - Scan 2.0 is the next generation scanning framework for the Tanzu
Application Platform. This will supersede the [SCST - Scan
component](overview.hbs.md) in a future release. The focus of this next
generation framework is to simplify the scan integration so that users can
create integrations for the available scan engines.

>**Important** SCST - Scan 2.0 is in beta, which means that it is still in
>active development by VMware and might be subject to change at any point. Users
>might encounter unexpected behavior. This is an opt-in
>component to gather early feedback from beta testers and is not installed by
>default with any profile.

## <a id="overview"></a>Overview

SCST - Scan 2.0 provides a framework to scan components of
workloads to help users increase the security posture of their application. This
component can scan container images using your preferred container image scan
solution for known Common Vulnerabilities and Exposures (CVEs). By including
this component in a users software supply chain, a user can identify
vulnerabilities earlier in the development life cycle. 
 
Scan 2.0 simplifies integrating image scan solutions, such as Anchore's
Grype, Aqua's Trivy, Palo Alto's Prisma, and VMware Carbon Black Cloud into
Tanzu Application Platform. You achieve this by using the following features of Scan 2.0:

- Reducing the scope of what image scanning is responsible for to include:
  - Scanning a container for vulnerabilities
  - Pushing the scan results in an industry standard format, such
    as[CycloneDX](https://cyclonedx.org/) or [SPDX](https://spdx.dev/), as an
    industry standard OCI artifact to an OCI compliant container registry.
    Using industry standards mitigates the need for users wishing to create an
    integration to be familiar with proprietary Tanzu Application Platform
    configurations.
  - Providing a generic interface as a Kubernetes Custom Resource Definition
    (CRD), ImageVulnerabilityScan, that allows users to declare how the Tanzu
    Application Platform executes a scan on a container image for a container
    image scan solution.

As part of the Tanzu Application Platform, the Scan 2.0 component scans a
container image for a workload that is built by the supply chain or provided as
part of a workload definition, and posting the results to the container registry
as an OCI artifact. Downstream services in the Tanzu Application such as the
[Tanzu CLI Insight Plugin](../cli-plugins/insight/cli-overview.hbs.md) and the
[Supply Chain Choreographer](../tap-gui/plugins/scc-tap-gui.hbs.md) and
[Security Analysis](../tap-gui/plugins/sa-tap-gui.hbs.md) dashboards within the
[Tanzu Developer portal](../tap-gui/about.hbs.md) depend on the data being in
the [SCST - Store component](../scst-store/overview.hbs.md). Because pushing of scan
results to the proprietary store endpoint is decoupled from the scan framework
in Scan 2.0, the [AMR Observer
(alpha)](../scst-store/amr/overview.hbs.md#amr-observer-alpha) observes results
pushed to a container registry, parses the results, and pushes them to the SCST - Store component. 

## <a id="supply-chain-usage"></a>Integrating in to a supply chain

The SCST Scan 2.0 component defines how to scan a container image with a scan
solution using the generic Kubernetes custom resource `ImageVulnerabilityScan`.
For [Cartographer](../scc/about.hbs.md) to stamp out an `ImageVulnerabilityScan`
CR as part of a supply chain execution, the `ImageVulnerabilityScan` must be
wrapped in a `ClusterImageTemplate` CR.  This CR tells cartographer not only how
to stamp out the `ImageVulnerabilityScan` template, but also what configurations
are passed to it.

## <a id="getting-started"></a>Getting started with Scan 2.0

To try out the Scan 2.0 component, review the [Scan 2.0 Getting Started guide](getting-started.hbs.md).