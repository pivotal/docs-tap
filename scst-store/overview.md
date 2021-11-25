# Supply Chain Security Tools for Tanzu – Store

Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and allows you to query for image, source, package, and vulnerability relationships.  It integrates with [Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically store the resulting source and image vulnerability reports.

<iframe width="480" height="270"
src="https://www.youtube.com/embed/UoWSsJBjFgc"
frameborder="0"  allow="autoplay; encrypted-media"  allowfullscreen></iframe>

Supply Chain Security Tools - Store has three components:

* Postgres database
* [API](api.md)
* CLI (`insight`)

## Install

Supply Chain Security Tools - Store is released as an individual Tanzu Application Platform component.

To install, see [Install Supply Chain Security Tools - Store](../install-components.md#install-scst-store).  It will install the Postgres database and an [API](api.md) backend.

> **Note:** the `insight` CLI requires a [separate installation](install_cli.md)

For more information, see [Deployment Details](deployment_details.md).

## <a id='required-set-up'></a>Set up

### Required

The following steps are required to use the API or CLI:

* [Using encryption and connection](using_encryption_and_connection.md)
* [Create a service account and get the access token](create_service_account_access_token.md)

### Recommended

The `insight` CLI is not required but may provide an easier-to-use interface than the [API](api.md).  

> **Note:** the `insight` CLI is separate from the `tanzu` CLI.  It will be added as a `tanzu` CLI plugin in a future release

* [Install the CLI](install_cli.md)
* [Configure the CLI](configure_cli.md)

## <a id='usage'></a>Usage

### Adding data

See [adding data](add_cyclonedx_to_store.md) to post CycloneDX scan reports to the Supply Chain Security Tools - Store

### Querying data

See [querying data](querying_the_metadata_store.md) understand vulnerability, image, and dependency relationships

## Known issues

See [Troubleshooting and Known Issues](known_issues.md).

## Security

See [Security](security.md)
