# Known limitations and issues

This topic describes the know issues and limitations for Namespace Provisioner.

- If you are using a GitOps repository to manage the list of namespaces, all the namespaces in the list must exist in the cluster. The provisioner application fails to reconcile if the namespaces do not exist on the cluster.

- To use different private repositories, the secret used for each entry (gitops_install, additional_sources) must be a unique name. Re-using the same secret is not supported due to a limitation in kapp-controller.

- Before performing any of these operations, such as uninstalling the provisioner or transitioning from the Controller mode to the GitOps mode, ensure that you clean up the finalizer (`namespace-provisioner.apps.tanzu.vmware.com/finalizer`) for all namespaces managed by the provisioner. This can be done either by removing the label used to set the namespaces as managed (refer to[Manage a list of developer namespaces](provision-developer-ns.hbs.md)), or by manually editing the namespace manifest and removing the finalizer entry.
