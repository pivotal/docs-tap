# Supply Chain Security Tools for Tanzu – Store

Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and allows you to query for image, source, package, and vulnerability relationships.  It integrates with [Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically store the resulting source and image vulnerability reports. It accepts any CycloneDX input and outputs in both human-readable and machine-readable formats, including JSON, text, and CycloneDX.


The following is a four-minute demo of scanning an image for CVEs and querying the database for CVEs and dependencies.

<iframe width="480" height="270"
src="https://www.youtube.com/embed/UoWSsJBjFgc"
frameborder="0" allow="autoplay; encrypted-media" allowfullscreen
alt="A demonstration of the features. First ingesting a bill of materials file. Then investigating vulnerabilities of different images."></iframe>

## Using the `insight` CLI plug-in

>**Note:** To install and configure the `insight` CLI plug-in, you must install the Supply Chain Security Tools - Store, either as its own package, or as part of Tanzu Application Platform Build profile or Tanzu Application Platform View profile.

1. [CLI installation](cli_installation.md)
1. [Configure target endpoint and certificate](using_encryption_and_connection.md)
1. [Configure access tokens](create_service_account_access_token.md)
1. [Query data](query_data.md)

## Additional Resources

* <a id='security'></a>[Security documentation](security.md).
* [Additional resources](additional.md) for more information.
