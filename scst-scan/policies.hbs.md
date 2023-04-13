# Enforce compliance policy using Open Policy Agent

## <a id="writing-pol-temp"></a>Writing a policy template

The Scan Policy custom resource (CR) allows you to define a Rego file for policy
enforcement that you can reuse across image scan and source scan CRs.

The Scan Controller supports policy enforcement by using an Open Policy Agent
(OPA) engine with Rego files. This allows you to validate scan results for
company policy compliance and can prevent source code from being built or images
from being deployed.

## <a id="rego-file-contract"></a>Rego file contract

To define a Rego file for an image scan or source scan, you must comply with the
requirements defined for every Rego file for the policy verification to work.
For information about how to write Rego, see [Open Policy Agent
documentation](https://www.openpolicyagent.org/docs/latest/policy-language/).

- **Package main:** The Rego file must define a package in its body called `main`. The system looks for this package to verify the scan results compliance.

- **Input match:** The Rego file evaluates one vulnerability match at a time, iterating as many times as the Rego file finds vulnerabilities in the scan. The match structure is accessed in the `input.currentVulnerability` object inside the Rego file and has the [CycloneDX](https://cyclonedx.org/docs/1.3/) format.

- **deny rule:** The Rego file must define a `deny` rule inside its body. `deny` is a set of error messages that are returned to the user. Each rule you write adds to that set of error messages. If the conditions in the body of the `deny` statement are true then the user is handed an error message. If false, the vulnerability is allowed in the Source or Image scan.

## <a id="define-rego-file"></a>Define a Rego file for policy enforcement

Follow these steps to define a Rego file for policy enforcement that you can
reuse across image scan and source scan CRs that output in the CycloneDX XML
format.

>**Note** The Snyk Scanner outputs SPDX JSON. <!--For an example of a ScanPolicy formatted for SPDX JSON output, see [Sample ScanPolicy for Snyk in SPDX JSON format](install-snyk-integration.md#snyk-scan-policy).-->

1. Create a scan policy with a Rego file. The following is an example scan policy resource:

    ```console
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: scanpolicy-sample
    spec:
      # A multiline string defining a valid Rego file for policy validation
      regoFile: |
        # Define the package policies
        package policies

        # Give default value to isCompliant to be returned
        # if no change to `true` is applied
        default isCompliant = false

        # Not fail on any CVE with this severities in it
        ignoreSeverities := ["Low"]

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        # Define the rule structure for evaluating CVEs
        isCompliant {
          # Check if the severity level in any of the ratings associated
          # with the current CVEs is present in the ignoreSeverities
          # array.
          ignore := contains(ignoreSeverities, input.currentVulnerability.Ratings.Rating[_].Severity)
          # If the severity level is in the array, isCompliant will be true
          # since `ignore` is. isCompliant will have the default value if `ignore` is false.
          ignore
        }
    ```

1. Deploy the scan policy to the cluster by running:

    ```console
    kubectl apply -f <path_to_scan_policy>/<scan_policy_filename>.yaml -n <desired_namespace>
    ```
