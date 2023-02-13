# Install Apps CLI plug-in

This document describes how to install the Apps CLI plug-in.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Apps CLI plug-in.
> For more information about profiles, see [About Tanzu Application Platform components and
> profiles](../../overview.hbs.md#about-package-profiles).

## <a id='prereqs'></a>Prerequisites

Before you install the Apps CLI plug-in:

- Follow the instructions to [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.md#cli-and-plugin).

## <a id='Install'></a>Install

To install the Apps CLI plug-in:

1. From the `HOME/tanzu` directory, run:

    ```console
    tanzu plugin install --local ./cli apps
    ```

2. To verify that the CLI is installed correctly, run:

    ```console
    tanzu apps version
    ```

    A version is displayed in the output.

    Verify that there is an `apps` entry in the `cli/manifest.yaml` file:

    ```yaml
    plugins:
    ...
        - name: apps
        description: Applications on Kubernetes
        versions: []
    ```
