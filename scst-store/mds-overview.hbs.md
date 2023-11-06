# Overview of Metadata Store

This topic gives you an overview of Metadata Store.

## <a id='overview'></a> Overview

Metadata Store saves software bills of materials (SBoMs) to a database and
allows you to query for image, source code, package, and vulnerability
relationships. Metadata Store integrates with
[Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically
store the resulting source code and image vulnerability reports. It accepts
CycloneDX input and outputs in both human-readable and machine-readable formats,
including JSON, text, and CycloneDX.

## <a id='using-insight'></a> Using the Tanzu Insight CLI plug-in

The Tanzu Insight CLI plug-in is the primary way to view results from the Supply Chain Security Tools (SCST) - Scan of source code and image files. Use it to query by source code commit, image digest, and CVE identifier to understand security risks.

For information about installing, configuring, and using `tanzu insight`, see [Tanzu Insight plug-in overview](../cli-plugins/insight/cli-overview.md).

## <a id='multicluster-config'></a> Multicluster configuration

You can configure Metadata Store in a multicluster setup.
See [Multicluster setup](multicluster-setup.hbs.md).

## <a id='integrate'></a> Integrating with Tanzu Developer Portal

By using the Supply Chain Choreographer in Tanzu Developer Portal, you can
visualize your supply chain. It uses to Metadata Store to show the packages and
vulnerabilities in your source code and images.

## <a id='additional-info'></a>Additional documentation

For more information about the API, deployment details and configuration, AWS RDS configuration, other database backup recommendations, and known issues, see [Additional documentation](additional.md).
