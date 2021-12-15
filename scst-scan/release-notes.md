# Release notes

This topic contains release notes for Supply Chain Security Tools – Scan.

## v1.0.0

**Release Date:** December 10, 2021


### New in this release

* Enhanced scanning coverage is now available for Node.js apps.
* CA certificates are now automatically imported from the Metadata Store namespace


### Known issues

This release has these known issues:

* **Failing Blob source scans:**
Blob Source Scans have an edge case where, when a compressed file without a `.git` directory is
provided, sending results to the Supply Chain Security Tools - Store fails and the scanned revision
value is not set.
The current workaround is to add the `.git` directory to the compressed file.
The fix for this issue is planned for after Supply Chain Security Tools – Scan reaches general
availability.

* **Events show `SaveScanResultsSuccess` incorrectly:**
`SaveScanResultsSuccess` appears in the events when the Supply Chain Security Tools - Store is not
configured.
The `.status.conditions` output, however, correctly reflects `SendingResults=False`.
The fix for this issue is planned for after Supply Chain Security Tools – Scan reaches general
availability.

* **Scanning Java source code does not reveal vulnerabilities unless binary is included:**
When scanning a Java source code directory, Grype does not use the `pom.xml` or `build.gradle` files
to determine packages to scan for vulnerabilities.
Instead, it scans the built binary (`.jar` or `.war` files) directly.
The ScanLink Source Scan either clones a Git repository or downloads a compressed archived and then
scans without building in between. As such, vulnerabilities are not found in the Source Scan unless
the built binary is provided in the code repository or compressed archive.
The fix for this issue is planned for after Supply Chain Security Tools – Scan reaches general
availability.
Possible workarounds are:
    * Include the built binary in the source code repository or compressed archive.
    * Update the `ScanTemplate` to include an InitContainer after the `repo` InitContainer to build
    the binary.

* **Network Error during Scan may result in "hanging" scan:**
When scanning, `kubectl get sourcescan` or `kubectl get imagescan` may appear to hang with Phase set
to "Scanning". The pod logs instead may show an HTTP error. This is an error state that is not
properly propogating to the `sourcescan` or `imagescan` resource, which should instead have the Phase
set to "Error". The fix for this issue is planned for after Supply Chain Security Tools – Scan
reaches general availability. Since this is a normal error state that is not propogating, there is no
particular remediation. The error itself in the pod logs should provide some help in remediating,
which if it is a network flake, may include just deleting and reapplying the `sourcescan` or
`imagescan` resources.


## v1.0.0-beta.2

**Release Date:** November 25, 2021


## v1.0.0-beta

**Release Date:** October 07, 2021


### Additional considerations

Scanner templates require internet access to download the vulnerability database at scan time.
