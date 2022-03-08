# Bind a user or group to a default role

You can take two approaches to bind a user or group to a default role:

1. Use the Beta TAP Auth CLI, which only supports binding Tanzu Application Platform default roles.
1. Use Kubernetes role-based access control (RBAC) role binding.

VMware recommends that you use the Beta TAP Auth CLI, available for download from Tanzu Network. This CLI simplifies the process for you by binding the cluster-scoped resource permissions at the same time as the namespace-scoped resource permissions, where applicable, for each default role. The following sections cover the Beta TAP Auth CLI.

## <a id="prereqs"></a>Prerequisites

1. Download the latest Tanzu CLI.
1. Download the beta Tanzu Application Platform Auth CLI tar.gz from [Tanzu Network](https://network.tanzu.vmware.com/products/tap-auth).
1. Ensure you have admin access to the cluster.
1. Ensure you have configured an authentication solution for the cluster. You can use **Pinniped** or the authentication service native to your Kubernetes distribution.


## <a id="install"></a>Install the auth plugin

1. Untar the tar.gz:

    ```
    tar zxvf <NAME OF THE TAR>
    ```

1. Install the auth plugin locally:

    - For macOS:

    ```
    tanzu plugin install auth --local published/darwin-amd64
    ```

    - For Linux:

    ```
    tanzu plugin install auth --local published/linux-amd64
    ```

    - For Windows:

    ```
    tanzu plugin install auth --local published/windows-amd64
    ```

### <a id="use-kubeconfig"></a>Use a different kubeconfig location

Use the `--kubeconfig` flag before the subcommand:

```
tanzu auth --kubeconfig <PATH_OF_KUBECONFIG> add-binding ...
```

For example:

```
$ tanzu auth --kubeconfig /tmp/pinniped_kubeconfig.yaml add-binding --user username@vmware.com --role app-editor --namespace user-ns
```

>**Note:** The environment variable `KUBECONFIG` is not implemented, you must use the `--kubeconfig` flag to enter a different location.

### <a id="add-user-group-to-role"></a>Add the specified user or group to a role

```
tanzu auth add-binding --user $user --role $role --namespace $namespace

tanzu auth add-binding --group $group --role $role --namespace $namespace
```

For example:

```
$ tanzu auth add-binding --user username@vmware.com --role app-editor --namespace user-ns
```

### <a id="get-list-users"></a>Get a list of users and groups from a role

```
tanzu auth get-binding --role $role --namespace $namespace

tanzu auth get-binding --role $role --namespace $namespace
```

For example:

```
$ tanzu auth get-binding --role app-editor --namespace user-ns
```

### <a id="remove-binding"></a>Remove the specified user or group from a role

```
tanzu auth remove-binding --user $user --role  $role --namespace $namespace

tanzu auth remove-binding --group $group --role $role --namespace $namespace
```

For example:

```
$ tanzu auth remove-binding --user username@vmware.com --role app-editor --namespace user-ns
```
