# Install Tanzu Apps CLI plug-in

This topic describes how to install the Apps CLI plug-in.

## <a id='prereqs'></a>Prerequisites

Ensure that you installed or updated the Tanzu CLI, for more information, see [Install Tanzu CLI](../../install-tanzu-cli.hbs.md#cli-and-plugin).

## Install Tanzu Apps CLI plug-in

Run:

```console
tanzu plugin install apps --group vmware-tap/default:{{ vars.tanzu-cli.plugin_group_version }}
```

Verify that the plug-in is installed correctly:

```console
tanzu apps version
# sample output
v0.12.1
```

## <a id='uninstall'></a>Uninstall Apps CLI plug-in

Run:

```console
tanzu plugin delete apps
```

## <a id='changing-clusters'></a>Changing clusters

The Apps CLI plug-in refers to the default kubeconfig file to access a Kubernetes cluster.
When you run a `tanzu apps` command, the plug-in uses the default context that is defined in that
kubeconfig file (located by default at `HOME/.kube/config`).

There are two ways to change the target cluster:

1. Use `kubectl config use-context CONTENT-NAME` to change the default context. All subsequent
`tanzu apps` commands target the cluster defined in the new default kubeconfig context.

2. Include the `--context CONTENT-NAME` flag when running any `tanzu apps` command.

   >**Note** Any subsequent `tanzu apps` commands that do not include the `--context CONTENT-NAME`
     flag continue to use the default context set in the kubeconfig.

## <a id='override-kubeconfig'></a>Overriding the default kubeconfig

There are two approaches to overriding the default kubeconfig:

1. Set the environment variable `KUBECONFIG=PATH` to change the kubeconfig the Apps CLI plug-in will
   reference.

   All subsequent `tanzu apps` commands reference the non-default kubeconfig assigned to the environment
   variable.

2. Include the  `--kubeconfig path` flag when running any `tanzu apps` command.

   >**Note** Any subsequent `tanzu apps` commands that do not include the `--context CONTEXT-NAME` flag
   continue to use the default context set in the kubeconfig.

For more information about kubeconfig, see [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) in the Kubernetes documentation.

## <a id='autocompletion'></a>Autocompletion

The Apps CLI plug-in has auto-completion support. The plug-in supports auto-completion for commands,
positional arguments, flags, and flag values. Add one of the following commands to the shell config file
according to your current setup:

### <a id='bash'></a>Bash

```bash
tanzu completion bash >  HOME/.tanzu/completion.bash.inc
```

### <a id='zsh'></a>Zsh

```bash
echo "autoload -U compinit; compinit" >> ~/.zshrc
tanzu completion zsh > "${fpath[1]}/_tanzu"
```

## <a id='about-workloads'></a> About workloads

### <a id='creating-workloads'></a>Creating workloads

Create workloads from one of the following sources:

- A Git repository, for example, a Git branch, Git tag, or Git commit
- An existing local project
- An image that is pulled from a registry to deploy the application.
- A Maven repository artifact.

For more information, see [Create a workload](create-workload.hbs.md).

### <a id='debugging-workloads'></a>Debugging and troubleshooting workloads

Check workload status with the `tanzu apps workload get` and `tanzu apps workload tail` commands.

Use `tanzu apps workload get` to see the workload specification, the resources attached to it, their
status and any associated high-level error messages (if they exist).

Use `tanzu apps workload tail` to see testing, scanning, build, configuration, deployment, and
runtime logs associated with a workload and its progression through the supply chain.

For more information about using these commands and common errors, see [Debugging workloads](debug-workload.hbs.md).
