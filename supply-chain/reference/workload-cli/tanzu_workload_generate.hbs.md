# tanzu workload generate

Generate a workload manifest with specified configuration

## Synopsis

Generate a workload manifest with specified configuration.

workload configuration options include:
- kind of the workload to generate

```console
tanzu workload generate [NAME] [flags]
```

## Examples

```console
tanzu workload generate NAME
  tanzu workload generate NAME --kind kindname
```

## Options

```console
  -h, --help          help for generate
  -k, --kind string   kind of the workload specification.
```

## Options inherited from parent commands

```console
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## SEE ALSO

* [tanzu workload](tanzu_workload.hbs.md)	 - create, update, view and list Tanzu Workloads.

