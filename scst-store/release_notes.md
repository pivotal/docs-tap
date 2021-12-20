# Release notes

This topic contains release notes for Supply Chain Security Tools - Store.

## v1.0.1

### Breaking changes

Changed package name to `metadata-store.apps.tanzu.vmware.com`

### Resolved issues

Upgrade golang version from `1.17.1` to `1.17.5`

### Known issues

See [Troubleshooting and Known Issues](known_issues.md).

### Limitations

Air-gapped environments are not supported.

### CVEs

No High or Critical CVEs were found in any of the components.
Components were scanned with Black Duck Binary Analysis and Grype.
For more information, see [SCA Scanning Results](sca_scans/CVE.md)

## v1.0.0-beta.2

### Software component versions

* PostgresSQL 13.4

### Breaking changes

* (possibly breaking) `storageClassName` and `databaseRequestStorage` fields have been changed to `storage_class_name` and `database_request_storage` respectively. This change was made to keep the format of all available fields consistent with other available fields.
* (possibly breaking) Change output for unhappy paths to be more consistent. Empty results due to sources not existing when searching by package or source information now returns an empty array with a 200 response. Previously it would give an error JSON with a 404.

### New features

* Add logs to Images, Vulnerabilities, Sources, and Package endpoints
* Supporting AWS RDS
* Add default read-only clusterrole
* Manually update go dependencies
* Export CA Cert to a specified namespace. By default, the CA Cert will be exported to the default namespace `scan-link-system`
* `db_password` is generated with secretgen when not provided by user
* Support cyclonedx 1.3

### Fixes

* Change DB and app service type
* Containers no longer need root user to run

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

## v1.0.0-beta.0

**Release Date**: October 07, 2021

### Software component versions

* PostgresSQL 13.4

### New features

* Store SBOM, CVE, and metadata about images and source code
* Query relationships between images, packages, and CVEs, and source code
* Support for CycloneDX SBOM format
* Command Line Interface (CLI)
* Authentication using Kubernetes Service Accounts
* Encrypted connection between client and API server
* Encrypted connection between API server and database
