# Namespace Provisioner Installation
Namespace Provisioner is packaged and distributed by using the Carvel set of tools.

The Namespace Provisioner carvel package is currently published to the Tanzu Application Platform package repository and two installation approaches are supported:

1. [Default TAP Profile-based Installation](#tap-profile-based-install)
2. [Customized Installation](#customized-install)

## <a id="tap-profile-based-install"></a>TAP Profile-based Installation
To install it as part of a wider Tanzu Application Platform profile based installation, see [**Installing Tanzu Application Platform**](../install-intro.hbs.md).</br>
The Namespace Provisioner package is installed as part of the standard TAP installation profiles (i.e. Full, Iterate, Build and Run) and the default set of resources provisioned in a given namespace is based on a combination of the TAP installation profile employed and the supply chain that is installed on the cluster.

To see a list of what resources are created for different profile/supply chain combinations out-of-the-box, please refer to the [**TAP Profile Resource Mapping table**](reference.hbs.md#profile-resource-mapping) on the [Namespace Provisioner reference page](reference.hbs.md).

## <a id="customized-install"></a>Customized Installation
For getting valid schema values to set in the `namespace_provisioner` run the following command: 

```
$ tanzu package available get namespace-provisioner.apps.tanzu.vmware.com/0.1.2 --values-schema -n tap-install
```
The following values are configurable:
* **controller**:  Whether to install the namespace provisioner controller that is part of the package.
  * Set to `true` (Default) if Platform Operators prefer to have the `desired-namespaces` ConfigMap automatically managed by a controller on the cluster.
  * Set to `false` if Platform Operators choose to populate `desired-namespaces` ConfigMap via an external mechanism such as GitOps (see [How to Control `desired-namespaces` via GitOps](how-tos.hbs.md#gitops-desired-namespaces)). 
* **aws_iam_role_arn**: If the installation is on AWS with EKS, use the selected IAM Role for Kubernetes Service Accounts.
* **additional_sources**: Add additional sources which contain Platform Operator templated resources to be set on the provisioned namespaces via GitOps in addition to the default-resources that are shipped with TAP. 
  * Please refer to the `fetch` section of the [kapp App](https://carvel.dev/kapp-controller/docs/v0.43.2/app-spec/) specification section for the format. We only support git type fetch for TAP 1.4.
  * See the how-to guide on [Extending Namespace Provisioner “default-resources” using GitOps](how-tos.hbs.md#gitops-extend-default-resources)
* **namespace_selector**: The [label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors) used by the controller to determine which namespaces should be added to the [desired-namespace ConfigMap](about.hbs.md#desired-namespaces-configmap).

Example snippet of tap-values.yaml:
```
...
namespace_provisioner:
  controller: yes
  namespace_selector:
    matchExpressions:
    - key: apps.tanzu.vmware.com/tap-ns
      operator: Exists
  aws_iam_role_arn: "arn:aws:iam::123456789012:role/EKSIAMRole"
  additional_sources:
  # Patches the OOTB scan policy with a different rego data
  - git:
       ref: origin/main
      subPath: namespace-provisioner-gitops-examples/default-resources-overrides/overlays
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    path: _ytt_lib/customize
  # Add a custom workload service account and a bunch of git secrets
  - git:
      ref: origin/main
      subPath: namespace-provisioner-gitops-examples/custom-resources/workload-sa
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    path: _ytt_lib/workload-sa
  # Add templated scan policies
...
```

### Links to additional Namespace Provisioner documentation:
* [Overview](about.hbs.md)
* [Tutorial - Provisioning Namespaces](tutorials.hbs.md) 
* [How-To Provision and Customize Namespaces via GitOps](how-tos.hbs.md)
* [Troubleshooting](troubleshooting.hbs.md)
* [Reference Materials](reference.hbs.md)