# Register a workload

## Topics

- [Client registration](#client-registration)
- [Workloads](#workloads)

## Client registration

Applications or Clients must register with AppSSO to allow users to sign in with single sign on within a Kubernetes cluster.
This registration results in the creation of a Kubernetes secret.

To do this, apply a [ClientRegistration](../crds/clientregistration.md) to the appropriate Kubernetes cluster.

To confirm that the `ClientRegistration` was successfully processed, check the status:

```shell
kubectl describe clientregistrations.sso.apps.tanzu.vmware.com <client-name>
```

It is also possible, but not recommended, to register clients statically while deploying AppSSO.

VMware recommends registering clients dynamically after deploying AppSSO. When registering a client 
statically, properties cannot be changed without triggering a rollout of AppSSO.

[Grant Types](grant-types.md)

## Workloads

This guide will walk you through steps necessary to secure your deployed `Workload` with AppSSO.

### Prerequisites

Before attempting to integrate your workload with AppSSO, please ensure that the following items are addressed:

- Tanzu Application Platform (TAP) `v{{ vars.tap_version }}` or above is available on your cluster.
- AppSSO package `v{{ vars.app-sso.version }}` or above is available on your cluster.

### Configuring a Workload with AppSSO

AppSSO and your Workload need to establish a bidirectional relationship: AppSSO is aware of your Workload and your
Workload is aware of AppSSO. How does that work?

- To make AppSSO aware of your Workload (i.e. that AppSSO should be responsible for authentication and authorization
  duties), you have to [create and apply a ClientRegistration resource](#create-and-apply-a-clientregistration-resource)
  .
- To make your Workload aware of AppSSO (i.e. that your application shall now rely on AppSSO for authentication and
  authorization requests), you must [specify a service resource claim](#add-a-service-resource-claim-to-your-workload)
  which produces the necessary credentials for your Workload to consume.
- (Optional) Ensure `Workload` trusts `AuthServer`. 
  For more information, see [Configure Workloads to trust a custom Certificate Authority (CA)](../service-operators/workload-trust-custom-ca.hbs.md).

    >**Important** You must ensure `Workload` trusts `AuthServer` if you use the default self-signed certificate `ClusterIssuer` while installing Tanzu Application Platform.

The following sections elaborate on both of the concepts in detail.

#### Create and apply a ClientRegistration resource

Define a [ClientRegistration resource](../crds/clientregistration.md) for your Workload. Here is an example:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: my-workload-client-registration
  namespace: my-workload-namespace
spec:
  authServerSelector:
    matchLabels:
    # ask your Service Operator for labels to target an `AuthServer`
  authorizationGrantTypes:
    - client_credentials
    - authorization_code
    - refresh_token
  clientAuthenticationMethod: basic
  requireUserConsent: true
  redirectURIs:
    - "<MY_WORKLOAD_HOSTNAME>/redirect-back-uri"
  scopes:
    - name: openid
```

Once applied successfully, this resource will create the appropriate credentials for your Workload to consume. More on
this in the next section.

Please refer to the [ClientRegistration custom resource documentation page](../crds/clientregistration.md) for
additional details on schema and specification of the resource.

#### Add a service resource claim to your Workload

Once a ClientRegistration resource has been defined, you can now create a service resource claim by using Tanzu CLI:

```shell
tanzu service resource-claim create my-client-claim \
  --namespace my-workload-namespace \
  --resource-api-version sso.apps.tanzu.vmware.com/v1alpha1 \
  --resource-kind ClientRegistration \
  --resource-name my-workload-client-registration \
  --resource-namespace my-workload-namespace
```

Alternatively, you may create the claim as `ResourceClaim` custom resource:

```shell
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ResourceClaim
metadata:
  name: my-client-claim
  namespace: my-workload-namespace
spec:
  ref:
    apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
    kind: ClientRegistration
    name: my-workload-client-registration
    namespace: my-workload-namespace
```

Observe the status of the service resource claim by running `tanzu service resource-claim list -n my-workload-namespace -o wide`:

```text
NAMESPACE              NAME             READY  REASON  CLAIM REF
my-workload-namespace  my-client-claim  True           services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:my-client-claim
```

The created service resource claim is now referable within a Workload:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: my-workload
  namespace: my-workload-namespace
spec:
  source:
    git:
      ref:
        branch: main
      url: ssh://git@github.com/my-company/my-workload.git
  serviceClaims:
    - name: my-client-claim
      ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ResourceClaim
        name: my-client-claim
```

Alternatively, you can refer to your `ClientRegistration` when deploying your workload with the `tanzu` CLI. Like so

```shell
tanzu apps workload create my-workload \
  --service-ref "my-client-claim=services.apps.tanzu.vmware.com/v1alpha1:ResourceClaim:my-client-claim" \
  # ...
```

What this service claim reference binding does under the hood is ensures that your Workload's Pod is mounted with a
volume containing the necessary credentials required by your application to become aware of AppSSO.

The credentials provided by the service claim are:

- **Client ID** - the identifier of your Workload that AppSSO is registered with. This is a unique identifier.
- **Client Secret** - secret string value used by AppSSO to verify your client during its interactions. Keep this value
  secret.
- **Issuer URI** - web address of AppSSO, and the primary location that your Workload will go to when interacting with
  AppSSO.
- **Authorization Grant Types** - list of desired OAuth 2 grant types that your wants to support.
- **Client Authentication Method** - method in which the client application requests an identity or access token
- **Scopes** - list of desired scopes that your application's users will have access to.

The above credentials are mounted onto your Workload's Pod(s) as individual files at the following locations:

```shell
/bindings
  /<name-of-service-claim>
    /client-id
    /client-secret
    /issuer-uri
    /authorization-grant-types
    /client-authentication-method
    /scope
```

Taking our example from above, the location of credentials can be found at:

```shell
/bindings/my-client-claim/{client-id,client-secret,issuer-uri,authorization-grant-types,client-authentication-method,scope}
```

Given these auto-generated values, your Workload is now able to load them at runtime and bind to AppSSO at start-up
time. Reading the values from the file system is left to the implementor as to the approach taken.
