# Usage and examples

## <a id='changing-clusters'></a> Changing clusters

The Apps CLI plugin refers to the default kubeconfig file to access a Kubernetes cluster.
When a `tanzu apps` command is run, the plugin uses the default context that's defined in that kubeconfig file (located by default at `$HOME/.kube/config`).

There are two ways to change the target cluster:

1. Use `kubectl config use-context <context-name>` to change the default context. All subsequent `tanzu apps` commands will target the cluster defined in the new default kubeconfig context.
1. Include the `--context <context-name>` flag when running any `tanzu apps` command. All subsequent `tanzu apps` commands without the `--context <context-name>` flag will continue to use the default context set in the kubeconfig.

There are also two ways to override the default kubeconfig:

1. Set the env var `KUBECONFIG=<path>` to change the kubeconfig the Apps CLI plugin should reference. All subsequent `tanzu apps` commands will reference the non-default kubeconfig assigned to the env var.
1. Include the  `--kubeconfig <path>` flag when running any `tanzu apps` command. All subsequent `tanzu apps` commands without the `--kubeconfig <path>` flag will continue to use the default kubeconfig.

For more information about kubeconfig, see [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).


## <a id='checking-update-status'></a>Checking update status

You can use the Apps CLI plugin to create or update a workload.
After you've successfully submitted your changes to the platform, the CLI command exits.
Depending on the changes you submitted, it might take time for them to be executed on the platform.
Run `tanzu apps workload get` to check the status of your changes.
For more information on this command, see [Tanzu Apps Workload Get](command-reference/tanzu_apps_workload_get.md).

## <a id='yaml-files'></a> Working with YAML files

In many cases, you can manage workload life cycles through CLI commands.
However, you might find cases where you want to manage a workload by using a `yaml` file.
The Apps CLI plugin supports using `yaml` files.

The plugin is designed to manage **one workload** at a time.
When you manage a workload by using a `yaml` file, that file must contain a single workload definition.
Plugin commands support only one file per command.

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
