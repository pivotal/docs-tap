# Using functions (Beta)

This topic describes how to create and deploy an HTTP or CloudEvent function from an application accelerator starter template.

## <a id="overview"></a> Overview

The function experience on Tanzu Application Platform enables developers to deploy functions, use starter templates to bootstrap their function and write only the code that matters to your business. Developers can run a single CLI command to deploy their functions to an auto-scaled cluster.

Functions provide a quick way to get started writing an application. Compared with a traditional application:

* Functions have a single entry-point and perform a single task. This means that functions can be easier to understand and monitor.

* The webserver is managed by the function buildpack. This means that you can focus on your code/business logic.

* A traditional webserver application might be a better fit if you want to implement an entire website or API in a single container

> **Important:** Beta features have been tested for functionality, but not performance.
> Features enter the beta stage so that customers can gain early access, and give
> feedback on the design and behavior.
> Beta features might undergo changes based on this feedback before the end of the beta stage.
> VMware discourages running beta features in production.
> VMware cannot guarantee that you can upgrade any beta feature in the future.

## <a id="supportedlangs"></a> Supported languages and framework

| **Language/framework** | **HTTP** | **CloudEvents** |
|------------------------|----------|-----------------|
| Java                   |     &check;     |     &check;            |
| Python                 |     &check;     |          &check;       |
| Node                   |    &check;      | N/A             |

## <a id="prereqs"></a> Prerequisites

Before using function workloads on Tanzu Application Platform, complete the following prerequisites:

* Follow all instructions in [Installing Tanzu Application Platform](../install-intro.md).

* Follow all instructions in [Set up developer namespaces to use installed packages](../set-up-namespaces.md).


## <a id="create-function-proj-acc"></a> Create a function project from an accelerator

1. From the Tanzu Application Platform GUI portal, click **Create** on the left navigation bar to see the list of available accelerators.

![Application-Accelerators-Accelerators-VMware-Tanzu-Application-Platform (2)](https://user-images.githubusercontent.com/36433204/194068385-3ad8b1fe-3c51-422e-bc72-27105d11a275.png)

1. Locate the function accelerator in the language/framework of your choice and click **CHOOSE**.
1. Provide a name for your function project and function. Provide a Git repository to store this accelerator's files. Click **NEXT STEP**, verify the provided information, and click **CREATE**.

    ![Screenshot of the Generate Accelerators page in Tanzu Application Platform GUI. It shows a Python function buildpacks accelerator with App accelerator input fields including Name, Default function name, Event type, Git repository URL, and Git repository branch.](images/generate-accelerators.png)
   
Note: If creating a Java function, select a project type*.

1. After the Task Activity processes complete, click **DOWNLOAD ZIP FILE**.

1. After downloading the ZIP file, expand it in a workspace directory and follow your preferred procedure for uploading the generated project files to a Git repository for your new project.

## <a id="create-function-proj-cli"></a> Create a function project using the Tanzu CLI

From the CLI, you can generate a function project using an accelerator template,
then download the project artifacts as a ZIP file.

1. Validate that you have added the function accelerator template to the application accelerator server by running:

     ```console
    tanzu accelerator list
    ```

1. Get the `server-url` for the Application Accelerator server.
The URL depends on the configuration settings for Application Accelerator:

    - For installations configured with a shared ingress, use `https://accelerator.DOMAIN`
    where `DOMAIN` is provided in the values file for the accelerator configuration.

    - For installations using a LoadBalancer, look up the External IP address by running:

         ```console
        kubectl get -n accelerator-system service/acc-server
        ```

        Use `http://EXTERNAL-IP` as the URL.


    - For any other configuration, you can use port forwarding by running:

        ```console
        kubectl port-forward service/acc-server -n accelerator-system 8877:80
        ```

        Use `http://localhost:8877` as the URL.

1. Generate a function project from an accelerator template by running:

    ```console
    tanzu accelerator generate ACCELERATOR-NAME \
    --options '{"projectName": "FUNCTION-NAME", "interfaceType": "TYPE"}' \
    --server-url APPLICATION-ACCELERATOR-URL
    ```

    Where:

    - `ACCELERATOR-NAME` is the name of the function accelerator template you want to use.
    - `FUNCTION-NAME` is the name of your function project.
    - `TYPE` is the interface you want to use for your function. Available options are `http` or `cloudevents`. CloudEvents is experimental.
    - `APPLICATION-ACCELERATOR-URL` is the URL for the Application Accelerator
    server that you retrieved in the previous step.

    For example:

    ```console
    tanzu accelerator generate java-function \
    --options '{"projectName": "my-func", "interfaceType": "http"}' \
    --server-url http://localhost:8877
    ```

1. After generating the ZIP file, expand it in your directory and follow your
preferred procedure for uploading the generated project files to a Git repository for your new project.

## <a id="deploy-function"></a> Deploy your function

1. Deploy the function accelerator by running the `tanzu apps workload` create command:

    ```console
    tanzu apps workload create functions-accelerator-python \
    --local-path . \
    --source-image REGISTRY/IMAGE:TAG \
    --type web \
    --yes
    --namespace YOUR-DEVELOPER-NAMESPACE
    ```

    Where:

    - `--source-image` is a writable repository in your registry.

    Harbor has the form: "my-harbor.io/my-project/functions-accelerator-python".

    Docker Hub has the form: "my-dockerhub-user/functions-accelerator-python".

    Google Cloud Registry has the form: "gcr.io/my-project/functions-accelerator-python".
    
    - Where YOUR-DEVELOPER-NAMESPACE is the namespace configured earlier.

1. View the build and runtime logs for your application by running the tail command:

    ```console
    tanzu apps workload tail functions-accelerator-python --since 10m --timestamp --namespace YOUR-DEVELOPER-NAMESPACE
    ```

1. After the workload is built and running, you can view the web application in your browser. To view the URL of the web application, run the following command and then ctrl-click the Workload Knative Services URL at the bottom of the command output.

    ```console
    tanzu apps workload get functions-accelerator-python --namespace YOUR-DEVELOPER-NAMESPACE
    ```
    
   For other methods, you must use more advanced REST API testing utilities, such cURL. The cURL command examples below assume that cURL is installed on your computer.
   
| **Language/framework** | **GET** | **POST** |
|------------------------|---------|----------|
| Java                   |        N/A     |     &check;     |
| Python                 |     &check;    |    &check;      |
| Node                   |     &check;    |     &check;     |

 
 
 Java Function POST example 
 ```console
 curl -w'\n' URL_FROM_YOUR_WORKLOAD_KNATIVE_SERVICES_SECTION \
 -H "Content-Type: application/json" \
 -d '{"firstName":"John", "lastName":"Doe"}'
  ```
