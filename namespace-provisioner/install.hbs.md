# Install Namespace Provisioner

Namespace Provisioner is packaged and distributed using the Carvel set of tools.

The Namespace Provisioner Carvel package is  published to the Tanzu Application Platform package
repository and two installation approaches are supported:

- [Install Namespace Provisioner](#install-namespace-provisioner)
  - [Install using a Profile](#install-using-a-profile)
  - [Customized Installation](#customized-installation)

## <a id="tap-profile-based-install"></a>Install using a Profile

To install Namespace Provisioner as part of a wider Tanzu Application Platform profile based
installation, see [Installing Tanzu Application Platform](../install-intro.hbs.md).</br>
The Namespace Provisioner package is installed as part of the standard installation profiles
(i.e. Full, Iterate, Build and Run) and the default set of resources provisioned in a namespace is
based on a combination of the Tanzu Application Platform installation profile employed and the supply
chain that is installed on the cluster.

For a list of what resources are created for different profile/supply chain combinations, see [default resource mapping table](reference.hbs.md#profile-resource-mapping).

## <a id="customized-install"></a>Customized Installation

Run:

```bash
tanzu package available get namespace-provisioner.apps.tanzu.vmware.com/0.1.2 --values-schema -n tap-install
```

The following values are configurable:

- **controller**: Whether to install the [controller](about.hbs.md#nsp-controller) that is part of the package.
  - Set to `true` (Default) to manage the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap) automatically using a [controller](about.hbs.md#nsp-controller) on the cluster.
  - Set to `false` to populate the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap) using an external mechanism such as GitOps, see [Control the `desired-namespaces` ConfigMap via GitOps](how-tos.hbs.md#control-the-desired-namespaces-configmap-via-gitops).
- **aws_iam_role_arn**: If the installation is on AWS with EKS, use the selected IAM Role for Kubernetes Service Accounts.
- **additional_sources**: Add additional sources which contain Platform Operator templated resources to be set on the provisioned namespaces using GitOps in addition to the default-resources that are shipped with Tanzu Application Platform.
  - See the `fetch` section of the [kapp App](https://carvel.dev/kapp-controller/docs/v0.43.2/app-spec/) specification section for the format. Only the Git type fetch is supported.
  - See [Extending the default provisioned resources](how-tos.hbs.md#extending-default-resources)
- **namespace_selector**: The [label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors) used by the [controller](about.hbs.md#nsp-controller) to determine which namespaces should be added to the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap).

Example snippet of `tap-values.yaml`:

```yaml
...
namespace_provisioner:
  controller: true
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
