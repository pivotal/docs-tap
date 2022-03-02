# How to Bind a User or Group to a Default Role

To bind a user or group to a Default Role, there are two approaches you can take:

1. Use the Beta TAP Auth CLI (only supports binding TAP Default Roles)
1. Use Kubernetes RBAC role binding

It is recommended that you use the Beta TAP Auth CLI, which is available to download from Tanzu Network. This CLI simplifies the process for you by binding the cluster-scoped resource permissions at the same time as the namespace-scoped resource permissions (where applicable) for each Default Role. This section of the documentation will cover the Beta TAP Auth CLI. 

## Pre-Requisites

1. Download the Beta TAP Auth CLI binary from Tanzu Network
1. Ensure you have an authentication solution configured for the cluster, you could use Pinniped or the authentication service native to your kubernetes distribution. 

### Add the specified user or group to a role cluster role

```
tanzu auth add-user --user $user --to-role $role --namespace $namespace

tanzu auth add-group --group $group --to-role $role --namespace $namespace
```

Example

```
$ tanzu auth add-user --user username@vmware.com --to-role app-developer --namespace user-ns
```

### Get a list of users or groups from a role

```
tanzu auth get-users --role $role --namespace $namespace

tanzu auth get-groups --role $role --namespace $namespace
```

Example

```
$ tanzu auth get-users --role app-developer --namespace user-ns
```

### Remove the specified user or group from a role

```
tanzu auth remove-user --user $user --from-role  $role --namespace $namespace

tanzu auth remove-group --group $group --from-role $role --namespace $namespace
```

```
$ tanzu auth remove-user --user username@vmware.com --from-role app-developer --namespace user-ns
```