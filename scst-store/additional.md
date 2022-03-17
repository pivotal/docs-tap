# Additional resources

See [Supply Chain Security Tools for Tanzu – Store](overview.md) for overview information.

## <a id='install'></a>Install

Supply Chain Security Tools - Store is released as an individual Tanzu Application Platform component.

To install, see [Install Supply Chain Security Tools - Store](install-scst-store.md).  It will install the Postgres database and an [API](api.md) backend.

> **Note:** The Insight CLI requires a [separate installation](cli_installation.md).

For more information, see [Deployment Details and Configuration](deployment_details.md).

## <a id='query-data'></a>Querying the database

The following steps are required to use the API or CLI:

* [Creating service accounts and access tokens](create_service_account_access_token.md)
* [Using encryption to connect to the database](using_encryption_and_connection.md)

The Insight CLI is the recommended means to query the database.

> **Note:** The Insight CLI is in beta and is separate from the Tanzu CLI. It still works with the production version of Supply Chain Security Tools - Store.

* [CLI installation](cli_installation.md)
* [CLI configuration](cli_configuration.md)
* [CLI details](cli_docs/insight.md)

### <a id='addquery-data'></a>Adding & querying data

See [Add data](add_data.md) to post CycloneDX scan reports to the Supply Chain Security Tools - Store.

See [Query data](query_data.md) to understand vulnerability, image, and dependency relationships.

## <a id='audit'></a>Auditing

The API server outputs logs when an endpoint is accessed, which can be used for auditing purposes. For information about the logs generated, see [Log configuration and usage](logs.md).

## <a id='known-issues'></a>Known issues

See [Troubleshooting and Known Issues](known_issues.md).

## <a id='security'></a>Security

See [Security](security.md).

## <a id='backup'></a>Backing up data

See [Backup suggestions](backups.md).

## <a id='fail-red'></a>Failover and redundancy

See [Failover, redundancy, and backups](failover.md).
