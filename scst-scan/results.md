# View Scan Status Conditions

## View Scan Status
You can view the Scan status by using `kubectl describe` on a `SourceScan` or `ImageScan`. You can see information about the scan status under the Status field for each scan CR.

## Understand Conditions
The `Status.Conditions` array will be populated with the scan status information during and after scanning execution, and the policy validation (if defined for the scan), once the results are available.

### Condition Types for the scans

#### Scanning
The Condition with type `Scanning` indicates the execution of the scanning job. The Status field indicates whether the scan is still running or has already finished (i.e. if `Status: True`, the scan job is still running; if `Status: False`, the scan is done).

The Reason field will be `JobStarted` while the scanning is running and `JobFinished` when it's done.

The Message field can either be `The scan job is running` or `The scan job terminated` depending on the current Status and Reason.

#### Succeeded
The Condition with type `Succeeded` indicates the scanning job result. The Status field indicates whether the scan finished successfully or if it encountered any error (i.e the status will be `Status: True` if it finished successfully or `Status: False` otherwise).

The Reason field will be `JobFinished` if the scanning was successful or `Error` if otherwise.

The Message and Error fields will have more information about the last seen status of the scan job.

#### SendingResults
The condition with type `SendingResults` indicates the process of sending the scan results to the metadata store. In addition to a successful process of sending the results, the condition may also indicate that the metadata store integration has not been configured or that there was an error sending. An error would usually be a misconfigured metadata store url or that the metadata store is inaccessible. Check the installation steps to ensure configuration is correct in terms of secrets being set within the `scan-link-system` namespace.

#### PolicySucceeded
The Condition with type `PolicySucceeded` indicates the compliance of the scanning results against the defined policies (see [Code Compliance Policy Enforcement using Open Policy Agent (OPA)](#code-compliance-policy-enforcement-using-open-policy-agent-opa). The Status field indicates whether the results are compliant or not (`Status: True` or `Status: False` respectively), or `Status: Unknown` in case an error occurred during the policy verification.

The Reason field is `EvaluationPassed` if the scan is compliant with the defined policies. The Reason field is `EvaluationFailed` if the scan is not compliant, or `Error` if something went wrong.

The Message and Error fields will be populated with `An error has occurred` and an error message if something went wrong during policy verification. Otherwise, the Message field will have `No CVEs were found that violated the policy` if there's no non-compliant vulnerabilities found or `Policy violated because of X CVEs` indicating the count of unique vulnerabilities found.
