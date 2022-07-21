# Enforce compliance policy using Open Policy Agent 

## <a id="writing-pol-temp"></a>Writing a policy template

The Scan Policy custom resource (CR) allows you to define a Rego file for policy enforcement that you can reuse across image scan and source scan CRs.

The Scan Controller supports policy enforcement by using an Open Policy Agent (OPA) engine with Rego files. This allows scan results to be validated for company policy compliance and can prevent source code from being built or images from being deployed.

## <a id="rego-file-contract"></a>Rego file contract

To define a Rego file for an image scan or source scan, you must comply with the requirements defined for every Rego file for the policy verification to work properly.

- **Package main:** The Rego file must define a package in its body called `main`, because the system looks for this package to verify the scan results compliance.

- **Input match:** The Rego file evaluates one vulnerability match at a time, iterating as many times as different vulnerabilities are found in the scan. The match structure is accessed in the `input.currentVulnerability` object inside the Rego file and has the [CycloneDX](https://cyclonedx.org/docs/1.3/) format.

- **deny rule:** The Rego file must define inside its body a `deny` rule. `deny` is a set of error messages that is returned to the user. Each rule you write adds to that set of error messages. If the conditions in the body of the `deny` statement are true then the user is handed an error message. If false, the vulnerability is allowed in the Source or Image scan.

## <a id="define-rego-file"></a>Define a Rego file for policy enforcement

Follow these steps to define a Rego file for policy enforcement that you can reuse across image scan and source scan CRs that output in the CycloneDX XML format.

>**Note:** The Snyk Scanner outputs SPDX JSON. See [Install Snyk Scanner](install-snyk-integration.md#a-idverifya-verify-integration-with-snyk) for an example of a ScanPolicy formatted for SPDX JSON output.

1. Create a scan policy with a Rego file. Here is a sample scan policy resource:

    ```yaml
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
    ```

2. Deploy the scan policy to the cluster by running:

    ```console
    kubectl apply -f <path_to_scan_policy>/<scan_policy_filename>.yaml -n <desired_namespace>
    ```

## <a id="gui-view-scan-policy"></a>Enable Tanzu Application Platform GUI to view ScanPolicy Resource

In order for the Tanzu Application Platform GUI to view the ScanPolicy resource, it must have a matching `kubernetes-label-selector` with a `part-of` prefix.

Here is an example of a ScanPolicy that is viewable by the TAP GUI:
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanPolicy
metadata:
  name: scanpolicy-sample
  labels:
    'app.kubernetes.io/part-of': 'component-a'
spec:
  regoFile: |
    ...
```
>**Note:** The value for the label can be anything. The Tanzu Application Platform GUI is looking for the existence of the `part-of` prefix string and doesn't match for anything else specific.

## <a id="deprecated-rego-file"></a> Deprecated Rego file Definition

Before Scan Controller v1.2.0, you must use the following format where the rego file differences are:

- The package name must be `package policies` instead of `package main`.
- The deny rule is a Boolean `isCompliant` instead of `deny[msg]`.
  - **isCompliant rule:** The Rego file must define inside its body an `isCompliant` rule. This must be a Boolean type containing the result whether the vulnerability violates the security policy or not. If `isCompliant` is `true`, the vulnerability is allowed in the Source or Image scan; `false` is considered otherwise. Any scan that finds at least one vulnerability that evaluates to `isCompliant=false` makes the `PolicySucceeded` condition set to false.
- Here is a sample scan policy resource:
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanPolicy
metadata:
  name: v1alpha1-scan-policy
spec:
  regoFile: |
    package policies

    default isCompliant = false

    ignoreSeverities := ["Low","Medium","High","Critical"]

    contains(array, elem) = true {
      array[_] = elem
    } else = false { true }

    isCompliant {
      ignore := contains(ignoreSeverities, input.currentVulnerability.Ratings.Rating[_].Severity)
      ignore
    }
```
