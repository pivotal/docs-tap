# Running a Sample Public Source Scan and Image Scan with Policy Enforcement

## <a id="public-source-scan"></a> Public Source Scan
This example will perform a source scan on a public repository. The source revision in question has 61 known vulnerabilities (CVEs), spanning a number of severities. The Source Scan will use the Scan Policy to run a compliance check against the CVEs.

The policy in this example has been set to only consider `Critical` severity CVEs as violations, which returns 2 Critical Vulnerabilities.

**NOTE:** This example Scan Policy has been deliberately constructed to showcase the features available, and as such should not be considered an acceptable base policy.

For this example, the scan will (at the time of writing):
* find all 61 of the CVEs,
* ignore any CVEs that have severities that are not critical,
* indicate in the `Status.Conditions` that 2 CVEs have violated policy compliance.

### Define the Scan Policy and Source Scan
Create `policy-enforcement-example.yaml`:
```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanPolicy
metadata:
  name: scan-policy
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
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
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: SourceScan
metadata:
  name: policy-enforcement-example
spec:
  git:
    url: "https://github.com/houndci/hound.git"
    revision: "5805c650"
  scanTemplate: public-source-scan-template
  scanPolicy: scan-policy
```

### (Optional) Setup a Watch
Before deploying, set up a watch in another terminal to see things process... it will be quick!
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](observing.md).

### Deploy the Resources
```bash
kubectl apply -f policy-enforcement-example.yaml
```

### See the Results
Once the scan has completed, perform:
```bash
kubectl describe sourcescan policy-enforcement-example
```
and notice the `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Vulnerabilities that failed OPA policy: GHSA-f2jv-r9rf-7988, GHSA-w457-6q6x-cgp9`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](results.md).

### Modifying the Scan Policy
Let us say that these failing CVEs are actually acceptable or the build just needs to be deployed... and the app will be patched tomorrow to remove the vulnerabilities... so... (it should be said, we are not advocating for ignoring Critical Severity Vulnerabilities, but for example's sake...)

Update the `ignoreCVEs` array in the ScanPolicy to include the CVEs to ignore:
```yaml
...
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    violatingSeverities := ["Critical"]
    # Adding the failing CVEs to the ignore array
    ignoreCVEs := ["GHSA-f2jv-r9rf-7988", "GHSA-w457-6q6x-cgp9"]
...
```

**NOTE:** Currently, the ScanPolicy CRD will not re-trigger a scan if it is updated, so one way to re-trigger the scan is to delete and re-apply the SourceScan CR.

So, go ahead and delete just the SourceScan CR:
```bash
kubectl delete sourcescan policy-enforcement-example
```

Re-apply the resources:
```bash
kubectl apply -f policy-enforcement-example.yaml
```
Re-describe the Scan CR:
```bash 
kubectl describe sourcescan policy-enforcement-example
```
...and voila!

`Status.Conditions` now includes a `Reason: EvaluationPassed` and `No noncompliant vulnerabilities found`.

You can also update the `violatingSeverities` array in the ScanPolicy if desired. For reference, the Grype scan returns the following Severity spread of vulnerabilities:

* Critical: 2
* High: 31
* Medium: 26
* Low: 2
* Negligible: 0
* UnknownSeverity: 0

### Clean Up
```bash
kubectl delete -f policy-enforcement-example.yaml
```