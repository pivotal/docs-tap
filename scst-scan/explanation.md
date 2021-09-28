# About Scans and Policies (TODO: Rework title?)
With the Scan Controller and Scanner installed, the following Custom Resource Definitions (CRDs) are now available.
```console
$ kubectl get crds | grep scanning.apps.tanzu.vmware.com
imagescans.scanning.apps.tanzu.vmware.com                2021-09-09T15:22:07Z
scanpolicies.scanning.apps.tanzu.vmware.com              2021-09-09T15:22:07Z
scantemplates.scanning.apps.tanzu.vmware.com             2021-09-09T15:22:07Z
sourcescans.scanning.apps.tanzu.vmware.com               2021-09-09T15:22:07Z
```

## About Source and Image Scans
Both `SourceScan` (`sourcescans.scanning.apps.tanzu.vmware.com`) and `ImageScan` (`imagescans.scanning.apps.tanzu.vmware.com`) define what will be scanned and `ScanTemplate` (`scantemplates.scanning.apps.tanzu.vmware.com`) will define how to run a scan, five have been pre-installed for use, either for use as is, or as samples to create your own. 

You can view the Scan Template CRs that were pre-installed:
```console
$ kubectl get scantemplates
NAME                              AGE
blob-source-scan-template         20h
private-image-scan-template       20h
private-source-scan-template      20h
public-image-scan-template        20h
public-source-scan-template       20h
```

The use cases they cover are the following:
* `public-source-scan-template`: TODO: Fill in
...

They cover the use cases of both source and image scans from either a public or private repository/registry. An additional one for use in a Supply Chain is also provided. In particular, they have been installed referencing secrets created using the docker server and credentials you provided, so they are ready to use out of the box. We will make use of them when running the samples.

For more information, refer to [How to Create a ScanTemplate](create-scan-template.md).

For more detailed information on the `SourceScan` and `ImageScan` CRDs and how to customize your own, refer to [Configuring Code Repositories and Image Artifacts to be Scanned](scan-crs.md).

## About Policy Enforcement around Vulnerabilities Found
The Scan Controller supports policy enforcement by using an Open Policy Agent (OPA) engine. This allows scan results to be validated for company policy compliance and can prevent source code from being built or images from being deployed.

For more information, refer to [Configuring Policy Enforcement using Open Policy Agent (OPA)](policies.md).
