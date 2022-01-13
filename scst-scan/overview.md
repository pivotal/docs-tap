# Supply Chain Security Tools - Scan

## Overview

With Supply Chain Security Tools - Scan, Tanzu customers can build and deploy secure, trusted software that complies with their corporate security requirements. To enable this, Supply Chain Security Tools - Scan provides scanning and gatekeeping capabilities that Application and DevSecOps teams can easily incorporate earlier in their path to production as it is a known industry best practice for reducing security risk and ensuring more efficient remediation.

## <a id="use-cases"></a>Use cases

* Using your scanner as a plug-in, scan source code repositories and images for known Common Vulnerabilities and Exposures (CVEs) before deploying to a cluster.
* Identify CVEs by continuously scanning each new code commit and/or each new image built.
* Analyze scan results against user-defined policies using Open Policy Agent.
* Produce vulnerability scan results and post them to the Supply Chain Security Tools - Store from where they can be queried.

## <a id="supply-chain-security-tools-scan-features"></a>Supply Chain Security Tools - Scan features

The following Supply Chain Security Tools - Scan features make the use cases available:

* Kubernetes controllers to run scan jobs.
* Custom Resource Definitions (CRDs) for Image and Source Scan.
* CRD for a scanner plug-in. Provided example using: Anchore's Syft and Grype.
* CRD for policy enforcement.
* Enhanced scanning coverage by analyzing the Cloud Native Buildpack SBoMs provided by TBS images.

## <a id="scanner-support"></a>Scanner support

| Out-Of-The-Box Scanner | Version |
| --- | --- |
| [Anchore Grype](https://github.com/anchore/grype) | v0.27.2 |

More to come. Let us know if there's a scanner you'd like us to support.

## <a id="prerequisites"></a>Prerequisites

* Supply Chain Security Tools - Store to store CVE results.
  For installation instructions, see [Installing part II: Profiles](../install-components.md#install-scst-store).
  For usage instructions, see [Using the Supply Chain Security Tools - Store](../scst-store/overview.md).

* Supply Chain Security Tools - Store CLI to query the Supply Chain Security Tools - Store for CVE results.
  See [Installing the CLI](../scst-store/cli_installation.md).
