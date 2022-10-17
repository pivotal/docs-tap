# Security Analysis in Tanzu Application Platform GUI

This topic describes the Security Analysis plug-in.

## <a id="overview"></a> Overview

The Security Analysis plug-in summarizes vulnerability data across all workloads running in
Tanzu Application Platform, enabling faster identification and remediation of CVEs.

## <a id="install"></a> Installing and configuring

The Security Analysis plug-in is installed by default.
It is tightly coupled with the [Supply Chain Choregrapher plug-in](scc-tap-gui.hbs.md).
After installing and configuring the Supply Chain Choreographer GUI plug-in, there is no additional
configuration needed for the Security Analysis plug-in.

The Security Analysis plug-in is part of the Tanzu Application Platform Full and View profiles.

## <a id="accessing"></a> Accessing the plug-in

The Security Analysis plug-in is always accessible from the left navigation panel.
Click the **Security Analysis** button to open the Security Analysis dashboard.

![Accessing the Security Analysis GUI](images/sagui-access-plug-in.png)

## <a id="viewing"></a> Viewing vulnerability data

The **Security Analysis** dashboard provides a summary of all vulnerabilities across all clusters
for single-cluster and multi-cluster deployments.

<!-- ![Viewing workload build vulnerabilities](images/sagui-view-vulns.png) Where is this file? -->

The **Vulnerabilities by Severity** widget quickly counts the number of critical, high, medium,
low, and unknown severity CVEs, based on the CVSS severity rating of each CVE.

It includes a sum of all workloads' source and image scan vulnerabilities.
For example, if CVE-123 exists in Workload ABC's and Workload DEF's latest source scans and image
scans, it is counted four times.

> **Note:** The sum includes any CVEs on the allowlist (ignoreCVEs).

The **Workload Build Vulnerabilities** tables, with the **Violates Policy** tab and **Does Not Violate**
tab, separate workloads based on the [scan policy](../../scst-scan/policies.hbs.md).
The Unique CVEs column uses the same sum logic as described earlier, but for individual workloads.

> **Note:** The sum of a workload's CVEs might not match the
> [Supply Chain Choreographer's Vulnerability Scan Results](scc-tap-gui.hbs.md#sc-view-scan-results).
> The data on this dashboard is based on the totals of individual scan results.
> The data on the Supply Chain Choreographer's Vulnerability Scan Results is based on vulnerabilities
> across all of the Metadata Store.

 >**Note:** Only vulnerability scans associated to a Cartographer workload will appear.  Use [`tanzu insight`](../../cli-plugins/insight/cli-overview.hbs.md) to view results for non-workload scan results.

## <a id="accessing-details"></a> Viewing CVE and package details

The Security Analysis plug-in has a **CVE** page and a **Package** page.
These are accessed by clicking on a workload name, which opens the Supply Chain Choregrapher plug-in.
Clicking on the CVE or Package name opens the **CVE** or **Package** page, respectively.

![Navigating to Security Analysis details pages](images/sagui-navigate-1.png)

![Navigating to Security Analysis details pages](images/sagui-navigate-2.png)

The **CVE** page contains basic information about the vulnerability and includes a table with
all affected packages and versions.

![CVE Details page](images/sagui-cve-details.png)

The **Package** page contains basic information about a package and includes a table with all
CVEs and the affected package versions.

![Package Details page](images/sagui-package-details.png)