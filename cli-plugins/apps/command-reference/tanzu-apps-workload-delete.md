# Tanzu apps workload delete

This topic helps you delete one or more workloads by name or all workloads within a namespace.

Deleting a workload prevents new builds while preserving built images in the
registry.

```
tanzu apps workload delete <name(s)> [flags]
```

## <a id="examples"></a>Examples

```
tanzu apps workload delete my-workload
tanzu apps workload delete --all
```

## <a id="options"></a>Options

```
      --all                     delete all workloads within the namespace
  -f, --file file path          file path containing the description of a single workload; other flags are layered on top of this resource. Use value "-" to read from stdin
  -h, --help                    help for delete
  -n, --namespace name          kubernetes namespace (defaulted from kube config)
      --wait                    waits for workload to be deleted
      --wait-timeout duration   timeout for workload to be deleted when waiting (default 1m0s)
  -y, --yes                     accept all prompts
```

## <a id="parent-commands-options"></a> Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## <a id="see-also"></a> See also

* [Tanzu Apps Workload](tanzu-apps-workload.md) - Workload life cycle management
