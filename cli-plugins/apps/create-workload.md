# Create a workload

This document describes how to create a workload from example source code with Tanzu Application Platform.

## <a id='prerequisites'></a> Prerequisites

The following prerequisites are required to use workloads with Tanzu Application Platform:

- Install Kubernetes command line tool (kubectl). For information about installing kubectl, see [Install Tools](https://kubernetes.io/docs/tasks/tools/) in the Kubernetes documentation.
- Install Tanzu Application Platform components on a Kubernetes cluster. See [Installing Tanzu Application Platform](../../install-intro.md).
- Set your kubeconfig context to the prepared cluster `kubectl config use-context CONTEXT_NAME`.
- Install Tanzu CLI. See [Install or update the Tanzu CLI and plug-ins](../../install-tanzu-cli.md#cli-and-plugin).
- Install the apps plug-in. See the [Install Apps plug-in](install-apps-cli.md).
- [Set up developer namespaces to use installed packages](../../install-components.md#setup).

## <a id="example"></a> Get started with an example workload

Here is how you can get started with an example workload.

- To name the workload and specify a source code location to create the workload from, run:

    ```
    tanzu apps workload create pet-clinic --git-repo https://github.com/spring-projects/spring-petclinic --git-branch main --type web  
    ```

    Respond `Y` to prompts to complete process.

    Where:

    - `pet-clinic` is the name of the workload.
    - `--git-repo` is the location of the code to build the workload from.
    - `--git-branch` (optional) specifies which branch in the repository to pull the code from.
    - `--type` is used to distinguish the workload type.

    You can find the options available for specifying the workload in the command reference for [`workload create`](command-reference/tanzu_apps_workload_create.md), or you can run `tanzu apps workload create --help`.


## <a id="check-build-logs"></a> Check build logs

Once the workload is created, you can tail the workload to view the build and runtime logs.

- Check logs by running:

    ```
    tanzu apps workload tail pet-clinic --since 10m --timestamp
    ```

    Where:
    
    - `pet-clinic` is the name you gave the workload.
    - `--since` (optional) the amount of time to go back to begin streaming logs. The default is 1 second.
    - `--timestamp` (optional) prints the timestamp with each log line.

## <a id="workload-status"></a> Get the workload status and details

After the workload build process is complete, create a Knative service to run the workload.
You can view workload details at anytime in the process. Some details, such as the workload URL, are only available after the workload is running.

1. To check the workload details, run:

    ```
    tanzu apps workload get pet-clinic
    ```

    Where:

    - `pet-clinic` is the name of the workload you want details about.

2. You can now see the running workload. When the workload is created, `tanzu apps workload get` includes the URL for the running workload. Some terminals allow you to `ctrl`+click the URL to view it. You can also copy and paste the URL into your web browser to see the workload.

## <a id="workload-local-source"></a> Create a workload from local source code

You can create a workload using code from a local folder.

- Inside the folder that contains the source code, run:

    ```
    tanzu apps workload create pet-clinic --local-path . --source-image springio/petclinic
    ```

    Respond `Y` to the prompt about publishing local source code if the image needs to be updated.

    Where:

    - `pet-clinic` is the name of the workload.
    - `--local-path` points to the directory where the source code is located.
    - `--source-image` is the registry path for the local source code.

## <a id="bind-service"></a> Bind a service to a workload

Multiple services can be configured for each workload. The cluster supply chain is in charge of provisioning those services.

- To bind a database service to a workload, run:

    ```
    tanzu apps workload update pet-clinic --service-ref "database=services.tanzu.vmware.com/v1alpha1:MySQL:my-prod-db"
    ```

    Where:

    - `pet-clinic` is the name of the workload to be updated.
    - `--service-ref` references the service using the format {name}={apiVersion}:{kind}:{name}. For more details, refer to [update command](command-reference/tanzu_apps_workload_update.md#update-options).

## <a id="next-steps"></a> Next steps

You can add environment variables, export definitions, and use flags with these [commands](command-reference.md). The following procedure includes example environment variables and flags.

1. To add environment variables, run:

    ```
    tanzu apps workload update pet-clinic --env foo=bar
    ```

2. To export the workload definition into git, or to migrate to another environment, run:

    ```
    tanzu apps workload get pet-clinic --export
    ```

3. To see flags available for the workload commands, run:

    ```
    tanzu apps workload -h
    tanzu apps workload get -h
    tanzu apps workload create -h
    ```
