# Create a workload

This topic describes how to create a workload from example source code with Tanzu Application Platform.

## <a id='prerequisites'></a> Prerequisites

The following prerequisites are required to use workloads with Tanzu Application Platform:

- Install [kubectl](https://kubernetes.io/docs/tasks/tools/).
- Install Tanzu Application Platform components on a Kubernetes cluster. See [Installing Tanzu Application Platform](../../install-intro.md).
- Set your kubeconfig context to the prepared cluster `kubectl config use-context CONTEXT_NAME`.
- Install Tanzu CLI. See [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.md#cli-and-plugin).
- Install the apps plug-in. See the [Install Apps plug-in](install-apps-cli.md).
- [Set up developer namespaces to use your installed packages](../../install-online/set-up-namespaces.hbs.md).

## <a id="example"></a> Get started with an example workload

### <a id="workload-git"></a> Create a workload from GitHub repository

Create a workload from an existing Git repository by setting the flags `--git-repo`, `--git-branch`, `--git-tag`, and `--git-commit`. This allows the [supply chain](../../scc/about.md) to get the source from the given repository to deploy the application.

To create a named workload and specify a Git source code location, run:

 ```bash
tanzu apps workload create pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web
```

Respond `Y` to prompts to complete process.

Where:

- `pet-clinic` is the name of the workload.
- `--git-repo` is the location of the code to build the workload from.
- `--git-branch` (optional) specifies which branch in the repository to pull the code from.
- `--type` used to distinguish the workload type.

You can find the options available for specifying the workload in the command reference for [`workload create`](command-reference/tanzu-apps-workload-create.md), or you can run `tanzu apps workload create --help`.

### <a id="workload-local-source"></a> Create a workload from local source code

Tanzu Application Platform supports creating a workload from an existing local project by setting the flags `--local-path` and `--source-image`, this allows the [supply chain](../../scc/about.md) to generate an image ([carvel-imgpkg](https://carvel.dev/imgpkg/)) and push it to the given registry to be used in the workload.

- To create a named workload and specify where the local source code is, run:

    ```bash
    tanzu apps workload create pet-clinic --local-path /path/to/my/project --source-image springio/petclinic
    ```

    Respond `Y` to the prompt to publish the local source code and update the image.

    Where:

    - `pet-clinic` is the name of the workload.
    - `--local-path` points to the directory where the source code is located.
    - `--source-image` is the registry path where the local source code is uploaded as an image.

    **Exclude Files**
    When working with local source code, you can exclude files from the source code to be uploaded within the image by creating a file `.tanzuignore` at the root of the source code. You can find the options available to specify the workload in the command reference for [`workload create`](command-reference/tanzu-apps-workload-create.md), or run `tanzu apps workload create --help`.

    The file must contain a list of file paths to exclude from the image including the file itself and the directories must not end with the system path separator (`/` or `\`).

    If the file contains files or directories that are not in the source code, they are ignored.

    If a line in the file starts with a `#` hashtag , the line is ignored.

    **Example**

    ```
    # This is a comment
    this/is/a/folder/to/exclude

    this-is-a-file.ext
    ```

### <a id="workload-image"></a> Create workload from an existing image

Creating a workload from an existing image by setting the flag `--image`. This allows the [supply chain](../../scc/about.md) to get the given image from the registry to deploy the application.

An example on how to create a workload from image is as follows:

```bash
tanzu apps workload create petclinic-image --image springcommunity/spring-framework-petclinic
```

Respond `Y` to prompts to complete process.

 Where:

- `petclinic-image` is the name of the workload.
- `--image` is an existing image, pulled from a registry, that contains the source that the workload is going to use to create the application.

### <a id="workload-maven"></a> Create a workload from Maven repository artifact

Tanzu Application Platform supports creating a workload from a Maven repository artifact ([Source-Controller](../../source-controller/about.md)) by setting some specific properties as yaml parameters in the workload when using the [supply chain](../../scc/about.md).

The maven repository URL is being set when the supply chain is created.

- Param name: maven
- Param value:
    - YAML:
    ```yaml
    artifactId: ...
    type: ... # default jar if not provided
    version: ...
    groupId: ...

    ```
    - JSON:
    ```json
    {
        "artifactId": ...,
        "type": ..., // default jar if not provided
        "version": ...,
        "groupId": ...
    }
    ```

For example, to create a workload from a maven artifact:

```bash
# YAML
tanzu apps workload create petclinic-image --param-yaml maven=$"artifactId:hello-world\ntype: jar\nversion: 0.0.1\ngroupId: carto.run"

# JSON
tanzu apps workload create petclinic-image --param-yaml maven="{"artifactId":"hello-world", "type": "jar", "version": "0.0.1", "groupId": "carto.run"}"
```

## <a id="bind-service"></a> Bind a service to a workload

Tanzu Application Platform supports creating a workload with binding to multiple services ([Service Binding](../../service-bindings/about.md)). The cluster supply chain is in charge of provisioning those services.

The intent of these bindings is to provide information from a service resource to an application.

- To bind a database service to a workload, run:

    ```bash
    tanzu apps workload update pet-clinic --service-ref "database=services.tanzu.vmware.com/v1alpha1:MySQL:my-prod-db"
    ```

    Where:

    - `pet-clinic` is the name of the workload to be updated.
    - `--service-ref` references the service using the format {service-ref-name}={apiVersion}:{kind}:{service-binding-name}.

Check [services consumption documentation](../../getting-started/consume-services.md) to get more information on how to bind a service to a workload.

## <a id="next-steps"></a> Next steps

You can check workload details and status, add environment variables, export definitions, bind services, and use flags with these [commands](command-reference.md). For more information,[Command reference](command-reference.hbs.md).

1. To check workload status and details, use `workload get` command and to get workload logs, use `workload tail` command.
For more information about these, refer to [debug workload section](debug-workload.md).

2. To add environment variables, run:

    ```bash
    tanzu apps workload update pet-clinic --env foo=bar
    ```

3. To export the workload definition into Git, or to migrate to another environment, run:

    ```bash
    tanzu apps workload get pet-clinic --export
    ```

4. To bind a service to a workload, see the [--service-ref flag](command-reference/commands-details/workload_create_update_apply.md#apply-service-ref).

5. To see flags available for the workload commands, run:

    ```bash
    tanzu apps workload -h
    tanzu apps workload get -h
    tanzu apps workload create -h
    ```
