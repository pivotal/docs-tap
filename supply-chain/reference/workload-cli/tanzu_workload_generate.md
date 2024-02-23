## tanzu workload generate

Generate a workload manifest with specified configuration

### Synopsis

Generate a workload manifest with specified configuration.

workload configuration options include:
- kind of the workload to generate

```
tanzu workload generate [NAME] [flags]
```

### Examples

```
tanzu workload generate NAME
  tanzu workload generate NAME --kind kindname
```

### Options

```
  -h, --help          help for generate
  -k, --kind string   kind of the workload specification.
```

### Options inherited from parent commands

```
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

### SEE ALSO

* [tanzu workload](tanzu_workload.md)	 - create, update, view and list Tanzu Workloads.

