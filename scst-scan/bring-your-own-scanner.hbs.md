# Bring Your Own Scanner with Supply Chain Security Tools - Scan 2.0.

## <a id="overview"></a>Overview

Supply Chain Security Tools - Scan 2.0 ships with an integration with Grype, as well as having published examples for the following container image scanning tools:

1. [Trivy](scst-scan/ivs-trivy.hbs.md)
2. [Prisma](scst-scan/ivs-prisma.hbs.md)
3. [Snyk](scst-scan/ivs-snyk.hbs.md)
4. [Carbon Black Cloud](scst-scan/ivs-carbon-black.hbs.md)

Given the vast ecosystem of container image scanning solutions, VMware realizes that every user may have an existing investment in a scan solution of which we do not have a published integration with.  Therefore, a core tenant of Scan 2.0 is to make building an integration to bring your own scanner easy.  Bringing your own scanner to the Tanzu Application Platform can be done following these steps:

1.  [Create an IVS Template](scst-scan/ivs-create-your-own.hbs.md): This step will walk you through how you can create an ImageVulnerabilityScan template that tells the Tanzu Application Platform how to execute your scanner
2.  [Verifying your IVS Template](scst-scan/verify-app-scanning.hbs.md):  This step will walk you through how you can validate that your ImageVulnerabilityScan is working correctly so that downstream Tanzu Application Platform Servers will work correctly.
3.  [Wrapping your IVSTemplate in a ClusterImageTemplate](scst-scan/clusterimagetemplates.hbs.md): The ClusterImageTemplate wraps the ImageVulnerabilityScan template and allows the Tanzu Application Platform supply chain to invoke the scan job.


