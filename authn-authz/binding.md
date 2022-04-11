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
        tanzu plugin install rbac --local published/darwin-amd64
        ```

    - For Linux, run:

        ```
        tanzu plugin install rbac --local published/linux-amd64
        ```

    - For Windows, run:

        ```
        tanzu plugin install rbac --local published/windows-amd64
        ```


### <a id="use-kubeconfig"></a> Use a different kubeconfig location

Use a different kubeconfig location by running:

```
tanzu rbac --kubeconfig PATH-OF-KUBECONFIG binding add ...
```

> **Note:** The environment variable `KUBECONFIG` is not implemented.
> You must use the `--kubeconfig` flag to enter a different location.

For example:

```
$ tanzu rbac --kubeconfig /tmp/pinniped_kubeconfig.yaml binding add --user username@vmware.com --role app-editor --namespace user-ns
```


### <a id="add-user-group-to-role"></a> Add the specified user or group to a role

Add a user or group to a role by running:

```
tanzu rbac binding add --user $user --role $role --namespace $namespace

tanzu rbac binding add --group $group --role $role --namespace $namespace
```

For example:

```
$ tanzu rbac binding add --user username@vmware.com --role app-editor --namespace user-ns
```

### <a id="get-list-users"></a> Get a list of users and groups from a role

Get a list of users and groups from a role by running:

```
tanzu rbac binding get --role $role --namespace $namespace

tanzu rbac binding get --role $role --namespace $namespace
```

For example:

```
$ tanzu rbac binding get --role app-editor --namespace user-ns
```

### <a id="binding-delete"></a> Remove the specified user or group from a role

Remove a user or group from a role by running:

```
tanzu rbac binding delete --user $user --role $role --namespace $namespace

tanzu rbac binding delete --group $group --role $role --namespace $namespace
```

For example:

```
$ tanzu rbac binding delete --user username@vmware.com --role app-editor --namespace user-ns
```

### <a id="error-logs"></a> Error logs

The following errors may be included in authorization error logs.

#### Permission Denied:

The current user does not have permissions to create or modify rolebinding objects.
Please use an administrator account when using the rbac cli.
```
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

#### Already Bound Error:
Adding a subject, user or group, to a role that already has the subject will produce the following error:
```
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

#### Could Not Find Error:
There are 2 scenarios this error can happen when removing a subject from a role:

1. The rolebinding does not exist
1. The subject does not exist in the rolebinding

Please ensure the rolebinding exists and that the subject name is correctly spelled.

```
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

#### Object Has Been Modified Error:

This error is a race condition caused by running multiple rbac cli actions at the same time.
Rerunning the rbac cli may fix the issue.

```
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

### <a id="troubleshooting"></a> Troubleshooting

1. Get a list of permissions for a user or a group

	```
	export NAME=<subject_name>
	kubectl get rolebindings,clusterrolebindings -A -o json | jq -r ".items[] | select(.subjects[]?.name == \"${NAME}\") | .roleRef.name" | xargs -n1 kubectl describe clusterroles
	```
1. Get a list of user or group for a specific role

	```
	tanzu rbac binding get --role $role --namespace $namespace
	```
