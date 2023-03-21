# Namespace Provisioner

Namespace Provisioner provides a secure, automated way for platform operators to provision
namespaces with the resources and namespace-level privileges required for their workloads
to function as intended. It enables operators to add additional customized namespace-scoped resources using GitOps to meet their organization's requirements.

Namespace Provisioner enables operators that are new to Kubernetes to automate the provisioning of
multiple developer namespaces in a shared cluster. For organizations that have already adopted
Kubernetes, Namespace Provisioner is also compatible with existing Kubernetes tooling.

Controller mode
: Controller mode has the following characteristics:

- List of developer namespaces are managed by the namespace provisioner controller via a label selector apps.tanzu.vmware.com/tap-ns=""
- Namespace provisioner creates default resources that are shipped Out of the Box in all managed namespaces.
- Namespace provisioner creates additional Platform Operator templated resources stored in Git repository locations specified under additional_sources section in Namespace Provisioner configuration. (See Customize Installation for more details)

GitOps mode
: Gitops mode has the following characteristics:

- List of developer namespaces is managed in a Git repository referred via the gitops_install section of the Namespace Provisioner configuration.
- Namespace provisioner creates default resources that are shipped Out of the Box in all managed namespaces.
- Namespace provisioner creates additional Platform Operator templated resources stored in Git repository locations specified under additional_sources in Namespace Provisioner configuration. (See Customize Installation for more details)
