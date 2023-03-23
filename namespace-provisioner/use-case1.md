# Multiple Tekton pipelines  + Scan policies in the same namespace using GitOps

Refer to the [Provision Developer Namespaces](#heading=h.y3di0ufxnjb4) section to create a developer namespace.

Configure developer namespace to include more than one Tekton pipelines and ScanPolices

This [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/testing-scanning-supplychain-polyglot) has a Java, Python and a Golang testing pipeline as well as a Strict and a Lax grype ScanPolicy.

Using Namespace Provisioner Controller
: Add the following configuration to your TAP values to add multiple tekton pipelines and scan policies to your developer namespace

        ```console
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

        ```console
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



        ---

        The sample Pipeline resource have the following ytt logic which creates this pipeline only if



        * `supply_chain` in your TAP values is either `testing` or `testing_scanning`
        * `profile` in your TAP values is either `full, iterate` or `build`.

            ```
        #@ load("@ytt:data", "data")
        #@ def in_list(key, list):
        #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
        #@ end
        #@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']):
        ```



        All pipelines have an additional label `apps.tanzu.vmware.com/language `to differentiate between them.

        The sample ScanPolicy resource have the following ytt logic which creates this pipeline only if



        * `supply_chain` in your TAP values is `testing_scanning`
        * `profile` in your TAP values is either `full` or `build`.

        The [strict ScanPolicy](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-scanning-supplychain-polyglot/scanpolicy-grype.yaml) does not allow any workloads that have Critical and High vulnerabilities to pass through the supply chain whereas [the lax ScanPolicy](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-scanning-supplychain-polyglot/scanpolicy-grype-lax.yaml) allows the workloads to pass regardless of CVEs detected. The allowed severity level is configured using the` notAllowedSeverities := [] `part of the rego file section of ScanPolicy.

        **CAUTION:** The lax ScanPolicy is just added for tutorial purposes but it is not advised to use such a policy in Production workloads.

        After adding the additional source to your TAP values, you should be able to see the `tekton-pipeline-java, tekton-pipeline-golang, tekton-pipeline-python`, `scan-policy and lax-scan-policy `created in your developer namespace. Run the following command to see if the pipelines are created correctly.


        ```
        kubectl get pipeline.tekton.dev,scanpolicies -n YOUR-NEW-DEVELOPER-NAMESPACE
        ```


        Run the following Tanzu CLI command to create a workload in your developer namespace:


        ```
        tanzu apps workload apply tanzu-java-web-app \
        --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
        --git-branch main \
        --type web \
        --app tanzu-java-web-app \
        --label apps.tanzu.vmware.com/has-tests="true" \
        --param-yaml testing_pipeline_matching_labels='{"apps.tanzu.vmware.com/pipeline": "test", "apps.tanzu.vmware.com/language": "java"}' \
        --param scanning_source_policy="lax-scan-policy" \
        --param scanning_image_policy="lax-scan-policy" \
        --namespace YOUR-NEW-DEVELOPER-NAMESPACE \
        --tail \
        --yes
        ```


        **NOTE**: `--param-yaml testing_pipeline_matching_labels` tells the supply chain to use the selector that matches the Java pipeline. To use the Python or Golang pipelines, use the selector that matches the language label in those resources.` --param scanning_source_policy="lax-scan-policy"` tells the supply chain to use the lax ScanPolicy for the workload.
