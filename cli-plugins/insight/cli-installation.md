# Install the Tanzu Insight CLI plug-in

**Note:**

- By following the [instructions](../../install-tanzu-cli.md) to install the Tanzu CLI and all the plug-ins, the Tanzu Insight plug-in is also installed.
- Currently, the Tanzu Insight plug-in only supports macOS and Linux.

This topic explains how to install the Tanzu Insight plug-in by itself, after the user has installed the Tanzu CLI.

1. From your `tanzu` directory, install the local version of the Tanzu Insight plug-in you downloaded by running:

    ```console
    cd $HOME/tanzu
    tanzu plugin install insight --local cli
    ```

1. Follow the steps in [Configure the Tanzu Insight CLI plug-in](cli-configuration.md).
