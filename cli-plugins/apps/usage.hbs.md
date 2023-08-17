# Manage a workload using a YAML file

This topic tells you how to use the Tanzu Apps CLI to manage a workload using a `yaml` file.

## <a id='changing-clusters'></a> Changing clusters

The Tanzu Apps CLI refers to the default kubeconfig file to access a Kubernetes cluster.
When a `tanzu apps` command is run, the Tanzu Apps CLI uses the default context that is defined in
that kubeconfig file (located by default at `$HOME/.kube/config`).

There are two ways to change the target cluster:

1. Use `kubectl config use-context <context-name>` to change the default context. All subsequent
`tanzu apps` commands target the cluster defined in the new default kubeconfig context.
2. Include the `--context <context-name>` flag when running any `tanzu apps` command.
All subsequent `tanzu apps` commands without the `--context <context-name>` flag continues to use
the default context set in the kubeconfig.

There are also two ways to override the default kubeconfig:

1. Set the environment `KUBECONFIG=<path>` to change the kubeconfig the Apps CLI plug-in references.
   All subsequent `tanzu apps` commands reference the non-default kubeconfig assigned to the
   environment.
2. Include the  `--kubeconfig <path>` flag when running any `tanzu apps` command. All subsequent
   `tanzu apps` commands without the `--kubeconfig <path>` flag continues to use the default
   kubeconfig.

For more information about kubeconfig, see [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) Kubernetes documentation.

## <a id='checking-update-status'></a>Checking update status

You can use the Tanzu Apps CLI to create or update a workload.
After you've submitted your changes to the platform, the CLI command exits.
Depending on the changes you submitted, it might take time for them to be executed on the platform.
Run `tanzu apps workload get` to verify the status of your changes.
For more information about this command, see [Tanzu Apps Workload Get](command-reference/tanzu-apps-workload-get.md).

## <a id='yaml-files'></a> Working with YAML files

In many cases, you can manage workload life cycles through CLI commands.
However, you might find cases where you want to manage a workload by using a `yaml` file.
The Tanzu Apps CLI supports using `yaml` files.

The Tanzu Apps CLI manages one workload at a time. When you manage a workload using a `yaml` file, that
file must contain a single workload definition. Tanzu Apps CLI commands support only one file per command.

For example:

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
      url: https://github.com/vmware-tanzu/application-accelerator-samples
      ref:
        tag: tap-1.3
    subPath: tanzu-java-web-app
```

To create a workload from a file like the previous one, run:

```console
tanzu apps workload create -f my-workload-file.yaml
```

Another way to create a workload from `yaml` is passing the definition through `stdin`.
For example, run:

```console
tanzu apps workload create -f - --yes
```

The console waits for input, and the content with a valid `yaml` definition for a workload is either
written or pasted. Then click `ctrl`+D three times to start workload creation. This can also be done
with `workload update` and `workload apply` commands.

**Note** to pass workload through `stdin`, `--yes` flag is needed. If not used, command fails.

## <a id='autocompletion'></a> Autocompletion

To enable command autocompletion, the Tanzu CLI offers the `tanzu completion` command.

Run:

### <a id='bash'></a> Bash

```console
tanzu completion bash >  $HOME/.tanzu/completion.bash.inc
```

Or

### <a id='zsh'></a> Zsh

```console
echo "autoload -U compinit; compinit" >> ~/.zshrc
tanzu completion zsh > "${fpath[1]}/_tanzu"
```
