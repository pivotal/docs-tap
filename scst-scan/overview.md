# Supply Chain Security Tools - Scan

## Overview
With Supply Chain Security Tools - Scan, Tanzu customers can build and deploy secure, trusted software that complies with their corporate security requirements. To enable this, Supply Chain Security Tools - Scan provides scanning and gatekeeping capabilities that Application and DevSecOps teams can easily incorporate earlier in their path to production as it is a known industry best practice for reducing security risk and ensuring more efficient remediation.

## Use cases
* Using your scanner as a plug-in, scan source code repositories and images for known CVEs before deploying to a cluster.
* Identify CVEs by continuously scanning each new code commit and/or each new image built.
* Analyze scan results against user-defined policies using Open Policy Agent.
* Produce vulnerability scan results and post them to the Supply Chain Security Tools - Store from where they can be queried.

## Supply Chain Security Tools - Scan features
The following Supply Chain Security Tools - Scan features make the use cases available:

* Built Kubernetes controllers to run scan jobs.  
* Built Custom Resource Definitions (CRDs) for Image and Source Scan.  
* Created a CRD for a scanner plugin. Provided example using: Anchore's Syft and Grype.  
* Created a CRD for policy enforcement.

## Scanner support
| Out-Of-The-Box Scanner | Version |
| --- | --- |
| [Anchore Grype](https://github.com/anchore/grype) | v0.25.1 |

More to come in FY23! Let us know if there's a scanner you'd like us to support.

## Prerequisites

* Supply Chain Security Tools - Store to store CVE results.
  For installation instructions, see [Installing Part II: Profiles](../install-components.md#install-scst-store).
  For usage instructions, see [Using the Supply Chain Security Tools - Store](../scst-store/overview.md).

* Supply Chain Security Tools - Store CLI to query the Supply Chain Security Tools - Store for CVE results.
  See [Installing the CLI](../scst-store/cli_installation.md).
