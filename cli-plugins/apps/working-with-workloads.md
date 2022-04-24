# Working with workloads

## <a id='Creating'></a> Create a workload 

This document describes how to create a workload from example source code with the Tanzu Application Platform.

### <a id='prereqs'></a> Before you begin

The following prerequisites are required to use workloads with Tanzu Application Service:

+ Kubectl is installed. For information about installing kubectl, see [Install Tools](https://kubernetes.io/docs/tasks/tools/) in the Kubernetes documentation.
+ Tanzu Application Platform components are installed on a Kubernetes cluster. See [Installing Tanzu Application Platform](../../install-intro.md). 
+ Your kubeconfig context is set to the prepared cluster `kubectl config use-context CONTEXT_NAME`.
+ Tanzu CLI is installed. See [Install the Tanzu CLI](../../install-general.md#cli-and-plugin).  
  + The apps plugin is installed. See the [Apps Plugin Overview](overview-installation.md#Installation).

### Getting started with an example workload

Use the following procedure to get started with an example workload.

1. Name the workload and specify a source code location to create the workload from. Run:

    ```sh
    tanzu apps workload create pet-clinic --git-repo https://github.com/spring-projects/spring-petclinic --git-branch main --type web  
    ```

    Respond `Y` to prompts to complete process.

    Where:

     + `pet-clinic` is the name that will be given to the workload.
     + `--git-repo` is the location of the code to build the workload from.
     + `--git-branch` (optional) specifies which branch in the repo to pull the code from.
     + `--type` is used to distinguish the workload type.

    The options available for specifying the workload are found in the command reference for [`workload create`](command-reference/tanzu_apps_workload_create.md) or by running `tanzu apps workload create --help`.


### <a id='workload-tail'></a> Check build logs

Once the workload is created, you can tail the workload to view the build and runtime logs.

1. Check logs by running:

    ```sh
    tanzu apps workload tail pet-clinic --since 10m --timestamp
    ```

    Where:

     + `pet-clinic` is the name you gave the workload.
     + `--since` (optional) is how long ago to start streaming logs from. The default is 1 second.
     + `--timestamp` (optional) prints the timestamp with each log line.

### <a id='workload-get'></a> Get the workload status and details

Once the workload build process is completed, create a knative service to run the workload.
You can view workload details at anytime in the process. Some details, such as the workload URL, are only available once the workload is running.

1. Check the workload details by running:

    ```sh
    tanzu apps workload get pet-clinic
    ```

    Where:

     + `pet-clinic` is the name of the workload you would like details from.

2. See the running workload.
When the workload is created, `tanzu apps workload get` includes the URL for the running workload.
Depending on your terminal, you may be able to `ctrl`+click the URL to view. You can also copy and paste the URL into your web browser to see the workload.

### <a id='workload-local-source'></a> Create a workload from local source

You can create a workload using code from a local folder.

1. Inside the folder that contains the source code, run the following:

    ```sh
    tanzu apps workload create pet-clinic --local-path . --source-image springio/petclinic
    ```

    Respond `Y` to the prompt about publishing local source if the image needs to be updated.

    Where:

    + `pet-clinic` is the name that will be given to the workload.
    + `--local-path` is pointing to the folder where the source code is located.
    + `--source-image` is the registry path for the local source code.

## <a id='service-binding'></a> Bind a service to a workload

Multiple services can be configured for each workload. The cluster supply chain is in charge of provisioning those services.

1. Bind a database service to a workload by running:

    ```sh
    tanzu apps workload update pet-clinic --service-ref "database=services.tanzu.vmware.com/v1alpha1:MySQL:my-prod-db"
    ```

    Where:

    + `pet-clinic` is the name of the workload to be updated.
    + `--service-ref` is the reference to the service using the format {name}={apiVersion}:{kind}:{name}. For more details, refer to [update command](command-reference/tanzu_apps_workload_update.md#update-options).

## <a id='next-steps'></a> Next steps

You can add environment variables, export definitions, and use flags with these [commands](command-reference.md). The following procedure includes example environment variables and flags.

1. Add environment variables by running:

    ```sh
    tanzu apps workload update pet-clinic --env foo=bar
    ```

2. Export the workload definition to check into git, or migrate to another environment by running:

    ```sh
    tanzu apps workload get pet-clinic --export
    ```

3. Check out the flags available for the workload commands by running:

    ```sh
    tanzu apps workload -h
    tanzu apps workload get -h
    tanzu apps workload create -h
    ```
