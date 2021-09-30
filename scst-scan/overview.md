# Supply Chain Security Tools for VMware Tanzu - Scan

## Overview
With Supply Chain Security Tools (SCST) for Tanzu - Scan, Tanzu customers can build and deploy secure, trusted software that complies with their corporate security requirements. To enable this, SCST - Scan provides scanning and gatekeeping capabilities that Application and DevSecOps teams can easily incorporate earlier in their path to production as it is a known industry best practice for reducing security risk and ensuring more efficient remediation.

## Use Cases
* Using your scanner as a plug-in, scan source code repositories and images for known CVEs prior to deploying to a cluster
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
| Out-Of-The-Box Scanner | Version |
| --- | --- |
| [Anchore Grype](https://github.com/anchore/grype) | v0.20.0 |

More to come in FY23! Let us know if there's a scanner you'd like us to support.
