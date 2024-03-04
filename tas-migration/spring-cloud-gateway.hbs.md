# Migrating applications bound to Spring Cloud Gateway from TAS to TAP

Gateway migration documentation details points to consider before migrating from either OSS
implementation of Gateway or TAS service offering of Gateway to Gateway on Kubernetes.

## Deploying the `animal-rescue` application to TAS

Documentation for deploying a gateway service to TAS can be found here. At a high level, steps for
deploying the `animal-rescue` app and configuring gateway on TAS are as below.

Create an instance of gateway from the marketplace by running `cf create-service`.

```console
cf create-service  p.gateway standard $GATEWAY_NAME -c $GATEWAY_CONFIG_FILE
```

Where:

- `$GATEWAY_NAME` is the name of the gateway instance
- `$GATEWAY_CONFIG_FILE` is the gateway instance configuration file

For more information, see
[app-gateway-config.json](https://github.com/spring-cloud-services-samples/animal-rescue/blob/main/gateway/api-gateway-config.json)
on GitHub.

To bind the gateway service to your application you have 2 choices. More details can be found
here.

Binding
: To bind the gateway service to your applications:

Bind the gateway service to your applications by running `cf bind-service` and restart your application
for changes to effect. `$GATEWAY_NAME` is the name of the gateway instance created in the previous step
`$ROUTE_CONFIG_FILE` is the route configuration file used for configuring routes of the application.
For reference here and here are the configuration files used for configuring frontend and backend
routes with gateway service in the `animal-rescue` application.

```console
cf bind-service $APP_NAME $GATEWAY_NAME -c $ROUTE_CONFIG_FILE
cf restart $APP_NAME
```

Using curl
: To use curl to dynamically update route configurations with the Service Broker API:

  1. Retrieve the GUID representing the animals app.

     ```console
     $ cf app animals --guid
     6e41a492-a17c-4b27-83b0-78635baa54b4
     ```

  1. Obtain the URL of a service instance's backing app for `my-gateway` by running

     ```console
     cf service my-gateway
     ```

     Example:

     ```console
     $ cf service my-gateway
     Showing info of service my-gateway in org myorg / space dev as user...

     name:             my-gateway
     service:          p.gateway
     tags:
     plan:             standard
     description:      Spring Cloud Gateway for VMware Tanzu
     documentation:
     dashboard:        https://my-gateway.apps.example.com/scg-dashboard
     ```

  1. Copy the URL given for dashboard and remove the `/scg-dashboard` path. This is the URL of the
     service instance's backing app. For example, `https://my-gateway.apps.example.com`.

  1. Update route configuration for the app animals via the routes actuator endpoint on the
     `my-gateway` service instance by running:

     ```console
     curl -k -X PUT https://my-gateway.apps.example.com/actuator/bound-apps/6e41a492-a17c-4b27-83b0-78635baa54b4/routes \
     -d "@./gateway-route-config.json" -H "Authorization: $(cf oauth-token)" -H "Content-Type: application/json"
     ...
     < HTTP/1.1 204 No Content
     ...
     ```

## Deploy the `animal-rescue` application to TAP

Documentation for deploying a gateway service to TAP can be found here. For deploying an
`animal-rescue` app and configuring the gateway on TAP, see documentation on repo here. The easy minimal
configuration required would be as below

### Create a gateway instance

1. Create a file called `gateway-config.yaml` containing the following YAML definition:

   ```yaml
   ---
   apiVersion: "tanzu.vmware.com/v1"
   kind: SpringCloudGateway
   metadata:
     name: my-gateway
   spec:
     count: 1
   ```

1. Apply this definition to your Kubernetes cluster by running:

   ```console
   kubectl apply --filename gateway-config.yaml
   ```

   Example:

   ```console
   $ kubectl get springcloudgateway my-gateway
   NAME               READY   REASON
   my-gateway         True    Created
   ```

### Create a route configuration

The Spring Cloud Gateway tile service has a JSON-based API route configuration approach. There are
many similarities in terms of the configuration options available to those in Spring Cloud Gateway
for Kubernetes.

1. Create a file called `animal-rescue-backend-route-config.yaml` with the following definition:

   ```yaml
   ---
   apiVersion: "tanzu.vmware.com/v1"
   kind: SpringCloudGatewayRouteConfig
   metadata:
     name: animal-rescue-backend-route-config
   spec:
     service:
       name: animal-rescue-backend
     routes:
       - predicates:
           - Path=/api/**
         filters:
           - StripPrefix=1
   ```

1. Apply this definition to your Kubernetes cluster by running:

   ```console
   kubectl apply --filename animal-rescue-backend-route-config.yaml
   ```

### Create a gateway mapping

In Tanzu Application Service, Spring Cloud Gateway tile services leverage the Service Broker API and
service binding approach for applications to set up container-network routing of requests to a
service instance.

Spring Cloud Gateway for Kubernetes provides a `SpringCloudGatewayMapping` resource definition to
expose API routes on to an API gateway instance.

For more information, see the
[Spring Cloud Gateway for Kubernetes documentation](https://docs.vmware.com/en/VMware-Spring-Cloud-Gateway-for-Kubernetes/2.1/scg-k8s/GUID-developer-resources-springcloudgatewaymapping.html).

# Create another file called animal-rescue-backend-mapping.yaml with the following definition

```yaml
---
apiVersion: "tanzu.vmware.com/v1"
kind: SpringCloudGatewayMapping
metadata:
  name: animal-rescue-backend-mapping
spec:
  gatewayRef:
    name: my-gateway
  routeConfigRef:
    name: animal-rescue-backend-route-config
```

# Apply this definition to your Kubernetes cluster

```console
kubectl apply --filename animal-rescue-backend-mapping.yaml
```

If your cluster has an ingress configured, then assuming that `my-gateway` is accessible via the
ingress with a fully-qualified domain name of `my-gateway.my-example-domain.com`, the Animal Rescue
backend API will be available under the path `my-gateway.my-example-domain.com/api/...`.

One of the endpoints available in the sample application is `GET /api/animals`, which lists all of
the animals available for adoption. This endpoint should now be accessible using the following
command:

```console
# Using curl:
curl my-gateway.my-example-domain.com/api/animals
```