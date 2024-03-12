# Migrate Spring Cloud Gateway apps to Tanzu Application Platform

This topic tells you how to migrate to Spring Cloud Gateway (SCG) for Kubernetes from a Tanzu
Application Service (commonly known as TAS) offering of SCG or an open-source implementation of SCG. An example
`animal-rescue` app is used to illustrate the high-level steps.

## <a id="deploy-app-to-tas"></a> Deploy the `animal-rescue` app to Tanzu Application Service

This section describes, at a high level, the steps for deploying an example `animal-rescue` app and
configuring SCG on TAS. For more detailed instructions, see the
[SCG documentation](https://docs.vmware.com/en/Spring-Cloud-Gateway-for-VMware-Tanzu/2.1/spring-cloud-gateway/GUID-guides-getting-started.html).

### <a id="create-scg-instance"></a> Create an SCG instance

Create an instance of SCG from Marketplace by running `cf create-service`.

```console
cf create-service  p.gateway standard GATEWAY-NAME -c GATEWAY-CONFIG-FILE
```

Where:

- `GATEWAY-NAME` is the name of the SCG instance
- `GATEWAY-CONFIG-FILE` is the SCG instance configuration file

For more information, see
[app-gateway-config.json](https://github.com/spring-cloud-services-samples/animal-rescue/blob/main/gateway/api-gateway-config.json)
on GitHub.

### <a id="bind-the-service-to-app"></a> Bind the SCG service to your app

You can directly bind the SCG service to the app or you can update the route configurations with the
Service Broker API. For more information about configuring routes, see the
[SCG documentation](https://docs.vmware.com/en/Spring-Cloud-Gateway-for-VMware-Tanzu/2.1/spring-cloud-gateway/GUID-guides-configuring-routes.html).

Binding
: To directly bind the SCG service to your app:

  1. Bind the SCG service to your app by running:

     ```console
     cf bind-service APP-NAME GATEWAY-NAME -c ROUTE-CONFIG-FILE
     ```

     Where:

     - `APP-NAME` is the app name.
     - `GATEWAY-NAME` is the name of the SCG instance created in the previous step
     - `ROUTE-CONFIG-FILE` is the route configuration file used for configuring routes of the app

  1. Restart your app by running:

     ```console
     cf restart $APP_NAME
     ```

  For reference here and here are the configuration files used for configuring front-end and back-end
  routes with SCG service in the `animal-rescue` app.

Update the route config
: To use curl to dynamically update route configurations with the Service Broker API:

  1. Retrieve the GUID representing the `animal-rescue` app by running:

     ```console
     cf app animals --guid
     6e41a492-a17c-4b27-83b0-78635baa54b4
     ```

  1. Obtain the URL of a service instance's backing app for `my-gateway` by running:

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

  1. Copy the URL given for the dashboard and remove the `/scg-dashboard` path. This is the URL of
     the service instance's backing app. For example, `https://my-gateway.apps.example.com`.

  1. Update route configuration for the `animal-rescue` app through the routes actuator endpoint on
     the `my-gateway` service instance by running:

     ```console
     curl -k -X PUT https://my-gateway.apps.example.com/actuator/bound-apps/6e41a492-a17c-4b27-83b0-78635baa54b4/routes \
     -d "@./gateway-route-config.json" -H "Authorization: $(cf oauth-token)" -H "Content-Type: application/json"
     ...
     < HTTP/1.1 204 No Content
     ...
     ```

## <a id="deploy-app-to-tap"></a> Deploy the `animal-rescue` app to Tanzu Application Platform

This section describes, at a high level, the steps for deploying an `animal-rescue` app and
configuring the SCG on Tanzu Application Platform. For detailed instructions, see the `animal-rescue`
app [README](https://github.com/spring-cloud-services-samples/animal-rescue/tree/main/tanzu-application-platform)
file in GitHub.

### <a id="create-gateway-instance"></a> Create an SCG instance

To create an SCG instance:

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

### <a id="create-route-config"></a> Create a route configuration

The SCG tile service has a JSON-based API route configuration approach. There are many similarities
in terms of the configuration options available to those in Spring Cloud Gateway for Kubernetes.

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

### <a id="create-gateway-mapping"></a> Create an SCG mapping

In TAS, the SCG tile services use the Service Broker API and service-binding approach for apps to
set up container-network routing of requests to a service instance.

Spring Cloud Gateway for Kubernetes provides a `SpringCloudGatewayMapping` resource definition to
expose API routes on to an API SCG instance. For more information, see the
[Spring Cloud Gateway for Kubernetes documentation](https://docs.vmware.com/en/VMware-Spring-Cloud-Gateway-for-Kubernetes/2.1/scg-k8s/GUID-developer-resources-springcloudgatewaymapping.html).

To create an SCG mapping:

1. Create another file called `animal-rescue-backend-mapping.yaml` with the following definition:

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

1. Apply `animal-rescue-backend-mapping.yaml` to your Kubernetes cluster by running:

   ```console
   kubectl apply --filename animal-rescue-backend-mapping.yaml
   ```

   If your cluster has an ingress configured then, if `my-gateway` is accessible through
   the ingress with a fully-qualified domain name of `my-gateway.my-example-domain.com`, the
   `animal-rescue` back-end API is available in the path `my-gateway.my-example-domain.com/api/...`.

   One of the endpoints available in the sample app is `GET /api/animals`, which lists all of the
   animals available for adoption.

1. From curl, verify that this endpoint is accessible by running:

   ```console
   curl my-gateway.my-example-domain.com/api/animals
   ```