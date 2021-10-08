# Release Notes

This topic contains release notes for Supply Chain Security Tools - Store.

## Release v1.0.0-beta.0

**Release Date**: October 07, 2021

### Software Component Versions

* PostgresSQL 13.4

### Features

* Store SBOM, CVE, and metadata about images and source code
* Query relationships between images, packages, and CVEs, and source code
* Support for CycloneDX SBOM format.
* Command Line Interface (CLI)
* Authentication using Kubernetes Service Accounts
* Encrypted connection between client and API server
* Encrypted connection between API server and database

### Known Issues

See [Troubleshooting and Known Issues](known_issues.md).

### Limitations

- **Air Gap Not Supported:**
  Supply Chain Security Tools - Store does not support air gapping. 