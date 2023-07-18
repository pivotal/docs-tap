# Tanzu CLI Overview

This topic provides an overview of the Tanzu command-line interface (CLI).

## <a id="tanzu-cli"></a>Tanzu CLI

The Tanzu CLI is a command-line interface that connects you to Tanzu. For example, you can use the Tanzu CLI to:

- Configure the Tanzu CLI itself
- Install and manage packages
- Create and manage application workloads


## <a id="itanzu-cli-architecture"></a>Tanzu CLI Architecture

The Tanzu CLI has a pluggable architecture. Plug-ins contain CLI commands. Here are the CLI plug-ins that can be installed with Tanzu Application Platform.

- Accelerator: manage accelerator's in a Kubernetes cluster
- Apps: manage application workloads running on workload clusters
- Build Service: plugin to interact with tanzu build service (tbs) crds
- Insight: post and query image, package, source, and vulnerability data
- Package: package management
- Secret: secret management
- Services: discover service types, service instances, and manage resource claims


You can also develop your own plug-ins to add custom commands to the Tanzu CLI. For more information about plug-ins, see the [Sync New Plugins](#plugin-sync), [Install New Plugins](#install-new), [Install Local Plugins](#install-local) following sections.

## <a id="tanzu-cli-install"></a>Tanzu CLI Installation

You install and initialize the Tanzu CLI on a computer. The computer can be a laptop, host, or server.

To install the CLI :

- To use the Tanzu CLI with **Tanzu Application Platform,** see [Installing the Tanzu CLI](../install-tanzu-cli.md#cli-and-plugin).
- To use the Tanzu CLI with **Tanzu Kubernetes Grid,** see [Install the Tanzu CLI and Other Tools](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid-Integrated-Edition/1.14/tkgi/GUID-installing-cli.html#install-the-tkgi-cli-0).

## <a id="tanzu-cli-command-groups"></a>Tanzu CLI Command Groups

Tanzu CLI commands are organized into command groups. To view a list of available command groups, run `tanzu`. The list of command groups that you see depends on which CLI plug-ins are installed on your local machine.

## <a id="install-new"></a> Install New Plugins

To install a Tanzu CLI plug-in that was not automatically downloaded when running `tanzu login` or `tanzu plugin sync`, install it manually by following these steps.

1. In a terminal, run:

   ```
   tanzu plugin install PLUGIN-NAME
   ```

2. Verify that you installed the plugin successfully by running:

   ```
   tanzu plugin list

  NAME                DESCRIPTION                                                        SCOPE       DISCOVERY  VERSION  STATUS
  login               Login to the platform                                              Standalone  default    v0.25.4  not installed
  management-cluster  Kubernetes management-cluster operations                           Standalone  default    v0.25.4  not installed
  package             Tanzu package management                                           Standalone  default    v0.25.4  installed
  pinniped-auth       Pinniped authentication operations (usually not directly invoked)  Standalone  default    v0.25.4  not installed
  secret              Tanzu secret management                                            Standalone  default    v0.25.4  installed
  telemetry           Configure cluster-wide telemetry settings                          Standalone  default    v0.25.4  not installed
  services            Commands for working with service instances, classes and claims    Standalone             v0.5.0   installed
  accelerator         Manage accelerators in a Kubernetes cluster                        Standalone             v1.4.1   installed
  apps                Applications on Kubernetes                                         Standalone             v0.10.0  installed
  insight             post & query image, package, source, and vulnerability data        Standalone             v1.4.3   installed
  build-service       plugin to interact with tanzu build service (tbs) crds             Standalone             v1.0.0   installed
   ```

## <a id="install-local"></a> Install Local Plugins

If your network is not connected to the Internet or you want to download and inspect
the Tanzu CLI plug-in binaries before installing, follow these steps:

1. Download the plug-in `tar.gz` from the release artifacts for your distribution.

2. Extract the `tar.gz` to a location on your local machine using the extraction tool of your choice.
For example, the `tar -xvf` command.

2. From that location, run:

   ```
   tanzu plugin install all --local /PATH/TO/FILE/
   ```

3. Verify that you installed the plug-ins successfully by running:

   ```
   tanzu plugin list
    NAME                DESCRIPTION                                                        SCOPE       DISCOVERY  VERSION  STATUS
  login               Login to the platform                                              Standalone  default    v0.25.4  not installed
  management-cluster  Kubernetes management-cluster operations                           Standalone  default    v0.25.4  not installed
  package             Tanzu package management                                           Standalone  default    v0.25.4  installed
  pinniped-auth       Pinniped authentication operations (usually not directly invoked)  Standalone  default    v0.25.4  not installed
  secret              Tanzu secret management                                            Standalone  default    v0.25.4  installed
  telemetry           Configure cluster-wide telemetry settings                          Standalone  default    v0.25.4  not installed
  services            Commands for working with service instances, classes and claims    Standalone             v0.5.0   installed
  accelerator         Manage accelerators in a Kubernetes cluster                        Standalone             v1.4.1   installed
  apps                Applications on Kubernetes                                         Standalone             v0.10.0  installed
  insight             post & query image, package, source, and vulnerability data        Standalone             v1.4.3   installed 
  build-service       plugin to interact with tanzu build service (tbs) crds             Standalone             v1.0.0   installed
   ```