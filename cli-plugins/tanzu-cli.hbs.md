# Overview of Tanzu CLI

This topic tells you about the Tanzu command-line interface (commonly known as Tanzu CLI).

## <a id="tanzu-cli"></a>Tanzu CLI

The Tanzu CLI is a command-line interface that connects you to Tanzu. For example, some functions of
Tanzu CLI include:

- Configure the Tanzu CLI itself
- Install and manage packages
- Run Tanzu services and components
- Create and manage application workloads

For more information about Tanzu CLI, see the
[VMware Tanzu CLI documentation](https://docs.vmware.com/en/VMware-Tanzu-CLI/index.html).

## <a id="itanzu-cli-architecture"></a>Tanzu CLI architecture

The Tanzu CLI has a pluggable architecture. Plug-ins extend the Tanzu CLI core with additional CLI
commands.

The following CLI plug-ins are required to install and use Tanzu Application Platform:

- `accelerator`: Manage accelerators in a Kubernetes cluster
- `apps`: Manage application workloads running on workload clusters
- `build-service`: Plug-in to interact with Tanzu Build Service (TBS) crds
- `external-secrets`: Interact with external-secrets.io resources
- `insight`: Post and query image, package, source, and vulnerability data
- `package`: Package management
- `secret`: Secret management
- `services`: Discover service types, service instances, and manage resource claims

You can also develop your own plug-ins to add custom commands to the Tanzu CLI.

## <a id="tanzu-cli-install"></a>Tanzu CLI installation

You install and initialize the Tanzu CLI on a computer. The computer can be a laptop, host, or server.
To install the CLI see [Install Tanzu CLI](../install-tanzu-cli.hbs.md#cli-and-plugin).

## <a id="tanzu-cli-command-groups"></a>Tanzu CLI command groups

Tanzu CLI commands are organized into command groups. View a list of available command groups by
running:

```console
tanzu
```

The list of command groups that you see depends on which CLI plug-ins are installed on your local
machine.

## <a id="install-new"></a> Install new plug-ins

Install the CLI plug-ins required for Tanzu Application Platform v{{ vars.tap_version }} by running:

```console
tanzu plugin install --group vmware-tap/default:v\{{ vars.tap_version }}
```

Plug-ins for the Tanzu CLI are distributed by using a centralized plug-in repository.

The centralized plug-in repository contains:

- CLI plug-ins, which you can install individually
- Plug-in groups, which are a collection of plug-ins that you can install by using a single command

To discover and install plug-ins and plug-in groups:

1. Discover which plug-ins or plug-in groups are available for installation by running:

   ```console
   tanzu plugin search
   ```

   ```console
   tanzu plugin group search
   ```

   > **Note** Include the `--show-details` flag to see all plug-in or group versions available
   > for installation.

2. Install the latest version of a plug-in or plug-in group by running:

   ```console
   tanzu plugin install PLUG-IN-NAME
   ```

   ```console
   tanzu plugin install --group GROUP-NAME
   ```

3. Install a specific version of a plug-in or plug-in group by running:

   ```console
   tanzu plugin install PLUG-IN-NAME --version VERSION
   ```

   ```console
   tanzu plugin install --group GROUP-NAME:VERSION
   ```
