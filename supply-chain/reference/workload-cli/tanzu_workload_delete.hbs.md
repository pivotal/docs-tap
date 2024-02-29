# tanzu workload delete

Delete workload

## Synopsis

Delete a workload by name within a namespace.

Deleting a workload prevents new builds while preserving built images in the
registry.

```console
tanzu workload delete [NAME] [flags]
```

## Examples

```console
tanzu workload delete NAME
  tanzu workload delete NAME --kind kindname
  tanzu workload delete NAME --kind kindname --namespace default
  tanzu workload delete --file workload.yaml
```

## Options

```console
  -f, --file file path   file path containing the description of a single workload, other flags are layered on top of this resource. Use value "-" to read from stdin
  -h, --help             help for delete
  -k, --kind string      kind of the workload specification
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -y, --yes              accept all prompts
```

## Options inherited from parent commands

```console
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## SEE ALSO

* [tanzu workload](tanzu_workload.hbs.md)	 - create, update, view and list Tanzu Workloads.

