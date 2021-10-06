## Tanzu Apps Workload Delete

Delete workload(s).

### Synopsis

Delete one or more workloads by name or all workloads within a namespace.

Deleting a workload prevents new builds while preserving built images in the
registry.

```
tanzu apps workload delete <name(s)> [flags]
```

### Examples

```
tanzu apps workload delete my-workload
tanzu apps workload delete --all
```

### Options

```
      --all                     delete all workloads within the namespace
  -f, --file file path          file path containing the description of a single workload, other flags are layered on top of this resource
  -h, --help                    help for delete
  -n, --namespace name          kubernetes namespace (defaulted from kube config)
      --wait                    waits for workload to be deleted
      --wait-timeout duration   timeout for workload to be deleted when waiting (default 1m0s)
  -y, --yes                     accept all prompts
```

### Options Inherited from Parent Commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

### See Also

* [tanzu apps workload](tanzu_apps_workload.md)	 - Workload lifecycle management

