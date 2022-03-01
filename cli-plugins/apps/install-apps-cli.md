# Install Apps CLI plug-in

This document describes how to install the Apps CLI plug-in.

## <a id='prereqs'></a>Prerequisites

Before you install the Apps CLI plug-in:

- Follow the instructions to [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.md#cli-and-plugin).

## <a id='Install'></a>Install

To install the Apps CLI plug-in:

1. From the `$HOME/tanzu` directory, run:

    ```
    tanzu plugin install --local ./cli apps
    ```

2. To verify that the CLI is installed correctly, run:

    ```
    tanzu apps version
    ```

    A version should be displayed in the output.

    If the following error is displayed during installation:

    ```
    Error: could not find plug-in "apps" in any known repositories

    ✖  could not find plug-in "apps" in any known repositories
    ```

    Verify that there is an `apps` entry in the `cli/manifest.yaml` file. It should look like this:

    ```
    plugins:
    ...
        - name: apps
        description: Applications on Kubernetes
        versions: []
    ```
