# tanzu workload apply

Apply a workload of specific kind on the cluster from the file

```console
tanzu workload apply [NAME] [flags]
```

## Examples

```console
tanzu workload apply --file workload.yaml
  tanzu workload apply my-workload --file workload.yaml --namespace my-namespace
```

## Options

```console
  -f, --file string      file that contains the workload manifest. Can also be a URL (default "workload.yaml")
  -h, --help             help for apply
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -o, --output string    output of the active workload run along with the status in selected format. Supported formats: "json", "yaml", "yml"
  -y, --yes              accept all prompts
```

## Options inherited from parent commands

```console
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## SEE ALSO

* [tanzu workload](tanzu_workload.md)	 - create, update, view and list Tanzu Workloads.

