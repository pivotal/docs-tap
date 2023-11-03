# Bind a user or group to a default role

Once your identity provider for Kubernetes has been configured, users can be authenticated to Kubernetes, however, they still need to be authorized to perform actions on resources.  In order to do this, you can use kubectl to create role bindings that binds a user to the roles defined in [role descriptions](role-descriptions.hbs.md).

## <a id="prereqs"></a> Prerequisites

1. Ensure you have kubectl configured and admin access to the cluster.
1. Ensure you have configured an authentication solution for the cluster.
You can use [Pinniped](https://pinniped.dev/) or the authentication service native to your Kubernetes distribution.

## <a id="Managing-user-group-to-role"></a> Managing a user or groups mapping to a role

User or group mapping to a role is granted by a [Kubernetes rolebinding or clusterrole binding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding).  A RoleBinding grants a role or clusterrole to a specific namespace.  Alternatively, a clusterbinding maps a clusterrole to all namespaces.

Each of the four roles for users have both a role for namespace scoped resources, as well as a role for cluster scoped resources.  To ensure that the roles have access to the resources at the correct scoping, you should create bindings for both the namespace scoped resources and the cluster scoped resources.

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
    ```


To bind a role to a group:

```console
kubectl create rolebinding ROLEBINDINGNAME --clusterrole ROLE --group GROUP --namespace NAMESPACE
kubectl create clusterrolebinding ROLEBINDINGNAME --clusterrole ROLE --user GROUP
```

For example, to grant the group "developers" app-editor rights to the "dev" namespace:

```console
kubectl create rolebinding app-editor --clusterrole app-editor --group developers --namespace dev
kubectl create clusterrolebinding app-editor-cluster-access --clusterrole app-editor-cluster-access --group developers
```

However, it may be necessary to bind individual users to a role.  To bind a role to a user:

```console
kubectl create rolebinding ROLEBINDINGNAME --clusterrole ROLE --user USER --namespace NAMESPACE
kubectl create clusterrolebinding ROLEBINDINGNAME --clusterrole ROLE --user USER
```

For example, to grant the user "developer-1" app-editor rights to the "dev" namespace:

```console
kubectl create rolebinding app-editor --clusterrole app-editor --user developer-1 --namespace dev
kubectl create clusterrolebinding app-editor-cluster-access --clusterrole app-editor-cluster-access --user developer-1
```

## <a id="get-list-users"></a> Get a list of users and groups from a role

Get a list of users and groups from a role by running:

```console
tanzu rbac binding get --role ROLE --namespace NAMESPACE
```

For example:

```console
$ tanzu rbac binding get --role app-editor --namespace user-ns
```

## <a id="binding-delete"></a> Remove the specified user or group from a role

Remove a user or group from a role by running:

```console
tanzu rbac binding delete --user USER --role ROLE --namespace NAMESPACE
```

```console
tanzu rbac binding delete --group GROUP --role ROLE --namespace NAMESPACE
```

For example:

```console
$ tanzu rbac binding delete --user username@vmware.com --role app-editor --namespace user-ns
```

## <a id="error-logs"></a> Error logs

Authorization error logs might include the following errors:

- Permission Denied:

    The current user does not have permissions to create or edit rolebinding objects.
    Use an admin account when using the RBAC CLI.

    ```console
    Error: rolebindings.rbac.authorization.k8s.io "app-operator" is forbidden: User "<subject>" cannot get resource "rolebindings" in API group "rbac.authorization.k8s.io" in the namespace "namespace"
    Usage:
    tanzu rbac binding add [flags]
    Flags:
    -g, --group string User Group
    -h, --help help for add
    -n, --namespace string Namespace
    -r, --role string Role
    -u, --user string User Name

    Global Flags:
    --kubeconfig string kubeconfig file
    ```

- Already Bound Error:

    Adding a subject, user or group, to a role that already has the subject produces the following error:

    ```console
    Error: User ‘test-user’ is already bound to 'app-operator' role
    Usage:
    tanzu rbac binding add [flags]
    Flags:
    -g, --group string User Group
    -h, --help help for add
    -n, --namespace string Namespace
    -r, --role string Role
    -u, --user string User Name

    Global Flags:
    --kubeconfig string kubeconfig file
    ```

- Could Not Find Error:

    When removing a subject from a role, this error can occur in the following two scenarios:

    1. The rolebinding does not exist.
    1. The subject does not exist in the rolebinding.

    Ensure the rolebinding exists and that the subject name is correctly spelled.

    ```console
    Error: Did not find User 'test-user' in RoleBinding 'app-operator'
    Usage:
    tanzu rbac binding delete [flags]

    Flags:
    -g, --group string User Group
    -h, --help help for delete
    -n, --namespace string Namespace
    -r, --role string Role
    -u, --user string User Name

    Global Flags:
    --kubeconfig string kubeconfig file
    ```

- Object Has Been Modified Error:

    This error is a race condition caused by running multiple RBAC CLI actions at the same time.
    Rerunning the RBAC CLI might fix the issue.

    ```console
    Removed User 'test-user' from RoleBinding 'app-operator'
    Removed User 'test-user' from ClusterRoleBinding 'app-operator-cluster-access'
    Error: Operation cannot be fulfilled on rolebindings.rbac.authorization.k8s.io "app-operator": the object has been modified; please apply your changes to the latest version and try again
    Usage:
    tanzu rbac binding delete [flags]

    Flags:
    -g, --group string User Group
    -h, --help help for delete
    -n, --namespace string Namespace
    -r, --role string Role
    -u, --user string User Name
    ```

## <a id="troubleshooting"></a> Troubleshooting

1. Get a list of permissions for a user or a group:

	```console
	export NAME=SUBJECT-NAME
	kubectl get rolebindings,clusterrolebindings -A -o json | jq -r ".items[] | select(.subjects[]?.name == \"${NAME}\") | .roleRef.name" | xargs -n1 kubectl describe clusterroles
	```

1. Get a list of user or group for a specific role:

	```console
	tanzu rbac binding get --role ROLE --namespace NAMESPACE
	```
