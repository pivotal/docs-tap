# CLI plug-in installation

**Note:**

- By following the [instructions](../install-tanzu-cli.md) to install the Tanzu CLI and all the plug-ins, the `insight` plug-in is also installed.
- Currently, the `tanzu insight` plug-in only supports MacOS and Linux. Windows is not supported.

This topic explains how to install the `insight` plug-in by itself, after the user has installed the Tanzu CLI.

1. From your `tanzu` directory, install the local version of the `insight` plugin you downloaded by running:

    ```
    cd $HOME/tanzu
    tanzu plugin install insight --local cli
    ```

1. Configure the `insight` plug-in by following these [instructions](cli-configuration.md)
