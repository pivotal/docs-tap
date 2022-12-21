# Namespace Provisioner Reference

## <a id="known-limitations"></a>Known Limitations/Issues

- If there is a namespace in your GitOps repo 
  [**`desired-namespaces`**](about.hbs.md#desired-namespaces-configmap) ConfigMap that does not 
  exist on the cluster, the `provisioner` app will fail to reconcile and will not be able to create resources.
- The Creation of the namespaces themselves is out of the scope for the namespace provisioner package.
- Removing namespace provisioner package removes all the components created by it
- **Before uninstalling the namespace provisioner**, Platform/App Operators are required to
  - If using the controller to manage `desired-namespaces` ConfigMap, Un-label all the namespaces 
    provisioned by namespace provisioner
  - If using GitOps to manage `desired-namespaces` ConfigMap, set the list of namespaces to an 
    empty list.

## <a id="default-resources-mapping"></a>TAP profile - default resources mapping

The following table shows the list of resources that are templated in the `default-resources` 
Secret for a given TAP installation profile and supply chain value combination:

| Namespace  | Kind | Name | supply_chain | Install Profile | Reconcile? |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| tap-install  | PackageInstall | grype-scanner-{ns} | testing_scanning | full, build | Yes  |
| tap-install  | Secret | grype-scanner-{ns} | testing_scanning | full, build | Yes |
| Developer Namespace  | Secret | registries-credentials | --- | full, iterate, build, run | Yes |
| Developer Namespace  | ServiceAccount | From: ootb_supply_chain_{supply_chain}.service_account (default: "default") | --- | full, iterate, build, run | **No** |
| Developer Namespace  | ServiceAccount | From: ootb_delivery_basic.service_account (default: "default") | --- | full, iterate, run | **No**  |
| Developer Namespace  | RoleBinding | default-permit-deliverable | --- | full, iterate, run | Yes  |
| Developer Namespace  | RoleBinding | default-permit-workload | --- | full, iterate, build | Yes  |

Note: For Install OOTB Supply Chain with Testing and Scanning check the section Extend the OOTB default-resources

</br>

---

### Links to additional Namespace Provisioner documentation:

- [Overview](about.hbs.md)
- [Installation](install.hbs.md)
- [Tutorial - Provisioning Namespaces](tutorials.hbs.md) 
- [How-To Provision and Customize Namespaces via GitOps](how-tos.hbs.md)
- [Troubleshooting](troubleshooting.hbs.md)
