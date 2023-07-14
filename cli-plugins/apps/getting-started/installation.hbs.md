# Install the Apps CLI plug-in

This topic tells you how to install the Apps CLI plug-in.

## Prerequisites

Ensure that you installed or updated the core Tanzu CLI. For more information, see
[Install Tanzu CLI](../../../install-tanzu-cli.hbs.md#install-cli).

## Install Apps CLI Plug-in

From VMware Tanzu CLI
: Install Apps CLI plug-in:

  ```console
  tanzu plugin install apps --group vmware-tap/default:VERSION
  ```

  Verify that the plug-in is installed correctly:

  ```console
  tanzu apps version
  # sample output
  v0.12.1
  ```

From GitHub release:
: The latest release is in the [GitHub repository releases page](https://github.com/vmware-tanzu/apps-cli-plugin/releases).

  Each of these releases has the `Assets` section where the packages for each `system-architecture`
  are placed.

  1. Download the binary executable file `tanzu-apps-plugin-{OS_ARCH}-{version}.tar.gz`:

       ```bash
       tar -xvf tanzu-apps-plugin-darwin-amd64-v0.12.1.tar.gz
       ```

  2. Run on macOS with plug-in version `0.12.1`:

        ```console
        tanzu plugin install apps \
        --local ./tanzu-apps-plugin-darwin-amd64-v0.12.1/darwin/amd64 \
        --version v0.12.1
        ```

## Uninstalling Apps CLI Plug-in

Run:

```console
tanzu plugin delete apps
```
