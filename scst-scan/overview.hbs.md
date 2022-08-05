# Supply Chain Security Tools - Scan

## <a id="overview"></a>Overview

With Supply Chain Security Tools - Scan, you can build and deploy 
secure, trusted software that complies with your corporate security requirements. 
Supply Chain Security Tools - Scan provides scanning and gatekeeping capabilities 
that Application and DevSecOps teams can incorporate early in their path to 
production as it is a known industry best practice for reducing security risk 
and ensuring more efficient remediation.

## <a id="use-cases"></a>Use cases

The following use cases apply to Supply Chain Security Tools - Scan:

- Use your scanner as a plug-in, scan source code repositories and images for known Common Vulnerabilities and Exposures (CVEs) before deploying to a cluster.
- Identify CVEs by continuously scanning each new code commit or each new image built.
- Analyze scan results against user-defined policies by using Open Policy Agent.
- Produce vulnerability scan results and post them to the Supply Chain Security Tools - Store from where they are queried.

## <a id="scst-scan-feat"></a>Supply Chain Security Tools - Scan features

The following Supply Chain Security Tools - Scan features enable the [Use cases](#use-cases):

- Kubernetes controllers to run scan jobs.
- Custom Resource Definitions (`CRD`s) for Image and Source Scan.
- `CRD` for a scanner plug-in. Example is available by using Anchore's Syft and Grype.
- `CRD` for policy enforcement.
- Enhanced scanning coverage by analyzing the Cloud Native Buildpack SBoMs that Tanzu Build Service images provide.

## <a id="scst-scan-note"></a>A Note on Vulnerability Scanners

Although vulnerability scanning is an important practice in DevSecOps and 
the benefits of it are widely recognized and accepted, it is important to 
remember that there are limitations present that impact its efficacy. 
The following examples illustrate the limitations that are prevalent in most scanners today:

#### <a id="missed-cves"></a>Missed CVEs

One limitation of all vulnerability scanners is that there is 
no one tool that can find 100% of all CVEs, which means there is always a risk 
that a missed CVE can be exploited. Some reasons for missed CVEs include:

- The scanner does not detect the vulnerability because it is just discovered and the CVE databases that the scanner checks against are not updated yet.
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
- A subcomponent might be identified as the parent component.
- A component is correctly identified but the impacted function is not on a reachable code path.
- A component’s impacted function is on a reachable code path but is not a concern due to the specific environment or configuration.
- The version of a component might be incorrectly flagged as impacted.
- The detected component does not always include a canonical name and vendor, requiring the scanner to infer and attempt fuzzy matching.

So what can you do to protect yourselves and your software?

Although vulnerability scanning is not a perfect solution, it is an essential part 
of the process for keeping your organization secure. 
You can take the following measures to maximize the benefits while minimizing 
the impact of the limitations:

- Scan more continuously and comprehensively to identify and remediate zero-day vulnerabilities quicker. Comprehensive scanning can be achieved by:
    - scanning earlier in the development cycle to ensure issues can be addressed more efficiently and do not delay a release. 
    Tanzu Application Platform includes security practices such as source and container image vulnerability scanning earlier in the path to production for application teams.
    - scanning any base images in use. Tanzu Application Platform image scanning includes the ability to recognize and scan the OS packages from a base image.
    - scanning running software in test, stage, and production environments at a regular cadence.
    - generating accurate provenance at any level so that scanners have a complete picture of the dependencies to scan. 
    This is where a software bill of materials (SBoM) comes into play. To help you automate this process, VMware Tanzu Build Service, 
    leveraging Cloud Native Buildpacks, generates an SBoM for Java and Node.js based projects. 
    Since this SBoM is generated during the image building stage, it is more accurate and complete than one generated earlier or later in the release life cycle. 
    This is because it can highlight dependencies introduced at the time of build that might introduce potential for compromise.
- Scan by using multiple scanners to maximize CVE coverage.
- Practice keeping your dependencies up-to-date.
- Reduce overall surface area of attack by:
  - using smaller dependencies.
  - reducing the amount of third party dependencies when possible.
  - using distroless base images when possible.
- Maintain a central record of false positives to ease CVE triaging and remediation efforts.
