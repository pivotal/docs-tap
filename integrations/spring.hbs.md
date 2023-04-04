# Deploying Spring Applications

This topic describes steps to migrate Spring applications to Tanzu Application Platform from
Tanzu Application Service or Azure Spring Apps.

## <a id="prereqs"></a> Prerequisites

If your applications are currently using Spring Cloud Configuration Service or
Spring Cloud Service Registry,
[install the Application Configuration Service](../application-configuration-service/install-app-config-service.hbs.md)
optional package.

## <a id="service-to-service"></a> Managing Service-to-Service Communication

In some cases, Spring applications running on Tanzu Application Service rely on Spring Cloud Services
for service registration and discovery.
For more information, see the
[Spring Cloud Services documentation](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/index.html).

Because this service is not available in Tanzu Application Platform, we recommend the following steps
to inject configuration into your application that will disable the Spring Cloud DiscoveryClient and
provide the necessary connection information to allow applications to reach each other via
Kubernetes internal networking.

The steps below illustrate how to make the
[Greeting](https://github.com/spring-cloud-services-samples/greeting) Spring Cloud Services sample
application run on Tanzu Application Platform.

### <a id="properties-file"></a> Create a properties file in your Configuration Repository

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

The values under `cloud.discovery.client.simple.instances` should list all of the services your
application requires. The example above illustrates how to connect to another Workload running on
the same cluster.

If the other workload is of type `server`, you can use a bare host name to connect
to it, provided that it is running in the same Kubernetes Namespace.

If it is of type `web` then you will need to provide the fully qualified host name as shown for the greeter-messages service above.
You may also include external services here, provided that they are reachable from your cluster.

### <a id="acs-resources"></a> Create Application Configuration Service (ACS) resources

On your Run cluster, create the ConfigurationSource and ConfigurationSlice resources that will tell
ACS how to fetch your configuration.

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

> **Note** Above is a very simple example, using a public repository and no encryption. Refer to the
> [ACS documentation](../application-configuration-service/about.hbs.md) for more details on how to
> connect to private repositories, encrypt configuration, or load properties in other formats.

You should see that a Secret has been created in the `my-apps` namespace with the name
`greeter-config-####`.

### <a id="create-workloads"></a> Create application Workload resources

The `ConfigurationSlice` object you created in the previous step is a bindable
[Provisioned Service](https://github.com/servicebinding/spec#provisioned-service), and as a result
may be used to mount the configuration to your application’s container using a `ResourceClaim` and
`serviceClaims` in the `Workload` object.

This configuration should be passed to Spring using either the `SPRING_CONFIG_IMPORT` variable, or
if that variable is already in use, the `SPRING_CONFIG_ADDITIONAL_LOCATION` variable.

In the example below, we create one workload for the greeter-messages service, and a second workload
for the greeter application. Both apps bind to the `ConfigurationSlice` to add Spring configuration:

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

You should see that the "greeter" application builds, starts up and finds the "greeter-messages" URI
using the Simple Discovery Client.
