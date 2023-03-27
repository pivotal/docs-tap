Namespace Provisioner Reference

# Known Limitation/Issues

If you are using a GitOps repository to manage the list of namespaces, all the namespaces in the list must exist in the cluster if the user chooses not to create them via some other means. The provisioner application will fail to reconcile if the namespaces do not exist on the cluster.
If you are using the Controller workflow, and then switch to the full GitOps (controller: false) managed namespaces list, you must manually remove the finalizer on all the namespaces previously managed by the controller as it will no longer be available to clean the finalizers up.
If you want to use different private repositories, the secret used for each entry (gitops_install, additional_sources) must be of a unique name. Re-using the same secret is currently not supported due to a limitation in kapp-controller.

# Default Resources
Namespace Provisioner is installed as part of the standard installation profiles (i.e. Full, Iterate, Build, and Run) and the default set of resources provisioned in a namespace is based on a combination of the installation profile employed and the supply chain that is installed on the cluster. The following table shows the list of resources that are templated in the default-resources Secret for an installation profile and supply chain value combination:
Namespace
Kind
Name
supply_chain
Install Profile
Reconcile
tap-install
PackageInstall
grype-scanner-{ns}
testing_scanning
full, build
Yes
tap-install
Secret
grype-scanner-{ns}
testing_scanning
full, build
Yes
Developer Namespace
Secret
registries-credentials
n/a
full, iterate, build, run
Yes
Developer Namespace
ServiceAccount
From: ootb_supply_chain_{supply_chain}.service_account (default: “default”)
n/a
full, iterate, build, run
No
Developer Namespace
ServiceAccount
From: ootb_delivery_basic.service_account (default: “default”)
n/a
full, iterate, run
No
Developer Namespace
RoleBinding
default-permit-deliverable
n/a
full, iterate, run
Yes
Developer Namespace
RoleBinding
default-permit-workload
n/a
full, iterate, build
Yes
Developer Namespace
LimitRange
{namespace}-lr
n/a
full, iterate, run
Yes

For installing additional resources for OOTB Supply Chain with Testing and Scanning, see Testing & Scanning Supply chain guide.




