# Assigning roles and permissions on Kubernetes clusters

This topic gives an overview of creating roles and permissions on Kubernetes clusters
and assigning these roles to users. For more information, see
[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) in the
Kubernetes documentation.

The steps to define and assign roles are:

1. [Create roles](#create-roles)
2. [Create users](#create-users)
3. [Assign users to their roles](#assign-users-to-roles)


## <a id="create-roles"></a> Create roles

To control the access to Kubernetes runtime resources on Tanzu Application Platform GUI based on users'
roles and permissions for each of visible remote clusters, VMware recommends two role types:

- [Cluster-scoped roles](#cluster-scoped-roles)
- [Namespace-scoped roles](#namespace-scoped-roles)


### <a id="cluster-scoped-roles"></a> Cluster-scoped roles

Cluster-scoped roles provide cluster-wide privileges. They enable visibility into runtime resources
across all of a cluster's namespaces.

In this example YAML snippet, the `pod-viewer` role enables pod visibility on the cluster:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pod-viewer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```


### <a id="namespace-scoped-roles"></a> Namespace-scoped roles

Namespace-scoped roles provide privileges that are limited to a certain namespace.
They enable visibility into runtime resources inside namespaces.

In this example YAML snippet, the `pod-viewer-app1` role enables pod visibility in the `app1` namespace:

```yaml
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


## <a id="create-users"></a> Create users

You can create users by running the `kubectl create` command.
In this example YAML snippet, the user `john` is defined:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: User
metadata:
  namespace: default
  name: john
```


## <a id="assign-users-to-roles"></a> Assign users to their roles

After the users and role are created, the next step is to bind them together.

To bind a Tanzu Application Platform default role, see
[Bind a user or group to a default role](../../authn-authz/binding.html).

In this example YAML snippet, the user `john` is bound with the `pod-viewer` cluster role:

```yaml
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

In this example YAML snippet, the user `john` is bound with the `pod-viewer-app1` namespace-specific
role:

```yaml
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

To verify the user's permissions, run the `can-i` commands to get a `yes` or `no` answer.
To verify that you can list pods in your cluster-wide role, run:

```console
kubectl auth can-i get pods --all-namespaces
```

To verify that you can list pods in namespace `app1` in your namespace-specific role, run:

```console
kubectl auth can-i get pods --namespace app1
```
