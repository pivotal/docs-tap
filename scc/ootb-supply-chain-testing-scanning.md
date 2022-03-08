# Out of the Box Supply Chain with Testing and Scanning

This Cartographer Supply Chain ties a series of Kubernetes resources which,
when working together, drives a developer-provided Workload from source code
all the way to a Kubernetes configuration ready to be deployed to a cluster,
having not only passed that source code through testing and vulnerability
scanning, but also the container image produced.


```
SUPPLYCHAIN
  source-provider                          flux/GitRepository|vmware/ImageRepository
    <--[src]-- source-tester               carto/Runnable        : tekton/PipelineRun
      <--[src]-- source-scanner            scst/SourceScan       : v1/Job
       <--[src]-- image-builder            kpack/Image           : kpack/Build
          <--[img]-- image-scanner         scst/ImageScan        : v1/Job
           <--[img]-- convention-applier   convention/PodIntent
             <--[config]-- config-creator  corev1/ConfigMap
              <--[config]-- config-pusher  carto/Runnable        : tekton/TaskRun

DELIVERY
  config-provider                           flux/GitRepository|vmware/ImageRepository
    <--[src]-- app-deployer                 kapp-ctrl/App
```


It includes all the capabilities of the Out of the Box Supply Chain With
Testing, but adds on top source and image scanning using Grype:

- Watching a Git Repository or local directory for changes
- Running tests from a developer-provided Tekton or Pipeline
- Scanning the source code for known vulnerabilities using Grype
- Building a container image out of the source code with Buildpacks
- Scanning the image for known vulnerabilities
- Applying operator-defined conventions to the container definition
- Deploying the application to the same cluster


## <a id="prerequisites"></a> Prerequisites

To make use this supply chain, it is required that:

- Out of the Box Templates is installed
- Out of the Box Delivery Basic is installed
- Out of the Box Supply Chain With Testing **is NOT installed**
- Out of the Box Supply Chain With Testing and Scanning **is installed**
- Developer namespace is configured with the objects per Out of the Box Supply
  Chain With Testing guidance (this supply chain is additive to the testing
  one)

You can verify that you have the right set of supply chains installed (i.e. the
one with Scanning and _not_ the one with testing) by running the following
command:

```
tanzu apps cluster-supply-chain list
```
```
NAME                      LABEL SELECTOR
source-test-scan-to-url   apps.tanzu.vmware.com/has-tests=true,apps.tanzu.vmware.com/workload-type=web
source-to-url             apps.tanzu.vmware.com/workload-type=web
```

If you see `source-test-to-url` in the list, the setup is wrong: you **must not
have the _source-test-to-url_ installed** at the same time as
_source-test-scan-to-url_.


## <a id="developer-namespace"></a> Developer Namespace

As mentioned in the prerequisites section, this example builds on the previous
Out of the Box Supply Chain examples, so only additions are included here.

To ensure that you have configured the namespace correctly, it is important that
the namespace has the objects that you configured in the other supply chain setups:

- **image secret**: A Kubernetes secret of type `kubernetes.io/dockerconfigjson` filled with
credentials for pushing the container images built by the supply chain. For more information, see
[Supply Chain Basic](ootb-supply-chain-basic.md).

- **service account**: The identity to be used for any interaction with the Kubernetes API made by
the supply chain. For more information, see [Supply Chain Basic](ootb-supply-chain-basic.md).

- **role**: The set of capabilities that you want to assign to the service account. It must provide
the ability to manage all of the resources that the supplychain is responsible for.
For more information, see [Supply Chain Basic](ootb-supply-chain-basic.md).

- **rolebinding**: Binds the role to the service account, which grants the capabilities to the
identity. For more information, see [Supply Chain Basic](ootb-supply-chain-basic.md).

- (Optional) **git credentials secret**: When using GitOps for managing the delivery of applications
or a private Git source, provides the required credentials for interacting with the Git repository.
For more information, see [Supply Chain Basic](ootb-supply-chain-basic.md).

- **tekton pipeline**: A pipeline to be ran whenever the supply chain hits the stage of testing the
source code. For more information, see [Supply Chain with Testing](ootb-supply-chain-testing.md).


And the new ones, that you create here:

- **scan policy**: Defines what to do with the results taken from scanning the source code and
image produced. For more information, see [ScanPolicy section](#scan-policy).

- **source scan template**: A template of how jobs are created for scanning the source
code. For more information, see [ScanTemplate section](#scan-template).

- **image scan template**: A template of how jobs are created for scanning the image
produced by the supply chain. For more information, see [ScanTemplate section](#scan-template).

Below you will find details about the new objects (compared to Out of the Box
Supply Chain With Testing).


### <a id="updates-to-developer-namespace"></a> Updates to the Developer Namespace

For source and image scans to happen, scan templates and scan policies
must exist in the same namespace as the Workload. These define:

- `ScanTemplate`: how to run a scan, allowing one to change details about the
  execution of the scan (either for images or source code)

- `ScanPolicy`: how to evaluate whether the artifacts scanned are compliant,
  for example allowing one to be either very strict, or restrictive about particular
vulnerabilities found.

Note that the names of the objects **must** match the ones in the example.


#### <a id="scan-policy"></a> ScanPolicy

The ScanPolicy defines a set of rules to evaluate for a particular scan to
consider the artifacts (image or source code) either compliant or not.

When a ImageScan or SourceScan is created to run a scan, those reference a
policy whose name **must** match the one below (`scan-policy`):

```
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanPolicy
metadata:
  name: scan-policy
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    violatingSeverities := ["Critical","High","UnknownSeverity"]
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
```

See [Writing Policy Templates](../scst-scan/policies.md) for more details.


#### <a id="scan-template"></a> ScanTemplate

A ScanTemplate defines the PodTemplateSpec to be used by a Job to run a
particular scan (image or source). When an ImageScan or SourceScan is
instantiated by the supply chain, they reference these templates which must
live in the same namespace as the Workload with the names matching the ones
below:

- source scanning (`blob-source-scan-template`)
- image scanning (`private-image-scan-template`)

If you are targeting a namespace that does not match the one configured in the
Tanzu Application Platform profiles, for example if `grype.namespace` is not the same as the one
you are writing the workload to, you can install these in such namespace by making use of the
`tanzu package install` command as described in [Install Supply Chain Security
Tools - Scan](../install-components.md#install-scst-scan):

1. Create a file named `ootb-supply-chain-basic-values.yaml` that specifies the corresponding values
to the properties you want to change. For example:

    ```
    grype:
      namespace: YOUR-DEV-NAMESPACE
      targetImagePullSecret: registry-credentials
    ```

1. With the configuration ready, install the templates by running:

    ```
    tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0 \
      --namespace YOUR-DEV-NAMESPACE
    ```

>**Note:** Although you can customize the templates, if you are just following the Getting Started
>guide then it is recommended you stick with what is provided in the installation of
>`grype.scanning.apps.tanzu.vmware.com`. This is created in the same namespace as configured by
>using `grype.namespace` in either Tanzu Application Platform profiles or individual component
>installation as in the earlier example. For more information, see
>[About Source and Image Scans](../scst-scan/explanation.md#about-src-and-image-scans).


## <a id="developer-workload"></a> Developer Workload

With the ScanPolicy and ScanTemplate objects, with the required names set,
submitted to the same namespace where the Workload will be submitted
to, you are ready to submit your Workload.

Regardless of the workflow being targeted (local development or gitops), the
Workload configuration details are the same as in Out of the Box Supply Chain
Basic, except that you mark the Workload as having tests enabled.

For example:

```
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app
  --label apps.tanzu.vmware.com/has-tests=true \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --type web
```
```
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
     16 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
```
