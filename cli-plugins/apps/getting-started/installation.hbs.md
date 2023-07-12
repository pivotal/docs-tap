# Installation

## Prerequisites

Ensure that you installed or updated the core Tanzu CLI. For more information, see
[Install Tanzu CLI](/install-tanzu-cli.hbs.md#cli-and-plugin).

## Install Apps CLI Plug-in

From VMware Tanzu CLI
: Install Apps CLI plug-in from TAP group:

```bash
tanzu plugin install apps --group vmware-tap/default:<version>
```

Verify that the plugin is installed correctly:

```bash
tanzu apps version
# sample output
v0.12.1
```

From Github release:
: The latest release is in the Github repository releases page.
    Each of these releases has the `Assets` section where the packages for each `system-architecture`
    are placed.

1. Download the binary executable file `tanzu-apps-plugin-{OS_ARCH}-{version}.tar.gz`:

```bash
tar -xvf tanzu-apps-plugin-darwin-amd64-v0.12.1.tar.gz
```

2. Run (on macOS with plug-in version `0.12.1`):

```bash
tanzu plugin install apps \
--local ./tanzu-apps-plugin-darwin-amd64-v0.12.1/darwin/amd64 \
--version v0.12.1
```

## Uninstalling Apps CLI Plug-in

Run:

```bash
tanzu plugin delete apps
```
