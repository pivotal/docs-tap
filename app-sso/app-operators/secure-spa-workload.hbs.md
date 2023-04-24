# Secure a single-page app workload

This topic describes the procedure to secure a sample single-page Angular app `Workload` with AppSSO, which runs on 
Tanzu Application Platform (TAP).

Follow these steps to deploy a sample single-page app `Workload`:

1. [Get the sample application](#sample-app).
1. [Create a namespace for workloads](#create-namespace).
1. [Apply a client registration](#clientregistration).
1. [Verify application auth settings](#auth-settings).
1. [Launch a sample backend](#backend).
1. [Deploy the Workload](#deploy-workload).

## <a id='sample-app'></a> Get the sample application

Follow these steps to fetch the single-page Angular app source code:

1. Download the Angular Frontend accelerator from the TAP GUI accelerators located on your TAP cluster:

    - Option 1: Use the TAP GUI dashboard through browser.

        Navigate to Application Accelerators and choose the "Angular Frontend" accelerator and then check the `Single Sign-on` option.

    - Option 2: Use the Tanzu Accelerator CLI.

        Download the zip file of the accelerator source code and identify your `AuthServer` Issuer URI by running:
        
        ```shell
        kubectl get authserver -A
        ```

        Generate the accelerator by using the `tanzu accelerator` CLI:

        ```shell
        tanzu accelerator generate angular-frontend \
          --server-url <TAP_GUI_SERVER_URL> \
          --options '{
            "useSingleSignOn": true,
            "authority": "<AUTHSERVER_ISSUER_URI>",
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
    git remote add origin <YOUR_ACCELERATOR_GIT_REPOSITORY>
    git push origin main -u
    ```

1. Push the resulting directory to a remote Git repository.

## <a id='create-namespace'></a> Create a namespace for workloads

You must create a namespace for your workloads for the `Workload` resources to function properly. 
If you have a workloads namespace already, you can skip this step.

```shell
kubectl create namespace my-apps
kubectl label namespaces my-apps apps.tanzu.vmware.com/tap-ns=""
```

For more information about provisioning namespaces for running `Workloads`, 
see [Set up developer namespaces](../../set-up-namespaces.hbs.md).

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
  - https://angular-frontend.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/user-profile
  - https://angular-frontend.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/customer-profiles/list
  - https://angular-frontend.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/
  - http://angular-frontend.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/user-profile
  - http://angular-frontend.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/customer-profiles/list
  - http://angular-frontend.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/
  scopes:
  - name: openid
  - name: email
  - name: profile
  - name: message.read
  - name: message.write
```

> **Note** You can choose `redirectURIs` that use http or https based on your need.
> The prefix of the `redirectURIs` denotes the name and namespace of the `Workload`.
> In this scenario, it is `angular-frontend` and `my-apps`.

You can apply the `ClientRegistration` and verify the status is `Ready` by running:

```shell
kubectl get clientregistration angular-frontend --namespace my-apps
```

## <a id="auth-settings"></a> Verify application auth settings

Within the single-page Angular app accelerator, auth configuration settings are located in `src/assets/auth.conf.json`.
If you properly generated the accelerator, the settings should already be populated. 
To verify, open the file and check that it adheres to the following structure:

```json
{
  "authority": "<AUTHSERVER_ISSUER_URI>",
  "clientId": "my-apps_angular-frontend",
  "scope": [ "openid", "profile", "email", "message.read", "message.write" ]
}
```

You can retrieve the `clientId` field by running:

```shell
kubectl get secret angular-frontend -n my-apps -o jsonpath="{.data.client-id}" | base64 -d
```

## <a id='backend'></a> Launch a sample backend

> **Important** You can skip this step if you have a `java-rest-service` backend up and running already.

The `angular-frontend` sample application requires a backend application to launch properly. 
To facilitate our objectives, you can launch a sample simulated backend that enables the frontend to launch.

```shell
kubectl run sample-backend --image nginx:<nginx-version-of-your-choosing> -n my-apps
kubectl expose pod sample-backend --port 80 -n my-apps
```

In the `angular-frontend` source code, edit the `.server.location[/api/].proxy_pass` 
field in the `nginx.conf` file at the root of the source directory. 
After updating the value, commit the changes to Git remote repository.

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
        --git-repo "<GIT_LOCATION_OF_YOUR_ACCELERATOR>" \
        --git-branch main
    ```

    > **Note** As an alternative approach to creating the workload, you can declaratively 
    > define a `Workload` resource by using `config/workload.yaml` within the source repository.

    It might take a few minutes for the workload to to be accessible through a URL 
    that can be accessed from a web browser.

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
    https://angular-frontend.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/user-profile
    ```

1. Open your preferred web browser and navigate to the URL.

    You should be prompted to sign in using AppSSO. After successfully signing in, 
    you will be directed to your profile page, which displays your identifying information.

## <a id="clean-up"></a> Cleaning up

Delete the running application by running the following commands:

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

1. Delete the sample backend if was previously applied:

    ```shell
    kubectl delete svc sample-backend --namespace my-apps
    kubectl delete pod sample-backend --namespace my-apps
    ```
