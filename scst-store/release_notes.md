# Release notes

This topic contains release notes for Supply Chain Security Tools - Store.


## v1.0.0-beta.1

**Release Date**: November 8, 2021

### Software component versions

* PostgresSQL 13.4

### New features

* Added a /health endpoint and `insight health` command
* Upgraded to golang 1.17
* Added support for query parameters
* Updated repository parsing logic
* Squashed some minor bugs

### Known issues

See [Troubleshooting and Known Issues](known_issues.md).

### Limitations

- Air gapped environments are not supported

## v1.0.0-beta.0

**Release Date**: October 07, 2021

### Software component versions

* PostgresSQL 13.4

### New features

* Store SBOM, CVE, and metadata about images and source code
* Query relationships between images, packages, and CVEs, and source code
* Support for CycloneDX SBOM format.
* Command Line Interface (CLI)
* Authentication using Kubernetes Service Accounts
* Encrypted connection between client and API server
* Encrypted connection between API server and database

### Known issues

See [Troubleshooting and Known Issues](known_issues.md).

### Limitations

- Air gapped environments are not supported