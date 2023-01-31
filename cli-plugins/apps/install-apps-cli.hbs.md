# Install Apps CLI plug-in

This topic describes how to install the Apps CLI plug-in.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Apps CLI plug-in.
> For more information about profiles, see [About Tanzu Application Platform components and
> profiles](../../about-package-profiles.hbs.md).

## <a id='prereqs'></a>Prerequisites

Before you install the Apps CLI plug-in:

- Follow the instructions to [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.md#cli-and-plugin).

## <a id='Install'></a>Install

### <a id=”from-tap-net”></a>From VMware Tanzu Network

To install the Apps CLI plug-in:

1. From the `$HOME/tanzu` directory, run:

    ```console
    tanzu plugin install --local ./cli apps
    ```

2. To verify that the CLI is installed correctly, run:

    ```console
    tanzu apps version
    ```

    A version is be displayed in the output.

    If the following error is displayed during installation:

    ```console
    Error: could not find plug-in "apps" in any known repositories

    ✖  could not find plug-in "apps" in any known repositories
    ```

    Verify that there is an `apps` entry in the `cli/manifest.yaml` file. It will look similar to this:

    ```yaml
    plugins:
    ...
        - name: apps
        description: Applications on Kubernetes
        versions: []
    ```

### <a id=”from-release”></a>From Release

Download the latest release from the [ apps-cli-plugin release page](https://github.com/vmware-tanzu/apps-cli-plugin/releases/). Each of these releases has the *Assets* section where the packages for each *system-architecture* are placed.

To install the Apps CLI plug-in:

Download binary executable file `tanzu-apps-plugin-{OS_ARCH}-{version}.tar.gz`
For example, run the these commands on macOS with plugin version v0.11.0

```bash
tar -xvf tanzu-apps-plugin-darwin-amd64-v0.11.0.tar.gz
tanzu plugin install apps --local ./tanzu-apps-plugin-darwin-amd64-v0.11.0 --version v0.11.0
```
