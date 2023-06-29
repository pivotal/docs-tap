# Set up for Out of the Box Supply Chains

This topic tells you how to set up Namespace Provisioner to automate the creation of resources
that are needed for workloads to run on Out of the Box Supply Chain Basic and Out of the Box Supply Chain with Testing.

## Out of the Box Supply Chain Basic

To create a developer namespace, see [Provision Developer Namespaces](provision-developer-ns.hbs.md).

Namespace Provisioner creates a set of [default resources](reference.hbs.md#default-resources) in all managed namespaces which are sufficient to run a workload through the Out of the Box Supply Chain Basic.

Run the following Tanzu CLI command to create a workload in your developer namespace:

Using Tanzu CLI
: Create workload using tanzu apps CLI command:

    ```shell
    tanzu apps workload apply tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --app tanzu-java-web-app \
    --namespace YOUR-NEW-DEVELOPER-NAMESPACE \
    --tail \
    --yes
    ```

Using workload yaml
: Create a workload.yaml file with the details as below:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      labels:
        app.kubernetes.io/part-of: tanzu-java-web-app
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

## Out of the Box Supply Chain with Testing

The Out of the Box Supply Chain with Testing adds the **source-tester** step in the supply chain which tests the source code pulled by the supply chain. For source code testing to work in the supply chain, a Tekton Pipeline must exist in the same namespace as the Workload so that, at the right moment, the Tekton PipelineRun object that is created to run the tests can reference the developer-provided Pipeline.

By default, the workload is matched to the corresponding pipeline to run using labels. Pipelines must have the label `apps.tanzu.vmware.com/pipeline: test` at a minimum. This provides a default match if no other labels are provided, but you can add additional labels for granularity. The pipeline expects two parameters:

- `source-url`, an HTTP address with a `.tar.gz` file containing all the source code to be tested
- `source-revision`, the revision of the commit or image reference (in case of `workload.spec.source.image` being set instead of `workload.spec.source.git`)

For example:

```yaml
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

To create a developer namespace, see the [Provision Developer Namespaces](provision-developer-ns.hbs.md).

Namespace Provisioner can automate the creation of a Tekton pipeline that is needed for the workload to run on an Out of the Box Supply Chain with Testing. You can create a sample pipeline in your GitOps repository and add your GitOps repository as an additional source in Namespace Provisioner configuration in `tap-values.yaml`. See [Customize Installation of Namespace Provisioner](customize-installation.hbs.md).

Add the following configuration to `tap-values.yaml` to add [this sample java pipeline](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-supplychain/tekton-pipeline-java.yaml) to your developer namespace:

Using Namespace Provisioner Controller
: Sample `tap-values.yaml` configuration:

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

Using GitOps
: Sample `tap-values.yaml` configuration:

    ```yaml
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

<br>
The sample pipeline resource has the following ytt logic which creates this pipeline only if the following conditions are met:

- `supply_chain` in your `tap-values.yaml` file is either `testing` or `testing_scanning`
- `profile` in your `tap-values.yaml` file is either `full, iterate`, or `build`.

```shell
#@ load("@ytt:data", "data")
#@ def in_list(key, list):
#@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
#@ end
#@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']):
```

After adding the additional source to your `tap-values.yaml` file, you can see the `tekton-pipeline-java` created in your developer namespace. Run the following command to see if the pipeline is created correctly.

```shell
kubectl get pipeline.tekton.dev -n YOUR-NEW-DEVELOPER-NAMESPACE
```

Run the following Tanzu CLI command to create a workload in your developer namespace:

Using Tanzu CLI
: Create workload using tanzu apps CLI command.

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

## <a id='test-scan'></a>Out of the Box Supply Chain with Testing and Scanning

The Out of the Box Supply Chain with Testing and Scanning adds the `source-tester`, `source-scanner`, and `image-scanner` steps in the supply chain which tests the source code pulled by the supply chain and scans for CVEs on the source and the image built by the supply chain. For these new testing and scanning steps to work, the following additional resources must exist in the same namespace as the workload.

- `Pipeline:` defines how to run the tests on the source code pulled by the supply chain and which image to use that has the tools to run those tests.
- `ScanTemplate`: defines how to run a scan, you can change how the scan is run, either for images or source code.

  - A ScanTemplate defines the PodTemplateSpec used by a Job to run a particular scan (image or source). When the supply chain initiates an ImageScan or SourceScan, they reference these templates which must be in the same namespace as the workload.

  - Although you can customize the templates, VMware recommends that you follow what is provided in the installation of the `grype.scanning.apps.tanzu.vmware.com` package. This is automatically created in all the namespaces managed by Namespace Provisioner. For more information, see [About Source and Image Scans](../scst-scan/explanation.hbs.md#about-src-and-image-scans).

- `ScanPolicy`: define how to evaluate whether the artifacts scanned are compliant. For example, allowing one to be either very strict, or restrictive about particular vulnerabilities found.
  - When an ImageScan or a SourceScan is created to run a scan, they reference a policy, the policy name must match the following [sample ScanPolicy](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-scanning-supplychain/scanpolicy-grype.yaml).
  - See [Writing Policy Templates](../scst-scan/policies.hbs.md#writing-a-policy-template).

### Add a Java Tekton Pipeline & Grype Scan Policy to your developer namespace

To create a developer namespace, see [Provision Developer Namespaces](provision-developer-ns.hbs.md).

Namespace Provisioner can automate the creation of a Tekton pipeline and a ScanPolicy that is needed for the workload to run on an Out of the Box Supply Chain with Testing and Scanning. Create a sample Pipeline and a ScanPolicy in your GitOps repository and add your GitOps repository as an additional source in Namespace Provisioner configuration in `tap-values.yaml`. See [Customize Installation of Namespace Provisioner](customize-installation.hbs.md) for more details.

Add the following configuration to your `tap-values.yaml` file to add the [sample java pipeline and grype scan policy ](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/testing-scanning-supplychain)to your developer namespace:

Using Namespace Provisioner Controller
: Sample `tap-values.yaml` configuration:

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

Using GitOps
: Sample `tap-values.yaml` configuration:

    ```yaml
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

The sample Pipeline resource have the following ytt logic which creates this pipeline only if

- `supply_chain` in your `tap-values.yaml` file is either `testing` or `testing_scanning`
- `profile` in your `tap-values.yaml` file is either `full, iterate`, or `build`.

```shell
#@ load("@ytt:data", "data")
#@ def in_list(key, list):
#@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
#@ end
#@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']):
```

The sample ScanPolicy resource have the following ytt logic which creates this pipeline only if

- `supply_chain` in your `tap-values.yaml` file is `testing_scanning`
- `profile` in your `tap-values.yaml`  file is either `full` or `build`.

After adding the additional source to your `tap-values.yaml` file, you can see the `tekton-pipeline-java and scan-policy` created in your developer namespace. Run the following command to see if the pipeline is created correctly.

```shell
kubectl get pipeline.tekton.dev,scanpolicies -n YOUR-NEW-DEVELOPER-NAMESPACE
```

Run the following Tanzu CLI command to create a workload in your developer namespace:

Using Tanzu CLI
: Create workload using tanzu apps CLI command.

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
