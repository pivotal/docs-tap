# Usage

## <a id='changing-clusters'></a> Changing Clusters

The Apps CLI plugin uses the default context that you set in the kubeconfig file to connect to the cluster. To switch clusters, use kubectl to set the [default context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).


## <a id='checking-update-status'></a>Checking Update Status

When you use the Apps CLI plugin to create or update a workload, it submits changes to the platform and the CLI command is completed successfully. This does not mean that the change appears on the platform. The time it takes for the change to be executed on the backend depends on the type of change requested.

Run [`tanzu apps workload get`](command-reference/tanzu_apps_workload_get.md) to check the status of the change.

## <a id='yaml-files'></a> Working with YAML Files

In many cases, workload lifecycles can be managed through CLI commands, but there may be cases where you want to manage a workload using a `yaml` file. The Apps plugin supports using `yaml` files. 

The plugin is designed to manage one workload at a time. When a workload is being managed via a `yaml` file, that file must contain a single workload definition. Plugin commands support only one file per command.

For example, a valid file looks similar to the following example:

```yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: spring-petclinic
  labels:
    app.kubernetes.io/part-of: spring-petclinic
    apps.tanzu.vmware.com/workload-type: java
spec:
  source:
    git:
      url: https://github.com/spring-projects/spring-petclinic
      ref:
        branch: main
```
## <a id='autocompletion'></a>Autocompletion

To enable command autocompletion, the Tanzu CLI offers the `tanzu completion` command.

Add the following command to the shell config file according to the current setup. Use one of the following options:

### Bash

```bash
tanzu completion bash >  $HOME/.tanzu/completion.bash.inc
```

### Zsh

```sh
echo "autoload -U compinit; compinit" >> ~/.zshrc
tanzu completion zsh > "${fpath[1]}/_tanzu"
```
