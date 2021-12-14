# Enforce compliance policy using Open Policy Agent

## Writing a policy template
The Scan Policy custom resource allows you to define a Rego File for policy enforcement that you can easily reuse across Image Scan and Source Scan CRs.

The Scan Controller supports policy enforcement by using an Open Policy Agent (OPA) engine with Rego Files. This allows scan results to be validated for company policy compliance and can prevent source code from being built or images from being deployed.

## Rego file contract
For you to define a rego file for an Image Scan or Source Scan, you need to be compliant with the requirements that are defined for every Rego File in order for the policy verification to work properly.

1. **Package Policies**  
The Rego File must define a package in its body called `policies` since this will be the package the system will be looking for to decide on the scan's results compliance.

1. **Input Match**  
The Rego File evaluates one vulnerability match at a time, having as many iterations as different vulnerabilities are found in the scan. The match structure can be accessed in the `input.currentVulnerability` object inside the Rego File and will have the [CycloneDX](https://cyclonedx.org/docs/1.3/) format.

1. **isCompliant Rule**  
The Rego File must define inside its body an `isCompliant` rule, which needs to be a boolean type containing the result whether the vulnerability violates the security policy or not. If `isCompliant` is `true`, the vulnerability is allowed in the Source or Image scan; `false` will be considered otherwise. Any scan that finds at least one vulnerability that evaluates to `isCompliant=false` will make the `PolicySucceeded` condition set to false.

## Step 1: Create a scan policy with rego file

### Sample scan policy resource
```
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanPolicy
metadata:
  name: scanpolicy-sample
spec:
  # A multiline string defining a valid Rego File for policy validation
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

## Step 2: Deploy the Scan Policy to the Cluster

`kubectl apply -f <path_to_scan_policy>/<scan_policy_filename>.yml -n <desired_namespace>`
