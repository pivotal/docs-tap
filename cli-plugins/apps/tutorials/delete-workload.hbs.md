# Delete a workload

This topic tells you about the `tanzu apps workload delete` command.

Use the `tanzu apps workload delete` command to remove one or more workloads from a specific
namespace on the target cluster.

>**Note** This command does not automatically remove a workload's corresponding images from the registry.

To specify the workload for deletion, either provide the workload name and namespace or use a `yaml`
file containing the workload definition.

To control the deletion process, use the `--wait` flag, which waits until
the workload is deleted, or the `--wait-timeout` flag, which sets a specific timeout duration for the
deletion process.

## Delete all workloads in a namespace

Delete workloads all at once with the `--all` flag. If there is a particular namespace where
all workloads should be deleted, use the `--namespace` flag to specify it.

```console
# --namespace shorthand is -n 
# an alternative for this same command is 
# tanzu apps workload delete --all -n my-namespace
tanzu apps workload delete --all --namespace my-namespace
❓ Really delete all workloads in the namespace "my-namespace"? Yes
👍 Deleted workloads in namespace "my-namespace"
```
