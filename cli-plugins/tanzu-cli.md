# Tanzu CLI Overview

This topic provides an overview of the Tanzu command-line interface (CLI).

## <a id="tanzu-cli"></a>Tanzu CLI

The Tanzu CLI is a command-line interface that connects you to Tanzu. For example, you can use the Tanzu CLI to:

- Configure the Tanzu CLI itself
- Install and manage packages
- Create and manage application workloads


## <a id="itanzu-cli-architecture"></a>Tanzu CLI Architecture

The Tanzu CLI has a pluggable architecture. Plug-ins contain CLI commands. Here are the CLI plug-ins that may be installed with Tanzu Application Platform.

- Accelerator: manage accelerator's in a Kubernetes cluster
- Apps: manage application workloads running on workload clusters
- Insight: post and query image, package, source, and vulnerability data
- Package: package management
- Secret: secret management
- Services: discover service types, service instances, and manage resource claims


You can also develop your own plug-ins to add custom commands to the Tanzu CLI. For more information about plug-ins, see the [Sync New Plugins](#plugin-sync), [Install New Plugins](#install-new), [Install Local Plugins](#install-local) following sections.

## <a id="tanzu-cli-install"></a>Tanzu CLI Installation

You install and initialize the Tanzu CLI on a computer. The computer can be a laptop, host, or server.

To install the CLI :

- To use the Tanzu CLI with **Tanzu Application Platform,** see [Installing the Tanzu CLI](install-tanzu-cli.md#cli-and-plugin).
- To use the Tanzu CLI with **Tanzu Kubernetes Grid,** see [Install the Tanzu CLI and Other Tools](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid-Integrated-Edition/1.14/tkgi/GUID-installing-cli.html#install-the-tkgi-cli-0).

## <a id="tanzu-cli-command-groups"></a>Tanzu CLI Command Groups

Tanzu CLI commands are organized into command groups. To view a list of available command groups, run `tanzu`. The list of command groups that you see depends on which CLI plug-ins are installed on your local machine.

## <a id="cli-config"></a> Tanzu CLI Configuration

The Tanzu CLI configuration file, `~/.config/tanzu/config.yaml`, contains your Tanzu CLI configuration, including:

- Sources for CLI plug-in discovery
- Global and plug-in-specific configuration options, or *features*
- Names, contexts, and `kubeconfig` locations for the management clusters that the CLI knows about, and which is the current one

You can use the `tanzu config set PATH VALUE` and `tanzu config unset PATH` commands to customize your CLI configuration, as described in the following table. Running these commands updates the `~/.config/tanzu/config.yaml` file.

<table>
  <thead>
    <tr>
      <th>Path</td>
      <th>Value</td>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>env.VARIABLE</code></td>
      <td>Your variable value; for example, <code>Standard_D2s_v3</code></td>
      <td>This path sets or unsets global environment variables for the CLI. Variables set by running <code>tanzu config set</code> persist until you unset them with <code>tanzu config unset</code>. You can set any of the variables listed in <a href="../tanzu-config-reference.md">Configuration File Variable Reference</a>. For example, <code>tanzu config set env.AZURE_NODE_MACHINE_TYPE Standard_D2s_v3</code>.</td>
    </tr>
    <tr>
      <td><code>features.global.FEATURE</code></td>
      <td><code>true</code> or <code>false</code></td>
      <td>This path activates or deactivates global features in your CLI configuration to. For example, <code>tanzu config set features.global.context-aware-cli-for-plugins true</code>.</td>
    </tr>
    <tr>
      <td><code>features.PLUGIN.FEATURE</code></td>
      <td><code>true</code> or <code>false</code></td>
      <td>This path activates or deactivates plug-in-specific features in your CLI configuration. To change or restore the defaults. Some of these features are beta and intended for evaluation and test purposes only. For example, running <code>tanzu config set features.cluster.dual-stack-ipv4-primary true</code> sets the <code>dual-stack-ipv4-primary</code> feature of the <code>cluster</code> CLI plug-in to <code>true</code>. By default, only production-ready plug-in features are set to <code>true</code> in the CLI. For more information, see <a href="../experimental-features.md">Experimental Features</a>.</td>
    </tr>
    <tr>
      <td><code>unstable-versions</code></td>
      <td><code>none</code> (default), <code>alpha</code>, <code>experimental</code>, and <code>all</code></td>
      <td><p>This path sets the <code>clientOptions.cli.unstableVersionSelector</code> property in the CLI configuration file. By default, the CLI uses only stable versions of CLI plug-ins. You can edit this behavior by setting <code>unstable-versions</code> to <code>alpha</code>, <code>experimental</code>, or <code>all</code>:</p>
        <ul>
          <li><code>none</code>: Allows only stable plug-in versions. <code>clientOptions.cli.unstableVersionSelector</code> is set to <code>none</code> by default.
          <li><code>alpha</code>: Allows stable and alpha plug-in versions.</li>
          <li><code>experimental</code>: Allows stable and pre-release plugin versions, including alpha versions.</li>
          <li><code>all</code>: Allows all plug-in< versions, including stable, pre-release, and build-tagged versions.</li>
        </ul>
      <p>To restore the default, set <code>unstable-versions</code> to <code>none</code>.</p>
      </td>
    </tr>
  </tbody>
</table>

The following table lists the global and plug-in-specific features that you can configure in the Tanzu CLI.

### <a id="features"></a>Features

<table>
  <thead>
    <tr>
      <th>Name</td>
      <th>Default</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
     <td colspan="3">Global features:</td>
    </tr>
    <tr>
      <td><code>context-aware-cli-for-plugins</code></td>
      <td><code>true</code></td>
      <td>Enables auto-discovery of CLI plugins.</td>
    </tr>
    <tr>
      <td colspan="3"><code>management-cluster</code> plug-in features:</td>
    </tr>
    <tr>
      <td><code>custom-nameservers</code></td>
      <td><code>false</code></td>
      <td>(<strong>Experimental, vSphere only</strong>) Allows you to configure custom DNS servers for control plane and worker nodes. This feature is in development.</td>
    </tr>
    <tr>
      <td><code>dual-stack-ipv4-primary</code></td>
      <td><code>false</code></td>
      <td>(<strong>Experimental, vSphere only</strong>) Allows you to deploy dual-stack clusters, with IPv4 as the primary protocol. This feature is in development.</td>
    </tr>
    <tr>
      <td><code>dual-stack-ipv6-primary</code></td>
      <td><code>false</code></td>
      <td>(<strong>Experimental, vSphere only</strong>) Allows you to deploy dual-stack clusters, with IPv6 as the primary protocol. This feature is in development.</td>
    </tr>
    <tr>
      <td><code>export-from-confirm</code></td>
      <td><code>true</code></td>
      <td>Enables the <strong>Export Configuration</strong> button in the Tanzu Kubernetes Grid installer interface.</td>
    </tr>
    <tr>
      <td><code>import</code></td>
      <td><code>false</code></td>
      <td>Allows you to import the cluster configuration file into the Tanzu Kubernetes Grid installer interface. This feature is not available in Tanzu Kubernetes Grid v1.5.</td>
    </tr>
    <tr>
      <td><code>standalone-cluster-mode</code></td>
      <td><code>false</code></td>
      <td>Enables you to deploy standalone clusters in Tanzu Community Edition. This feature is not available in Tanzu Kubernetes Grid.</td>
    </tr>
    <tr>
      <td colspan="3"><code>cluster</code> plug-in features:</td>
    </tr>
    <tr>
      <td><code>custom-nameservers</code></td>
      <td><code>false</code></td>
      <td>See above.</td>
    </tr>
    <tr>
      <td><code>dual-stack-ipv4-primary</code></td>
      <td><code>false</code></td>
      <td>See above.</td>
    </tr>
    <tr>
      <td><code>dual-stack-ipv6-primary</code></td>
      <td><code>false</code></td>
      <td>See above.</td>
    </tr>
  </tbody>
</table>

## <a id="plugin-sync"></a> Sync New Plugins

The `tanzu plugin sync` command discovers and downloads new CLI plug-ins that are associated with either a newer version of Tanzu Kubernetes Grid or a package installed on your management cluster that your local CLI does not know about, for example, if another user installed it.

Run this command when:

- **update this?** You install the Tanzu CLI for the first time or upgrade to a newer version of Tanzu Kubernetes Grid see [Install the Tanzu CLI Plugins](install-cli.md#install-the-tanzu-cli-plugins-4) in *Install the Tanzu CLI and Other Tools*.

- You are already logged in to a management cluster and another user installs a package with an associated CLI plug-in on the same management cluster. If you are not logged in, these CLI plug-ins are installed when you run `tanzu login`.

For more information, see [Sync Command](https://github.com/vmware-tanzu/tanzu-framework/blob/main/docs/design/context-aware-plugin-discovery-design.md#sync-command) in the Tanzu Framework repository.

## <a id="install-new"></a> Install New Plugins

To install a Tanzu CLI plug-in that was not automatically downloaded when running `tanzu login` or `tanzu plugin sync`, install it manually by following these steps.

1. In a terminal, run:

   ```
   tanzu plugin install PLUGIN-NAME
   ```

2. Verify that you installed the plugin successfully by running:

   ```
   tanzu plugin list
   NAME                DESCRIPTION                                    SCOPE         DISCOVERY    VERSION      STATUS
   login               Login to the platform                          Standalone    default      v0.11.0-dev  installed
   management-cluster  Kubernetes management-cluster operations       Standalone    default      v0.11.0-dev  installed
   package             Tanzu package management                       Standalone    default      v0.11.0-dev  installed
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
   tanzu plugin list --local /PATH/TO/FILE/
   NAME     DESCRIPTION                 SCOPE       DISCOVERY  VERSION      STATUS
   builder  Build Tanzu components      Standalone             v0.13.0-dev  installed
   codegen  Tanzu code generation tool  Standalone             v0.13.0-dev  installed
   ```
