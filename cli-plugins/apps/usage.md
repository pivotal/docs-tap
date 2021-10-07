# Usage

## <a id='changing-clusters'></a> Changing Clusters

The Apps CLI plugin uses the default context that is set in the kubeconfig file to connect to the cluster. To switch clusters use kubectl to set the [default context](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).


## <a id='checking-update-status'></a>Checking Update Status

When the apps plugin is used to create or update a workload, it submits the changes to the platform and the CLI command is completed successfully. This does not necessarily mean that the change has been realized on the platform. The time it takes for the change for the change to be executed on the backend will depend on the nature of the change requested.

Run [`tanzu apps workload get`](command-reference/tanzu_apps_workload_get.md) periodically to check on the status of the change.

## <a id='yaml-files'></a>Working with YAML Files

In many cases the lifecycle of workloads can be managed through CLI commands and their flags alone but there might be cases where it is desired to manage a workload using a `yaml` file and the Apps plugin supports this use case. 

The plugin has been designed to manage one workload at a time. As such when a workload is being managed via a `yaml` file, that file must contain a single workload definition. In addition plugin commands support only one file per command.

For example, a valid file would be like this:

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

Add the following command to the shell config file according to the current setup:

### Bash

```bash
tanzu completion bash >  $HOME/.tanzu/completion.bash.inc
```

### Zsh

```sh
echo "autoload -U compinit; compinit" >> ~/.zshrc
tanzu completion zsh > "${fpath[1]}/_tanzu"
```
