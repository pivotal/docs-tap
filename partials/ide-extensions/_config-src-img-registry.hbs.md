Please configure Local Source Proxy following these [instructions](../../local-source-proxy/about.hbs.md)

If Local Source Proxy cannot be configured, then use a source image registry.
Before deploying a workload, you must authenticate with an image registry to store your source code.
You can use the Docker CLI to authenticate or you can set environment variables that the Tanzu CLI
can use to authenticate.

Docker CLI
: To authenticate by using the Docker CLI, run:

    ```console
    docker login $REGISTRY_HOSTNAME -u $REGISTRY_USERNAME -p $REGISTRY_PASSWORD
    ```

Tanzu CLI
: To authenticate using the Tanzu CLI, export these environment variables by running:

    ```console
    export TANZU_APPS_REGISTRY_CA_CERT=PATH-TO-CA-CERT.nip.io.crt
    export TANZU_APPS_REGISTRY_PASSWORD=USERNAME
    export TANZU_APPS_REGISTRY_USERNAME=PASSWORD
    ```

  `CA_CERT` is only needed for a custom or private registry.

For more information, see
[Workload creation fails due to authentication failure in Docker Registry](../troubleshooting-tap/troubleshoot-using-tap.hbs.md#workload-fails-docker-auth)