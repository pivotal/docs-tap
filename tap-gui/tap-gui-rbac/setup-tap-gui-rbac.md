# Enable Authorization on Remote Clusters in Tanzu Application Platform GUI

You can control the access to Kubernetes runtime resources on Tanzu Application Platform GUI based on users' role and permissions for each of visible remote clusters. Role-Based Access Control (RBAC) is currently supported for the following Kubernetes cluster providers:

- [GKE](./setup-tap-gui-rbac-with-gke-auth.md) (Google Kubernetes Engine) on GCP

Support for other Kubernetes providers will be added in future releases of Tanzu Application Platform.

We assume that the roles and permissions for the Kubernetes clusters have been defined and that the users have been asigned to their roles. For more guidance on how to assign roles and permissions to users, please refer to [Assigning roles and permissions on Kubernetes clusters](./assigning-kubernetes-roles.md).

The general process for adding access-controlled visibility for a remote cluster is similar to [Setting up unrestricted remote cluster visibility](./../cluster-view-setup.md). The steps include:

1. Set up the OIDC provider (pre-requisite)
2. Configure the Kubernetes cluster with the OIDC provider
3. Configure the Tanzu Application Platform GUI to view the remote cluster
4. Upgrade the Tanzu Application Platform GUI package

Once these steps are complete, you can view your runtime resources on a remote cluster in Tanzu Application Platform GUI. For more detail, please refer to [View Runtime Resources on Remote Clusters in Tanzu Application Platform GUI](./view-resouces-rbac.md).