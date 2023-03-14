# Create a workload

This topic describes how to create a workload from example source code with Tanzu Application Platform.

## <a id='prerequisites'></a> Prerequisites

The following prerequisites are required to use workloads with Tanzu Application Platform:

- Install [kubectl](https://kubernetes.io/docs/tasks/tools/).
- Install Tanzu Application Platform components on a Kubernetes cluster. See [Installing Tanzu
  Application Platform](../../install-intro.hbs.md).
- [Set your kubeconfig context](tutorials.hbs.md#changing-clusters) to the prepared cluster `kubectl
  config use-context CONTEXT_NAME`.
- Install Tanzu CLI. See [Install or update the Tanzu CLI and
  plug-ins](../../install-tanzu-cli.hbs.md#cli-and-plugin).
- Install the Apps plug-in. See the [Install Apps plug-in](tutorials.hbs.md#install).
- [Set up developer namespaces to use installed packages](../../set-up-namespaces.hbs.md).
- For more information about the values you can provide when creating and managing the life cycle of
  workloads, see [Workload and Supply Chain Custom Resources](https://cartographer.sh/docs/v0.6.0/reference/workload/)
  in the Cartographer documentation. Alternatively, run `kubectl explain workload.spec` for the Kubernetes
  version running on the target cluster.

## <a id="example"></a> Get started with an example workload

You can create a workload from a GitHub repository or local source.

### <a id="workload-git"></a> Create a workload from GitHub repository

Use the flags `--git-repo`, `--git-branch`, `--git-tag`, and `--git-commit` flags to create a
workload from an existing Git repository. This allows the
[supply chain](../../scc/about.hbs.md) to get the source from the given repository to deploy the
application.

To create a named workload and specify a Git source code location, run:

 ```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-1.4.0 --type web
```

Respond `Y` to prompts to complete process.

Where:

- `tanzu-java-web-app` is the name of the workload.
- `--git-repo` is the location of the code to build the workload from.
- `--sub-path` is the relative path inside the repository to treat as application root.
- `--git-tag` (optional) specifies which tag in the repository to pull the code from.
- `--git-branch` (optional) specifies which branch in the repository to pull the code from.
- `--type` distinguishes the workload type.

View the full list of supported workload configuration options
by running `tanzu apps workload apply --help`.

### <a id="workload-local-source"></a> Create a workload from local source code

Use the `--local-path` and `--source-image` flags to create a workload from an existing local project.
This allows the [supplychain](../../scc/about.hbs.md) to generate an image ([carvel-imgpkg](https://carvel.dev/imgpkg/))
and push it to the given registry to be used in the workload.

To create a named workload and specify where the local source code is, run:

```console
tanzu apps workload create pet-clinic --local-path /path/to/my/project --source-image springio/petclinic
```

Respond `Y` to the dialog box about publishing local source code if the image must be updated.

Where:

- `pet-clinic` is the name of the workload.
- `--local-path` points to the directory where the source code is located.
- `--source-image` is the registry path where the local source code is uploaded as an image.

#### Exclude Files

When working with local source code, you can exclude files from the source code to be uploaded
within the image by creating a `.tanzuignore` file at the root of the source code.

The file must contain a list of file paths to exclude from the image including the file itself
and the directories must not end with the system path separator (`/` or `\`).

For more information regarding the `.tanzuignore` file
see [tanzuignorefile](how-to-guides.hbs.md#tanzuignore-file).

### <a id="workload-image"></a> Create workload from an existing image

Create a workload from an existing registry image by providing
the reference to that image through the `--image` flag. The [supplychain](../../scc/about.hbs.md)
references the provided registry image when the workload is deployed.

For example:

```console
tanzu apps workload create petclinic-image --image springcommunity/spring-framework-petclinic
```

Respond `Y` to prompts to complete process.

 Where:

- `petclinic-image` is the name of the workload.
- `--image` is an existing image, pulled from a registry, that contains the source that the workload
  is going to use to create the application.

### <a id="workload-maven"></a> Create a workload from Maven repository artifact

Create a workload from a Maven repository
artifact ([Source-Controller](../../source-controller/about.hbs.md)) by setting some
specific properties as YAML parameters in the workload when using the [supply chain](../../scc/about.hbs.md).

The Maven repository URL is set when the supply chain is created.

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

For example, to create a workload from a Maven artifact, run:

```console
# YAML
tanzu apps workload create petclinic-image --param-yaml maven=$"artifactId:hello-world\ntype: jar\nversion: 0.0.1\ngroupId: carto.run"

# JSON
tanzu apps workload create petclinic-image --param-yaml maven="{"artifactId":"hello-world", "type": "jar", "version": "0.0.1", "groupId": "carto.run"}"
```

## <a id='yaml-files'></a> Working with YAML files

In many cases, workload life cycles are managed through CLI commands. However, there might be cases
where managing the workload through direct interactions and edits of a `yaml` file is preferred. The
Apps CLI plug-in supports using `yaml` files to meet the requirements.

When a workload is managed using a `yaml` file, that file **must contain a single workload definition**.

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
        tag: tap-1.4.0
    subPath: tanzu-java-web-app
```

To create a workload from a file like the earlier example:

```console
tanzu apps workload create --file my-workload-file.yaml
```

>**Note** When flags are passed in combination with `--file my-workload-file.yaml` the flag values take precedence over the associated property or values in the YAML.

The workload YAML definition can also be passed in through stdin as follows:

```console
tanzu apps workload create --file - --yes
```

The console waits for input, and the content with valid `yaml` definitions for a workload can either
be written or pasted. Then click **Ctrl-D** three times to start the workload creation. This can
also be done with the `workload apply` command.

**Note** To pass a workload through `stdin`, the `--yes` flag is required. If not provided, the
command fails.

Another way to pass a workload with the `--file` flag is using a URL, which, as mentioned before,
must contain a raw file with the workload definition.

For example:

```console
tanzu apps workload apply --file https://raw.githubusercontent.com/vmware-tanzu/apps-cli-plugin/main/pkg/commands/testdata/workload.yaml
```

## <a id="bind-service"></a> Bind a service to a workload

Tanzu Application Platform supports creating a workload with binding to multiple
services ([ServiceBinding](../../service-bindings/about.hbs.md)).
The cluster supply chain is in charge of provisioning those services.

The purpose of these bindings is to provide information from a service resource to an application.

- To bind a database service to a workload, run:

    ```console
    tanzu apps workload apply pet-clinic --service-ref "database=services.tanzu.vmware.com/v1alpha1:MySQL:my-prod-db"
    ```

    Where:

  - `pet-clinic` is the name of the workload to be updated.
  - `--service-ref` references the service using the format {service-ref-name}={apiVersion}:{kind}:{service-binding-name}.

For more information about how to bind a service to a workload, see [Consume services on Tanzu Application Platform](../../getting-started/consume-services.hbs.md).
## <a id="next-steps"></a> Next steps

You can verify workload details and status, add environment variables, export definitions or bind services.

1. To verify a workload status and details, use `tanzu apps workload get`.

   To get workload logs, use `tanzu apps workload tail`.

   For more information, see [debug workload section](debug-workload.hbs.md).

2. To add environment variables, run:

    ```console
    tanzu apps workload apply pet-clinic --env foo=bar
    ```

3. To export the workload definition into Git, or to migrate to another environment, run:

    ```console
    tanzu apps workload get pet-clinic --export
    ```

4. To bind a service to a workload, see the [--service-ref flag](command-reference/workload_create_update_apply.hbs.md#service-ref).

5. To see flags available for the workload commands, run:

    ```console
    tanzu apps workload -h
    tanzu apps workload get -h
    tanzu apps workload create -h
    ```
