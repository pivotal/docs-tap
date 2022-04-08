# Bind a user or group to a default role

You can choose one of two approaches to bind a user or group to a default role:

* Use the Tanzu Application Platform RBAC CLI plug-in, which only supports binding Tanzu Application Platform default roles.
* Use Kubernetes role-based access control (RBAC) role binding.

VMware recommends that you use the Tanzu Application Platform RBAC CLI plug-in.
This CLI plug-in simplifies the process for you by binding the cluster-scoped resource permissions
at the same time as the namespace-scoped resource permissions, where applicable, for each default role.
The following sections cover the Tanzu Application Platform RBAC CLI plug-in.

## <a id="prereqs"></a> Prerequisites

1. Download the latest Tanzu CLI version.
1. Download the Tanzu Application Platform RBAC CLI plug-in `tar.gz` file from [Tanzu Network](https://network.tanzu.vmware.com/products/tap-auth).
1. Ensure you have admin access to the cluster.
1. Ensure you have configured an authentication solution for the cluster.
You can use [Pinniped](https://pinniped.dev/) or the authentication service native to your Kubernetes distribution.


## <a id="install"></a> Install the Tanzu Application Platform RBAC CLI plug-in

Follow these steps to install the Tanzu Application Platform RBAC CLI plug-in:

> **Caution:** The Tanzu Application Platform RBAC CLI plug-in is currently in beta and is
intended for evaluation and test purposes only.

1. Untar the `tar.gz` file:

    ```
    tar zxvf <NAME OF THE TAR>
    ```

1. Install the Tanzu Application Platform RBAC CLI plug-in locally on your operating system:

    - For macOS, run:

        ```
        tanzu plugin install auth --local published/darwin-amd64
        ```

    - For Linux, run:

        ```
        tanzu plugin install auth --local published/linux-amd64
        ```

    - For Windows, run:

        ```
        tanzu plugin install auth --local published/windows-amd64
        ```


### <a id="use-kubeconfig"></a> Use a different kubeconfig location

Use a different kubeconfig location by running:

```
tanzu auth --kubeconfig PATH-OF-KUBECONFIG binding add ...
```

> **Note:** The environment variable `KUBECONFIG` is not implemented.
> You must use the `--kubeconfig` flag to enter a different location.

For example:

```
$ tanzu auth --kubeconfig /tmp/pinniped_kubeconfig.yaml binding add --user username@vmware.com --role app-editor --namespace user-ns
```


### <a id="add-user-group-to-role"></a> Add the specified user or group to a role

Add a user or group to a role by running:

```
tanzu auth binding add --user $user --role $role --namespace $namespace

tanzu auth binding add --group $group --role $role --namespace $namespace
```

For example:

```
$ tanzu auth binding add --user username@vmware.com --role app-editor --namespace user-ns
```

### <a id="get-list-users"></a> Get a list of users and groups from a role

Get a list of users and groups from a role by running:

```
tanzu auth binding get --role $role --namespace $namespace

tanzu auth binding get --role $role --namespace $namespace
```

For example:

```
$ tanzu auth binding get --role app-editor --namespace user-ns
```

### <a id="binding-delete"></a> Remove the specified user or group from a role

Remove a user or group from a role by running:

```
tanzu auth binding delete --user $user --role $role --namespace $namespace

tanzu auth binding delete --group $group --role $role --namespace $namespace
```

For example:

```
$ tanzu auth binding delete --user username@vmware.com --role app-editor --namespace user-ns
```
