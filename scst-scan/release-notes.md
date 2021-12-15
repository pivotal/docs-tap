# Release notes

This topic contains release notes for Supply Chain Security Tools – Scan.

## Releases

### v1.0.0

**Release Date:** December 10, 2021

### New in this Release

* Enhanced scanning coverage is now available for Node.js apps.
* CA certificates are now automatically imported from the Metadata Store namespace

### Known Issues

* **Failing Blob source scans:** Blob Source Scans have an edge case where, when a compressed file
without a `.git` directory is provided, sending results to the Supply Chain Security Tools - Store
fails and the scanned revision value is not set.
The current workaround is to add the `.git` directory to the compressed file.
The fix for this issue is planned for after Supply Chain Security Tools – Scan reaches general
availability.

* **Events show `SaveScanResultsSuccess` incorrectly** `SaveScanResultsSuccess` appears in the events
when the Supply Chain Security Tools - Store is not configured.
The `.status.conditions` output, however, correctly reflects `SendingResults=False`.
The fix for this issue is planned for after Supply Chain Security Tools – Scan reaches general  
availability.

### v1.0.0-beta.2

**Release Date:** November 25, 2021

### v1.0.0-beta

**Release Date:** October 07, 2021



## Additional considerations

* Our scanner templates require internet access to download the vulnerability database at scan time.
