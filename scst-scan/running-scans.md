# Sample public source code and image scans with policy enforcement

## <a id="public-source-scan"></a> Public source scan
This example performs a source scan on a public repository. The source revision has 192 known vulnerabilities (CVEs), spanning a number of severities. SourceScan uses the ScanPolicy to run a compliance check against the CVEs.

The example policy is set to only consider `Critical` severity CVEs as violations, which returns 7 Critical Vulnerabilities.

**NOTE:** This example ScanPolicy is deliberately constructed to showcase the features available, and should not be considered an acceptable base policy.

For this example, the scan (at the time of writing):

* Finds all 192 of the CVEs
* Ignores any CVEs that have severities that are not critical
* Indicates in the `Status.Conditions` that 7 CVEs have violated policy compliance

### Define the ScanPolicy and SourceScan
Create `sample-public-source-scan-with-compliance-check.yaml`:

```yaml
---
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
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
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
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

### (Optional) Set up a watch
Before deploying, set up a watch in another terminal to view processing.

```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](observing.md).

### Deploy the resources

```bash
kubectl apply -f sample-public-source-scan-with-compliance-check.yaml
```

### View the scan results
Once the scan has completed, run:

```bash
kubectl describe sourcescan sample-public-source-scan-with-compliance-check
```
and notice the `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Policy violated because of 7 CVEs`.

For more information, see [Viewing and Understanding Scan Status Conditions](results.md).

### Modify the ScanPolicy
If the failing CVEs are acceptable or the build needs to be deployed regardless of these CVEs, the app is patched to remove the vulnerabilities:

Update the `ignoreCVEs` array in the ScanPolicy to include the CVEs to ignore:

```yaml
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

#### Delete the SourceScan CR:

```bash
kubectl delete sourcescan sample-public-source-scan-with-compliance-check
```

#### Re-apply the resources:

```bash
kubectl apply -f sample-public-source-scan-with-compliance-check.yaml
```

#### Re-describe the SourceScan CR:

```bash 
kubectl describe sourcescan sample-public-source-scan-with-compliance-check
```
Observe that `Status.Conditions` now includes a `Reason: EvaluationPassed` and `No CVEs were found that violated the policy`.

You can update the `violatingSeverities` array in the ScanPolicy if desired. For reference, the Grype scan returns the following Severity spread of vulnerabilities (at the time of writing):

* Critical: 7
* High: 88
* Medium: 92
* Low: 5
* Negligible: 0
* UnknownSeverity: 0

### Clean Up

```bash
kubectl delete -f sample-public-source-scan-with-compliance-check.yaml
```

## <a id="public-image-scan"></a> Public image scan
The following example performs an image scan on a image in a public registry. This image revision has 223 known vulnerabilities (CVEs), spanning a number of severities. ImageScan uses the ScanPolicy to run a compliance check against the CVEs.

The policy in this example is set to only consider `Critical` severity CVEs as a violation, which returns 21 Unknown Severity Vulnerability.

**NOTE:** This example ScanPolicy has been deliberately constructed to showcase the features available, and should not be considered an acceptable base policy.

In this example, the scan does the following (at the time of writing):

* Find all 223 of the CVEs.
* Ignore any CVEs with severities that are not unknown severities.
* Indicate in the `Status.Conditions` that 21 CVEs have violated policy compliance.

### Define the ScanPolicy and ImageScan
Create `sample-public-image-scan-with-compliance-check.yaml`:

```yaml
---
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
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
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
kind: ImageScan
metadata:
  name: sample-public-image-scan-with-compliance-check
spec:
  registry:
    image: "nginx:1.16"
  scanTemplate: public-image-scan-template
  scanPolicy: sample-scan-policy
```

### (Optional) Set up a watch
Before deploying, set up a watch in another terminal to view the process.
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information about setting up a watch, see [Observing and Troubleshooting](observing.md).

### Deploy the resources
```bash
kubectl apply -f sample-public-image-scan-with-compliance-check.yaml
```

### View the scan results
```bash
kubectl describe imagescan sample-public-image-scan-with-compliance-check
```
Note that the `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Policy violated because of 18 CVEs`.

For more information about scan status conditions, see [Viewing and Understanding Scan Status Conditions](results.md).

### Modify the ScanPolicy
See the previous source scan example.

### Clean up
To clean up, run:
```bash
kubectl delete -f sample-public-image-scan-with-compliance-check.yaml
```