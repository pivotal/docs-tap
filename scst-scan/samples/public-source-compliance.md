# Sample public source code scan with compliance check

## <a id="public-source-scan"></a> Public source scan

This example performs a source scan on a public repository. The source revision has 192 known
Common Vulnerabilities and Exposures (CVEs), spanning several severities.
SourceScan uses the ScanPolicy to run a compliance check against the CVEs.

The example policy is set to only consider `Critical` severity CVEs as violations, which returns 7 Critical Severity Vulnerabilities.

>**Note:** This example ScanPolicy is deliberately constructed to showcase the features available
>and must not be considered an acceptable base policy.

For this example, the scan (at the time of writing):

* Finds all 192 of the CVEs.
* Ignores any CVEs that have severities that are not critical.
* Indicates in the `Status.Conditions` that 7 CVEs have violated policy compliance.

### <a id="public-source-scan-proc"></a> Run an example public source scan

To perform an example source scan on a public repository:

1. Create `sample-public-source-scan-with-compliance-check.yaml` to define the ScanPolicy and
SourceScan:

    ```yaml
    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: sample-scan-policy
    spec:
      regoFile: |
        package main

        # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
        notAllowedSeverities := ["Critical"]
        ignoreCves := []

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        isSafe(match) {
          severities := { e | e := match.ratings.rating.severity } | { e | e := match.ratings.rating[_].severity }
          some i
          fails := contains(notAllowedSeverities, severities[i])
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCves, match.id)
          ignore
        }

        deny[msg] {
          comps := { e | e := input.bom.components.component } | { e | e := input.bom.components.component[_] }
          some i
          comp := comps[i]
          vulns := { e | e := comp.vulnerabilities.vulnerability } | { e | e := comp.vulnerabilities.vulnerability[_] }
          some j
          vuln := vulns[j]
          ratings := { e | e := vuln.ratings.rating.severity } | { e | e := vuln.ratings.rating[_].severity }
          not isSafe(vuln)
          msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
        }

    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: SourceScan
    metadata:
      name: sample-public-source-scan-with-compliance-check
    spec:
      git:
        url: "https://github.com/houndci/hound.git"
        revision: "5805c650"
      scanTemplate: public-source-scan-template
      scanPolicy: sample-scan-policy
    ```

1. (Optional) Before deploying, set up a watch in another terminal to view processing by running:

    ```console
    watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
    ```

    For more information, refer to [Observing and Troubleshooting](../observing.md).

1. Deploy the resources by running:

    ```console
    kubectl apply -f sample-public-source-scan-with-compliance-check.yaml
    ```

1. When the scan completes, view the results by running:

    ```console
    kubectl describe sourcescan sample-public-source-scan-with-compliance-check
    ```

    The `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Policy violated because of 7 CVEs`.
    For more information, see [Viewing and Understanding Scan Status Conditions](../results.md).

1. <a id="modify-scan-policy"></a>If the failing CVEs are acceptable or the build needs to be deployed regardless of these CVEs,
the app is patched to remove the vulnerabilities. Update the `ignoreCVEs` array in the ScanPolicy to
include the CVEs to ignore:

    ```console
    ...
    spec:
      regoFile: |
        package policies

        default isCompliant = false

        # Accepted Values: "UnknownSeverity", "Critical", "High", "Medium", "Low", "Negligible"
        violatingSeverities := ["Critical"]
        # Adding the failing CVEs to the ignore array
        ignoreCVEs := ["CVE-2018-14643", "GHSA-f2jv-r9rf-7988", "GHSA-w457-6q6x-cgp9", "CVE-2021-23369", "CVE-2021-23383", "CVE-2020-15256", "CVE-2021-29940"]
    ...
    ```

1. The changes applied to the new ScanPolicy trigger the scan to run again. Reapply the resources by running:

    ```console
    kubectl apply -f sample-public-source-scan-with-compliance-check.yaml
    ```

1. Re-describe the SourceScan CR by running:

    ```console
kubectl describe sourcescan sample-public-source-scan-with-compliance-check
    ```

1. Check that `Status.Conditions` now includes a `Reason: EvaluationPassed` and
`No CVEs were found that violated the policy`.
You can update the `violatingSeverities` array in the ScanPolicy if desired. For reference, the
Grype scan returns the following Severity spread of vulnerabilities (currently):

    * Critical: 7
    * High: 88
    * Medium: 92
    * Low: 5
    * Negligible: 0
    * UnknownSeverity: 0

1.  Clean up by running:

    ```console
    kubectl delete -f sample-public-source-scan-with-compliance-check.yaml
    ```
