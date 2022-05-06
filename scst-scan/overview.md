# Supply Chain Security Tools - Scan

## <a id="overview"></a>Overview

With Supply Chain Security Tools - Scan, Tanzu customers can build and deploy secure, trusted software that complies with their corporate security requirements. To enable this, Supply Chain Security Tools - Scan provides scanning and gatekeeping capabilities that Application and DevSecOps teams can easily incorporate earlier in their path to production as it is a known industry best practice for reducing security risk and ensuring more efficient remediation.

## <a id="use-cases"></a>Use cases

The following use cases apply to Supply Chain Security Tools - Scan:

* Using your scanner as a plug-in, scan source code repositories and images for known Common Vulnerabilities and Exposures (CVEs) before deploying to a cluster.
* Identify CVEs by continuously scanning each new code commit and/or each new image built.
* Analyze scan results against user-defined policies using Open Policy Agent.
* Produce vulnerability scan results and post them to the Supply Chain Security Tools - Store from where they can be queried.

## <a id="scst-scan-feat"></a>Supply Chain Security Tools - Scan features

The following Supply Chain Security Tools - Scan features make the use cases available:

* Kubernetes controllers to run scan jobs.
* Custom Resource Definitions (CRDs) for Image and Source Scan.
* CRD for a scanner plug-in. Provided example using: Anchore's Syft and Grype.
* CRD for policy enforcement.
* Enhanced scanning coverage by analyzing the Cloud Native Buildpack SBoMs provided by TBS images.

## <a id="scst-scan-note"></a>A Note on Vulnerability Scanners
While vulnerability scanning is an important practice in DevSecOps and the benefits of doing this well are widely recognized and accepted, it is important to remember that there are limitations present that impact its efficacy. Here we share some examples of these limitations that are prevalent in most scanners today:

#### <a id="missed-cves"></a>Missed CVEs
One of the biggest limitations of all vulnerability scanners is that there is no one tool that can find 100% of all CVEs, which means there will always be a risk that a missed CVE could get exploited. Some reasons for why this happens:
- The scanner is not aware of the vulnerability yet because it has only just been discovered and the CVE databases that the scanner is checking against are yet to be updated
- Scanners check different CVE sources based on detected package type and OS
- The scanner may not fully support a particular programming language, packaging system or manifest format
- The scanner may not implement binary analysis or fingerprinting
- The detected component doesn’t always include a canonical name and vendor, requiring the scanner to infer and attempt fuzzy matching
- When vendors register impacted software with NVD the provided information might not exactly match the values included in the release artifacts

#### <a id="false-positives"></a>False positives
Vulnerability scanners aren’t always able to access the information that they need to accurately identify whether a CVE exists. This often leads to an influx of false positives where the tool mistakenly flags something as a vulnerability when it isn’t. Unless a user is specialized in security or is deeply familiar with what is deemed to be a vulnerable component by the scanner, assessing and determining false positives becomes a challenging and time-consuming activity. Some reasons for a false positive flag:
- A component might be misidentified due to similar names
- A subcomponent might be identified as the parent component
- A component is correctly identified but the impacted functionality is not on a reachable code path
- A component’s impacted functionality is on a reachable code path but is not a concern due to the specific environment or configuration
- The version of a component might be incorrectly flagged as impacted
- The detected component doesn’t always include a canonical name and vendor, requiring the scanner to infer and attempt fuzzy matching

### <a id="protect-software"></a>So what can you do to protect yourselves and your software?
Although vulnerability scanning is not a perfect solution, it is an essential part of the process for keeping your organization secure – and there are measures you can take to maximize the benefits while minimizing the impact of the limitations.

- Scan more continuously and comprehensively to identify and remediate zero-day vulnerabilities quicker. Comprehensive scanning can be achieved by:
    - scanning earlier in the development cycle to ensure issues can be addressed more efficiently and do not delay a release. Tanzu Application Platform includes security practices such as source and container image vulnerability scanning earlier in the path to production for application teams
    - scanning any base images used. TAP image scanning includes the ability to recognize and scan the OS packages from a base image
    - scanning running software in test/stage/production environments at a regular cadence
    - generating accurate provenance at any level so that scanners have a complete picture of the dependencies to scan. This is where a software bill of materials (SBoM) comes into play. To help you automate this process, VMware Tanzu Build Service, leveraging Cloud Native Buildpacks, automatically generates an SBoM for Java- and Node.js-based projects. Since this SBoM is generated during the image building stage, it is more accurate and complete than one generated earlier or later in the release lifecycle. This is because it can highlight dependencies introduced at the time of build that could introduce potential for compromise
- Scan using multiple scanners to maximize CVE coverage
- Practice keeping your dependencies up-to-date
- Reduce overall surface area of attack by:
  - using smaller dependencies
  - reducing the amount of third party dependencies when possible
  - using distroless base images when possible
- Maintain a central record of false positives to ease CVE triaging and remediation efforts