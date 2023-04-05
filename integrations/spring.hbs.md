# Deploying Spring Applications

This topic describes how to migrate Spring applications from Tanzu Application Service or
Azure Spring Apps to Tanzu Application Platform.

## <a id="spring-cloud-config"></a> Migrating from Spring Cloud Config

If your applications are currently using
[Spring Cloud Config](https://spring.io/projects/spring-cloud-config), refer to
installing Tanzu Application Platform compatible option
[Application Configuration Service](../application-configuration-service/install-app-config-service.hbs.md)
optional package.

## <a id="spring-cloud-gateway"></a> Using Spring Cloud Gateway for Kubernetes

Spring Cloud Gateway is a popular project library for creating an API Gateway built on top of the
Spring ecosystem. The OSS library is a foundational component of our Spring Cloud Gateway for
Kubernetes and Spring Cloud Gateway for VMware Tanzu Application Service commercial offerings along
with commercial-only capabilities and platform integrated operator experiences. The OSS and
commercial offerings can be used as a reverse proxy with additional API Gateway functionality to
handle request and response to upstream application services.

With Spring Cloud Gateway for Kubernetes now included as part of Tanzu Application Platform
beginning with version 1.5. This guide will help with migrating upstream applications that expose
API routes on Spring Cloud Gateway migrate to Tanzu Application Platform from Tanzu Application
Service and custom OSS implementations.

Learn more about [using Spring Cloud Gateway for Kubernetes on Tanzu Application Platform](https://docs.vmware.com/en/VMware-Spring-Cloud-Gateway-for-Kubernetes/2.0/scg-k8s/GUID-guides-tap.html).

## <a id="service-to-service"></a> Manage Service-to-Service Communication

In some cases, Spring applications running on Tanzu Application Service rely on Spring Cloud Services
for service registration and discovery.
For more information, see the
[Spring Cloud Services documentation](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/index.html).

This service is not available on Tanzu Application Platform.
A workaround is to inject configuration into your application that deactivates the
Spring Cloud DiscoveryClient and provides the necessary connection information to allow applications
to reach each other through Kubernetes internal networking.

The following sections illustrate how to make the
[Greeting](https://github.com/spring-cloud-services-samples/greeting) Spring Cloud Services sample
application run on Tanzu Application Platform.

### <a id="properties-file"></a> Create a properties file in your configuration repository

In a Git repository that will be reachable from your Run cluster, create a `greeter-dev.yaml` file as
follows:

```yaml
eureka:
  client:
    # this disables the Eureka Spring Cloud discovery client
    enabled: false
spring:
  cloud:
    discovery:
      client:
        simple:
          instances:
            greeter-messages:
            - uri: http://greeter-messages.my-apps.svc.cluster.local
```

The values under `cloud.discovery.client.simple.instances` list all the services that your application
requires. The example `greeter-dev.yaml` file illustrates how to connect to another workload running
on the same cluster.

If the other workload is of the `server` type, you can use a bare host name to connect to it if the
workload is running in the same Kubernetes namespace.

If the other workload is of the `web` type then you must provide the fully qualified host name as
shown for the greeter-messages service in the example.
You can also include external services here if they are reachable from your cluster.

### <a id="acs-resources"></a> Create Application Configuration Service (ACS) resources

On your Run cluster, create the ConfigurationSource and ConfigurationSlice resources that tell
ACS how to fetch your configuration.

The following simple example uses a public repository and no encryption.
For more information about how to connect to private repositories, encrypt configuration, and load
properties in other formats,
see the [ACS documentation](../application-configuration-service/about.hbs.md).

```yaml
---
apiVersion: "config.apps.tanzu.vmware.com/v1alpha4"
kind: ConfigurationSource
metadata:
  name: greeter-config-source
  namespace: my-apps
spec:
  backends:
    - type: git
      uri: https://github.com/your-org/your-config-repo
---
apiVersion: config.apps.tanzu.vmware.com/v1alpha4
kind: ConfigurationSlice
metadata:
  name: greeter-config
  namespace: my-apps
spec:
  configurationSource: greeter-config-source
  content:
  - greeter/dev
  configMapStrategy: applicationProperties
  interval: 10m
```

A Secret is created in the `my-apps` namespace with the name `greeter-config-####`.

### <a id="create-workloads"></a> Create application `Workload` resources

The `ConfigurationSlice` object you created in the previous section is a bindable
[Provisioned Service](https://github.com/servicebinding/spec#provisioned-service), which means it
can be used to mount the configuration to your application’s container by using a `ResourceClaim` and
`serviceClaims` in the `Workload` object.

This configuration is passed to Spring by using either the `SPRING_CONFIG_IMPORT` variable, or
if that variable is already in use, the `SPRING_CONFIG_ADDITIONAL_LOCATION` variable.

In the following example, one workload is created for the greeter-messages service, and a second
workload is created for the greeter application.
Both apps bind to the `ConfigurationSlice` to add Spring configuration:

```yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: greeter-messages
  namespace: my-apps
  labels:
    apps.tanzu.vmware.com/workload-type: web
    apps.tanzu.vmware.com/has-tests: "true"
    app.kubernetes.io/part-of: greeter
spec:
  build:
    env:
    - name: BP_JVM_VERSION
      value: "17"
    # this tells the Gradle buildpack which module to build
    - name: BP_GRADLE_BUILT_MODULE
      value: "greeter-messages"
  env:
  # the Greeting app enables basic authentication unless the
  # development profile is used
  - name: SPRING_PROFILES_ACTIVE
    value: "development"
  - name: SPRING_CONFIG_IMPORT
    value: "${SERVICE_BINDING_ROOT}/spring-properties/"
  serviceClaims:
  - name: spring-properties
    ref:
      apiVersion: services.apps.tanzu.vmware.com/v1alpha1
      kind: ResourceClaim
      name: greeter-config-claim
  source:
    git:
      url: https://github.com/spring-cloud-services-samples/greeting
      ref:
        branch: main
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: greeter
  namespace: my-apps
  labels:
    apps.tanzu.vmware.com/workload-type: web
    apps.tanzu.vmware.com/has-tests: "true"
    app.kubernetes.io/part-of: greeter
spec:
  build:
    env:
    - name: BP_JVM_VERSION
      value: "17"
    - name: BP_GRADLE_BUILT_MODULE
      value: "greeter"
  env:
  - name: SPRING_PROFILES_ACTIVE
    value: "development"
  - name: SPRING_CONFIG_IMPORT
    value: "${SERVICE_BINDING_ROOT}/spring-properties/"
  serviceClaims:
  - name: spring-properties
    ref:
      apiVersion: services.apps.tanzu.vmware.com/v1alpha1
      kind: ResourceClaim
      name: greeter-config-claim
  source:
    git:
      url: https://github.com/spring-cloud-services-samples/greeting
      ref:
        branch: main
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ResourceClaim
metadata:
  name: greeter-config-claim
  namespace: my-apps
spec:
  ref:
    apiVersion: config.apps.tanzu.vmware.com/v1alpha4
    kind: ConfigurationSlice
    name: greeter-config
```

The greeter application builds, starts up, and finds the greeter-messages URI using the simple
discovery client.
