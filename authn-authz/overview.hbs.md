# Overview of Default roles for Tanzu Application Platform

Tanzu Application Platform (commonly known as TAP) v{{ vars.url_version }} includes:

- Documentation for [use your existing identity management solution for Kubernetes authentication](integrating-identity.md).
- Six default roles that can be used to provide authorization for users and [service accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/) within a namespace on a cluster that runs one of the Tanzu Application Platform profiles.


## <a id="default-roles"></a> Default roles

Tanzu Application Platform has resources that are namespace scoped (such as workloads, pipelineruns, builds, etc) as well as resources that are cluster scoped (such as clusterbuilders, clustersupplychains, clusterimagetemplates, etc).  For users, the Tanzu Application Platform providers 4 roles that include both a namespace scoped role, as well as a cluster scoped role:

| Role Name | Role Description | Namespace Scoped Role Name | Cluster Scoped Role Name | 
| ---- | ---- | ---- | ---- | ---- |
| app-editor | View, create, edit, and delete a Tanzu workload or deliverable. | app-editor | app-editor-cluster-access |
| app-viewer |  Read-only for a Tanzu workload or deliverable | app-viewer | app-view-cluster-access | 
| app-operator | View, create, edit, and delete supply chain resources |  app-operator | app-operator-cluster-access |
| service-operator | View, create, edit, and delete service instances, service instance classes, and resource claim policiesservice-operator | service-operator| service-operator-cluster-access | 

For an detailed view of the different roles and their permissions, see [Role Descriptions](role-descriptions.md).

Additionally, two roles are included for service accounts for namespace scoped resources associated with Tanzu Supply Chains:


| Role Name | Namespace Scoped Role Name |
| ---- | ---- | ---- |
| workload | workload |
| deliverable | deliverable |

The default roles provide an opinionated starting point for the most common permissions that users
need when using Tanzu Application Platform.
However, as described in the [Kubernetes documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
about RBAC, you can create customized roles and permissions that better meet your needs.
Aggregated cluster roles are used to build VMware Tanzu Application Platform default roles.


Cluster admins must be careful when creating Roles or ClusterRoles.
When changing roles or adding new roles that carry one of the labels used by the default roles, the roles are automatically updated to the aggregation state. It can lead to unintentional changes in functions and permissions to all users.


The default roles are installed with every Tanzu Application Platform profile except for `view`.

## <a id=" assigning-roles"></a>  Assigning with roles using kubectl

For more information about assigning roles to users, see [Bind a user or group to a default role](binding.md).

## <a id="disclaimer"></a> Disclaimer

[Tanzu Developer Portal](../tap-gui/about.md) does not make use of the described roles.
Instead, it provides the user with view access for each cluster.
