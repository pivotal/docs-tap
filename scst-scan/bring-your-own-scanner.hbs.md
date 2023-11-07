# Bring your own scanner with Supply Chain Security Tools - Scan 2.0

This topic tells you how to bring your own scanner to use with Supply Chain Security Tools (SCST) - Scan 2.0.

## <a id="overview"></a>Overview

Supply Chain Security Tools (SCST) - Scan 2.0 includes integrations with Trivy and Grype and examples for the following container image scanning tools:

- [Trivy](ivs-trivy.hbs.md)
- [Prisma](ivs-prisma.hbs.md)
- [Snyk](ivs-snyk.hbs.md)
- [Carbon Black Cloud](ivs-carbon-black.hbs.md)

You might have an existing investment in a scan solution that VMware does not have a published integration with, but Scan 2.0 makes building an integration to bring your own scanner easy. To bring your own scanner to the Tanzu Application Platform:

1. [Create an ImageVulnerabilityScan](ivs-create-your-own.hbs.md): Create an ImageVulnerabilityScan template that tells the Tanzu Application Platform how to run your scanner.
2. [Verify your ImageVulnerabilityScan](verify-app-scanning.hbs.md): Verify that your ImageVulnerabilityScan is working correctly so that downstream Tanzu Application Platform services work correctly.
3. [Wrap your ImageVulnerabilityScan in a ClusterImageTemplate](clusterimagetemplates.hbs.md): The ClusterImageTemplate wraps the ImageVulnerabilityScan and allows the Tanzu Application Platform supply chain to run the scan job.

## <a id="prerequisities"></a>Prerequisites

Tanzu Application Platform users must have the following prerequisites:

- Provide a Vulnerability Scanner Image either by:
  - Using a publicly available image that contains the scanner CLI.
    - For example, the official Aqua image for Trivy from [Dockerhub](https://hub.docker.com/r/aquasec/trivy/tags).
  - Building your own image with the scanner CLI, which allows for:
    - A more customizable scanning experience.
      - For example, you can create an image with the scanner CLI with any dependencies required to run the scanner CLI.
    - Managing your image to meet the Tanzu Application Platform user's compliance standards.
- Know how your preferred scanner works. For example, commands to use to call scan results.
