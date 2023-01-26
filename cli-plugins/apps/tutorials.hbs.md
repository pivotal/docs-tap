# Install Apps CLI plug-in

This document describes how to install the Apps CLI plug-in.

## <a id='prereqs'></a>Prerequisites

Before you install the Apps CLI plug-in:

- Follow the instructions to [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.hbs.md#cli-and-plugin).

## <a id='from-tap-net'></a>Install From VMware Tanzu Network

1. From the `$HOME/tanzu` directory, run:

    ```console
    tanzu plugin install --local ./cli apps
    ```

2. To verify that the CLI is installed correctly, run:

    ```console
    tanzu apps version
    ```

    A version displays in the output.

    If the following error is displayed during installation:

    ```console
    Error: could not find plug-in "apps" in any known repositories

    ✖  could not find plug-in "apps" in any known repositories
    ```

    Verify that there is an `apps` entry in the `cli/manifest.yaml` file. For example:

    ```yaml
    plugins:
    ...
        - name: apps
        description: Applications on Kubernetes
        versions: []
    ```

## <a id='from-release'></a>Install From Release

The latest release is in the [Github repository releases page](https://github.com/vmware-tanzu/apps-cli-plugin/releases/). Each of these releases has the *Assets* section where the packages for each *system-architecture* are placed.

To install the Apps CLI plug-in:

Download binary executable file `tanzu-apps-plugin-{OS_ARCH}-{version}.tar.gz`
Run these commands, for example, using macOS and plug-in version v0.10.0:

```bash
tar -xvf tanzu-apps-plugin-darwin-amd64-v0.10.0.tar.gz
tanzu plugin install apps --local ./tanzu-apps-plugin-darwin-amd64-v0.10.0 --version v0.10.0
```

## <a id='uninstall'></a>Uninstalling Apps CLI plug-in

To uninstall Apps CLI plug-in by using:

```bash
tanzu plugin delete apps
```

## <a id='changing-clusters'></a>Changing clusters

The Apps CLI plug-in refers to the default kubeconfig file to access a Kubernetes cluster.
When a `tanzu apps` command is run, the plug-in uses the default context that is defined in that kubeconfig file (located by default at `$HOME/.kube/config`).

There are two ways to change the target cluster:

1. Use `kubectl config use-context <context-name>` to change the default context. All subsequent `tanzu apps` commands target the cluster defined in the new default kubeconfig context.

2. Include the `--context <context-name>` flag when running any `tanzu apps` command.

   **Note:** Any subsequent `tanzu apps` commands that do not include the `--context <context-name>` flag continue to use the default context set in the kubeconfig.

## <a id='override-kubeconfig'></a>Overriding the default kubeconfig

There are two approaches to achieving this:

1. Set the environment variable `KUBECONFIG=<path>` to change the kubeconfig the Apps CLI plug-in will reference.

   All subsequent `tanzu apps` commands reference the non-default kubeconfig assigned to the environment variable.

2. Include the  `--kubeconfig <path>` flag when running any `tanzu apps` command.

   **Note:** Any subsequent `tanzu apps` commands that do not include the `--context <context-name>` flag
   continue to use the default context set in the kubeconfig.

For more information about kubeconfig, see [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/) in the Kubernetes documentation.

## <a id='autocompletion'></a>Autocompletion

The apps plug-in has auto-completion support.

The plug-in supports auto-completion for commands, positional arguments, flags, and flag values and enabling this feature is highly recommended.

Add the following command to the shell config file according to the current setup. Use one of the following options:

### <a id='bash'></a>Bash

```bash
tanzu completion bash >  $HOME/.tanzu/completion.bash.inc
```

### <a id='zsh'></a>Zsh

```bash
echo "autoload -U compinit; compinit" >> ~/.zshrc
tanzu completion zsh > "${fpath[1]}/_tanzu"
```

## <a id='about-workloads'></a> About workloads

### <a id='creating-workloads'></a>Creating workloads

The four sources from which workloads can be created are as follows:

1. Using URL to Git repository, for example, a Git branch, Git tag, or Git commit.
2. Creating from an existing local project as source.
3. Using an image that is pulled from a registry to deploy the application.
4. Setting a Maven repository artifact.

Some examples of each of these ways are given in the [workload creation](create-workload.hbs.md) page.

### <a id='debugging-workloads'></a>Debugging and troubleshooting workloads

Check workload status with the `tanzu apps workload get` and `tanzu apps workload tail` commands.

Use `tanzu apps workload get` to see the workload specification, the resources attached to it, their status and any associated high-level error messages (should they exist).

Use `tanzu apps workload tail` to see testing, scanning, build, configuration, deployment, and runtime logs associated with a workload and its progression through the supply chain.

For more information about using these commands and common errors, see [Debugging workloads](debug-workload.hbs.md).
