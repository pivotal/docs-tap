# Install Accelerator CLI plug-in

This document describes how to install the Accelerator CLI plug-in.

## <a id='prereqs'></a>Prerequisites

Before you install the Accelerator CLI plug-in:

- Follow the instructions to [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.md#cli-and-plugin).

## <a id='Install'></a>Install

To install the Accelerator CLI plug-in:

1. From the `$HOME/tanzu` directory, run:

    ```console
    tanzu plugin install --local ./cli accelerator
    ```

2. To verify that the CLI is installed correctly, run:

    ```console
    tanzu accelerator version
    ```

    A version will be displayed in the output.

    If the following error is displayed during installation:

    ```console
    Error: could not find plug-in "accelerator" in any known repositories

    ✖  could not find plug-in "accelerator" in any known repositories
    ```

    Verify that there is an `accelerator` entry in the `cli/manifest.yaml` file. It should look like this:

    ```yaml
    plugins:
    ...
        - name: accelerator
        description: Manage accelerators in a Kubernetes cluster
        versions: []
    ```
