# Supply Chain Security Tools - Scan 2.0

This topic gives you an overview of Supply Chain Security Tools (SCST) - Scan
2.0. Include this component in your software supply chain to help identify
vulnerabilities earlier in the development life cycle. This helps to increase the security
posture of your application.

## <a id="overview"></a>Overview

SCST - Scan 2.0 is the next-generation scanning framework for Tanzu
Application Platform. It will supersede the [SCST - Scan
component](overview.hbs.md) in a future release. It  provides a framework to scan
workload components.

With SCST - Scan 2.0 you can:

- Scan container images for a workload that is built by the supply chain or provided
as part of a workload definition for known Common Vulnerabilities and Exposures (CVEs).
- Use your preferred container image scan solution such as Anchore's
Grype, Aqua's Trivy, Palo Alto's Prisma, and VMware Carbon Black Cloud.
- Post the scan results in an industry-standard format, such
as [CycloneDX](https://cyclonedx.org/) or [SPDX](https://spdx.dev/), as an
OCI artifact to an OCI-compliant container image registry.
By using industry standards, you do not need to be familiar with proprietary
Tanzu Application Platform configurations.

### AMR Observer

Downstream services such as 
[Tanzu CLI Insight plug-in](../cli-plugins/insight/cli-overview.hbs.md),
[Supply Chain Choreographer](../tap-gui/plugins/scc-tap-gui.hbs.md), and
[Security Analysis](../tap-gui/plugins/sa-tap-gui.hbs.md) dashboards in the
Tanzu Developer Portal depend on data being in
the [SCST - Store component](../scst-store/overview.hbs.md). Because pushing scan
results to the proprietary store endpoint is decoupled from the scan framework
in SCST - Scan 2.0, AMR Observer observes results
pushed to a registry, parses the results, and pushes them to the SCST - Store component.

For information about AMR observer, see [Overview of Supply Chain Security Tools for Tanzu – Store](../scst-store/overview.hbs.md).

## <a id="supply-chain-usage"></a>Integrating into a supply chain

The SCST - Scan 2.0 component defines how to scan a container image with a scan
solution using the generic Kubernetes custom resource `ImageVulnerabilityScan`.
This provides a generic interface that allows you to declare how the Tanzu
Application Platform executes a scan on a container image for a container
image scan solution.
For [Cartographer](../scc/about.hbs.md) to stamp out an `ImageVulnerabilityScan`
custom resource as part of a supply chain execution, the `ImageVulnerabilityScan` must be
wrapped in a `ClusterImageTemplate` custom resource. This custom resource tells Cartographer not
only how to stamp out the `ImageVulnerabilityScan` template, but also what configurations
are passed to it.

## <a id="getting-started"></a>Getting started with SCST - Scan 2.0

To use the SCST - Scan 2.0 component, see [Getting Started with Supply Chain Security Tools - Scan 2.0](getting-started.hbs.md).
