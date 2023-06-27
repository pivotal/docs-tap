# Data Models and Concepts

This topic describes the different data models and concepts the Supply Chain Security Tools (SCST) - Store uses for consuming and providing various information.

## <a id='overview'></a> Overview

The diagram below shows an overall view of the SCST - Store data models and their relations.

![Screenshot of a SCST -Store Data Model Overview.](images/scst-store-data-model-overview.jpg)

It includes the relations of the following concepts:
* Software Bill of Material per Build

## <a id='sbom-per-build'></a> Software Bill of Material per Build

Originally, the SCST - Store aggregated the data of all vulnerability scans submitted to it. This allowed users to see information from all scan results against an image or source.
However, users were not able to retrieve information against an image or source from a specific vulnerability scan. As such, for example, a user could not know from which specific
vulnerability scan a specific CVE may have surfaced from.

As such, SCST - Store introduced a concept of Software Bill of Material per Build (SBOM per build).

![Screenshot of the SCST - Store SBOM per Build concept](images/sbom-per-build.jpg)

Items in blue are the new information saved with each vulnerability scan.

With each vulnerability scan submitted, the SCST - Store creates an internal
report, which keeps track of the following from the vulnerability scan:
* The specific image or source
* Which packages were listed
* Which vulnerabilities were listed
* Which ratings were listed

Users can then search for all reports against an image or source with [query for a list of reports](api.hbs.md#span-idv1-search-reportsspan-query-for-a-list-of-reports-with-specified-image-digest-source-sha-or-original-location-v1searchreports).
Once a report is located, the information for that report can be retrieved with [query for a specific report](api.hbs.md#span-idv1-get-reportspan-get-a-specific-report-by-its-unique-identifier-v1getreport).
