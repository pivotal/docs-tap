# Overview of Supply Chain Security Tools for Tanzu – Store

This topic gives you an overview of Supply Chain Security Tools (SCST) – Store.

## Overview

Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and allows you to query for image, source code, package, and vulnerability relationships.  It integrates with [Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically store the resulting source code and image vulnerability reports. It accepts CycloneDX input and outputs in both human-readable and machine-readable formats, including JSON, text, and CycloneDX.

The following is a quick demo of configuring the tanzu insight plug-in and querying the metadata store for CVEs and scan results.

<iframe width="480" height="270"
src="https://www.youtube.com/embed/qBBv3YKwH2E"
frameborder="0" allow="autoplay; encrypted-media" allowfullscreen
alt="A demonstration of the tanzu insight cli plug-in. Querying for the supply chain scan results and vulnerabilities stored in the metadata store."></iframe>

## Using the Tanzu Insight CLI plug-in

the Tanzu Insight CLI plug-in is the primary way to view results from the Supply Chain Security Tools - Scan of source code and image files.  Use it to query by source code commit, image digest, and CVE identifier to understand security risks.  

See [Tanzu Insight plug-in overview](../cli-plugins/insight/cli-overview.md) to install, configure, and use `tanzu insight`.

## Multicluster configuration

See [Multicluster setup](multicluster-setup.hbs.md) for information about how to set up SCST - Store in a multicluster setup.

## Integrating with Tanzu Application Platform GUI

Using the Supply Chain Choreographer in Tanzu Application Platform GUI, you can visualize your supply chain.
It uses SCST - Store to show the packages and vulnerabilities in your source code and images.

To enable this feature, see [Supply Chain Choreographer in Tanzu Application Platform GUI - Enable CVE scan results](../tap-gui/plugins/scc-tap-gui.hbs.md#scan).

## <a id='additional-info'></a>Additional documentation

[Additional documentation](additional.md) includes information about the API, deployment details and configuration, AWS RDS configuration, other database backup recommendations, known issues, and other topics.
