# Tutorials

## <a id='install-uninstall'>Installing/Uninstalling Apps CLI plug-in

### <a id='prereqs'></a>Installation prerequisites

Before you install the Apps CLI plug-in:

- Follow the instructions to [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.hbs.md#cli-and-plugin).

### <a id='install'></a>Install

#### <a id='from-tap-net'></a>From Tanzu Network

To install the Apps CLI plug-in:

1. From the `$HOME/tanzu` directory, run:

    ```console
    tanzu plugin install --local ./cli apps
    ```

2. To verify that the CLI is installed correctly, run:

    ```console
    tanzu apps version
    ```

    A version should be displayed in the output.

    If the following error is displayed during installation:

    ```console
    Error: could not find plug-in "apps" in any known repositories

    ✖  could not find plug-in "apps" in any known repositories
    ```

    Verify that there is an `apps` entry in the `cli/manifest.yaml` file. It should look like this:

    ```yaml
    plugins:
    ...
        - name: apps
        description: Applications on Kubernetes
        versions: []
    ```

#### <a id='from-release'></a>From Release

The latest release can be found in the [repository releases page](https://github.com/vmware-tanzu/apps-cli-plugin/releases/). Each of these releases has the *Assets* section where the packages for each *system-architecture* are placed.

To install the Apps CLI plug-in:

Download binary executable `tanzu-apps-plugin-{OS_ARCH}-{version}.tar.gz`
Run the following commands(for example for macOS and plugin version v0.10.0)

```bash
tar -xvf tanzu-apps-plugin-darwin-amd64-v0.10.0.tar.gz
tanzu plugin install apps --local ./tanzu-apps-plugin-darwin-amd64-v0.10.0 --version v0.10.0
```

### <a id='uninstall'>Uninstalling Apps CLI plug-in

To uninstall Apps CLI plug-in by using:

```bash
tanzu plugin delete apps
```

## <a id='changing-clusters'></a>Changing clusters

The Apps CLI plug-in refers to the default kubeconfig file to access a Kubernetes cluster.
When a `tanzu apps` command is run, the plug-in uses the default context that's defined in that kubeconfig file (located by default at `$HOME/.kube/config`).

There are two ways to change the target cluster:

1. Use `kubectl config use-context <context-name>` to change the default context. All subsequent `tanzu apps` commands will target the cluster defined in the new default kubeconfig context.

2. Include the `--context <context-name>` flag when running any `tanzu apps` command.

   **Note:** Any subsequent `tanzu apps` commands that do not include the `--context <context-name>` flag will continue to use the default context set in the kubeconfig.

## <a id='override-kubeconfig'></a>Overriding the default kubeconfig

There are two approaches to achieving this:

1. Set the env var `KUBECONFIG=<path>` to change the kubeconfig the Apps CLI plug-in should reference.

   All subsequent `tanzu apps` commands will reference the non-default kubeconfig assigned to the env var.

2. Include the  `--kubeconfig <path>` flag when running any `tanzu apps` command.

   **Note:** Any subsequent `tanzu apps` commands that do not include the `--context <context-name>` flag will continue to use the default context set in the kubeconfig.

For more information about kubeconfig, see [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/).

## <a id='autocompletion'></a>Autocompletion

Use of autocomplete greatly optimizes usage of any CLI and the apps plugin has provided robust autocompletion support so that users do not need to struggle to remember the correct spellings and or possible entries required.

The plugin supports autocompletion for commands, positional arguments, flags and flag values and enabling this feature is highly recommended.

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

## <a id='about-workloads'>About workloads

### <a id='creating-workloads'>Creating workloads

Workloads can be created via references to four different sources as follows:

1. Using URL to git repo. Source code can be read from either git branch, git tag or git commit.
2. Creating from an existing local project as source.
3. Using an image that will be pulled from a registry to deploy the application.
4. Setting a Maven repository artifact.

Some examples of each of these ways are given in the [workload creation](create-workload.hbs.md) page.

### <a id='debugging-workloads'>Debugging and troubleshooting workloads

Workload status can be checked with commands as `tanzu apps workload get` and `tanzu apps workload tail`.

`tanzu apps workload get` is used to see the workload specification, the resources attached to it, their status and any associated high-level error messages (should they exist).

`tanzu apps workload tail` is used to see testing, scanning, build, configuration, deployment, and runtime logs associated with a workload and its progression through the supply chain.

More info on the usage of these commands and common errors, can be found on [debugging workloads](debug-workload.hbs.md) page.