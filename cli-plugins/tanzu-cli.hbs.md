# Tanzu CLI Overview

This topic tells you about the Tanzu command-line interface (CLI).

## <a id="tanzu-cli"></a>Tanzu CLI

The Tanzu CLI is a command-line interface that connects you to Tanzu. For example, you can use the Tanzu CLI to:

- Configure the Tanzu CLI itself
- Install and manage packages
- Invoke Tanzu services and components
- Create and manage application workloads
- and more...

To read more comprehensive documentation about the Tanzu CLI see the [VMware Tanzu CLI docs](https://docs.vmware.com/en/VMware-Tanzu-CLI/index.html).

## <a id="itanzu-cli-architecture"></a>Tanzu CLI Architecture

The Tanzu CLI has a pluggable architecture. Plug-ins extend the Tanzu CLI core with additional CLI commands.</br>

The following CLI plug-ins are required to install/utilize Tanzu Application Platform.

- _accelerator_: manage accelerator's in a Kubernetes cluster
- _apps_: manage application workloads running on workload clusters
- _build-service_: plugin to interact with tanzu build service (tbs) crds
- _external-secrets_: interact with external-secrets.io resources
- _insight_: post and query image, package, source, and vulnerability data
- _package_: package management
- _secret_: secret management
- _services_: discover service types, service instances, and manage resource claims


You can also develop your own plug-ins to add custom commands to the Tanzu CLI. For more information about plug-ins, see the [Sync New Plugins](#plugin-sync), [Install New Plugins](#install-new), [Install Local Plugins](#install-local) following sections.

## <a id="tanzu-cli-install"></a>Tanzu CLI Installation

You install and initialize the Tanzu CLI on a computer. The computer can be a laptop, host, or server.

To install the CLI see [Installing the Tanzu CLI](../install-tanzu-cli.md#cli-and-plugin).

## <a id="tanzu-cli-command-groups"></a>Tanzu CLI Command Groups

Tanzu CLI commands are organized into command groups. To view a list of available command groups, run `tanzu`. The list of command groups that you see depends on which CLI plug-ins are installed on your local machine.

## <a id="install-new"></a> Install New Plugins

If you want to install the CLI Plugins required for TAP v{{ vars.tap_version }}, run the following command in your terminal:

```
tanzu plugin install --group vmware-tap/default:v{{ vars.tap_version }}
```

Below is a generalized overview of plugin and plugin group discovery and installation.


Plugins for the Tanzu CLI are distributed via a centralized plugin repository.</br>
The centralized plugin repository contains CLI plugins (which can be installed individually) and plugin groups (a collection of plugins installable via a single command).</br>
Below are instructions for discovering and installing plugins and/or plugin groups:

1. In a terminal, you can run a search to discover which plugins and/or plugin groups are available for installation:

   ```
   tanzu plugin search
   ```
   
   ```
   tanzu plugin group search
   ```
   > Note: include the `--show-details` flag to see all plugin and/or group versions available for installation
   
1. To install the _latest_ version of a plugin and/or plugin group:	

   ```
   tanzu plugin install PLUGIN-NAME
   ```

   ```
   tanzu plugin install --group GROUP-NAME
   ```

1. To install a specific version of a plugin and/or plugin group:

   ```
   tanzu plugin install PLUGIN-NAME --version VERSION
   ```

   ```
   tanzu plugin install --group GROUP-NAME:VERSION
   ```
