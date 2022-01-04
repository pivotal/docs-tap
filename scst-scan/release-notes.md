# Release notes

This topic contains release notes for Supply Chain Security Tools – Scan.

## v1.0.0

**Release Date:** December 10, 2021


### New in this release

Changes in this release include:

* Enhanced scanning coverage is available for Node.js apps
* CA certificates are automatically imported from the Metadata Store namespace


### Known issues

This release has these known issues:

* **Failing Blob source scans:**
Blob Source Scans have an edge case where, when a compressed file without a `.git` directory is
provided, sending results to the Supply Chain Security Tools - Store fails and the scanned revision
value is not set. The current workaround is to add the `.git` directory to the compressed file.

* **Events show `SaveScanResultsSuccess` incorrectly:**
`SaveScanResultsSuccess` appears in the events when the Supply Chain Security Tools - Store is not
configured. The `.status.conditions` output, however, correctly reflects `SendingResults=False`.

* **Scan Phase indicates `Scanning` incorrectly:**
Scans have an edge case where, when an error has occurred during scanning, the Scan Phase field does
not get updated to `Error` and instead remains in the `Scanning` phase.
Read the scan Pod logs to verify there was an error.

* **CVE print columns are not populated:**
After running a scan and using `kubectl get` on the scan, the CVE print columns (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN, CVETOTAL) are not populated. Query the metadata store for full CVE results.

### Known limitations with Grype scanner

**Scanning Java source code may not reveal vulnerabilities:**
Source Code Scanning only scans files present in the source code repository.
No network calls are made to fetch dependencies.

For languages that make use of dependency lock files, such as Golang and Node.js, Grype uses the lock
files to check the dependencies for vulnerabilities.
In the case of Java, dependency lock files are not guaranteed, so Grype instead uses the dependencies
present in the built binaries (`.jar` or `.war` files).

Because best practices do not include committing binaries to source code repositories, Grype fails to
find vulnerabilities during a Source Scan. The vulnerabilities are still found during the Image Scan,
after the binaries are built and packaged as images.


## v1.0.0-beta.2

**Release Date:** November 25, 2021


## v1.0.0-beta

**Release Date:** October 07, 2021


### Additional considerations

Scanner templates require internet access to download the vulnerability database at scan time.
