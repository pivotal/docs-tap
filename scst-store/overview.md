# Supply Chain Security Tools for Tanzu – Store

Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and allows you to query for image, source code, package, and vulnerability relationships.  It integrates with [Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically store the resulting source code and image vulnerability reports. It accepts CycloneDX input and outputs in both human-readable and machine-readable formats, including JSON, text, and CycloneDX.


The following is a four-minute demo of scanning an image for CVEs and querying the database for CVEs and dependencies.

<iframe width="480" height="270"
src="https://www.youtube.com/embed/UoWSsJBjFgc"
frameborder="0" allow="autoplay; encrypted-media" allowfullscreen
alt="A demonstration of the features. First ingesting a bill of materials file. Then investigating vulnerabilities of different images."></iframe>

## Using the `tanzu insight` CLI plug-in

The `tanzu insight` CLI plug-in is the primary method to post and query the Supply Chain Security Tools - Store database.

Follow the below steps to install and configure `tanzu insight` CLI plug-in.

>**Note:** Prior to using the CLI plug-in, you must install the Supply Chain Security Tools - Store, either as its own package, or as part of Tanzu Application Platform Build profile or Tanzu Application Platform View profile.

1. [CLI plug-in installation](cli-installation.md)
1. [Configure target endpoint and certificate](using-encryption-and-connection.md)
1. [Configure access tokens](create-service-account-access-token.md)

Once `tanzu insight` CLI plug-in is set up:

1. [Add data](add-data.md)
1. [Query data](query-data.md)


## <a id='additional-info'></a>Additional documentation

- <a id='api'></a>[API](api.md)
- <a id='deploy'></a>[Deployment details and configuration](deployment-details.md)
- <a id='install-scst-store'></a>[Install Supply Chain Security Tools - Store independent from Tanzu Application Platform profiles](install-scst-store.md)
- <a id='aws-rds'></a>[AWS RDS Postgres configuration](use-aws-rds.md)
- <a id='audit'></a>[Log configuration and usage](logs.md)
- <a id='known-issues'></a>[Troubleshooting and Known Issues](known-issues.md)
- <a id='backup'></a>[Backup suggestions](backups.md)
- <a id='fail-red'></a>[Failover, redundancy, and backups](failover.md)

