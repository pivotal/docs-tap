# Secure a Spring Boot Workload

This topic describes the procedure to secure a sample Spring Boot `Workload` with AppSSO, which runs on Tanzu Application Platform (TAP). 

Follow these steps to deploy a sample Spring Boot `Workload`:

1. [Get the sample application](#sample-app)
1. [Create a namespace for workloads](#create-namespace).
1. [Apply a client registration](#clientregistration).
1. [Create a resource claim for the workload](#resource-claim).
1. (Optional) [Ensure `Workload` trusts `AuthServer`](#trust-authserver).
1. [Deploy the Workload](#deploy-workload).

## <a id='sample-app'></a> Get the sample application

Fetch the AppSSO Spring Boot application source code by downloading **AppSSO Starter Java** accelerator from 
TAP GUI accelerators located on your TAP cluster.

You may do this in two ways:

1. **Navigate to your TAP GUI dashboard via browser** - navigate to Application Accelerators and download "AppSSO Starter Java" accelerator.
2. **Use the Tanzu Accelerator CLI** - download the zip file of the accelerator source code, you may run:
   ```shell
   tanzu accelerator generate appsso-starter-java --server-url <TAP_GUI_SERVER_URL>
   ```
   
Unzip the resulting `.zip` file into directory `appsso-starter-java` in your workspace.

```shell
unzip appsso-starter-java
```

With the resulting project, create an accessible remote Git repository and push your accelerator to Git remote.

## <a id='create-namespace'></a> Create a workloads namespace

You must create a namespace for your workloads in order for `Workload` resources to function properly. If you have a
workloads namespace already, you may skip this step.

```shell
kubectl create namespace my-apps
kubectl label namespaces my-apps apps.tanzu.vmware.com/tap-ns=""
```

For more information about provisioning namespaces for workloads, see [Set up developer namespaces](../../set-up-namespaces.hbs.md)

## <a id='clientregistration'></a> Create a `ClientRegistration`

_Example_: A `ClientRegistration` with name `appsso-starter-java` in namespace `my-apps` that is attached to an existing `AuthServer` with
labels `my-sso=true,env=dev` and an allowance of client registrations from namespace `my-apps`.

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

> **Note** You may choose redirect URIs that are http or https based on your need.
> The prefix of the redirectURI denotes the name and namespace of the `Workload`, in the above case
> `appsso-starter-java` and `my-apps`. Keep the suffix formatted like this: `/login/oauth2/code/{ClientRegistration.metadata.name}`
> ([read more about Spring Security OAuth 2 Client library redirect URI format](./workloads-and-appsso.hbs.md#redirect-uris)).

The accelerator comes pre-packaged with a ytt-templated `ClientRegistration` that is located in `client.yaml`. You
may generate the same `ClientRegistration` as above with your specific values by running:

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

- **namespace** - the namespace in which the workload will run.
- **workload_name** - the distinct name of the instance of the accelerator being deployed.
- **domain** - the domain name under which the workload will be deployed. The workload instance will use a subdomain to
  distinguish itself from other workloads. If working locally, `127.0.0.1.nip.io` is the easiest approach to get a
  working DNS route on a local cluster.
- **authserver_label.{matching-label}** - uniquely identifying label(s) for your `AuthServer`. In this example, we assume that
  the `AuthServer` resource has labels `my-sso: "true"` and `env: dev`. You can add as many identifying labels as needed.

Apply the `ClientRegistration`, and then check its status via:

```shell
kubectl get clientregistration appsso-starter-java --namespace my-apps
```

## <a id="resource-claim"></a> Claim the `ClientRegistration`

Using Tanzu Services plugin CLI, create a service resource claim for the `ClientRegistration` created above:

```shell
tanzu service resource-claim create appsso-starter-java \
    --namespace my-apps \
    --resource-namespace my-apps \
    --resource-name appsso-starter-java \
    --resource-kind ClientRegistration \
    --resource-api-version "sso.apps.tanzu.vmware.com/v1alpha1"
```

Once applied, you may check the status of the claim like so:

```shell
tanzu service claim list --namespace my-apps
```

You should see `appsso-starter-java` claim with `Ready` status as `True`.

## <a id="trust-authserver"></a> Ensure `Workload` will trust `AuthServer`

If using a TAP cluster with a custom or self-signed CA certificate, 
see [Configure Workloads to trust a custom Certificate Authority (CA)](../service-operators/workload-trust-custom-ca.hbs.md).

## <a id="deploy-workload"></a> Deploy the `Workload`

To create the Spring Boot accelerator `Workload`, run the following:

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

> **Important** While the name of the `ResourceClaim` may be anything you choose, the `Workload`'s service reference name
> **must** be the name of the `ClientRegistration`.
> 
> `--service-ref "**appsso-starter-java**=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:appsso-starter-java"`
>
> If the service reference name does not match the `ClientRegistration` name, the `Workload` will present a redirect URI
> that is not accepted by the `AuthServer`.

It takes some minutes for the workload to become available through a browser-accessible URL.

To query the latest status of the workload, run:

```shell
tanzu apps workload get appsso-starter-java --namespace my-apps
```

Follow the `Workload` logs:

```shell
tanzu apps workload tail appsso-starter-java --namespace my-apps
```

After the status of the workload reaches the `Ready` state, you can navigate to the URL provided, which looks similar to:

```text
https://appsso-starter-java.my-apps.<TAP_CLUSTER_DOMAIN_NAME>
```

Navigate to the URL in your favorite browser, and observe a large log-in button tailored for authenticating with AppSSO.

## Cleaning up

You can delete the running application by running the following commands:

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

