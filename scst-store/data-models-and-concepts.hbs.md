# Data models and concepts for Supply Chain Security Tools - Store

This topic describes the different data models and concepts the Supply Chain Security Tools (SCST) - Store uses for consuming and providing information.

## <a id='overview'></a> Overview

This diagram shows an overview of the SCST - Store data models and their relations.

![Screenshot of a SCST -Store Data Model Overview.](images/scst-store-data-model-overview.jpg)

## <a id='sbom-per-build'></a> Software Bill of Material per build

Originally, the SCST - Store aggregated the data of all vulnerability scans
submitted to it. This allowed users to see information from all scan results
against an image or source. However, users couldn't retrieve information against
an image or source from a specific vulnerability scan. For example, a user can't
know from which vulnerability scan a specific CVE might have surfaced from. This
is why VMware introduced Software Bill of Material per build for SCST - Store.

![Screenshot of the SCST - Store SBOM per Build concept](images/sbom-per-build.jpg)

Items in blue are the new information saved with each vulnerability scan.

With each vulnerability scan submitted, the SCST - Store creates an internal
report, which keeps track of the following from the vulnerability scan:

- The specific image or source
- Which packages were listed
- Which vulnerabilities were listed
- Which ratings were listed

Users can then search for all reports against an image or source with [query for a list of reports](api.hbs.md#span-idv1-search-reportsspan-query-for-a-list-of-reports-with-specified-image-digest-source-sha-or-original-location-v1searchreports).

After a report is located, a query for a specific report retrieves the information for that report. See [Paths](api.hbs.md#span-idv1-get-reportspan-get-a-specific-report-by-its-unique-identifier-v1getreport).

## <a id='triage'></a> Vulnerability triage

The new Triage feature of Tanzu Application Platform allows you to store vulnerability analysis
information alongside the current data handled by SCST - Store. Using the Tanzu
Insight CLI, users can now perform basic triaging functions against any
detected vulnerabilities. The main objective is to reduce spreadsheet and
tool toil by centralizing CVE scanning, identification, and triaging in
one place.

![Screenshot of the SCST - Store Triage concept](images/triage.jpg)

Items in orange are the new information saved for vulnerability analysis.
You can create, view, and update vulnerability analysis using the [Tanzu CLI
Insight plug-in](../cli-plugins/insight/triaging-vulnerabilities.md).

See [API resource](api.hbs.md#v1triage).