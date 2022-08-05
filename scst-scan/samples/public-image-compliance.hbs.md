# Sample public image scan with compliance check

## <a id="public-image-scan"></a> Public image scan

The following example performs an image scan on an image in a public registry. This image revision has 223 known vulnerabilities (CVEs), spanning a number of severities. ImageScan uses the ScanPolicy to run a compliance check against the CVEs.

The policy in this example is set to only consider `Critical` severity CVEs as a violation, which returns 21 Critical Severity Vulnerabilities.

>**Note:** This example ScanPolicy is deliberately constructed to showcase the features available and must not be considered an acceptable base policy.

In this example, the scan does the following (currently):

* Finds all 223 of the CVEs.
* Ignores any CVEs with severities that are not critical.
* Indicates in the `Status.Conditions` that 21 CVEs have violated policy compliance.

### <a id="define-scanpolicy-imgscan"></a> Define the ScanPolicy and ImageScan

Create `sample-public-image-scan-with-compliance-check.yaml`:

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
kind: ImageScan
metadata:
  name: sample-public-image-scan-with-compliance-check
spec:
  registry:
    image: "nginx:1.16"
  scanTemplate: public-image-scan-template
  scanPolicy: sample-scan-policy
```

### <a id="set-up-watch"></a> (Optional) Set up a watch

Before deploying, set up a watch in another terminal to view the process:

```console
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information about setting up a watch, see [Observing and Troubleshooting](../observing.md).

### <a id="deploy-resources"></a> Deploy the resources

```console
kubectl apply -f sample-public-image-scan-with-compliance-check.yaml
```

### <a id="view-scan-results"></a> View the scan results

```console
kubectl describe imagescan sample-public-image-scan-with-compliance-check
```

> **Note:** The `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Policy violated because of 21 CVEs`.

For more information about scan status conditions, see [Viewing and Understanding Scan Status Conditions](../results.md).

### <a id="modify-scanpolicy"></a> Modify the ScanPolicy

To modify the Scan Policy, see [Step 5: Sample Public Source Code Scan with Compliance Check](public-source-compliance.md#modify-scan-policy).

### <a id="clean-up"></a> Clean up

To clean up, run:

```console
kubectl delete -f sample-public-image-scan-with-compliance-check.yaml
```
