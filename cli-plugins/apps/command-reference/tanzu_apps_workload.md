# Tanzu apps workload

This topic helps you with workload life cycle management.

A workload may run as a Knative service, Kubernetes deployment, or other runtime. Workloads can be grouped together with other related resources, such as storage or credential objects as a logical application for easier management.

Workload configuration includes:

- Source code to build
- Runtime resource limits
- Environment variables
- Services to bind

## <a id="options"></a>Options

```
  -h, --help   help for workload
```

## <a id="parent-commands-options"></a>Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## <a id="see-also"></a> See also

- [Tanzu applications](tanzu_apps.md)	- Applications on Kubernetes
- [Tanzu apps workload apply](tanzu_apps_workload_apply.md)	- Apply configuration to a new or existing workload
- [Tanzu apps workload create](tanzu_apps_workload_create.md)	- Create a workload with specified configuration
- [Tanzu apps workload delete](tanzu_apps_workload_delete.md)	- Delete workload(s)
- [Tanzu apps workload get](tanzu_apps_workload_get.md)	- Get details from a workload
- [Tanzu apps workload list](tanzu_apps_workload_list.md) - Table listing of workloads
- [Tanzu apps workload tail](tanzu_apps_workload_tail.md) - Watch workload-related logs
- [Tanzu apps workload update](tanzu_apps_workload_update.md)	- Update configuration of an existing workload

