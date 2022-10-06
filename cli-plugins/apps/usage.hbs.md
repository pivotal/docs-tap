# Usage and examples

## <a id='changing-clusters'></a> Changing clusters

The Apps CLI plug-in refers to the default kubeconfig file to access a Kubernetes cluster.
When a `tanzu apps` command is run, the plug-in uses the default context that's defined in that kubeconfig file (located by default at `$HOME/.kube/config`).

There are two ways to change the target cluster:

1. Use `kubectl config use-context <context-name>` to change the default context. All subsequent `tanzu apps` commands will target the cluster defined in the new default kubeconfig context.
2. Include the `--context <context-name>` flag when running any `tanzu apps` command. All subsequent `tanzu apps` commands without the `--context <context-name>` flag will continue to use the default context set in the kubeconfig.

There are also two ways to override the default kubeconfig:

3. Set the env var `KUBECONFIG=<path>` to change the kubeconfig the Apps CLI plug-in should reference. All subsequent `tanzu apps` commands will reference the non-default kubeconfig assigned to the env var.
4. Include the  `--kubeconfig <path>` flag when running any `tanzu apps` command. All subsequent `tanzu apps` commands without the `--kubeconfig <path>` flag will continue to use the default kubeconfig.

For more information about kubeconfig, see [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).


## <a id='checking-update-status'></a>Checking update status

You can use the Apps CLI plug-in to create or update a workload.
After you've successfully submitted your changes to the platform, the CLI command exits.
Depending on the changes you submitted, it might take time for them to be executed on the platform.
Run `tanzu apps workload get` to check the status of your changes.
For more information on this command, see [Tanzu Apps Workload Get](command-reference/tanzu-apps-workload-get.md).

## <a id='yaml-files'></a> Working with YAML files

In many cases, you can manage workload life cycles through CLI commands.
However, you might find cases where you want to manage a workload by using a `yaml` file.
The Apps CLI plug-in supports using `yaml` files.

The plug-in is designed to manage one workload at a time.
When you manage a workload using a `yaml` file, that file must contain a single workload definition.
Plug-in commands support only one file per command.

For example, a valid file looks similar to the following example:

```yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tanzu-java-web-app
  labels:
    app.kubernetes.io/part-of: tanzu-java-web-app
    apps.tanzu.vmware.com/workload-type: web
spec:
  source:
    git:
      url: https://github.com/vmware-tanzu/application-accelerator-samples/tanzu-java-web-app
      ref:
        tag: tap-1.3
```

To create a workload from a file like the one just shown, run:

```console
tanzu apps workload create -f my-workload-file.yaml
```

Another way to create a workload from `yaml` is passing the definition through `stdin`. For example, run:

```console
tanzu apps workload create -f - --yes
```

The console remains waiting for some input, and the content with a valid `yaml` definition for a workload can be either written or pasted, then press `ctrl`+D three times to start workload creation. This can also be done with `workload update` and `workload apply` commands.

**Note**: to pass workload through `stdin`, `--yes` flag is needed. If not used, command will fail.

## <a id='autocompletion'></a> Autocompletion

The apps plugin supports autocompletion for command names, positional arguments, flag names, and flag values.

To enable command autocompletion, the Tanzu CLI offers the `tanzu completion` command.

Add the following command to the shell config file according to the current setup. Use one of the following options:

### <a id='bash'></a> Bash

```console
tanzu completion bash >  $HOME/.tanzu/completion.bash.inc
```

### <a id='zsh'></a> Zsh

```console
echo "autoload -U compinit; compinit" >> ~/.zshrc
tanzu completion zsh > "${fpath[1]}/_tanzu"
```
