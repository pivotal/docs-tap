# Delete a workload

The delete command can be used to remove one or many workloads from a specific namespace on the
target cluster.

>**Note** this command does not automatically remove a workload's corresponding image(s) from the registry.

To specify the workload for deletion, user can either provide its name and the namespace (`--namespace`)
in which it resides or use a `yaml` file containing its definition.

To control the deletion process, users have the option to utilize the `--wait` flag, which waits until
the workload is deleted, or the `--wait-timeout` flag, which sets a specific timeout duration for the
deletion process.

## Delete all Workloads in a namespace

Workloads can be deleted all at once with the `--all` flag. If there is a particular namespace where
all workloads should be deleted, then it can be specified with the `--namespace` flag.

```bash
# --namespace shorthand is -n 
# an alternative for this same command is 
# tanzu apps workload delete --all -n my-namespace
tanzu apps workload delete --all --namespace my-namespace
❓ Really delete all workloads in the namespace "my-namespace"? Yes
👍 Deleted workloads in namespace "my-namespace"
```
