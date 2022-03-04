# Bind a user or group to a default role

You can take two approaches to bind a user or group to a default role:

1. Use the Beta TAP Auth CLI, which only supports binding Tanzu Application Platform default roles.
1. Use Kubernetes role-based access control (RBAC) role binding.

VMware recommends that you use the Beta TAP Auth CLI, available for download from Tanzu Network. This CLI simplifies the process for you by binding the cluster-scoped resource permissions at the same time as the namespace-scoped resource permissions, where applicable, for each default role. The following sections cover the Beta TAP Auth CLI.

## <a id="prereqs"></a>Prerequisites

1. Download the Beta TAP Auth CLI binary from Tanzu Network.
1. Ensure you have an authentication solution configured for the cluster. You can use Pinniped or the authentication service native to your Kubernetes distribution.

### <a id="add-user-group-to-role"></a>Add the specified user or group to a role

```
tanzu auth add-user --user $user --to-role $role --namespace $namespace

tanzu auth add-group --group $group --to-role $role --namespace $namespace
```

For example:

```
$ tanzu auth add-user --user username@vmware.com --to-role app-developer --namespace user-ns
```

### <a id="get-list-users"></a>Get a list of users or groups from a role

```
tanzu auth get-users --role $role --namespace $namespace

tanzu auth get-groups --role $role --namespace $namespace
```

For example:

```
$ tanzu auth get-users --role app-developer --namespace user-ns
```

### <a id="remove-user"></a>Remove the specified user or group from a role

```
tanzu auth remove-user --user $user --from-role  $role --namespace $namespace

tanzu auth remove-group --group $group --from-role $role --namespace $namespace
```

For example:

```
$ tanzu auth remove-user --user username@vmware.com --from-role app-developer --namespace user-ns
```
