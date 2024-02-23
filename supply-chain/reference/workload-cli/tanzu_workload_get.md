## tanzu workload get

Get details of a workload

### Synopsis

Get the details of the specified workload within a namespace.

workload get configuration options include:
- Specify the namespace of the workload
- Specify the kind of the workload
- Output the workload formatted

```
tanzu workload get <NAME> [flags]
```

### Examples

```
tanzu workload get NAME
  tanzu workload get NAME --kind kindname
  tanzu workload get NAME --kind kindname --namespace default
```

### Options

```
  -h, --help             help for get
  -k, --kind string      kind of the workload specification
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -o, --output string    output the workload details formatted. Supported formats: "json", "yaml", "yml"
```

### Options inherited from parent commands

```
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

### SEE ALSO

* [tanzu workload](tanzu_workload.md)	 - create, update, view and list Tanzu Workloads.

