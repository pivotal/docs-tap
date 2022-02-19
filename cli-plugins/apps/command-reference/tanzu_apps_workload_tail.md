# Tanzu apps workload tail

This topic will help you to watch workload related logs.

You can stream logs for a workload until canceled. To cancel, press Ctl-c in
the shell or kill the process. As new workload pods are started, the logs
are displayed. To show historical logs use --since.

```
tanzu apps workload tail <name> [flags]
```

## <a id="examples"></a>Examples

```
tanzu apps workload tail my-workload
tanzu apps workload tail my-workload --since 1h
```

## <a id="options"></a>Options

```
      --component name   workload component name (e.g. build)
  -h, --help             help for tail
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
      --since duration   time duration to start reading logs from (default 1s)
  -t, --timestamp        print timestamp for each log line
```

## <a id="parent-commands-options"></a>Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## <a id="see-also"></a> See also

* [Tanzu Apps Workload](tanzu_apps_workload.md) - Workload life cycle management
