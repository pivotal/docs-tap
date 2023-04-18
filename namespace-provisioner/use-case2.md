# Add Tekton pipelines and Scan policies using namespace parameters

Refer to the [Provision Developer Namespaces](provision-developer-ns.md) section to create a developer namespace.

Namespace Provisioner allows you to parameterize your additional resources and pass those parameters. Create a Tekton pipeline and ScanPolicy that is bespoke to certain namespaces that are running workloads using a particular language stack instead of creating all the pipelines in all provisioned namespaces.

This use case uses looks at the pipelines and ScanPolicies in this [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/testing-scanning-supplychain-parameterized).

Using Namespace Provisioner Controller
: When using the Namespace Provisioner controller, pass the parameters to a namespace via labels and annotations on the namespace. To enable this, set the `parameter_prefixes` in TAP configuration for Namespace Provisioner so the controller will look for labels/annotations starting with that prefix to populate parameters for a given namespace. See Controller section of [Customize Installation of Namespace Provisioner](customize-installation.md) guide for more information.

    Add the following configuration to your TAP values to add parameterized tekton pipelines and scan policies to your developer namespace:

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain-parameterized
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/testing-scanning-supplychain-parameterized-setup
      parameter_prefixes:
      - tap.tanzu.vmware.com
    ```
    >**Note** We added `tap.tanzu.vmware.com` as a parameter_prefixes in Namespace Provisioner configuration. This tells the Namespace Provisioner controller to look for the annotations/labels on a provisioned namespace that start with the prefix `tap.tanzu.vmware.com/` and use those as parameters.

    The sample pipelines have the following ytt logic which creates this pipeline only if

    - `supply_chain` in your TAP values is either `testing` or `testing_scanning`
    - `profile` in your TAP values is either` full, iterate` or `build`.
     `pipeline` parameter that matches the language for which the pipeline is for.

    ```shell
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']) and hasattr(data.values, 'pipeline') and data.values.pipeline == 'java':
    ```

    The sample ScanPolicy resource have the following ytt logic which creates this pipeline only if

    * `supply_chain` in your TAP values is `testing_scanning`
    * `profile` in your TAP values is either `full` or `build`.
    * `scanpolicy `parameter matches either `strict` or `lax`

    ```shell
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing_scanning']) and in_list('profile', ['full', 'build']) and hasattr(data.values, 'scanpolicy') and data.values.scanpolicy == 'lax':
    ```

    Label your developer namespace using the `parameter_prefixes` with the parameter to be used in the `additional_sources` as follows:

    ```shell
    kubectl label namespaces YOUR-NEW-DEVELOPER-NAMESPACE tap.tanzu.vmware.com/scanpolicy=lax
    ```

    ```shell
    kubectl label namespaces YOUR-NEW-DEVELOPER-NAMESPACE tap.tanzu.vmware.com/pipeline=java
    ```

Using GitOps
: When using GitOps, pass the parameters to a namespace by adding them to the data.values file located in our GitOps repo. Take a look at [this sample file](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/gitops-install-with-params/desired-namespaces.yaml#L7-L8) for an example.

    Add the following configuration to your TAP values to add parameterized tekton pipelines and scan policies to your developer namespace:

    ```yaml
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain-parameterized
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/testing-scanning-supplychain-parameterized-setup
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install-with-params
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

    **Note** We added `gitops_install` with this [sample GitOps location](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/gitops-install-with-params) to create the namespaces and manage the desired namespaces from GitOps. See GitOps section of [Customize Installation of Namespace Provisioner](customize-installation.md) guide for more information.

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

    The sample pipelines have the following ytt logic which creates this pipeline only if

    * `supply_chain` in your TAP values is either `testing` or `testing_scanning`
    * `profile` in your TAP values is either` full, iterate` or `build`.
    * `pipeline` parameter that matches the language for which the pipeline is for.

    ```shell
    #@ load("@ytt:data", "data")
    #@ def in_list(key, list):
    #@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
    #@ end
    #@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']) and hasattr(data.values, 'pipeline') and data.values.pipeline == 'java':
    ```

    The sample ScanPolicy resource have the following ytt logic which creates this pipeline only if

    * `supply_chain` in your TAP values is `testing_scanning`
    * `profile` in your TAP values is either `full` or `build`.
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
: Create workload using tanzu apps CLI command
  ```shell
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

Run the following command to verify the resources have been created in the namespace: \

```shell
kubectl get secrets,serviceaccount,rolebinding,pods,workload,configmap,limitrange,pipeline,scanpolicies -n YOUR-NEW-DEVELOPER-NAMESPACE
```

