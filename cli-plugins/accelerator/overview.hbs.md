# Application Accelerator CLI plug-in overview

The Application Accelerator Tanzun CLI plug-in includes commands for developers and operators to create and use accelerators.

## <a id="server-api-connections"></a>Server API connections for operators and developers

The Application Accelerator CLI must connect to a server for all provided commands except for the `help` and `version` commands.

Operators typically use **create**, **update**, and **delete** commands for managing accelerators in a Kubernetes context.
They also use the **fragment** commands to manage accelerator fragments.
These commands require a Kubernetes context where the operator is already authenticated and is authorized to create and edit the accelerator resources.
Operators can also use the **get** and **list** commands by using the same authentication.
For any of these commands, the operator can specify the `--context` flag to access accelerators in a specific Kubernetes context.

Developers use the **list**, **get**, and **generate** commands for using accelerators
available in an Application Accelerator server.
Developers use the `--server-url` to point to the Application Accelerator server they want to use.
You can either use the proxy that is part of TAP-GUI or you can use the URL for the Application Accelerator server, if that is configured to be exposed. We recommend to use the TAP-GUI address.

### <a id="server-api-tap-gui"></a>Using TAP-GUI URL

When using TAP-GUI you should specify `--server-url` as `https://tap-gui.<domain>` where `domain` defaults to the `shared.ingress_domain` value provided in the values file of Tanzu Application Platform.

### <a id="server-api-acc-server"></a>Using Application Accelerator Server URL

If you cannot use the TAP-GUI URL, the fallback is to use Application Accelerator server directly. In this case the URL depends on the configuration settings for Application Accelerator:

- For installations configured with a **shared ingress** and where the Application Accelerator server is configured to use the ingress, use `https://accelerator.<domain>` where `domain` defaults to the `shared.ingress_domain` value provided in the values file of Tanzu Application Platform.
- For installations using a **LoadBalancer**, look up the External IP address by using:

    ```
    kubectl get -n accelerator-system service/acc-server
    ```

    Use `http://<External-IP>` as the URL.
- For any other configuration, you can use port forwarding by using:

    ```
    kubectl port-forward service/acc-server -n accelerator-system 8877:80
    ```

    Use `http://localhost:8877` as the URL.

### <a id="server-api-env-var"></a>Using "ACC_SERVER_URL" environment variable

The developer can set an `ACC_SERVER_URL` environment variable to avoid having to provide the same `--server-url` flag for every command.
Run `export ACC_SERVER_URL=<URL>` for the terminal session in use.
If the developer explicitly specifies the `--server-url` flag, it overrides the `ACC_SERVER_URL` environment variable if it is set.

## <a id="installation"></a>Installation

For information about installing the Tanzu CLI accelerator plug-in, see [Install Accelerator CLI plug-in](install-accelerator-cli.md).

## <a id='command-reference'></a>Command reference

For information about available commands, see [Command Reference](command-reference/tanzu_accelerator.md).
