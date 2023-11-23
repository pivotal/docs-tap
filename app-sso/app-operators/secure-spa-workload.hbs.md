# Secure a single-page app workload

This topic tells you how to to secure a sample single-page Angular app `Workload` 
with Application Single Sign-On (commonly called AppSSO), which runs on 
Tanzu Application Platform (commonly known as TAP).

Follow these steps to deploy a sample single-page app `Workload`:

1. [Get the sample application](#sample-app).
1. [Create a namespace for workloads](#create-namespace).
1. [Apply a client registration](#clientregistration).
1. [Verify application authentication settings](#auth-settings).
1. [Start a sample back end](#backend).
1. [Deploy the Workload](#deploy-workload).

## <a id='sample-app'></a> Get the sample application

Follow these steps to fetch the single-page Angular app source code:

1. Download the Angular Frontend accelerator from the Tanzu Application Platform GUI accelerators located on your Tanzu Application Platform cluster:

    - Option 1: Use the Tanzu Application Platform GUI dashboard by using a browser.

        Navigate to Application Accelerators and choose the **Angular Frontend** accelerator and then select the **Single Sign-on** option.

    - Option 2: Use the Tanzu Accelerator CLI.

        Download the zip file of the accelerator source code and identify your `AuthServer` Issuer URI by running:

        ```shell
        kubectl get authserver -A
        ```

        Generate the accelerator by using the `tanzu accelerator` CLI:

        ```shell
        tanzu accelerator generate angular-frontend \
          --server-url TAP-GUI-SERVER-URL \
          --options '{
            "useSingleSignOn": true,
            "authority": "AUTHSERVER-ISSUER-URI",
            "namespace": "my-apps",
            "authorityLabelKey": "my-sso",
            "authorityLabelValue": "true"
          }'
        ```

1. Unzip the resulting `.zip` file into directory `angular-frontend` in your workspace:

    ```shell
    unzip angular-frontend
    cd angular-frontend
    git init
    git branch -M main
    git remote add origin YOUR-ACCELERATOR-GIT-REPOSITORY
    git push origin main -u
    ```

    For public clients, the `AuthServer` only supports the Authorization Code Flow: `response_type=code`,  because public clients such as single page apps cannot safely store sensitive information such as client secrets.

1. Push the resulting directory to the remote Git repository.

## <a id='create-namespace'></a> Create a namespace for workloads

You must create a namespace for your workloads for the `Workload` resources to function properly.
If you have a workloads namespace already, you can skip this step.

```shell
kubectl create namespace my-apps
kubectl label namespaces my-apps apps.tanzu.vmware.com/tap-ns=""
```

For more information about provisioning namespaces for running `Workloads`,
see [Set up developer namespaces](../../install-online/set-up-namespaces.hbs.md).

## <a id='clientregistration'></a> Create a `ClientRegistration`

You must create a `ClientRegistration` to register the frontend application with the `AuthServer`.

**Example:** A `ClientRegistration` named `angular-frontend` in the `my-apps` namespace.
`angular-frontend` is attached to an existing `AuthServer` with labels `my-sso=true` and an
allowance of client registrations from the `my-apps` namespace.

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: angular-frontend
  namespace: my-apps
spec:
  authServerSelector:
    matchLabels:
      my-sso: "true"
  clientAuthenticationMethod: none
  authorizationGrantTypes:
  - authorization_code
  redirectURIs:
  - https://angular-frontend.my-apps.TAP-CLUSTER-DOMAIN-NAME/user-profile
  - https://angular-frontend.my-apps.TAP-CLUSTER-DOMAIN-NAME/customer-profiles/list
  - https://angular-frontend.my-apps.TAP-CLUSTER-DOMAIN-NAME/
  - http://angular-frontend.my-apps.TAP-CLUSTER-DOMAIN-NAME/user-profile
  - http://angular-frontend.my-apps.TAP-CLUSTER-DOMAIN-NAME/customer-profiles/list
  - http://angular-frontend.my-apps.TAP-CLUSTER-DOMAIN-NAME/
  scopes:
  - name: openid
  - name: email
  - name: profile
  - name: message.read
  - name: message.write
```

> **Note** You can choose `redirectURIs` that use HTTP or HTTPS based on your need.
> The prefix of the `redirectURIs` denotes the name and namespace of the `Workload`.
> In this scenario, it is `angular-frontend` and `my-apps`.

You can apply the `ClientRegistration` and verify the status is `Ready` by running:

```shell
kubectl get clientregistration angular-frontend --namespace my-apps
```

## <a id="auth-settings"></a> Verify application authentication settings

Within the single-page Angular app accelerator, authentication configuration settings are located in `src/assets/auth.conf.json`.
After generating the accelerator, expect to observe the populated settings.

Open the file and verify that it adheres to the following structure:

```json
{
  "authority": "AUTHSERVER-ISSUER-URI",
  "clientId": "my-apps_angular-frontend",
  "scope": [ "openid", "profile", "email", "message.read", "message.write" ]
}
```

You can retrieve the `clientId` field by running:

```shell
kubectl get secret angular-frontend -n my-apps -o jsonpath="{.data.client-id}" | base64 -d
```

## <a id='backend'></a> Start a sample back end

> **Important** You can skip this step if you have a `java-rest-service` back end running already.

The `angular-frontend` sample application requires a back end application to start properly:

1. Start a sample simulated back end by running:

    ```shell
    kubectl run sample-backend --image nginx:NGINX-VERSION -n my-apps
    kubectl expose pod sample-backend --port 80 -n my-apps
    ```

1. In the `angular-frontend` source code, edit the `.server.location[/api/].proxy_pass`
field in the `nginx.conf` file at the root of the source directory.

1. After updating the value, commit the changes to the Git remote repository:

    ```console
    server {
     # ...
     location /api/ {
       proxy_pass http://sample-backend.my-apps/api/;
     }
     # ...
    }
    ```

## <a id="deploy-workload"></a> Deploy the `Workload`

Follow these steps to deploy the `Workload`:

1. Create the `angular-frontend` accelerator `Workload` by running:

    ```shell
    tanzu apps workload create angular-frontend \
        --namespace my-apps \
        --type web \
        --param "clusterBuilder=base" \
        --param "annotations=autoscaling.knative.dev/minScale: \"1\"" \
        --label app.kubernetes.io/part-of=angular-frontend \
        --git-repo "GIT-LOCATION-OF-YOUR-ACCELERATOR" \
        --git-branch main
    ```

    > **Note** As an alternative approach to creating the workload, you can declaratively
    > define a `Workload` resource by using `config/workload.yaml` within the source repository.

    It might take a few minutes for the workload to become available through a browser-accessible URL.

1. Query the latest status of the workload by running:

    ```shell
    tanzu apps workload get angular-frontend --namespace my-apps
    ```

1. Monitor the `Workload` logs:

    ```shell
    tanzu apps workload tail angular-frontend --namespace my-apps
    ```

    After the status of the workload reaches the `Ready` state,
    you can navigate to the provided URL, which looks similar to:

    ```text
    https://angular-frontend.my-apps.TAP-CLUSTER-DOMAIN-NAME/user-profile
    ```

1. Open your preferred web browser and navigate to the URL.

    Expect to be prompted to sign in by using AppSSO. After successfully signing in,
    the profile page displays your identifying information.

## <a id="clean-up"></a> Clean up

Delete the running application by running these commands:

1. Delete the sample application `Workload`:

    ```shell
    tanzu apps workload delete angular-frontend --namespace my-apps
    ```

1. Delete the service resource claim for the `ClientRegistration`:

    ```shell
    tanzu service resource-claim delete angular-frontend --namespace my-apps
    ```

1. Disconnect the client from AppSSO:

    ```shell
    kubectl delete clientregistration angular-frontend --namespace my-apps
    ```

1. Delete the sample back end if was previously applied:

    ```shell
    kubectl delete svc sample-backend --namespace my-apps
    kubectl delete pod sample-backend --namespace my-apps
    ```
