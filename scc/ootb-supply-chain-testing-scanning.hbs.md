# Out of the Box Supply Chain with Testing and Scanning for Supply Chain Choreographer

This topic provides an overview of Out of the Box Supply Chain with Testing and Scanning for Supply Chain Choreographer.

This package contains Cartographer Supply Chains that tie together a series of
Kubernetes resources that drive a developer-provided workload from source code
to a Kubernetes configuration ready to be deployed to a cluster.
It contains supply chains that pass the source code through testing and vulnerability
scanning, and also the container image.

This package includes all the capabilities of the Out of the Box Supply Chain With
Testing, but adds source and image scanning using Grype.

Workloads that use source code or prebuilt images
perform the following:

- Building from source code:

  1. Watching a Git Repository or local directory for changes
  2. Running tests from a developer-provided Tekton pipeline
  3. Scanning the source code for known vulnerabilities using Grype
  4. Building a container image out of the source code with Buildpacks
  5. Scanning the image for known vulnerabilities
  6. Applying operator-defined conventions to the container definition
  7. Deploying the application to the same cluster

- Using a prebuilt application image:

  1. Scanning the image for known vulnerabilities
  1. Applying operator-defined conventions to the container definition
  1. Creating a deliverable object for deploying the application to a cluster

## <a id="prerequisites"></a> Prerequisites

To use this supply chain, verify that:

- Out of the Box Templates is installed.
- Out of the Box Supply Chain With Testing **is NOT installed**.
- Out of the Box Supply Chain With Testing and Scanning **is installed**.
- Developer namespace is configured with the objects according to Out of the Box Supply
  Chain With Testing guidance. This supply chain is in addition to the Supply Chain with testing.
- (Optionally) install [Out of the Box Delivery
  Basic](ootb-delivery-basic.html), if you are willing to deploy the application to the
same cluster as the workload and supply chains.

Verify that you have the supply chains with scanning, not with testing, installed. Run:

```console
tanzu apps cluster-supply-chain list
```

```console
NAME                      LABEL SELECTOR
source-test-scan-to-url   apps.tanzu.vmware.com/has-tests=true,apps.tanzu.vmware.com/workload-type=web
source-to-url             apps.tanzu.vmware.com/workload-type=web
```

If you see `source-test-to-url` in the list, the setup is wrong. You **must not
have the _source-test-to-url_ installed** at the same time as
_source-test-scan-to-url_.

## <a id="developer-namespace"></a> Developer namespace

This example builds on the previous
Out of the Box Supply Chain examples, so only additions are included here.

To ensure that you configured the namespace correctly, it is important that
the namespace has the objects that you configured in the other supply chain setups:

- **registries secrets**: Kubernetes secrets of type
  `kubernetes.io/dockerconfigjson` that contain credentials for pushing and
  pulling the container images built by the supply chain and the
  installation of Tanzu Application Platform.

- **service account**: The identity to be used for any
  interaction with the Kubernetes API made by the supply chain.

- **rolebinding**: Grant to the identity the necessary roles
  for creating the resources prescribed by the supply chain.

  For more information about the preceding objects, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- **Tekton pipeline**: A pipeline runs whenever the supply chain hits the stage
  of testing the source code.

  For more information, see [Out of the Box Supply Chain Testing](ootb-supply-chain-testing.md).

And the new objects, that you create here:

- **scan policy**: Defines what to do with the results taken from scanning the source code and
image produced. For more information, see [ScanPolicy section](#scan-policy).

- **source scan template**: A template of how TaskRuns are created for scanning the source
code. See [ScanTemplate section](#scan-template).

- **image scan template**: A template of how TaskRuns are created for scanning the image
produced by the supply chain. See [ScanTemplate section](#scan-template).

The following section includes details about the new objects, compared to Out of the Box
Supply Chain With Testing.

### <a id="updates-to-developer-namespace"></a> Updates to the developer namespace

For source and image scans, scan templates and scan policies
must exist in the same namespace as the workload. These define:

- `ScanTemplate`: how to run a scan, allowing one to change details about the
  execution of the scan (either for images or source code)

- `ScanPolicy`: how to evaluate whether the artifacts scanned are compliant.
  For example, allowing one to be either very strict, or restrictive about particular
vulnerabilities found.

The names of the objects **must** match the names in the example with default installation configurations. This is overriden either by using the `ootb_supply_chain_testing_scanning` package configuration in the `tap-values.yaml` file or by using workload parameters:

- To override by using the `ootb_supply_chain_testing_scanning` package configuration, make the following modification to your `tap-values.yaml` file and perform a [Tanzu Application Platform update](../upgrading.hbs.md#upgrading-tanzu-application-platform).

    ```yaml
    ootb_supply_chain_testing_scanning:
      scanning:
        source:
          policy: SCAN-POLICY
          template: SCAN-TEMPLATE
        image:
          policy: SCAN-POLICY
          template: SCAN-TEMPLATE
    ```

    Where `SCAN-POLICY` and `SCAN-TEMPLATE` are the names of the `ScanPolicy` and `ScanTemplate`.

- To override through workload parameters, use the following commands.
  For more information, see [Tanzu apps workload apply](../cli-plugins/apps/reference/workload-create-apply.hbs.md).

    ```console
    tanzu apps workload apply WORKLOAD --param "scanning_source_policy=SCAN-POLICY" -n DEV-NAMESPACE
    tanzu apps workload apply WORKLOAD --param "scanning_source_template=SCAN-TEMPLATE" -n DEV-NAMESPACE
    ```

    Where:

    - `WORKLOAD` is the name of the workload.
    - `SCAN-POLICY` and `SCAN-TEMPLATE` are the names of the `ScanPolicy` and `ScanTemplate`.
    - `DEV-NAMESPACE` is the developer namespace.

#### <a id="scan-policy"></a> ScanPolicy

The ScanPolicy defines a set of rules to evaluate for a particular scan to
consider the artifacts (image or source code) either compliant or not.

When a ImageScan or SourceScan is created to run a scan, those reference a
policy whose name **must** match the following sample `scan-policy`:

```console
---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanPolicy
metadata:
  name: scan-policy
  labels:
    'app.kubernetes.io/part-of': 'enable-in-gui'
spec:
  regoFile: |
    package main

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    notAllowedSeverities := ["Critical", "High", "UnknownSeverity"]
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

See [Writing Policy Templates](../scst-scan/policies.md).

#### <a id="scan-template"></a> ScanTemplate

A ScanTemplate defines the PodTemplateSpec used by a TaskRun to run a
particular scan (image or source). When the supply chain initiates an ImageScan or SourceScan, they reference these templates which must
live in the same namespace as the workload with the names matching the following:

- source scanning (`blob-source-scan-template`)
- image scanning (`private-image-scan-template`)

If you are targeting a namespace that does not match the one configured in the
Tanzu Application Platform profiles, for example, if `grype.namespace` is not the same as the one
you are writing the workload to, you can install these in such namespace by making use of the
`tanzu package install` command as described in [Install Supply Chain Security
Tools - Scan](../scst-scan/install-scst-scan.md):

1. Create a file named `ootb-supply-chain-basic-values.yaml` that specifies the corresponding values
to the properties you want to change. For example:

    ```yaml
    grype:
      namespace: YOUR-DEV-NAMESPACE
      targetImagePullSecret: registry-credentials
    ```

1. With the configuration ready, install the templates by running:

    ```console
    tanzu package install grype-scanner \
      --package grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace YOUR-DEV-NAMESPACE
    ```

>**Note** Although you can customize the templates, if you are following the Getting Started
>guide, VMware recommends that you follow what is provided in the installation of
>`grype.scanning.apps.tanzu.vmware.com`. This is created in the same namespace as configured by
>using `grype.namespace` in either Tanzu Application Platform profiles or individual component
>installation as in the earlier example. For more information, see
>[About Source and Image Scans](../scst-scan/explanation.md#about-src-and-image-scans).

#### <a id="storing-scan-results"></a>Enable storing scan results

To enable SCST - Scan to store scan results by using SCST - Store, see
[Developer namespace setup](../scst-store/developer-namespace-setup.hbs.md) for exporting the
SCST - Store CA certificate and authentication token to the developer namespace.

#### <a id="multiple-pl"></a> Allow multiple Tekton pipelines in a namespace

{{> 'partials/multiple-pipelines' }}

## <a id="developer-workload"></a> Developer workload

With the ScanPolicy and ScanTemplate objects, with the required names set,
submitted to the same namespace where the workload are submitted, you are ready to submit your workload.

Regardless of the workflow being targeted, such as local development or gitops, the
workload configuration details are the same as in Out of the Box Supply Chain
Basic, except that you mark the workload as having tests enabled.

For example:

```console
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/vmware-tanzu/application-accelerator-samples \
  --sub-path tanzu-java-web-app \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --type web
```

```console
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |    apps.tanzu.vmware.com/has-tests: "true"
      8 + |    app.kubernetes.io/part-of: tanzu-java-web-app
      9 + |  name: tanzu-java-web-app
     10 + |  namespace: default
     11 + |spec:
     12 + |  source:
     13 + |    git:
     14 + |      ref:
     15 + |        branch: main
     16 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     17 + |    subPath: tanzu-java-web-app
```

## <a id="cve-triage-workflow"></a> CVE triage workflow

The Supply Chain halts progression if either a SourceScan (`sourcescans.scanning.apps.tanzu.vmware.com`) or an ImageScan (`imagescans.scanning.apps.tanzu.vmware.com`) fails policy enforcement through the [ScanPolicy](../scst-scan/policies.hbs.md#define-a-rego-file-for-policy-enforcement) (`scanpolicies.scanning.apps.tanzu.vmware.com`). This can prevent source code from building or images deploying that contain vulnerabilities that are in violation of the user-defined scan policy.
For information about learning how to handle these vulnerabilities and unblock your Supply Chain, see [Triaging and Remediating CVEs](../scst-scan/triaging-and-remediating-cves.hbs.md).

## <a id="scan-images-using-different-scanner"></a> Scan Images using a different scanner

[Supply Chain Security Tools - Scan](../scst-scan/install-scst-scan.md) includes additional integrations for running an image scan using Snyk and VMware Carbon Black.
