# Install Tanzu Apps CLI

This topic tells you how to install the Tanzu Apps CLI on Tanzu Application Platform (commonly known as TAP).

## Prerequisites

Ensure that you installed or updated the core Tanzu CLI. For more information, see
[Install Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-cli).

## Install Tanzu Apps CLI plug-in

Run:

```console
tanzu plugin install apps --group vmware-tap/default:v{{ vars.tanzu-cli.plugin_group_version }}
```

Verify that the plug-in is installed correctly:

```console
tanzu apps version
# sample output
v0.12.1
```

## Uninstall Tanzu Apps CLI

Run:

```console
tanzu plugin delete apps
```
