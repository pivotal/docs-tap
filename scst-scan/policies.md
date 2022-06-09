# Enforce compliance policy using Open Policy Agent

## <a id="writing-pol-temp"></a>Writing a policy template

The Scan Policy custom resource (CR) allows you to define a Rego file for policy enforcement that you can reuse across image scan and source scan CRs.

The Scan Controller supports policy enforcement by using an Open Policy Agent (OPA) engine with Rego files. This allows scan results to be validated for company policy compliance and can prevent source code from being built or images from being deployed.

## <a id="rego-file-contract"></a>Rego file contract

To define a Rego file for an image scan or source scan, you must comply with the requirements defined for every Rego file for the policy verification to work properly.

- **Package policies:** The Rego file must define a package in its body called `policies`, because the system looks for this package to verify the scan's results compliance.

- **Input match:** The Rego file evaluates one vulnerability match at a time, iterating as many times as different vulnerabilities are found in the scan. The match structure can be accessed in the `input.currentVulnerability` object inside the Rego file and has the [CycloneDX](https://cyclonedx.org/docs/1.3/) format.

- **isCompliant rule:** The Rego file must define inside its body an `isCompliant` rule. This must be a Boolean type containing the result whether or not the vulnerability violates the security policy. If `isCompliant` is `true`, the vulnerability is allowed in the Source or Image scan; `false` is considered otherwise. Any scan that finds at least one vulnerability that evaluates to `isCompliant=false` makes the `PolicySucceeded` condition set to false.

## <a id="define-rego-file"></a>Define a Rego file for policy enforcement

Follow these steps to define a Rego file for policy enforcement that you can reuse across image scan and source scan CRs:

1. Create a scan policy with a Rego file. Here is a sample scan policy resource:

    ```console
    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: scanpolicy-sample
    spec:
      regoFile: |
        package main

        # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
        notAllowedSeverities := ["Low"]
        ignoreCves := []

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        isSafe(match) {
          fails := contains(notAllowedSeverities, match.ratings.rating[_])
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCves, match.Id)
          ignore
        }

        deny[msg] {
          comp := input.bom.components.component[_]
          vuln := comp.vulnerabilities.vulnerability[_]
          ratings := vuln.ratings.rating[_]
          not isSafe(vuln)
          msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
        }
    ```

1. Deploy the scan policy to the cluster by running:

    ```console
    kubectl apply -f <path_to_scan_policy>/<scan_policy_filename>.yaml -n <desired_namespace>
    ```
