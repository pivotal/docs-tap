# <a id='Creating'></a> Creating a workload 

This document describes how to create a workload from example source code with the Tanzu Application Platform.

## <a id='prereqs'></a>Before you begin

+ Kubectl has been installed [guide](https://kubernetes.io/docs/tasks/tools/)
+ TAP components have been installed on a k8s cluster [guide](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.1/tap-0-1/GUID-install.html)
+ Your kubeconfig context has been set to the prepared cluster `kubectl config use-context CONTEXT_NAME`
+ You have the Tanzu CLI installed [guide](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.1/tap-0-1/GUID-install.html#install-the-tanzu-cli-and-package-plugin-4), with the apps plugin [guide]()

## <a id='create-workload'></a> About workloads

The Tanzu Application Platform beta includes tools that enable developers to quickly begin building and testing applications regardless of their familiarity with Kubernetes. Developers can turn source code into a workload running in a container with a URL in minutes. 

The platform can support range of possible workloads, from a stand-alone serverless process that spins up on demand, to one of a constellation of microservice that work together as a logical application or even a small hello-world test app.

The options available for specifying the workload are available in the command reference for [`workload create`](tanzu_apps_workload_create.md) or by running `tanzu apps workload create --help` 

## Getting started with an example workload

Start by naming the workload and specifying a source code location for the workload to be created from.

1. Run: 

    ```sh
    tanzu apps workload create pet-clinic --git-repo https://github.com/spring-projects/spring-petclinic --git-branch main --type web  
    ```
    Respond `Y` to prompts to complete process
    
     Where:

     + `pet-clinic` is the name you would like to give the workload
     + `--git-repo` is the location of the code to build the workload from
     + `--git-branch` (optional) specifies which branch in the repo to pull the code from
     + `--type` is used to distinguish the workload type
     


## <a id='workload-tail'></a> Check the build logs

Once the workload has been successfully created, you can tail the workload to view the build and runtime logs:

1. Check logs by running:
    
    ```sh
    tanzu apps workload tail pet-clinic --since 10m --timestamps
    ```
    
    Where:

     + `pet-clinic` is the name you gave the workload
     + `--since` (optional) is how long ago to start streaming logs from (default 1s)
     + `--timestamp` (optional) prints the timestamp with each log line

## <a id='workload-get'></a> Get the workload status and details

Once the workload build process has completed, a knative service will be created to run the workload.
You can view workload details at anytime in the process but some details such as the workload URL will only be available once the workload is running:

1. Check the workload details by running:
    
    ```sh
    tanzu apps workload get pet-clinic
    ```
    
    Where:

     + `pet-clinic` is the name of the workload you would like details from

2. See the running workload
When the workload has been created, `tanzu apps workload get` will include the URL for the running workload.
Depending on the terminal you use you may be able to <ctrl>+click on the URL to view. If that doesn't work you can copy-paste the URL into your web browser to see the workload.
    
## <a id='next-steps'></a> Next Steps

Keep exploring:

1. Add some environment variables

    ```sh
    tanzu apps workload update pet-clinic --env foo=bar
    ```

2. Export the workload definition (to check into git, or migrate to another environment)
    ```
    tanzu apps workload get pet-clinic --export
    ```

 3. Check out the flags available for the workload commands   
    ```
    tanzu apps workload -h
    tanzu apps workload get -h
    tanzu apps workload create -h
    ```
