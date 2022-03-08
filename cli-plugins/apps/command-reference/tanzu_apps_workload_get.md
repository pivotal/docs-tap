# Tanzu apps workload get

This topic helps you get details from a workload.

```
tanzu apps workload get <name> [flags]
```

## <a id="examples"></a>Examples

```
tanzu apps workload get my-workload
```

## <a id="options"></a>Options

```
      --export           export workload in yaml format
  -h, --help             help for get
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -o, --output string    output the Workload formatted. Supported formats: "json", "yaml"
```

## <a id="parent-commands-options"></a>Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## <a id="see-also"></a> See also

* [Tanzu apps workload](tanzu_apps_workload.md)	- Workload life cycle management

