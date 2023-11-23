# Secure a Spring Boot workload

This tutorial tells you how to secure a sample Spring Boot `Workload` with
Application Single Sign-On (commonly called AppSSO),
which runs on Tanzu Application Platform (commonly called TAP).

Follow these steps to deploy a sample Spring Boot `Workload`:

1. [Get the sample application](#sample-app).
1. [Create a namespace for workloads](#create-namespace).
1. [Claim client credentials](#credentials).
1. (Optional) [Ensure `Workload` trusts `AuthServer`](#trust-authserver).
1. [Deploy the workload](#deploy-workload).

## <a id='sample-app'></a> Get the sample application

Follow these steps to fetch the Application Single Sign-On Spring Boot application source code:

1. Download the Application Single Sign-On Starter Java accelerator from the Tanzu Developer Portal
   (formerly named Tanzu Application Platform GUI) accelerators located on your
   Tanzu Application Platform cluster:

    - Option 1: Use the Tanzu Developer Portal dashboard through the browser.

        Navigate to Application Accelerators and download the "AppSSO Starter Java" accelerator.

    - Option 2: Use the Tanzu Accelerator CLI.

        Download the zip file of the accelerator source code by running:

        ```shell
        tanzu accelerator generate appsso-starter-java --server-url TAP_GUI_SERVER_URL
        ```

2. Unzip the resulting `.zip` file into the `appsso-starter-java` directory in your workspace.

    ```shell
    unzip appsso-starter-java
    ```

3. With the resulting project, create an accessible remote Git repository and push your accelerator to the Git remote repository.

## <a id='create-namespace'></a> Create a namespace for workloads

You must create a namespace for your workloads for the `Workload` resources to function properly.
If you have a workloads namespace already, you can skip this step.

```shell
kubectl create namespace my-apps
kubectl label namespaces my-apps apps.tanzu.vmware.com/tap-ns=""
```

For more information about provisioning namespaces for workloads, see [Set up developer namespaces](../../../install-online/set-up-namespaces.hbs.md).

## <a id='credentials'></a> Claim client credentials

Follow these steps to claim credentials for an Application Single Sign-On service so that you can secure your workload:

1. Discover the available Application Single Sign-On services with the Tanzu Service CLI:

  ```console
  $ tanzu service class list
    NAME      DESCRIPTION
    sso       Login by AppSSO
  ```

    The actual names of your AppSSO services might be different. VMware
    assumes that there's one AppSSO service with the name `sso`.

1. Claim credentials for that service by creating a `ClassClaim` named
`appsso-starter-java` in the `my-apps` namespace.

    ```yaml
    ---
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ClassClaim
    metadata:
      name: appsso-starter-java
      namespace: my-apps
    spec:
      classRef:
        name: sso
      parameters:
        workloadRef:
          name: appsso-starter-java
        redirectPaths:
          - /login/oauth2/code/appsso-starter-java
        scopes:
          - name: openid
        authorizationGrantTypes:
          - authorization_code
        clientAuthenticationMethod: client_secret_basic
    ```

1. Apply the `ClassClaim` and verify its status by running:

    ```shell
    kubectl get classclaim appsso-starter-java --namespace my-apps
    ```

## <a id="trust-authserver"></a> Ensure `Workload` trusts `AuthServer`

For Tanzu Application Platform cluster with a custom or self-signed CA certificate,
see [Configure workloads to trust a custom Certificate Authority (CA)](../service-operators/workload-trust-custom-ca.hbs.md).

## <a id="deploy-workload"></a> Deploy the `Workload`

Follow these steps to deploy the `Workload`:

1. Create the Spring Boot accelerator `Workload` by running:

    ```shell
    tanzu apps workload create appsso-starter-java \
        --namespace my-apps \
        --type web \
        --label app.kubernetes.io/part-of=appsso-starter-java \
        --build-env "BP_JVM_VERSION=17" \
        --service-ref "appsso-starter-java=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:appsso-starter-java" \
        --service-ref "ca-cert=v1:Secret:tap-ca-cert" \
        --git-repo "<GIT_LOCATION_OF_YOUR_ACCELERATOR>" \
        --git-branch main \
        --live-update
    ```

    > **Important** Although you can assign any name to the `ClassClaim`, the `Workload`'s service reference name must match the `ClassClaim`'s name.
    >
    > ```console
    > --service-ref "**appsso-starter-java**=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:appsso-starter-java"
    > ```
    >
    > If the service reference name does not match the `ClassClaim` name,
    > the `Workload` generates a redirect URI that the authorization server will reject.

    It might take a few minutes for the workload to become available through a browser-accessible URL.

1. Query the latest status of the workload by running:

    ```shell
    tanzu apps workload get appsso-starter-java --namespace my-apps
    ```

1. Monitor the `Workload` logs:

    ```shell
    tanzu apps workload tail appsso-starter-java --namespace my-apps
    ```

    After the status of the workload reaches the `Ready` state,
    you can navigate to the provided URL, which looks similar to:

    ```text
    https://appsso-starter-java.my-apps.<TAP_CLUSTER_DOMAIN_NAME>
    ```

1. Open your preferred web browser and navigate to the URL.

    Expect to see a large log-in button tailored for authenticating with AppSSO.

## <a id="clean-up"></a> Cleaning up

Delete the running application by running the following commands:

1. Delete the sample application `Workload`:

    ```shell
    tanzu apps workload delete appsso-starter-java --namespace my-apps
    ```

1. Delete the claim:

    ```shell
    tanzu service class-claims delete appsso-starter-java --namespace my-apps
    ```
