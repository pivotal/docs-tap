# View resources on remote clusters

You can control the access to Kubernetes runtime resources on Tanzu Developer Portal
(formerly called Tanzu Application Platform GUI) based on user roles and permissions for each of the visible remote clusters.

> **Caution** Setting up role-based access control (RBAC) might impact the user's ability to view
> workloads in the Security Analysis GUI and the Workloads table of the Supply Chain Choreographer
> plug-in GUI.

RBAC is currently supported for the following Kubernetes cluster providers:

- [EKS](set-up-tap-gui-rbac-eks.html) (Elastic Kubernetes Service) on AWS
- [GKE](set-up-tap-gui-rbac-gke.html) (Google Kubernetes Engine) on GCP

Support for other Kubernetes providers is planned for future releases of Tanzu Application Platform.

Tanzu Developer Portal is designed under the assumption that the roles and permissions for
the Kubernetes clusters are already defined and that the users are already assigned to their roles.
For information about assigning roles and permissions to users, see
[Assigning roles and permissions on Kubernetes clusters](assigning-kubernetes-roles.html).

Adding access-controlled visibility for a remote cluster is similar to
[Setting up unrestricted remote cluster visibility](../cluster-view-setup.html).

The steps are:

1. Set up the OIDC provider
2. Configure the Kubernetes cluster with the OIDC provider
3. Configure the Tanzu Developer Portal to view the remote cluster
4. Upgrade the Tanzu Developer Portal package

After following these steps, you can view your runtime resources on a remote cluster in
Tanzu Developer Portal.
For more information, see [View runtime resources on remote clusters](view-resources-rbac.md).