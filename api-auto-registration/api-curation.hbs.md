# API Curation (alpha)

This topic describes how you can use API Curation to expose several standalone APIs as one API.

To unlock the maximum power of API curation, we strongly recommend to use a supported route provider.
Without this setup, the generated API spec will not have a functional server URL set for testing the
curated API. And you will need to manually create the routing resources to route traffic to each
referenced API to match on the aggregated API spec. With the route provider integration, all of these
routing concern will be taken care of by us automatically.

A successful API curation requires the following as of today:

1. (Optional) Spring Cloud Gateway for Kubernetes is installed.
2. API Auto Registration is installed or updated with `route_provider.spring_cloud_gateway.enabled`
   set accordingly.
3. One or more `APIDescriptor`s that are in the ready state.
4. (Optional) A `SpringCloudGateway` resource is created with the matching `groupId` and `version`.
5. A `CuratedAPIDescriptor` resource is created
6. You should be able to get the aggregated API spec from the OpenAPI endpoint from our controller.

## <a id='create-route-provider'></a>(Optional) Install route provider and create gateway resources

### <a id='setup-scg'></a>Setup Spring Cloud Gateway integration

Install Spring Cloud Gateway for Kubernetes following [this guide](../spring-cloud-gateway/install-spring-cloud-gateway.hbs.md).

SCG integration as route provider is disabled by default. Once you have SCG installed, you may enable
SCG as a route provider by [installing/updating API Auto Registration](./configuration.hbs.md) with
the following value property:

```yaml
route_provider:
  spring_cloud_gateway:
    enabled: true
    scg_openapi_service_url: "http://scg-openapi-service.spring-cloud-gateway.svc.cluster.local" # default value
```

For SCG 2.1.0 and above, if you enabled TLS on SCG, or installed it in a custom namespace,
you will need to overwrite `route_provider.spring_cloud_gateway.scg_openapi_service_url` in your
API Auto Registration values file.

If you are using lower version of SCG, consider to upgrade or refer to the following table to
understand the impact:

| Capability | Behavior with SCG 2.1.0 and above | Behavior prior to SCG 2.1.0 |
| --- | --- | --- |
| Configuring `scg_openapi_service_url` | The default value should be sufficient if with default SCG installation | The URL is `http://scg-operator.tap-install.svc.cluster.local` with the default SCG installation |
| Update API metadata on the matching SCG | API metadata annotations will be added/updated, and the API spec exposed from SCG OpenAPI endpoint will reflect that | API metadata annotations will be added/updated, but the API spec exposed from SCG OpenAPI endpoint will <strong>NOT</strong> reflect that |
| Use SCG generated API spec as aggregated API spec | Yes. And the OpenAPI endpoint from AAR controller will return the same spec as the SCG OpenAPI Service | SCG OpenAPI endpoint does not support returning spec for a single SCG instance, so the aggregated API spec will not include the additional information from SCG filters |

### <a id='create-scg'></a>Create SpringCloudGateway resource

Using your GitOps process, or manually, you may create an `SpringCloudGateway` CR and apply it in the
cluster you choose.

Here is a sample SCG resource

```yaml
apiVersion: "tanzu.vmware.com/v1"
kind: SpringCloudGateway
metadata:
  name: test-api-curation
spec:
  api:
    version: 1.2.3
    groupId: test-api-curation
    serverUrl: https://my-curated-api.mydomain.com
    cors:
      allowedOrigins:
        - "http://api-portal.mydomain.com"
      allowedMethods:
        - "GET"
        - "PUT"
        - "POST"
      allowedHeaders:
        - '*'
```

The `groupId` and `version` will be used to match on the SCG when we reconcile for `CuratedAPIDescriptor`.
Once a match is found, `serverUrl` will be used as the baseURL of the curated API.

## <a id='create-api-descriptors-for-curation'></a>Create APIDescriptors for curation

Follow the [API Auto Registration Usage Guide](./usage.hbs.md) to create `APIDescriptor` resources.
If any of the referenced `APIDescriptor` is not ready, the `CuratedAPIDescriptor` will keep retrying
until all the referenced `APIDescriptor`s are ready. If the API spec from any of the `APIDescriptor`
gets updated, our controller will pick up the changes on the next reconciliation loop.

**Note:** By default, the update might take up to 10 minutes to be reflected in the worst case scenario,
max 5 minutes to refresh the `APIDescriptor`, and max 5 minutes to refresh `CuratedAPIDescriptor`.
However, you may shorten the wait time by configuring `sync_period` in the AAR values file.

## <a id='create-curated-api-descriptor'></a>Create CuratedAPIDescriptor custom resource

Using your GitOps process, or manually, you may create an CuratedAPIDescriptor CR and apply it in the
cluster you choose. Be sure specify all the required fields for an CuratedAPIDescriptor CR to reconcile.

For information about CuratedAPIDescriptors, see [CuratedAPIDescriptor explained](./key-concepts.hbs.md#curated-api-descriptor).

## <a id='retrieve-curated-api-specs'></a>Retrieve curated API specs

The API Auto Registration controller offers an endpoint to retrieve all the generated API specs for
the curated APIs in the cluster. To do so, you need to first find the HTTPProxy that's created for
accessing the endpoint:

```console
kubectl get httpproxy api-auto-registration-controller -n api-auto-registration
```

The result is similar to:

```console
NAME                               FQDN                              TLS SECRET                   STATUS   STATUS DESCRIPTION
api-auto-registration-controller   api-auto-registration.tap.domain  api-auto-registration-cert   valid    Valid HTTPProxy
```

With the FQDN with proper http scheme, you may get all the curated API specs with curl:

```console
curl http(s)://<AAR-controller-fqdn>/openapi
```

You may retrieve spec for a specific `groupId` and `version` combination by specifying query params:

```console
curl http(s)://<AAR-controller-fqdn>/openapi?groupId=<groupId>&version=<version>
```
