# Supply Chain Security Tools - Scan 2.0

This topic gives you an overview of Supply Chain Security Tools (SCST) - Scan
2.0.

## <a id="overview"></a>Overview

SCST - Scan 2.0 is the next-generation scanning framework for the Tanzu
Application Platform. It will supersede the [SCST - Scan
component](overview.hbs.md) in a future release. It simplifies the scan integration so that you can
create integrations for the available scan engines.

SCST - Scan 2.0 provides a framework to scan workload components.
This helps to increase the security posture of your application.
SCST - Scan 2.0 can scan container images using your preferred container image scan
solution for known Common Vulnerabilities and Exposures (CVEs). By including
this component in your software supply chain, you can identify
vulnerabilities earlier in the development life cycle.
 
SCST - Scan 2.0 simplifies integrating image scan solutions, such as Anchore's
Grype, Aqua's Trivy, Palo Alto's Prisma, and VMware Carbon Black Cloud into
Tanzu Application Platform. 

SCST - Scan 2.0 contains the  following features:

  - Scan a container for vulnerabilities.
  - Push the scan results in an industry standard format, such
    as [CycloneDX](https://cyclonedx.org/) or [SPDX](https://spdx.dev/), as an
    industry standard OCI artifact to an OCI compliant container image registry.
    By using industry standards, you do not need to be familiar with proprietary
    Tanzu Application Platform     configurations.
  - Provide a generic interface as a Kubernetes Custom Resource Definition
    (CRD), ImageVulnerabilityScan, that allows you to declare how the Tanzu
    Application Platform executes a scan on a container image for a container
    image scan solution.

SCST - Scan 2.0 scans a container image for a workload that is built by the supply chain or provided
as part of a workload definition, and posts the results to the registry
as an OCI artifact. Downstream services in the Tanzu Application such as the
[Tanzu CLI Insight plug=-in](../cli-plugins/insight/cli-overview.hbs.md),
[Supply Chain Choreographer](../tap-gui/plugins/scc-tap-gui.hbs.md), and
[Security Analysis](../tap-gui/plugins/sa-tap-gui.hbs.md) dashboards in the
Tanzu Developer Portal depend on data being in
the [SCST - Store component](../scst-store/overview.hbs.md). Because pushing of scan
results to the proprietary store endpoint is decoupled from the scan framework
in SCST - Scan 2.0, AMR Observer observes results
pushed to a registry, parses the results, and pushes them to the SCST - Store component.
For information about AMR observer, see [Overview of Supply Chain Security Tools for Tanzu – Store](../scst-store/overview.hbs.md).

## <a id="supply-chain-usage"></a>Integrating into a supply chain

The SCST - Scan 2.0 component defines how to scan a container image with a scan
solution using the generic Kubernetes custom resource `ImageVulnerabilityScan`.
For [Cartographer](../scc/about.hbs.md) to stamp out an `ImageVulnerabilityScan`
custom resource as part of a supply chain execution, the `ImageVulnerabilityScan` must be
wrapped in a `ClusterImageTemplate` custom resource.  This custom resource tells Cartographer not
only how to stamp out the `ImageVulnerabilityScan` template, but also what configurations
are passed to it.

## <a id="getting-started"></a>Getting started with Scan 2.0

To use the SCST - Scan 2.0 component, review the [Scan 2.0 Getting Started guide](getting-started.hbs.md).
