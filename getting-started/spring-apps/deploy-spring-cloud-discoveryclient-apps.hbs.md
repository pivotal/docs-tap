# Deploy Spring Cloud DiscoveryClient applications to Tanzu Application Platform

This topic tells you how to run Spring applications that use the Spring Cloud DiscoveryClient
as workloads on Tanzu Application Platform.

## <a id="background"></a> Identify Spring Cloud DiscoveryClient applications

The Spring Cloud DiscoveryClient abstraction underlies several common libraries and services for
Spring applications to register themselves as services for other applications and to look up
connection details of registered applications. These services include the following:

- The [Service Registry](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/3.1/spring-cloud-services/GUID-service-registry-index.html)
  in the managed service tile Spring Cloud Services for VMware Tanzu supported by
  VMware Tanzu Application Service for VMs.

- The [Tanzu Service Registry](https://learn.microsoft.com/en-us/azure/spring-apps/how-to-enterprise-service-registry) in Azure Spring Apps.
  For more information about Azure Spring Apps, see the
  [Microsoft Azure documentation](https://azure.microsoft.com/en-us/products/spring-apps/).

- The [Spring Cloud Netflix](https://spring.io/projects/spring-cloud-netflix) project, which includes
  the Eureka client library and the Eureka server.

Spring applications that use these discovery services include a client dependency that implements the
Spring Cloud DiscoveryClient:

- Applications that use the Spring Cloud Services Service Registry on Tanzu Application Service typically
  include the `spring-cloud-services-starter-service-registry` dependency from the
  `io.pivotal.spring.cloud` group.
  For more information, see [Service Registry](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/3.1/spring-cloud-services/GUID-client-dependencies.html#service-registry)
  in the Spring Cloud Services documentation.

- Applications that use the Tanzu Service Registry in Azure Spring Apps or that use the
  Spring Cloud Netflix libraries typically include the `spring-cloud-starter-netflix-eureka-client`
  dependency from the `org.springframework.cloud` group.
  For more information about how to use the Tanzu Service Registry, see the
  [Microsoft Azure documentation](https://learn.microsoft.com/en-us/azure/spring-apps/how-to-enterprise-service-registry).
  For more information about how to include Eureka Client, see the
  [Spring documentation](https://docs.spring.io/spring-cloud-netflix/docs/current/reference/html/#netflix-eureka-client-starter).

Each of these client dependencies includes the
[Spring Cloud SimpleDiscoveryClient](https://docs.spring.io/spring-cloud-commons/docs/current/reference/html/#simplediscoveryclient)
from the Spring Cloud Commons project as a base dependency.
The approach in this topic uses this common dependency to configure service resolution for client applications.

## <a id="prerequisites"></a> Prerequisites

Before you can continue with the example in this topic, you must
[Install Application Configuration Service for VMware Tanzu](../../application-configuration-service/install-app-config-service.hbs.md).

In this example, the Application Configuration Service for VMware Tanzu component in
Tanzu Application Platform distributes service discovery information to client applications as Spring properties.

## <a id="example-greeting-app"></a> Example: The Greeting application

The following sections show how to run the
[Greeting](https://github.com/spring-cloud-services-samples/greeting) sample application
as a pair of workloads on Tanzu Application Platform.

### <a id="properties-file"></a> Create a properties file in your configuration repository

In a Git repository that is reachable from your Run cluster, create a `greeter-dev.yaml` file as
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

The values under `spring.cloud.discovery.client.simple.instances` list all the services that your application
requires. The example `greeter-dev.yaml` file shows how to connect to another workload running
on the same cluster.

In the example in [Create application workload resources](#create-workloads), the `greeter-messages` microservice is deployed as a workload of type  `web`, so the
discovery client configuration must use the fully qualified domain name for the service within the
Kubernetes cluster. If you instead choose to run the `greeter-messages` microservice as a workload of
type `server`, this address still works, but the `greeter` microservice can also connect
using the shorter URI `http://greeter-messages`.

### <a id="acs-resources"></a> Create Application Configuration Service resources

On your Run cluster, create the `ConfigurationSource` and `ConfigurationSlice` resources that tell
Application Configuration Service (ACS) how to fetch the discovery configuration from the
Git repository you are using.

The following example uses a public repository and no encryption.
For more information about how to connect to private repositories, encrypt configuration, and load
properties in other formats, see the
[ACS documentation](../../application-configuration-service/about.hbs.md).

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
  secretStrategy: applicationProperties
  interval: 10m
```

A Kubernetes secret is created in the `my-apps` namespace with a name starting with `greeter-config-`.

### <a id="create-workloads"></a> Create application workload resources

The `ConfigurationSlice` object you created in the previous section is a
[Provisioned Service](https://github.com/servicebinding/spec#provisioned-service).
You can use a `ResourceClaim` to claim it within the `my-apps` namespace.
You then supply the resource claim in the `serviceClaims` list in the `Workload` object to provide
the configuration inside the workload's runtime environment.

The `SPRING_CONFIG_IMPORT` variable passes this configuration to Spring.
If your application already uses that variable to apply other Spring configuration, use the
`SPRING_CONFIG_ADDITIONAL_LOCATION` variable instead.

In the following example, one workload is created for the `greeter-messages` microservice, and a second
workload is created for the greeter microservice.
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

The greeter application builds, starts up, and finds the `greeter-messages` URI using the SimpleDiscoveryClient.
