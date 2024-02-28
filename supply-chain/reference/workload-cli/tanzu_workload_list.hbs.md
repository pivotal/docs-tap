# tanzu workload list

Lists all workloads

## Synopsis

Lists all workloads
		
list configuration options include:
- Output the list for all namespaces
- Output the list for a specific namespace
- Output the list for a specific kind
- Output the list formatted

```console
tanzu workload list [flags]
```

## Examples

```console
tanzu workload list
  tanzu workload list --all-namespaces,
  tanzu workload list --namespace my-namepsace,		
  tanzu workload list --kind my-workload-kind,		
  tanzu workload list --output yaml
```

## Options

```console
  -A, --all-namespaces   use all kubernetes namespaces
  -h, --help             help for list
  -k, --kind string      list workloads from the specified workload kind
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -o, --output string    output the workloads formatted. Supported formats: "json", "yaml", "yml"
```

## Options inherited from parent commands

```console
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## SEE ALSO

* [tanzu workload](tanzu_workload.hbs.md)	 - create, update, view and list Tanzu Workloads.

