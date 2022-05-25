# Application Accelerator CLI

The Application Accelerator command line interface (CLI) includes commands for developers and operators to create and use accelerators.

## <a id="server-api-connections"></a>Server API connections for operators and developers

The Application Accelerator CLI must connect to a server for all provided commands except for the `help` and `version` commands.

Operators typically use **create**, **update**, and **delete** commands for managing accelerators in a
Kubernetes context.
These commands require a Kubernetes context where the operator is already authenticated and is authorized to create and edit the accelerator resources.
Operators can also use the **get** and **list** commands by using the same authentication.
For any of these commands, the operator can specify the `--context` flag to access accelerators in a specific Kubernetes context.

Developers use the **list**, **get**, and **generate** commands for using accelerators
available in an Application Accelerator server.
Developers use the `--server-url` to point to the Application Accelerator server they want to use.
The URL depends on the configuration settings for Application Accelerator:

- For installations configured with a **shared ingress**, use `https://accelerator.<domain>` where `domain` is provided in the values file for the accelerator configuration.
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

The developer can set an `ACC_SERVER_URL` environment variable to avoid having to provide the same `--server-url` flag for every command.
Run `export ACC_SERVER_URL=<URL>` for the terminal session in use.
If the developer explicitly specifies the `--server-url` flag, it overrides the `ACC_SERVER_URL` environment variable if it is set.

## <a id="installation"></a>Installation

The Application Accelerator CLI commands are part of the Tanzu CLI Accelerator Plug-in.
This is shipped as part of VMware Tanzu Application Platform and can be installed alongside other Tanzu CLI plug-ins shipped with the platform.
For information about installing the Tanzu CLI and bundled plug-ins, see the
[Tanzu Application Platform documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/index.html).

## <a id="commands"></a>Commands

To view a list of commands, a description of commands, and help information, run:

```
tanzu accelerator  --help
```

### <a id="accelerator-commands"></a>Accelerator commands

Manage accelerators in a Kubernetes cluster.

Use: `tanzu accelerator [command]`

Where: `[command]` is a compatible command.

|Aliases:|
|--------|
| accelerator |
| acc |

Available Commands:

| Command | Description |
|--------|-------|
| apply | Apply accelerator |
| create | Create a new accelerator |
| delete | Delete an accelerator |
| generate | Generate project from accelerator |
| get | Get accelerator info |
| list | List accelerators |
| push | Push local path to source image |
| update | Update an accelerator |

Flags:

| Flag | Description |
|--------|-------|
| --context name | Name of the kubeconfig context to use (default is current-context defined by kubeconfig) |
| -h, --help | Help for accelerator |
| --kubeconfig file | kubeconfig file (default is $HOME/.kube/config) |

Use `tanzu accelerator [command] --help` for more information about a command.

### Apply

Create or update accelerator resource by using the specified accelerator manifest file.

Use: `tanzu accelerator apply [flags]`

Where: `[flags]` is one or more compatible flags.

Examples:

```
tanzu accelerator apply --filename <path-to-accelerator-manifest>
```

Flags:

| Flag | Description |
|--------|-------|
|  -f, --filename string | path of manifest file for the accelerator |
|  -h, --help | help for apply |
|  -n, --namespace string | namespace for accelerators; default is "accelerator-system" |

Global Flags:

| Flag | Description |
|--------|-------|
| --context name  | name of the kubeconfig context to use; default is current-context defined by kubeconfig |
| --kubeconfig file | kubeconfig file; default is $HOME/.kube/config |

### Create

Create a new accelerator resource with specified configuration.

Accelerator configuration options include:

- Git repository URL and branch/tag where accelerator code and metadata is defined.
- Metadata description, display-name, tags, and icon-url.

The Git repository option is required. Metadata options are optional and override any values for
the same options specified in the accelerator metadata retrieved from the Git repository.

Use: `tanzu accelerator create [flags]`

&nbsp;&nbsp;Where `[flags]` is one or more compatible flags.

Examples:

```
tanzu accelerator create <accelerator-name> --git-repository <URL> --git-branch <branch>
```

Flags:  

| Flag | Description |
|--------|-------|
| --description string  | Description of this accelerator |
| --display-name string | Display name for the accelerator |
| --git-branch string | Git repository branch to be used |
| --git-repository string  | Git repository URL for the accelerator |
| --git-tag string | Git repository tag to be used |
| --git-branch string | Git repository branch to be used |
| -h, --help | Help for create |
| --icon-url string | URL for icon to use with the accelerator |
| --interval string | Interval for checking for updates to Git or image repository |
| --local-path string | Path to the directory containing the source for the accelerator |
| -n, --namespace name | Namespace for accelerators (default "accelerator-system") |
| --secret-ref string | Name of secret containing credentials for private Git or image repository |
| --source-image string | Name of the source image for the accelerator |
| --tags strings | Tags that can be used to search for accelerators |

Global Flags:

| Flag | Description |
|--------|-------|
| --context name  | Name of the kubeconfig context to use (default is current-context defined by kubeconfig) |
| --kubeconfig file | kubeconfig file (default is $HOME/.kube/config) |

### <a id="delete"></a>Delete

Delete the accelerator resource with the specified name.

Use: `tanzu accelerator delete [flags]`

&nbsp;&nbsp;Where `[flags]` is one or more compatible flags.

Examples:

```
tanzu accelerator delete <accelerator-name>
```

Flags:

| Flag | Description |
|--------|-------|
| -h, --help  | Help for delete |
| -n, --namespace name | Namespace for accelerators (default "accelerator-system") |

Global Flags:

| Flag | Description |
|--------|-------|
| --context name | Name of the kubeconfig context to use (default is current-context defined by kubeconfig) |
| --kubeconfig file | kubeconfig file (default is $HOME/.kube/config) |

### <a id="generate"></a>Generate

Generate a project from an accelerator using provided options and download project artifacts as a ZIP file.

Generation options are provided as a JSON string and must match the metadata options specified for the
accelerator used for the generation. The options can include "projectName", which defaults to the name of the accelerator.
This "projectName" is used as the name of the generated ZIP file.

You can see the available options by using the "tanzu accelerator list <accelerator-name>" command.

Here is an example of an options JSON string that specifies the "projectName" and an "includeKubernetes" Boolean flag:

&nbsp;&nbsp;`--options '{"projectName":"test", "includeKubernetes": true}'`

You can also provide a file that specifies the JSON string using the `--options-file` flag.

The generate command needs access to the Application Accelerator server. You can specify the `--server-url` flag or set
an `ACC_SERVER_URL` environment variable. If you specify the `--server-url` flag, it overrides the `ACC_SERVER_URL`
environment variable if it is set.

Use: `tanzu accelerator generate [flags]`

&nbsp;&nbsp;Where `[flags]` is one or more compatible flags.

Examples:

```
tanzu accelerator generate <accelerator-name> --options '{"projectName":"test"}'
```

Flags:

| Flag | Description |
|--------|-------|
| -h, --help | Help for generate |
| --options string | Options JSON string |
| --options-file string | Path to file containing options JSON string |
| --output-dir string | Directory that the zip file is written to |
| --server-url string | The URL for the Application Accelerator server |   

Global Flags:

| Flag | Description |
|--------|-------|
| --context name | Name of the kubeconfig context to use (default is current-context defined by kubeconfig) |
| --kubeconfig file | kubeconfig file (default is $HOME/.kube/config) |

### <a id="get"></a>Get

Get accelerator information.

You can choose to get the accelerator from the Application Accelerator server by using the `--server-url` flag
or from a Kubernetes context by using the `--from-context` flag. The default is to get accelerators from the
Kubernetes context. To override this, you can set the `ACC_SERVER_URL` environment variable with the URL for
the Application Accelerator server you want to access.

Use: `tanzu accelerator get [flags]`

Where: `[flags]` is one or more compatible flags.

Examples:

```
tanzu accelerator get <accelerator-name> --from-context
```

Flags:

| Flag | Description |
|--------|-------|
| --from-context | Retrieve resources from current context defined in kubeconfig |
| -h, --help | Help for get |
| -n, --namespace name | Namespace for accelerators (default "accelerator-system") |
| --server-url string | The URL for the Application Accelerator server |

Global Flags:

| Flag | Description |
|--------|-------|
| --context name | Name of the kubeconfig context to use (default is current-context defined by kubeconfig) |
| --kubeconfig file | kubeconfig file (default is $HOME/.kube/config) |

### <a id="list"></a>List

List all accelerators.

You can choose to list the accelerators from the Application Accelerator server using `--server-url` flag
or from a Kubernetes context using `--from-context` flag. The default is to get accelerators from the
Kubernetes context. To override this, you can set the `ACC_SERVER_URL` environment variable with the URL for
the Application Acceleratior server you want to access.

Use: `tanzu accelerator list [flags]`

Where: `[flags]` is one or more compatible flags.

Examples:

```
tanzu accelerator list
```

Flags:

| Flag | Description |
|--------|-------|
| --from-context | Retrieve resources from current context defined in kubeconfig |
| -h, --help | Help for list |  
| -n, --namespace name | Namespace for accelerators (default "accelerator-system") |
| --server-url string | The URL for the Application Accelerator server |    

Global Flags:

| Flag | Description |
|--------|-------|
| --context name | Name of the kubeconfig context to use (default is current-context defined by kubeconfig) |
| --kubeconfig file | kubeconfig file (default is $HOME/.kube/config) |  

### <a id="update"></a>Update

Update an accelerator resource with the specified name using the specified configuration.

Accelerator configuration options include:

- Git repository URL and branch/tag where accelerator code and metadata is defined.
- Metadata description, display-name, tags, and icon-url.

The update command also provides a `--reconcile` flag that forces the accelerator to be refreshed
with any changes made to the associated Git repository.

Use: `tanzu accelerator update [flags]`

Where: `[flags]` is one or more compatible flags.

Examples:

```
tanzu accelerator update <accelerator-name> --description "Lorem Ipsum"
```

Flags:

| Flag | Description |
|--------|-------|
| --description string  | Description of this accelerator |
| --display-name string| Display name for the accelerator |  
| --git-branch string | Git repository branch to be used |
| --git-repository string | Git repository URL for the accelerator |  
| --git-tag string | Git repository tag to be used |
| -h, --help| Help for update |  
| --icon-url string | URL for icon to use with the accelerator |
| --interval string | Interval for checking for updates to Git or image repository |
| -n, --namespace name | Namespace for accelerators (default "accelerator-system") |  
| --reconcile | Trigger a reconciliation including the associated GitRepository resource|
| --secret-ref string | Name of secret containing credentials for private Git or image repository |
| --source-image string | Name of the source image for the accelerator |
| --tags strings | Tags used to search for accelerators |  

Global flags:

| Flag | Description |
|--------|-------|
| --context name | Name of the kubeconfig context to use (default is current-context defined by kubeconfig) |
| --kubeconfig file | kubeconfig file (default is $HOME/.kube/config) |  
