# Overview of Default roles for Tanzu Application Platform

Tanzu Application Platform (commonly known as TAP) v{{ vars.url_version }} includes:

- Documentation for using your existing identity management solution for Kubernetes authentication. For more information, see [Set up authentication for your Tanzu Application Platform deployment](integrating-identity.md).
- Six default roles for providing authorization for users and service accounts within a namespace on a cluster that runs one of the Tanzu Application Platform profiles. For more information about service accounts, see the [Kubernetes documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/).


## <a id="default-roles"></a> Default roles

Tanzu Application Platform has resources that are namespace scoped, such as workloads, pipelineruns, builds and resources that are cluster scoped, such as clusterbuilders, clustersupplychains, clusterimagetemplates.  Tanzu Application Platform provides four roles that include both a namespace scoped role and a cluster scoped role:

| Role name | Role description | Namespace scoped role name | Cluster scoped role name | 
| ---- | ---- | ---- | ---- | ---- |
| app-editor | View, create, edit, and delete a Tanzu workload or deliverable. | app-editor | app-editor-cluster-access |
| app-viewer |  Read-only for a Tanzu workload or deliverable. | app-viewer | app-view-cluster-access | 
| app-operator | View, create, edit, and delete supply chain resources. |  app-operator | app-operator-cluster-access |
| service-operator | View, create, edit, and delete service instances, service instance classes, and resource claim policies. | service-operator| service-operator-cluster-access | 

For more information about the different roles and their permissions, see [Role descriptions for Tanzu Application Platform](role-descriptions.md).

Additionally, the following two roles are available for service accounts for namespace scoped resources associated with Tanzu Supply Chains:

| Role name | Namespace scoped role name |
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
