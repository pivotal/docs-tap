# Enforce compliance policy using Open Policy Agent

## <a id="writing-policy-template"></a>Writing a policy template
The Scan Policy custom resource allows you to define a Rego file for policy enforcement that you can reuse across Image Scan and Source Scan CRs.

The Scan Controller supports policy enforcement by using an Open Policy Agent (OPA) engine with Rego files. This allows scan results to be validated for company policy compliance and can prevent source code from being built or images from being deployed.

## <a id="rego-file-contract"></a>Rego file contract
To define a Rego file for an image scan or source scan, you must comply with the requirements defined for every Rego file for the policy verification to work properly.

1. **Package policies**  
The Rego file must define a package in its body called `policies`, because the system looks for this package to determine the scan's results compliance.

1. **Input match**  
The Rego file evaluates one vulnerability match at a time, iterating as many times as different vulnerabilities are found in the scan. The match structure can be accessed in the `input.currentVulnerability` object inside the Rego file and has the [CycloneDX](https://cyclonedx.org/docs/1.3/) format.

1. **isCompliant rule**  
The Rego file must define inside its body an `isCompliant` rule. This must be a Boolean type containing the result whether or not the vulnerability violates the security policy. If `isCompliant` is `true`, the vulnerability is allowed in the Source or Image scan; `false` will be considered otherwise. Any scan that finds at least one vulnerability that evaluates to `isCompliant=false` will make the `PolicySucceeded` condition set to false.

## <a id="create-scan-pol-with-rego"></a>Step 1: Create a scan policy with rego file

### <a id="sample-scan-pol-resource"></a>Sample scan policy resource

```
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

## <a id="deploy-scan-pol-to-clust"></a>Step 2: Deploy the scan policy to the cluster

`kubectl apply -f <path_to_scan_policy>/<scan_policy_filename>.yml -n <desired_namespace>`
