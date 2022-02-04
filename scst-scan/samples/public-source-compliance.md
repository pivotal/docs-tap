# Sample public source code scan with compliance check

## <a id="public-source-scan"></a> Public source scan

This example performs a source scan on a public repository. The source revision has 192 known
Common Vulnerabilities and Exposures (CVEs), spanning several severities.
SourceScan uses the ScanPolicy to run a compliance check against the CVEs.

The example policy is set to only consider `Critical` severity CVEs as violations, which returns 7
Critical Vulnerabilities.

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

    ```
    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: sample-scan-policy
    spec:
      regoFile: |
        package policies

        default isCompliant = false

        # Accepted Values: "UnknownSeverity", "Critical", "High", "Medium", "Low", "Negligible"
        violatingSeverities := ["Critical"]
        ignoreCVEs := []

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        isSafe(match) {
          fails := contains(violatingSeverities, match.Ratings.Rating[_].Severity)
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCVEs, match.Id)
          ignore
        }

        isCompliant = isSafe(input.currentVulnerability)

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

    ```
    watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
    ```

    For more information, refer to [Observing and Troubleshooting](../observing.md).

1. Deploy the resources by running:

    ```
    kubectl apply -f sample-public-source-scan-with-compliance-check.yaml
    ```

1. When the scan completes, view the results by running:

    ```
    kubectl describe sourcescan sample-public-source-scan-with-compliance-check
    ```

    The `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Policy violated because of 7 CVEs`.
    For more information, see [Viewing and Understanding Scan Status Conditions](../results.md).

1. If the failing CVEs are acceptable or the build needs to be deployed regardless of these CVEs,
the app is patched to remove the vulnerabilities. Update the `ignoreCVEs` array in the ScanPolicy to
include the CVEs to ignore:

    ```
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

1. Delete the SourceScan CR by running:

    ```
    kubectl delete sourcescan sample-public-source-scan-with-compliance-check
    ```

1. Reapply the resources by running:

    ```
    kubectl apply -f sample-public-source-scan-with-compliance-check.yaml
    ```

1. Re-describe the SourceScan CR by running:

    ```
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

    ```
    kubectl delete -f sample-public-source-scan-with-compliance-check.yaml
    ```

## <a id="public-image-scan"></a> Public image scan

The following example performs an image scan on an image in a public registry.
This image revision has 223 known vulnerabilities (CVEs), spanning a number of severities.
ImageScan uses the ScanPolicy to run a compliance check against the CVEs.

The policy in this example is set to only consider `Critical` severity CVEs as a violation, which
returns 21 Unknown Severity Vulnerability.

>**Note:** This example ScanPolicy is deliberately constructed to showcase the features available
>and must not be considered an acceptable base policy.

In this example, the scan does the following (currently):

* Finds all 223 of the CVEs.
* Ignores any CVEs with severities that are not unknown severities.
* Indicates in the `Status.Conditions` that 21 CVEs have violated policy compliance.

### <a id="public-img-scan-proc"></a> Run an example public image scan

To perform an example image scan of an image in a public registry:

1. Create `sample-public-image-scan-with-compliance-check.yaml` to define the ScanPolicy and
ImageScan:

    ```
    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: sample-scan-policy
    spec:
      regoFile: |
        package policies

        default isCompliant = false

        # Accepted Values: "UnknownSeverity", "Critical", "High", "Medium", "Low", "Negligible"
        violatingSeverities := ["Critical"]
        ignoreCVEs := []

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        isSafe(match) {
          fails := contains(violatingSeverities, match.Ratings.Rating[_].Severity)
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCVEs, match.Id)
          ignore
        }

        isCompliant = isSafe(input.currentVulnerability)

    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ImageScan
    metadata:
      name: sample-public-image-scan-with-compliance-check
    spec:
      registry:
        image: "nginx:1.16"
      scanTemplate: public-image-scan-template
      scanPolicy: sample-scan-policy
    ```

1. (Optional) Before deploying, set up a watch in another terminal to view the process by running:

    ```
    watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
    ```

    For more information about setting up a watch, see
    [Observing and Troubleshooting](../observing.md).

1. Deploy the resources by running:

    ```
    kubectl apply -f sample-public-image-scan-with-compliance-check.yaml
    ```

1. View the scan results by running:

    ```
    kubectl describe imagescan sample-public-image-scan-with-compliance-check
    ```

    The `Status.Conditions` includes a `Reason: EvaluationFailed` and
    `Message: Policy violated because of 18 CVEs`.

    For more information about scan status conditions, see
    [Viewing and Understanding Scan Status Conditions](../results.md).

1. If the failing CVEs are acceptable or the build needs to be deployed regardless of these CVEs,
the app is patched to remove the vulnerabilities. Update the `ignoreCVEs` array in the ScanPolicy to
include the CVEs to ignore:

    ```
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

1. Clean up by running:

    ```
    kubectl delete -f sample-public-image-scan-with-compliance-check.yaml
    ```
