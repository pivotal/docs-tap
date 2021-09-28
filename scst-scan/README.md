# Vulnerability Scanning Enablement

## Running a Sample Public Source Scan with Policy Enforcement
This example will perform a source scan on a public repository. The source revision in question has 61 known vulnerabilities (CVEs), spanning a number of severities. The Source Scan will use the Scan Policy to run a compliance check against the CVEs.

The policy in this example has been set to only consider `Critical` severity CVEs as violations, which returns 2 Critical Vulnerabilities. Additionally, one of the `Critical` CVEs has been set to be ignored, whereas the other has not.

TODO: Reword?
**NOTE:** This example Scan Policy deliberatly has been constructed to showcase the features available, and as such should not be considered an acceptable base policy.

The scan will (at the time of writing):
* find all 61 of the CVEs,
* trim out the CVEs that have severities that are not included within the `violatingSeverities` array,
* further trim out any CVEs included in the `ignoreCVEs` array
* and indicate in the `Status.Conditions` that only one CVE violated policy compliance.

#### Define the Scan Policy and Source Scan
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
    ignoreCVEs := ["GHSA-f2jv-r9rf-7988"]

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

#### (Optional) Setup a Watch
Before deploying, set up a watch in another terminal to see things process... it will be quick!
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](observing.md).

#### Deploy the Resources
```bash
kubectl apply -f policy-enforcement-example.yaml
```

#### See the Results
Once the scan has completed, perform:
```bash
kubectl describe sourcescan policy-enforcement-example
```
and notice the `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Vulnerabilities that failed OPA policy: GHSA-w457-6q6x-cgp9`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](results.md).

TODO: Rename this heading to be Feature oriented towards the AllowList
#### Modifying the Scan Policy
Let us say that this failing CVE is actually acceptable or the build just needs to be deployed... and the app will be patched tomorrow to remove the vulnerability... so... (It should be said, we are not advocating for ignoring Critical Severity Vulnerabilities, but for example sake...)

Update the `ignoreCVEs` array in the `ScanPolicy` to include the failing CVE `GHSA-w457-6q6x-cgp9`.

**NOTE:** Currently, the ScanPolicy CRD will not re-trigger a scan if it is updated, so one way to re-trigger the scan is to delete and reapply the SourceScan CR.

So, go ahead and delete just the SourceScan CR:
```bash
kubectl delete sourcescan policy-enforcement-example
```

Reapply the resources (`kubectl apply -f policy-enforcement-example.yaml`), re-describe the Scan CR (`kubectl describe sourcescan policy-enforcement-example`) and voila!

... `Status.Conditions` now includes a `Reason: EvaluationPassed` and `No noncompliant vulnerabilities found`.

Go ahead and update the `violatingSeverities` array as well to see the effect. For reference, the Grype scan returns the following Severity spread of vulnerabilities:
* Critical: 2
* High: 31
* Medium: 26
* Low: 2
* Negligible: 0
* UnknownSeverity: 0

## Clean Up
```bash
kubectl delete -f policy-enforcement-example.yaml
```

TODO: Add Image Scan

## Viewing Vulnerability Reports
TODO: Rework narrative with Metadata Store
The Scan Controller supports integration with the Metadata Store to save information about vulnerabilities and dependencies. You can query this vulnerability data using the Metadata Store `insight` CLI by providing the digest of the source or image scanned.

For example, to query Vulnerability data relating to an Image Scan:
```bash
# In another terminal (ensure the namespace is correct):
kubectl port-forward service/metadata-app-postgres 8080:8080 -n metadata-store
# Then back in the main terminal, check you are targeting the port-forwarded port:
insight config set-target http://localhost:8080
# Query for image scans:
kubectl get imagescans
# and grab the sha256 digest and replace in the following example query:
insight image get \
  --digest sha256:06ba459dc32475871646f22c980d5db4335021d76e1693c8a87bf02aed8c1a3e \
  --format json
```

For more information, refer to [Using the Metadata Store](https://gitlab.eng.vmware.com/source-insight-tooling/insight-metadata-store/-/blob/alpha/README.md#using-the-metadata-store).

## Incorporating into CI/CD Pipelines
The Scan Controller is developed to be included within with your CI/CD pipelines, providing you information and reliability about the security of your Image or Source Code before promoting it further in your supply chain. You can use any tool for CI/CD pipelines, just ensure the following are included inside the template to trigger a new scan:
* Source Scans: the repository url and commit digest, or the path to the compressed file with the latest source code
* Image Scans: the image name and digest

After you update and apply the scan CR to your cluster, then the next step should be looking at the CR description to get feedback from the Status field (see [Viewing and Understanding Scan Status Conditions](results.md)) and from there, make the decision if promoting your Image or Source Code further or just fail the pipeline.

## Next Steps and Further Information
* [Running More Samples](samples/README.md)
* [Configuring Code Repositories and Image Artifacts to be Scanned](scan-crs.md)
* [Configuring Policy Enforcement using Open Policy Agent (OPA)](policies.md)
* [Viewing and Understanding Scan Status Conditions](results.md)
* [Observing and Troubleshooting](observing.md)

## Contact Us
Need help or want to cover something that is not mentioned?
Find us on [#tap-assist](https://app.slack.com/client/T024JFTN4/C02D60T1ZDJ) as `@sct-vse` or email us at [sct-vse@groups.vmware.com](mailto:sct-vse@groups.vmware.com).
