# Reference
With the Scan Controller and Scanner installed (see Install Supply Chain Security Tools - Scan from [Installing Part II: Packages](../install.md#install-supply-chain-security-tools--scan-8)), the following Custom Resource Definitions (CRDs) are now available.
```console
$ kubectl get crds | grep scanning.apps.tanzu.vmware.com
imagescans.scanning.apps.tanzu.vmware.com                2021-09-09T15:22:07Z
scanpolicies.scanning.apps.tanzu.vmware.com              2021-09-09T15:22:07Z
scantemplates.scanning.apps.tanzu.vmware.com             2021-09-09T15:22:07Z
sourcescans.scanning.apps.tanzu.vmware.com               2021-09-09T15:22:07Z
```

## About Source and Image Scans
Both SourceScan (`sourcescans.scanning.apps.tanzu.vmware.com`) and ImageScan (`imagescans.scanning.apps.tanzu.vmware.com`) define what will be scanned and ScanTemplate (`scantemplates.scanning.apps.tanzu.vmware.com`) will define how to run a scan. We have provided five custom resources (CRs) pre-installed for use. You can either use them as-is, or as samples to create your own.

To view the pre-installed Scan Template CRs, run:
```console
$ kubectl get scantemplates
```

And you will see the following scan templates:
| CR Name | Use Case|
|---|---|
|`public-source-scan-template`|Will clone and scan source code from a public repository.|
|`private-source-scan-template`|Will connect with ssh credentials to clone and scan source code from a private repository.|
|`public-image-scan-template`|Will pull and scan images from a public registry.|
|`private-image-scan-template`|Will connect with the registry credentials to pull and scan images from a private registry.|
|`blob-source-scan-template`|To be used in a Supply Chain. It will get a `.tar.gz` available file with `wget`, uncompress it and scan the source code inside it.|

The private scan templates are referencing secrets created using the docker server and credentials you provided, so they are ready to use out-of-the-box. We will make use of them when running the samples.

For more information, refer to [How to Create a ScanTemplate](create-scan-template.md).

For more detailed information on the `SourceScan` and `ImageScan` CRDs and how to customize your own, refer to [Configuring Code Repositories and Image Artifacts to be Scanned](scan-crs.md).

## About Policy Enforcement around Vulnerabilities Found
The Scan Controller supports policy enforcement by using an Open Policy Agent (OPA) engine. ScanPolicy (`scanpolicies.scanning.apps.tanzu.vmware.com`) allows scan results to be validated for company policy compliance and can prevent source code from being built or images from being deployed.

For more information, refer to [Configuring Policy Enforcement using Open Policy Agent (OPA)](policies.md).
