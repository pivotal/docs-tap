# Secure a single-page app Workload

This topic describes the procedure to secure a sample single-page Angular app `Workload` with AppSSO, which runs on 
Tanzu Application Platform (TAP).

Follow these steps to deploy a sample single-page app `Workload`:

1. [Get the sample application](#sample-app)
1. [Create a namespace for workloads](#create-namespace).
1. [Apply a client registration](#clientregistration).
1. [Verify application auth settings](#auth-settings).
1. [Launch a sample backend](#backend)
1. [Deploy the Workload](#deploy-workload).

## <a id='sample-app'></a> Get the sample application

Fetch the single-page Angular app source code by downloading the **Angular Frontend** accelerator from
TAP GUI accelerators located on your TAP cluster.

You may do this in two ways:

1. **Navigate to your TAP GUI dashboard via browser** - navigate to Application Accelerators and choose "Angular Frontend" accelerator.
   1. Check `Single Sign-on` option
2. **Use the Tanzu Accelerator CLI** - download the zip file of the accelerator source code, you may run:
   Find out your `AuthServer` Issuer URI by running:
   ```shell
   kubectl get authserver -A
   ```
   Generate the accelerator using the `tanzu accelerator` CLI
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

Unzip the resulting `.zip` file into directory `angular-frontend` in your workspace.

```shell
unzip angular-frontend
cd angular-frontend
git init
git branch -M main
git remote add origin <YOUR_ACCELERATOR_GIT_REPOSITORY>
git push origin main -u
```

Push the resulting directory to a remote Git repository.

## <a id='create-namespace'></a> Create a workloads namespace

You must create a namespace for your workloads in order for `Workload` resources to function properly. If you have a
workloads namespace already, you may skip this step.

```shell
kubectl create namespace my-apps
kubectl label namespaces my-apps apps.tanzu.vmware.com/tap-ns=""
```

For more information about provisioning namespaces for running `Workloads`, see [Set up developer namespaces](../../set-up-namespaces.hbs.md)

## <a id='clientregistration'></a> Create a `ClientRegistration`

A `ClientRegistration` must be created to register the frontend application with the `AuthServer`.

_Example_: A `ClientRegistration` with name `angular-frontend` in namespace `my-apps` that is attached to an existing `AuthServer` with
labels `my-sso=true` and an allowance of client registrations from namespace `my-apps`.

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

> **Note** You may choose redirect URIs that are http or https based on your need.
> The prefix of the redirectURI denotes the name and namespace of the `Workload`, in the above case
> `angular-frontend` and `my-apps`.

Apply the `ClientRegistration`, and then verify that the status is `Ready` by running:

```shell
kubectl get clientregistration angular-frontend --namespace my-apps
```

## <a id="auth-settings"></a> Verify application auth settings

Within the single-page Angular app accelerator, you will find auth configuration settings located in `src/assets/auth.conf.json`.
If you properly generated the accelerator, then the settings should already be populated. To verify, view the file and
ensure the following structure:

```json
{
  "authority": "<AUTHSERVER_ISSUER_URI>",
  "clientId": "my-apps_angular-frontend",
  "scope": [ "openid", "profile", "email", "message.read", "message.write" ]
}
```

The `clientId` field may be retrieved by running:

```shell
kubectl get secret angular-frontend -n my-apps -o jsonpath="{.data.client-id}" | base64 -d
```

## <a id='backend'></a> Launch a sample backend

> **Note** You may skip this step if you have a `java-rest-service` backend up and running already.

The `angular-frontend` sample application requires a backend application to launch properly. For our purposes, we may
launch a sample (fake) backend to allow for the frontend to launch.

```
kubectl run sample-backend --image nginx:<nginx-version-of-your-choosing> -n my-apps
kubectl expose pod sample-backend --port 80 -n my-apps
```

In `angular-frontend` source, update `.server.location[/api/].proxy_pass` field in `nginx.conf` at the root of the source
directory. After updating the value, commit the changes to Git remote.

```
server {
 # ...
 location /api/ {
   proxy_pass http://sample-backend.my-apps/api/;
 }
 # ...
}
```

## <a id="deploy-workload"></a> Deploy the `Workload`

To create the `angular-frontend` accelerator `Workload`, run the following:

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

> **Note** You may declaratively define a `Workload` resource using `config/workload.yaml` within the source repository
> as an alternative approach to creating the workload.

It takes some minutes for the workload to become available through a browser-accessible URL.

To query the latest status of the workload, run:

```shell
tanzu apps workload get angular-frontend --namespace my-apps
```

Follow the `Workload` logs:

```shell
tanzu apps workload tail angular-frontend --namespace my-apps
```

After the status of the workload reaches the `Ready` state, you can navigate to the URL provided, which looks similar to:

```text
https://angular-frontend.my-apps.<TAP_CLUSTER_DOMAIN_NAME>/user-profile
```

Navigate to the URL in your favorite browser, and observe a prompt to sign in with AppSSO. Once signed in, you will observe
that the profile page is rendered with your identifying details.

## Cleaning up

You can delete the running application by running the following commands:

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

1. Delete the sample backend (if applied):

    ```shell
    kubectl delete svc sample-backend --namespace my-apps
    kubectl delete pod sample-backend --namespace my-apps
    ```
