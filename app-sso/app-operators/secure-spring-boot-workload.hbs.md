# Secure a Spring Boot workload

This topic describes the procedure to secure a sample Spring Boot `Workload` with AppSSO, which runs on Tanzu Application Platform (TAP).

Follow these steps to deploy a sample Spring Boot `Workload`:

1. [Get the sample application](#sample-app).
1. [Create a namespace for workloads](#create-namespace).
1. [Apply a client registration](#clientregistration).
1. [Create a resource claim for the workload](#resource-claim).
1. (Optional) [Ensure `Workload` trusts `AuthServer`](#trust-authserver).
1. [Deploy the workload](#deploy-workload).

## <a id='sample-app'></a> Get the sample application

Follow these steps to fetch the AppSSO Spring Boot application source code:

1. Download the AppSSO Starter Java accelerator from the TAP GUI accelerators located on your TAP cluster:

    - Option 1: Use the TAP GUI dashboard through browser.

        Navigate to Application Accelerators and download the "AppSSO Starter Java" accelerator.

    - Option 2: Use the Tanzu Accelerator CLI.

        Download the zip file of the accelerator source code by running:

        ```shell
        tanzu accelerator generate appsso-starter-java --server-url <TAP_GUI_SERVER_URL>
        ```

1. Unzip the resulting `.zip` file into directory `appsso-starter-java` in your workspace.

    ```shell
    unzip appsso-starter-java
    ```

1. With the resulting project, create an accessible remote Git repository and push your accelerator to the Git remote repository.

## <a id='create-namespace'></a> Create a namespace for workloads

You must create a namespace for your workloads for the `Workload` resources to function properly.
If you have a workloads namespace already, you can skip this step.

```shell
kubectl create namespace my-apps
kubectl label namespaces my-apps apps.tanzu.vmware.com/tap-ns=""
```

For more information about provisioning namespaces for workloads, see [Set up developer namespaces](../../install-online/set-up-namespaces.hbs.md).

## <a id='clientregistration'></a> Create a `ClientRegistration`

**Example:** A `ClientRegistration` named `appsso-starter-java` in the `my-apps` namespace.
`appsso-starter-java` is attached to an existing `AuthServer` with labels `my-sso=true,env=dev`
and an allowance of client registrations from the `my-apps` namespace.

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: appsso-starter-java
  namespace: my-apps
spec:
  authServerSelector:
    matchLabels:
      my-sso: "true"
      env: dev
  clientAuthenticationMethod: client_secret_basic
  authorizationGrantTypes:
  - authorization_code
  redirectURIs:
  - https://appsso-starter-java.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/login/oauth2/code/appsso-starter-java
  - http://appsso-starter-java.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/login/oauth2/code/appsso-starter-java
  scopes:
  - name: openid
```

> **Note** You can choose `redirectURIs` that use http or https based on your need.
> The prefix of the `redirectURIs` denotes the name and namespace of the `Workload`.
> In this case, it is `appsso-starter-java` and `my-apps`.
> Keep the suffix formatted as `/login/oauth2/code/{ClientRegistration.metadata.name}`.
> For more information about the redirect URI format of Spring Security OAuth 2 Client library,
> see [Workloads and AppSSO](./workloads-and-appsso.hbs.md#redirect-uris).

The accelerator is pre-packaged with a ytt-templated `ClientRegistration` that is located in `client.yaml`.
You can generate the same `ClientRegistration` as earlier with your specific values by running:

```shell
ytt \
  --file client.yaml \
  --data-value namespace=my-apps \
  --data-value workload_name=appsso-starter-java \
  --data-value domain=<TAP_CLUSTER_DOMAIN_NAME> \
  --data-value authserver_label.my-sso=true \
  --data-value authserver_label.env=dev
```

Where:

- `namespace` is the namespace where the workload runs.
- `workload_name` is the distinct instance name of the deployed accelerator.
- `domain` is the domain name where the workload is deployed. The workload instance uses a subdomain to
  distinguish itself from other workloads. When working within a local cluster,
  you can use `127.0.0.1.nip.io` to establish a functional DNS route.
- `authserver_label.{matching-label}` is the uniquely identifying label (one or more) for your `AuthServer`.
  In this example, the `AuthServer` resource is assumed to have labels `my-sso: "true"` and `env: dev`.
  You can add as many identifying labels as needed.

You can apply the `ClientRegistration` and verify its status by running:

```shell
kubectl get clientregistration appsso-starter-java --namespace my-apps
```

## <a id="resource-claim"></a> Claim the `ClientRegistration`

Follow these steps to claim the `ClientRegistration`:

1. Create a service resource claim for the `ClientRegistration` created earlier
by using the Tanzu Services plugin CLI:

    ```shell
    tanzu service resource-claim create appsso-starter-java \
        --namespace my-apps \
        --resource-namespace my-apps \
        --resource-name appsso-starter-java \
        --resource-kind ClientRegistration \
        --resource-api-version "sso.apps.tanzu.vmware.com/v1alpha1"
    ```

1. Check the status of the claim by running:

    ```shell
    tanzu service claim list --namespace my-apps
    ```

    Expect to see the `appsso-starter-java` claim with the `Ready` status as `True`.

## <a id="trust-authserver"></a> Ensure `Workload` trusts `AuthServer`

For TAP cluster with a custom or self-signed CA certificate,
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
        --service-ref "appsso-starter-java=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:appsso-starter-java" \
        --service-ref "ca-cert=v1:Secret:tap-ca-cert" \
        --git-repo "<GIT_LOCATION_OF_YOUR_ACCELERATOR>" \
        --git-branch main \
        --live-update
    ```

    > **Important** Although you can assign any name to the `ResourceClaim`, the `Workload`'s service reference name
    > must match the `ClientRegistration` name.
    >
    > ```console
    > --service-ref "**appsso-starter-java**=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:appsso-starter-java"
    > ```
    >
    > If the service reference name does not match the `ClientRegistration` name,
    > the `Workload` generates a redirect URI that the `AuthServer` will not accept.

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

1. Delete the service resource claim for the `ClientRegistration`:

    ```shell
    tanzu service resource-claim delete appsso-starter-java --namespace my-apps
    ```

1. Disconnect the client from AppSSO:

    ```shell
    kubectl delete clientregistration appsso-starter-java --namespace my-apps
    ```
