# Namespace Provisioner reference

This topic contains know issues and limitations
## Known limitations and issues

If you are using a GitOps repository to manage the list of namespaces, all the namespaces in the list must exist in the cluster. The provisioner application fails to reconcile if the namespaces do not exist on the cluster.

If you switch from  controller mode to GitOps mode, you must manually remove the finalizer on all the namespaces previously managed by the controller. For more information on using controller versus GitOps, see [Manage a list of developer namespaces](provision-developer-ns.md).

To use different private repositories, the secret used for each entry (gitops_install, additional_sources) must be a unique name. Re-using the same secret is not supported due to a limitation in kapp-controller.

## <a id='default-resources'></a>Default resources

Namespace Provisioner is installed as part of the standard installation profiles.  and the default set of resources provisioned in a namespace is based on a combination of the installation profile employed and the supply chain that is installed on the cluster. For more information about installation profiles, see [Installation profiles in Tanzu Application Platform](../about-package-profiles.hbs.md#profiles-and-packages)

 The following table shows the list of resources that are templated in the default-resources secret for an installation profile and supply chain value combination:

| Namespace  | Kind | Name | supply_chain | Install Profile | Reconcile |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| tap-install  | PackageInstall | grype-scanner-{ns} | testing_scanning | full, build | Yes  |
| tap-install  | Secret | grype-scanner-{ns} | testing_scanning | full, build | Yes |
| Developer Namespace  | Secret | registries-credentials | n/a | full, iterate, build, run | Yes |
| Developer Namespace  | ServiceAccount | From: ootb_supply_chain_{supply_chain}.service_account (default: "default") | n/a | full, iterate, build, run | No |
| Developer Namespace  | ServiceAccount | From: ootb_delivery_basic.service_account (default: "default") | n/a| full, iterate, run | No  |
| Developer Namespace  | RoleBinding | default-permit-deliverable | n/a | full, iterate, run | Yes  |
| Developer Namespace  | RoleBinding | default-permit-workload | n/a | full, iterate, build | Yes  |
| Developer Namespace | LimitRange | {namespace}-lr | n/a | run | Yes |

For installing additional resources for OOTB Supply Chain with Testing and Scanning, see [Supply Chain Security Tools - Scan](../scst-scan/overview.hbs.md).
