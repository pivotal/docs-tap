# Running a Sample Public Source Scan and Image Scan with Policy Enforcement

## <a id="public-source-scan"></a> Public Source Scan
This example performs a source scan on a public repository. The source revision has 61 known vulnerabilities (CVEs), spanning a number of severities. SourceScan uses the ScanPolicy to run a compliance check against the CVEs.

The example policy is set to only consider `Critical` severity CVEs as violations, which returns 2 Critical Vulnerabilities.

**NOTE:** This example ScanPolicy is deliberately constructed to showcase the features available, and should not be considered an acceptable base policy.

For this example, the scan:

* Finds all 61 of the CVEs
* Ignores any CVEs that have severities that are not critical
* Indicates in the `Status.Conditions` that 2 CVEs have violated policy compliance

### Define the ScanPolicy and SourceScan
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

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "Unknown"
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

### (Optional) Set Up a Watch
Before deploying, set up a watch in another terminal to view processing.

```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](observing.md).

### Deploy the Resources

```bash
kubectl apply -f policy-enforcement-example.yaml
```

### View the Scan Results
Once the scan has completed, run:

```bash
kubectl describe sourcescan policy-enforcement-example
```
and notice the `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Vulnerabilities that failed OPA policy: GHSA-f2jv-r9rf-7988, GHSA-w457-6q6x-cgp9`.

For more information, see [Viewing and Understanding Scan Status Conditions](results.md).

### Modify the ScanPolicy
If the failing CVEs are acceptable or the build needs to be deployed regardless of these CVEs, 
the app is patched to remove the vulnerabilities:

Update the `ignoreCVEs` array in the ScanPolicy to include the CVEs to ignore:

```yaml
...
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "Unknown"
    violatingSeverities := ["Critical"]
    # Adding the failing CVEs to the ignore array
    ignoreCVEs := ["GHSA-f2jv-r9rf-7988", "GHSA-w457-6q6x-cgp9"]
...
```

**NOTE:** The ScanPolicy CRD will not re-trigger a scan if it is updated. To re-trigger the scan, delete and re-apply the SourceScan CR.

#### Delete the SourceScan CR:

```bash
kubectl delete sourcescan policy-enforcement-example
```

#### Re-apply the Resources:

```bash
kubectl apply -f policy-enforcement-example.yaml
```

#### Re-describe the SourceScan CR:

```bash 
kubectl describe sourcescan policy-enforcement-example
```
Observe that `Status.Conditions` now includes a `Reason: EvaluationPassed` and `No noncompliant vulnerabilities found`.

You can update the `violatingSeverities` array in the ScanPolicy if desired. For reference, the Grype scan returns the following Severity spread of vulnerabilities:

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

## <a id="public-image-scan"></a> Public Image Scan
The following example performs an image scan on a image in a public registry. This image revision has 226 known vulnerabilities (CVEs), spanning a number of severities. ImageScan uses the ScanPolicy to run a compliance check against the CVEs.

The policy in this example is set to only consider `Unknown` severity CVEs as a violation, which returns 1 Unknown Severity Vulnerability.

**NOTE:** This example ScanPolicy has been deliberately constructed to showcase the features available, and should not be considered an acceptable base policy.

In this example, the scan does the following (at the time of writing):

* Find all 226 of the CVEs.
* Ignore any CVEs with severities that are not unknown severities.
* Indicate in the `Status.Conditions` that 1 CVE have violated policy compliance.

### Define the ScanPolicy and ImageScan
Create `image-policy-enforcement-example.yaml`:
```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanPolicy
metadata:
  name: image-scan-policy
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "Unknown"
    violatingSeverities := ["Unknown"]
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
kind: ImageScan
metadata:
  name: image-policy-enforcement-example
spec:
  registry:
    image: "nginx:1.16"
  scanTemplate: public-image-scan-template
  scanPolicy: image-scan-policy
```

### (Optional) Set Up a Watch
Before deploying, set up a watch in another terminal to view the process.
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information about setting up a watch, see [Observing and Troubleshooting](observing.md).

### Deploy the Resources
```bash
kubectl apply -f image-policy-enforcement-example.yaml
```

### View the Scan Results
```bash
kubectl describe imagescan image-policy-enforcement-example
```
Note that the `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Vulnerabilities that failed OPA policy: CVE-2021-3618`.

For more information about scan status conditions, see [Viewing and Understanding Scan Status Conditions](results.md).

### Modify the ScanPolicy
If the failing CVE is acceptable or the build needs to be deployed, and the app will be patched tomorrow to remove the vulnerability, see the following example.

Update the `ignoreCVEs` array in the ScanPolicy to include the CVEs to ignore, run:
```yaml
...
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "Unknown"
    violatingSeverities := ["Unknown"]
    # Adding the failing CVE to the ignore array
    ignoreCVEs := ["CVE-2021-3618"]
...
```

**NOTE:** The ScanPolicy CRD will not re-trigger a scan if it is updated, so one way to re-trigger the scan is to delete and re-apply the ImageScan CR.

#### Delete the ImageScan CR
```bash
kubectl delete imagescan image-policy-enforcement-example
```

####  Re-apply the Resources
```bash
kubectl apply -f image-policy-enforcement-example.yaml
```

#### Re-describe the Scan CR
```bash 
kubectl describe imagescan image-policy-enforcement-example
```
You will see the following output:

`Status.Conditions` now includes a `Reason: EvaluationPassed` and `No noncompliant vulnerabilities found`.

You can update the `violatingSeverities` array in the ScanPolicy.. For reference, the Grype scan returns the following Severity spread of vulnerabilities:

* Critical: 21
* High: 59
* Medium: 44
* Low: 28
* Negligible: 73
* UnknownSeverity: 1

### Clean Up
To clean up, run:
```bash
kubectl delete -f image-policy-enforcement-example.yaml
```