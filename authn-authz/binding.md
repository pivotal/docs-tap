# Bind a user or group to a default role

You can take two approaches to bind a user or group to a default role:

1. Use the beta Tanzu Application Platform Auth CLI plug-in, which only supports binding Tanzu Application Platform default roles.
1. Use Kubernetes role-based access control (RBAC) role binding.

VMware recommends that you use the beta Tanzu Application Platform Auth CLI plug-in, available for download from Tanzu Network. This CLI plug-in simplifies the process for you by binding the cluster-scoped resource permissions at the same time as the namespace-scoped resource permissions, where applicable, for each default role. The following sections cover the beta Tanzu Application Platform Auth CLI plug-in.

>**Caution:** The Auth CLI plug-in is currently in beta and is intended for evaluation and test purposes only.

## <a id="prereqs"></a>Prerequisites

1. Download the latest Tanzu CLI.
1. Download the beta Tanzu Application Platform Auth CLI plug-in tar.gz from [Tanzu Network](https://network.tanzu.vmware.com/products/tap-auth).
1. Ensure you have administrator access to the cluster.
1. Ensure you have configured an authentication solution for the cluster. You can use **Pinniped** or the authentication service native to your Kubernetes distribution.


## <a id="install"></a>Install the Auth CLI plug-in

Follow these steps to install the Auth CLI plug-in:

1. Untar the tar.gz:

    ```
    tar zxvf <NAME OF THE TAR>
    ```

1. Install the Auth plug-in locally:

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
tanzu auth --kubeconfig <PATH_OF_KUBECONFIG> binding add ...
```

For example:

```
$ tanzu auth --kubeconfig /tmp/pinniped_kubeconfig.yaml binding add --user username@vmware.com --role app-editor --namespace user-ns
```

>**Note:** The environment variable `KUBECONFIG` is not implemented. You must use the `--kubeconfig` flag to enter a different location.

### <a id="add-user-group-to-role"></a>Add the specified user or group to a role

To add a user or group to a role, run:

```
tanzu auth binding add --user $user --role $role --namespace $namespace

tanzu auth binding add --group $group --role $role --namespace $namespace
```

For example:

```
$ tanzu auth binding add --user username@vmware.com --role app-editor --namespace user-ns
```

### <a id="get-list-users"></a>Get a list of users and groups from a role

To get a list of users and groups from a role, run:

```
tanzu auth binding get --role $role --namespace $namespace

tanzu auth binding get --role $role --namespace $namespace
```

For example:

```
$ tanzu auth binding get --role app-editor --namespace user-ns
```

### <a id="binding-delete"></a>Remove the specified user or group from a role

To remove a user or group from a role, run:

```
tanzu auth binding delete --user $user --role  $role --namespace $namespace

tanzu auth binding delete --group $group --role $role --namespace $namespace
```

For example:

```
$ tanzu auth binding delete --user username@vmware.com --role app-editor --namespace user-ns
```
