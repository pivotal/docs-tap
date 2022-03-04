# Overview

Tanzu Application Platform 1.1 introduces five new default roles to help you set up permissions for users and service accounts within a namespace on a cluster running one of the Tanzu Application Platform profiles. Three of these roles are for users:

- app-editor
- app-viewer
- app-operator

Two of these roles are for service accounts associated with the Tanzu Supply Chain:

- workload
- deliverable

The default roles provide an opinionated starting point for the most common permissions users need while using Tanzu Application Platform. However, with [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/), you have flexibility in creating customized roles and permissions that meet the needs of your business. VMware Tanzu Application Platform default roles are built using aggregated cluster roles.

The default roles are installed automatically with every Tanzu Application Platform profile. For an overview of the different roles and what permission they have, see [Role Descriptions](role-descriptions.md).

## Working with roles

For more information on working with roles, see [Bind a user or group to a default role](binding.md).