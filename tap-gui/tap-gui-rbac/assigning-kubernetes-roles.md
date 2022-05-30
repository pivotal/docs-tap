# Assigning Roles and Permissions on Kubernetes Clusters

This section provides a basic overview of how to create roles and persmissions on Kubernetes clusters and how to assign these roles to users. For more detailed information, please refer to [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

The steps to define and assign roles include:

1. Create roles
2. Create users
3. Assign users to their roles


## <a id="create-role"></a> Create Roles

To control the access to Kubernetes runtime resources on Tanzu Application Platform GUI based on users' roles and permissions for each of visible remote clusters. we recommend considering two role types:

- [Cluster-scoped Roles](#-cluster-scoped-roles)
- [Namespace-scoped Roles](#-namespace-scoped-roles)

### <a id="cluster-scoped-roles"></a> Cluster-scoped Roles

Cluster-scoped roles provide cluster-wide privileges. They allow visibility into runtime resources across all cluster's namespaces.

For example, role `pod-viewer` enables Pod visibility on the cluster.

```console
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-viewer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

### <a id="namespace-scoped-roles"></a> Namespace-scoped Roles


Namespace-scoped roles provide privileges that are limited to a certain namespace. They allow visibility into runtime resources inside the namespaces.

For example, role `pod-viewer-app1` enables Pod visibility in the `app1` namespace.

```console
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: app1
  name: pod-viewer-app1
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

## <a id="create-users"></a> Create Users

Creating users can be done with a `kubectl` command.

For example, user `john` can be defined in the YAML file below:

```console
apiVersion: rbac.authorization.k8s.io/v1
kind: User
metadata:
  namespace: default
  name: john
```

## <a id="assign-users-to-roles"></a> Assign Users to their Roles

After the users and role have been created, the next step is to bind them together.

For example, to bind user `john` with the 'pod-viewer' cluster role, you can use the following YAML file:

```console
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: john-pod-viewer
  namespace: default
subjects:
- kind: User
  name: john
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: pod-viewer
  apiGroup: rbac.authorization.k8s.io
```

In another example, you can bind user `john` with the 'pod-viewer-app1' namespace-specific role:

```console
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: john-pod-viewer-app1
  namespace: app1
subjects:
- kind: User
  name: john
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-viewer-app1
  apiGroup: rbac.authorization.k8s.io
```

To verify user's permissions, try running the `can-i` commands. You will get a yes or no answer.

For example, to verify your cluster-wide role to list pods, execute:

```console
kubectl auth can-i get pods --all-namespaces
```

In another example, to verify your namespace-specific role to list pods in namespace `app1`, execute:

```console
kubectl auth can-i get pods --namespace app1
```




