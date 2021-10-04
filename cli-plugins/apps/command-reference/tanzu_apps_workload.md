## tanzu apps workload

Workload lifecycle management

### Synopsis

A workload may run as a knative service, kubernetes deployment, or other runtime. Workloads can be grouped together with other related resources such as storage or credential objects as a logical application for easier management.

Workload configuration includes:
- source code to build
- runtime resource limits
- environment variables
- services to bind

### Options

```
  -h, --help   help for workload
```

### Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

### SEE ALSO

* [tanzu apps](tanzu_apps.md)	 - Applications on Kubernetes
* [tanzu apps workload apply](tanzu_apps_workload_apply.md)	 - Apply configuration to a new or existing workload
* [tanzu apps workload create](tanzu_apps_workload_create.md)	 - Create a workload with specified configuration
* [tanzu apps workload delete](tanzu_apps_workload_delete.md)	 - Delete workload(s)
* [tanzu apps workload get](tanzu_apps_workload_get.md)	 - Get details from a workload
* [tanzu apps workload list](tanzu_apps_workload_list.md)	 - Table listing of workloads
* [tanzu apps workload tail](tanzu_apps_workload_tail.md)	 - Watch workload related logs
* [tanzu apps workload update](tanzu_apps_workload_update.md)	 - Update configuration of an existing workload

