# Overview

Tanzu Application Platform 1.1 introduces five new default roles to make it faster and easier to set up permissions for users and service accounts within a namespace on a cluster running one of the Tanzu Application Platform Profiles. Three of these roles are meant for users: app-editor, app-viewer and app-operator. Two of these roles are meant for service accounts associated with the Tanzu Supply Chain: workload and deliverable. 

The default roles are meant to provide an opinionated starting point for the most common permissions users will need while using Tanzu Application Platform. However, using [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/), you have ultimate flexibility in creating customized roles and permissions that meet the needs of your business. Our default roles are built using aggregated cluster roles. 

The default roles will be installed automatically with every Tanzu Application Platform profile. For an overview of the different roles and what permission they have, see [Role Descriptions](role-descriptions.md).

## Working with Roles

* [How to bind a user or group to a default role](binding.md)