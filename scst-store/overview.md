# Supply Chain Security Tools for Tanzu – Store

Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and allows you to query for image, source, package, and vulnerability relationships.  It integrates with [Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically store the resulting source and image vulnerability reports. It accepts any CycloneDX input and outputs in both human-readable and machine-readable formats, including JSON, text, and CycloneDX.


The following is a four minute demo of scanning an image for CVEs and querying the database for CVEs and dependencies.

<iframe width="480" height="270"
src="https://www.youtube.com/embed/UoWSsJBjFgc"
frameborder="0" allow="autoplay; encrypted-media" allowfullscreen
alt="A demonstration of the features. First ingesting a bill of materials file. Then investigating vulnerabilities of different images."></iframe>

Supply Chain Security Tools - Store has three components:

* [API](api.md)
* [CLI](install_cli.md) (Insight)
* Postgres database

## Install

Supply Chain Security Tools - Store is released as an individual Tanzu Application Platform component.

To install, see [Install Supply Chain Security Tools - Store](../install-components.md#install-scst-store).  It will install the Postgres database and an [API](api.md) backend.

> **Note:** the Insight CLI requires a [separate installation](install_cli.md)

For more information, see [Deployment Details and Configuration](deployment_details.md).

## <a id='required-set-up'></a>Set up

### Required

The following steps are required to use the API or CLI:

* [Using encryption and connection](using_encryption_and_connection.md)
* [Create a service account and get the access token](create_service_account_access_token.md)

### Recommended

The Insight CLI is not required but may provide an easier-to-use interface than the [API](api.md).  

> **Note:** The Insight CLI is in beta and is separate from the Tanzu CLI.

* [Install the CLI](install_cli.md)
* [Configure the CLI](configure_cli.md)

## <a id='usage'></a>Usage

### Adding data

See [adding data](add_cyclonedx_to_store.md) to post CycloneDX scan reports to the Supply Chain Security Tools - Store

### Querying data

See [querying data](querying_the_metadata_store.md) understand vulnerability, image, and dependency relationships

## Auditing

The API server outputs logs when an endpoint is accessed, and can be used for auditing purposes. For information about the logs generated, see [Configuring and Understanding Store Logs](logs.md).


## Known issues

See [Troubleshooting and Known Issues](known_issues.md).

## Security

See [Security](security.md)
