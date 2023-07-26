# Set up Out of the Box Supply Chains in Namespace Provisioner

This topic tells you how to set up Namespace Provisioner to automate resource creation
needed for workloads to run on Out of the Box Supply Chain Basic and Out of the Box Supply Chain with Testing.

## <a id='basic'></a> Out of the Box Supply Chain Basic

To create a developer namespace, see [Provision Developer Namespaces](provision-developer-ns.hbs.md).

Namespace Provisioner creates a set of [default resources](reference.hbs.md#default-resources) in all managed namespaces which are sufficient to run a workload through the Out of the Box Supply Chain Basic.

Run the following Tanzu CLI command to create a workload in your developer namespace.

Using the Tanzu CLI:

  - Create workload using Tanzu apps CLI command:

    ```console
    tanzu apps workload apply tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --app tanzu-java-web-app \
    --namespace DEVELOPER-NAMESPACE \
    --tail \
    --yes
    ```

Using a workload YAML:

  - Create a `workload.yaml` file:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      labels:
        app.kubernetes.io/part-of: tanzu-java-web-app
        apps.tanzu.vmware.com/workload-type: web
      name: tanzu-java-web-app
      namespace: DEVELOPER-NAMESPACE
    spec:
      source:
        git:
          ref:
            branch: main
          url: https://github.com/sample-accelerators/tanzu-java-web-app
    ```

## <a id='testing'></a> Out of the Box Supply Chain with Testing

The Out of the Box Supply Chain with Testing adds the **source-tester** step in
the supply chain which tests the source code pulled by the supply chain. For
source code testing to work in the supply chain, Tekton Pipelines must exist in
the same namespace as the Workload so that the Tekton PipelineRun object that is
created to run the tests can reference the developer-provided Pipeline.

By default, the workload is matched to the corresponding pipeline to run using
labels. Pipelines must have the label `apps.tanzu.vmware.com/pipeline: test`.
This provides a default match if no other labels are provided, but you can add
additional labels. The pipeline expects two parameters:

- `source-url` is an HTTP address with a `.tar.gz` file containing all the source code to test.
- `source-revision` is the revision of the commit or image reference, such as setting `workload.spec.source.image` instead of `workload.spec.source.git`.

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

### <a id='add-dev-ns'></a> Add Java Tekton Pipelines to your developer namespace

To create a developer namespace, see the [Provision Developer Namespaces](provision-developer-ns.hbs.md).

Namespace Provisioner can automate the creation of a Tekton pipeline needed for
the workload to run on an Out of the Box Supply Chain with Testing. You can
create an example pipeline in your GitOps repository and add your GitOps
repository as an additional source in Namespace Provisioner configuration in
`tap-values.yaml`. See [Customize Installation of Namespace
Provisioner](customize-installation.hbs.md).

Add the following configuration to `tap-values.yaml` to add [this example java pipeline](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-supplychain/tekton-pipeline-java.yaml) to your developer namespace:

Using Namespace Provisioner Controller:

  - Example `tap-values.yaml` configuration:

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

Using GitOps:

- Example `tap-values.yaml` configuration:

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

The example pipeline resource has the following ytt logic which creates this pipeline only if the following conditions are met:

- `supply_chain` in your `tap-values.yaml` file is either `testing` or `testing_scanning`
- `profile` in your `tap-values.yaml` file is either `full, iterate`, or `build`.

```console
#@ load("@ytt:data", "data")
#@ def in_list(key, list):
#@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
#@ end
#@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']):
```

After adding the additional source to your `tap-values.yaml` file, you can see the `tekton-pipeline-java` created in your developer namespace. To verify that the pipeline is created correctly:

```console
kubectl get pipeline.tekton.dev -n DEVELOPER-NAMESPACE
```

Where `DEVELOPER-NAMESPACE` is the name of the new developer namespace you want to use.

Run the following Tanzu CLI command to create a workload in your developer namespace:

Using the Tanzu CLI:

  - Create workload using Tanzu apps CLI command.

    ```console
    tanzu apps workload apply tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --app tanzu-java-web-app \
    --label apps.tanzu.vmware.com/has-tests="true" \
    --namespace DEVELOPER-NAMESPACE \
    --tail \
    --yes
    ```

Using workload YAML:

  - Create a `workload.yaml` file:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      labels:
        app.kubernetes.io/part-of: tanzu-java-web-app
        apps.tanzu.vmware.com/has-tests: "true"
        apps.tanzu.vmware.com/workload-type: web
      name: tanzu-java-web-app
      namespace: DEVELOPER-NAMESPACE
    spec:
      source:
        git:
          ref:
            branch: main
          url: https://github.com/sample-accelerators/tanzu-java-web-app
    ```

## <a id='test-scan'></a> Out of the Box Supply Chain with Testing and Scanning

The Out of the Box Supply Chain with Testing and Scanning adds the
`source-tester`, `source-scanner`, and `image-scanner` steps in the supply
chain. See [Scan Types for Supply Chain Security Tools -
Scan](../scst-scan/scan-types.hbs.md#source-scan). These steps test the source
code pulled by the supply chain and scans for CVEs on the source and the image
built by the supply chain. For these new testing and scanning steps to work, the
following additional resources must exist in the same namespace as the workload:

- `Pipeline:` defines how to run the tests on the source code pulled by the supply chain and which image to use that has the tools to run those tests.
- `ScanTemplate`: defines how to run a scan, you can change how the scan is run, either for images or source code.

  - A ScanTemplate defines the PodTemplateSpec used by a Job to run a particular scan, such as an image or source. When the supply chain initiates an ImageScan or SourceScan, they reference these templates which must be in the same namespace as the workload.

  - Although you can customize the templates, VMware recommends that you follow the installation of the `grype.scanning.apps.tanzu.vmware.com` package. This is automatically created in all the namespaces managed by Namespace Provisioner. For more information, see [About Source and Image Scans](../scst-scan/explanation.hbs.md#about-src-and-image-scans).

- `ScanPolicy` defines how to evaluate whether the artifacts scanned are compliant. For example, allowing one to be restrictive about particular vulnerabilities found.
  - When an ImageScan or a SourceScan is created to run a scan, they reference a policy, the policy name must match the following [example ScanPolicy](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/testing-scanning-supplychain/scanpolicy-grype.yaml).
  - See [Writing Policy Templates](../scst-scan/policies.hbs.md#writing-a-policy-template).

### <a id='add-grype-dev-ns'></a> Add Java Tekton Pipelines Grype Scan Policy to your developer namespace

To create a developer namespace, see [Provision Developer Namespaces](provision-developer-ns.hbs.md).

Namespace Provisioner can automate the creation of a Tekton pipeline and a
ScanPolicy that is needed for the workload to run on an Out of the Box Supply
Chain with Testing and Scanning. Create an example Pipeline and a ScanPolicy in
your GitOps repository and add your GitOps repository as an additional source in
Namespace Provisioner configuration in `tap-values.yaml`. See [Customize
Installation of Namespace Provisioner](customize-installation.hbs.md).

Add the following configuration to your `tap-values.yaml` file to add the example java pipeline and grype scan policy to your developer namespace. See [application-accelerator-samples](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/testing-scanning-supplychain) in GitHub.

Using Namespace Provisioner Controller:

  - Sample `tap-values.yaml` configuration:

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

Using GitOps:

- Example `tap-values.yaml` configuration:

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

The example Pipeline resource have the following ytt logic which creates this pipeline only if

- `supply_chain` in your `tap-values.yaml` file is either `testing` or `testing_scanning`
- `profile` in your `tap-values.yaml` file is either `full, iterate`, or `build`.

```console
#@ load("@ytt:data", "data")
#@ def in_list(key, list):
#@  return hasattr(data.values.tap_values, key) and (data.values.tap_values[key] in list)
#@ end
#@ if/end in_list('supply_chain', ['testing', 'testing_scanning']) and in_list('profile', ['full', 'iterate', 'build']):
```

The example ScanPolicy resource have the following ytt logic which creates this pipeline only if

- `supply_chain` in your `tap-values.yaml` file is `testing_scanning`
- `profile` in your `tap-values.yaml`  file is either `full` or `build`.

After adding the additional source to your `tap-values.yaml` file, you can see the `tekton-pipeline-java and scan-policy` created in your developer namespace. To verify that the pipeline is created correctly:

```console
kubectl get pipeline.tekton.dev,scanpolicies -n DEVELOPER-NAMESPACE
```

Where `DEVELOPER-NAMESPACE` is the name of the new developer namespace you want to use.

Run the following Tanzu CLI command to create a workload in your developer namespace:

Using the Tanzu CLI:

  - Create workload using Tanzu apps CLI command.

    ```console
    tanzu apps workload apply tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --app tanzu-java-web-app \
    --label apps.tanzu.vmware.com/has-tests="true" \
    --namespace DEVELOPER-NAMESPACE \
    --tail \
    --yes
    ```

Using a workload YAML:

  - Create a workload.yaml file:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      labels:
        app.kubernetes.io/part-of: tanzu-java-web-app
        apps.tanzu.vmware.com/has-tests: "true"
        apps.tanzu.vmware.com/workload-type: web
      name: tanzu-java-web-app
      namespace: DEVELOPER-NAMESPACE
    spec:
      source:
        git:
          ref:
            branch: main
          url: https://github.com/sample-accelerators/tanzu-java-web-app
    ```
