# Overview of Supply Chain Security Tools - Scan

This topic gives you an overview of use cases, features, and CVEs for Supply Chain Security Tools (SCST) - Scan.

## <a id="overview"></a>Overview

With Supply Chain Security Tools - Scan, you can build and deploy 
secure, trusted software that complies with your corporate security requirements. 
Supply Chain Security Tools (SCST) - Scan provides scanning and gatekeeping capabilities 
that Application and DevSecOps teams can incorporate early in their path to 
production as it is a known industry best practice for reducing security risk 
and ensuring more efficient remediation.

## <a id="use-cases"></a>Language support

For information about the languages and frameworks that are supported by Tanzu Application Platform components, see the [Language and framework support in Tanzu Application Platform](../about-package-profiles.hbs.md#language-support) table.

## <a id="use-cases"></a>Use cases

The following use cases apply to SCST - Scan:

- Scan source code repositories and images for known Common Vulnerabilities and Exposures (CVEs) as part of your software supply chain
- Use one of the out-of-box provided scan integrations or create your own to leverage your existing vulnerability scanning platforms
- Identify CVEs by continuously scanning container images for newly reported vulnerabilities
- Analyze supply chain scan results against user-defined policies
- Store vulnerability scan results in SCST - Store for long term archival and reporting

## <a id="scst-scan-feat"></a>SCST - Scan Versions

There are currently two versions of SCST - Scan:

### Scan 1.0

Scan 1.0 has been in the testing and scanning supply chain since it was introduced with TAP 1.0.  Scan 1.0 includes the ability to scan a workload for vulnerabilities, submit the scan results to SCST - Store for long term storage and reporting, and compare the results against a policy defined by the user.  This is all included in a tightly coupled scan job that is executed as part of the testing and scanning supply chain.  

This tight coupling of the capabilities made it difficult to develop and maintain integrations for the vast ecosystem of vulnerability scanning platforms.  To simplify this integration process, we have introduced Scan 2.0.

Although other scan integrations are available, the default configuration for Scan 1.0 was the open-source [Anchore Grype](https://anchore.com/opensource/).

### Scan 2.0

Scan 2.0 was introduced in the TAP 1.5 release as an Alpha and now enters GA in TAP 1.8.  This iteration of SCST - Scan focuses on simplifying the integration experience by decoupling SCST - Store submission and policy from the scanning task.  This allows integration to be simplified and focused on the task of scanning workloads for vulnerabilities. 

The Scan 2.0 engine also allows us to introduce the ability to scan container images after the initial creation of the workload.  This allows you to have visibility in the security posture of images as new vulnerabilities are reported.

Scan 2.0 ships with the default configuration to use open-source [Aqua Trivy](https://www.aquasec.com/products/trivy/) as the imager scanner, and we include a Grype template for backwards compatibility.  Examples of other integrations, as well as how to build your own integration with this simplified interface, are provided in documentation.

### Which version should I use?

In TAP 1.8, both Scan 1.0 and Scan 2.0 are supported.  In a future release, Scan 1.0 will be deprecated and replaced with Scan 2.0.  To help facilitate this transition, we are slowly making Scan 2.0 the default component based on the environment TAP is installed in.  Those defaults are as follows:

| Installation Type | Default Component | Detail |
| --- | --- | --- |
| [Online Installation](../install-online/intro.hbs.md) | Scan 1.0 | Scan 1.0 remains the default with the option for users to opt in to Scan 2.0 |
| [Offline Installation](../install-offline/intro.hbs.md) | Scan 2.0 | Scan 2.0 is the default due to a much simplified air gap experience with Trivy |
| [Azure Installation](../install-azure/intro.hbs.md)| Scan 1.0 | Scan 1.0 remains the default with the option for users to opt in to Scan 2.0 |
| [AWS Installation](../install-aws/intro.hbs.md)| Scan 1.0 | Scan 1.0 remains the default with the option for users to opt in to Scan 2.0 |

Other general guidance:

If you require policy to block a workload in a supply chain based on detected vulnerabilities, use Scan 1.0.
If you wish to create a scan integration for a scan tool that does not exist, use Scan 2.0 as the [process is greatly simplified](./bring-your-own-scanner.hbs.md).
If you opt in to using the new [Supply Chains component](../supply-chain/about.hbs.md), use Scan 2.0 as only Scan 2.0 is supported with Supply Chains.

## <a id="scst-scan-note"></a>A Note on Vulnerability Scanners

Although vulnerability scanning is an important practice in DevSecOps and 
the benefits of it are widely recognized and accepted, 
remember that there are limits present that impact its efficacy. 
The following examples illustrate the limits that are prevalent in most scanners today:

#### <a id="missed-cves"></a>Missed CVEs

One limit of all vulnerability scanners is that there is 
no one tool that can find 100% of all CVEs, which means there is always a risk 
that a missed CVE can be exploited. Some reasons for missed CVEs include:

- The scanner does not detect the vulnerability because it is recently discovered and the CVE databases that the scanner checks against are not updated yet.
- Scanners verify different CVE sources based on the detected package type and OS.
- The scanner might not fully support a particular programming language, packaging system or manifest format.
- The scanner might not implement binary analysis or fingerprinting.
- The detected component does not always include a canonical name and vendor, requiring the scanner to infer and attempt fuzzy matching.
- When vendors register impacted software with NVD, the provided information might not exactly match the values in the release artifacts.

#### <a id="false-positives"></a>False positives

Vulnerability scanners cannot always access the information to accurately identify whether a CVE exists. 
This often leads to an influx of false positives where the tool mistakenly flags something as a vulnerability when it isn’t. 
Unless a user is specialized in security or is deeply familiar with what is deemed to be a vulnerable component by the scanner, 
assessing and determining false positives becomes a challenging and time-consuming activity. Some reasons for a false positive flag include:

- A component might be misidentified due to similar names.
- A sub-component might be identified as the parent component.
- A component is correctly identified but the impacted function is not on a reachable code path.
- A component’s impacted function is on a reachable code path but is not a concern due to the specific environment or configuration.
- The version of a component might be incorrectly flagged as impacted.
- The detected component does not always include a canonical name and vendor, requiring the scanner to infer and attempt fuzzy matching.

So what can you do to protect yourselves and your software?

Although vulnerability scanning is not a perfect solution, it is an essential part 
of the process for keeping your organization secure. 
You can take the following measures to maximize the benefits while minimizing 
the impact of the limits:

- Scan more continuously and comprehensively to identify and remediate zero-day vulnerabilities quicker. You can achieve comprehensive scanning by:

    - scanning earlier in the development cycle to ensure that you can address issues more efficiently and do not delay a release. 
    Tanzu Application Platform includes security practices such as source and container image vulnerability scanning earlier in the path to production for application teams.
    - scanning any base images in use. Tanzu Application Platform image scanning can recognize and scan the OS packages from a base image.
    - scanning running software in test, stage, and production environments at a regular cadence.
    - generating accurate provenance at any level so that scanners have a complete picture of the dependencies to scan. 
    This is where a software bill of materials (SBoM) comes into play. To help you automate this process, VMware Tanzu Build Service, 
    leveraging Cloud Native Buildpacks, generates an SBoM for buildpack-based projects. 
    Because this SBoM is generated during the image building stage, it is more accurate and complete than one generated earlier or later in the release life cycle. 
    This is because it can highlight dependencies introduced at the time of build that might introduce potential for compromise.
- Scan by using multiple scanners to maximize CVE coverage.
- Practice keeping your dependencies up-to-date.
- Reduce overall surface area of attack by:
  - using smaller dependencies.
  - reducing the amount of third-party dependencies when possible.
  - using distroless base images when possible.
- Maintain a central record of false positives to ease CVE triaging and remediation efforts.
