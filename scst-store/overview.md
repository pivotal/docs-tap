# Supply Chain Security Tools for Tanzu – Store

Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and allows you to query for image, source code, package, and vulnerability relationships.  It integrates with [Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically store the resulting source code and image vulnerability reports. It accepts CycloneDX input and outputs in both human-readable and machine-readable formats, including JSON, text, and CycloneDX.


The following is a four-minute demo of scanning an image for CVEs and querying the database for CVEs and dependencies.

<iframe width="480" height="270"
src="https://www.youtube.com/embed/UoWSsJBjFgc"
frameborder="0" allow="autoplay; encrypted-media" allowfullscreen
alt="A demonstration of the features. First ingesting a bill of materials file. Then investigating vulnerabilities of different images."></iframe>

## Using the `tanzu insight` CLI plug-in

The `tanzu insight` CLI plug-in is the primary way to view results from the Supply Chain Security Tools - Scan of source code and image files.  Use it to query by source code commit, image digest, CVE identifier to understand security risks.  

See [Tanzu Insight plug-in overview](../cli-plugins/insight/cli-overview.md) to install, configure and use `tanzu insight`.

## Multi-cluster configuration

See [Ingress and multicluster support](ingress-multicluster.md) to learn how to configure Supply Chain Security Tools Scan and Store in a multi-cluster setup.

## <a id='additional-info'></a>Additional documentation

[Additional documentation](additional.md) includes information about the API, deployment details and config, AWS RDS configuration and other database backup recommendations, known issues, among other topics.
