# View scan status conditions for Supply Chain Security Tools - Scan

This topic explains how you can view scan status conditions for Supply Chain Security Tools - Scan. 

## <a id='view-scan-stat'></a>Viewing scan status

You can view the scan status by using `kubectl describe` on a `SourceScan` or `ImageScan`. You can see information about the scan status under the Status field for each scan CR.

## <a id='understand-con'></a>Overview of conditions

The `Status.Conditions` array is populated with the scan status information during and after scanning execution, and the policy validation (if defined for the scan) after the results are available.

### <a id='con-type-scan'></a>Condition types for the scans

#### <a id='scanning'></a>Scanning

The Condition with type `Scanning` indicates running the scanning TaskRun. The Status field indicates whether the scan is running or has already finished. For example, if `Status: True`, the scan TaskRun is still running and if `Status: False`, the scan is done.

The Reason field is `JobStarted` while the scan is running and `JobFinished` when it is done.

The Message fieldcan either be `The scan job is running` or `The scan job terminated` depending on the current Status and Reason.

#### <a id='succeeded'></a>Succeeded

The Condition with type `Succeeded` indicates the scanning TaskRun result. The Status field indicates whether the scan finished successfully or if it encountered an error. For example, the status is `Status: True` if it completed successfully or `Status: False` otherwise.

The Reason field is `JobFinished` if the scanning was successful or `Error` if otherwise.

The Message and Error fields have more information about the last seen status of the scan TaskRun.

#### <a id='send-results'></a>SendingResults

The condition with type `SendingResults` indicates sending the scan results to the metadata store. In addition to a successful process of sending the results, the condition can also indicate that the metadata store integration has not been configured or that there was an error sending. An error is usually a misconfigured metadata store URL or that the metadata store is inaccessible. Verify the installation steps to ensure that the configuration is correct regarding secrets being set within the `scan-link-system` namespace.

#### <a id='policy-succeed'></a>PolicySucceeded

The Condition with type `PolicySucceeded` indicates the compliance of the scanning results against the defined policies. See [Code Compliance Policy Enforcement using Open Policy Agent (OPA)](policies.md). The Status field indicates whether the results are compliant or not (`Status: True` or `Status: False` respectively) or `Status: Unknown` in case an error occurred during the policy verification.

The Reason field is `EvaluationPassed` if the scan complies with the defined policies. The Reason field is `EvaluationFailed` if the scan is not compliant, or `Error` if something went wrong.

The Message and Error fields are populated with `An error has occurred` and an error message if something went wrong during policy verification. Otherwise, the Message field displays `No CVEs were found that violated the policy` if there are no non-compliant vulnerabilities found or `Policy violated because of X CVEs` indicating the count of unique vulnerabilities found.

## <a id='understand-cvecount'></a>Overview of CVECount

The `status.CVECount` is populated with the number of CVEs in each category (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN) and the total (CVETOTAL).

>**Note** You can also view scan CVE summary in print columns with `kubectl get` on a `SourceScan` or `ImageScan`.

## <a id='understand-metaurl'></a>Overview of MetadataURL

The `status.metadataURL` is populated with the URL of the vulnerability scan results in> the metadata store integration. This is only available when the integration is configured.

## <a id='understand-phase'></a>Overview of Phase

The `status.phase` field is populated with the current phase of the scan. The phases are: Pending, Scanning, Completed, Failed, and Error.

* `Pending`: initial phase of the scan.
* `Scanning`: execution of the scan TaskRun is running.
* `Completed`: scan completed and no CVEs were found that violated the scan policy.
* `Failed`: scan completed but CVEs were found that violated the scan policy.
* `Error`: indication of an error (e.g., an invalid scantemplate or scan policy).

>**Note** The PHASE print column also shows this with `kubectl get` on a `SourceScan` or `ImageScan`.

## <a id='understand-scannedby'></a>Overview of ScannedBy

The `status.scannedBy` field is populated with the name, vendor, and scanner version that generates the security assessment report.

## <a id='understand-scannedat'></a>Overview of ScannedAt

The `status.scannedAt` field is populated with the latest date when the scanning finishes.
