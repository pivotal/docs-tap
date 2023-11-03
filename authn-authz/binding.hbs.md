# Bind a user or group to a default role

Once your identity provider for Kubernetes has been configured, users can be authenticated to Kubernetes, however, they still need to be authorized to perform actions on resources.  In order to do this, you can use kubectl to create role bindings that binds a user to the roles defined in [role descriptions](role-descriptions.hbs.md).

## <a id="prereqs"></a> Prerequisites

1. Ensure you have kubectl configured and admin access to the cluster.
1. Ensure you have configured an authentication solution for the cluster.
You can use [Pinniped](https://pinniped.dev/) or the authentication service native to your Kubernetes distribution.

## <a id="Managing-user-group-to-role"></a> Managing a user or groups mapping to a role

User or group mapping to a role is granted by a [Kubernetes rolebinding or clusterrole binding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding).  A RoleBinding grants a role or clusterrole to a specific namespace.  Alternatively, a clusterbinding maps a clusterrole to all namespaces.

Each of the four roles for users have both a role for namespace scoped resources, as well as a role for cluster scoped resources.  To ensure that the roles have access to the resources at the correct scoping, you should create bindings for both the namespace scoped resources and the cluster scoped resources.  The role and clusterroles are as follows:


There are many ways to manage the binding of a user or group to a role.  This guide will walk you through how to use Kubernetes manifests to create the binding between a user/group and roles.  By using a manifest, this will also allow you add or remove users/roles after initial creation by simply applying the updated manifiest.

The following is an example of mapping the user "developer-1" to the app-editor" role.

    ```console
    kubectl apply -n DEVELOPER_NAMESPACE -f - << EOF
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: app-editor
      namespace: $DEVELOPER_NAMSPACE
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: app-editor
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: User
      name: developer-1
    EOF
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: app-editor-cluster-access
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: app-editor-cluster-access
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: User
      name: developer-1
    ```

To simplify the management of user to role membership, you may wish to bind a group to a role and manage group membership in an enteprise identity provider.  For example, if you wanted to add the group "developers" to the app-editor role, you could use the following:

    ```console
    kubectl apply -n DEVELOPER_NAMESPACE -f - << EOF
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: app-editor
      namespace: $DEVELOPER_NAMSPACE
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: app-editor
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: developers
    EOF
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: app-editor-cluster-access
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: app-editor-cluster-access
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: developers
    ```

Additional users or groups can be added to the role by adding another subject to the list.  For example, if you wanted to add the "developer-2" user, the `subjects` key would look like this:

    ```console
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: User
      name: developer-1
    - apiGroup: rbac.authorization.k8s.io
      kind: User
      name: developer-2
    ```
    
Additionally, you can use a combination of users and groups in the `subject` key as follows:

    ```console
    subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: Group
      name: developers
    - apiGroup: rbac.authorization.k8s.io
      kind: User
      name: developer-1
    ```