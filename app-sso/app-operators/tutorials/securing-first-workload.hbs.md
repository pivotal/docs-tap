# Secure a workload

This tutorial will walk you through the steps to add an authentication mechanism to a sample Spring Boot application
using AppSSO service, running on Tanzu Application Platform (TAP).

## Prerequisites

Before starting the tutorial, please ensure that the following items are addressed:

- **RECOMMENDED** Familiarity with [Workloads and AppSSO](../register-an-app-with-app-sso.md#workloads)
- Tanzu Application Platform (TAP) `v1.2.0` or above is available and fully reconciled in your cluster.
    - Please ensure that you are using one of the following TAP Profiles: `run`, `iterate`, or `full`.
- AppSSO package is available and reconciled successfully on your cluster.
- AppSSO has at least one [identity provider configured](../../service-operators/identity-providers.md).
- Access to [AppSSO Starter Java](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/appsso-starter-java)
accelerator used in this tutorial.

## Getting started

> **Note** See [Deploying the sample application as a Workload](#deploy-as-workload) for step-by-step instructions if you are already familiar
with the accelerator described in this tutorial.

### Understanding the sample application

In this tutorial, you will be working with a sample Servlet-based Spring Boot application that
uses [Spring Security OAuth2 Client library](https://docs.spring.io/spring-security/reference/servlet/oauth2/client/index.html).

You can find
the [source code for the application here](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/appsso-starter-java).
To follow along, be sure to Git clone the repository onto your local environment.

The application, once launched, has two pages:

- a **publicly-accessible home page (`/home`)**, available to everyone.
- a **user home page (`/authenticated/home`)**, for signed-in users only.

The security configuration for the above is located
at `com.vmware.tanzu.apps.sso.sampleworkload.config.WebSecurityConfig`.

For more information about how apps are configured with Spring Security OAuth2 Client library, see [Spring Boot and OAuth2 documentation](https://spring.io/guides/tutorials/spring-boot-oauth2/).

By default, there is no application properties file in our sample application and this is by design: even the simplest
application can be deployed with AppSSO, you can even go to [start.spring.io](https://start.spring.io) and download a
Spring Boot app with Spring Security OAuth2 Client library, and you are good to go! There is yet another reason for the
absence of any properties files: a demonstration
of [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings) in action, which removes the need for
any OAuth related properties. Spring Cloud Bindings will be introduced later in this tutorial.

#### The sample application's `ClientRegistration`

A critical piece of integration with AppSSO is to create
a [ClientRegistration custom resource definition](../../crds/clientregistration.md). A `ClientRegistration` is a way
for AppSSO to learn about the sample application. In the sample application, you can find the definition file
named `client.yaml`, at the root of the source directory.

The `ClientRegistration` resource definition contains a few critical pieces in its specification:

- `authorizationGrantTypes` is set to a list of one: `authorization_code`. Authorization Code grant type is required for
  [OpenID Connect authentication](https://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth) which we will be
  using in this tutorial.
- `redirectURIs` is set to a list of two URIs: a remote URI and a local URI (i.e. `127.0.0.1`). The remote URI will be
  the full URL to which AppSSO will redirect the user back upon successful authentication. The local URI is only meant
  for debugging purposes and can be ignored unless desired. The suffix of both URIs is important for Spring Security -
  it adheres
  to [the default redirect URI template](https://docs.spring.io/spring-security/reference/servlet/oauth2/login/core.html#oauth2login-sample-redirect-uri)
  .
- `scopes` is set to a list of one scope, the `openid` scope. The `openid` scope
  is [required by OpenID Connect specification](https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest) in
  order to issue identity tokens which designate a user as 'signed in'.

For more information about `ClientRegistration` custom resource, 
see [ClientRegistration CRD](../../crds/clientregistration.md).

The `client.yaml` file is using [ytt templating](https://carvel.dev/ytt/) conventions. If you have
the [Tanzu Cluster Essentials](https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/) installed, you
should already have `ytt` available on your command line. Later in the tutorial, we will generate a final
output `ClientRegistration` declaration that will look similar to the below:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: appsso-starter-java
  namespace: workloads
spec:
  authServerSelector:
    matchLabels:
    # ask your Service Operator for labels to target an `AuthServer`
  clientAuthenticationMethod: basic
  authorizationGrantTypes:
    - authorization_code
  redirectURIs:
    - http://<app-url>/login/oauth2/code/<claim-name>
  scopes:
    - name: openid
```

### Understanding `Workload`s

To deploy the sample application onto a TAP cluster, we must first craft it as a `Workload` resource (
a [Cartographer CRD](https://cartographer.sh/)). A `Workload` resource can be thought of as a manifest for a process you
want to execute on the cluster, and in this context, the type of workload is `web` - a web application. TAP clusters
provide the capability to apply `Workload` resources out of the box within the proper profiles, as described in
the [prerequisites](#prerequisites) section.

To deploy a workload, it is best to work in a separate workload-specific namespace. Once created, there
are [required TAP configurations that need to be applied](../../../set-up-namespaces.md)
before a `Workload` in a specific namespace can be deployed properly.

## <a id="deploy-as-workload"></a>Deploying the sample application as a Workload

To tie it all together and deploy the sample application, the following are the steps involved.

### Create workload namespace

Create a workload namespace called `workloads`:

```shell
kubectl create namespace workloads
```

### Apply required TAP workload configurations

Within the `workloads` namespace, apply [TAP required developer namespaces](../../../set-up-namespaces.md)
as described.

### Apply the `ClientRegistration`

Apply the `client.yaml` definition file (described [above](#the-sample-applications-clientregistration))

> **Caution** Make sure to set `auth_server_name` field to the value of the label name on the AuthServer custom resource. 
This might differ from the name of the AuthServer custom resource.

```shell
ytt \
  --file client.yaml \
  --data-value namespace=workloads \
  --data-value workload_name=appsso-starter-java \
  --data-value domain=127.0.0.1.nip.io \
  --data-value auth_server_name="" \
  --data-value claim_name=appsso-starter-java | \
   kubectl apply -f-
```

A bit more detail on the above YTT data values:

- **namespace** - the namespace in which the workload will run.
- **workload_name** - the distinct name of the instance of the accelerator being deployed.
- **domain** - the domain name under which the workload will be deployed. The workload instance will use a subdomain to
  distinguish itself from other workloads. If working locally, `127.0.0.1.nip.io` is the easiest approach to get a
  working DNS route on a local cluster.
- **auth_server_name** - the value of the label "name" on the AuthServer resource that you installed and want to use with your workload. This may differ from the name of the AuthServer custom resource.
- **claim_name** - the service resource claim name being assigned for this workload, this is the binding between the
  workload and AppSSO. You may choose any reasonably descriptive name for this, it will be used in the next step.

This command has generated a `ClientRegistration` definition and applied it to the cluster. To check the status of the
client registration, run:

```shell
kubectl get clientregistration appsso-starter-java --namespace workloads
```

You should see the `ClientRegistration` entry listed.

### Create a ClientRegistration service resource claim for the workload

Using Tanzu Services plugin CLI, create a service resource claim for the workload:

> **Caution** Name of the claim must be the same as the value of `claim_name` from the previous step.

> **Caution** Resource name must be the same name as the workload name.

```shell
tanzu service claim create appsso-starter-java \
    --namespace workloads \
    --resource-namespace workloads \
    --resource-name appsso-starter-java \
    --resource-kind ClientRegistration \
    --resource-api-version "sso.apps.tanzu.vmware.com/v1alpha1"
```

Once applied, you may check the status of the claim like so:

```shell
tanzu service claim list --namespace workloads
```

You should see `appsso-starter-java` claim with `Ready` status as `True`.

### (Optional) Ensure Workload trusts AuthServer

You must ensure `Workload` trusts `AuthServer` if you use the default self-signed certificate `ClusterIssuer` while installing Tanzu Application Platform.

For more information, see [Configure Workloads to trust a custom Certificate Authority (CA)](../../service-operators/workload-trust-custom-ca.hbs.md).

### Deploy the workload

The Tanzu CLI command to create a workload for the sample application should look like the following:

```shell
tanzu apps workload create appsso-starter-java \
    --namespace workloads \
    --type web \
    --label app.kubernetes.io/part-of=appsso-starter-java \
    --service-ref "appsso-starter-java=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:appsso-starter-java" \
    --git-repo "https://github.com/vmware-tanzu/application-accelerator-samples" \
    --sub-path "appsso-starter-java" \
    --git-branch main \
    --live-update \
    --yes
```

The above command creates a web `Workload` named 'appsso-starter-java' in the `workloads` namespace. The sample
applications' source code repository is defined in the `git-repo` and `git-branch` parameters. The original client yaml
definition contains the reference to a service claim which enables the `Workload`'s Pods to have the necessary
AppSSO-generated credentials available as a Service Binding. Learn more about how this
works [here](../register-an-app-with-app-sso.md#workloads).

It takes some minutes for the workload to become available as a URL.

To query the latest status of the Workload, run:

```shell
tanzu apps workload get appsso-starter-java --namespace workloads
```

> **Caution** You may see the status of the workload at first:
>
> **message**: waiting to read value [.status.latestImage] from resource [image.kpack.io/appsso-starter-java]
> in namespace [workloads]
>
> **reason**: `MissingValueAtPath`
>
> **status**: `Unknown`
> 
> This is not an error, this is normal operation of a pending workload. Watch the status for changes.

Follow the `Workload` logs:

```shell
tanzu apps workload tail appsso-starter-java --namespace workloads
```

After the status of the workload reaches the `Ready` state, you can navigate to the URL provided, which looks similar to:

```text
http://appsso-starter-java.workloads.127.0.0.1.nip.io
```

Navigate to the URL in your favorite browser, and observe a large login button tailored for logging with AppSSO.

Once you have explored the accelerator and its operation, head on to the next section for uninstall
instructions.

## Cleaning up

You may delete the running accelerator by running the following:

Delete the sample application workload

```shell
tanzu apps workload delete appsso-starter-java --namespace workloads
```

Delete the service resource claim for the ClientRegistration

```shell
tanzu service claim delete appsso-starter-java --namespace workloads
```

Disconnect the accelerator from AppSSO

```shell
kubectl delete clientregistration appsso-starter-java --namespace workloads
```
