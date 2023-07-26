# Use multiple Tekton pipelines and scan policies in the same namespace

This topic tells you how to use Namespace Provisioner to configure developer namespaces to include multiple Tekton pipelines and ScanPolices in Tanzu Application Platform (commonly known as TAP).

For information about, how to create a developer namespace, see [Provision Developer Namespaces](provision-developer-ns.hbs.md).

This [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/testing-scanning-supplychain-polyglot) has a Java, Python and a Golang testing pipeline as well as a Strict and a Lax grype ScanPolicy.

Using Namespace Provisioner Controller
: Add the following configuration to your TAP values to add multiple tekton pipelines and scan policies to your developer namespace:

  ```yaml
  namespace_provisioner:
    controller: true
    additional_sources:
    - git:
        ref: origin/main
        subPath: ns-provisioner-samples/testing-scanning-supplychain-polyglot
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      path: _ytt_lib/testing-scanning-supplychain-polyglot-setup
  ```

Using GitOps
: Add the following configuration to your TAP values to add multiple tekton pipelines and scan policies to your developer namespace:

  ```yaml
  namespace_provisioner:
    controller: false
    additional_sources:
    - git:
        ref: origin/main
        subPath: ns-provisioner-samples/testing-scanning-supplychain-polyglot
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      path: _ytt_lib/testing-scanning-supplychain-polyglot-setup
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

The sample Pipeline resource have the following ytt logic which creates this pipeline only if

* `supply_chain` in your TAP values is either `testing` or `testing_scanning`
* `profile` in your TAP values is either `full, iterate` or `build`.

```shell
#@ load("@ytt:data", "data")
#@ def in_list(key, list):
#@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
#@ end
#@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']):
```

All pipelines have an additional label `apps.tanzu.vmware.com/language` to differentiate between them.

The sample ScanPolicy resource have the following ytt logic which creates this pipeline only if

- `supply_chain` in your TAP values is `testing_scanning`
- `profile` in your TAP values is either `full` or `build`.

The [strict ScanPolicy](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-scanning-supplychain-polyglot/scanpolicy-grype.yaml) does not allow any workloads that have Critical and High vulnerabilities to pass through the supply chain whereas [the lax ScanPolicy](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-scanning-supplychain-polyglot/scanpolicy-grype-lax.yaml) allows the workloads to pass regardless of CVEs detected. The allowed severity level is configured using the `notAllowedSeverities := []` part of the rego file section of ScanPolicy.

>**Caution** The lax ScanPolicy is just added for tutorial purposes but it is not advised to use such a policy in Production workloads.

After adding the additional source to your TAP values, you should be able to see the `tekton-pipeline-java, tekton-pipeline-golang, tekton-pipeline-python`, `scan-policy` and `lax-scan-policy` created in your developer namespace. Run the following command to see if the pipelines are created correctly.

```shell
kubectl get pipeline.tekton.dev,scanpolicies -n YOUR-NEW-DEVELOPER-NAMESPACE
```

Run the following Tanzu CLI command to create a workload in your developer namespace:

Using Tanzu CLI
: Create workload using tanzu apps CLI command
  ```shell
  tanzu apps workload apply tanzu-java-web-app \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
  --git-branch main \
  --type web \
  --app tanzu-java-web-app \
  --label apps.tanzu.vmware.com/has-tests="true" \
  --param-yaml testing_pipeline_matching_labels='{"apps.tanzu.vmware.com/language": "java"}' \
  --param scanning_source_policy="lax-scan-policy" \
  --param scanning_image_policy="lax-scan-policy" \
  --namespace YOUR-NEW-DEVELOPER-NAMESPACE \
  --tail \
  --yes
  ```

Using workload yaml
: Create a workload.yaml file with the details as below.
  ```yaml
  ---
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    generation: 1
    labels:
      app.kubernetes.io/part-of: tanzu-java-web-app
      apps.tanzu.vmware.com/has-tests: "true"
      apps.tanzu.vmware.com/workload-type: web
    name: tanzu-java-web-app
    namespace: YOUR-NEW-DEVELOPER-NAMESPACE
  spec:
    params:
    - name: scanning_source_policy
      value: lax-scan-policy
    - name: scanning_image_policy
      value: lax-scan-policy
    - name: testing_pipeline_matching_labels
      value:
        apps.tanzu.vmware.com/language: java
    source:
      git:
        ref:
          branch: main
        url: https://github.com/sample-accelerators/tanzu-java-web-app
  ```

>**Note** `--param-yaml testing_pipeline_matching_labels` tells the supply chain to use the selector that matches the Java pipeline. To use the Python or Golang pipelines, use the selector that matches the language label in those resources.` --param scanning_source_policy="lax-scan-policy"` tells the supply chain to use the lax ScanPolicy for the workload.
