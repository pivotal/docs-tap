# CLI Plugin installation

>**Note:** By following the [instructions](../install-tanzu-cli.md) to install the tanzu cli and all the plugins, the `insight` plugin should also be installed.

This topic explains how to install the `insight` plugin by itself, after the user has installed the tanzu cli.

1. From your `tanzu` directory, install the local version of the `insight` plugin you downloaded by running:

    ```
    cd $HOME/tanzu
    tanzu plugin install insight --local cli
    ```
1. Configure the `insight` plugin by following these [instructions](cli_configuration.md)
