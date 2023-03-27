# Setup for OOTB Supply chains (WIP)

This topic describes how to setup for OOTB supply chains.

## Basic Supply Chain

Refer to the [Provision Developer Namespaces](#fake) section to create a developer namespace.

Namespace Provisioner creates a set of [default resources](#fake) in all managed namespaces which are sufficient to run a workload through the Basic supply chain.

Run the following Tanzu CLI command to create a workload in your developer namespace:

```console
tanzu apps workload apply tanzu-java-web-app \
--git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
--git-branch main \
--type web \
--app tanzu-java-web-app \
--namespace YOUR-NEW-DEVELOPER-NAMESPACE \
--tail \
--yes
```

## Testing Supply Chain

The Testing supply chain adds the **source-tester** step in the supply chain which tests the source code pulled by the supply chain. For source code testing to work in the supply chain, a Tekton Pipeline must exist in the same namespace as the Workload so that, at the right moment, the Tekton PipelineRun object that gets created to run the tests can reference such developer-provided Pipeline.

By default, the workload is matched to the corresponding pipeline to run using labels. Pipelines must have the label `apps.tanzu.vmware.com/pipeline: test` at a minimum, but you can add additional labels for granularity. This provides a default match in the event that no other labels are provided. The pipeline expects two parameters:

* `source-url`, an HTTP address where a `.tar.gz` file containing all the source code to be tested can be found
* `source-revision`, the revision of the commit or image reference (in case of `workload.spec.source.image` being set instead of `workload.spec.source.git`)

For example:

```console
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: tekton-pipeline-java
  labels:
    apps.tanzu.vmware.com/pipeline: test      # (!) required
spec:
  params:
    - name: source-url                        # (!) required
    - name: source-revision                   # (!) required
  tasks:
    - name: test
      params:
        - name: source-url
          value: $(params.source-url)
        - name: source-revision
          value: $(params.source-revision)
      taskSpec:
        params:
          - name: source-url
          - name: source-revision
        steps:
          - name: test
            image: gradle
            script: |-
              cd `mktemp -d`
              wget -qO- $(params.source-url) | tar xvz -m
              ./mvnw test
```

### Add a Java Tekton Pipeline to your developer namespace

Refer to the [Provision Developer Namespaces](#fake) section to create a developer namespace.

Namespace Provisioner can automate the creation of a Tekton pipeline that is needed for the workload to run on a Testing supply chain. You can create a sample pipeline in your GitOps repo and add your GitOps repository as an additional source in Namespace Provisioner configuration in TAP values. (See [Customize Installation](#fake) for more details).

Add the following configuration to your TAP values to add [this sample java pipeline](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-supplychain/tekton-pipeline-java.yaml) to your developer namespace:

Using Namespace Provisioner Controller
: Sample TAP values configuration:

    ```console
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/testing-supplychain-setup
    ```

Using GitOps
: Sample TAP values configuration:

    ```
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/testing-supplychain-setup
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

    The sample pipeline resource have the following ytt logic which creates this pipeline only if

    * `supply_chain` in your TAP values is either `testing` or `testing_scanning`
    * `profile` in your TAP values is either `full, iterate` or `build`.

    ```console
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']):
    ```

    After adding the additional source to your TAP values, you should be able to see the `tekton-pipeline-java` created in your developer namespace. Run the following command to see if the pipeline is created correctly.


    ```console
    kubectl get pipeline.tekton.dev -n YOUR-NEW-DEVELOPER-NAMESPACE
    ```

    Run the following Tanzu CLI command to create a workload in your developer namespace:

    ```console
    tanzu apps workload apply tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --app tanzu-java-web-app \
    --label apps.tanzu.vmware.com/has-tests="true" \
    --namespace YOUR-NEW-DEVELOPER-NAMESPACE \
    --tail \
    --yes
    ```

## Testing & Scanning Supply Chain

The Testing Scanning supply chain adds the `source-tester`, `source-scanner` and `image-scanner` steps in the supply chain which tests the source code pulled by the supply chain as well as run scans for CVEs on the source and the image built by the supply chain. For these new testing and scanning steps to work, following additional resources must exist in the same namespace as the workload.

* `Pipeline:`defines how to run the tests on the source code pulled by the supply chain and which image to use that has the tools to run those tests.
* `ScanTemplate`: defines how to run a scan, allowing one to change details about the execution of the scan (either for images or source code)
    * A ScanTemplate defines the PodTemplateSpec used by a Job to run a particular scan (image or source). When the supply chain initiates an ImageScan a SourceScan, they reference these templates which must live in the same namespace as the workload.
    * Although you can customize the templates, VMware recommends that you follow what is provided in the installation of the `grype.scanning.apps.tanzu.vmware.com` package. This is automatically created in all the namespace managed by Namespace Provisioner. For more information, see [About Source and Image Scans](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/scst-scan-explanation.html#about-src-and-image-scans).
* `ScanPolicy`: define how to evaluate whether the artifacts scanned are compliant. For example, allowing one to be either very strict, or restrictive about particular vulnerabilities found.
* When an ImageScan or a SourceScan is created to run a scan, those reference a policy whose name must match the following [sample ScanPolicy](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-scanning-supplychain/scanpolicy-grype.yaml).
* See [Writing Policy Templates](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/scst-scan-policies.html).

### Add a Java Tekton Pipeline & Grype Scan Policy to your developer namespace

Refer to the [Provision Developer Namespaces](#heading=h.y3di0ufxnjb4) section to create a developer namespace.

Namespace Provisioner can automate the creation of a Tekton pipeline and a ScanPolicy that is needed for the workload to run on a Testing & Scanning supply chain. You can create a sample Pipeline and a ScanPolicy in your GitOps repo and add your GitOps repository as an additional source in Namespace Provisioner configuration in TAP values. (See [Customize Installation](#fake) for more details)

Add the following configuration to your TAP values to add the [sample java pipeline and grype scan policy ](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/testing-scanning-supplychain)to your developer namespace:

Using Namespace Provisioner Controller
: Sample TAP values configuration:

    ```
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/testing-scanning-supplychain-setup
    ```

Using GitOps
: Sample TAP values configuration:

    ```console
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/testing-scanning-supplychain-setup
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

    The sample Pipeline resource have the following ytt logic which creates this pipeline only if

    * `supply_chain` in your TAP values is either `testing` or `testing_scanning`
    * `profile` in your TAP values is either `full, iterate` or `build`.

    ```console
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']):
    ```

    The sample ScanPolicy resource have the following ytt logic which creates this pipeline only if

    * `supply_chain` in your TAP values is `testing_scanning`
    * `profile` in your TAP values is either `full` or `build`.

    After adding the additional source to your TAP values, you should be able to see the `tekton-pipeline-java and scan-policy` created in your developer namespace. Run the following command to see if the pipeline is created correctly.

    ```console
    kubectl get pipeline.tekton.dev,scanpolicies -n YOUR-NEW-DEVELOPER-NAMESPACE
    ```

    Run the following Tanzu CLI command to create a workload in your developer namespace:

    ```console
    tanzu apps workload apply tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --app tanzu-java-web-app \
    --label apps.tanzu.vmware.com/has-tests="true" \
    --namespace YOUR-NEW-DEVELOPER-NAMESPACE \
    --tail \
    --yes
    ```

### <a id="fake"></a>Fake section -->