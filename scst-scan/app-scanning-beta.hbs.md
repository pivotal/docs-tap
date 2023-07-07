# Supply Chain Security Tools - Scan 2.0 (beta)

Supply Chain Security Tools (SCST) - Scan 2.0 is the next generation scanning framework for the Tanzu Application Platform.  This will supersede the [SCST - Scan component](overview.hbs.md) in a future release.  The focus of this next generation framework is to simply the scan integration so that it is easier for users to create integrations for the vast ecosystem of scan engines available.  

>**Important** SCST - Scan 2.0 is in beta, which means that it is still in
>active development by VMware and might be subject to change at any point. Users
>might encounter unexpected behavior. This is an opt-in
>component to gather early feedback from beta testers and is not installed by
>default with any profile.

## <a id="overview"></a>Overview

SCST - Scan 2.0 is responsible for providing the framework to scan components of workloads to help users increase the security posture of their application.  The initial capability for this component is to provide the ability to scan container images using a users prefered container image scan solution for known Common Vulnerabilities and Exposures (CVEs).  By including this component in a users software supply chain, a user can identify vulnerabilites earlier in the development lifecycle. 
 
The Scan 2.0 simplifies integrating image scan solutions such as Anchore's Grype, Aqua's Trivy, Palo Alto's Prisma, and VMware's Carbon Black Cloud in to the Tanzu Application Platform.  This is achieved by the following enhancements over Scan 1.0:

* Reducing the scope of what image scanning is resposible to only be 1) scanning a container image and 2) pushing the scan results in an industry standard format ([CycloneDX](https://cyclonedx.org/) or [SPDX](https://spdx.dev/) as an industry standard OCI artifact to an OCI compliant container registry.  Using industry standards mitigates the need for users wishing to create an integration to be familar with properitary Tanzu Application Platform configurations.
* Providing a generic interface as a Kubernetes Custom Resource Definition (ImageVulnerabilityScan) that allows users to declare how the Tanzu Application Platform should execute a scan on a container image for a given container image scan solution.

As part of the Tanzu Application Platform, the Scan 2.0 component is responsible for scanning a container image for a given workload (either built by the supply chain or provided as part of a workload definition) and posting the results to the container registry as an OCI artifact.  Downstream services in the Tanzu Application such as the [Tanzu CLI Insight Plugin](cli-plugins/insight/cli-overview.hbs.md) and the [Supply Chain Choreographer](../tap-gui/plugins/scc-tap-gui.hbs.md) and [Security Analysis](../tap-gui/plugins/sa-tap-gui.hbs.md) dashboards within the [Tanzu Developer portal](../tap-gui/about.hbs.md) depend on the data being in the [SCST - Store component](../scst-store/overview.hbs.md).  Since the pushing of scan results to the propietary store endpoint has been decoupled from the scan framework in Scan 2.0, the [AMR Observer (alpha)](../scst-store/amr/overview.hbs.md#amr-observer-alpha) has been introduced that observes results being pushed to a container registry, parses the results, and pushes them to the SCST - Store component. 

## <a id="supply-chain-usage"></a>Integrating in to a Supply Chain

The SCST Scan 2.0 component provides the ability to define how to scan a given container image with a given scan solution using the generic Kubernetes custom resource `ImageVulnerabilityScan`.  In order for [Cartographer](../scc/about.hbs.md) to be able to stamp out an `ImageVulnerabilityScan` CR as part of a supply chain execution, the `ImageVulnerabilityScan` must be wrapped in a `ClusterImageTemplate` CR.  This CR tells cartographer not only how to stamp out the `ImageVulnerabilityScan` template, but also what configurations should be passed to it.

## <a id="getting-started"></a>Getting Started with Scan 2.0

To try out the Scan 2.0 component, review the [Scan 2.0 Getting Started guide](getting-started.hbs.md).