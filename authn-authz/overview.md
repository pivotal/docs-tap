# Overview

Tanzu Application Platform 1.1 includes:

- Documentation for [integrating with your existing identity management solution](integrating-identity.md).
- Five new default roles to help you set up permissions for users and service accounts within a namespace on a cluster that runs one of the Tanzu Application Platform profiles.
- TAP `rbac` CLI plug-in for role binding.

## Default roles

Three of these roles are for users, including:

- app-editor
- app-viewer
- app-operator

Two of these roles are for service accounts associated with the Tanzu Supply Chain, including:

- workload
- deliverable

The default roles provide an opinionated starting point for the most common permissions that the users need when using Tanzu Application Platform. However, with [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/), you have flexibility in creating customized roles and permissions that better meet your business needs. VMware Tanzu Application Platform default roles are built by using aggregated cluster roles.

The default roles are installed with every Tanzu Application Platform profile. For an overview of the different roles and their permissions, see [Role Descriptions](role-descriptions.md).

## <a id="work-with-roles"></a>Working with roles using the `rbac` CLI plug-in

For more information about working with roles, see [Bind a user or group to a default role](binding.md).

## Additional Information
- [SCA scanning results](sca-scanning-results.md)