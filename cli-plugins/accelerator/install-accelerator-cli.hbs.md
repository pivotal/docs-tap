# Install Accelerator CLI plug-in

This document tells you how to install the Accelerator CLI plug-in.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Accelerator CLI plug-in.
> For more information about profiles, see [About Tanzu Application Platform components and
> profiles](../../about-package-profiles.hbs.md).

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

    Verify that there is an `accelerator` entry in the `cli/manifest.yaml` file. It will look similar to this:

    ```yaml
    plugins:
    ...
        - name: accelerator
        description: Manage accelerators in a Kubernetes cluster
        versions: []
    ```
