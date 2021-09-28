# Overview

The Tanzu Vulnerability Scanning Enablement (VSE) Team's mission is to help Tanzu customers build and deploy secure, trusted software that complies with their corporate security requirements. To that end, we are providing scanning and gatekeeping capabilities that Application and DevSecOps teams can easily incorporate earlier in their path to production as it is a known industry best practice for reducing security risk and ensuring more efficient remediation.

## Use Cases
* Scan source code repositories and images for known CVEs prior to deploying to a cluster using your scanner as a plugin.
* Identify CVEs by scanning continuously on each new code commit and/or each new image built.
* Analyze scan results against user-defined policies using Open Policy Agent.
* Produce vulnerability scan results and post them to the Metadata Store from where they can be queried.

## What We Built
To deliver on the use cases, we have:
* Built Kubernetes controllers to run scan jobs.
* Built Custom Resource Definitions (CRDs) for Image and Source Scan.
* Created a CRD for a scanner plugin. Provided example using: Anchore's Syft and Grype.
* Created a CRD for policy enforcement.

## Scanner Support
| Out-Of-The-Box Scanner | Image |
| --- | --- |
| Anchore Grype | [1.0.0-alpha.1](#scanner-anchore-grype) |

More to come in FY23! Let us know if there's a scanner you'd like us to support.
