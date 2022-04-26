# Spec reference

With the Scan Controller and Grype Scanner installed (see Install Supply Chain Security Tools - Scan
from [Installing Individual Packages](../install-components.html#install-scst-scan),
the following Custom Resource Definitions (CRDs) are now available:

```console
$ kubectl get crds | grep scanning.apps.tanzu.vmware.com
imagescans.scanning.apps.tanzu.vmware.com                2021-09-09T15:22:07Z
scanpolicies.scanning.apps.tanzu.vmware.com              2021-09-09T15:22:07Z
scantemplates.scanning.apps.tanzu.vmware.com             2021-09-09T15:22:07Z
sourcescans.scanning.apps.tanzu.vmware.com               2021-09-09T15:22:07Z
```

## <a id="about-src-and-image-scans"></a>About source and image scans

Both SourceScan (`sourcescans.scanning.apps.tanzu.vmware.com`) and ImageScan (`imagescans.scanning.apps.tanzu.vmware.com`) define what will be scanned, and ScanTemplate (`scantemplates.scanning.apps.tanzu.vmware.com`) will define how to run a scan. We have provided five custom resources (CRs) pre-installed for use. You can either use them as-is or as samples to create your own.

To view the pre-installed Scan Template CRs, run:

```console
kubectl get scantemplates
```

You will see the following scan templates:

| CR Name | Use Case|
|---|---|
|`public-source-scan-template`|Clones and scans source code from a public repository.|
|`private-source-scan-template`|Connects with SSH credentials to clone and scan source code from a private repository.|
|`public-image-scan-template`|Pulls and scans images from a public registry.|
|`private-image-scan-template`|Connects with the registry credentials to pull and scan images from a private registry.|
|`blob-source-scan-template`|To be used in a Supply Chain. Gets a `.tar.gz` available file with `wget`, uncompresses it, and scans the source code inside it.|

By default, three scan templates are deployed (`public-source-scan-template`,
  `public-image-scan-template`, and `blob-source-scan-template`).

If `targetImagePullSecret` is set in `tap-values.yaml`, `private-image-scan-template` is also deployed.
If `targetSourceSshSecret` is set in `tap-values.yaml`, `private-source-scan-template` is also deployed.

The private scan templates reference secrets created using the Docker server and credentials you
provided, which means they are ready to use immediately.

For more information about the `SourceScan` and `ImageScan` CRDs and how to customize your own, refer to [Configuring Code Repositories and Image Artifacts to be Scanned](scan-crs.md).

## <a id="policy-enforcement-vuln"></a>About policy enforcement around vulnerabilities found

The Scan Controller supports policy enforcement by using an Open Policy Agent (OPA) engine. ScanPolicy (`scanpolicies.scanning.apps.tanzu.vmware.com`) allows scan results to be validated for company policy compliance and can prevent source code from being built or images from being deployed.

For more information, see [Configuring Policy Enforcement using Open Policy Agent (OPA)](policies.md).
