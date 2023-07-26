# Add Tekton pipelines and scan policies using namespace parameters

This topic tells you how to use Namespace Provisioner to parameterize your additional resources and
pass those parameters to namespaces in Tanzu Application Platform (commonly known as TAP).

Instead of creating all the pipelines in all provisioned namespaces,
create a Tekton pipeline and ScanPolicy that is bespoke to namespaces that are running workloads using a specific language stack.

For information about, how to create a developer namespace, see [Provision Developer Namespaces](provision-developer-ns.hbs.md).

This use case looks at the pipelines and ScanPolicies in this [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/testing-scanning-supplychain-parameterized).

Using Namespace Provisioner controller
: Use controller to pass the parameters to a namespace via labels and annotations on the namespace. To enable this, set the `parameter_prefixes` in `tap-values.yaml`. The controller looks for labels and annotations starting with that prefix to populate parameters for a given namespace. For more information, see [Customize the label and annotation prefixes that controller watches](customize-installation.hbs.md#con-custom-label).

    Add the following configuration to your `tap-values.yaml` file to add parameterized Tekton pipelines and scan policies to your developer namespace:

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain-parameterized
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      parameter_prefixes:
      - tap.tanzu.vmware.com
    ```
    >**Note** This example adds `tap.tanzu.vmware.com` as a parameter_prefixes in Namespace Provisioner configuration. This tells the Namespace Provisioner controller to look for the annotations and labels on a provisioned namespace that start with the prefix `tap.tanzu.vmware.com` and use those as parameters.

    The sample pipelines have the following ytt logic which creates this pipeline only if

    - `supply_chain` in your `tap-values.yaml` file is either `testing` or `testing_scanning`
    - `profile` in your `tap-values.yaml` file is either` full, iterate` or `build`.
     `pipeline` parameter that matches the language for which the pipeline is for.

    ```shell
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']) and hasattr(data.values, 'pipeline') and data.values.pipeline == 'java':
    ```

    The sample ScanPolicy resource have the following ytt logic which creates this pipeline only if

    * `supply_chain` in your `tap-values.yaml` file is `testing_scanning`
    * `profile` in your `tap-values.yaml` file is either `full` or `build`.
    * `scanpolicy `parameter matches either `strict` or `lax`

    ```shell
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing_scanning']) and in_list('profile', ['full', 'build']) and hasattr(data.values, 'scanpolicy') and data.values.scanpolicy == 'lax':
    ```

    Label your developer namespace using the `parameter_prefixes` with the [parameter](parameters.hbs.md#namespace-parameters) to be used in the `additional_sources` as follows:

    ```shell
    kubectl label namespaces YOUR-NEW-DEVELOPER-NAMESPACE tap.tanzu.vmware.com/scanpolicy=lax
    ```

    ```shell
    kubectl label namespaces YOUR-NEW-DEVELOPER-NAMESPACE tap.tanzu.vmware.com/pipeline=java
    ```

Using GitOps
: Pass the parameters to a namespace by adding them to the `data.values` file located in the GitOps repository. Use [this sample file](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/gitops-install-with-params/desired-namespaces.yaml#L7-L8) as an example.

    Add the following configuration to your `tap-values.yaml` file to add parameterized Tekton pipelines and scan policies to your developer namespace:

    ```yaml
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain-parameterized
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install-with-params
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

    `gitops_install` uses this [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/gitops-install-with-params) to create the namespaces and manage the desired namespaces from GitOps. For more information, see GitOps section of [Customize Installation of Namespace Provisioner](customize-installation.hbs.md).

    Sample of `gitops_install` files:

    ```yaml
    #@data/values
    ---
    namespaces:
    - name: dev
      scanpolicy: lax
      pipeline: java
    - name: qa
      scanpolicy: strict
      pipeline: java
    ```

    ```yaml
    #@ load("@ytt:data", "data")
    #! This loop will now loop over the namespace list in
    #! in ns.yaml and will create those namespaces.
    #@ for ns in data.values.namespaces:
    ---
    apiVersion: v1
    kind: Namespace
    metadata:
      name: #@ ns.name
    #@ end
    ```

    The sample pipelines have the following ytt logic which creates this pipeline only if the following conditions are met:

    * `supply_chain` in your `tap-values.yaml` file is either `testing` or `testing_scanning`
    * `profile` in your `tap-values.yaml` file is either` full, iterate` or `build`.
    * `pipeline` parameter that matches the language for which the pipeline is for.

    ```shell
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']) and hasattr(data.values, 'pipeline') and data.values.pipeline == 'java':
    ```

    The sample ScanPolicy resource have the following ytt logic which creates this pipeline only if the following conditions are me:

    * `supply_chain` in your `tap-values.yaml` file is `testing_scanning`
    * `profile` in your `tap-values.yaml` file is either `full` or `build`.
    * `scanpolicy `parameter matches either `strict` or `lax`

    ```shell
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing_scanning']) and in_list('profile', ['full', 'build']) and hasattr(data.values, 'scanpolicy') and data.values.scanpolicy == 'lax':
    ```

Run the following Tanzu CLI command to create a workload in your developer namespace:

Using Tanzu CLI
: Create a workload using Tanzu Apps CLI command

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

Using workload yaml
: Create a workload.yaml file with the details as below.

  ```yaml
  ---
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    labels:
      app.kubernetes.io/part-of: tanzu-java-web-app
      apps.tanzu.vmware.com/has-tests: "true"
      apps.tanzu.vmware.com/workload-type: web
    name: tanzu-java-web-app
    namespace: YOUR-NEW-DEVELOPER-NAMESPACE
  spec:
    source:
      git:
        ref:
          branch: main
        url: https://github.com/sample-accelerators/tanzu-java-web-app
  ```

Run the following command to verify the resources have been created in the namespace:

```shell
kubectl get secrets,serviceaccount,rolebinding,pods,workload,configmap,limitrange,pipeline,scanpolicies -n YOUR-NEW-DEVELOPER-NAMESPACE
```
