# Release notes

This topic contains release notes for Supply Chain Security Tools – Scan.

## v1.0.0

**Release Date:** December 10, 2021


### New in this release

* Enhanced scanning coverage is now available for Node.js apps.
* CA certificates are now automatically imported from the Metadata Store namespace


### Known issues

* **Failing Blob source scans:**
Blob Source Scans have an edge case where, when a compressed file without a `.git` directory is
provided, sending results to the Supply Chain Security Tools - Store fails and the scanned revision
value is not set. The current workaround is to add the `.git` directory to the compressed file. The
fix for this issue is planned for after Supply Chain Security Tools – Scan reaches general
availability.

* **Events show `SaveScanResultsSuccess` incorrectly:**
`SaveScanResultsSuccess` appears in the events when the Supply Chain Security Tools - Store is not
configured. The `.status.conditions` output, however, correctly reflects `SendingResults=False`. The
fix for this issue is planned for after Supply Chain Security Tools – Scan reaches general
availability.

* **Scan Phase indicates `Scanning` incorrectly:**
Scans have an edge case where, when an error has occurred during scanning, the Scan Phase field does
not get updated to `Error` and instead remains in the `Scanning` phase. Check the scan pod logs to
verify if there was an error. The fix for this issue is planned for after Supply Chain Security Tools
– Scan reaches general availability.

### Known limitations with Grype scanner

* **Scanning Java source code may not reveal vulnerabilities:**
Source Code Scanning will only scan files present in the source code repository (ie they will not
make network calls to fetch dependencies). For languages that make use of dependency lock files (ie Golang and Node.js), Grype will use these lock files to check the dependencies for vulnerabilities.
In the case of Java, dependency lock files are not guaranteed, so Grype will instead use the
dependencies present in the built binaries (`.jar` or `.war` files). Since best practices do not
include committing binaries to source code repositories, Grype will fail to find vulnerabilities
during a Source Scan. The vulnerabilities will still be found during the Image Scan, after the
binaries are built and packaged as images. The fix for this issue is planned for after Supply Chain
Security Tools – Scan reaches general availability.


## v1.0.0-beta.2

**Release Date:** November 25, 2021


## v1.0.0-beta

**Release Date:** October 07, 2021


### Additional considerations

Scanner templates require internet access to download the vulnerability database at scan time.
