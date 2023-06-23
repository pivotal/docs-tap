# Namespace Provisioner Reference Guide

This topic tells you about the known limitations and default resource mapping for the Namespace
Provisioner component in Tanzu Application Platform (commonly known as TAP).

## <a id="known-limitations"></a>Known Limitations

- If there is a namespace in your GitOp's repository [desired-namespaces](about.hbs.md#desired-ns-configmap)
ConfigMap that does not exist on the cluster, the `provisioner` application fails to reconcile
and cannot create resources.
- The creation of the namespaces is out of scope for Namespace Provisioner.
- Removing the Namespace Provisioner package removes all the components created by it.
- Before uninstalling the Namespace Provisioner, you must:
  - If you are using the [controller](about.hbs.md#nsp-controller) to manage [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap), un-label all the
    namespaces provisioned by Namespace Provisioner
  - If you are using GitOps to manage [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap), set the list of namespaces to an
    empty list.
- The namespace selector label to provision resources cannot be applied to the developer namespace
  which is configured at deployment time under the Grype package values as it causes the provisioner
  application to fail due to ownership issues.

## <a id="default-resources-mapping"></a>Default resources mapping

Namespace Provisioner is installed as part of the [standard installation profiles](../about-package-profiles.hbs.md#profiles-and-packages).
The default set of resources provisioned in a namespace is
based on a combination of the installation profile and the supply chain that is installed
on the cluster. The following table shows the list of resources that are templated in the
`default-resources` Secret for an installation profile and supply chain value combination:

| Namespace  | Kind | Name | supply_chain | Install Profile | Reconcile |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| tap-install  | PackageInstall | grype-scanner-{ns} | testing_scanning | full, build | Yes  |
| tap-install  | Secret | grype-scanner-{ns} | testing_scanning | full, build | Yes |
| Developer Namespace  | Secret | registries-credentials | n/a | full, iterate, build, run | Yes |
| Developer Namespace  | ServiceAccount | From: ootb_supply_chain_{supply_chain}.service_account (default: "default") | n/a | full, iterate, build, run | No |
| Developer Namespace  | ServiceAccount | From: ootb_delivery_basic.service_account (default: "default") | n/a| full, iterate, run | No  |
| Developer Namespace  | RoleBinding | default-permit-deliverable | n/a | full, iterate, run | Yes  |
| Developer Namespace  | RoleBinding | default-permit-workload | n/a | full, iterate, build | Yes  |

>**Note** For Install OOTB Supply Chain with Testing and Scanning, see [Extending the default provisioned resources](how-tos.hbs.md#extending-default-resources).
