# View resources on remote clusters

You can control the access to Kubernetes runtime resources on Tanzu Application Platform GUI
(commonly called TAP GUI) based on user roles and permissions for each of the visible remote clusters.

RBAC is currently supported for the following Kubernetes cluster providers:

- [EKS](set-up-tap-gui-rbac-eks.html) (Elastic Kubernetes Service) on AWS
- [GKE](set-up-tap-gui-rbac-gke.html) (Google Kubernetes Engine) on GCP

Support for other Kubernetes providers is planned for future releases of Tanzu Application Platform.

Tanzu Application Platform GUI is designed under the assumption that the roles and permissions for
the Kubernetes clusters are already defined and that the users are already assigned to their roles.
For information about assigning roles and permissions to users, see
[Assigning roles and permissions on Kubernetes clusters](assigning-kubernetes-roles.html).

Adding access-controlled visibility for a remote cluster is similar to
[Setting up unrestricted remote cluster visibility](../cluster-view-setup.html).

The steps are:

1. Set up the OIDC provider
2. Configure the Kubernetes cluster with the OIDC provider
3. Configure the Tanzu Application Platform GUI to view the remote cluster
4. Upgrade the Tanzu Application Platform GUI package

After following these steps, you can view your runtime resources on a remote cluster in
Tanzu Application Platform GUI.
For more information, see [View runtime resources on remote clusters](view-resources-rbac.md).
