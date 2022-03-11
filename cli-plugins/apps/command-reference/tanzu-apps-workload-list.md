# Tanzu apps workload list

This topic will help you list workloads in a namespace or across all namespaces.

```
tanzu apps workload list [flags]
```

## <a id="examples"></a>Examples

```
tanzu apps workload list
tanzu apps workload list --all-namespaces
```

## <a id="options"></a>Options

```
      --all-namespaces   use all kubernetes namespaces
      --app name         application name the workload is a part of
  -h, --help             help for list
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
```

## <a id="parent-commands-options"></a>Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## <a id="see-also"></a> See also

* [Tanzu Apps Workload](tanzu-apps-workload.md) - Workload life cycle management
