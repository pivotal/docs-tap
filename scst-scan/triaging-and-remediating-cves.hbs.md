# Triage and Remediate CVEs for Supply Chain Security Tools - Scan

This topic explains how you can triage and remediate CVEs related to SCST - Scan.

## <a id="sc-stop"></a>Confirming Supply Chain stopped due to failed policy enforcement

To confirm that Supply Chain failure is related to policy enforcement:

1. Verify that the status of the workload is `MissingValueAtPath` due to waiting on a `.status.compliantArtifact` from either the SourceScan or ImageScan:

  ```console
  kubectl describe workload WORKLOAD-NAME -n DEVELOPER-NAMESPACE
  ```

1. Describe the SourceScan or ImageScan to determine what CVE(s) violated the ScanPolicy:

  ```
  kubectl describe sourcescan NAME -n DEVELOPER-NAMESPACE
  kubectl describe imagescan NAME -n DEVELOPER-NAMESPACE
  ```

## <a id="triage-cve"></a>Triage

The goal of triage is to analyze and prioritize the reported vulnerability data to discover the appropriate course of action to take at the remediation step. To remediate efficiently and appropriately, you need context on the vulnerabilities that are blocking your supply chain, the packages that are affected, and the impact they can have.

During triage, review which packages are impacted by the CVEs that violated your scan policy.
Use the Supply Chain Choreographer in the Tanzu Developer Portal (formerly named Tanzu Application Platform GUI) to visualize your supply chain, including scans, scan policy, and CVEs.
You can also use the Tanzu CLI Insight plug-in to query packages, vulnerabilities, and create vulnerability analysis. See [Tanzu CLI Insight plug-in](../cli-plugins/insight/cli-overview.hbs.md).

During this stage, VMware recommends reviewing information pertaining to the CVEs from sources such as the [National Vulnerability Database](https://nvd.nist.gov/vuln) or the release page of a package.

## <a id="remediation"></a>Remediation
After triage is complete, the next step is to remediate the blocking vulnerabilities quickly. Some common methods for CVE remediation are as follows:

- Updating the affected component to remove the CVE
- Amending the scan policy with an exception if you decide to accept the CVE and unblock your supply chain

### <a id="update-component"></a>Updating the affected component

Vulnerabilities that occur in older versions of a package might be resolved in later versions. Apply a patch by upgrading to a later version.
You can further adopt security best practices by using your project's package manager tools, such as `go mod graph` for projects in Go, to identify transitive or indirect dependencies that can affect CVEs.

### <a id="amend-scan-policy"></a>Amending the scan policy

If you decide to proceed without remediating the CVE, for example, when a CVE is evaluated to be a false positive or when a fix is not available, you can amend the ScanPolicy to ignore one or more CVEs. For information about common scanner limitations, see [Note on Vulnerability Scanners](overview.hbs.md#scst-scan-note). For information about templates, see [Writing Policy Templates](policies.md).

Under RBAC, users with the `app-operator-scanning` role that is part of the `app-operator` aggregate role, have permission to edit the ScanPolicy. See [Detailed role permissions breakdown](../authn-authz/permissions-breakdown.hbs.md).
