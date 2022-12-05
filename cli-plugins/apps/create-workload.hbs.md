# Create a workload

This document describes how to create a workload from example source code with Tanzu Application Platform.

## <a id='prerequisites'></a> Prerequisites

The following prerequisites are required to use workloads with Tanzu Application Platform:

- Install Kubernetes command line tool (kubectl). For information about installing kubectl, see [Install Tools](https://kubernetes.io/docs/tasks/tools/) in the Kubernetes documentation.
- Install Tanzu Application Platform components on a Kubernetes cluster. See [Installing Tanzu Application Platform](../../install-intro.hbs.md).
- [Set your kubeconfig context](tutorials.hbs.md#changing-clusters) to the prepared cluster `kubectl config use-context CONTEXT_NAME`.
- Install Tanzu CLI. See [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.hbs.md#cli-and-plugin).
- Install the apps plug-in. See the [Install Apps plug-in](tutorials.hbs.md#install).
- [Set up developer namespaces to use installed packages](../../set-up-namespaces.hbs.md).

## <a id="example"></a> Get started with an example workload

### <a id="workload-git"></a> Create a workload from GitHub repository

Tanzu Application Platform supports creating a workload from an existing git repository by setting the flags `--git-repo`, `--git-branch`, `--git-tag` and `--git-commit`, this will allow the out of the box [supply chain](../../scc/about.hbs.md) to get the source from the given repository to deploy the application.

To create a named workload and specify a git source code location, run:

 ```bash
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-1.3 --type web
```

Respond `Y` to prompts to complete process.

Where:

- `tanzu-java-web-app` is the name of the workload.
- `--git-repo` is the location of the code to build the workload from.
- `--sub-path` is the relative path inside the repository to treat as application root.
- `--git-tag` (optional) specifies which tag in the repository to pull the code from.
- `--git-branch` (optional) specifies which branch in the repository to pull the code from.
- `--type` is used to distinguish the workload type.

View the full list of supported workload configuration options by running `tanzu apps workload apply --help`.

### <a id="workload-local-source"></a> Create a workload from local source code

Tanzu Application Platform supports creating a workload from an existing local project by setting the flags `--local-path` and `--source-image`, this allows the [supply chain](../../scc/about.hbs.md) to generate an image ([carvel-imgpkg](https://carvel.dev/imgpkg/)) and push it to the given registry to be used in the workload.

- To create a named workload and specify where the local source code is, run:

    ```bash
    tanzu apps workload create pet-clinic --local-path /path/to/my/project --source-image springio/petclinic
    ```

    Respond `Y` to the prompt about publishing local source code if the image needs to be updated.

    Where:

    - `pet-clinic` is the name of the workload.
    - `--local-path` points to the directory where the source code is located.
    - `--source-image` is the registry path where the local source code will be uploaded as an image.

    **Exclude Files**
    When working with local source code, you can exclude files from the source code to be uploaded within the image by creating a file `.tanzuignore` at the root of the source code.

    The file must contain a list of file paths to exclude from the image including the file itself and the directories must not end with the system path separator (`/` or `\`).

    More info regarding .tanzuignore file can be found in the [how-to guide](how-to-guides.hbs.md#tanzuignore-file).

### <a id="workload-image"></a> Create workload from an existing image

Tanzu Application Platform supports creating a workload from an existing image by setting the flag `--image`. This will allow the out of the box [supply chain](../../scc/about.hbs.md) to get the given image from the registry to deploy the application.

An example on how to create a workload from image is as follows:

```bash
tanzu apps workload create petclinic-image --image springcommunity/spring-framework-petclinic
```

Respond `Y` to prompts to complete process.

 Where:

- `petclinic-image` is the name of the workload.
- `--image` is an existing image, pulled from a registry, that contains the source that the workload is going to use to create the application.

### <a id="workload-maven"></a> Create a workload from Maven repository artifact

Tanzu Application Platform supports creating a workload from a Maven repository artifact ([Source-Controller](../../source-controller/about.hbs.md)) by setting some specific properties as yaml parameters in the workload when using the [supply chain](../../scc/about.hbs.md).

The maven repository url is being set when the supply chain is created.

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

For example, to create a workload from a maven artifact, something like this could be done:

```bash
# YAML
tanzu apps workload create petclinic-image --param-yaml maven=$"artifactId:hello-world\ntype: jar\nversion: 0.0.1\ngroupId: carto.run"

# JSON
tanzu apps workload create petclinic-image --param-yaml maven="{"artifactId":"hello-world", "type": "jar", "version": "0.0.1", "groupId": "carto.run"}"
```

## <a id='yaml-files'></a> Working with YAML files

In many cases, you can manage workload life cycles through CLI commands.
However, you might find cases where you want to manage a workload by using a `yaml` file.
The Apps CLI plug-in supports using `yaml` files.

The plug-in is designed to manage one workload at a time.
When you manage a workload using a `yaml` file, that file must contain a single workload definition.
Plug-in commands support only one file per command.

For example, a valid file looks similar to the following example:

```yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tanzu-java-web-app
  labels:
    app.kubernetes.io/part-of: tanzu-java-web-app
    apps.tanzu.vmware.com/workload-type: web
spec:
  source:
    git:
      url: https://github.com/vmware-tanzu/application-accelerator-samples
      ref:
        tag: tap-1.3
    subPath: tanzu-java-web-app
```

To create a workload from a file like the example above:

```console
tanzu apps workload create -f my-workload-file.yaml
```

The workload yaml definition can also be passed in through stdin as follows:

```console
tanzu apps workload create -f - --yes
```

The console remains waiting for some input, and the content with a valid `yaml` definition for a workload can be either written or pasted, then press **Ctrl-D** three times to start workload creation. This can also be done with `workload apply` command.

**Note** to pass workload through `stdin`, the `--yes` flag is required. If not provided, the command will fail.

## <a id="bind-service"></a> Bind a service to a workload

Tanzu Application Platform supports creating a workload with binding to multiple services ([Service Binding](../../service-bindings/about.hbs.md)). The cluster supply chain is in charge of provisioning those services.

The intent of these bindings is to provide information from a service resource to an application.

- To bind a database service to a workload, run:

    ```bash
    tanzu apps workload update pet-clinic --service-ref "database=services.tanzu.vmware.com/v1alpha1:MySQL:my-prod-db"
    ```

    Where:

    - `pet-clinic` is the name of the workload to be updated.
    - `--service-ref` references the service using the format {service-ref-name}={apiVersion}:{kind}:{service-binding-name}.

Check [services consumption documentation](../../getting-started/consume-services.hbs.md) to get more info on how to bind a service to a workload.

## <a id="next-steps"></a> Next steps

You can check workload details and status, add environment variables, export definitions or bind services.

1. To check workload status and details, use `workload get` command and to get workload logs, use `workload tail` command. For more info about these, refer to [debug workload section](debug-workload.hbs.md).


2. To add environment variables, run:

    ```bash
    tanzu apps workload update pet-clinic --env foo=bar
    ```

3. To export the workload definition into git, or to migrate to another environment, run:

    ```bash
    tanzu apps workload get pet-clinic --export
    ```

4. To bind a service to a workload, see the [--service-ref flag](command-reference/commands-details/workload_create_update_apply.hbs.md#service-ref).

5. To see flags available for the workload commands, run:

    ```bash
    tanzu apps workload -h
    tanzu apps workload get -h
    tanzu apps workload create -h
    ```
