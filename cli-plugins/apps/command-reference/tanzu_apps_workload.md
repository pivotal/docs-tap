# Tanzu Apps Workload

This topic will help you with workload lifecycle management.

A workload may run as a Knative service, Kubernetes deployment, or other runtime. Workloads can be grouped together with other related resources, such as storage or credential objects as a logical application for easier management.

Workload configuration includes:

- Source code to build
- Runtime resource limits
- Environment variables
- Services to bind

## Options

```
  -h, --help   help for workload
```

## Options Inherited from Parent Commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## See Also

- [Tanzu Applications](tanzu_apps.md)	- Applications on Kubernetes
- [Tanzu Apps Workload Apply](tanzu_apps_workload_apply.md)	- Apply configuration to a new or existing workload
- [Tanzu Apps Workload Create](tanzu_apps_workload_create.md)	- Create a workload with specified configuration
- [Tanzu Apps Workload Delete](tanzu_apps_workload_delete.md)	- Delete workload(s)
- [Tanzu Apps Workload Get](tanzu_apps_workload_get.md)	- Get details from a workload
- [Tanzu Apps Workload List](tanzu_apps_workload_list.md) - Table listing of workloads
- [Tanzu Apps Workload Tail](tanzu_apps_workload_tail.md) - Watch workload-related logs
- [Tanzu Apps Workload Update](tanzu_apps_workload_update.md)	- Update configuration of an existing workload

