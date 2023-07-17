# Bring your own scanner with Supply Chain Security Tools - Scan 2.0

This topic tells you how to bring your own scanner to use with Supply Chain Security Tools (SCST) - Scan 2.0.

## <a id="overview"></a>Overview

Supply Chain Security Tools (SCST) - Scan 2.0 includes an integration with Grype and examples for the following container image scanning tools:

- [Trivy](ivs-trivy.hbs.md)
- [Prisma](ivs-prisma.hbs.md)
- [Snyk](ivs-snyk.hbs.md)
- [Carbon Black Cloud](ivs-carbon-black.hbs.md)

You might have an existing investment in a scan solution that VMware does not have a published integration with, but Scan 2.0 makes building an integration to bring your own scanner easy. To bring your own scanner to the Tanzu Application Platform:

1.  [Create an ImageVulnerabilityScan](ivs-create-your-own.hbs.md): This step will walk you through how you can create an ImageVulnerabilityScan template that tells the Tanzu Application Platform how to execute your scanner
2.  [Verifying your ImageVulnerabilityScan](verify-app-scanning.hbs.md): This step will walk you through how you can validate that your ImageVulnerabilityScan is working correctly so that downstream Tanzu Application Platform Servers will work correctly.
3.  [Wrapping your ImageVulnerabilityScan in a ClusterImageTemplate](clusterimagetemplates.hbs.md): The ClusterImageTemplate wraps the ImageVulnerabilityScan and allows the Tanzu Application Platform supply chain to invoke the scan job.
