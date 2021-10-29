# Supply Chain Security Tools for VMware Tanzu – Store

Supply Chain Security Tools - Store saves software bills of materials (SBoMs) to a database and allows you to query for image, source, package, and vulnerability relationships.  It integrates with [Supply Chain Security Tools - Scan](../scst-scan/overview.md) to automatically store the resulting source and image vulnerability reports.

Supply Chain Security Tools - Store has three components:

* Postgres database
* API
* CLI (`insight`)

## Installation

Supply Chain Security Tools - Store is released as an individual Tanzu Application Platform component.  

To install, see [Install Supply Chain Security Tools - Store](../install-components.md#install-scst-store)

> **Note:** the `insight` CLI requires a [separate installation](../scst-store/cli.md)

For more information, see [Installation Details](../scst-store/install_details.md).

## Set Up

### <a id='required-set-up'></a> Required

The following steps are required to use the API or CLI:

* [Enable encryption and connection](enable_encrypted_connection.md)
* [Create a service account and get the access token](create_service_account_access_token.md)

### Recommended

The `insight` CLI is not required but may provide an easier-to-use interface than the API.  

> **Note:** the `insight` CLI is separate from the `tanzu` CLI.  It will be added as a `tanzu` CLI plugin in a future release

* [Install the CLI](cli.md)
* [Configure the CLI](configure_cli.md)

## Usage

### Adding Data

See [adding data](add_cyclonedx_to_store.md) to post CycloneDX scan reports to the Supply Chain Security Tools - Store

### Querying Data

See [querying data](querying_the_metadata_store.md) understand vulnerability, image, and dependency relationships

## Known Issues

See [Troubleshooting and Known Issues](known_issues.md).
