# Bind a user or group to a default role

This topic tells you how to use Kubernetes manifests to create the binding between users or groups and roles. Using a manifest allows you to add or remove users or groups after the initial creation. You can update the manifest and re-apply it by using kubectl.

After configuring your identity provider for Kubernetes, users can be authenticated to Kubernetes. However, they must be authorized to perform actions on resources. You can use kubectl to create role bindings that binds a user to the roles. For more information, see [Role descriptions for Tanzu Application Platform](role-descriptions.hbs.md).

## <a id="prereqs"></a> Prerequisites

1. Configure kubectl and have admin access to the cluster.
1. Configure an authentication solution for the cluster.
You can use [Pinniped](https://pinniped.dev/) or the authentication service native to your Kubernetes distribution.

## <a id="user-group-to-role"></a> Manage a user or groups mapping to a role

A Kubernetes RoleBinding or ClusterRoleBinding grants a user or group mapping to a role. A RoleBinding grants a role or ClusterRole to a specific namespace. Alternatively, a ClusterBinding maps a clusterrole to all namespaces. For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding).

Each of the four roles for users have both a role for namespace scoped resources and a role for cluster scoped resources. To ensure that the roles have access to the resources at the correct scoping, you must create bindings for both the namespace scoped resources and the cluster scoped resources. For a listing of the roles and cluster roles for each out-of-the-box Tanzu Application Platform role, see [Default roles](overview.hbs.md#default-roles).

The following is an example of mapping the user `developer-1` to the `app-editor` role:

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

Where `DEVELOPER-NAMESPACE` is the namespace for scoping the developers access.

To simplify the management of user to role membership, you can bind a group to a role in Kubernetes and manage a users group membership with an enteprise identity provider. For an example of Azure AD, see [Integrate your Azure Active Directory](azure-ad.hbs.md). 

The following example demonstrates how to add the group `developers` to the `app-editor` role:

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

Where `DEVELOPER-NAMESPACE` is the namespace for scoping the developers access.

To add additional users or groups to the role, you can add another subject to the list. For example, to add the user `developer-2`, the `subjects` key looks like the following:

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
