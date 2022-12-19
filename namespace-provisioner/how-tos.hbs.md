# Namespace Provisioner How-to Guide
This page provides guidance for more advanced use-cases associated with Namespace Provisioner.

The available guides are as follows:
* [Data values templating](#data-values-templating)
* [GitOps customizations](#gitops-customizations):
   1. [Extending the default resources provisioned](#extending-ootb-resources)
   2. [Customizing OOTB default resources](#customizing-ootb-resources)
   3. [Control reconcile behavior of namespace provisioner for certain resources](#control-reconcile-behavior)
   4. [Control the desired-namespace ConfigMap via GitOps](#control-desired-namespaces)

## <a id="data-values-templating"></a>Data Values Templating Guide
Customize your custom resources with data values from TAP values and data from `desired-namespaces` ConfigMap.

Namespace provisioner inherits all of the configuration in the [`desired-namespaces`](about.hbs.md#nsp-component-desired-namespaces-configmap) as well as the tap values under the key `tap_values` making it available for Platform Operators to use as ytt `data.values` when [extending the resources via GitOps](#extending-ootb-resources).

Let's assume that the `desired-namespaces` ConfigMap has a namespace `dev-ns1` with an additional parameter `language: java`.

The `data.values` config that is available to Platform Operators for templating their custom resource looks as follows:

```
# data.values map that can be used for templating custom resources
tap_values:
  ...
  supply_chain: testing_scanning
  profile: full
  ootb_delivery_basic:
    service_account: default
  ootb_supply_chain_basic:
    service_account: default
  ootb_supply_chain_testing_scanning:
    scanning:
      image:
        policy: image-scan-policy
      source:
        policy: scan-policy
    service_account: default
  ootb_supply_chain_testing:
    service_account: default

# Everything below this comes from desired-namespaces ConfigMap
name: dev-ns1  
# additional parameters about dev-ns1 from desired-namespaces ConfigMap
language: java
```

You can use this config while creating custom resources to [extend the OOTB default-resources](#extending-default-resources). 

For those interested, here's a [sample of a templated tekton pipeline.](https://github.com/vmware-tanzu/application-accelerator-samples/namespace-provisioner-gitops-examples/custom-resources/tekton-pipelines/python-test.yaml) 

---

## <a id="gitops-customizations"></a>GitOps Customizations

![namespace provisioner diagram](../images/namespace-provisioner-overview-2.svg)

### <a id="extending-default-resources"></a>Extending the default provisioned resources

Platform Operators may need to do additional namespace customization beyond TAP requirements (such as quota allocation or creation of other namespaced resources) that are not taken care of by the [`default-resources`](about.hbs.md#nsp-component-default-resources) Secret that's created out of the box. 

Platform Operators can add [additional git sources](install.hbs.md#customized-install) in tap-values configuration for the namespace provisioner. 

This allows Platform Operators to extend the out of the box setup with additional resources which enables them to achieve the bespoke customizations needed to meet the unique requirements of thier organization.

In the example `namespace_provisioner` ([snippet from tap-values yaml below](#example-additional-resources)) we add 4 additional sources as follows:</br></br>

* The first additional source points to an example of a [workload service account yaml file](https://github.com/vmware-tanzu/application-accelerator-samples/namespace-provisioner-gitops-examples/custom-resources/workload-sa/workload-sa-with-secrets.yaml) with no ytt templating or overlay.
   * After importing this source, Namespace provisioner will create the following resources in all namespaces mentioned in “desired-namespaces” ConfigMap.</br></br>
* The second additional source points to examples of [ytt templated testing and scanpolicy](https://github.com/vmware-tanzu/application-accelerator-samples/namespace-provisioner-gitops-examples/custom-resources/testing-scanning-supplychain).
   * After importing this source, Namespace provisioner will create a **scan-policy** as well as a **developer-defined-tekton-pipeline-java** in all namespaces in the [`desired-namespaces`](about.hbs.md#nsp-component-desired-namespaces-configmap) ConfigMap with the default setup in [Install OOTB Supply Chain with Testing and Scanning](../getting-started/add-test-and-security.hbs.md#install-OOTB-test-scan) documentation.</br></br>
* The third additional source points to an example of a [ytt templated scanpolicy yaml file](https://github.com/vmware-tanzu/application-accelerator-samples/namespace-provisioner-gitops-examples/custom-resources/scanpolicies/scanpolicies.yaml).
   * After importing this source, Namespace provisioner will create a **snyk-scan-policy** in all namespaces in the [`desired-namespaces`](about.hbs.md#nsp-component-desired-namespaces-configmap) ConfigMap that has an additional parameter **scanpolicy: snyk**.</br></br>
* The fourth additional source points to [examples of ytt templated tekton pipelines](https://github.com/vmware-tanzu/application-accelerator-samples/namespace-provisioner-gitops-examples/custom-resources/tekton-pipelines).
   * After importing this source, Namespace Provisioner will create a **developer-defined-tekton-pipeline-python** and **developer-defined-tekton-pipeline-angular** for namespaces in  the [`desired-namespaces`](about.hbs.md#nsp-component-desired-namespaces-configmap) ConfigMap that has an additional parameter **language: python** and **language: angular** respectively.</br></br>


<a id="example-additional-resources"></a>Example TAP values snippet configuration for namespace_provisioner with additional_sources:
```
namespace_provisioner:
  additional_sources:
  # Add a custom workload service account and a bunch of git secrets
  - git:
      ref: origin/main
      subPath: custom-resources/workload-sa
      url: https://github.com/odinnordico/namespace-provisioner-resources.git
    path: _ytt_lib/workload-sa
  # Add templated scan policies
  - git:
      ref: origin/main
      subPath: custom-resources/testing-scanning-supplychain
      url: https://github.com/odinnordico/namespace-provisioner-resources.git
    path: _ytt_lib/scanpolicies
  # Add templated python & angular scan policies
  - git:
      ref: origin/main
      subPath: custom-resources/scanpolicies
      url: https://github.com/odinnordico/namespace-provisioner-resources.git
    path: _ytt_lib/langscanpolicies
  # Add templated tekton pipelines
  - git:
      ref: origin/main
      subPath: custom-resources/tekton-pipelines
      url: https://github.com/odinnordico/namespace-provisioner-resources.git
    path: _ytt_lib/tektonpipelines


```

---

### <a id="customizing-default-resources"></a>Customizing the default provisioned resources

The Out-Of-The-box [`default-resources`](reference.hbs.md#tap-profile---default-resources-mapping) can be customized by using GitOps with some specific characteristics:

- The GitOps customization should be done by using the [ytt overlay](https://carvel.dev/ytt/docs/latest/lang-ref-ytt-overlay/) feature and should be set in the tap-values under [additional_sources](install.hbs.md#customized-installation).
- The additional git resource should be mounted in the path “_ytt_lib/customize”, otherwise the customization will not be considered
- The GitOps repo folder should have a file with an extension “.lib.yaml” to be recognized as a ytt library with members to be exported
- The library file in the GitOps repo folder should have a function called “customize” with the overlays to be applied to the resources, it can contain 1 or more overlays

The sample file sa-secrets.lib.yaml shows how Platform/App Operators can completely override the “secrets” and “imagePullSecrets” sections of the default ServiceAccount to add custom created secrets by other additional resource. 

Sample tap-values change to pull this ytt customization overlay

```
namespace_provisioner: 
  additional_sources:
  # Patches the OOTB default service account to add different secrets
  - git:
      ref: origin/main
      subPath: default-resources-overrides/overlays
      url: https://github.com/odinnordico/namespace-provisioner-resources.git
    path: _ytt_lib/customize
  # Adds the secrets referenced in the overlay
  - git:
      ref: origin/main
      subPath: custom-resources/workload-sa
      url: https://github.com/odinnordico/namespace-provisioner-resources.git
    path: _ytt_lib/workload-sa
```

---

### <a id="control-reconcile-behavior"></a>Controlling the Namespace Provisioner reconcile behavior for specific resources

---

### <a id="control-desired-namespaces"></a>Control the `desired-namespace` ConfigMap



### Links to additional Namespace Provisioner documentation:
* [Overview](about.hbs.md)
* [Tutorial - Provisioning Namespaces](tutorials.hbs.md) 
* [Installation](install.hbs.md)
* [Troubleshooting](troubleshooting.hbs.md)
* [Reference Materials](reference.hbs.md)